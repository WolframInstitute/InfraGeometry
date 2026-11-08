Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: CausalInfrageometry :: InfraWorldline *)

Options[ RandomInfraWorldline ] = { "NextVertexFunction" -> Automatic, RandomSeeding -> Automatic }

RandomInfraWorldline[ args___ ] /; FreeQ[ { args }, RandomSeeding -> None, { 1 } ] :=
  With[ { result = BlockRandom[
      RandomInfraWorldline[ Sequence @@ DeleteCases[ { args }, RandomSeeding -> _ ], RandomSeeding -> None ],
      RandomSeeding -> FirstCase[ { args }, ( RandomSeeding -> seed_ ) :> seed, Automatic ] ] },
    result /; ! MatchQ[ result, HoldPattern[ RandomInfraWorldline[ ___, RandomSeeding -> None ] ] ] ]

PackageScope[ chainLengths ]

chainLengths[ dag_Graph ] :=
  With[ { inNbr = GroupBy[ EdgeList @ dag, Last -> First ] },
    { lengths = Fold[
        { a, w } |-> Append[ a, w -> Replace[ Lookup[ inNbr, Key @ w, { } ],
          { { } -> { 0 }, ps_ :> Union @@ ( Lookup[ a, Key /@ ps ] + 1 ) } ] ],
        <| |>, TopologicalSort @ dag ] },
    Replace[ Union @@ Lookup[ lengths, Key /@ Pick[ VertexList @ dag, VertexOutDegree @ dag, 0 ] ], { one_ } :> one ] ]

InfraWorldline /: InfraMeasurement[ graph_Graph, InfraWorldline[ p_, q_ ], "Graph" ] :=
  TransitiveReductionGraph @ Subgraph[ graph, Intersection[ VertexOutComponent[ graph, { p } ], VertexInComponent[ graph, { q } ] ] ]

InfraWorldline /: InfraMeasurement[ graph_Graph, InfraWorldline[ ], "Graph" ] :=
  TransitiveReductionGraph @ graph

InfraWorldline /: InfraMeasurement[ graph_Graph, worldline_InfraWorldline, "Length" ] :=
  chainLengths @ InfraMeasurement[ graph, worldline, "Graph" ]

InfraWorldline /: InfraMeasurement[ _Graph, _InfraWorldline, "Faithful" ] :=
  True

InfraWorldline /: InfraMeasurement[ graph_Graph, worldline_InfraWorldline, All ] :=
  InfraMeasurement[ graph, worldline,
    { "Graph", "Faithful", "Cardinality", "Length", "VertexDensity", "EdgeDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" } ]

RandomInfraWorldline[ graph_Graph, worldline_InfraWorldline,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    MemberQ[ { opts }, RandomSeeding -> None ] &&
    SubsetQ[ First /@ Options[ RandomInfraWorldline ], First /@ { opts } ] &&
    ( OptionValue[ RandomInfraWorldline, { opts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) :=
  chainSample[ InfraMeasurement[ graph, worldline, "Graph" ], count,
    OptionValue[ RandomInfraWorldline, { opts }, "NextVertexFunction" ] ]

RandomInfraWorldline[ graph_Graph,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    MemberQ[ { opts }, RandomSeeding -> None ] &&
    SubsetQ[ First /@ Options[ RandomInfraWorldline ], First /@ { opts } ] :=
  RandomInfraWorldline[ graph, InfraWorldline[ ], count, opts ]

RandomInfraWorldline[ graph_Graph, p_, q_,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    MemberQ[ { opts }, RandomSeeding -> None ] &&
    VertexQ[ graph, p ] && VertexQ[ graph, q ] && SubsetQ[ First /@ Options[ RandomInfraWorldline ], First /@ { opts } ] :=
  RandomInfraWorldline[ graph, InfraWorldline[ p, q ], count, opts ]

InfraWorldlineQ[ graph_Graph, chains : { __List } ] /; ! AllTrue[ chains, VertexQ[ graph, # ] & ] :=
  AllTrue[ chains, InfraWorldlineQ[ graph, # ] & ]

InfraWorldlineQ[ graph_Graph, chain_List ] :=
  chain =!= { } && AllTrue[ chain, VertexQ[ graph, # ] & ] &&
    AllTrue[ Partition[ chain, 2, 1 ],
      Apply[ { u, v } |-> Length @ Intersection[ VertexOutComponent[ graph, { u } ], VertexInComponent[ graph, { v } ] ] == 2 ] ]
