Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: InfraAnalysis :: InfraAntiderivative *)

Options[ InfraAntiderivative ] = { Method -> "Volume", "Origin" -> Automatic, "Direction" -> "Past" }

Options[ InfraDerivative ] = { Method -> "Volume", "Origin" -> Automatic, "Direction" -> "Past" }

InfraAntiderivative /: InfraMeasurement[ graph_Graph,
    InfraAntiderivative[ head : _InfraCodifferential | _InfraAntiderivative | _InfraDerivative, opts___ ], "Function" ] :=
  With[ { form = InfraMeasurement[ graph, head, "Function" ] },
    With[ { result = InfraMeasurement[ graph, InfraAntiderivative[ form, opts ], "Function" ] },
      result /; AssociationQ @ result ] /; AssociationQ @ form ]

InfraAntiderivative /: InfraMeasurement[ graph_Graph,
    InfraAntiderivative[ f : Except[ <| ( _DirectedEdge -> _ ) .. |> | _InfraDifferential | _InfraCodifferential | _InfraAntiderivative | _InfraDerivative ],
      opts : OptionsPattern[ ] ], "Function" ] /;
    SubsetQ[ First /@ Options @ InfraAntiderivative, First /@ { opts } ] &&
    MatchQ[ OptionValue[ InfraAntiderivative, { opts }, Method ],
      "Volume" | "Paths" | "Average" | "Uniform" | "Flow" | { "Weights", _Association } ] &&
    MatchQ[ OptionValue[ InfraAntiderivative, { opts }, "Direction" ], "Past" | "Future" ] &&
    With[ { origin = OptionValue[ InfraAntiderivative, { opts }, "Origin" ] },
      ( origin === Automatic && DirectedGraphQ @ graph && AcyclicGraphQ @ graph ) || ( UndirectedGraphQ @ graph && VertexQ[ graph, origin ] ) ] :=
  With[ { method = OptionValue[ InfraAntiderivative, { opts }, Method ],
          origin = OptionValue[ InfraAntiderivative, { opts }, "Origin" ],
          value = If[ AssociationQ @ f, vertex |-> Lookup[ f, Key @ vertex, 0 ], f ] },
    { hasse = If[ origin === Automatic, TransitiveReductionGraph @ graph, SprayGraph[ graph, origin ] ] },
    { order = If[ OptionValue[ InfraAntiderivative, { opts }, "Direction" ] === "Future", ReverseGraph @ hasse, hasse ] },
    { inNbr = GroupBy[ EdgeList @ order, Last -> First ],
      outNbr = GroupBy[ EdgeList @ order, First -> Last ],
      vertices = Select[ VertexList @ graph, v |-> VertexQ[ order, v ] ] },
    KeyTake[
      If[ method === "Volume",
        AssociationMap[ v |-> Total[ value /@ VertexInComponent[ order, { v } ] ], vertices ],
        With[ { weight = Replace[ method, {
              "Paths" -> ( { tail, head } |-> 1 ),
              "Average" -> ( { tail, head } |-> 1 / Length @ Lookup[ inNbr, Key @ head ] ),
              "Flow" -> ( { tail, head } |-> 1 / Length @ Lookup[ outNbr, Key @ tail ] ),
              "Uniform" :> With[ { chains = Fold[
                    { counts, v } |-> Append[ counts, v -> Replace[ Lookup[ inNbr, Key @ v, { } ], { { } -> 1, us_ :> Total @ Lookup[ counts, Key /@ us ] } ] ],
                    <| |>, TopologicalSort @ order ] },
                { tail, head } |-> Lookup[ chains, Key @ tail ] / Lookup[ chains, Key @ head ] ],
              { "Weights", w_ } :> ( { tail, head } |-> Lookup[ w, Key @ DirectedEdge[ tail, head ], Lookup[ w, Key @ DirectedEdge[ head, tail ], 0 ] ] ) } ] },
          Fold[
            { integral, v } |-> Append[ integral,
              v -> value @ v + Total[ ( u |-> weight[ u, v ] Lookup[ integral, Key @ u ] ) /@ Lookup[ inNbr, Key @ v, { } ] ] ],
            <| |>, TopologicalSort @ order ] ] ],
      vertices ] ]

InfraAntiderivative /: InfraMeasurement[ graph_Graph,
    InfraAntiderivative[ Except[ <| ( _DirectedEdge -> _ ) .. |> | _InfraDifferential ], opts : OptionsPattern[ ] ], "Kernel" ] :=
  With[ { zero = InfraMeasurement[ graph, InfraAntiderivative[ <| |>, opts ], "Function" ] },
    Association @ Catenate @ Map[
      u |-> KeyValueMap[ { v, k } |-> { u, v } -> k,
        DeleteCases[ InfraMeasurement[ graph, InfraAntiderivative[ <| u -> 1 |>, opts ], "Function" ], _?PossibleZeroQ ] ],
      Keys @ zero ] /; AssociationQ @ zero ]

