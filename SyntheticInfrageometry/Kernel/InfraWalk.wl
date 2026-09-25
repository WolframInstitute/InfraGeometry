Package["WolframInstitute`SyntheticInfrageometry`"]


(* ===================== The walk shape ===================== *)

(* a walk is a Graph, never a wrapper: a directed path graph on the position pairs {i, v} (walkGraph, Tools.wl), a closed walk a directed cycle on them (closedWalkGraph).  The engines below grow vertex sequences and hand them to walkGraph at the boundary; EdgeCount is the length, Last /@ VertexList the vertex sequence, GraphUnion the bundle, and a walk given as a bare vertex list is accepted wherever a walk is read.  InfraWalk itself survives only as the scene-DSL token InfraWalk[v1, ..., vk] at the foot of this file *)


(* ===================== FindInfraWalk ===================== *)

(* growth from a seed under the Properties rules until a stopping condition fires, the length budget kspec is spent, or no admissible step remains.  Every rule reads the window -- the last <= "InfraScale" vertices with the candidate, the whole walk at the default scale Infinity.  The default class {"Simple"} is the simple paths; "Generic" (InfraGenericQ's read per step, endpoint freeness added on the finished curve), "Immersed" and the bare class {} are opt-in.
   A rule excluding self-intersections, triple points or self-tangencies bounds the class by itself, as does "Minimizing" at scale Infinity, so kspec Infinity is legal under the default; without a bounding rule it is refused, since a stopping condition may never fire.
   kspec is UpTo[k] (at most k edges), {k} (exactly k), {lo, hi} or Infinity, never a bare integer: with no wrapper to mark it, a bare integer after p1 is the endpoint p2 of the two-point form and an Association its multiset -- on an integer-labelled substrate a budget and a vertex would otherwise collide.  A count needs an explicit kspec before it for the same reason.  When both readings fit (a vertex label that is also a {k} or {lo, hi} list) the pointed one wins *)

FindInfraWalk::badproperty = "Property `1` is not a walk rule; the rules are \"Minimizing\", \"Simple\", \"Immersed\", \"Generic\", \"Exclude\" -> species, \"Straightest\", {\"Minimal\", f}, {\"Maximal\", f}, or a predicate on the window; species are \"SelfIntersections\", \"SelfTangencies\", \"Cusps\", \"TriplePoints\".";
FindInfraWalk::badmethod   = "Method `1` is not supported.";
FindInfraWalk::unbounded   = "the walk class at scale `1` is infinite without a length bound: give a finite kspec, add \"Simple\", \"Generic\" or an \"Exclude\" of \"SelfIntersections\", \"TriplePoints\" or \"SelfTangencies\", or ask \"Minimizing\" at scale Infinity.";
FindInfraWalk::badevent    = "Stopping condition `1` is not supported; give n (stop at the n-th arrival at a visited vertex), a predicate on the walk so far, or {spec, \"Delay\" -> k}.";
FindInfraWalk::deadevent   = "the stopping condition awaits a self-intersection the Properties constraints exclude; the walk runs to its budget.";

Options[ FindInfraWalk ] = {
  "InfraScale"        -> Infinity,
  Properties          -> { "Simple" },
  "StoppingCondition" -> None,
  Method              -> Automatic
};

FindInfraWalk[ graph_Graph, p1_, opts : OptionsPattern[] ] :=
  FindInfraWalk[ graph, p1, Infinity, Automatic, opts ]

(* the pointed walk is the forward extension of the one-vertex walk at each anchor; the refusals are checked here so that they carry FindInfraWalk's name *)

FindInfraWalk[ graph_Graph, p1_,
    kspec : ( UpTo[ _Integer ] | { _Integer } | { _Integer, _Integer } | Infinity ),
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] :=
  Catch @ With[ {
      scale     = OptionValue[ FindInfraWalk, { opts }, "InfraScale" ],
      rules     = OptionValue[ FindInfraWalk, { opts }, Properties ],
      condition = OptionValue[ FindInfraWalk, { opts }, "StoppingCondition" ],
      spec      = Replace[ OptionValue[ FindInfraWalk, { opts }, Method ], Automatic :> If[ count === All, "Exhaustive", "Greedy" ] ] },
    { base     = NestWhile[ First, condition, MatchQ[ { _, "Delay" -> _Integer?NonNegative } ] ],
      excluded = Union @@ Replace[ rules, {
        "Simple"   -> { "SelfIntersections" },
        "Immersed" -> { "Cusps" },
        "Generic"  -> { "Cusps", "SelfTangencies", "TriplePoints" },
        ( "Exclude" -> s_ ) :> Flatten @ { s },
        _ -> { } }, { 1 } ] },
    If[ ! ( base === None || ( IntegerQ[ base ] && base >= 1 ) || ! MatchQ[ base, None | _Integer | _List | _String | _Rule ] ),
      Message[ FindInfraWalk::badevent, base ]; Throw[ $Failed ] ];
    Scan[ rule |-> If[ MatchQ[ rule, _String | { _String, ___ } | _Rule ] && ! MatchQ[ rule,
          "Minimizing" | "Simple" | "Immersed" | "Generic" | "Straightest" | { "Minimal", _ } | { "Maximal", _ } |
          ( "Exclude" -> ( "SelfIntersections" | "SelfTangencies" | "Cusps" | "TriplePoints" |
              { ( "SelfIntersections" | "SelfTangencies" | "Cusps" | "TriplePoints" ) .. } ) ) ],
        Message[ FindInfraWalk::badproperty, rule ]; Throw[ $Failed ] ], rules ];
    If[ IntegerQ[ base ] &&
        ( MemberQ[ excluded, "SelfIntersections" ] || ( scale === Infinity && MemberQ[ rules, "Minimizing" ] ) ),
      Message[ FindInfraWalk::deadevent ] ];
    (* a rule excluding self-intersections, triple points or self-tangencies bounds the class, as does "Minimizing" on the whole walk; a local rule alone leaves it infinite, since a walk can wind a long cycle forever *)
    If[ kspec === Infinity && ! ( ( scale === Infinity && MemberQ[ rules, "Minimizing" ] ) ||
          IntersectingQ[ excluded, { "SelfIntersections", "TriplePoints", "SelfTangencies" } ] ),
      Message[ FindInfraWalk::unbounded, scale ]; Throw[ $Failed ] ];
    If[ ! MatchQ[ Replace[ spec, { m_String, ___ } :> m ], "Exhaustive" | "Greedy" | "RandomGreedy" ],
      Message[ FindInfraWalk::badmethod, spec ]; Throw[ $Failed ] ];
    With[ { walks = DeleteDuplicates @ Catenate[
        If[ VertexQ[ graph, # ],
          Quiet[ ExtendInfraWalk[ graph, { # }, kspec, Replace[ count, { Automatic -> UpTo[ 1 ], n_Integer :> UpTo[ n ] } ],
            "InfraScale" -> scale, Properties -> rules, "StoppingCondition" -> condition,
            Method -> OptionValue[ FindInfraWalk, { opts }, Method ], "Direction" -> "Forward" ], ExtendInfraWalk::deadevent ],
          { } ] & /@ Replace[ p1, { fam_Association :> Keys @ fam, x_ :> { x } } ] ] },
      Switch[ count,
        Automatic, First[ walks, { } ],
        All,       walks,
        _UpTo,     Take[ walks, count ],
        _,         If[ Length @ walks < count, $Failed, Take[ walks, count ] ] ] ] ]

(* the walks from p1 ending at p2.  The branch may stop at its first arrival at p2 exactly when no accepted walk revisits its endpoint -- no self-intersections, "Generic", or "Minimizing" on the whole walk; a finite-scale rule lets a walk pass through p2 and return *)

FindInfraWalk[ graph_Graph, p1_, p2_,
    kspec : ( UpTo[ _Integer ] | { _Integer } | { _Integer, _Integer } | Infinity ) : Infinity,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    VertexQ[ graph, p2 ] || AssociationQ[ p2 ] :=
  With[ { cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ] },
    { results = ( { q1, q2 } |-> If[ q1 === q2, { },
        Module[ { cands, keepQ, stepFn, dlFn, pick, ev, state, acc = { }, frontier, completed = { }, extended, descend },
          Catch @ With[ {
              scale      = OptionValue[ FindInfraWalk, { opts }, "InfraScale" ],
              rules      = OptionValue[ FindInfraWalk, { opts }, Properties ],
              condition  = OptionValue[ FindInfraWalk, { opts }, "StoppingCondition" ],
              methodSpec = Replace[ OptionValue[ FindInfraWalk, { opts }, Method ],
                             Automatic :> If[ count === All, "Exhaustive", "Greedy" ] ] },
            { base       = NestWhile[ First, condition, MatchQ[ { _, "Delay" -> _Integer?NonNegative } ] ],
              methodHead = Replace[ methodSpec, { m_String, ___ } :> m ],
              pruning    = Lookup[ Replace[ methodSpec, { { _String, o___ } :> { o }, _ -> { } } ], "Pruning", Infinity ],
              kmax       = Replace[ kspec, { { _, hi_ } :> hi, { k_ } :> k, UpTo[ k_ ] :> k } ],
              lengthQ    = Replace[ kspec, {
                Infinity     :> ( True & ),
                UpTo[ k_ ]   :> ( Length[ # ] - 1 <= k & ),
                { k_ }       :> ( Length[ # ] - 1 == k & ),
                { lo_, hi_ } :> ( lo <= Length[ # ] - 1 <= hi & ) } ],
              speciesOf  = rule |-> Replace[ rule, {
                "Simple"   -> { "SelfIntersections" },
                "Immersed" -> { "Cusps" },
                "Generic"  -> { "Cusps", "SelfTangencies", "TriplePoints" },
                ( "Exclude" -> s_ ) :> Flatten @ { s },
                _ -> { } } ],
              window     = walk |-> If[ scale === Infinity, walk, Take[ walk, -Min[ scale, Length @ walk ] ] ] },
            { excluded = Union @@ ( speciesOf /@ rules ),
              events   = With[ { entries = Which[
                    base === None,                  { },
                    IntegerQ[ base ] && base >= 1,  { { "SelfIntersection", 0, base } },
                    ! MatchQ[ base, None | _Integer | _List | _String | _Rule ], { { base, 0, 1 } },
                    True, ( Message[ FindInfraWalk::badevent, base ]; Throw[ $Failed ] ) ] },
                If[ MatchQ[ condition, { _, "Delay" -> _Integer?NonNegative } ],
                  { #[[ 1 ]], condition[[ 2, 2 ]], #[[ 3 ]] } & /@ entries, entries ] ],
              species  = Map[ rule |-> Switch[ rule,
                  "Minimizing" | "Simple" | "Immersed" | "Generic" |
                    ( "Exclude" -> ( "SelfIntersections" | "SelfTangencies" | "Cusps" | "TriplePoints" |
                        { ( "SelfIntersections" | "SelfTangencies" | "Cusps" | "TriplePoints" ) .. } ) ),
                                                                         "Constraint",
                  "Straightest" | { "Minimal", _ } | { "Maximal", _ },  "Selector",
                  _String | { _String, ___ } | _Rule,
                    ( Message[ FindInfraWalk::badproperty, rule ]; Throw[ $Failed ] ),
                  _,                                                     "Constraint" ],
                rules ] },
            { checks = Map[ rule |-> If[ rule === "Minimizing",
                  { walk, w } |-> GraphDistance[ graph, First @ window @ walk, w ] == Length @ window @ walk,
                  If[ speciesOf @ rule === { },
                    { walk, w } |-> rule @ Append[ window @ walk, w ],
                    With[ { sps = speciesOf @ rule }, { walk, w } |-> AllTrue[ sps, sp |-> Switch[ sp,
                      "SelfIntersections", ! MemberQ[ walk, w ],
                      "Cusps",             Length[ walk ] < 2 || walk[[ -2 ]] =!= w,
                      "TriplePoints",      Count[ walk, w ] <= 1,
                      (* a repeated edge opens a repeated arc unless it is the mirror of a cusp, the stretch between the two traversals then being a palindrome *)
                      "SelfTangencies",    NoneTrue[ Range[ Length[ walk ] - 1 ],
                        p |-> ( walk[[ p ]] === Last[ walk ] && walk[[ p + 1 ]] === w ) ||
                          ( walk[[ p ]] === w && walk[[ p + 1 ]] === Last[ walk ] && ! PalindromeQ[ walk[[ p + 1 ;; ]] ] ) ] ] ] ] ] ],
                Pick[ rules, species, "Constraint" ] ],
              selectors = Map[ rule |-> Switch[ rule,
                  "Straightest",
                    With[ { vidx = AssociationThread[ VertexList @ graph, Range @ VertexCount @ graph ],
                            dmat = GraphDistanceMatrix @ graph },
                      { walk, candidates } |-> With[ { historyIdx = vidx /@ Reverse @ Most @ window @ walk },
                        If[ candidates === { } || historyIdx === { }, candidates,
                          MaximalBy[ candidates, w |-> dmat[[ historyIdx, vidx[ w ] ]] ] ] ] ],
                  { "Minimal", _ },
                    { walk, candidates } |-> If[ candidates === { }, candidates,
                      MinimalBy[ candidates, w |-> Last[ rule ] @ Append[ window @ walk, w ] ] ],
                  { "Maximal", _ },
                    { walk, candidates } |-> If[ candidates === { }, candidates,
                      MaximalBy[ candidates, w |-> Last[ rule ] @ Append[ window @ walk, w ] ] ] ],
                Pick[ rules, species, "Selector" ] ],
              terminal = MemberQ[ excluded, "SelfIntersections" ] || MemberQ[ rules, "Generic" ] ||
                ( scale === Infinity && MemberQ[ rules, "Minimizing" ] ),
              prunedOf = paths |-> Which[
                pruning === Infinity, paths,
                IntegerQ @ pruning,   If[ Length @ paths <= pruning, paths, RandomSample[ paths, pruning ] ],
                paths === { },        { },
                True, With[ { survivors = Select[ paths, RandomReal[ ] < pruning & ] },
                  If[ survivors === { }, RandomSample[ paths, 1 ], survivors ] ] ] },
            cands = { g, walk } |-> Fold[ #2[ walk, #1 ] &,
              Select[ AdjacencyList[ g, Last @ walk ], w |-> AllTrue[ checks, #[ walk, w ] & ] ], selectors ];
            (* endpoint freeness is the one census condition the moving tip cannot prune; checked on the finished walk *)
            keepQ = If[ MemberQ[ rules, "Generic" ],
              w |-> lengthQ[ w ] && Count[ w, First @ w ] === 1 && Count[ w, Last @ w ] === 1,
              lengthQ ];
            pick = If[ methodHead === "RandomGreedy", RandomSample, Identity ];
            ev = events;
            state[ walk_ ] := state[ walk ] =
              If[ Length[ walk ] < 2, { ev[[ All, 3 ]], Infinity },
                With[ { prev = state @ Most @ walk },
                  { fired = MapThread[ { rem, entry } |-> Boole[ rem > 0 &&
                        If[ First @ entry === "SelfIntersection", Count[ walk, Last @ walk ] >= 2, TrueQ[ First[ entry ] @ walk ] ] ],
                      { First @ prev, ev } ] },
                  { rem = First @ prev - fired },
                  { rem, Min @ Prepend[
                      MapThread[ If[ #1 === 1 && #2 === 0, Length[ walk ] - 1 + #3[[ 2 ]], Infinity ] &, { fired, rem, ev } ],
                      Last @ prev ] } ] ];
            dlFn = walk |-> Last @ state @ walk;
            stepFn = If[ ev === { }, cands, { g, walk } |-> If[ Length[ walk ] - 1 >= dlFn @ walk, { }, cands[ g, walk ] ] ];
            If[ MatchQ[ events, { { "SelfIntersection", _, _ } } ] &&
                ( MemberQ[ excluded, "SelfIntersections" ] || ( scale === Infinity && MemberQ[ rules, "Minimizing" ] ) ),
              Message[ FindInfraWalk::deadevent ] ];
            If[ kmax === Infinity && ! ( ( scale === Infinity && MemberQ[ rules, "Minimizing" ] ) ||
                  IntersectingQ[ excluded, { "SelfIntersections", "TriplePoints", "SelfTangencies" } ] ),
              Message[ FindInfraWalk::unbounded, scale ]; Throw[ $Failed ] ];
            Which[
              (* a geodesic is simple, hence immersed, generic, and minimizing in every window at every scale: the canonical count-less witness, which is what "Greedy" -- and so the default -- means on this signature *)
              methodHead === "Greedy" && kspec === Infinity && cap === 1 && events === { } &&
                AllTrue[ rules, MatchQ[ #, "Minimizing" | "Simple" | "Immersed" | "Generic" | ( "Exclude" -> _ ) ] & ],
                Replace[ FindShortestPath[ graph, q1, q2 ], { { } -> { }, path_ :> { path } } ],
              (* breadth-first over the candidate frontier, "Pruning" capping it per layer; an early stop on the count is unsound when a completion can still be rejected, by an exact or range length or by the endpoint check *)
              MatchQ[ methodHead, "Exhaustive" | "Greedy" | "RandomGreedy" ] &&
                ( ! VertexQ[ graph, q1 ] || ! VertexQ[ graph, q2 ] || GraphDistance[ graph, q1, q2 ] === Infinity ), { },
              methodHead === "Exhaustive",
                With[ { limit = If[ MatchQ[ kspec, { _Integer } | { _Integer, _Integer } ] || MemberQ[ rules, "Generic" ],
                          Infinity, cap ] },
                  frontier = { { q1 } };
                  While[ frontier =!= { } && Length[ completed ] < limit,
                    extended = Flatten[ ( path |-> ( Append[ path, # ] & ) /@
                        If[ Length[ path ] - 1 >= kmax, { }, stepFn[ graph, path ] ] ) /@ frontier, 1 ];
                    completed = Join[ completed, Select[ extended, Last[ # ] === q2 & ] ];
                    frontier = prunedOf @ If[ terminal, Select[ extended, Last[ # ] =!= q2 & ], extended ] ];
                  Select[ Take[ completed, UpTo[ limit ] ], keepQ ] ],
              (* depth-first with backtracking, the first cap completions: complete, so a finite count is exact *)
              methodHead === "Greedy" || methodHead === "RandomGreedy",
                descend[ walk_ ] := (
                  If[ Last @ walk === q2 && keepQ @ walk,
                    AppendTo[ acc, walk ];
                    If[ Length @ acc >= cap, Throw[ acc, descend ] ] ];
                  If[ ( ! terminal || Last @ walk =!= q2 ) && Length[ walk ] - 1 < kmax,
                    Scan[ descend[ Append[ walk, # ] ] &, pick @ stepFn[ graph, walk ] ] ] );
                Catch[ descend[ { q1 } ]; acc, descend ],
              True,
                Message[ FindInfraWalk::badmethod, methodSpec ]; $Failed ] ] ] ] ) @@@
      Tuples[ Replace[ #, { fam_Association :> Keys @ fam, x_ :> { x } } ] & /@ { p1, p2 } ] },
    If[ MemberQ[ results, $Failed ], $Failed,
      With[ { walks = DeleteDuplicates[ ( seq |-> PathGraph[ MapIndexed[ { First @ #2, #1 } &, seq ], DirectedEdges -> True ] ) /@
                DeleteDuplicates @ Catenate @ results ] },
        Switch[ count,
          Automatic, First[ walks, { } ],
          All,       walks,
          _UpTo,     Take[ walks, count ],
          _,         If[ Length @ walks < count, $Failed, Take[ walks, count ] ] ] ] ] ]


(* ===================== FindInfraGeodesic ===================== *)

(* a geodesic at infra-scale r: a walk in which every window -- the last r vertices together with the next one -- is a shortest path, any further rule holding on the window too.  The class degenerates at both ends of the ladder: r = 1 asks only for adjacency, r = Infinity for a segment.  The wrapper is FindInfraWalk at "InfraScale" -> r with "Minimizing" always among the rules -- the name promises the rule -- so the bare class at a finite scale is FindInfraWalk with Properties -> { }.
   Candidates are local, so p2 never enters a window: a selector may steer the walk away from p2 and leave no realisation, which is the honest answer for an observer whose horizon is r.  FindInfraSegment's geodesic DAG is the target-aware optimisation of the constraint-only case r = Infinity.
   The scale is a bare integer, so on an integer-labelled substrate [g, p1, x, ...] reads x as the scale when the rest parses as kspec and count, and as p2 otherwise -- the pointed reading wins a tie, which happens only at [g, p1, p2, Infinity]; give kspec explicitly there *)

Options[ FindInfraGeodesic ] = {
  Properties          -> { },
  "StoppingCondition" -> None,
  Method              -> Automatic
};

FindInfraGeodesic[ graph_Graph, p1_, scale : ( _Integer | Infinity ), opts : OptionsPattern[] ] :=
  FindInfraGeodesic[ graph, p1, scale, Infinity, Automatic, opts ]

FindInfraGeodesic[ graph_Graph, p1_,
    scale : ( _Integer | Infinity ),
    kspec : ( UpTo[ _Integer ] | { _Integer } | { _Integer, _Integer } | Infinity ),
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] :=
  FindInfraWalk[ graph, p1, kspec, count, "InfraScale" -> scale,
    Properties -> DeleteDuplicates @ Prepend[ OptionValue[ FindInfraGeodesic, { opts }, Properties ], "Minimizing" ],
    Sequence @@ FilterRules[ { opts }, Except[ Properties ] ] ]

FindInfraGeodesic[ graph_Graph, p1_, p2_,
    scale : ( _Integer | Infinity ),
    kspec : ( UpTo[ _Integer ] | { _Integer } | { _Integer, _Integer } | Infinity ) : Infinity,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    VertexQ[ graph, p2 ] || AssociationQ[ p2 ] :=
  FindInfraWalk[ graph, p1, p2, kspec, count, "InfraScale" -> scale,
    Properties -> DeleteDuplicates @ Prepend[ OptionValue[ FindInfraGeodesic, { opts }, Properties ], "Minimizing" ],
    Sequence @@ FilterRules[ { opts }, Except[ Properties ] ] ]


(* ===================== InfraGeodesicQ ===================== *)

(* every window of r consecutive vertices with the next one is a shortest path; the ladder is exact at both ends: r = 1 is InfraWalkQ, r = Infinity is InfraSegmentQ *)

InfraGeodesicQ[ graph_Graph, ws : { __Graph }, scale : ( _Integer | Infinity ) : Infinity ] :=
  AllTrue[ ws, InfraGeodesicQ[ graph, #, scale ] & ]

InfraGeodesicQ[ graph_Graph, w_Graph, scale : ( _Integer | Infinity ) : Infinity ] :=
  With[ { vs = VertexList @ w },
    { spelled = AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
      scan = v |-> Reap[ DepthFirstScan[ w, v, { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] },
    AllTrue[
      Which[
        ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w,
          { If[ First @ # === Last @ #, #, Append[ #, First @ # ] ] & @
              If[ spelled, Last /@ SortBy[ vs, First ], scan @ First @ vs ] },
        EdgeCount @ w == 0, List /@ If[ spelled, Last /@ vs, vs ],
        spelled,            { Last /@ SortBy[ vs, First ] },
        DirectedGraphQ @ w,
          Catenate @ Catenate @ Table[ FindPath[ w, s, t, Infinity, All ],
            { s, Select[ vs, VertexInDegree[ w, # ] == 0 & ] }, { t, Select[ vs, VertexOutDegree[ w, # ] == 0 & ] } ],
        True, { scan @ SelectFirst[ vs, VertexDegree[ w, # ] == 1 &, First @ vs ] } ],
      InfraGeodesicQ[ graph, #, scale ] & ] ]

InfraGeodesicQ[ graph_Graph, walk_List,
    scale : ( _Integer | Infinity ) : Infinity ] /; Length[ walk ] >= 2 :=
  InfraWalkQ[ graph, walk ] &&
  AllTrue[ Range[ 2, Length[ walk ] ],
    i |-> With[ { j = If[ scale === Infinity, 1, Max[ 1, i - scale ] ] },
      GraphDistance[ graph, walk[[ j ]], walk[[ i ]] ] == i - j ] ]

InfraGeodesicQ[ _Graph, walk_List, ___ ] /; Length[ walk ] < 2 := False


(* ===================== WalkSingularities ===================== *)

(* an invariant of the vertex sequence: the coincidences v_i === v_j, the maximal repeated arcs, and the mirrored blocks v_{i-t} === v_{i+t} around an apex.  A closed walk -- a cycle graph -- is read on its cyclic core, an interval lifted past m being read mod m; a substrate path or cycle graph never repeats a vertex and so has the empty census *)

WalkSingularities[ ws : { __Graph } ] := WalkSingularities /@ ws

WalkSingularities[ w_Graph ] :=
  If[ closedWalkQ @ w, cyclicCensus @ walkSequence @ w, openCensus @ walkSequence @ w ]

WalkSingularities[ walk_List ] := openCensus @ walk


(* direct blocks v_i === v_{i+d} and inverse blocks v_i === v_{s-i} on maximal runs of two or more positions; an inverse run reaching the apex s/2 is the mirror of a cusp, not a repeated arc *)

openCensus[ walk_List ] := With[
  { m = Length @ walk },
  { traversals = Join[
      Catenate @ Table[
        { #, # + d } & /@
          Select[ maximalRuns @ Select[ Range[ m - d ], i |-> walk[[ i ]] === walk[[ i + d ]] ],
            run |-> Length[ run ] >= 2 ],
        { d, 2, m - 2 } ],
      Catenate @ Table[
        { #, Reverse[ s - # ] } & /@
          Select[ maximalRuns @ Select[ Range[ Max[ 1, s - m ], Floor[ ( s - 1 ) / 2 ] ],
              i |-> walk[[ i ]] === walk[[ s - i ]] ],
            run |-> Length[ run ] >= 2 && ! ( EvenQ[ s ] && Last[ run ] == s / 2 - 1 ) ],
        { s, 3, 2 m - 1 } ] ] },
  <|
    "SelfIntersections" -> Select[ Values @ PositionIndex @ walk, Length[ # ] >= 2 & ],
    "SelfTangencies" -> arcGroups[ walk, Catenate @ traversals ],
    "Cusps" -> ( i |-> With[
        { k = LengthWhile[ Range @ Min[ i - 1, m - i ], t |-> walk[[ i - t ]] === walk[[ i + t ]] ] },
        Range[ i - k, i + k ] ] ) /@
      Select[ Range[ 2, m - 1 ], i |-> walk[[ i - 1 ]] === walk[[ i + 1 ]] ]
  |> ]


(* a core of minimal period p < m is the m/p fold cover of its period loop: one repeated arc tiling the cycle; a cyclic inverse run touching an apex of the reflection i -> s - i is a cusp *)

cyclicCensus[ core_List ] := With[
  { m = Length @ core },
  { cyc = i |-> Mod[ i - 1, m ] + 1,
    period = SelectFirst[ Divisors @ m, d |-> core === RotateLeft[ core, d ] ] },
  { traversals = Join[
      If[ period < m, { Partition[ Range @ m, period ] }, { } ],
      Catenate @ Table[
        { First[ # ] + Range[ 0, Length[ # ] - 1 ], cyc[ First[ # ] + d ] + Range[ 0, Length[ # ] - 1 ] } & /@
          Select[ cyclicRuns[ Select[ Range @ m, i |-> core[[ i ]] === core[[ cyc[ i + d ] ]] ], m ],
            run |-> 2 <= Length[ run ] < m ],
        { d, 2, Floor[ m / 2 ] } ],
      Catenate @ Table[
        { First[ # ] + Range[ 0, Length[ # ] - 1 ], cyc[ s - Last[ # ] ] + Range[ 0, Length[ # ] - 1 ] } & /@
          Select[ cyclicRuns[
              Select[ Range @ m, i |-> cyc[ s - i ] =!= i && core[[ i ]] === core[[ cyc[ s - i ] ]] ], m ],
            run |-> Length[ run ] >= 2 &&
              NoneTrue[ run, i |-> cyc[ s - i ] === cyc[ i + 2 ] || cyc[ s - i ] === cyc[ i - 2 ] ] ],
        { s, 0, m - 1 } ] ] },
  <|
    "SelfIntersections" -> Select[ Values @ PositionIndex @ core, Length[ # ] >= 2 & ],
    "SelfTangencies" -> arcGroups[ core, Catenate @ traversals ],
    "Cusps" -> ( i |-> With[
        { k = LengthWhile[ Range @ Floor[ ( m - 1 ) / 2 ],
            t |-> core[[ cyc[ i - t ] ]] === core[[ cyc[ i + t ] ]] ] },
        cyc /@ Range[ i - k, i + k ] ] ) /@
      Select[ Range @ m, i |-> core[[ cyc[ i - 1 ] ]] === core[[ cyc[ i + 1 ] ]] ]
  |> ]


(* the traversals of one arc form a group of oriented intervals, the first ascending and each later one descending when it runs the arc backwards *)

arcGroups[ core_List, traversals_List ] := With[
  { m = Length @ core },
  { keyed = ( pos |-> With[ { arc = core[[ Mod[ pos - 1, m ] + 1 ]] },
        { key = First @ Sort @ { arc, Reverse @ arc } },
        key -> { pos, arc === key } ] ) /@ DeleteDuplicates @ traversals },
  Values @ GroupBy[ keyed, First -> Last,
    ps |-> With[ { sorted = SortBy[ DeleteDuplicates @ ps, First @ First @ # & ] },
      { flip = ! Last @ First @ sorted },
      ( { pos, direct } |-> If[ Xor[ direct, flip ],
          { First @ pos, Last @ pos }, { Last @ pos, First @ pos } ] ) @@@ sorted ] ] ]


maximalRuns[ set_List ] := Split[ Sort @ set, #2 == #1 + 1 & ]


cyclicRuns[ set_List, m_ ] := With[
  { runs = maximalRuns @ set },
  If[ Length[ runs ] >= 2 && First[ First @ runs ] == 1 && Last[ Last @ runs ] == m,
    Prepend[ runs[[ 2 ;; -2 ]], Join[ Last @ runs, First @ runs ] ],
    runs ] ]


(* ===================== InfraImmersedQ / InfraGenericQ ===================== *)

(* immersed walk: a walk with no cusp *)

InfraImmersedQ[ graph_Graph, ws : { __Graph } ] := AllTrue[ ws, InfraImmersedQ[ graph, # ] & ]

InfraImmersedQ[ graph_Graph, w_Graph ] /; closedWalkQ[ w ] :=
  With[ { core = walkSequence @ w },
    InfraWalkQ[ graph, closeWalk @ core ] && cyclicCensus[ core ][ "Cusps" ] === { } ]

InfraImmersedQ[ graph_Graph, w_Graph ] := AllTrue[ walkRealisations @ w, InfraImmersedQ[ graph, # ] & ]

InfraImmersedQ[ graph_Graph, walk_List ] :=
  InfraWalkQ[ graph, walk ] && openCensus[ walk ][ "Cusps" ] === { }


(* generic walk: immersed and in general position -- no repeated arc, every self-intersection a double point, the endpoints of an open walk off the curve *)

InfraGenericQ[ graph_Graph, ws : { __Graph } ] := AllTrue[ ws, InfraGenericQ[ graph, # ] & ]

InfraGenericQ[ graph_Graph, w_Graph ] /; closedWalkQ[ w ] :=
  With[ { core = walkSequence @ w },
    InfraWalkQ[ graph, closeWalk @ core ] &&
    With[ { c = cyclicCensus @ core },
      c[ "Cusps" ] === { } && c[ "SelfTangencies" ] === { } &&
      AllTrue[ c[ "SelfIntersections" ], Length[ # ] == 2 & ] ] ]

InfraGenericQ[ graph_Graph, w_Graph ] := AllTrue[ walkRealisations @ w, InfraGenericQ[ graph, # ] & ]

InfraGenericQ[ graph_Graph, walk_List ] :=
  InfraWalkQ[ graph, walk ] &&
  With[ { c = openCensus @ walk },
    c[ "Cusps" ] === { } && c[ "SelfTangencies" ] === { } &&
    AllTrue[ c[ "SelfIntersections" ], Length[ # ] == 2 && FreeQ[ #, 1 | Length @ walk ] & ] ]


(* ===================== InfraWalkCrossingQ ===================== *)

(* a double visit of v is a crossing at scale r when each pass through B(v, r-1), continued along its radial arcs through the shell {r, r+1}, separates the other pass's exits on that shell.  Two 0-spheres link only in S^1: on a surface-like substrate this is the interleaving of the two germ pairs, and where the shell stays connected after a radial cut nothing is a crossing *)

InfraWalkCrossingQ[ graph_Graph, ws : { __Graph }, at_, r_Integer ] :=
  AllTrue[ ws, InfraWalkCrossingQ[ graph, #, at, r ] & ]

InfraWalkCrossingQ[ graph_Graph, w_Graph, at_, r_Integer ] /; closedWalkQ[ w ] :=
  walkCrossingQ[ graph, walkSequence @ w, True, at, r ]

InfraWalkCrossingQ[ graph_Graph, w_Graph, at_, r_Integer ] :=
  AllTrue[ walkRealisations @ w, InfraWalkCrossingQ[ graph, #, at, r ] & ]

InfraWalkCrossingQ[ graph_Graph, walk_List, at_, r_Integer ] :=
  walkCrossingQ[ graph, walk, False, at, r ]


(* the ambient point names the double visit; a vertex visited once or more than twice is no crossing.  A vertex label that is itself a pair of integers is written <| v -> 1 |>, the position pair winning the tie *)

walkCrossingQ[ graph_, core_List, closedQ_, at : Except[ { _Integer, _Integer } ], r_ ] :=
  With[ { ps = Select[ Range @ Length @ core, core[[ # ]] === Replace[ at, fam_Association :> First @ Keys @ fam ] & ] },
    Length[ ps ] == 2 && walkCrossingQ[ graph, core, closedQ, ps, r ] ]

walkCrossingQ[ graph_, core_List, closedQ_, { i_Integer, j_Integer }, r_ ] := With[
  { m = Length @ core, v = core[[ i ]] },
  { localG = NeighborhoodGraph[ graph, { v }, r + 1 ] },
  { d = AssociationThread[ VertexList @ localG, GraphDistance[ localG, v ] ] },
  { at = t |-> core[[ Mod[ t - 1, m ] + 1 ]],
    dist = t |-> If[ closedQ || 1 <= t <= m,
      Lookup[ d, Key @ core[[ Mod[ t - 1, m ] + 1 ]], Infinity ], Missing[ ] ] },
  (* the excursion through B(v, r-1) around a visit, and the radial arc out of an exit: the walk while it sits on the sphere, then its first step onto the outer ring -- Missing when it turns back or ends first *)
  { excursion = p |-> {
      p - LengthWhile[ Range[ p - 1, p - m, -1 ], t |-> TrueQ[ dist[ t ] <= r - 1 ] ],
      p + LengthWhile[ Range[ p + 1, p + m ], t |-> TrueQ[ dist[ t ] <= r - 1 ] ] },
    radial = { start, step } |-> With[
      { ps = NestWhileList[ # + step &, start, dist[ # ] === r &, 1, m ] },
      If[ dist[ Last @ ps ] === r + 1, at /@ ps, Missing[ ] ] ] },
  { ei = excursion @ i, ej = excursion @ j },
  { exitsI = { First[ ei ] - 1, Last[ ei ] + 1 }, exitsJ = { First[ ej ] - 1, Last[ ej ] + 1 } },
  { band = Subgraph[ localG, Select[ VertexList @ localG, r <= d[ # ] <= r + 1 & ] ],
    cutI = { radial[ First @ exitsI, -1 ], radial[ Last @ exitsI, 1 ] },
    cutJ = { radial[ First @ exitsJ, -1 ], radial[ Last @ exitsJ, 1 ] } },
  core[[ j ]] === v &&
  ! IntersectingQ[ Mod[ Range @@ ei - 1, m ] + 1, Mod[ Range @@ ej - 1, m ] + 1 ] &&
  AllTrue[ Join[ exitsI, exitsJ ], dist[ # ] === r & ] &&
  FreeQ[ { cutI, cutJ }, _Missing ] &&
  SeparatesQ[ band, DeleteDuplicates[ Join @@ cutJ ], at @ First @ exitsI, at @ Last @ exitsI ] &&
  SeparatesQ[ band, DeleteDuplicates[ Join @@ cutI ], at @ First @ exitsJ, at @ Last @ exitsJ ] ]


(* ===================== ExtendInfraWalk ===================== *)

(* continues a seed walk under the Properties rules, each read on the window of the last <= "InfraScale" vertices: Find seeds with points and owns the two-point sugar, Extend seeds with walks and owns "Direction".  kspec is the extension budget, in added edges per growing side -- UpTo[k], {k}, {lo, hi} or Infinity, as for FindInfraWalk -- and is mandatory-finite whenever the class is infinite.  The seed is a vertex list, a walk graph, or a bundle of either.
   "BothSides" offers three moves per outer step -- both sides, back only, front only, joint first so a greedy witness keeps the synchronous trajectory -- and re-checks the joined step against the monotone whole-walk constraints its sides cannot see alone, so the walk freezes only when no side can move and the class is the whole two-sided extension class.  Its budget is Max[la, ra], the edges added on the longer side, invariant under the order the moves are taken.  Stopping conditions replay over the seed, so a deadline may already sit inside it and the seed come back unextended; a two-ended walk has no single tip for the event clock, so they require "Forward" or "Backward". *)

ExtendInfraWalk::badproperty  = "Property `1` is not a walk rule; the rules are \"Minimizing\", \"Simple\", \"Immersed\", \"Generic\", \"Exclude\" -> species, \"Straightest\", {\"Minimal\", f}, {\"Maximal\", f}, or a predicate on the window; species are \"SelfIntersections\", \"SelfTangencies\", \"Cusps\", \"TriplePoints\".";
ExtendInfraWalk::badmethod    = "Method `1` is not supported.";
ExtendInfraWalk::baddirection = "Direction `1` is not supported; give \"Forward\", \"Backward\" or \"BothSides\".";
ExtendInfraWalk::badevent     = "Stopping condition `1` is not supported; give n (stop at the n-th arrival at a visited vertex), a predicate on the walk so far, or {spec, \"Delay\" -> k}.";
ExtendInfraWalk::deadevent    = "the stopping condition awaits a self-intersection the Properties constraints exclude; the walk runs to its budget.";
ExtendInfraWalk::eventsided   = "stopping conditions read the walk at a single growing tip; extend with \"Direction\" -> \"Forward\" or \"Backward\".";
ExtendInfraWalk::unbounded    = "the extension class at scale `1` is infinite without a length bound: give a finite kspec, add \"Simple\", \"Generic\" or an \"Exclude\" of \"SelfIntersections\", \"TriplePoints\" or \"SelfTangencies\", or ask \"Minimizing\" at scale Infinity.";

Options[ ExtendInfraWalk ] = {
  "InfraScale"        -> Infinity,
  Properties          -> { "Simple" },
  "StoppingCondition" -> None,
  Method              -> Automatic,
  "Direction"         -> "BothSides"
};

(* the closures live in Module locals and never in the RHS of a recursive definition: a pattern variable of the same name as a closure's own parameter would rewrite it on substitution *)

ExtendInfraWalk[ graph_Graph, seed_,
    kspec : ( UpTo[ _Integer ] | { _Integer } | { _Integer, _Integer } | Infinity ) : Infinity,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] :=
  With[ {
      cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ],
      walksOf = w |-> With[ { vs = VertexList @ w },
        { spelled = AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
          scan = v |-> Reap[ DepthFirstScan[ w, v, { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] },
        Which[
          ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w,
            { If[ First @ # === Last @ #, #, Append[ #, First @ # ] ] & @
                If[ spelled, Last /@ SortBy[ vs, First ], scan @ First @ vs ] },
          EdgeCount @ w == 0, List /@ If[ spelled, Last /@ vs, vs ],
          spelled,            { Last /@ SortBy[ vs, First ] },
          DirectedGraphQ @ w,
            Catenate @ Catenate @ Table[ FindPath[ w, s, t, Infinity, All ],
              { s, Select[ vs, VertexInDegree[ w, # ] == 0 & ] }, { t, Select[ vs, VertexOutDegree[ w, # ] == 0 & ] } ],
          True, { scan @ SelectFirst[ vs, VertexDegree[ w, # ] == 1 &, First @ vs ] } ] ] },
    { seedWalks = Which[
        AssociationQ @ seed,         Keys @ seed,
        GraphQ @ seed,               walksOf @ seed,
        MatchQ[ seed, { __Graph } ], Catenate[ walksOf /@ seed ],
        seed === { },                { },
        MatchQ[ seed, ( InfraSegment | InfraRay | InfraLine | InfraCircle | InfraArc )[ _Association ] ],
          Catenate[ walksOf /@ Normal @ seed ],
        True,                        { seed } ] },
    { results = Map[ walk0 |-> If[ walk0 === { } || ! AllTrue[ walk0, VertexQ[ graph, # ] & ], { },
        Module[ { cands, keepQ, stepsOK, dlFn, pick, filterQ, ev, state, step,
                  acc = { }, kept = <| |>, seen = <| |>, frontier, completed = { }, moves, descend, emit, descendBoth, emitBoth },
          Catch @ With[ {
              scale      = OptionValue[ ExtendInfraWalk, { opts }, "InfraScale" ],
              rules      = OptionValue[ ExtendInfraWalk, { opts }, Properties ],
              condition  = OptionValue[ ExtendInfraWalk, { opts }, "StoppingCondition" ],
              direction  = OptionValue[ ExtendInfraWalk, { opts }, "Direction" ],
              methodSpec = Replace[ OptionValue[ ExtendInfraWalk, { opts }, Method ],
                             Automatic :> If[ count === All, "Exhaustive", "Greedy" ] ],
              absSpec    = Replace[ kspec, {
                { lo_, hi_ } :> { lo, hi } + Length[ walk0 ] - 1,
                { k_ }       :> { k + Length[ walk0 ] - 1 },
                UpTo[ k_ ]   :> UpTo[ k + Length[ walk0 ] - 1 ] } ] },
            { base       = NestWhile[ First, condition, MatchQ[ { _, "Delay" -> _Integer?NonNegative } ] ],
              methodHead = Replace[ methodSpec, { m_String, ___ } :> m ],
              pruning    = Lookup[ Replace[ methodSpec, { { _String, o___ } :> { o }, _ -> { } } ], "Pruning", Infinity ],
              kmax       = Replace[ absSpec, { { _, hi_ } :> hi, { k_ } :> k, UpTo[ k_ ] :> k } ],
              lengthQ    = Replace[ absSpec, {
                Infinity     :> ( True & ),
                UpTo[ k_ ]   :> ( Length[ # ] - 1 <= k & ),
                { k_ }       :> ( Length[ # ] - 1 == k & ),
                { lo_, hi_ } :> ( lo <= Length[ # ] - 1 <= hi & ) } ],
              stepsMax   = Replace[ kspec, { { _, hi_ } :> hi, { k_ } :> k, UpTo[ k_ ] :> k } ],
              stepsQ     = Replace[ kspec, {
                Infinity     :> ( True & ),
                { k_ }       :> ( # == k & ),
                { lo_, hi_ } :> ( lo <= # <= hi & ),
                UpTo[ k_ ]   :> ( # <= k & ) } ],
              (* the species a rule list forbids: "Simple", "Immersed" and "Generic" name the standard exclusion sets *)
              speciesOf  = rule |-> Replace[ rule, {
                "Simple"   -> { "SelfIntersections" },
                "Immersed" -> { "Cusps" },
                "Generic"  -> { "Cusps", "SelfTangencies", "TriplePoints" },
                ( "Exclude" -> s_ ) :> Flatten @ { s },
                _ -> { } } ],
              window     = walk |-> If[ scale === Infinity, walk, Take[ walk, -Min[ scale, Length @ walk ] ] ] },
            { excluded = Union @@ ( speciesOf /@ rules ),
              events   = With[ { entries = Which[
                    base === None,                  { },
                    IntegerQ[ base ] && base >= 1,  { { "SelfIntersection", 0, base } },
                    ! MatchQ[ base, None | _Integer | _List | _String | _Rule ], { { base, 0, 1 } },
                    True, ( Message[ ExtendInfraWalk::badevent, base ]; Throw[ $Failed ] ) ] },
                If[ MatchQ[ condition, { _, "Delay" -> _Integer?NonNegative } ],
                  { #[[ 1 ]], condition[[ 2, 2 ]], #[[ 3 ]] } & /@ entries, entries ] ],
              species  = Map[ rule |-> Switch[ rule,
                  "Minimizing" | "Simple" | "Immersed" | "Generic" |
                    ( "Exclude" -> ( "SelfIntersections" | "SelfTangencies" | "Cusps" | "TriplePoints" |
                        { ( "SelfIntersections" | "SelfTangencies" | "Cusps" | "TriplePoints" ) .. } ) ),
                                                                         "Constraint",
                  "Straightest" | { "Minimal", _ } | { "Maximal", _ },  "Selector",
                  _String | { _String, ___ } | _Rule,
                    ( Message[ ExtendInfraWalk::badproperty, rule ]; Throw[ $Failed ] ),
                  _,                                                     "Constraint" ],
                rules ] },
            (* each excluded species is refused exactly at the step that would create it, so per-step pruning is exact; a bare predicate is a custom local law on the window *)
            { checks = Map[ rule |-> If[ rule === "Minimizing",
                  { walk, w } |-> GraphDistance[ graph, First @ window @ walk, w ] == Length @ window @ walk,
                  If[ speciesOf @ rule === { },
                    { walk, w } |-> rule @ Append[ window @ walk, w ],
                    With[ { sps = speciesOf @ rule }, { walk, w } |-> AllTrue[ sps, sp |-> Switch[ sp,
                      "SelfIntersections", ! MemberQ[ walk, w ],
                      "Cusps",             Length[ walk ] < 2 || walk[[ -2 ]] =!= w,
                      "TriplePoints",      Count[ walk, w ] <= 1,
                      (* a repeated edge opens a repeated arc unless it is the mirror of a cusp, the stretch between the two traversals then being a palindrome *)
                      "SelfTangencies",    NoneTrue[ Range[ Length[ walk ] - 1 ],
                        p |-> ( walk[[ p ]] === Last[ walk ] && walk[[ p + 1 ]] === w ) ||
                          ( walk[[ p ]] === w && walk[[ p + 1 ]] === Last[ walk ] && ! PalindromeQ[ walk[[ p + 1 ;; ]] ] ) ] ] ] ] ] ],
                Pick[ rules, species, "Constraint" ] ],
              (* "Straightest" maximises the distance tuple from the candidate back along the window, nearest first -- the immediate predecessor sits at distance 1 for every candidate and carries no information *)
              selectors = Map[ rule |-> Switch[ rule,
                  "Straightest",
                    With[ { vidx = AssociationThread[ VertexList @ graph, Range @ VertexCount @ graph ],
                            dmat = GraphDistanceMatrix @ graph },
                      { walk, candidates } |-> With[ { historyIdx = vidx /@ Reverse @ Most @ window @ walk },
                        If[ candidates === { } || historyIdx === { }, candidates,
                          MaximalBy[ candidates, w |-> dmat[[ historyIdx, vidx[ w ] ]] ] ] ] ],
                  { "Minimal", _ },
                    { walk, candidates } |-> If[ candidates === { }, candidates,
                      MinimalBy[ candidates, w |-> Last[ rule ] @ Append[ window @ walk, w ] ] ],
                  { "Maximal", _ },
                    { walk, candidates } |-> If[ candidates === { }, candidates,
                      MaximalBy[ candidates, w |-> Last[ rule ] @ Append[ window @ walk, w ] ] ] ],
                Pick[ rules, species, "Selector" ] ],
              (* a two-sided step can violate a whole-walk constraint each side admits alone; re-check the joined walk on the constraints monotone under extension -- a walk is a geodesic iff every sub-walk is, so a failed joined check never heals *)
              stepChecks = Join[
                Replace[ excluded, {
                  "SelfIntersections" -> DuplicateFreeQ,
                  "TriplePoints"      -> ( w |-> Max[ Counts @ w ] <= 2 ),
                  "Cusps"             -> ( w |-> WalkSingularities[ w ][ "Cusps" ] === { } ),
                  "SelfTangencies"    -> ( w |-> WalkSingularities[ w ][ "SelfTangencies" ] === { } ) }, { 1 } ],
                If[ scale === Infinity && MemberQ[ rules, "Minimizing" ],
                  { w |-> GraphDistance[ graph, First @ w, Last @ w ] == Length[ w ] - 1 }, { } ] ],
              prunedOf = paths |-> Which[
                pruning === Infinity, paths,
                IntegerQ @ pruning,   If[ Length @ paths <= pruning, paths, RandomSample[ paths, pruning ] ],
                paths === { },        { },
                True, With[ { survivors = Select[ paths, RandomReal[ ] < pruning & ] },
                  If[ survivors === { }, RandomSample[ paths, 1 ], survivors ] ] ] },
            (* constraints are checked first and commute; selectors follow in list order, each refining the previous ties *)
            cands = { g, walk } |-> Fold[ #2[ walk, #1 ] &,
              Select[ AdjacencyList[ g, Last @ walk ], w |-> AllTrue[ checks, #[ walk, w ] & ] ], selectors ];
            keepQ   = lengthQ;
            stepsOK = stepsQ;
            filterQ = If[ stepChecks === { }, True &, w |-> AllTrue[ stepChecks, #[ w ] & ] ];
            pick    = If[ methodHead === "RandomGreedy", RandomSample, Identity ];
            ev      = events;
            (* the event state is a function of the walk prefix, memoised per prefix so that a shared prefix is stepped once: the remaining counts and the deadline, an event firing at the tip of an arrival at an already visited vertex or at its predicate's first True *)
            state[ walk_ ] := state[ walk ] =
              If[ Length[ walk ] < 2, { ev[[ All, 3 ]], Infinity },
                With[ { prev = state @ Most @ walk },
                  { fired = MapThread[ { rem, entry } |-> Boole[ rem > 0 &&
                        If[ First @ entry === "SelfIntersection", Count[ walk, Last @ walk ] >= 2, TrueQ[ First[ entry ] @ walk ] ] ],
                      { First @ prev, ev } ] },
                  { rem = First @ prev - fired },
                  { rem, Min @ Prepend[
                      MapThread[ If[ #1 === 1 && #2 === 0, Length[ walk ] - 1 + #3[[ 2 ]], Infinity ] &, { fired, rem, ev } ],
                      Last @ prev ] } ] ];
            dlFn = If[ ev === { }, Infinity &, walk |-> Last @ state @ walk ];
            (* the three moves of one outer step, joint first; a side draws candidates only while its own added-edge count is under the budget *)
            step = { walk, la, ra, br } |->
              With[ { backCands = If[ la < stepsMax, br @ cands[ graph, Reverse @ walk ], { } ],
                      fwdCands  = If[ ra < stepsMax, br @ cands[ graph, walk ], { } ] },
                Join[
                  Flatten[ Outer[ { Prepend[ Append[ walk, #2 ], #1 ], la + 1, ra + 1 } &, backCands, fwdCands, 1 ], 1 ],
                  { Append[ walk, # ], la, ra + 1 } & /@ fwdCands,
                  { Prepend[ walk, # ], la + 1, ra } & /@ backCands ] ];
            If[ events =!= { } && direction === "BothSides",
              Message[ ExtendInfraWalk::eventsided ]; Throw[ $Failed ] ];
            If[ MatchQ[ events, { { "SelfIntersection", _, _ } } ] &&
                ( MemberQ[ excluded, "SelfIntersections" ] || ( scale === Infinity && MemberQ[ rules, "Minimizing" ] ) ),
              Message[ ExtendInfraWalk::deadevent ] ];
            (* the class is finite once no vertex may be revisited or visited a third time, or no arc repeated, or the whole walk minimizes *)
            If[ kmax === Infinity && ! ( ( scale === Infinity && MemberQ[ rules, "Minimizing" ] ) ||
                  IntersectingQ[ excluded, { "SelfIntersections", "TriplePoints", "SelfTangencies" } ] ),
              Message[ ExtendInfraWalk::unbounded, scale ]; Throw[ $Failed ] ];
            If[ ! MatchQ[ methodHead, "Exhaustive" | "Greedy" | "RandomGreedy" ],
              Message[ ExtendInfraWalk::badmethod, methodSpec ]; Throw[ $Failed ] ];
            (* one side grows: the lazy depth-first descent emits a walk when the budget or the deadline is spent or no admissible step remains, and is complete, so a finite count is exact; the breadth-first sweep caps the live frontier by "Pruning" *)
            emit[ walk_ ] := If[ keepQ @ walk,
              AppendTo[ acc, walk ];
              If[ Length @ acc >= cap, Throw[ acc, emit ] ] ];
            descend[ walk_ ] :=
              If[ Length[ walk ] - 1 >= Min[ kmax, dlFn @ walk ],
                emit[ walk ],
                With[ { nexts = pick @ cands[ graph, walk ] },
                  If[ nexts === { }, emit[ walk ], Scan[ descend[ Append[ walk, # ] ] &, nexts ] ] ] ];
            Switch[ direction,
              "Forward" | "Backward",
                If[ direction === "Backward", Reverse /@ # &, Identity ] @
                  If[ methodHead === "Exhaustive",
                    frontier = { If[ direction === "Backward", Reverse @ walk0, walk0 ] };
                    While[ frontier =!= { } && Length[ completed ] < cap,
                      moves = ( walk |-> { walk,
                          If[ Length[ walk ] - 1 >= Min[ kmax, dlFn @ walk ], { }, cands[ graph, walk ] ] } ) /@ frontier;
                      completed = Join[ completed, Select[ Cases[ moves, { w_, { } } :> w ], keepQ ] ];
                      frontier = prunedOf @ Flatten[ Cases[ moves, { w_, nexts : { __ } } :> ( Append[ w, # ] & /@ nexts ) ], 1 ] ];
                    Take[ completed, UpTo[ cap ] ],
                    Catch[ descend[ If[ direction === "Backward", Reverse @ walk0, walk0 ] ]; acc, emit ] ],
              "BothSides",
                If[ methodHead === "Exhaustive",
                  frontier = { { walk0, 0, 0 } };
                  seen = <| { walk0, 0, 0 } -> True |>;
                  While[ frontier =!= { } && Length[ completed ] < cap,
                    moves = ( st |-> { st, Select[ step[ Sequence @@ st, Identity ], filterQ[ First @ # ] & ] } ) /@ frontier;
                    completed = DeleteDuplicates @ Join[ completed,
                      Cases[ moves, { { w_, la_, ra_ }, { } } /; stepsOK[ Max[ la, ra ] ] :> w ] ];
                    frontier = prunedOf @ Select[ DeleteDuplicates @ Flatten[ Cases[ moves, { _, nexts : { __ } } :> nexts ], 1 ],
                      st |-> If[ KeyExistsQ[ seen, st ], False, seen[ st ] = True ] ] ];
                  Take[ completed, UpTo[ cap ] ],
                  emitBoth[ walk_, la_, ra_ ] :=
                    If[ stepsOK[ Max[ la, ra ] ] && ! KeyExistsQ[ kept, walk ],
                      kept[ walk ] = True;
                      AppendTo[ acc, walk ];
                      If[ Length @ acc >= cap, Throw[ acc, emitBoth ] ] ];
                  descendBoth[ st : { walk_, la_, ra_ } ] :=
                    If[ ! KeyExistsQ[ seen, st ],
                      seen[ st ] = True;
                      With[ { nexts = Select[ step[ walk, la, ra, pick ], filterQ[ First @ # ] & ] },
                        If[ nexts === { }, emitBoth[ walk, la, ra ], Scan[ descendBoth, nexts ] ] ] ];
                  Catch[ descendBoth[ { walk0, 0, 0 } ]; acc, emitBoth ] ],
              _, Message[ ExtendInfraWalk::baddirection, direction ]; Throw[ $Failed ] ] ] ] ],
      seedWalks ] },
    If[ MemberQ[ results, $Failed ], $Failed,
      With[ { walks = DeleteDuplicates[ ( seq |-> PathGraph[ MapIndexed[ { First @ #2, #1 } &, seq ], DirectedEdges -> True ] ) /@
                DeleteDuplicates @ Catenate @ results ] },
        Switch[ count,
          Automatic, First[ walks, { } ],
          All,       walks,
          _UpTo,     Take[ walks, count ],
          _,         If[ Length @ walks < count, $Failed, Take[ walks, count ] ] ] ] ] ]


(* ===================== ExtendInfraGeodesic ===================== *)

(* continues a seed walk as a geodesic at infra-scale scale: ExtendInfraWalk at "InfraScale" -> scale with "Minimizing" always among the rules *)

Options[ ExtendInfraGeodesic ] = {
  Properties          -> { },
  "StoppingCondition" -> None,
  Method              -> Automatic,
  "Direction"         -> "BothSides"
};

ExtendInfraGeodesic[ graph_Graph, seed_,
    scale : ( _Integer | Infinity ),
    kspec : ( UpTo[ _Integer ] | { _Integer } | { _Integer, _Integer } | Infinity ) : Infinity,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] :=
  ExtendInfraWalk[ graph, seed, kspec, count, "InfraScale" -> scale,
    Properties -> DeleteDuplicates @ Prepend[ OptionValue[ ExtendInfraGeodesic, { opts }, Properties ], "Minimizing" ],
    Sequence @@ FilterRules[ { opts }, Except[ Properties ] ] ]


(* ===================== ConcatenateInfraWalk ===================== *)

(* path concatenation: all pairs (walk1, walk2) with Last[walk1] === First[walk2] *)

ConcatenateInfraWalk[ path1_, path2_,
    count : ( _Integer | UpTo[ _Integer ] | All ) : All ] :=
  spreadFind[ walkGraph, count,
    { walk1, walk2 } |->
      If[ Last[ walk1 ] === First[ walk2 ], { Join[ walk1, Rest @ walk2 ] }, { } ],
    path1, path2 ]


(* ===================== Scene-DSL constructor ===================== *)

(* InfraWalk[v1, ..., vk] inside a scene is the literal walk; the scene engine binds the vertex sequence, as for every construction token *)

dispatchConstruction[ graph_Graph, InfraWalk[ vs__ ] ] :=
  With[ { walk = { vs } },
    If[ Length[ walk ] >= 2 &&
        AllTrue[ Partition[ walk, 2, 1 ], EdgeQ[ graph, UndirectedEdge @@ # ] & ],
      { walk },
      { } ]
  ]
