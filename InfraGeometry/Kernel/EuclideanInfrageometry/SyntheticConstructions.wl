Package[ "WolframInstitute`InfraGeometry`" ]

Options[ RandomInfraMidpoint ] = { "NextVertexFunction" -> Automatic }

RandomInfraMidpoint[ graph_Graph, p_, q_,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    UndirectedGraphQ[ graph ] && SimpleGraphQ[ graph ] && ! WeightedGraphQ[ graph ] &&
    VertexQ[ graph, p ] && VertexQ[ graph, q ] &&
    SubsetQ[ { "NextVertexFunction" }, First /@ { opts } ] &&
    MemberQ[ { Automatic, Identity }, OptionValue[ RandomInfraMidpoint, { opts }, "NextVertexFunction" ] ] :=
  With[ { vertices = VertexList[ graph ] },
    { indices = AssociationThread[ vertices, Range @ Length[ vertices ] ],
      indexedGraph = VertexReplace[ graph, Thread[ vertices -> Range @ Length[ vertices ] ] ] },
    { fromP = GraphDistance[ indexedGraph, Lookup[ indices, Key[ p ] ] ],
      fromQ = GraphDistance[ indexedGraph, Lookup[ indices, Key[ q ] ] ] },
    { distance = fromP[[ Lookup[ indices, Key[ q ] ] ]] },
    { members = If[ distance === Infinity, { },
        Pick[ vertices, MapThread[ { a, b } |-> 2 a == distance && 2 b == distance, { fromP, fromQ } ], True ] ] },
    Which[
      count === Automatic, If[ members === { }, { },
        If[ OptionValue[ "NextVertexFunction" ] === Identity, First @ members, RandomChoice @ members ] ],
      count === All, members,
      IntegerQ[ count ] && Length[ members ] < count, { },
      OptionValue[ "NextVertexFunction" ] === Identity, Take[ members, count ],
      True, RandomSample[ members, count ] ] ]

RandomInfraMidpoint[ graph_Graph, InfraMidpoint[ p_, q_ ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    SubsetQ[ { "NextVertexFunction" }, First /@ { opts } ] &&
    MemberQ[ { Automatic, Identity }, OptionValue[ RandomInfraMidpoint, { opts }, "NextVertexFunction" ] ] :=
  With[ { result = RandomInfraMidpoint[ graph, p, q, count, opts ] }, result /; HoldComplete[ result ] =!= HoldComplete[ RandomInfraMidpoint[ graph, p, q, count, opts ] ] ]

Options[ RandomInfraPerpendicularBisector ] = { "NextVertexFunction" -> Automatic }

RandomInfraPerpendicularBisector[ graph_Graph, p_, q_,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    UndirectedGraphQ[ graph ] && SimpleGraphQ[ graph ] && ! WeightedGraphQ[ graph ] &&
    VertexQ[ graph, p ] && VertexQ[ graph, q ] &&
    SubsetQ[ { "NextVertexFunction" }, First /@ { opts } ] &&
    MemberQ[ { Automatic, Identity }, OptionValue[ RandomInfraPerpendicularBisector, { opts }, "NextVertexFunction" ] ] :=
  With[ { vertices = VertexList[ graph ] },
    { indices = AssociationThread[ vertices, Range @ Length[ vertices ] ],
      indexedGraph = VertexReplace[ graph, Thread[ vertices -> Range @ Length[ vertices ] ] ] },
    { fromP = GraphDistance[ indexedGraph, Lookup[ indices, Key[ p ] ] ],
      fromQ = GraphDistance[ indexedGraph, Lookup[ indices, Key[ q ] ] ] },
    { members = Pick[ vertices, MapThread[ { a, b } |-> a < Infinity && a == b, { fromP, fromQ } ], True ] },
    Which[
      count === Automatic, If[ members === { }, { },
        If[ OptionValue[ "NextVertexFunction" ] === Identity, First @ members, RandomChoice @ members ] ],
      count === All, members,
      IntegerQ[ count ] && Length[ members ] < count, { },
      OptionValue[ "NextVertexFunction" ] === Identity, Take[ members, count ],
      True, RandomSample[ members, count ] ] ]

RandomInfraPerpendicularBisector[ graph_Graph, InfraPerpendicularBisector[ p_, q_ ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    SubsetQ[ { "NextVertexFunction" }, First /@ { opts } ] &&
    MemberQ[ { Automatic, Identity }, OptionValue[ RandomInfraPerpendicularBisector, { opts }, "NextVertexFunction" ] ] :=
  With[ { result = RandomInfraPerpendicularBisector[ graph, p, q, count, opts ] }, result /; HoldComplete[ result ] =!= HoldComplete[ RandomInfraPerpendicularBisector[ graph, p, q, count, opts ] ] ]

Options[ RandomInfraRegionNearest ] = { "NextVertexFunction" -> Automatic }

RandomInfraRegionNearest[ graph_Graph, object_, p_,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    UndirectedGraphQ[ graph ] && SimpleGraphQ[ graph ] && ! WeightedGraphQ[ graph ] &&
    VertexQ[ graph, p ] &&
    SubsetQ[ { "NextVertexFunction" }, First /@ { opts } ] &&
    MemberQ[ { Automatic, Identity }, OptionValue[ RandomInfraRegionNearest, { opts }, "NextVertexFunction" ] ] :=
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
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    SubsetQ[ { "NextVertexFunction" }, First /@ { opts } ] &&
    MemberQ[ { Automatic, Identity }, OptionValue[ RandomInfraRegionNearest, { opts }, "NextVertexFunction" ] ] :=
  With[ { result = RandomInfraRegionNearest[ graph, object, p, count, opts ] }, result /; HoldComplete[ result ] =!= HoldComplete[ RandomInfraRegionNearest[ graph, object, p, count, opts ] ] ]

InfraMeasurement[ graph_Graph, object : _InfraMidpoint | _InfraPerpendicularBisector | _InfraRegionNearest,
    "VertexDensity" ] :=
  With[ { members = If[ VertexQ[ graph, object ], { object },
      Switch[ Head[ object ],
        InfraMidpoint, RandomInfraMidpoint[ graph, object, All ],
        InfraPerpendicularBisector, RandomInfraPerpendicularBisector[ graph, object, All ],
        InfraRegionNearest, RandomInfraRegionNearest[ graph, object, All ] ] ] },
    AssociationThread[ members, 1 ] /; ListQ[ members ] ]

InfraMeasurement[ graph_Graph, object : _InfraMidpoint | _InfraPerpendicularBisector | _InfraRegionNearest,
    property : ( "Cardinality" | "CountingMeasure" | "Subgraph" | "RiemannianMeasure" ) ] :=
  With[ { density = InfraMeasurement[ graph, object, "VertexDensity" ] },
    Switch[ property,
      "Cardinality" | "CountingMeasure", Length[ density ],
      "Subgraph", Subgraph[ graph, Keys[ density ] ],
      "RiemannianMeasure", With[ { support = Keys[ density ] },
        Count[ support, vertex_ /; AllTrue[ AdjacencyList[ graph, vertex ],
          neighbor |-> KeyExistsQ[ density, neighbor ] ] ] ] ] /; AssociationQ[ density ] ]

InfraMeasurement[ graph_Graph, object : _InfraMidpoint | _InfraPerpendicularBisector | _InfraRegionNearest, All ] :=
  With[ { density = InfraMeasurement[ graph, object, "VertexDensity" ] },
    AssociationMap[ property |-> InfraMeasurement[ graph, object, property ],
      { "VertexDensity", "Cardinality", "CountingMeasure", "Subgraph", "RiemannianMeasure" } ] /; AssociationQ[ density ] ]

InfraMemberQ[ graph_Graph, object : _InfraMidpoint | _InfraPerpendicularBisector | _InfraRegionNearest, vertex_ ] /;
    VertexQ[ graph, vertex ] :=
  With[ { density = InfraMeasurement[ graph, object, "VertexDensity" ] },
    KeyExistsQ[ density, vertex ] /; AssociationQ[ density ] ]

InfraDensity[ graph_Graph, object : _InfraMidpoint | _InfraPerpendicularBisector | _InfraRegionNearest ] :=
  With[ { density = InfraMeasurement[ graph, object, "VertexDensity" ] }, density /; AssociationQ[ density ] ]