InfraAntiderivative /: InfraMeasurement[ graph_Graph, antiderivative_InfraAntiderivative, All ] :=
  With[ { readings = InfraMeasurement[ graph, antiderivative, { "Function", "Kernel" } ] },
    readings /; AllTrue[ readings, AssociationQ ] ]

InfraDerivative /: InfraMeasurement[ graph_Graph,
    InfraDerivative[ head : _InfraCodifferential | _InfraAntiderivative | _InfraDerivative, opts___ ], "Function" ] :=
  With[ { form = InfraMeasurement[ graph, head, "Function" ] },
    With[ { result = InfraMeasurement[ graph, InfraDerivative[ form, opts ], "Function" ] },
      result /; AssociationQ @ result ] /; AssociationQ @ form ]

InfraDerivative /: InfraMeasurement[ graph_Graph,
    InfraDerivative[ f : Except[ <| ( _DirectedEdge -> _ ) .. |> | _InfraDifferential | _InfraCodifferential | _InfraAntiderivative | _InfraDerivative ],
      opts : OptionsPattern[ ] ], "Function" ] /;
    SubsetQ[ First /@ Options @ InfraDerivative, First /@ { opts } ] &&
    MatchQ[ OptionValue[ InfraDerivative, { opts }, Method ],
      "Volume" | "Paths" | "Average" | "Uniform" | "Flow" | { "Weights", _Association } ] &&
    MatchQ[ OptionValue[ InfraDerivative, { opts }, "Direction" ], "Past" | "Future" ] &&
    With[ { origin = OptionValue[ InfraDerivative, { opts }, "Origin" ] },
      ( origin === Automatic && DirectedGraphQ @ graph && AcyclicGraphQ @ graph ) || ( UndirectedGraphQ @ graph && VertexQ[ graph, origin ] ) ] :=
  With[ { method = OptionValue[ InfraDerivative, { opts }, Method ],
          origin = OptionValue[ InfraDerivative, { opts }, "Origin" ],
          value = If[ AssociationQ @ f, vertex |-> Lookup[ f, Key @ vertex, 0 ], f ] },
    { hasse = If[ origin === Automatic, TransitiveReductionGraph @ graph, SprayGraph[ graph, origin ] ] },
    { order = If[ OptionValue[ InfraDerivative, { opts }, "Direction" ] === "Future", ReverseGraph @ hasse, hasse ] },
    { inNbr = GroupBy[ EdgeList @ order, Last -> First ],
      outNbr = GroupBy[ EdgeList @ order, First -> Last ],
      vertices = Select[ VertexList @ graph, v |-> VertexQ[ order, v ] ] },
    KeyTake[
      If[ method === "Volume",
        Fold[
          { derivative, v } |-> Append[ derivative,
            v -> value @ v - Total @ Lookup[ derivative, Key /@ VertexInComponent[ order, Lookup[ inNbr, Key @ v, { } ] ] ] ],
          <| |>, TopologicalSort @ order ],
        With[ { weight = Replace[ method, {
              "Paths" -> ( { tail, head } |-> 1 ),
              "Average" -> ( { tail, head } |-> 1 / Length @ Lookup[ inNbr, Key @ head ] ),
              "Flow" -> ( { tail, head } |-> 1 / Length @ Lookup[ outNbr, Key @ tail ] ),
              "Uniform" :> With[ { chains = Fold[
                    { counts, v } |-> Append[ counts, v -> Replace[ Lookup[ inNbr, Key @ v, { } ], { { } -> 1, us_ :> Total @ Lookup[ counts, Key /@ us ] } ] ],
                    <| |>, TopologicalSort @ order ] },
                { tail, head } |-> Lookup[ chains, Key @ tail ] / Lookup[ chains, Key @ head ] ],
              { "Weights", w_ } :> ( { tail, head } |-> Lookup[ w, Key @ DirectedEdge[ tail, head ], Lookup[ w, Key @ DirectedEdge[ head, tail ], 0 ] ] ) } ] },
          AssociationMap[
            v |-> value @ v - Total[ ( u |-> weight[ u, v ] value @ u ) /@ Lookup[ inNbr, Key @ v, { } ] ],
            vertices ] ] ],
      vertices ] ]

InfraDerivative /: InfraMeasurement[ graph_Graph,
    InfraDerivative[ Except[ <| ( _DirectedEdge -> _ ) .. |> | _InfraDifferential ], opts : OptionsPattern[ ] ], "Kernel" ] :=
  With[ { zero = InfraMeasurement[ graph, InfraDerivative[ <| |>, opts ], "Function" ] },
    Association @ Catenate @ Map[
      u |-> KeyValueMap[ { v, k } |-> { u, v } -> k,
        DeleteCases[ InfraMeasurement[ graph, InfraDerivative[ <| u -> 1 |>, opts ], "Function" ], _?PossibleZeroQ ] ],
      Keys @ zero ] /; AssociationQ @ zero ]

InfraDerivative /: InfraMeasurement[ graph_Graph, derivative_InfraDerivative, All ] :=
  With[ { readings = InfraMeasurement[ graph, derivative, { "Function", "Kernel" } ] },
    readings /; AllTrue[ readings, AssociationQ ] ]
