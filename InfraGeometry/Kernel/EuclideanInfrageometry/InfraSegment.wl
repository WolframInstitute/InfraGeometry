Package[ "WolframInstitute`InfraGeometry`" ]

Options[ RandomInfraSegment ] = { "NextVertexFunction" -> Automatic }

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraSegment *)

(* InfraSegment[p1, ..., pk] is inert: the polyline of the segments [p_i, p_(i+1)], k >= 2, and for k == 2 the segment itself.  Its graph is the
   interval DAG I(p, q) = { v : d(p, v) + d(v, q) == d(p, q) } with the arrows v -> w of rising d(p, .), whose chains are exactly the geodesics from
   p to q (design Thm. segment), and for a polyline the List of the pieces' DAGs, a member concatenating one chain per piece *)

InfraMeasurement[ graph_Graph,
    InfraSegment[ p : Except[ _Rule | _RuleDelayed ], q : Except[ _Rule | _RuleDelayed ] ], "Graph" ] :=
  With[ { sources = Keys @ InfraDensity[ graph, p ], targets = Keys @ InfraDensity[ graph, q ] },
    { dp = AssociationThread[ VertexList @ graph, Min /@ Transpose[ GraphDistance[ graph, # ] & /@ sources ] ],
      dq = AssociationThread[ VertexList @ graph, Min /@ Transpose[ GraphDistance[ graph, # ] & /@ targets ] ] },
    { d = Min @ Lookup[ dp, Key /@ targets ] },
    { interval = If[ d === Infinity, { },
        Select[ VertexList @ graph, Lookup[ dp, Key @ # ] + Lookup[ dq, Key @ # ] == d & ] ] },
    { inside = AssociationThread[ interval, True ] },
    Graph[ interval,
      Catenate @ Map[
        v |-> DirectedEdge[ v, # ] & /@ Select[ AdjacencyList[ graph, v ],
          TrueQ @ Lookup[ inside, Key @ # ] && Lookup[ dp, Key @ # ] == Lookup[ dp, Key @ v ] + 1 & ],
        interval ] ] ]

InfraMeasurement[ graph_Graph,
    segment : InfraSegment[ Except[ _Rule | _RuleDelayed ], Except[ _Rule | _RuleDelayed ] ], "Midpoint" ] :=
  With[ { dag = InfraMeasurement[ graph, segment, "Graph" ] },
    { density = InfraMeasurement[ graph, segment, "VertexDensity" ] },
    { sources = Select[ VertexList @ dag, VertexInDegree[ dag, # ] == 0 & ] },
    { layers = AssociationMap[ v |-> Min[ GraphDistance[ dag, #, v ] & /@ sources ], VertexList @ dag ] },
    { offsets = Abs[ 2 layers - Max[ 0, Values @ layers ] ] },
    If[ VertexCount @ dag == 0, <| |>,
      KeySort @ KeyTake[ density, Keys @ Select[ offsets, # == Min @ offsets & ] ] ] ]

InfraMeasurement[ graph_Graph,
    InfraSegment[ pts : Repeated[ Except[ _Rule | _RuleDelayed ], { 3, Infinity } ] ], "Graph" ] :=
  InfraMeasurement[ graph, InfraSegment @@ #, "Graph" ] & /@ Partition[ { pts }, 2, 1 ]

InfraMeasurement[ graph_Graph,
    InfraSegment[ pts : Repeated[ Except[ _Rule | _RuleDelayed ], { 3, Infinity } ] ], "Cardinality" ] :=
  Times @@ ( InfraMeasurement[ graph, InfraSegment @@ #, "Cardinality" ] & /@ Partition[ { pts }, 2, 1 ] )

InfraMeasurement[ graph_Graph,
    InfraSegment[ pts : Repeated[ Except[ _Rule | _RuleDelayed ], { 3, Infinity } ] ], "Length" ] :=
  Total[ GraphDistance[ graph, #1, #2 ] & @@@ Partition[ { pts }, 2, 1 ] ]

RandomInfraSegment[ graph_Graph,
    segment : InfraSegment[ p : Except[ _Rule | _RuleDelayed ], mid : Repeated[ Except[ _Rule | _RuleDelayed ], { 1, Infinity } ], p_ ],
    Automatic, opts : OptionsPattern[ RandomInfraSegment ] ] /; SubsetQ[ First /@ Options[ RandomInfraSegment ], First /@ { opts } ] &&
    OptionValue[ RandomInfraSegment, { opts }, "NextVertexFunction" ] === Identity :=
  Replace[ With[ { sides = Partition[ { p, mid, p }, 2, 1 ] },
    { dags = InfraMeasurement[ graph, InfraSegment @@ #, "Graph" ] & /@ sides },
    { arcs = Catenate @ MapIndexed[ { dag, i } |-> ( { First @ i, # } & /@ EdgeList @ dag ), dags ] },
    { x = Array[ \[FormalX], Length @ arcs ] },
    { outOf = GroupBy[ Transpose[ { arcs, x } ], ( { #[[ 1, 1 ]], #[[ 1, 2, 1 ]] } & ) -> Last, Total ],
      into = GroupBy[ Transpose[ { arcs, x } ], ( { #[[ 1, 1 ]], #[[ 1, 2, 2 ]] } & ) -> Last, Total ],
      load = GroupBy[ Transpose[ { arcs, x } ], ( Sort[ List @@ #[[ 1, 2 ]] ] & ) -> Last, Total ] },
    { solution = Which[ AnyTrue[ dags, VertexCount[ # ] == 0 & ], $Failed, arcs === { }, { }, True,
        Quiet @ LinearOptimization[ 0,
          Join[
            Catenate @ MapIndexed[ { dag, i } |-> Map[
                v |-> Lookup[ outOf, Key @ { First @ i, v }, 0 ] - Lookup[ into, Key @ { First @ i, v }, 0 ] ==
                  Which[ SameQ @@ sides[[ First @ i ]], 0, v === sides[[ First @ i, 1 ]], 1, v === sides[[ First @ i, 2 ]], -1, True, 0 ],
                VertexList @ dag ], dags ],
            Thread[ Values @ load <= 1 ], Thread[ 0 <= x <= 1 ] ],
          x \[Element] Vectors[ Length @ arcs, Integers ] ] ] },
    If[ ! MatchQ[ solution, { ___Rule } ] || ! FreeQ[ solution, Indeterminate ], { },
      With[ { chosen = Pick[ arcs, Round[ x /. solution ], 1 ] },
        Fold[ Join[ #1, Rest @ #2 ] &,
          MapIndexed[ { side, i } |-> If[ SameQ @@ side, { First @ side }, TopologicalSort @ Graph[ Cases[ chosen, { First @ i, arc_ } :> arc ] ] ],
            sides ] ] ] ] ],
    { } :> First[ RandomInfraSegment[ graph, segment, UpTo[ 1 ], "NextVertexFunction" -> Identity ], { } ] ]

RandomInfraSegment[ graph_Graph,
    InfraSegment[ pts : Repeated[ Except[ _Rule | _RuleDelayed ], { 3, Infinity } ] ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /; SubsetQ[ First /@ Options[ RandomInfraSegment ], First /@ { opts } ] &&
    ( OptionValue[ RandomInfraSegment, { opts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) :=
  With[ { sides = Partition[ { pts }, 2, 1 ],
          nextFn = OptionValue[ RandomInfraSegment, { opts }, "NextVertexFunction" ] },
    { cardinality = Times @@ ( InfraMeasurement[ graph, InfraSegment @@ #, "Cardinality" ] & /@ sides ) },
    { cap = Replace[ count, { Automatic -> 1, UpTo[ n_ ] :> n } ] },
    { sampleOne = ignored |-> With[
        { members = RandomInfraSegment[ graph, InfraSegment @@ #, Automatic,
            "NextVertexFunction" -> nextFn ] & /@ sides },
        If[ MemberQ[ members, { } ], { },
          Fold[ Join[ #1, Rest @ #2 ] &, First @ members, Rest @ members ] ] ] },
    { enumerate = ignored |-> With[
        { pieces = RandomInfraSegment[ graph, InfraSegment @@ #, All,
            "NextVertexFunction" -> nextFn ] & /@ sides },
        Fold[ { as, bs } |-> Catenate @ Map[ a |-> ( Join[ a, Rest @ # ] & /@ bs ), as ],
          First @ pieces, Rest @ pieces ] ] },
    { members = Which[
        count === Automatic, { sampleOne[ Null ] },
        count === All, enumerate[ Null ],
        nextFn === RandomChoice,
          If[ cap > cardinality && ! MatchQ[ count, _UpTo ], { },
            First @ NestWhile[
              state |-> With[ { member = sampleOne[ Null ] },
                If[ MemberQ[ First @ state, member ], state, { Append[ First @ state, member ], Last @ state + 1 } ] ],
              { { }, 0 },
              Last @ # < If[ MatchQ[ count, _UpTo ], Min[ cap, cardinality ], cap ] & ] ],
        nextFn === Automatic,
          Which[
            cap > cardinality && ! MatchQ[ count, _UpTo ], { },
            2 cap >= cardinality, RandomSample[ enumerate[ Null ], count ],
            True,
              First @ NestWhile[
                state |-> With[ { member = sampleOne[ Null ] },
                  If[ MemberQ[ First @ state, member ], state, { Append[ First @ state, member ], Last @ state + 1 } ] ],
                { { }, 0 }, Last @ # < cap & ] ],
        True, enumerate[ Null ] ] },
    Switch[ count,
      Automatic, First[ members, { } ],
      All,       members,
      _UpTo,     If[ nextFn === Automatic, members, Take[ members, count ] ],
      _,         If[ Length @ members < count, { }, Take[ members, count ] ] ] ]

InfraMeasurement[ graph_Graph,
    InfraSegment[ pts : Repeated[ Except[ _Rule | _RuleDelayed ], { 3, Infinity } ] ], "VertexDensity" ] :=
  With[ { pieces = InfraSegment @@@ Partition[ { pts }, 2, 1 ] },
    { counts = InfraMeasurement[ graph, #, "Cardinality" ] & /@ pieces },
    KeySort @ DeleteCases[ 0 ] @ Merge[
      Append[
        MapIndexed[ { piece, i } |-> ( Times @@ Delete[ counts, i ] ) InfraMeasurement[ graph, piece, "VertexDensity" ], pieces ],
        - ( Times @@ counts ) Counts @ Take[ { pts }, { 2, -2 } ] ],
      Total ] ]

InfraMeasurement[ graph_Graph,
    InfraSegment[ pts : Repeated[ Except[ _Rule | _RuleDelayed ], { 3, Infinity } ] ], "EdgeDensity" ] :=
  With[ { pieces = InfraSegment @@@ Partition[ { pts }, 2, 1 ] },
    { counts = InfraMeasurement[ graph, #, "Cardinality" ] & /@ pieces },
    KeySort @ DeleteCases[ 0 ] @ Merge[
      MapIndexed[ { piece, i } |-> ( Times @@ Delete[ counts, i ] ) InfraMeasurement[ graph, piece, "EdgeDensity" ], pieces ],
      Total ] ]


(* the knots cut the path at prescribed positions: every chain of the piece p_i -> p_(i+1) has length d(p_i, p_(i+1)) *)

InfraMemberQ[ graph_Graph,
    InfraSegment[ pts : Repeated[ Except[ _Rule | _RuleDelayed ], { 3, Infinity } ] ], path_List ] :=
  With[ { pieces = Partition[ { pts }, 2, 1 ] },
    { cuts = Accumulate @ Prepend[ GraphDistance[ graph, #1, #2 ] & @@@ pieces, 1 ] },
    Last @ cuts == Length @ path &&
      AllTrue[ Range @ Length @ pieces,
        i |-> InfraMemberQ[ graph, InfraSegment @@ pieces[[ i ]], Take[ path, { cuts[[ i ]], cuts[[ i + 1 ]] } ] ] ] ]

(* a geodesic (p = v0, v1, ..., vk = q) with k = d(p, q), as a vertex list -- the substrate searched directly by FindPath, independently of the
   interval DAG.  The count-less call is one geodesic, a bounded count a List of them, All the whole class *)

RandomInfraSegment[ graph_Graph, p_, q_,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[ RandomInfraSegment ] ] /; ( VertexQ[ graph, p ] || ! MatchQ[ p, _InfraSegment ] ) &&
    SubsetQ[ First /@ Options[ RandomInfraSegment ], First /@ { opts } ] :=
  RandomInfraSegment[ graph, InfraSegment[ p, q ], count, opts ]

InfraWalkQ[ graph_Graph, ws : { __Graph } ] :=
  AllTrue[ ws, InfraWalkQ[ graph, # ] & ]

InfraWalkQ[ graph_Graph, w_Graph ] :=
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
      InfraWalkQ[ graph, # ] & ] ]

InfraWalkQ[ graph_Graph, path_List ] /; Length[ path ] >= 2 :=
  AllTrue[ Partition[ path, 2, 1 ], EdgeQ[ graph, UndirectedEdge @@ # ] & ]

InfraWalkQ[ _Graph, path_List ] /; Length[ path ] < 2 :=
  False

(* consecutive vertices adjacent and the total edge count equal to d(v0, vk); a graph -- one path or a DAG -- passes iff every walk it stands for
   does *)

InfraSegmentQ[ graph_Graph, ws : { __Graph } ] :=
  AllTrue[ ws, InfraSegmentQ[ graph, # ] & ]

InfraSegmentQ[ graph_Graph, ws : { { ___ } .. } ] :=
  AllTrue[ ws, InfraSegmentQ[ graph, # ] & ]

InfraSegmentQ[ graph_Graph, w_Graph ] :=
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
      InfraSegmentQ[ graph, # ] & ] ]

InfraSegmentQ[ graph_Graph, segment_List ] /; Length[ segment ] >= 2 :=
  GraphDistance[ graph, First[ segment ], Last[ segment ] ] == Length[ segment ] - 1 &&
  AllTrue[ Partition[ segment, 2, 1 ], EdgeQ[ graph, UndirectedEdge @@ # ] & ]

InfraSegmentQ[ _Graph, segment_List ] /; Length[ segment ] < 2 :=
  False

UniqueInfraSegmentQ[ graph_Graph, u_, v_ ] :=
  InfraMeasurement[ graph, InfraSegment[ u, v ], "Cardinality" ] == 1

UniqueInfraSegmentQ[ graph_Graph ] :=
  AllTrue[ Subsets[ VertexList[ graph ], { 2 } ],
    pair |-> UniqueInfraSegmentQ[ graph, pair[[ 1 ]], pair[[ 2 ]] ] ]

RandomInfraSegment[ graph_Graph,
    obj : InfraSegment[ Except[ _Rule | _RuleDelayed ], Except[ _Rule | _RuleDelayed ] ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /; SubsetQ[ First /@ Options[ RandomInfraSegment ], First /@ { opts } ] &&
    ( OptionValue[ RandomInfraSegment, { opts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) :=
  With[ {
      cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ],
      nextFn = OptionValue[ RandomInfraSegment, { opts }, "NextVertexFunction" ],
      dags = Select[ Replace[ InfraMeasurement[ graph, obj, "Graph" ], dag_Graph :> { dag } ], VertexCount[ # ] > 0 & ] },
    { engines = Map[
        dag |-> With[ { out = GroupBy[ List @@@ EdgeList @ dag, First -> Last ] },
          { beta = Fold[ { a, w } |-> Append[ a, w -> Replace[ Lookup[ out, Key @ w, { } ],
                  { { } -> 1, qs_ :> Total @ Lookup[ a, Key /@ qs ] } ] ],
              <| |>, Reverse @ TopologicalSort @ dag ] },
          { out, beta, Sort @ Pick[ VertexList @ dag, VertexInDegree @ dag, 0 ] } ],
        dags ] },
    { draw = { out, beta, sources } |->
        NestWhile[
          path |-> With[ { nexts = Lookup[ out, Key @ Last @ path, { } ] },
            Append[ path, RandomChoice[ Lookup[ beta, Key /@ nexts ] -> nexts ] ] ],
          { RandomChoice[ Lookup[ beta, Key /@ sources ] -> sources ] },
          path |-> Lookup[ out, Key @ Last @ path, { } ] =!= { } ] },
    { randomDraw = ignored |-> If[ engines === { }, { },
        With[ { weights = Total @ Lookup[ #[[ 2 ]], Key /@ #[[ 3 ]] ] & /@ engines },
          draw @@ RandomChoice[ weights -> engines ] ] ] },
    { enumerate = limit |-> Catenate @ Last @ Reap @ Fold[
          { found, engine } |-> With[ { out = First @ engine },
            Last @ NestWhile[
              Apply[ { stack, got } |-> With[ { path = First @ stack },
                { nexts = Sort @ Lookup[ out, Key @ Last @ path, { } ] },
                { selected = If[ nexts === { } || nextFn === Automatic, nexts,
                    Replace[ nextFn @ nexts,
                      candidate_ /; MemberQ[ nexts, Verbatim @ candidate ] :> { candidate } ] ] },
                If[ nexts === { },
                  ( Sow[ path ]; { Rest @ stack, got + 1 } ),
                  { Join[ Append[ path, # ] & /@ selected, Rest @ stack ],
                    got } ] ] ],
              { List /@ Last @ engine, found },
              state |-> First @ state =!= { } && Last @ state < limit ] ],
          0, engines ] },
    { randomWalk = ignored |-> First[ enumerate @ 1, { } ] },
    { cardinality = Total @ ( Total @ Lookup[ #[[ 2 ]], Key /@ #[[ 3 ]] ] & /@ engines ) },
    { members = Which[
        count === Automatic && nextFn === Automatic,
          { randomDraw[ Null ] },
        nextFn === RandomChoice,
          If[ cap > cardinality && ! MatchQ[ count, _UpTo ], { },
            First @ NestWhile[
              state |-> With[ { member = randomWalk[ Null ] },
                If[ MemberQ[ First @ state, member ], state, { Append[ First @ state, member ], Last @ state + 1 } ] ],
              { { }, 0 },
              Last @ # < If[ MatchQ[ count, _UpTo ], Min[ cap, cardinality ], cap ] & ] ],
        nextFn =!= Automatic,
          enumerate @ cap,
        count === All,
          enumerate @ Infinity,
        cap > cardinality && ! MatchQ[ count, _UpTo ],
          { },
        2 cap >= cardinality,
          RandomSample[ enumerate @ Infinity, Replace[ count, UpTo[ n_ ] :> UpTo[ n ] ] ],
        True,
          First @ NestWhile[
            state |-> With[ { member = randomDraw[ Null ] },
              If[ MemberQ[ First @ state, member ], state, { Append[ First @ state, member ], Last @ state + 1 } ] ],
            { { }, 0 },
            Last @ # < cap & ] ] },
    Switch[ count,
      Automatic, First[ members, { } ],
      All,       members,
      _UpTo,     If[ nextFn === Automatic, members, Take[ members, count ] ],
      _,         If[ Length[ members ] < count, { }, Take[ members, count ] ] ] ]
