Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraSegment *)

(* InfraSegment[p1, ..., pk] is inert: the polyline of the segments [p_i, p_(i+1)], k >= 2, and for k == 2 the segment itself.  Its graph is the
   interval DAG I(p, q) = { v : d(p, v) + d(v, q) == d(p, q) } with the arrows v -> w of rising d(p, .), whose chains are exactly the geodesics from
   p to q (design Thm. segment), and for a polyline the List of the pieces' DAGs, a member concatenating one chain per piece *)

InfraMeasurement[ graph_Graph,
    InfraSegment[ p : Except[ _Rule | _RuleDelayed ], q : Except[ _Rule | _RuleDelayed ] ], "Graph" ] :=
  With[ { dp = AssociationThread[ VertexList @ graph, GraphDistance[ graph, p ] ],
          dq = AssociationThread[ VertexList @ graph, GraphDistance[ graph, q ] ] },
    { d = Lookup[ dp, Key @ q ] },
    { interval = If[ d === Infinity, { },
        Select[ VertexList @ graph, Lookup[ dp, Key @ # ] + Lookup[ dq, Key @ # ] == d & ] ] },
    { inside = AssociationThread[ interval, True ] },
    Graph[ interval,
      Catenate @ Map[
        v |-> DirectedEdge[ v, # ] & /@ Select[ AdjacencyList[ graph, v ],
          TrueQ @ Lookup[ inside, Key @ # ] && Lookup[ dp, Key @ # ] == Lookup[ dp, Key @ v ] + 1 & ],
        interval ] ] ]

InfraMeasurement[ graph_Graph,
    InfraSegment[ pts : Repeated[ Except[ _Rule | _RuleDelayed ], { 3, Infinity } ] ], "Graph" ] :=
  InfraMeasurement[ graph, InfraSegment @@ #, "Graph" ] & /@ Partition[ { pts }, 2, 1 ]

InfraMeasurement[ graph_Graph,
    InfraSegment[ pts : Repeated[ Except[ _Rule | _RuleDelayed ], { 3, Infinity } ] ], "Cardinality" ] :=
  Times @@ ( InfraMeasurement[ graph, InfraSegment @@ #, "Cardinality" ] & /@ Partition[ { pts }, 2, 1 ] )

InfraMeasurement[ graph_Graph,
    InfraSegment[ pts : Repeated[ Except[ _Rule | _RuleDelayed ], { 3, Infinity } ] ], "Length" ] :=
  Total[ GraphDistance[ graph, #1, #2 ] & @@@ Partition[ { pts }, 2, 1 ] ]

(* the one witness of a closed polyline retraces none of its edges when some member does not, a polygon being a simple closed curve; otherwise it
   is the first member *)

FindInfraRepresentative[ graph_Graph,
    segment : InfraSegment[ p : Except[ _Rule | _RuleDelayed ], mid : Repeated[ Except[ _Rule | _RuleDelayed ] ], p_ ],
    Optional[ Automatic, Automatic ] ] :=
  Replace[ edgeFreshChain[ graph, { p, mid, p } ], { } :> First[ FindInfraRepresentative[ graph, segment, UpTo[ 1 ] ], { } ] ]

FindInfraRepresentative[ graph_Graph,
    InfraSegment[ pts : Repeated[ Except[ _Rule | _RuleDelayed ], { 3, Infinity } ] ],
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, mods___ ] :=
  With[ { cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ] },
    { pieces = FindInfraRepresentative[ graph, InfraSegment @@ #, If[ cap === Infinity, All, UpTo[ cap ] ], mods ] & /@
        Partition[ { pts }, 2, 1 ] },
    { members = Fold[ { as, bs } |-> Catenate @ Map[ a |-> ( Join[ a, Rest @ # ] & /@ bs ), as ],
        First @ pieces, Rest @ pieces ] },
    Switch[ count,
      Automatic, First[ members, { } ],
      All,       members,
      _UpTo,     Take[ members, count ],
      _,         If[ Length @ members < count, { }, Take[ members, count ] ] ] ]

(* a member with no edge twice, or { } when there is none, as a 0-1 program: on side i a unit flow x through its interval DAG from p_i to p_(i+1),
   which is one geodesic since the DAG is acyclic, and every edge of the graph carried by at most one side in either direction *)

edgeFreshChain[ graph_Graph, corners_List ] :=
  With[ { sides = Partition[ corners, 2, 1 ] },
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
            sides ] ] ] ] ]

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

FindInfraSegment[ graph_Graph, p_, q_,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic ] :=
  With[ { d = GraphDistance[ graph, p, q ],
          cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ] },
    { geodesics = Which[
        d === Infinity, { },
        d === 0,        { { p } },
        True,           FindPath[ graph, p, q, { d }, Replace[ cap, Infinity -> All ] ] ] },
    Switch[ count,
      Automatic, First[ geodesics, { } ],
      All,       geodesics,
      _UpTo,     Take[ geodesics, count ],
      _,         If[ Length @ geodesics < count, { }, Take[ geodesics, count ] ] ] ]

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
