Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: InfraAnalysis :: InfraIntegral *)

InfraIntegral /: InfraMeasurement[ graph_Graph,
    InfraIntegral[ head : _InfraDifferential | _InfraCodifferential | _InfraAntiderivative | _InfraDerivative, obj_ ],
    property : "Value" | "ValueDensity" | "Mean" | "Cardinality" | "Flux" ] :=
  With[ { form = InfraMeasurement[ graph, head, "Function" ] },
    With[ { result = InfraMeasurement[ graph, InfraIntegral[ form, obj ], property ] },
      result /; Head @ result =!= InfraMeasurement ] /; AssociationQ @ form ]

InfraIntegral /: InfraMeasurement[ graph_Graph,
    InfraIntegral[ f : Except[ _InfraDifferential | _InfraCodifferential | _InfraAntiderivative | _InfraDerivative ],
      obj : Except[ InfraSegment[ _, _, __ ] | InfraArc[ _, { _, _, __ } | { p_, p_ } | { _ }, ___ ] | InfraCircle[ _, _, ___ ] ] ],
    "ValueDensity" ] :=
  With[ { dags = Replace[ InfraMeasurement[ graph, obj, "Graph" ], dag_Graph :> { dag } ] },
    With[ { value = If[ AssociationQ @ f, vertex |-> Lookup[ f, Key @ vertex, 0 ], f ],
            oneForm = MatchQ[ f, <| ( _DirectedEdge -> _ ) .. |> ] },
      { start = If[ oneForm, vertex |-> 0, value ],
        step = If[ oneForm,
          { tail, head } |-> Lookup[ f, Key @ DirectedEdge[ tail, head ], - Lookup[ f, Key @ DirectedEdge[ head, tail ], 0 ] ],
          { tail, head } |-> value @ head ] },
      KeySort @ Merge[
        Map[
          dag |-> With[ { inNbr = GroupBy[ EdgeList @ dag, Last -> First ] },
            { sums = Fold[
                { acc, v } |-> Append[ acc, v -> Replace[ Lookup[ inNbr, Key @ v, { } ], {
                    { } :> <| start @ v -> 1 |>,
                    us_ :> Merge[ Map[ u |-> With[ { s = step[ u, v ] }, KeyMap[ x |-> x + s, Lookup[ acc, Key @ u ] ] ], us ], Total ] } ] ],
                <| |>, TopologicalSort @ dag ] },
            Merge[ Lookup[ sums, Key /@ Pick[ VertexList @ dag, VertexOutDegree @ dag, 0 ] ], Total ] ],
          dags ],
        Total ] ] /;
      MatchQ[ dags, { ___Graph } ] && AllTrue[ dags, dag |-> AcyclicGraphQ @ dag && SubsetQ[ VertexList @ graph, VertexList @ dag ] ] ]

InfraIntegral /: InfraMeasurement[ graph_Graph,
    InfraIntegral[ f : Except[ <| ( _DirectedEdge -> _ ) .. |> | _InfraDifferential | _InfraCodifferential | _InfraAntiderivative | _InfraDerivative ], obj_ ],
    "ValueDensity" ] :=
  With[ { carrier = InfraMeasurement[ graph, obj, "Graph" ] },
    With[ { support = InfraMeasurement[ graph, obj, "VertexDensity" ] },
      <| Total[ If[ AssociationQ @ f, Lookup[ f, Key /@ Keys @ support, 0 ], f /@ Keys @ support ] ] -> 1 |> /; AssociationQ @ support ] /;
      ! MatchQ[ carrier, _Graph | { ___Graph } ] ]

InfraIntegral /: InfraMeasurement[ graph_Graph,
    integral : InfraIntegral[ Except[ _InfraDifferential | _InfraCodifferential | _InfraAntiderivative | _InfraDerivative ], _ ], "Value" ] :=
  With[ { density = InfraMeasurement[ graph, integral, "ValueDensity" ] },
    Replace[ Keys @ density, { one_ } :> one ] /; AssociationQ @ density ]

