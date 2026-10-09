Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraBall *)

(* the closed ball { v : d(v, C) <= r } with d(v, C) = min_{c in C} d(v, c) over the anchor's vertices C; a band {r, s} is the shell *)

InfraMeasurement[ graph_Graph, InfraBall[ center_, r : Except[ _List ] ], "VertexDensity" ] :=
  AssociationThread[
    Union @ VertexList @ NeighborhoodGraph[ graph, Keys @ InfraDensity[ graph, center ], Floor @ Min[ r, VertexCount @ graph ] ], 1 ]

InfraMeasurement[ graph_Graph, InfraBall[ center_, { r_, s_ } ], "VertexDensity" ] :=
  InfraMeasurement[ graph, InfraShell[ center, { r, s } ], "VertexDensity" ]

InfraMeasurement[ graph_Graph, ball : InfraBall[ _, _ ], "EdgeDensity" ] :=
  AssociationThread[ EdgeList @ Subgraph[ graph, Keys @ InfraMeasurement[ graph, ball, "VertexDensity" ] ], 1 ]

InfraMeasurement[ _Graph, InfraBall[ _, _ ], "Cardinality" ] :=
  1

InfraMeasurement[ _Graph, InfraBall[ _, _ ], "Faithful" ] :=
  True

InfraMeasurement[ graph_Graph, ball : InfraBall[ _, _ ], All ] :=
  InfraMeasurement[ graph, ball,
    { "Faithful", "Cardinality", "VertexDensity", "EdgeDensity", "Subgraph",
      "CountingMeasure", "RiemannianMeasure" } ]

(* vs is a closed ball iff some c in vs has { v : d(c, v) <= max_{w in vs} d(c, w) } == vs; a family of sets passes iff each does *)

InfraBallQ[ graph_Graph, fam_Association ] :=
  InfraBallQ[ graph, Keys @ fam ]

InfraBallQ[ graph_Graph, sets : { __List } ] /; ! AllTrue[ sets, VertexQ[ graph, # ] & ] :=
  AllTrue[ sets, InfraBallQ[ graph, # ] & ]

InfraBallQ[ graph_Graph, vs_List ] :=
  vs =!= { } &&
  AnyTrue[ vs, c |->
    With[ { r = Max @ ( GraphDistance[ graph, c, # ] & /@ vs ) },
      Sort @ Select[ VertexList[ graph ], GraphDistance[ graph, c, # ] <= r & ] === Sort @ vs
    ]
  ]

RandomInfraRepresentative[ graph_Graph, ball : InfraBall[ _, _ ],
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    ( OptionValue[ RandomInfraRepresentative, { opts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) :=
  With[ { members = Keys @ InfraMeasurement[ graph, ball, "VertexDensity" ],
          nextFn = OptionValue[ RandomInfraRepresentative, { opts }, "NextVertexFunction" ] },
    { ordered = Sort @ members },
    Which[
      count === Automatic, If[ ordered === { }, { }, If[ nextFn === Identity, First @ ordered, RandomChoice @ ordered ] ],
      count === All,       members,
      nextFn === Identity, If[ IntegerQ @ count && Length @ ordered < count, { }, Take[ ordered, count ] ],
      IntegerQ @ count && Length @ ordered < count, { },
      True, RandomSample[ ordered, count ] ] ]
