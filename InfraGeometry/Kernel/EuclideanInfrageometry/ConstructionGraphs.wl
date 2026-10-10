Package[ "WolframInstitute`InfraGeometry`" ]

IntervalGraph[ graph_Graph, points : Repeated[ Except[ _Rule | _RuleDelayed ], { 2, Infinity } ] ] :=
  InfraMeasurement[ graph, InfraSegment[ points ], "Graph" ]

RayGraph[ graph_Graph, p_, q_ ] :=
  InfraMeasurement[ graph, InfraRay[ p, q ], "Graph" ]

BeamGraph[ graph_Graph, p_, q_ ] :=
  InfraMeasurement[ graph, InfraLine[ p, q ], "Graph" ]

BeamGraph[ graph_Graph, germ_ ] :=
  InfraMeasurement[ graph, InfraLine[ germ ], "Graph" ]

ArcGraph[ graph_Graph, center_, points_List, opts___Rule ] :=
  InfraMeasurement[ graph, InfraArc[ center, points, opts ], "Graph" ]