InfraIntegral /: InfraMeasurement[ graph_Graph,
    InfraIntegral[ f : Except[ _InfraDifferential | _InfraCodifferential | _InfraAntiderivative | _InfraDerivative ],
      obj : Except[ InfraSegment[ _, _, __ ] | InfraArc[ _, { _, _, __ } | { p_, p_ } | { _ }, ___ ] | InfraCircle[ _, _, ___ ] ] ],
    "Mean" ] :=
  With[ { dags = Replace[ InfraMeasurement[ graph, obj, "Graph" ], dag_Graph :> { dag } ] },
    With[ { members = InfraMeasurement[ graph, obj, "Cardinality" ] },
      If[ MatchQ[ f, <| ( _DirectedEdge -> _ ) .. |> ],
        Total @ KeyValueMap[ { e, n } |-> n Lookup[ f, Key @ e, - Lookup[ f, Key @ Reverse @ e, 0 ] ], InfraMeasurement[ graph, obj, "EdgeDensity" ] ],
        Total @ KeyValueMap[ { v, n } |-> n If[ AssociationQ @ f, Lookup[ f, Key @ v, 0 ], f @ v ], InfraMeasurement[ graph, obj, "VertexDensity" ] ] ] / members /;
        members > 0 ] /;
      MatchQ[ dags, { ___Graph } ] && AllTrue[ dags, dag |-> AcyclicGraphQ @ dag && SubsetQ[ VertexList @ graph, VertexList @ dag ] ] ]

InfraIntegral /: InfraMeasurement[ graph_Graph,
    integral : InfraIntegral[ Except[ _InfraDifferential | _InfraCodifferential | _InfraAntiderivative | _InfraDerivative ], obj_ ], "Mean" ] :=
  With[ { carrier = InfraMeasurement[ graph, obj, "Graph" ] },
    With[ { density = InfraMeasurement[ graph, integral, "ValueDensity" ] },
      First @ Keys @ density /; AssociationQ @ density ] /;
      ! MatchQ[ carrier, _Graph | { ___Graph } ] ]

InfraIntegral /: InfraMeasurement[ graph_Graph,
    InfraIntegral[ Except[ _InfraDifferential | _InfraCodifferential | _InfraAntiderivative | _InfraDerivative ],
      obj : Except[ InfraSegment[ _, _, __ ] | InfraArc[ _, { _, _, __ } | { p_, p_ } | { _ }, ___ ] | InfraCircle[ _, _, ___ ] ] ],
    "Cardinality" ] :=
  With[ { dags = Replace[ InfraMeasurement[ graph, obj, "Graph" ], dag_Graph :> { dag } ] },
    InfraMeasurement[ graph, obj, "Cardinality" ] /;
      MatchQ[ dags, { ___Graph } ] && AllTrue[ dags, dag |-> AcyclicGraphQ @ dag && SubsetQ[ VertexList @ graph, VertexList @ dag ] ] ]

InfraIntegral /: InfraMeasurement[ graph_Graph,
    InfraIntegral[ Except[ _InfraDifferential | _InfraCodifferential | _InfraAntiderivative | _InfraDerivative ], obj_ ], "Cardinality" ] :=
  With[ { carrier = InfraMeasurement[ graph, obj, "Graph" ] },
    With[ { support = InfraMeasurement[ graph, obj, "VertexDensity" ] },
      1 /; AssociationQ @ support ] /;
      ! MatchQ[ carrier, _Graph | { ___Graph } ] ]

InfraIntegral /: InfraMeasurement[ graph_Graph, InfraIntegral[ form : <| ( _DirectedEdge -> _ ) ... |>, obj_ ], "Flux" ] /;
    ( DirectedGraphQ @ graph && AcyclicGraphQ @ graph ) || UndirectedGraphQ @ graph :=
  With[ { carrier = InfraMeasurement[ graph, obj, "Graph" ] },
    With[ { support = InfraMeasurement[ graph, obj, "VertexDensity" ] },
      With[ { inside = AssociationThread[ Keys @ support, 1 ] },
        Total @ Map[
          e |-> ( Lookup[ inside, Key @ Last @ e, 0 ] - Lookup[ inside, Key @ First @ e, 0 ] ) Lookup[ form, Key @ e, - Lookup[ form, Key @ Reverse @ e, 0 ] ],
          If[ UndirectedGraphQ @ graph, DirectedEdge @@@ EdgeList @ graph, EdgeList @ TransitiveReductionGraph @ graph ] ] ] /;
        AssociationQ @ support ] /;
      ! MatchQ[ carrier, _Graph | { ___Graph } ] ]

InfraIntegral /: InfraMeasurement[ graph_Graph, integral_InfraIntegral, All ] :=
  With[ { readings = Select[ InfraMeasurement[ graph, integral, { "Value", "ValueDensity", "Mean", "Cardinality", "Flux" } ],
      reading |-> Head @ reading =!= InfraMeasurement ] },
    readings /; readings =!= <| |> ]
