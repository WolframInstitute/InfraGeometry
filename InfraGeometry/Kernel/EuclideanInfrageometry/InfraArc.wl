Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraArc *)

(* InfraArc[c, {p, q}] is inert: the minor arcs of the circles around c through p and q, a minor arc being a geodesic of the band graph A = G[W] on
   the band W = { v : rmin <= d(c, v) <= rmax } of the circle through p, widened by "RadiusDelta" -> dOut | {dIn, dOut}.  Its graph is the interval
   DAG I_A(p, q) = { v in W : d_A(p, v) + d_A(v, q) == d_A(p, q) } with the arrows of rising d_A(p, .), whose chains are exactly those geodesics --
   and hence, under the winding functional (W) and for p, q on a common circle, exactly the minor arcs, all of length d_A(p, q) (design Thm.
   arc).  Neither hypothesis is certified here, so "Faithful" is Undetermined.  More points give the polyline of the consecutive minor arcs, each
   read on the band of the circle through its own first point -- one band, since the arc asks its points to lie on a common circle *)

(* InfraArc[c, {p, p}], and its shorthand InfraArc[c, {p}], is the closed arc: the circles through p on the band of p.  The band is cut open along
   a radial seam through p -- the band part of a geodesic from c through p to just outside the band -- and the arc leaves p to one side of the
   seam and returns from the other.  Its graph is the List of necklaces of that seam whose run meets p: on a run S = (s1, ..., sm) the necklace
   N(S, u, v), with u ~ s1 and v ~ sm in one component of the cut band A - V(sigma), is s1 -> ... -> sm -> v together with the interval DAG of the
   cut band from v to u, the closing arrow u -> s1 left out, so its chains are exactly the cycles S v gamma u, all of the one length m + 1 + d(v, u)
   (design Thm. seam).  Kept are the necklaces of least length among those whose cycles separate c from beyond the band.  They are every circle
   through p exactly once under (W) and the one-run hypothesis (T).  InfraArc[c, {p1, ..., pk, p1}] keeps of each necklace the chains through p2,
   ..., pk: the union of the interval DAGs between their consecutive copies, in the necklace's own order *)

InfraMeasurement[ graph_Graph, InfraArc[ center_, pts : ( { p_, ___, p_ } | { p_ } ), opts___Rule ], "Graph" ] :=
  With[ { dist = AssociationThread[ VertexList @ graph, GraphDistance[ graph, center ] ],
          delta = Replace[ Lookup[ { opts }, "RadiusDelta", 0 ], d : Except[ _List ] :> { 0, d } ] },
    { rmin = Max[ 1, Lookup[ dist, Key @ p ] - First @ delta ], rmax = Lookup[ dist, Key @ p ] + Last @ delta },
    { local = Subgraph[ graph, Select[ VertexList @ graph, Lookup[ dist, Key @ # ] <= rmax + 1 & ] ] },
    { outward = SelectFirst[
        SortBy[ Select[ VertexList @ local, Lookup[ dist, Key @ # ] > rmax & ], Lookup[ dist, Key @ # ] & ],
        Lookup[ dist, Key @ p ] + GraphDistance[ local, p, # ] == Lookup[ dist, Key @ # ] & ] },
    { radial = If[ MissingQ @ outward, { },
        Join[ FindShortestPath[ local, center, p ], Rest @ FindShortestPath[ local, p, outward ] ] ] },
    { seam = Select[ radial, rmin <= Lookup[ dist, Key @ # ] <= rmax & ],
      bandGraph = Subgraph[ local, Select[ VertexList @ local, rmin <= Lookup[ dist, Key @ # ] <= rmax & ] ] },
    { cut = VertexDelete[ bandGraph, seam ] },
    { cutVs = VertexList @ cut },
    { cdm = If[ cutVs === { }, { }, GraphDistanceMatrix @ cut ],
      cidx = AssociationThread[ cutVs, Range @ Length @ cutVs ] },
    { cd = cdm[[ cidx @ #1, cidx @ #2 ]] & },
    { necklaces = Catenate @ Map[
        run |-> Map[
          pair |-> With[ { u = First @ pair, v = Last @ pair },
            { duv = cd[ Last @ pair, First @ pair ] },
            { support = If[ duv === Infinity, { }, Select[ cutVs, cd[ v, # ] + cd[ #, u ] == duv & ] ] },
            { inside = AssociationThread[ support, True ] },
            If[ duv === Infinity, Nothing,
              <| "Length" -> Length @ run + duv + 1,
                 "Cycle"  -> Join[ run, FindShortestPath[ cut, v, u ] ],
                 "Graph"  -> Graph[ Join[ run, support ],
                   Join[ DirectedEdge @@@ Partition[ Append[ run, v ], 2, 1 ],
                     Catenate @ Map[
                       w |-> DirectedEdge[ w, # ] & /@ Select[ AdjacencyList[ cut, w ],
                         TrueQ @ Lookup[ inside, Key @ # ] && cd[ v, # ] == cd[ v, w ] + 1 & ],
                       support ] ] ] |> ] ],
          If[ Length @ run == 1,
            Subsets[ Intersection[ AdjacencyList[ bandGraph, First @ run ], cutVs ], { 2 } ],
            Tuples[ Intersection[ AdjacencyList[ bandGraph, # ], cutVs ] & /@ { First @ run, Last @ run } ] ] ],
        Select[ Catenate @ Table[ Take[ seam, { i, j } ], { i, Length @ seam }, { j, i, Length @ seam } ], MemberQ[ #, p ] & ] ] },
    { dags = Replace[
        Catch @ Scan[
          class |-> With[ { admissible = Select[ class,
                necklace |-> AllTrue[ VertexComponent[ VertexDelete[ local, necklace[ "Cycle" ] ], center ],
                  Lookup[ dist, Key @ # ] <= rmax & ] ] },
            If[ admissible =!= { }, Throw[ #[ "Graph" ] & /@ admissible ] ] ],
          Values @ KeySort @ GroupBy[ necklaces, #[ "Length" ] & ] ],
        Null -> { } ] },
    { through = DeleteCases[ DeleteDuplicates @ Rest @ pts, p ] },
    If[ through === { }, dags,
      Select[ VertexCount[ # ] > 0 & ] @ Map[
        dag |-> If[ ! SubsetQ[ VertexList @ dag, through ], Graph[ { }, { } ],
          With[ { order = TopologicalSort @ dag },
            { xs = SortBy[ through, FirstPosition[ order, # ] & ] },
            { segments = Join[ { VertexInComponent[ dag, First @ xs ] },
                MapThread[ Intersection[ VertexOutComponent[ dag, #1 ], VertexInComponent[ dag, #2 ] ] &, { Most @ xs, Rest @ xs } ],
                { VertexOutComponent[ dag, Last @ xs ] } ] },
            If[ MemberQ[ segments, { } ], Graph[ { }, { } ],
              Graph[ Union @@ segments, Union @@ ( EdgeList @ Subgraph[ dag, # ] & /@ segments ) ] ] ] ],
        dags ] ] ]

InfraMeasurement[ graph_Graph, obj : InfraArc[ _, { p_, ___, p_ } | { _ }, ___Rule ], "Length" ] :=
  Replace[
    Union @@ Map[
      dag |-> DeleteCases[ Infinity ] @ Union @ Flatten @ Table[ 1 + GraphDistance[ dag, s, t ],
          { s, Pick[ VertexList @ dag, VertexInDegree @ dag, 0 ] },
          { t, Pick[ VertexList @ dag, VertexOutDegree @ dag, 0 ] } ],
      InfraMeasurement[ graph, obj, "Graph" ] ],
    { one_ } :> one ]

InfraMeasurement[ graph_Graph, obj : InfraArc[ _, { p_, ___, p_ } | { _ }, ___Rule ], "EdgeDensity" ] :=
  KeySort @ Merge[
    Map[
      dag |-> With[ { inNbr = GroupBy[ EdgeList @ dag, Last -> First ],
                      outNbr = GroupBy[ EdgeList @ dag, First -> Last ],
                      order = TopologicalSort @ dag,
                      source = First @ Pick[ VertexList @ dag, VertexInDegree @ dag, 0 ],
                      sink = First @ Pick[ VertexList @ dag, VertexOutDegree @ dag, 0 ] },
        { alpha = Fold[ { a, w } |-> Append[ a, w -> Replace[ Lookup[ inNbr, Key @ w, { } ],
                { { } -> 1, ps_ :> Total @ Lookup[ a, Key /@ ps ] } ] ], <| |>, order ],
          beta = Fold[ { a, w } |-> Append[ a, w -> Replace[ Lookup[ outNbr, Key @ w, { } ],
                { { } -> 1, qs_ :> Total @ Lookup[ a, Key /@ qs ] } ] ], <| |>, Reverse @ order ] },
        Append[
          Association[ # -> Lookup[ alpha, Key @ First @ # ] Lookup[ beta, Key @ Last @ # ] & /@ EdgeList @ dag ],
          DirectedEdge[ sink, source ] -> Lookup[ alpha, Key @ sink ] ] ],
      InfraMeasurement[ graph, obj, "Graph" ] ],
    Total ]

InfraMemberQ[ graph_Graph, obj : InfraArc[ _, { p_, ___, p_ } | { _ }, ___Rule ], path_List ] :=
  path =!= { } &&
  AnyTrue[ InfraMeasurement[ graph, obj, "Graph" ],
    dag |-> AnyTrue[
      Join[ NestList[ RotateLeft, path, Length @ path - 1 ],
            NestList[ RotateLeft, Reverse @ path, Length @ path - 1 ] ],
      rot |-> VertexQ[ dag, First @ rot ] && VertexInDegree[ dag, First @ rot ] == 0 &&
        VertexQ[ dag, Last @ rot ] && VertexOutDegree[ dag, Last @ rot ] == 0 &&
        AllTrue[ Partition[ rot, 2, 1 ], EdgeQ[ dag, DirectedEdge @@ # ] & ] ] ]

(* the closed arc's search is the sweep: the shortest cycles of the band through p that separate c from beyond it, then those through every
   point of the list *)

FindInfraRepresentative[ graph_Graph, InfraArc[ center_, pts : ( { p_, ___, p_ } | { p_ } ), opts___Rule ],
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, mods___ ] :=
  With[ { dist = AssociationThread[ VertexList @ graph, GraphDistance[ graph, center ] ],
          delta = Replace[ Lookup[ { opts }, "RadiusDelta", 0 ], d : Except[ _List ] :> { 0, d } ] },
    { rmin = Max[ 1, Lookup[ dist, Key @ p ] - First @ delta ], rmax = Lookup[ dist, Key @ p ] + Last @ delta },
    { local = Subgraph[ graph, Select[ VertexList @ graph, Lookup[ dist, Key @ # ] <= rmax + 1 & ] ] },
    { bandGraph = Subgraph[ local, Select[ VertexList @ local, rmin <= Lookup[ dist, Key @ # ] <= rmax & ] ] },
    { circles = Replace[
        Catch @ Scan[
          k |-> With[ { found = Select[ First /@ # & /@ FindCycle[ bandGraph, { k }, All ],
                cycle |-> MemberQ[ cycle, p ] &&
                  AllTrue[ VertexComponent[ VertexDelete[ local, cycle ], center ], Lookup[ dist, Key @ # ] <= rmax & ] ] },
            If[ found =!= { }, Throw @ found ] ],
          Range[ 3, VertexCount @ bandGraph ] ],
        Null -> { } ] },
    takeRepresentatives[ Select[ circles, SubsetQ[ #, pts ] & ], count, mods ] ]

InfraMeasurement[ graph_Graph, InfraArc[ center_, { p_, q_ } /; p =!= q, opts___Rule ], "Graph" ] :=
  With[ { dist = AssociationThread[ VertexList @ graph, GraphDistance[ graph, center ] ],
          delta = Replace[ Lookup[ { opts }, "RadiusDelta", 0 ], d : Except[ _List ] :> { 0, d } ] },
    { r = Lookup[ dist, Key @ p ] },
    { band = Subgraph[ graph, Select[ VertexList @ graph,
        Max[ 1, r - First @ delta ] <= Lookup[ dist, Key @ # ] <= r + Last @ delta & ] ] },
    { vs = VertexList @ band },
    { dp = If[ MemberQ[ vs, p ], AssociationThread[ vs, GraphDistance[ band, p ] ], <| |> ],
      dq = If[ MemberQ[ vs, q ], AssociationThread[ vs, GraphDistance[ band, q ] ], <| |> ] },
    { d = Lookup[ dp, Key @ q, Infinity ] },
    { interval = If[ d === Infinity, { },
        Select[ vs, Lookup[ dp, Key @ # ] + Lookup[ dq, Key @ # ] == d & ] ] },
    { inside = AssociationThread[ interval, True ] },
    Graph[ interval,
      Catenate @ Map[
        v |-> DirectedEdge[ v, # ] & /@ Select[ AdjacencyList[ band, v ],
          TrueQ @ Lookup[ inside, Key @ # ] && Lookup[ dp, Key @ # ] == Lookup[ dp, Key @ v ] + 1 & ],
        interval ] ] ]

InfraMeasurement[ graph_Graph, InfraArc[ center_, pts : Except[ { p_, ___, p_ }, { _, _, __ } ], opts___Rule ], "Graph" ] :=
  InfraMeasurement[ graph, InfraArc[ center, #, opts ], "Graph" ] & /@ Partition[ pts, 2, 1 ]

InfraMeasurement[ graph_Graph, InfraArc[ center_, pts : Except[ { p_, ___, p_ }, { _, _, __ } ], opts___Rule ], "Cardinality" ] :=
  Times @@ ( InfraMeasurement[ graph, InfraArc[ center, #, opts ], "Cardinality" ] & /@ Partition[ pts, 2, 1 ] )

InfraMeasurement[ graph_Graph, InfraArc[ center_, pts : Except[ { p_, ___, p_ }, { _, _, __ } ], opts___Rule ], "Length" ] :=
  Total @ ( InfraMeasurement[ graph, InfraArc[ center, #, opts ], "Length" ] & /@ Partition[ pts, 2, 1 ] )

FindInfraRepresentative[ graph_Graph, InfraArc[ center_, pts : Except[ { p_, ___, p_ }, { _, _, __ } ], opts___Rule ],
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, mods___ ] :=
  With[ { cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ] },
    { pieces = FindInfraRepresentative[ graph, InfraArc[ center, #, opts ],
        If[ cap === Infinity, All, UpTo[ cap ] ], mods ] & /@ Partition[ pts, 2, 1 ] },
    { members = Fold[ { as, bs } |-> Catenate @ Map[ a |-> ( Join[ a, Rest @ # ] & /@ bs ), as ],
        First @ pieces, Rest @ pieces ] },
    Switch[ count,
      Automatic, First[ members, { } ],
      All,       members,
      _UpTo,     Take[ members, count ],
      _,         If[ Length @ members < count, { }, Take[ members, count ] ] ] ]

InfraMeasurement[ graph_Graph, InfraArc[ center_, pts : Except[ { p_, ___, p_ }, { _, _, __ } ], opts___Rule ], "VertexDensity" ] :=
  With[ { pieces = InfraArc[ center, #, opts ] & /@ Partition[ pts, 2, 1 ] },
    { counts = InfraMeasurement[ graph, #, "Cardinality" ] & /@ pieces },
    KeySort @ DeleteCases[ 0 ] @ Merge[
      Append[
        MapIndexed[ { piece, i } |-> ( Times @@ Delete[ counts, i ] ) InfraMeasurement[ graph, piece, "VertexDensity" ], pieces ],
        - ( Times @@ counts ) Counts @ Take[ pts, { 2, -2 } ] ],
      Total ] ]

InfraMeasurement[ graph_Graph, InfraArc[ center_, pts : Except[ { p_, ___, p_ }, { _, _, __ } ], opts___Rule ], "EdgeDensity" ] :=
  With[ { pieces = InfraArc[ center, #, opts ] & /@ Partition[ pts, 2, 1 ] },
    { counts = InfraMeasurement[ graph, #, "Cardinality" ] & /@ pieces },
    KeySort @ DeleteCases[ 0 ] @ Merge[
      MapIndexed[ { piece, i } |-> ( Times @@ Delete[ counts, i ] ) InfraMeasurement[ graph, piece, "EdgeDensity" ], pieces ],
      Total ] ]

InfraMemberQ[ graph_Graph, InfraArc[ center_, pts : Except[ { p_, ___, p_ }, { _, _, __ } ], opts___Rule ], path_List ] :=
  With[ { pieces = InfraArc[ center, #, opts ] & /@ Partition[ pts, 2, 1 ] },
    { cuts = Accumulate @ Prepend[ InfraMeasurement[ graph, #, "Length" ] & /@ pieces, 1 ] },
    TrueQ[ Last @ cuts == Length @ path ] &&
      AllTrue[ Range @ Length @ pieces,
        i |-> InfraMemberQ[ graph, pieces[[ i ]], Take[ path, { cuts[[ i ]], cuts[[ i + 1 ]] } ] ] ] ]
