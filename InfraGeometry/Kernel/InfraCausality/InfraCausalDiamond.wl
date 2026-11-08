Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: CausalInfrageometry :: InfraCausalDiamond *)

InfraCausalDiamond /: InfraMeasurement[ graph_Graph, InfraCausalDiamond[ p_, q_ ], "VertexDensity" ] :=
  AssociationThread[
    Intersection[
      VertexOutComponent[ graph, Keys @ InfraMeasurement[ graph, p, "VertexDensity" ] ],
      VertexInComponent[ graph, Keys @ InfraMeasurement[ graph, q, "VertexDensity" ] ] ],
    1 ]

InfraCausalDiamond /: InfraMeasurement[ graph_Graph, InfraCausalDiamond[ anchor_ ], "VertexDensity" ] :=
  InfraMeasurement[ graph, InfraCausalDiamond[ anchor, anchor ], "VertexDensity" ]

InfraCausalDiamond /: InfraMeasurement[ graph_Graph, diamond_InfraCausalDiamond, "EdgeDensity" ] :=
  AssociationThread[ EdgeList @ Subgraph[ graph, Keys @ InfraMeasurement[ graph, diamond, "VertexDensity" ] ], 1 ]

InfraCausalDiamond /: InfraMeasurement[ _Graph, _InfraCausalDiamond, "Cardinality" ] :=
  1

InfraCausalDiamond /: InfraMeasurement[ _Graph, _InfraCausalDiamond, "Faithful" ] :=
  True

InfraCausalDiamond /: InfraMeasurement[ graph_Graph, diamond_InfraCausalDiamond, All ] :=
  InfraMeasurement[ graph, diamond,
    { "Faithful", "Cardinality", "VertexDensity", "EdgeDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" } ]

InfraCausalDiamond /: InfraMemberQ[ graph_Graph, diamond_InfraCausalDiamond, set_List ] :=
  Sort @ set === Keys @ InfraMeasurement[ graph, diamond, "VertexDensity" ]

InfraCausalDiamondQ[ graph_Graph, family_Association ] :=
  InfraCausalDiamondQ[ graph, Keys @ family ]

InfraCausalDiamondQ[ graph_Graph, sets : { __List } ] /; ! AllTrue[ sets, VertexQ[ graph, # ] & ] :=
  AllTrue[ sets, InfraCausalDiamondQ[ graph, # ] & ]

InfraCausalDiamondQ[ graph_Graph, vs_List ] :=
  vs =!= { } && AllTrue[ vs, VertexQ[ graph, # ] & ] &&
    With[ { set = Sort @ vs },
      { bottom = SelectFirst[ set, v |-> SubsetQ[ VertexOutComponent[ graph, { v } ], set ] ],
        top = SelectFirst[ set, v |-> SubsetQ[ VertexInComponent[ graph, { v } ], set ] ] },
      ! MissingQ[ bottom ] && ! MissingQ[ top ] &&
        Intersection[ VertexOutComponent[ graph, { bottom } ], VertexInComponent[ graph, { top } ] ] === set ]
