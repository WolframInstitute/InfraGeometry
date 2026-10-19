Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraEquidistantSet *)

InfraMeasurement[ graph_Graph, object : InfraEquidistantSet[ points_List ], "VertexDensity" ] /;
    VertexQ[ graph, object ] || ( UndirectedGraphQ[ graph ] && SimpleGraphQ[ graph ] && ! WeightedGraphQ[ graph ] &&
      AllTrue[ points, point |-> VertexQ[ graph, point ] ] ) :=
  If[ VertexQ[ graph, object ], <| object -> 1 |>,
    With[ { vertices = VertexList[ graph ] },
      { indices = AssociationThread[ vertices, Range @ Length[ vertices ] ],
        indexedGraph = VertexReplace[ graph, Thread[ vertices -> Range @ Length[ vertices ] ] ] },
      { rows = GraphDistance[ indexedGraph, Lookup[ indices, Key[ # ] ] ] & /@ points },
      AssociationThread[ If[ points === { }, vertices,
        Pick[ vertices, Map[ distances |-> First[ distances ] < Infinity && SameQ @@ distances, Transpose[ rows ] ], True ] ], 1 ] ] ]

InfraMeasurement[ graph_Graph, object_InfraEquidistantSet,
    property : ( "Cardinality" | "CountingMeasure" | "Subgraph" | "RiemannianMeasure" ) ] :=
  With[ { density = InfraMeasurement[ graph, object, "VertexDensity" ] },
    Switch[ property,
      "Cardinality", 1,
      "CountingMeasure", Length[ density ],
      "Subgraph", Subgraph[ graph, Keys[ density ] ],
      "RiemannianMeasure", Count[ Keys[ density ], vertex_ /;
        AllTrue[ AdjacencyList[ graph, vertex ], neighbor |-> KeyExistsQ[ density, neighbor ] ] ] ] /; AssociationQ[ density ] ]

InfraMeasurement[ graph_Graph, object_InfraEquidistantSet,
    properties : { ( "VertexDensity" | "Cardinality" | "CountingMeasure" | "Subgraph" | "RiemannianMeasure" ) .. } ] :=
  With[ { density = InfraMeasurement[ graph, object, "VertexDensity" ] },
    AssociationMap[ property |-> InfraMeasurement[ graph, object, property ], properties ] /; AssociationQ[ density ] ]

InfraMeasurement[ graph_Graph, object_InfraEquidistantSet, All ] :=
  With[ { density = InfraMeasurement[ graph, object, "VertexDensity" ] },
    AssociationMap[ property |-> InfraMeasurement[ graph, object, property ],
      { "VertexDensity", "Cardinality", "CountingMeasure", "Subgraph", "RiemannianMeasure" } ] /; AssociationQ[ density ] ]

InfraMemberQ[ graph_Graph, object_InfraEquidistantSet, vertices_List ] :=
  With[ { density = InfraMeasurement[ graph, object, "VertexDensity" ] },
    Union[ vertices ] === Sort[ Keys[ density ] ] /; AssociationQ[ density ] ]
