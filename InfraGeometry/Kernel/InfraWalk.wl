Package[ "WolframInstitute`InfraGeometry`" ]

(* growth of a germ under the Properties rules until a stopping condition fires, the length budget kspec is spent, or no admissible step
   remains.  Every rule reads the window -- the last <= "InfraScale" vertices with the candidate, the whole walk at the default scale Infinity.  The
   default class {"Simple"} is the simple paths; "Generic" (InfraGenericQ's read per step, endpoint freeness added on the finished curve), "Immersed"
   and the bare class {} are opt-in.
   A rule excluding self-intersections, triple points or self-tangencies bounds the class by itself, as does "Minimizing" at scale Infinity, so kspec
   Infinity is legal under the default; without a bounding rule it is refused, since a stopping condition may never fire.
   The germ is a vertex first, then a vertex list, a walk graph, or a bundle of germs; kspec counts the edges added per growing side.
   "BothSides" offers three moves per outer step -- both sides, back only, front only, joint first so a greedy witness keeps the synchronous
   trajectory -- and re-checks the joined step against the monotone whole-walk constraints its sides cannot see alone, so the walk freezes only when
   no side can move and the class is the whole two-sided extension class.  Its budget is Max[la, ra], the edges added on the longer side, invariant
   under the order the moves are taken.  Stopping conditions replay over the germ, so a deadline may already sit inside it and the germ come back
   unextended; a two-ended walk has no single tip for the event clock, so they require "Forward" or "Backward", the default under a condition *)

Options[ FindInfraWalk ] = {
  "InfraScale"         -> Infinity,
  Properties           -> { "Simple" },
  "StoppingCondition"  -> None,
  "NextVertexFunction" -> Identity,
  "Direction"          -> Automatic
}

FindInfraWalk[ graph_Graph, germ_, opts : OptionsPattern[] ] :=
  With[ { result = FindInfraWalk[ graph, germ, Infinity, Automatic, opts ] },
    result /; Head[ result ] =!= FindInfraWalk ]

FindInfraWalk[ graph_Graph, germ_,
    kspec : ( UpTo[ _Integer ] | { _Integer } | { _Integer, _Integer } | Infinity ),
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    With[ { rules     = OptionValue[ FindInfraWalk, { opts }, Properties ],
            scale     = OptionValue[ FindInfraWalk, { opts }, "InfraScale" ],
            direction = OptionValue[ FindInfraWalk, { opts }, "Direction" ],
            base      = NestWhile[ First, OptionValue[ FindInfraWalk, { opts }, "StoppingCondition" ],
              MatchQ[ { _, "Delay" -> _Integer?NonNegative } ] ] },
      { excluded = Union @@ Replace[ rules, {
          "Simple" -> { "SelfIntersections" }, "Immersed" -> { "Cusps" }, "Generic" -> { "Cusps", "SelfTangencies", "TriplePoints" },
          ( "Exclude" -> sp_ ) :> Flatten @ { sp }, _ -> { } }, { 1 } ] },
        ( MatchQ[ direction, Automatic | "Forward" | "Backward" ] || ( base === None && direction === "BothSides" ) ) &&
        ( base === None || ( IntegerQ[ base ] && base >= 1 ) || ! MatchQ[ base, None | _Integer | _List | _String | _Rule ] ) &&
        AllTrue[ rules, rule |-> ! MatchQ[ rule, _String | { _String, ___ } | _Rule ] || MatchQ[ rule,
          "Minimizing" | "Simple" | "Immersed" | "Generic" |
            ( "Exclude" -> ( "SelfIntersections" | "SelfTangencies" | "Cusps" | "TriplePoints" |
              { ( "SelfIntersections" | "SelfTangencies" | "Cusps" | "TriplePoints" ) .. } ) ) ] ] &&
        ( kspec =!= Infinity || ( scale === Infinity && MemberQ[ rules, "Minimizing" ] ) ||
          IntersectingQ[ excluded, { "SelfIntersections", "TriplePoints", "SelfTangencies" } ] ) ] :=
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
    (* a germ is read as a vertex before a vertex list, so a list-valued vertex label is one point, never the walk of its entries *)
    { germWalks = Which[
        VertexQ[ graph, # ],                                                 { { # } },
        AssociationQ @ #,                                                    Catenate[ #0 /@ Keys @ # ],
        ListQ[ # ] && # =!= { } && AllTrue[ #, v |-> VertexQ[ graph, v ] ], { # },
        GraphQ @ #,                                                          walksOf @ #,
        ListQ @ #,                                                           Catenate[ #0 /@ # ],
        True,                                                                { } ] & },
    { results = Map[ walk0 |-> If[ ! AllTrue[ walk0, VertexQ[ graph, # ] & ], { },
        With[ {
            scale     = OptionValue[ FindInfraWalk, { opts }, "InfraScale" ],
            rules     = OptionValue[ FindInfraWalk, { opts }, Properties ],
            condition = OptionValue[ FindInfraWalk, { opts }, "StoppingCondition" ],
            nextFn    = OptionValue[ FindInfraWalk, { opts }, "NextVertexFunction" ],
            absSpec   = Replace[ kspec, {
              { lo_, hi_ } :> { lo, hi } + Length[ walk0 ] - 1,
              { k_ }       :> { k + Length[ walk0 ] - 1 },
              UpTo[ k_ ]   :> UpTo[ k + Length[ walk0 ] - 1 ] } ] },
          { base       = NestWhile[ First, condition, MatchQ[ { _, "Delay" -> _Integer?NonNegative } ] ],
            direction  = Replace[ OptionValue[ FindInfraWalk, { opts }, "Direction" ],
              Automatic :> If[ condition === None && Length[ walk0 ] >= 2, "BothSides", "Forward" ] ],
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
                  True,                           { { base, 0, 1 } } ] },
              If[ MatchQ[ condition, { _, "Delay" -> _Integer?NonNegative } ],
                { #[[ 1 ]], condition[[ 2, 2 ]], #[[ 3 ]] } & /@ entries, entries ] ] },
          { checks = Map[ rule |-> If[ rule === "Minimizing",
                { walk, w } |-> GraphDistance[ graph, First @ window @ walk, w ] == Length @ window @ walk,
                If[ speciesOf @ rule === { },
                  { walk, w } |-> rule @ Append[ window @ walk, w ],
                  With[ { sps = speciesOf @ rule }, { walk, w } |-> AllTrue[ sps, sp |-> Switch[ sp,
                    "SelfIntersections", ! MemberQ[ walk, w ],
                    "Cusps",             Length[ walk ] < 2 || walk[[ -2 ]] =!= w,
                    "TriplePoints",      Count[ walk, w ] <= 1,
                    "SelfTangencies",    NoneTrue[ Range[ Length[ walk ] - 1 ],
                      p |-> ( walk[[ p ]] === Last[ walk ] && walk[[ p + 1 ]] === w ) ||
                        ( walk[[ p ]] === w && walk[[ p + 1 ]] === Last[ walk ] && ! PalindromeQ[ walk[[ p + 1 ;; ]] ] ) ] ] ] ] ] ],
              rules ],
            (* a two-sided step can violate a whole-walk constraint each side admits alone; re-check the joined walk on the constraints monotone
               under extension -- a walk is a geodesic iff every sub-walk is, so a failed joined check never heals *)
            stepChecks = Join[
              Replace[ excluded, {
                "SelfIntersections" -> DuplicateFreeQ,
                "TriplePoints"      -> ( w |-> Max[ Counts @ w ] <= 2 ),
                "Cusps"             -> ( w |-> WalkSingularities[ w ][ "Cusps" ] === { } ),
                "SelfTangencies"    -> ( w |-> WalkSingularities[ w ][ "SelfTangencies" ] === { } ) }, { 1 } ],
              If[ scale === Infinity && MemberQ[ rules, "Minimizing" ],
                { w |-> GraphDistance[ graph, First @ w, Last @ w ] == Length[ w ] - 1 }, { } ],
              If[ IntegerQ[ scale ] && Length[ walk0 ] < scale && MemberQ[ rules, "Minimizing" ],
                { w |-> InfraGeodesicQ[ graph, w, scale ] }, { } ] ] },
          (* the next-vertex function sees the candidate windows and gives the ones to pursue in order, one window read as the list of it *)
          { cands = { g, walk } |-> Replace[
              Append[ window @ walk, # ] & /@ Select[ AdjacencyList[ g, Last @ walk ], w |-> AllTrue[ checks, #[ walk, w ] & ] ],
              { { } -> { }, windows_ :> Last /@ Replace[ nextFn @ windows, chosen_ /; MemberQ[ windows, Verbatim @ chosen ] :> { chosen } ] } ],
            filterQ = If[ stepChecks === { }, True &, w |-> AllTrue[ stepChecks, #[ w ] & ] ],
            (* the event state travels with the walk, stepped once per added vertex, so a shared prefix is never replayed: the
               remaining counts and the deadline, an event firing at an arrival at a visited vertex or at its predicate's first True *)
            advance = If[ events === { },
              #1 &,
              With[ { prev = #1, walk = #2 },
                { fired = MapThread[ { rem, entry } |-> Boole[ rem > 0 &&
                      If[ First @ entry === "SelfIntersection", Count[ walk, Last @ walk ] >= 2, TrueQ[ First[ entry ] @ walk ] ] ],
                    { First @ prev, events } ] },
                { rem = First @ prev - fired },
                { rem, Min @ Prepend[
                    MapThread[ If[ #1 === 1 && #2 === 0, Length[ walk ] - 1 + #3[[ 2 ]], Infinity ] &, { fired, rem, events } ],
                    Last @ prev ] } ] & ],
            oriented = If[ direction === "Backward", Reverse @ walk0, walk0 ] },
          { step = { walk, la, ra } |->
              With[ { backCands = If[ la < stepsMax, cands[ graph, Reverse @ walk ], { } ],
                      fwdCands  = If[ ra < stepsMax, cands[ graph, walk ], { } ] },
                Join[
                  Flatten[ Outer[ { Prepend[ Append[ walk, #2 ], #1 ], la + 1, ra + 1 } &, backCands, fwdCands, 1 ], 1 ],
                  { Append[ walk, # ], la, ra + 1 } & /@ fwdCands,
                  { Prepend[ walk, # ], la + 1, ra } & /@ backCands ] ],
            seedState = Fold[ { st, i } |-> advance[ st, Take[ oriented, i ] ],
              { events[[ All, 3 ]], Infinity }, Range[ 2, Length @ oriented ] ] },
          (* the hot loops reach the closures through an Association, an atom, so no closure call or With renames their bodies *)
          { engine = <| "Candidates" -> cands, "Advance" -> advance, "Step" -> step, "Filter" -> filterQ |> },
          Which[
            MemberQ[ rules, "Minimizing" ] && Length[ walk0 ] >= 2 && ! InfraGeodesicQ[ graph, walk0, scale ], { },
            MatchQ[ direction, "Forward" | "Backward" ],
              If[ direction === "Backward", Reverse /@ # &, Identity ] @ With[
                { descend = With[ { self = #0, walk = #1, st = #2, found = #3 },
                    { nexts = If[ Length[ walk ] - 1 >= Min[ kmax, Last @ st ], { }, engine[ "Candidates" ][ graph, walk ] ] },
                    If[ nexts === { },
                      If[ lengthQ @ walk, Append[ found, walk ], found ],
                      Fold[
                        If[ Length @ #1 >= cap, #1, self[ Append[ walk, #2 ], engine[ "Advance" ][ st, Append[ walk, #2 ] ], #1 ] ] &,
                        found, nexts ] ] ] & },
                descend[ oriented, seedState, { } ] ],
            True,
              With[ { descendBoth = With[ { self = #0, st = #1, state = #2 },
                    If[ KeyExistsQ[ Last @ state, st ], state,
                      With[ { marked = { First @ state, state[[ 2 ]], Append[ Last @ state, st -> True ] },
                              nexts  = Select[ engine[ "Step" ][ Sequence @@ st ], engine[ "Filter" ][ First @ # ] & ] },
                        Which[
                          nexts =!= { },
                            Fold[ If[ Length @ First @ #1 >= cap, #1, self[ #2, #1 ] ] &, marked, nexts ],
                          stepsQ[ Max @ Rest @ st ] && ! KeyExistsQ[ marked[[ 2 ]], First @ st ],
                            { Append[ First @ marked, First @ st ], Append[ marked[[ 2 ]], First @ st -> True ], Last @ marked },
                          True, marked ] ] ] ] & },
                First @ descendBoth[ { walk0, 0, 0 }, { { }, <| |>, <| |> } ] ] ] ] ],
      germWalks @ germ ] },
    With[ { walks = DeleteDuplicates[ ( seq |-> PathGraph[ MapIndexed[ { First @ #2, #1 } &, seq ], DirectedEdges -> True ] ) /@
                DeleteDuplicates @ Catenate @ results ] },
        Switch[ count,
          Automatic, First[ walks, { } ],
          All,       walks,
          _UpTo,     Take[ walks, count ],
          _,         If[ Length @ walks < count, { }, Take[ walks, count ] ] ] ] ]

Options[ FindInfraGeodesic ] = {
  Properties           -> { },
  "StoppingCondition"  -> None,
  "NextVertexFunction" -> Identity,
  "Direction"          -> Automatic
}

FindInfraGeodesic[ graph_Graph, germ_, scale : ( _Integer | Infinity ), opts : OptionsPattern[] ] :=
  With[ { result = FindInfraGeodesic[ graph, germ, scale, Infinity, Automatic, opts ] },
    result /; Head[ result ] =!= FindInfraGeodesic ]

FindInfraGeodesic[ graph_Graph, germ_,
    scale : ( _Integer | Infinity ),
    kspec : ( UpTo[ _Integer ] | { _Integer } | { _Integer, _Integer } | Infinity ),
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] :=
  With[ { result = FindInfraWalk[ graph, germ, kspec, count, "InfraScale" -> scale,
      Properties -> DeleteDuplicates @ Prepend[ OptionValue[ FindInfraGeodesic, { opts }, Properties ], "Minimizing" ],
      Sequence @@ FilterRules[ { opts }, Except[ Properties ] ] ] },
    result /; Head[ result ] =!= FindInfraWalk ]

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

InfraGeodesicQ[ _Graph, walk_List, ___ ] /; Length[ walk ] < 2 :=
  False

WalkSingularities[ ws : { __Graph } ] :=
  WalkSingularities /@ ws

WalkSingularities[ w_Graph ] /; ! LoopFreeGraphQ[ w ] || ! AcyclicGraphQ[ w ] :=
  With[
    { vs = VertexList @ w },
    { core = If[ AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
        Last /@ SortBy[ vs, First ],
        Reap[ DepthFirstScan[ w, First @ vs, { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] ] },
    { m = Length @ core },
    { cyc = i |-> Mod[ i - 1, m ] + 1,
      period = SelectFirst[ Divisors @ m, d |-> core === RotateLeft[ core, d ] ],
      cyclicRuns = set |-> With[ { runs = Split[ Sort @ set, #2 == #1 + 1 & ] },
        If[ Length[ runs ] >= 2 && First[ First @ runs ] == 1 && Last[ Last @ runs ] == m,
          Prepend[ runs[[ 2 ;; -2 ]], Join[ Last @ runs, First @ runs ] ],
          runs ] ],
      arcGroups = ts |-> Values @ GroupBy[
        ( pos |-> With[ { arc = core[[ Mod[ pos - 1, m ] + 1 ]] },
            { key = First @ Sort @ { arc, Reverse @ arc } },
            key -> { pos, arc === key } ] ) /@ DeleteDuplicates @ ts,
        First -> Last,
        ps |-> With[ { sorted = SortBy[ DeleteDuplicates @ ps, First @ First @ # & ] },
          { flip = ! Last @ First @ sorted },
          ( { pos, direct } |-> If[ Xor[ direct, flip ],
              { First @ pos, Last @ pos }, { Last @ pos, First @ pos } ] ) @@@ sorted ] ] },
    { traversals = Join[
        If[ period < m, { Partition[ Range @ m, period ] }, { } ],
        Catenate @ Table[
          { First[ # ] + Range[ 0, Length[ # ] - 1 ], cyc[ First[ # ] + d ] + Range[ 0, Length[ # ] - 1 ] } & /@
            Select[ cyclicRuns @ Select[ Range @ m, i |-> core[[ i ]] === core[[ cyc[ i + d ] ]] ],
              run |-> 2 <= Length[ run ] < m ],
          { d, 2, Floor[ m / 2 ] } ],
        Catenate @ Table[
          { First[ # ] + Range[ 0, Length[ # ] - 1 ], cyc[ s - Last[ # ] ] + Range[ 0, Length[ # ] - 1 ] } & /@
            Select[ cyclicRuns @
                Select[ Range @ m, i |-> cyc[ s - i ] =!= i && core[[ i ]] === core[[ cyc[ s - i ] ]] ],
              run |-> Length[ run ] >= 2 &&
                NoneTrue[ run, i |-> cyc[ s - i ] === cyc[ i + 2 ] || cyc[ s - i ] === cyc[ i - 2 ] ] ],
          { s, 0, m - 1 } ] ] },
    <|
      "SelfIntersections" -> Select[ Values @ PositionIndex @ core, Length[ # ] >= 2 & ],
      "SelfTangencies" -> arcGroups[ Catenate @ traversals ],
      "Cusps" -> ( i |-> With[
          { k = LengthWhile[ Range @ Floor[ ( m - 1 ) / 2 ],
              t |-> core[[ cyc[ i - t ] ]] === core[[ cyc[ i + t ] ]] ] },
          cyc /@ Range[ i - k, i + k ] ] ) /@
        Select[ Range @ m, i |-> core[[ cyc[ i - 1 ] ]] === core[[ cyc[ i + 1 ] ]] ]
    |> ]

WalkSingularities[ w_Graph ] :=
  With[ { vs = VertexList @ w },
    WalkSingularities @ Which[
      AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs, Last /@ SortBy[ vs, First ],
      EdgeCount[ w ] == 0, vs,
      True,
        Reap[ DepthFirstScan[ w,
          SelectFirst[ vs, If[ DirectedGraphQ @ w, VertexInDegree[ w, # ] == 0, VertexDegree[ w, # ] == 1 ] &, First @ vs ],
          { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] ] ]

WalkSingularities[ walk_List ] :=
  With[
    { m = Length @ walk,
      maximalRuns = set |-> Split[ Sort @ set, #2 == #1 + 1 & ] },
    { arcGroups = ts |-> Values @ GroupBy[
        ( pos |-> With[ { arc = walk[[ Mod[ pos - 1, m ] + 1 ]] },
            { key = First @ Sort @ { arc, Reverse @ arc } },
            key -> { pos, arc === key } ] ) /@ DeleteDuplicates @ ts,
        First -> Last,
        ps |-> With[ { sorted = SortBy[ DeleteDuplicates @ ps, First @ First @ # & ] },
          { flip = ! Last @ First @ sorted },
          ( { pos, direct } |-> If[ Xor[ direct, flip ],
              { First @ pos, Last @ pos }, { Last @ pos, First @ pos } ] ) @@@ sorted ] ],
      traversals = Join[
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
      "SelfTangencies" -> arcGroups[ Catenate @ traversals ],
      "Cusps" -> ( i |-> With[
          { k = LengthWhile[ Range @ Min[ i - 1, m - i ], t |-> walk[[ i - t ]] === walk[[ i + t ]] ] },
          Range[ i - k, i + k ] ] ) /@
        Select[ Range[ 2, m - 1 ], i |-> walk[[ i - 1 ]] === walk[[ i + 1 ]] ]
    |> ]

InfraImmersedQ[ graph_Graph, ws : { __Graph } ] :=
  AllTrue[ ws, InfraImmersedQ[ graph, # ] & ]

InfraImmersedQ[ graph_Graph, w_Graph ] /; ! LoopFreeGraphQ[ w ] || ! AcyclicGraphQ[ w ] :=
  With[ { vs = VertexList @ w },
    { core = If[ AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
        Last /@ SortBy[ vs, First ],
        Reap[ DepthFirstScan[ w, First @ vs, { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] ] },
    InfraWalkQ[ graph, If[ First @ core === Last @ core, core, Append[ core, First @ core ] ] ] &&
    WalkSingularities[ w ][ "Cusps" ] === { } ]

InfraImmersedQ[ graph_Graph, w_Graph ] :=
  With[ { vs = VertexList @ w },
    { spelled = AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs },
    AllTrue[
      Which[
        EdgeCount @ w == 0, List /@ If[ spelled, Last /@ vs, vs ],
        spelled,            { Last /@ SortBy[ vs, First ] },
        DirectedGraphQ @ w,
          Catenate @ Catenate @ Table[ FindPath[ w, a, b, Infinity, All ],
            { a, Select[ vs, VertexInDegree[ w, # ] == 0 & ] }, { b, Select[ vs, VertexOutDegree[ w, # ] == 0 & ] } ],
        True, { Reap[ DepthFirstScan[ w, SelectFirst[ vs, VertexDegree[ w, # ] == 1 &, First @ vs ],
          { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] } ],
      InfraImmersedQ[ graph, # ] & ] ]

InfraImmersedQ[ graph_Graph, walk_List ] :=
  InfraWalkQ[ graph, walk ] && WalkSingularities[ walk ][ "Cusps" ] === { }

InfraGenericQ[ graph_Graph, ws : { __Graph } ] :=
  AllTrue[ ws, InfraGenericQ[ graph, # ] & ]

InfraGenericQ[ graph_Graph, w_Graph ] /; ! LoopFreeGraphQ[ w ] || ! AcyclicGraphQ[ w ] :=
  With[ { vs = VertexList @ w },
    { core = If[ AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
        Last /@ SortBy[ vs, First ],
        Reap[ DepthFirstScan[ w, First @ vs, { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] ] },
    InfraWalkQ[ graph, If[ First @ core === Last @ core, core, Append[ core, First @ core ] ] ] &&
    With[ { c = WalkSingularities @ w },
      c[ "Cusps" ] === { } && c[ "SelfTangencies" ] === { } &&
      AllTrue[ c[ "SelfIntersections" ], Length[ # ] == 2 & ] ] ]

InfraGenericQ[ graph_Graph, w_Graph ] :=
  With[ { vs = VertexList @ w },
    { spelled = AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs },
    AllTrue[
      Which[
        EdgeCount @ w == 0, List /@ If[ spelled, Last /@ vs, vs ],
        spelled,            { Last /@ SortBy[ vs, First ] },
        DirectedGraphQ @ w,
          Catenate @ Catenate @ Table[ FindPath[ w, a, b, Infinity, All ],
            { a, Select[ vs, VertexInDegree[ w, # ] == 0 & ] }, { b, Select[ vs, VertexOutDegree[ w, # ] == 0 & ] } ],
        True, { Reap[ DepthFirstScan[ w, SelectFirst[ vs, VertexDegree[ w, # ] == 1 &, First @ vs ],
          { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] } ],
      InfraGenericQ[ graph, # ] & ] ]

InfraGenericQ[ graph_Graph, walk_List ] :=
  InfraWalkQ[ graph, walk ] &&
  With[ { c = WalkSingularities @ walk },
    c[ "Cusps" ] === { } && c[ "SelfTangencies" ] === { } &&
    AllTrue[ c[ "SelfIntersections" ], Length[ # ] == 2 && FreeQ[ #, 1 | Length @ walk ] & ] ]

(* a double visit of v is a crossing at scale r when each pass through B(v, r-1), continued along its radial arcs through the shell {r, r+1},
   separates the other pass's exits on that shell.  Two 0-spheres link only in S^1: on a surface-like substrate this is the interleaving of the two
   germ pairs, and where the shell stays connected after a radial cut nothing is a crossing *)

InfraWalkCrossingQ[ graph_Graph, ws : { __Graph }, at_, r_Integer ] :=
  AllTrue[ ws, InfraWalkCrossingQ[ graph, #, at, r ] & ]

InfraWalkCrossingQ[ graph_Graph, w_Graph, at_, r_Integer ] /; LoopFreeGraphQ[ w ] && AcyclicGraphQ[ w ] :=
  With[ { vs = VertexList @ w },
    { spelled = AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs },
    AllTrue[
      Which[
        EdgeCount @ w == 0, List /@ If[ spelled, Last /@ vs, vs ],
        spelled,            { Last /@ SortBy[ vs, First ] },
        DirectedGraphQ @ w,
          Catenate @ Catenate @ Table[ FindPath[ w, a, b, Infinity, All ],
            { a, Select[ vs, VertexInDegree[ w, # ] == 0 & ] }, { b, Select[ vs, VertexOutDegree[ w, # ] == 0 & ] } ],
        True, { Reap[ DepthFirstScan[ w, SelectFirst[ vs, VertexDegree[ w, # ] == 1 &, First @ vs ],
          { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] } ],
      InfraWalkCrossingQ[ graph, #, at, r ] & ] ]

InfraWalkCrossingQ[ graph_Graph, x : ( _Graph | _List ), at_, r_Integer ] /;
    If[ GraphQ @ x, ! LoopFreeGraphQ[ x ] || ! AcyclicGraphQ[ x ], ! MatchQ[ x, { __Graph } ] ] :=
  With[ { closedQ = GraphQ @ x, vs = If[ GraphQ @ x, VertexList @ x, { } ] },
    { core = Which[
        ! closedQ, x,
        AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs, Last /@ SortBy[ vs, First ],
        True, Reap[ DepthFirstScan[ x, First @ vs, { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] ] },
    { ps = If[ MatchQ[ at, { _Integer, _Integer } ], at,
        Select[ Range @ Length @ core, core[[ # ]] === Replace[ at, fam_Association :> First @ Keys @ fam ] & ] ],
      crossQ = { i, j } |-> With[
        { m = Length @ core, v = core[[ i ]] },
        { localG = NeighborhoodGraph[ graph, { v }, r + 1 ] },
        { d = AssociationThread[ VertexList @ localG, GraphDistance[ localG, v ] ] },
        { vertexAt = t |-> core[[ Mod[ t - 1, m ] + 1 ]],
          dist = t |-> If[ closedQ || 1 <= t <= m,
            Lookup[ d, Key @ core[[ Mod[ t - 1, m ] + 1 ]], Infinity ], Missing[ ] ] },
        { excursion = p |-> {
            p - LengthWhile[ Range[ p - 1, p - m, -1 ], t |-> TrueQ[ dist[ t ] <= r - 1 ] ],
            p + LengthWhile[ Range[ p + 1, p + m ], t |-> TrueQ[ dist[ t ] <= r - 1 ] ] },
          radial = { start, step } |-> With[
            { steps = NestWhileList[ # + step &, start, dist[ # ] === r &, 1, m ] },
            If[ dist[ Last @ steps ] === r + 1, vertexAt /@ steps, Missing[ ] ] ] },
        { ei = excursion @ i, ej = excursion @ j },
        { exitsI = { First[ ei ] - 1, Last[ ei ] + 1 }, exitsJ = { First[ ej ] - 1, Last[ ej ] + 1 } },
        { band = Subgraph[ localG, Select[ VertexList @ localG, r <= d[ # ] <= r + 1 & ] ],
          cutI = { radial[ First @ exitsI, -1 ], radial[ Last @ exitsI, 1 ] },
          cutJ = { radial[ First @ exitsJ, -1 ], radial[ Last @ exitsJ, 1 ] } },
        core[[ j ]] === v &&
        ! IntersectingQ[ Mod[ Range @@ ei - 1, m ] + 1, Mod[ Range @@ ej - 1, m ] + 1 ] &&
        AllTrue[ Join[ exitsI, exitsJ ], dist[ # ] === r & ] &&
        FreeQ[ { cutI, cutJ }, _Missing ] &&
        SeparatesQ[ band, DeleteDuplicates[ Join @@ cutJ ], vertexAt @ First @ exitsI, vertexAt @ Last @ exitsI ] &&
        SeparatesQ[ band, DeleteDuplicates[ Join @@ cutI ], vertexAt @ First @ exitsJ, vertexAt @ Last @ exitsJ ] ] },
    Length[ ps ] == 2 && crossQ @@ ps ]

FindInfraRepresentative[ graph_Graph, InfraGeodesic[ germ_List, scale : ( _Integer | Infinity ) ],
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, mods___ ] :=
  With[ { walks = FindInfraGeodesic[ graph, germ, scale, Infinity, count,
      Properties -> { "Simple" }, "Direction" -> "BothSides", Sequence @@ searchMethod[ mods ] ] },
    Replace[ walks, { w_Graph :> Last /@ VertexList @ w, l_List :> ( Last /@ VertexList @ # & ) /@ l } ] /; ! MatchQ[ walks, _FindInfraGeodesic ] ]

(* the window graph of the scale-r geodesics through the germ, read forward: a vertex is a window, the last <= r vertices of a walk, and a
   window w_1 ... w_m steps to v iff d(w_1, v) == m, so the walks of k edges from the germ's window are the k-step extensions of the germ.  It is
   a subshift of finite type; its cycles are the closed scale-r geodesics.  At scale Infinity the walk is a geodesic from the germ's first
   vertex p, the window collapses to its last vertex, and the graph is the part of the ray DAG of p reachable from the germ's last vertex.
   NestGraph[f, x, Infinity] takes 1.8 s on a 9-vertex grid, so the closure is a frontier loop *)

InfraMeasurement[ graph_Graph, InfraGeodesic[ germ : { __ }, scale : ( _Integer?Positive | Infinity ) ], "Graph" ] /;
    AllTrue[ germ, VertexQ[ graph, # ] & ] && ( Length[ germ ] == 1 || InfraGeodesicQ[ graph, germ, scale ] ) :=
  With[ { dm = GraphDistanceMatrix @ graph, index = AssociationThread[ VertexList @ graph, Range @ VertexCount @ graph ] },
    { source = If[ scale === Infinity, Last @ germ, Take[ germ, -Min[ scale, Length @ germ ] ] ],
      steps = If[ scale === Infinity,
        v |-> Select[ AdjacencyList[ graph, v ], dm[[ index @ First @ germ, index @ # ]] == dm[[ index @ First @ germ, index @ v ]] + 1 & ],
        window |-> ( Take[ Append[ window, # ], -Min[ scale, Length @ window + 1 ] ] & ) /@
          Select[ AdjacencyList[ graph, Last @ window ], dm[[ index @ First @ window, index @ # ]] == Length @ window & ] ] },
    { closure = NestWhile[
        Apply[ { edges, seen, frontier } |-> With[ { out = Catenate @ Map[ w |-> ( DirectedEdge[ w, # ] & ) /@ steps @ w, frontier ] },
          { fresh = Select[ DeleteDuplicates[ Last /@ out ], ! KeyExistsQ[ seen, # ] & ] },
          { Join[ edges, out ], Join[ seen, AssociationThread[ fresh, True ] ], fresh } ] ],
        { { }, <| source -> True |>, { source } },
        Last @ # =!= { } & ] },
    Graph[ Keys @ closure[[ 2 ]], First @ closure ] ]

ConcatenateInfraWalk[ path1_, path2_,
    count : ( _Integer | UpTo[ _Integer ] | All ) : All ] :=
  With[ { walksOf = w |-> With[ { vs = VertexList @ w },
      { spelled = AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
        scan = root |-> Reap[ DepthFirstScan[ w, root, { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] },
      Which[
        ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w,
          { If[ First @ # === Last @ #, #, Append[ #, First @ # ] ] & @
              If[ spelled, Last /@ SortBy[ vs, First ], scan @ First @ vs ] },
        EdgeCount @ w == 0, List /@ If[ spelled, Last /@ vs, vs ],
        spelled,            { Last /@ SortBy[ vs, First ] },
        DirectedGraphQ @ w,
          Catenate @ Catenate @ Table[ FindPath[ w, a, b, Infinity, All ],
            { a, Select[ vs, VertexInDegree[ w, # ] == 0 & ] }, { b, Select[ vs, VertexOutDegree[ w, # ] == 0 & ] } ],
        True, { scan @ SelectFirst[ vs, VertexDegree[ w, # ] == 1 &, First @ vs ] } ] ] },
    { spread = x |-> Which[
        AssociationQ @ x,           Keys @ x,
        GraphQ @ x,                 walksOf @ x,
        MatchQ[ x, { __Graph } ],   Catenate[ walksOf /@ x ],
        MatchQ[ x, { { ___ } .. } ], x,
        x === { },                  { },
        True,                       { x } ] },
    { reps = DeleteDuplicates[
        PathGraph[ MapIndexed[ { First @ #2, #1 } &, # ], DirectedEdges -> True ] & /@
          DeleteDuplicates @ Catenate[
            ( { walk1, walk2 } |->
                If[ Last[ walk1 ] === First[ walk2 ], { Join[ walk1, Rest @ walk2 ] }, { } ] ) @@@
              Tuples[ { spread @ path1, spread @ path2 } ] ] ] },
    Switch[ count,
      All,   reps,
      _UpTo, Take[ reps, count ],
      _,     If[ Length @ reps < count, { }, Take[ reps, count ] ] ] ]

FindInfraRepresentative[ graph_Graph, InfraWalk[ vs__ ],
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, mods___ ] :=
  takeRepresentatives[
    If[ Length[ { vs } ] >= 2 && AllTrue[ Partition[ { vs }, 2, 1 ], EdgeQ[ graph, UndirectedEdge @@ # ] & ], { { vs } }, { } ],
    count, mods ]
