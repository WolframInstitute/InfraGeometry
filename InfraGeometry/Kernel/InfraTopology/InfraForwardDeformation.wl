Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: InfraTopology :: InfraForwardDeformation *)

Options[ InfraForwardDeformation ] = { "TubeRadius" -> 1, "FirstArrival" -> True }

InfraMeasurement[ graph_Graph,
    InfraForwardDeformation[ reference : { __ },
      excessSpec : ( { _Integer?NonNegative } | { _Integer?NonNegative, _Integer?NonNegative } | UpTo[ _Integer?NonNegative ] ),
      opts : OptionsPattern[ InfraForwardDeformation ] ], "Graph" ] /;
    SubsetQ[ Keys @ Options @ InfraForwardDeformation, Keys @ { opts } ] &&
      UndirectedGraphQ[ graph ] && SimpleGraphQ[ graph ] && ! EdgeWeightedGraphQ[ graph ] &&
      AllTrue[ reference, VertexQ[ graph, # ] & ] &&
      AllTrue[ Partition[ reference, 2, 1 ], EdgeQ[ graph, UndirectedEdge @@ # ] & ] &&
      GraphDistance[ graph, First @ reference, Last @ reference ] == Length @ reference - 1 &&
      MatchQ[ OptionValue[ InfraForwardDeformation, { opts }, "TubeRadius" ], _Integer?NonNegative | Infinity ] &&
      MatchQ[ OptionValue[ InfraForwardDeformation, { opts }, "FirstArrival" ], True | False ] &&
      ( ! MatchQ[ excessSpec, { _, _ } ] || First @ excessSpec <= Last @ excessSpec ) :=
  With[ { source = First @ reference, target = Last @ reference,
      length = Length @ reference - 1,
      excesses = Replace[ excessSpec, { { k_ } :> { k }, { low_, high_ } :> Range[ low, high ], UpTo[ k_ ] :> Range[ 0, k ] } ],
      radius = OptionValue[ InfraForwardDeformation, { opts }, "TubeRadius" ],
      firstArrival = OptionValue[ InfraForwardDeformation, { opts }, "FirstArrival" ],
      distance = AssociationThread[ VertexList @ graph, GraphDistance[ graph, First @ reference ] ] },
    { maximum = Max @ excesses,
      vertices = Select[ VertexList @ NeighborhoodGraph[ graph, reference, Min[ radius, VertexCount @ graph ] ],
        Lookup[ distance, Key @ # ] <= length & ] },
    { local = Subgraph[ graph, vertices ] },
    { next = AssociationMap[
        vertex |-> If[ firstArrival && vertex === target, { },
          Select[ AdjacencyList[ local, vertex ],
            0 <= Lookup[ distance, Key @ # ] - Lookup[ distance, Key @ vertex ] <= 1 & ] ], vertices ] },
    { trellis = Graph[
        Catenate @ Table[ { Lookup[ distance, Key @ vertex ] + excess, vertex }, { excess, 0, maximum }, { vertex, vertices } ],
        Catenate @ Catenate @ Table[
          DirectedEdge[ { Lookup[ distance, Key @ vertex ] + excess, vertex },
              { Lookup[ distance, Key @ vertex ] + excess + 1, # } ] & /@
            Select[ Lookup[ next, Key @ vertex ],
              excess + 1 - Lookup[ distance, Key @ # ] + Lookup[ distance, Key @ vertex ] <= maximum & ],
          { excess, 0, maximum }, { vertex, vertices } ], DirectedEdges -> True ] },
    { reachable = VertexOutComponent[ trellis, { 0, source } ] },
    Map[ excess |-> With[ { sink = { length + excess, target } },
        If[ MemberQ[ reachable, sink ],
          Subgraph[ trellis, Intersection[ reachable, VertexInComponent[ trellis, sink ] ] ], Nothing ] ],
      excesses ] ]

InfraMeasurement[ graph_Graph, object_InfraForwardDeformation, All ] :=
  InfraMeasurement[ graph, object,
    { "Graph", "Cardinality", "Length", "VertexDensity", "EdgeDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" } ]

InfraMeasurement[ graph_Graph, object_InfraForwardDeformation, property : "VertexDensity" | "EdgeDensity" ] :=
  With[ { dags = InfraMeasurement[ graph, object, "Graph" ] },
    KeySort @ GroupBy[ Catenate @ Map[
      dag |-> With[ { incoming = GroupBy[ EdgeList @ dag, Last -> First ],
          outgoing = GroupBy[ EdgeList @ dag, First -> Last ], order = TopologicalSort @ dag },
        { prefixes = Fold[ { counts, vertex } |-> Append[ counts,
              vertex -> Replace[ Lookup[ incoming, Key @ vertex, { } ],
                { { } -> 1, previous_ :> Total @ Lookup[ counts, Key /@ previous ] } ] ], <| |>, order ],
          suffixes = Fold[ { counts, vertex } |-> Append[ counts,
              vertex -> Replace[ Lookup[ outgoing, Key @ vertex, { } ],
                { { } -> 1, following_ :> Total @ Lookup[ counts, Key /@ following ] } ] ], <| |>, Reverse @ order ] },
        If[ property === "VertexDensity",
          ( Last @ # -> Lookup[ prefixes, Key @ # ] Lookup[ suffixes, Key @ # ] ) & /@ VertexList @ dag,
          ( DirectedEdge[ Last @ First @ #, Last @ Last @ # ] ->
              Lookup[ prefixes, Key @ First @ # ] Lookup[ suffixes, Key @ Last @ # ] ) & /@ EdgeList @ dag ] ], dags ],
      First -> Last, Total ] /; MatchQ[ dags, { ___Graph } ] ]

InfraMemberQ[ graph_Graph, object_InfraForwardDeformation, walk_List ] :=
  With[ { dags = InfraMeasurement[ graph, object, "Graph" ],
      lifted = MapIndexed[ { #2[[ 1 ]] - 1, #1 } &, walk ] },
    lifted =!= { } && AnyTrue[ dags,
      dag |-> VertexQ[ dag, First @ lifted ] && VertexInDegree[ dag, First @ lifted ] == 0 &&
        VertexQ[ dag, Last @ lifted ] && VertexOutDegree[ dag, Last @ lifted ] == 0 &&
        AllTrue[ Partition[ lifted, 2, 1 ], EdgeQ[ dag, DirectedEdge @@ # ] & ] ] /; MatchQ[ dags, { ___Graph } ] ]

FindInfraForwardDeformation[ graph_Graph, object_InfraForwardDeformation,
    count : ( Automatic | _Integer?NonNegative | UpTo[ _Integer?NonNegative ] | All ) : Automatic ] :=
  With[ { dags = InfraMeasurement[ graph, object, "Graph" ],
      limit = Replace[ count, { Automatic -> 1, UpTo[ n_ ] :> n } ] },
    With[ { walks = If[ limit === 0, { }, Catenate @ Map[
        dag |-> If[ VertexCount @ dag == 1, { { Last @ First @ VertexList @ dag } },
          ( Last /@ # & ) /@ FindPath[ dag,
            First @ Pick[ VertexList @ dag, VertexInDegree @ dag, 0 ],
            First @ Pick[ VertexList @ dag, VertexOutDegree @ dag, 0 ], Infinity, limit ] ], dags ] ] },
      Switch[ count,
        Automatic, First[ walks, { } ],
        All, walks,
        _UpTo, Take[ walks, count ],
        _, If[ Length @ walks < count, { }, Take[ walks, count ] ] ] ] /; MatchQ[ dags, { ___Graph } ] ]
