Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: RiemannianInfrageometry :: InfraWalk *)

(* growth of a germ under the Properties until the stopping condition fires, the length budget kspec is spent, or no admissible step remains.
   A property reads the window of scale r, the last r vertices of the growing side with the candidate appended, given as "Window" -> r
   (default Infinity), through an energy.  "Simple" counts the candidate's earlier visits in the window and drops a candidate of positive
   count.  "Geodesic" drops a candidate whose window is not a shortest path; with "Straightness" -> β finite it weighs the candidates by the
   energy 1 - g(c) for the window (w_0, ..., w_t) of tip w_t and the candidate c, with the mean gain
   g(c) = (1 / t) Σ_{i < t} d(w_i, c) - d(w_i, w_t) in [-1, 1], and 0 while the window is the tip alone; the mean keeps the cost of a turn
   from growing with the window (the sum did, and a long walk froze), and on a mesh g(c) is about the cosine of the turning angle, so the
   turning angle is von Mises of concentration β.  The energy is 0 exactly when the step moves away from every earlier vertex, so on a
   window that is a shortest path its zero set is the geodesic rule's, and the constraint is β Infinity.  A user function f is the energy
   f[window], a predicate read as 0 for True and Infinity for False, at β 1; a candidate of energy Infinity is dropped, the others weigh
   Exp[-β Δ], Δ the energy above the step's least.  Internally a hard rule is {kind, r, 0} and a weight {kind, r} -> β.
   A weight is carried as its logarithm, so none underflows.  The properties act in their order.
   The next-vertex function turns the surviving, weighted candidates into the order they are tried: Automatic, RandomSample and RandomChoice read
   the weights, Identity and a function ignore them; RandomChoice never backtracks, so its count is that many independent runs.  The germ is a vertex first, then a vertex list, a walk graph, or a bundle of germs; kspec counts the edges added per
   growing side, and kspec Infinity needs a hard rule that bounds the class, "Simple" or "Geodesic" on the window Infinity.
   "BothSides" offers three moves per outer step -- both sides, front only, back only, joint first so a greedy witness keeps the synchronous
   trajectory.  Under hard rules alone each side is ordered by its own candidates; the one window neither side sees alone holds both new ends,
   the whole joined walk once it is short enough, and the hard "Simple" and the geodesic rule re-check it.  Under a weighted property the joint
   move draws the back end on the joined walk, then the front end on the joined walk with its new back end, so the window of either end is the
   joined walk.  Its budget is Max[la, ra], the edges added on the longer side.  The stopping condition reads the whole walk after every step
   under every direction, and the germ once it has an edge *)

Options[ RandomInfraWalk ] = {
  Properties           -> { },
  "StoppingCondition"  -> None,
  "NextVertexFunction" -> Automatic,
  "Direction"          -> "Forward",
  RandomSeeding        -> Automatic
}

RandomInfraWalk[ args___ ] /; FreeQ[ { args }, RandomSeeding -> None, { 1 } ] :=
  With[ { result = BlockRandom[
      RandomInfraWalk[ Sequence @@ DeleteCases[ { args }, RandomSeeding -> _ ], RandomSeeding -> None ],
      RandomSeeding -> FirstCase[ { args }, ( RandomSeeding -> seed_ ) :> seed, Automatic ] ] },
    result /; ! MatchQ[ result, HoldPattern[ RandomInfraWalk[ ___, RandomSeeding -> None ] ] ] ]

