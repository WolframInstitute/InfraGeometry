Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: InfraTopology :: InfraDeformations *)

Options[ InfraDeformation ] = { "TubeRadius" -> 1, "MaxStates" -> 100000 }
Options[ RandomInfraDeformation ] = { "NextVertexFunction" -> Automatic, RandomSeeding -> Automatic }

InfraMeasurement[ graph_Graph,
    object : InfraDeformation[ reference : { __ },
      excessSpec : ( { _Integer?NonNegative } | { _Integer?NonNegative, _Integer?NonNegative } | UpTo[ _Integer?NonNegative ] ),
      opts : OptionsPattern[ InfraDeformation ] ], "Graph" ] /;
    SubsetQ[ Keys @ Options @ InfraDeformation, Keys @ { opts } ] &&
      UndirectedGraphQ[ graph ] && SimpleGraphQ[ graph ] && ! EdgeWeightedGraphQ[ graph ] &&
      AllTrue[ reference, VertexQ[ graph, # ] & ] &&
      AllTrue[ Partition[ reference, 2, 1 ], EdgeQ[ graph, UndirectedEdge @@ # ] & ] &&
      GraphDistance[ graph, First @ reference, Last @ reference ] == Length @ reference - 1 &&
      MatchQ[ OptionValue[ InfraDeformation, { opts }, "TubeRadius" ], _Integer?NonNegative | Infinity ] &&
      MatchQ[ OptionValue[ InfraDeformation, { opts }, "MaxStates" ], _Integer?Positive | Infinity ] &&
      ( ! MatchQ[ excessSpec, { _, _ } ] || First @ excessSpec <= Last @ excessSpec ) :=
  With[ { result =
  With[ { local = NeighborhoodGraph[ graph, reference,
        Min[ OptionValue[ InfraDeformation, { opts }, "TubeRadius" ], VertexCount @ graph ] ],
      length = Length @ reference - 1, source = First @ reference, target = Last @ reference, finish = { -1 },
      requested = Replace[ excessSpec, { { k_ } :> { k }, { low_, high_ } :> Range[ low, high ], UpTo[ k_ ] :> Range[ 0, k ] } ],
      maximumStates = OptionValue[ InfraDeformation, { opts }, "MaxStates" ] },
    { horizon = Min[ length + Max @ requested, VertexCount @ local - 1 ] },
    If[ Min @ requested > horizon - length, Graph[ { }, { }, DirectedEdges -> True ],
      With[ { girth = If[ horizon - length <= 2, 3,
            Min @ Prepend[ ( 1 + GraphDistance[ EdgeDelete[ local, # ], First @ #, Last @ # ] & ) /@ EdgeList @ local, Infinity ] ],
          distances = AssociationThread[ VertexList @ local, GraphDistance[ local, target ] ],
          adjacency = AssociationMap[ AdjacencyList[ local, # ] &, VertexList @ local ], start = { 0, { source } } },
        { memory = If[ horizon - length < girth, 2, Max[ 1, horizon - length ] ] },
        { construction = NestWhile[
            data |-> With[ { time = data[ "Time" ], frontier = data[ "Frontier" ] },
              { accepted = Join[ data[ "Accepted" ],
                  Select[ frontier, Last @ Last @ # === target && MemberQ[ requested, time - length ] & ] ],
                nextEdges = If[ time == horizon, { }, Catenate @ Map[ state |-> With[ { history = Last @ state },
                    If[ Last @ history === target, { },
                      DirectedEdge[ state, { time + 1, Take[ Append[ history, # ], -Min[ memory, Length @ history + 1 ] ] } ] & /@
                        Select[ Lookup[ adjacency, Key @ Last @ history ], neighbor |->
                          ! MemberQ[ history, neighbor ] && time + 1 + Lookup[ distances, Key @ neighbor ] <= horizon ] ] ], frontier ] ] },
              { nextStates = DeleteDuplicates[ Last /@ nextEdges ] },
              If[ Length @ data[ "States" ] + Length @ nextStates + 1 > maximumStates,
                Append[ data, "Exceeded" -> True ],
                <| "Time" -> time + 1, "Frontier" -> nextStates, "States" -> Join[ data[ "States" ], nextStates ],
                  "Edges" -> Join[ data[ "Edges" ], nextEdges ], "Accepted" -> accepted, "Exceeded" -> False |> ] ],
            <| "Time" -> 0, "Frontier" -> { start }, "States" -> { start }, "Edges" -> { }, "Accepted" -> { },
              "Exceeded" -> ( maximumStates < 2 ) |>,
            ! #[ "Exceeded" ] && #[ "Frontier" ] =!= { } && #[ "Time" ] <= horizon & ] },
        Which[
          construction[ "Exceeded" ], Null,
          construction[ "Accepted" ] === { }, Graph[ { }, { }, DirectedEdges -> True ],
          True, With[ { carrier = Graph[ Append[ construction[ "States" ], finish ],
              Join[ construction[ "Edges" ], DirectedEdge[ #, finish ] & /@ construction[ "Accepted" ] ], DirectedEdges -> True ] },
            Subgraph[ carrier, VertexInComponent[ carrier, finish ] ] ] ] ] ] ] },
    result /; GraphQ[ result ] ]

InfraMeasurement[ graph_Graph, object_InfraDeformation, All ] :=
  With[ { result =
  With[ { carrier = InfraMeasurement[ graph, object, "Graph" ], finish = { -1 },
      requested = Replace[ object[[ 2 ]], { { k_ } :> { k }, { low_, high_ } :> Range[ low, high ], UpTo[ k_ ] :> Range[ 0, k ] } ] },
    If[ ! GraphQ[ carrier ], Null,
      If[ VertexCount @ carrier == 0,
        <| "Graph" -> carrier, "Cardinality" -> 0, "CountsByExcess" -> AssociationThread[ requested, 0 ], "Length" -> { },
          "VertexDensity" -> <| |>, "EdgeDensity" -> <| |>, "Subgraph" -> Subgraph[ graph, { } ],
          "CountingMeasure" -> 0, "RiemannianMeasure" -> 0 |>,
        With[ { incoming = GroupBy[ EdgeList @ carrier, Last -> First ],
            outgoing = GroupBy[ EdgeList @ carrier, First -> Last ], order = TopologicalSort @ carrier },
          { start = First @ order, terminalStates = Lookup[ incoming, Key @ finish ] },
          { prefixes = Fold[ { values, state } |-> Append[ values, state -> If[ state === start, 1,
                Total @ Lookup[ values, Key /@ Lookup[ incoming, Key @ state, { } ] ] ] ], <| |>, order ],
            suffixes = Fold[ { values, state } |-> Append[ values, state -> If[ state === finish, 1,
                Total @ Lookup[ values, Key /@ Lookup[ outgoing, Key @ state, { } ] ] ] ], <| |>, Reverse @ order ] },
          { counts = AssociationThread[ requested, Map[ excess |-> Total @ Lookup[ prefixes,
                Key /@ Select[ terminalStates, First @ # == Length @ First @ object - 1 + excess & ] ], requested ] ],
            vertexDensity = KeySort @ GroupBy[ ( Last @ Last @ # -> Lookup[ prefixes, Key @ # ] Lookup[ suffixes, Key @ # ] & ) /@
                DeleteCases[ VertexList @ carrier, finish ], First -> Last, Total ],
            edgeDensity = KeySort @ GroupBy[ ( DirectedEdge[ Last @ Last @ First @ #, Last @ Last @ Last @ # ] ->
                  Lookup[ prefixes, Key @ First @ # ] Lookup[ suffixes, Key @ Last @ # ] & ) /@
                Select[ EdgeList @ carrier, Last @ # =!= finish & ], First -> Last, Total ] },
          { support = Keys @ vertexDensity, lengths = DeleteDuplicates @ Sort[ First /@ terminalStates ] },
          { inside = AssociationThread[ support, True ] },
          <| "Graph" -> carrier, "Cardinality" -> Lookup[ prefixes, Key @ finish ], "CountsByExcess" -> counts,
            "Length" -> Replace[ lengths, { one_ } :> one ], "VertexDensity" -> vertexDensity, "EdgeDensity" -> edgeDensity,
            "Subgraph" -> Subgraph[ graph, support ], "CountingMeasure" -> Length @ support,
            "RiemannianMeasure" -> Count[ support, vertex_ /;
              AllTrue[ AdjacencyList[ graph, vertex ], TrueQ @ Lookup[ inside, Key @ # ] & ] ] |> ] ] ] ] },
    result /; AssociationQ[ result ] ]

InfraMeasurement[ graph_Graph, object_InfraDeformation, "Cardinality" ] :=
  With[ { data = InfraMeasurement[ graph, object, All ] },
    data[ "Cardinality" ] /; AssociationQ[ data ] ]

InfraMeasurement[ graph_Graph, object_InfraDeformation, "CountsByExcess" ] :=
  With[ { data = InfraMeasurement[ graph, object, All ] },
    data[ "CountsByExcess" ] /; AssociationQ[ data ] ]

InfraMeasurement[ graph_Graph, object_InfraDeformation, "Length" ] :=
  With[ { data = InfraMeasurement[ graph, object, All ] },
    data[ "Length" ] /; AssociationQ[ data ] ]

InfraMeasurement[ graph_Graph, object_InfraDeformation, "VertexDensity" ] :=
  With[ { data = InfraMeasurement[ graph, object, All ] },
    data[ "VertexDensity" ] /; AssociationQ[ data ] ]

InfraMeasurement[ graph_Graph, object_InfraDeformation, "EdgeDensity" ] :=
  With[ { data = InfraMeasurement[ graph, object, All ] },
    data[ "EdgeDensity" ] /; AssociationQ[ data ] ]

InfraMeasurement[ graph_Graph, object_InfraDeformation, "Subgraph" ] :=
  With[ { data = InfraMeasurement[ graph, object, All ] },
    data[ "Subgraph" ] /; AssociationQ[ data ] ]

InfraMeasurement[ graph_Graph, object_InfraDeformation, "CountingMeasure" ] :=
  With[ { data = InfraMeasurement[ graph, object, All ] },
    data[ "CountingMeasure" ] /; AssociationQ[ data ] ]

InfraMeasurement[ graph_Graph, object_InfraDeformation, "RiemannianMeasure" ] :=
  With[ { data = InfraMeasurement[ graph, object, All ] },
    data[ "RiemannianMeasure" ] /; AssociationQ[ data ] ]

InfraMeasurement[ graph_Graph, object_InfraDeformation, properties : { __String } ] :=
  With[ { data = InfraMeasurement[ graph, object, All ] },
    KeyTake[ data, properties ] /; AssociationQ[ data ] ]

InfraMemberQ[ graph_Graph,
    InfraDeformation[ reference : { __ },
      excessSpec : ( { _Integer?NonNegative } | { _Integer?NonNegative, _Integer?NonNegative } | UpTo[ _Integer?NonNegative ] ),
      opts : OptionsPattern[ InfraDeformation ] ], path_List ] /;
    SubsetQ[ Keys @ Options @ InfraDeformation, Keys @ { opts } ] &&
      UndirectedGraphQ[ graph ] && SimpleGraphQ[ graph ] && ! EdgeWeightedGraphQ[ graph ] &&
      AllTrue[ reference, VertexQ[ graph, # ] & ] &&
      AllTrue[ Partition[ reference, 2, 1 ], EdgeQ[ graph, UndirectedEdge @@ # ] & ] &&
      GraphDistance[ graph, First @ reference, Last @ reference ] == Length @ reference - 1 &&
      MatchQ[ OptionValue[ InfraDeformation, { opts }, "TubeRadius" ], _Integer?NonNegative | Infinity ] &&
      MatchQ[ OptionValue[ InfraDeformation, { opts }, "MaxStates" ], _Integer?Positive | Infinity ] &&
      ( ! MatchQ[ excessSpec, { _, _ } ] || First @ excessSpec <= Last @ excessSpec ) :=
  path =!= { } && First @ path === First @ reference && Last @ path === Last @ reference && DuplicateFreeQ[ path ] &&
    AllTrue[ path, VertexQ[ graph, # ] & ] &&
    AllTrue[ Partition[ path, 2, 1 ], EdgeQ[ graph, UndirectedEdge @@ # ] & ] &&
    With[ { excess = Length @ path - Length @ reference,
        bounds = Replace[ excessSpec, { { k_ } :> { k, k }, UpTo[ k_ ] :> { 0, k } } ] },
      First @ bounds <= excess <= Last @ bounds ] &&
    With[ { tube = AssociationThread[ VertexList @ NeighborhoodGraph[ graph, reference,
          Min[ OptionValue[ InfraDeformation, { opts }, "TubeRadius" ], VertexCount @ graph ] ], True ] },
      AllTrue[ path, TrueQ @ Lookup[ tube, Key @ # ] & ] ]

RandomInfraDeformation[ graph_Graph, object_InfraDeformation,
    count : ( Automatic | _Integer?NonNegative | UpTo[ _Integer?NonNegative ] | All ) : Automatic,
    opts : OptionsPattern[ ] ] /;
    SubsetQ[ Keys @ Options @ RandomInfraDeformation, Keys @ { opts } ] &&
      MemberQ[ { Automatic, Identity }, OptionValue[ RandomInfraDeformation, { opts }, "NextVertexFunction" ] ] &&
      OptionValue[ RandomInfraDeformation, { opts }, RandomSeeding ] =!= None :=
  With[ { result = BlockRandom[
      RandomInfraDeformation[ graph, object, count, "NextVertexFunction" -> OptionValue[ RandomInfraDeformation, { opts }, "NextVertexFunction" ], RandomSeeding -> None ],
      RandomSeeding -> OptionValue[ RandomInfraDeformation, { opts }, RandomSeeding ] ] },
    result /; ! MatchQ[ result, HoldPattern[ RandomInfraDeformation[ ___, RandomSeeding -> None ] ] ] ]

RandomInfraDeformation[ graph_Graph, object_InfraDeformation,
    count : ( Automatic | _Integer?NonNegative | UpTo[ _Integer?NonNegative ] | All ) : Automatic,
    opts : OptionsPattern[ ] ] /;
    SubsetQ[ Keys @ Options @ RandomInfraDeformation, Keys @ { opts } ] &&
      MemberQ[ { Automatic, Identity }, OptionValue[ RandomInfraDeformation, { opts }, "NextVertexFunction" ] ] &&
      OptionValue[ RandomInfraDeformation, { opts }, RandomSeeding ] === None :=
  With[ { result =
  With[ { carrier = InfraMeasurement[ graph, object, "Graph" ], finish = { -1 } },
    If[ ! GraphQ[ carrier ], Null,
      If[ VertexCount @ carrier == 0, { },
        With[ { source = First @ Pick[ VertexList @ carrier, VertexInDegree @ carrier, 0 ],
            successors = GroupBy[ EdgeList @ carrier, First -> Last ] },
          { suffixes = Fold[ { values, state } |-> Append[ values, state -> If[ state === finish, 1,
                Total @ Lookup[ values, Key /@ Lookup[ successors, Key @ state, { } ] ] ] ],
              <| |>, Reverse @ TopologicalSort @ carrier ] },
          { total = Lookup[ suffixes, Key @ source ] },
          { number = Replace[ count, { All -> total, Automatic -> Min[ 1, total ], UpTo[ n_ ] :> Min[ n, total ] } ] },
          If[ number > total, { },
            With[ { ranks = If[ count === All || OptionValue[ RandomInfraDeformation, { opts }, "NextVertexFunction" ] === Identity, Range[ number ],
                  RandomSample @ Keys @ Fold[ { selected, last } |-> With[ { draw = RandomInteger[ { 1, last } ] },
                      Append[ selected, If[ KeyExistsQ[ selected, draw ], last, draw ] -> True ] ],
                    <| |>, Range[ total - number + 1, total ] ] ] },
              { representatives = Map[ rank |-> ( Last @ Last @ First @ # & /@ Most @ NestWhileList[
                    state |-> With[ { targets = Lookup[ successors, Key @ First @ state ], residual = Last @ state },
                      { cumulative = Accumulate @ Lookup[ suffixes, Key /@ targets ] },
                      { choice = First @ FirstPosition[ cumulative, value_ /; value >= residual ] },
                      { targets[[ choice ]], residual - If[ choice == 1, 0, cumulative[[ choice - 1 ]] ] } ],
                    { source, rank }, First @ # =!= finish & ] ), ranks ] },
              If[ count === Automatic, First[ representatives, { } ], representatives ] ] ] ] ] ] ] },
    result /; ListQ[ result ] ]
