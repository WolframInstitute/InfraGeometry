Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: CausalTime :: InfraSlice *)

InfraSlice /: InfraMeasurement[ graph_Graph, InfraSlice[ k_Integer ], "VertexDensity" ] :=
  InfraMeasurement[ graph, InfraSlice[ { k, k } ], "VertexDensity" ]

InfraSlice /: InfraMeasurement[ graph_Graph, InfraSlice[ { k1_Integer, k2_Integer } ], "VertexDensity" ] :=
  AssociationThread[ Sort @ Keys @ Select[ CausalHeight @ graph, t |-> k1 <= t <= k2 ], 1 ]

InfraSlice /: InfraMeasurement[ graph_Graph, slice_InfraSlice, "EdgeDensity" ] :=
  AssociationThread[ EdgeList @ Subgraph[ graph, Keys @ InfraMeasurement[ graph, slice, "VertexDensity" ] ], 1 ]

InfraSlice /: InfraMeasurement[ _Graph, _InfraSlice, "Cardinality" ] :=
  1

InfraSlice /: InfraMeasurement[ _Graph, _InfraSlice, "Faithful" ] :=
  True

InfraSlice /: InfraMeasurement[ graph_Graph, slice_InfraSlice, All ] :=
  InfraMeasurement[ graph, slice,
    { "Faithful", "Cardinality", "VertexDensity", "EdgeDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" } ]

InfraSlice /: InfraMemberQ[ graph_Graph, slice_InfraSlice, set_List ] :=
  Sort @ set === Keys @ InfraMeasurement[ graph, slice, "VertexDensity" ]

InfraSliceQ[ graph_Graph, family_Association ] :=
  InfraSliceQ[ graph, Keys @ family ]

InfraSliceQ[ graph_Graph, sets : { __List } ] /; ! AllTrue[ sets, VertexQ[ graph, # ] & ] :=
  AllTrue[ sets, InfraSliceQ[ graph, # ] & ]

InfraSliceQ[ graph_Graph, vs_List ] :=
  vs =!= { } && AllTrue[ vs, VertexQ[ graph, # ] & ] &&
    With[ { time = CausalHeight @ graph },
      Sort @ vs === Sort @ Keys @ Select[ time, EqualTo[ time[ First @ vs ] ] ] ]