RandomInfraWalk[ graph_Graph, germ_, opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( ( VertexQ[ graph, germ ] || ! MatchQ[ germ, _InfraWalk | _InfraGeodesic ] ) &&
    SubsetQ[ First /@ Options[ RandomInfraWalk ], First /@ { opts } ] ) :=
  With[ { result = RandomInfraWalk[ graph, germ, Infinity, Automatic, opts ] },
    result /; Head[ result ] =!= RandomInfraWalk ]

RandomInfraWalk[ graph_Graph, germ_,
    kspec : ( UpTo[ _Integer ] | { _Integer } | { _Integer, _Integer } | Infinity ),
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( ( VertexQ[ graph, germ ] || ! MatchQ[ germ, _InfraWalk | _InfraGeodesic ] ) &&
    SubsetQ[ Keys @ Options @ RandomInfraWalk, Keys @ Flatten @ { opts } ] &&
    With[ { rules     = OptionValue[ RandomInfraWalk, { opts }, Properties ],
            condition = OptionValue[ RandomInfraWalk, { opts }, "StoppingCondition" ],
            nextFn    = OptionValue[ RandomInfraWalk, { opts }, "NextVertexFunction" ],
            scale     = _Integer?Positive | Infinity,
            beta      = Infinity | _?( NumericQ[ # ] && # >= 0 & ) },
      ListQ[ rules ] &&
      AllTrue[ rules, MatchQ[ "Simple" | "Geodesic" | Except[ _String | _List | _Rule ] | { "Simple" | Except[ _String | _List | _Rule ], "Window" -> scale } |
          ( { "Geodesic", subs : ( ( "Window" -> scale ) | ( "Straightness" -> beta ) ) ... } /; DuplicateFreeQ[ First /@ { subs } ] ) ] ] &&
      MatchQ[ OptionValue[ RandomInfraWalk, { opts }, "Direction" ], "Forward" | "Backward" | "BothSides" ] &&
      ( condition === None || ! MatchQ[ condition, _Integer | _List | _String | _Rule ] ) &&
      ( nextFn =!= RandomChoice || count =!= All ) &&
      ( kspec =!= Infinity || MemberQ[ rules, "Simple" | "Geodesic" | { "Simple", "Window" -> Infinity } | ( { "Geodesic", subs___Rule } /; ! MemberQ[ { subs }, _ -> Except[ Infinity ] ] ) ] ) ] ) :=
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
          True, { scan @ SelectFirst[ vs, VertexDegree[ w, # ] == 1 &, First @ vs ] } ] ],
      (* a hard rule is {kind, r, 0}, a weighted property {kind, r} -> β *)
      rules = Replace[ OptionValue[ RandomInfraWalk, { opts }, Properties ], {
          "Simple"                                :> { "Simple", Infinity, 0 },
          "Geodesic"                              :> { geodesicRule, Infinity, 0 },
          { "Simple", "Window" -> r_ }            :> { "Simple", r, 0 },
          { "Geodesic", subs___Rule }             :> With[ { r = Lookup[ { subs }, "Window", Infinity ], b = Lookup[ { subs }, "Straightness", Infinity ] },
                                                       If[ b === Infinity, { geodesicRule, r, 0 }, { "Straightness", r } -> b ] ],
          { f_, "Window" -> r_ }                  :> ( { f, r } -> 1 ),
          f_                                      :> ( { f, Infinity } -> 1 ) }, { 1 } ],
      condition = OptionValue[ RandomInfraWalk, { opts }, "StoppingCondition" ],
      nextFn    = If[ count === All &&
          OptionValue[ RandomInfraWalk, { opts }, "NextVertexFunction" ] === Automatic,
        Identity, OptionValue[ RandomInfraWalk, { opts }, "NextVertexFunction" ] ],
      direction = OptionValue[ RandomInfraWalk, { opts }, "Direction" ] },
    (* a germ is read as a vertex before a vertex list, so a list-valued vertex label is one point, never the walk of its entries *)
    { germWalks = Which[
        VertexQ[ graph, # ],                                                 { { # } },
        AssociationQ @ #,                                                    Catenate[ #0 /@ Keys @ # ],
        ListQ[ # ] && # =!= { } && AllTrue[ #, v |-> VertexQ[ graph, v ] ], { # },
        GraphQ @ #,                                                          walksOf @ #,
        ListQ @ #,                                                           Catenate[ #0 /@ # ],
        True,                                                                { } ] &,
      weighted = ! AllTrue[ rules, MatchQ[ { _, _, 0 } ] ],
      sampler  = nextFn === RandomChoice,
      (* the energy of a property on each candidate's window, the window holding the candidate last: one minus the mean gain of the step
         against the vertices before the tip for "Straightness", the defect read from w_1 alone for the geodesic rule *)
      energies = { kind, r, walk, cs } |-> With[ { window = Take[ walk, -Min[ r, Length @ walk ] ] },
        Switch[ kind,
          "Simple",       Count[ window, # ] & /@ cs,
          geodesicRule,   ( Length[ window ] - GraphDistance[ graph, First @ window, # ] & ) /@ cs,
          "Straightness", With[ { earlier = Most @ window },
                            { tipDistances = GraphDistance[ graph, #, Last @ window ] & /@ earlier },
                            ( c |-> If[ earlier === { }, 0,
                              1 - Mean[ ( GraphDistance[ graph, #, c ] & /@ earlier ) - tipDistances ] ] ) /@ cs ],
          _,              Replace[ kind[ Append[ window, # ] ], { True -> 0, False -> Infinity } ] & /@ cs ] ],
      stopQ = If[ condition === None, False &, Length[ # ] >= 2 && TrueQ[ condition @ # ] & ] },
    (* the candidates come with the logarithms ls of their weights.  A weighted RandomSample repeats a candidate whose weight is below
       $MachineEpsilon of the total, so a draw reads only the candidates within $MachineEpsilon times their number of the best, and a
       permutation draws the rest after them in the same way *)
    { order = Which[
      nextFn === Identity,                                       { walk, cs, ls } |-> cs,
        sampler,                                                  { walk, cs, ls } |->
          With[ { top = ( # >= Max[ ls ] + Log[ $MachineEpsilon Length @ ls ] & ) /@ ls },
            { ws = Exp[ Pick[ ls, top ] - Max[ ls ] ], tops = Pick[ cs, top ] },
            { If[ Equal @@ ws, RandomChoice @ tops, RandomChoice[ ws -> tops ] ] } ],
        MatchQ[ nextFn, Automatic | RandomSample ],               { walk, cs, ls } |-> First @ NestWhile[
          Apply[ { done, c, l } |-> With[ { top = ( # >= Max[ l ] + Log[ $MachineEpsilon Length @ l ] & ) /@ l },
            { ws = Exp[ Pick[ l, top ] - Max[ l ] ], tops = Pick[ c, top ] },
            { Join[ done, If[ Equal @@ ws, RandomSample @ tops, RandomSample[ ws -> tops ] ] ], Pick[ c, top, False ], Pick[ l, top, False ] } ] ],
          { { }, cs, ls }, #[[ 2 ]] =!= { } & ],
        (* the next-vertex function sees the candidate windows and gives the ones to pursue in order, one window read as the list of it *)
        True, With[ { f = Replace[ nextFn, { fn_, _Integer?Positive | Infinity } :> fn ],
                      r = Replace[ nextFn, { { _, s : ( _Integer?Positive | Infinity ) } :> s, _ -> Infinity } ] },
          { walk, cs, ws } |-> With[ { windows = Append[ Take[ walk, -Min[ r, Length @ walk ] ], # ] & /@ cs },
            Last /@ Replace[ f @ windows, chosen_ /; MemberQ[ windows, Verbatim @ chosen ] :> { chosen } ] ] ] ],
      joinedQ = With[ { checks = Replace[ rules, {
            { "Simple", r_, 0 }   :> ( w |-> Length[ w ] - 1 > r || First @ w =!= Last @ w ),
            { geodesicRule, r_, 0 } :> ( w |-> Length[ w ] - 1 > r || GraphDistance[ graph, First @ w, Last @ w ] == Length[ w ] - 1 ),
            _ -> Nothing }, { 1 } ] },
        If[ checks === { }, True &, w |-> AllTrue[ checks, #[ w ] & ] ] ] },
    (* a weight is read from the step's least energy, a factor common to the candidates *)
    { cands = walk |-> With[ { scored = Fold[
            { state, rule } |-> Which[
              MatchQ[ rule, { _, _, 0 } ],
                With[ { keep = ( # == 0 & ) /@ energies[ First @ rule, rule[[ 2 ]], walk, First @ state ] },
                  { Pick[ First @ state, keep ], Pick[ Last @ state, keep ] } ],
              ListQ @ rule,
                With[ { e = energies[ First @ rule, rule[[ 2 ]], walk, First @ state ] },
                  { First @ state, Last[ state ] + ( e - Min[ e ] ) Log[ N @ Last @ rule ] } ],
              True,
                With[ { e = energies[ First @ First @ rule, Last @ First @ rule, walk, First @ state ] },
                  { finite = ( # < Infinity & ) /@ e },
                  { live = Pick[ e, finite ], cs = Pick[ First @ state, finite ], ls = Pick[ Last @ state, finite ] },
                  { least = Min @ live },
                  If[ Last @ rule === Infinity,
                    With[ { keep = ( # == least & ) /@ live }, { Pick[ cs, keep ], Pick[ ls, keep ] } ],
                    { cs, ls - N[ Last @ rule ] ( live - least ) } ] ] ],
            { #, ConstantArray[ 0, Length @ # ] } & @ AdjacencyList[ graph, Last @ walk ],
            rules ] },
        If[ First @ scored === { }, { }, order[ walk, First @ scored, Last @ scored ] ] ] },
    { results = Map[ walk0 |-> If[ ! AllTrue[ walk0, VertexQ[ graph, # ] & ], { },
        With[ {
            absSpec = Replace[ kspec, {
              { lo_, hi_ } :> { lo, hi } + Length[ walk0 ] - 1,
              { k_ }       :> { k + Length[ walk0 ] - 1 },
              UpTo[ k_ ]   :> UpTo[ k + Length[ walk0 ] - 1 ] } ],
            stepsMax = Replace[ kspec, { { _, hi_ } :> hi, { k_ } :> k, UpTo[ k_ ] :> k } ],
            stepsQ   = Replace[ kspec, {
              Infinity     :> ( True & ),
              { k_ }       :> ( # == k & ),
              { lo_, hi_ } :> ( lo <= # <= hi & ),
              UpTo[ k_ ]   :> ( # <= k & ) } ],
            oriented = If[ direction === "Backward", Reverse @ walk0, walk0 ] },
          { kmax    = Replace[ absSpec, { { _, hi_ } :> hi, { k_ } :> k, UpTo[ k_ ] :> k } ],
            lengthQ = Replace[ absSpec, {
              Infinity     :> ( True & ),
              UpTo[ k_ ]   :> ( Length[ # ] - 1 <= k & ),
              { k_ }       :> ( Length[ # ] - 1 == k & ),
              { lo_, hi_ } :> ( lo <= Length[ # ] - 1 <= hi & ) } ],
            step = { walk, la, ra } |->
              With[ { backCands = If[ la < stepsMax, cands @ Reverse @ walk, { } ],
                      fwdCands  = If[ ra < stepsMax, cands @ walk, { } ] },
                Join[
                  Which[
                    ! weighted,      Flatten[ Outer[ { Prepend[ Append[ walk, #2 ], #1 ], la + 1, ra + 1 } &, backCands, fwdCands, 1 ], 1 ],
                    ra < stepsMax,   Catenate[ ( b |-> ( { Prepend[ Append[ walk, # ], b ], la + 1, ra + 1 } & ) /@ cands @ Prepend[ walk, b ] ) /@ backCands ],
                    True,            { } ],
                  { Append[ walk, # ], la, ra + 1 } & /@ fwdCands,
                  { Prepend[ walk, # ], la + 1, ra } & /@ backCands ] ] },
          (* the hot loops reach the closures through an Association, an atom, so no closure call or With renames their bodies *)
          { engine = <| "Candidates" -> cands, "Step" -> step, "Joined" -> joinedQ, "Stop" -> stopQ |> },
          { run = runCap |-> Which[
              Length[ walk0 ] >= 2 && AnyTrue[ rules, MatchQ[ #, { geodesicRule, _, 0 } ] && ! InfraGeodesicQ[ graph, walk0, #[[ 2 ]] ] & ], { },
              direction =!= "BothSides",
                If[ direction === "Backward", Reverse /@ # &, Identity ] @ With[
                  { descend = With[ { self = #0, walk = #1, found = #2 },
                      { nexts = If[ Length[ walk ] - 1 >= kmax || engine[ "Stop" ][ walk ], { }, engine[ "Candidates" ][ walk ] ] },
                      If[ nexts === { },
                        If[ lengthQ @ walk, Append[ found, walk ], found ],
                        Fold[ If[ Length @ #1 >= runCap, #1, self[ Append[ walk, #2 ], #1 ] ] &, found, nexts ] ] ] & },
                  descend[ oriented, { } ] ],
              True,
                With[ { descendBoth = With[ { self = #0, st = #1, state = #2 },
                      If[ KeyExistsQ[ Last @ state, st ], state,
                        With[ { marked = { First @ state, state[[ 2 ]], Append[ Last @ state, st -> True ] },
                                nexts  = If[ engine[ "Stop" ][ First @ st ], { },
                                  If[ sampler, Take[ #, UpTo[ 1 ] ] &, Identity ] @
                                    Select[ engine[ "Step" ][ Sequence @@ st ], engine[ "Joined" ][ First @ # ] & ] ] },
                          Which[
                            nexts =!= { },
                              Fold[ If[ Length @ First @ #1 >= runCap, #1, self[ #2, #1 ] ] &, marked, nexts ],
                            stepsQ[ Max @ Rest @ st ] && ! KeyExistsQ[ marked[[ 2 ]], First @ st ],
                              { Append[ First @ marked, First @ st ], Append[ marked[[ 2 ]], First @ st -> True ], Last @ marked },
                            True, marked ] ] ] ] & },
                  First @ descendBoth[ { walk0, 0, 0 }, { { }, <| |>, <| |> } ] ] ] },
          If[ sampler, Catenate @ Table[ run[ 1 ], Replace[ count, { Automatic -> 1, UpTo[ n_ ] :> n } ] ], run[ cap ] ] ] ],
      germWalks @ germ ] },
    With[ { walks = If[ sampler, Identity, DeleteDuplicates ][
          ( seq |-> PathGraph[ MapIndexed[ { First @ #2, #1 } &, seq ], DirectedEdges -> True ] ) /@
            If[ sampler, Identity, DeleteDuplicates ][ Catenate @ results ] ] },
        Switch[ count,
          Automatic, First[ walks, { } ],
          All,       walks,
          _UpTo,     Take[ walks, count ],
          _,         If[ Length @ walks < count, { }, Take[ walks, count ] ] ] ] ]

Options[ RandomInfraGeodesic ] = {
  Properties           -> { },
  "StoppingCondition"  -> None,
  "NextVertexFunction" -> Automatic,
  "Direction"          -> "Forward",
  RandomSeeding        -> Automatic
}

RandomInfraGeodesic[ args___ ] /; FreeQ[ { args }, RandomSeeding -> None, { 1 } ] :=
  With[ { result = BlockRandom[
      RandomInfraGeodesic[ Sequence @@ DeleteCases[ { args }, RandomSeeding -> _ ], RandomSeeding -> None ],
      RandomSeeding -> FirstCase[ { args }, ( RandomSeeding -> seed_ ) :> seed, Automatic ] ] },
    result /; ! MatchQ[ result, HoldPattern[ RandomInfraGeodesic[ ___, RandomSeeding -> None ] ] ] ]

RandomInfraGeodesic[ graph_Graph, germ_, scale : ( _Integer?Positive | Infinity ), opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( ( VertexQ[ graph, germ ] || ! MatchQ[ germ, _InfraWalk | _InfraGeodesic ] ) &&
    SubsetQ[ First /@ Options[ RandomInfraGeodesic ], First /@ { opts } ] ) :=
  With[ { result = RandomInfraGeodesic[ graph, germ, scale, Infinity, Automatic, opts ] },
    result /; Head[ result ] =!= RandomInfraGeodesic ]

RandomInfraGeodesic[ graph_Graph, germ_,
    scale : ( _Integer?Positive | Infinity ),
    kspec : ( UpTo[ _Integer ] | { _Integer } | { _Integer, _Integer } | Infinity ),
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( ( VertexQ[ graph, germ ] || ! MatchQ[ germ, _InfraWalk | _InfraGeodesic ] ) &&
    SubsetQ[ First /@ Options[ RandomInfraGeodesic ], First /@ { opts } ] ) :=
  With[ { result = RandomInfraWalk[ graph, germ, kspec, count,
      Properties -> Prepend[ OptionValue[ RandomInfraGeodesic, { opts }, Properties ], { "Geodesic", "Window" -> scale } ],
      Sequence @@ FilterRules[ { opts }, Except[ Properties ] ] ] },
    result /; Head[ result ] =!= RandomInfraWalk ]

InfraGeodesicQ[ graph_Graph, ws : { __Graph }, scale : ( _Integer?Positive | Infinity ) : Infinity ] :=
  AllTrue[ ws, InfraGeodesicQ[ graph, #, scale ] & ]

InfraGeodesicQ[ graph_Graph, w_Graph, scale : ( _Integer?Positive | Infinity ) : Infinity ] :=
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
    scale : ( _Integer?Positive | Infinity ) : Infinity ] /; Length[ walk ] >= 2 :=
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

RandomInfraGeodesic[ graph_Graph, InfraGeodesic[ germ : { __ }, scale : ( _Integer?Positive | Infinity ) ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( SubsetQ[ { "NextVertexFunction", RandomSeeding }, First /@ { opts } ] &&
    ( OptionValue[ RandomInfraGeodesic, { opts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) ) :=
  With[ { walks = RandomInfraGeodesic[ graph, germ, scale, Infinity, count,
      Properties -> { "Simple" }, "Direction" -> "BothSides",
      "NextVertexFunction" -> OptionValue[ RandomInfraGeodesic, { opts }, "NextVertexFunction" ], RandomSeeding -> None ] },
    Replace[ walks, { w_Graph :> Last /@ SortBy[ VertexList @ w, First ], l_List :> ( Last /@ SortBy[ VertexList @ #, First ] & ) /@ l } ] /; ! MatchQ[ walks, _RandomInfraGeodesic ] ]

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

(* at scale Infinity a maximal geodesic through the germ is a line through it, and the readings are the dynamic programming on the atoms of
   InfraInfiniteLine[germ]; at a finite scale the members are simple, a rule no window graph sees, so the readings list them: the members being
   simple, a vertex's count of visits over them is the number of members through it *)

InfraMeasurement[ graph_Graph, InfraGeodesic[ germ : { __ }, Infinity ], property : "VertexDensity" | "EdgeDensity" | "Cardinality" | "Length" ] /;
    AllTrue[ germ, VertexQ[ graph, # ] & ] && ( Length[ germ ] == 1 || InfraGeodesicQ[ graph, germ, Infinity ] ) :=
  InfraMeasurement[ graph, InfraInfiniteLine[ germ ], property ]

InfraMemberQ[ graph_Graph, InfraGeodesic[ germ : { __ }, Infinity ], path_List ] /;
    AllTrue[ germ, VertexQ[ graph, # ] & ] && ( Length[ germ ] == 1 || InfraGeodesicQ[ graph, germ, Infinity ] ) :=
  InfraMemberQ[ graph, InfraInfiniteLine[ germ ], path ]

InfraMeasurement[ graph_Graph, geodesic : InfraGeodesic[ germ : { __ }, scale_Integer?Positive ],
    property : "VertexDensity" | "EdgeDensity" | "Cardinality" | "Length" ] /;
    AllTrue[ germ, VertexQ[ graph, # ] & ] && ( Length[ germ ] == 1 || InfraGeodesicQ[ graph, germ, scale ] ) :=
  With[ { members = RandomInfraGeodesic[ graph, geodesic, All, RandomSeeding -> None ] },
    Switch[ property,
      "VertexDensity", KeySort @ Counts @ Catenate @ members,
      "EdgeDensity",   KeySort @ Counts @ Catenate[ ( member |-> DirectedEdge @@@ Partition[ member, 2, 1 ] ) /@ members ],
      "Cardinality",   Length @ members,
      "Length",        Replace[ Union[ Length /@ members - 1 ], { one_ } :> one ] ] ]

InfraMemberQ[ graph_Graph, geodesic : InfraGeodesic[ germ : { __ }, scale_Integer?Positive ], path_List ] /;
    AllTrue[ germ, VertexQ[ graph, # ] & ] && ( Length[ germ ] == 1 || InfraGeodesicQ[ graph, germ, scale ] ) :=
  MemberQ[ RandomInfraGeodesic[ graph, geodesic, All, RandomSeeding -> None ], path ]

(* the density of a literal walk counts its visits to each vertex *)

InfraMeasurement[ graph_Graph, InfraWalk[ vertices__ ], "VertexDensity" ] /; InfraWalkQ[ graph, { vertices } ] :=
  KeySort @ Counts @ { vertices }

InfraMeasurement[ graph_Graph, InfraWalk[ vertices_List ], "VertexDensity" ] /; InfraWalkQ[ graph, vertices ] :=
  KeySort @ Counts @ vertices

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

RandomInfraWalk[ graph_Graph, InfraWalk[ vs : Repeated[ _, { 2, Infinity } ] ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( SubsetQ[ { "NextVertexFunction", RandomSeeding }, First /@ { opts } ] &&
    ( OptionValue[ RandomInfraWalk, { opts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) ) :=
  With[ { members = If[ Length[ { vs } ] >= 2 &&
          AllTrue[ Partition[ { vs }, 2, 1 ], EdgeQ[ graph, UndirectedEdge @@ # ] & ], { { vs } }, { } ],
          nextFn = OptionValue[ RandomInfraWalk, { opts }, "NextVertexFunction" ] },
    { ordered = Sort @ members },
    Which[
      count === Automatic, If[ ordered === { }, { }, If[ nextFn === Identity, First @ ordered, RandomChoice @ ordered ] ],
      count === All,       members,
      nextFn === Identity, If[ IntegerQ @ count && Length @ ordered < count, { }, Take[ ordered, count ] ],
      IntegerQ @ count && Length @ ordered < count, { },
      True, RandomSample[ ordered, count ] ] ]
