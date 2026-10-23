Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: InfraAnalysis :: InfraDifferential *)

InfraDifferential /: InfraMeasurement[ graph_Graph, InfraDifferential[ head : _InfraCodifferential | _InfraAntiderivative | _InfraDerivative ], "Function" ] :=
  With[ { form = InfraMeasurement[ graph, head, "Function" ] },
    With[ { result = InfraMeasurement[ graph, InfraDifferential[ form ], "Function" ] },
      result /; AssociationQ @ result ] /; AssociationQ @ form ]

InfraDifferential /: InfraMeasurement[ graph_Graph,
    InfraDifferential[ f : Except[ <| ( _DirectedEdge -> _ ) .. |> | _InfraDifferential | _InfraCodifferential | _InfraAntiderivative | _InfraDerivative ] ],
    "Function" ] /; ( DirectedGraphQ @ graph && AcyclicGraphQ @ graph ) || UndirectedGraphQ @ graph :=
  With[ { value = If[ AssociationQ @ f, vertex |-> Lookup[ f, Key @ vertex, 0 ], f ] },
    AssociationMap[ e |-> value @ Last @ e - value @ First @ e,
      If[ UndirectedGraphQ @ graph, DirectedEdge @@@ EdgeList @ graph, EdgeList @ TransitiveReductionGraph @ graph ] ] ]

InfraDifferential /: InfraMeasurement[ graph_Graph, differential_InfraDifferential, All ] :=
  With[ { readings = InfraMeasurement[ graph, differential, { "Function" } ] },
    readings /; AssociationQ @ First @ readings ]

InfraCodifferential /: InfraMeasurement[ graph_Graph, InfraCodifferential[ head_InfraDifferential ], "Function" ] :=
  With[ { form = InfraMeasurement[ graph, head, "Function" ] },
    With[ { result = InfraMeasurement[ graph, InfraCodifferential[ form ], "Function" ] },
      result /; AssociationQ @ result ] /; AssociationQ @ form ]

InfraCodifferential /: InfraMeasurement[ graph_Graph, InfraCodifferential[ form : <| ( _DirectedEdge -> _ ) ... |> ], "Function" ] /;
    ( DirectedGraphQ @ graph && AcyclicGraphQ @ graph ) || UndirectedGraphQ @ graph :=
  With[ { links = If[ UndirectedGraphQ @ graph, DirectedEdge @@@ EdgeList @ graph, EdgeList @ TransitiveReductionGraph @ graph ] },
    { value = edge |-> Lookup[ form, Key @ edge, - Lookup[ form, Key @ Reverse @ edge, 0 ] ],
      incoming = GroupBy[ links, Last ],
      outgoing = GroupBy[ links, First ] },
    AssociationMap[
      v |-> Total[ value /@ Lookup[ incoming, Key @ v, { } ] ] - Total[ value /@ Lookup[ outgoing, Key @ v, { } ] ],
      VertexList @ graph ] ]

InfraCodifferential /: InfraMeasurement[ graph_Graph, codifferential_InfraCodifferential, All ] :=
  With[ { readings = InfraMeasurement[ graph, codifferential, { "Function" } ] },
    readings /; AssociationQ @ First @ readings ]
