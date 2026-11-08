Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: CausalInfrageometry :: InfraCausalFuture *)

InfraCausalFuture /: InfraMeasurement[ graph_Graph, InfraCausalFuture[ anchor_ ], "VertexDensity" ] :=
  AssociationThread[ Sort @ VertexOutComponent[ graph, Keys @ InfraMeasurement[ graph, anchor, "VertexDensity" ] ], 1 ]

InfraCausalFuture /: InfraMeasurement[ graph_Graph, InfraCausalFuture[ anchor_, t_ ], "VertexDensity" ] :=
  With[ { future = Subgraph[ graph, VertexOutComponent[ graph, Keys @ InfraMeasurement[ graph, anchor, "VertexDensity" ] ] ] },
    AssociationThread[ Sort @ Keys @ Select[ CausalHeight @ future, LessEqualThan[ t ] ], 1 ] ]

InfraCausalFuture /: InfraMeasurement[ graph_Graph, cone_InfraCausalFuture, "EdgeDensity" ] :=
  AssociationThread[ EdgeList @ Subgraph[ graph, Keys @ InfraMeasurement[ graph, cone, "VertexDensity" ] ], 1 ]

InfraCausalFuture /: InfraMeasurement[ _Graph, _InfraCausalFuture, "Cardinality" ] :=
  1

InfraCausalFuture /: InfraMeasurement[ _Graph, _InfraCausalFuture, "Faithful" ] :=
  True

InfraCausalFuture /: InfraMeasurement[ graph_Graph, cone_InfraCausalFuture, All ] :=
  InfraMeasurement[ graph, cone,
    { "Faithful", "Cardinality", "VertexDensity", "EdgeDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" } ]

InfraCausalFuture /: InfraMemberQ[ graph_Graph, cone_InfraCausalFuture, set_List ] :=
  Sort @ set === Keys @ InfraMeasurement[ graph, cone, "VertexDensity" ]

InfraCausalPast /: InfraMeasurement[ graph_Graph, InfraCausalPast[ anchor_ ], "VertexDensity" ] :=
  AssociationThread[ Sort @ VertexInComponent[ graph, Keys @ InfraMeasurement[ graph, anchor, "VertexDensity" ] ], 1 ]

InfraCausalPast /: InfraMeasurement[ graph_Graph, InfraCausalPast[ anchor_, t_ ], "VertexDensity" ] :=
  InfraMeasurement[ ReverseGraph @ graph, InfraCausalFuture[ anchor, t ], "VertexDensity" ]

InfraCausalPast /: InfraMeasurement[ graph_Graph, cone_InfraCausalPast, "EdgeDensity" ] :=
  AssociationThread[ EdgeList @ Subgraph[ graph, Keys @ InfraMeasurement[ graph, cone, "VertexDensity" ] ], 1 ]

InfraCausalPast /: InfraMeasurement[ _Graph, _InfraCausalPast, "Cardinality" ] :=
  1

InfraCausalPast /: InfraMeasurement[ _Graph, _InfraCausalPast, "Faithful" ] :=
  True

InfraCausalPast /: InfraMeasurement[ graph_Graph, cone_InfraCausalPast, All ] :=
  InfraMeasurement[ graph, cone,
    { "Faithful", "Cardinality", "VertexDensity", "EdgeDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" } ]

InfraCausalPast /: InfraMemberQ[ graph_Graph, cone_InfraCausalPast, set_List ] :=
  Sort @ set === Keys @ InfraMeasurement[ graph, cone, "VertexDensity" ]

InfraCausalFutureQ[ graph_Graph, family_Association ] :=
  InfraCausalFutureQ[ graph, Keys @ family ]

InfraCausalFutureQ[ graph_Graph, sets : { __List } ] /; ! AllTrue[ sets, VertexQ[ graph, # ] & ] :=
  AllTrue[ sets, InfraCausalFutureQ[ graph, # ] & ]

InfraCausalFutureQ[ graph_Graph, vs_List ] :=
  vs =!= { } && AllTrue[ vs, VertexQ[ graph, # ] & ] &&
    AnyTrue[ vs, v |-> Sort @ VertexOutComponent[ graph, { v } ] === Sort @ vs ]

InfraCausalPastQ[ graph_Graph, family_Association ] :=
  InfraCausalPastQ[ graph, Keys @ family ]

InfraCausalPastQ[ graph_Graph, sets : { __List } ] /; ! AllTrue[ sets, VertexQ[ graph, # ] & ] :=
  AllTrue[ sets, InfraCausalPastQ[ graph, # ] & ]

InfraCausalPastQ[ graph_Graph, vs_List ] :=
  vs =!= { } && AllTrue[ vs, VertexQ[ graph, # ] & ] &&
    AnyTrue[ vs, v |-> Sort @ VertexInComponent[ graph, { v } ] === Sort @ vs ]
