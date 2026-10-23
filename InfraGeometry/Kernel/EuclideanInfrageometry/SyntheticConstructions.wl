Package[ "WolframInstitute`InfraGeometry`" ]

Options[ RandomInfraMidpoint ] = { "NextVertexFunction" -> Automatic, RandomSeeding -> Automatic }

RandomInfraMidpoint[ args___ ] /; FreeQ[ { args }, RandomSeeding -> None, { 1 } ] :=
  With[ { result = BlockRandom[
      RandomInfraMidpoint[ Sequence @@ DeleteCases[ { args }, RandomSeeding -> _ ], RandomSeeding -> None ],
      RandomSeeding -> FirstCase[ { args }, ( RandomSeeding -> seed_ ) :> seed, Automatic ] ] },
    result /; ! MatchQ[ result, HoldPattern[ RandomInfraMidpoint[ ___, RandomSeeding -> None ] ] ] ]

RandomInfraMidpoint[ graph_Graph, p_, q_,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( UndirectedGraphQ[ graph ] && SimpleGraphQ[ graph ] && ! WeightedGraphQ[ graph ] &&
    VertexQ[ graph, p ] && VertexQ[ graph, q ] &&
    SubsetQ[ { "NextVertexFunction", RandomSeeding }, First /@ { opts } ] &&
    MemberQ[ { Automatic, Identity }, OptionValue[ RandomInfraMidpoint, { opts }, "NextVertexFunction" ] ] ) :=
  With[ { density = InfraMeasurement[ graph, InfraSegment[ p, q ], "Midpoint" ] },
    { members = Select[ VertexList[ graph ], vertex |-> KeyExistsQ[ density, vertex ] ] },
    Which[
      count === Automatic, If[ members === { }, { },
        If[ OptionValue[ "NextVertexFunction" ] === Identity, First @ members, RandomChoice @ members ] ],
      count === All, members,
      IntegerQ[ count ] && Length[ members ] < count, { },
      OptionValue[ "NextVertexFunction" ] === Identity, Take[ members, count ],
      True, RandomSample[ members, count ] ] ]

RandomInfraMidpoint[ graph_Graph, InfraMidpoint[ p_, q_ ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( SubsetQ[ { "NextVertexFunction", RandomSeeding }, First /@ { opts } ] &&
    MemberQ[ { Automatic, Identity }, OptionValue[ RandomInfraMidpoint, { opts }, "NextVertexFunction" ] ] ) :=
  With[ { result = RandomInfraMidpoint[ graph, p, q, count, opts ] }, result /; HoldComplete[ result ] =!= HoldComplete[ RandomInfraMidpoint[ graph, p, q, count, opts ] ] ]

Options[ RandomInfraRegionNearest ] = { "NextVertexFunction" -> Automatic, RandomSeeding -> Automatic }

RandomInfraRegionNearest[ args___ ] /; FreeQ[ { args }, RandomSeeding -> None, { 1 } ] :=
  With[ { result = BlockRandom[
      RandomInfraRegionNearest[ Sequence @@ DeleteCases[ { args }, RandomSeeding -> _ ], RandomSeeding -> None ],
      RandomSeeding -> FirstCase[ { args }, ( RandomSeeding -> seed_ ) :> seed, Automatic ] ] },
    result /; ! MatchQ[ result, HoldPattern[ RandomInfraRegionNearest[ ___, RandomSeeding -> None ] ] ] ]

RandomInfraRegionNearest[ graph_Graph, object_, p_,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( UndirectedGraphQ[ graph ] && SimpleGraphQ[ graph ] && ! WeightedGraphQ[ graph ] &&
    VertexQ[ graph, p ] &&
    SubsetQ[ { "NextVertexFunction", RandomSeeding }, First /@ { opts } ] &&
    MemberQ[ { Automatic, Identity }, OptionValue[ RandomInfraRegionNearest, { opts }, "NextVertexFunction" ] ] ) :=
  With[ { density = Which[
      VertexQ[ graph, object ], <| object -> 1 |>,
      ListQ[ object ] && AllTrue[ object, vertex |-> VertexQ[ graph, vertex ] ], Counts[ object ],
      AssociationQ[ object ], object,
      GraphQ[ object ], With[ { vertices = VertexList[ object ] }, Which[
        AllTrue[ vertices, vertex |-> VertexQ[ graph, vertex ] ], Counts[ vertices ],
        AllTrue[ vertices, vertex |-> MatchQ[ vertex, { _Integer, _ } ] ] &&
          Sort[ First /@ vertices ] === Range[ Length[ vertices ] ] &&
          AllTrue[ Last /@ vertices, vertex |-> VertexQ[ graph, vertex ] ], Counts[ Last /@ vertices ],
        True, object ] ],
      True, Quiet[ InfraMeasurement[ graph, object, "VertexDensity" ] ] ] },
    With[ { vertices = VertexList[ graph ] },
      { indices = AssociationThread[ vertices, Range @ Length[ vertices ] ],
      indexedGraph = VertexReplace[ graph, Thread[ vertices -> Range @ Length[ vertices ] ] ],
        support = Select[ density, value |-> value != 0 ] },
      { fromP = GraphDistance[ indexedGraph, Lookup[ indices, Key[ p ] ] ] },
      { reachable = Select[ Range @ Length[ vertices ],
          index |-> KeyExistsQ[ support, vertices[[ index ]] ] && fromP[[ index ]] < Infinity ] },
      { members = vertices[[ If[ reachable === { }, { }, MinimalBy[ reachable, index |-> fromP[[ index ]] ] ] ]] },
    Which[
      count === Automatic, If[ members === { }, { },
        If[ OptionValue[ "NextVertexFunction" ] === Identity, First @ members, RandomChoice @ members ] ],
      count === All, members,
      IntegerQ[ count ] && Length[ members ] < count, { },
      OptionValue[ "NextVertexFunction" ] === Identity, Take[ members, count ],
      True, RandomSample[ members, count ] ] ] /; AssociationQ[ density ] && AllTrue[ Keys[ density ], vertex |-> VertexQ[ graph, vertex ] ] &&
      AllTrue[ Values[ density ], NumericQ ] ]

RandomInfraRegionNearest[ graph_Graph, InfraRegionNearest[ object_, p_ ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( SubsetQ[ { "NextVertexFunction", RandomSeeding }, First /@ { opts } ] &&
    MemberQ[ { Automatic, Identity }, OptionValue[ RandomInfraRegionNearest, { opts }, "NextVertexFunction" ] ] ) :=
  With[ { result = RandomInfraRegionNearest[ graph, object, p, count, opts ] }, result /; HoldComplete[ result ] =!= HoldComplete[ RandomInfraRegionNearest[ graph, object, p, count, opts ] ] ]

InfraMeasurement[ graph_Graph, object : InfraMidpoint[ p_, q_ ], "VertexDensity" ] /;
    VertexQ[ graph, object ] || ( UndirectedGraphQ[ graph ] && SimpleGraphQ[ graph ] && ! WeightedGraphQ[ graph ] &&
      VertexQ[ graph, p ] && VertexQ[ graph, q ] ) :=
  If[ VertexQ[ graph, object ], <| object -> 1 |>,
    InfraMeasurement[ graph, InfraSegment[ p, q ], "Midpoint" ] ]

InfraMeasurement[ graph_Graph, object : InfraPerpendicularBisector[ p_, q_ ], "VertexDensity" ] /;
    VertexQ[ graph, object ] || ( UndirectedGraphQ[ graph ] && SimpleGraphQ[ graph ] && ! WeightedGraphQ[ graph ] &&
      VertexQ[ graph, p ] && VertexQ[ graph, q ] ) :=
  If[ VertexQ[ graph, object ], <| object -> 1 |>,
    With[ { vertices = VertexList[ graph ] },
      { indices = AssociationThread[ vertices, Range @ Length[ vertices ] ],
        indexedGraph = VertexReplace[ graph, Thread[ vertices -> Range @ Length[ vertices ] ] ] },
      { fromP = GraphDistance[ indexedGraph, Lookup[ indices, Key[ p ] ] ],
        fromQ = GraphDistance[ indexedGraph, Lookup[ indices, Key[ q ] ] ] },
      AssociationThread[ Pick[ vertices, MapThread[ { a, b } |-> a < Infinity && a == b, { fromP, fromQ } ], True ], 1 ] ] ]

InfraMeasurement[ graph_Graph, object_InfraRegionNearest, "VertexDensity" ] :=
  With[ { members = If[ VertexQ[ graph, object ], { object }, RandomInfraRegionNearest[ graph, object, All, RandomSeeding -> None ] ] },
    AssociationThread[ members, 1 ] /; ListQ[ members ] ]

InfraMeasurement[ graph_Graph, object : _InfraMidpoint | _InfraPerpendicularBisector | _InfraRegionNearest,
    property : ( "Cardinality" | "CountingMeasure" | "Subgraph" | "RiemannianMeasure" ) ] :=
  With[ { density = InfraMeasurement[ graph, object, "VertexDensity" ] },
    Switch[ property,
      "Cardinality", If[ MatchQ[ object, _InfraPerpendicularBisector ], 1, Length[ density ] ],
      "CountingMeasure", Length[ density ],
      "Subgraph", Subgraph[ graph, Keys[ density ] ],
      "RiemannianMeasure", With[ { support = Keys[ density ] },
        Count[ support, vertex_ /; AllTrue[ AdjacencyList[ graph, vertex ],
          neighbor |-> KeyExistsQ[ density, neighbor ] ] ] ] ] /; AssociationQ[ density ] ]

InfraMeasurement[ graph_Graph, object : _InfraMidpoint | _InfraPerpendicularBisector | _InfraRegionNearest, All ] :=
  With[ { density = InfraMeasurement[ graph, object, "VertexDensity" ] },
    AssociationMap[ property |-> InfraMeasurement[ graph, object, property ],
      { "VertexDensity", "Cardinality", "CountingMeasure", "Subgraph", "RiemannianMeasure" } ] /; AssociationQ[ density ] ]

InfraMemberQ[ graph_Graph, object : _InfraMidpoint | _InfraRegionNearest, vertex_ ] /;
    VertexQ[ graph, vertex ] :=
  With[ { density = InfraMeasurement[ graph, object, "VertexDensity" ] },
    KeyExistsQ[ density, vertex ] /; AssociationQ[ density ] ]


InfraMemberQ[ graph_Graph, object_InfraPerpendicularBisector, vertices_List ] :=
  With[ { density = InfraMeasurement[ graph, object, "VertexDensity" ] },
    Union[ vertices ] === Sort[ Keys[ density ] ] /; AssociationQ[ density ] ]
