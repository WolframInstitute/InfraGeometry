Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraArc *)

(* InfraArc[c, {p, q}] is inert: the minor arcs of the circles around c through p and q, a minor arc being a geodesic of the band graph A = G[W] on
   the band W = { v : rmin <= d(c, v) <= rmax } of the circle through p, widened by "RadiusDelta" -> dOut | {dIn, dOut}.  Its graph is the interval
   DAG I_A(p, q) = { v in W : d_A(p, v) + d_A(v, q) == d_A(p, q) } with the arrows of rising d_A(p, .), whose chains are exactly those geodesics --
   and hence, under the winding functional (W) and for p, q on a common circle, exactly the minor arcs, all of length d_A(p, q) (design Thm.
   arc).  Neither hypothesis is certified here, so "Faithful" is Undetermined.  More points give the polyline of the consecutive minor arcs, each
   read on the band of the circle through its own first point -- one band, since the arc asks its points to lie on a common circle *)

InfraMeasurement[ graph_Graph, InfraArc[ center_, { p_, q_ }, opts___Rule ], "Graph" ] :=
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

InfraMeasurement[ graph_Graph, InfraArc[ center_, pts : { _, _, __ }, opts___Rule ], "Graph" ] :=
  InfraMeasurement[ graph, InfraArc[ center, #, opts ], "Graph" ] & /@ Partition[ pts, 2, 1 ]

InfraMeasurement[ graph_Graph, InfraArc[ center_, pts : { _, _, __ }, opts___Rule ], "Cardinality" ] :=
  Times @@ ( InfraMeasurement[ graph, InfraArc[ center, #, opts ], "Cardinality" ] & /@ Partition[ pts, 2, 1 ] )

InfraMeasurement[ graph_Graph, InfraArc[ center_, pts : { _, _, __ }, opts___Rule ], "Length" ] :=
  Total @ ( InfraMeasurement[ graph, InfraArc[ center, #, opts ], "Length" ] & /@ Partition[ pts, 2, 1 ] )

InfraVertexList[ graph_Graph, InfraArc[ center_, pts : { _, _, __ }, opts___Rule ],
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, mods___ ] :=
  With[ { cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ] },
    { pieces = InfraVertexList[ graph, InfraArc[ center, #, opts ],
        If[ cap === Infinity, All, UpTo[ cap ] ], mods ] & /@ Partition[ pts, 2, 1 ] },
    { members = Fold[ { as, bs } |-> Catenate @ Map[ a |-> ( Join[ a, Rest @ # ] & /@ bs ), as ],
        First @ pieces, Rest @ pieces ] },
    Switch[ count,
      Automatic, First[ members, { } ],
      All,       members,
      _UpTo,     Take[ members, count ],
      _,         If[ Length @ members < count, { }, Take[ members, count ] ] ] ]

InfraMeasurement[ graph_Graph, InfraArc[ center_, pts : { _, _, __ }, opts___Rule ], "VertexDensity" ] :=
  With[ { pieces = InfraArc[ center, #, opts ] & /@ Partition[ pts, 2, 1 ] },
    { counts = InfraMeasurement[ graph, #, "Cardinality" ] & /@ pieces },
    KeySort @ DeleteCases[ 0 ] @ Merge[
      Append[
        MapIndexed[ { piece, i } |-> ( Times @@ Delete[ counts, i ] ) InfraMeasurement[ graph, piece, "VertexDensity" ], pieces ],
        - ( Times @@ counts ) Counts @ Take[ pts, { 2, -2 } ] ],
      Total ] ]

InfraMeasurement[ graph_Graph, InfraArc[ center_, pts : { _, _, __ }, opts___Rule ], "EdgeDensity" ] :=
  With[ { pieces = InfraArc[ center, #, opts ] & /@ Partition[ pts, 2, 1 ] },
    { counts = InfraMeasurement[ graph, #, "Cardinality" ] & /@ pieces },
    KeySort @ DeleteCases[ 0 ] @ Merge[
      MapIndexed[ { piece, i } |-> ( Times @@ Delete[ counts, i ] ) InfraMeasurement[ graph, piece, "EdgeDensity" ], pieces ],
      Total ] ]

InfraMemberQ[ graph_Graph, InfraArc[ center_, pts : { _, _, __ }, opts___Rule ], path_List ] :=
  With[ { pieces = InfraArc[ center, #, opts ] & /@ Partition[ pts, 2, 1 ] },
    { cuts = Accumulate @ Prepend[ InfraMeasurement[ graph, #, "Length" ] & /@ pieces, 1 ] },
    TrueQ[ Last @ cuts == Length @ path ] &&
      AllTrue[ Range @ Length @ pieces,
        i |-> InfraMemberQ[ graph, pieces[[ i ]], Take[ path, { cuts[[ i ]], cuts[[ i + 1 ]] } ] ] ] ]

Options[ FindInfraArc ] = { "RadiusDelta" -> 0 }

FindInfraArc[ graph_Graph, center_, pts : { _, _, ___ },
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] :=
  With[ { dist = AssociationThread[ VertexList @ graph, GraphDistance[ graph, center ] ],
          delta = Replace[ OptionValue[ FindInfraArc, { opts }, "RadiusDelta" ],
                    d : Except[ _List ] :> { 0, d } ],
          cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ] },
    { r = Lookup[ dist, Key @ First @ pts ] },
    { band = Subgraph[ graph, Select[ VertexList @ graph,
        Max[ 1, r - First @ delta ] <= Lookup[ dist, Key @ # ] <= r + Last @ delta & ] ] },
    { pieces = Map[
        pair |-> With[ { d = If[ AllTrue[ pair, VertexQ[ band, # ] & ],
                GraphDistance[ band, First @ pair, Last @ pair ], Infinity ] },
          Which[
            d === Infinity, { },
            d === 0,        { { First @ pair } },
            True,           FindPath[ band, First @ pair, Last @ pair, { d }, Replace[ cap, Infinity -> All ] ] ] ],
        Partition[ pts, 2, 1 ] ] },
    { arcs = Fold[ { as, bs } |-> Catenate @ Map[ a |-> ( Join[ a, Rest @ # ] & /@ bs ), as ],
        First @ pieces, Rest @ pieces ] },
    Switch[ count,
      Automatic, First[ arcs, { } ],
      All,       arcs,
      _UpTo,     Take[ arcs, count ],
      _,         If[ Length @ arcs < count, { }, Take[ arcs, count ] ] ] ]
