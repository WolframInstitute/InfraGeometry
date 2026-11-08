Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: CausalInfrageometry :: InfraTimelikeGeodesic *)

Options[ RandomInfraTimelikeGeodesic ] = { "NextVertexFunction" -> Automatic, RandomSeeding -> Automatic }

RandomInfraTimelikeGeodesic[ args___ ] /; FreeQ[ { args }, RandomSeeding -> None, { 1 } ] :=
  With[ { result = BlockRandom[
      RandomInfraTimelikeGeodesic[ Sequence @@ DeleteCases[ { args }, RandomSeeding -> _ ], RandomSeeding -> None ],
      RandomSeeding -> FirstCase[ { args }, ( RandomSeeding -> seed_ ) :> seed, Automatic ] ] },
    result /; ! MatchQ[ result, HoldPattern[ RandomInfraTimelikeGeodesic[ ___, RandomSeeding -> None ] ] ] ]

PackageScope[ chainSample ]

chainSample[ dag_Graph, count_, nextFn_ ] :=
  With[ { out = GroupBy[ List @@@ EdgeList @ dag, First -> Last ],
          sources = Sort @ Pick[ VertexList @ dag, VertexInDegree @ dag, 0 ],
          sinks = Sort @ Pick[ VertexList @ dag, VertexOutDegree @ dag, 0 ],
          cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ] },
    { beta = Fold[
        { a, w } |-> Append[ a, w -> Replace[ Lookup[ out, Key @ w, { } ],
          { { } -> 1, qs_ :> Total @ Lookup[ a, Key /@ qs ] } ] ],
        <| |>, Reverse @ TopologicalSort @ dag ] },
    { cardinality = Total @ Lookup[ beta, Key /@ sources ],
      draw = ignored |-> NestWhile[
        path |-> With[ { nexts = Lookup[ out, Key @ Last @ path, { } ] },
          Append[ path, RandomChoice[ Lookup[ beta, Key /@ nexts ] -> nexts ] ] ],
        { RandomChoice[ Lookup[ beta, Key /@ sources ] -> sources ] },
        path |-> Lookup[ out, Key @ Last @ path, { } ] =!= { } ],
      paths = ignored |-> Catenate @ Catenate @ Outer[
        If[ #1 === #2, { { #1 } }, FindPath[ dag, #1, #2, Infinity, All ] ] &, sources, sinks, 1 ],
      enumerate = { starts, limit } |-> Catenate @ Last @ Reap @ NestWhile[
        Apply[ { stack, got } |-> With[ { path = First @ stack },
          { nexts = Sort @ Lookup[ out, Key @ Last @ path, { } ] },
          { selected = If[ nexts === { } || nextFn === Automatic, nexts,
              Replace[ nextFn @ nexts, candidate_ /; MemberQ[ nexts, Verbatim @ candidate ] :> { candidate } ] ] },
          If[ nexts === { },
            ( Sow[ path ]; { Rest @ stack, got + 1 } ),
            { Join[ Append[ path, # ] & /@ selected, Rest @ stack ], got } ] ] ],
        { starts, 0 },
        state |-> First @ state =!= { } && Last @ state < limit ] },
    { distinct = generate |-> First @ NestWhile[
        state |-> With[ { member = generate[ Null ] },
          If[ MemberQ[ First @ state, member ], state, { Append[ First @ state, member ], Last @ state + 1 } ] ],
        { { }, 0 },
        Last @ # < If[ MatchQ[ count, _UpTo ], Min[ cap, cardinality ], cap ] & ] },
    { members = Which[
        cardinality == 0, { },
        count === Automatic && nextFn === Automatic, { draw[ Null ] },
        nextFn === RandomChoice,
          If[ cap > cardinality && ! MatchQ[ count, _UpTo ], { },
            distinct[ ignored |-> First[ enumerate[ { { RandomChoice @ sources } }, 1 ], { } ] ] ],
        nextFn =!= Automatic, enumerate[ List /@ sources, cap ],
        count === All, paths[ Null ],
        cap > cardinality && ! MatchQ[ count, _UpTo ], { },
        2 cap >= cardinality, RandomSample[ paths[ Null ], count ],
        True, distinct[ draw ] ] },
    Switch[ count,
      Automatic, First[ members, { } ],
      All,       members,
      _UpTo,     If[ nextFn === Automatic, members, Take[ members, count ] ],
      _,         If[ Length @ members < count, { }, Take[ members, count ] ] ] ]

InfraTimelikeGeodesic /: InfraMeasurement[ graph_Graph, InfraTimelikeGeodesic[ p_, q_ ], "Graph" ] :=
  With[ { interval = Subgraph[ graph, Intersection[ VertexOutComponent[ graph, { p } ], VertexInComponent[ graph, { q } ] ] ] },
    { up = CausalHeight @ interval, down = CausalHeight @ ReverseGraph @ interval },
    { carriers = Select[ VertexList @ interval, up[ # ] + down[ # ] == Lookup[ up, Key @ q ] & ] },
    Graph[ carriers, Select[ EdgeList @ Subgraph[ interval, carriers ], up[ Last @ # ] == up[ First @ # ] + 1 & ] ] ]

InfraTimelikeGeodesic /: InfraMeasurement[ graph_Graph, InfraTimelikeGeodesic[ ], "Graph" ] :=
  With[ { up = CausalHeight @ graph, down = CausalHeight @ ReverseGraph @ graph },
    { carriers = Select[ VertexList @ graph, up[ # ] + down[ # ] == Max[ 0, Values @ up ] & ] },
    Graph[ carriers, Select[ EdgeList @ Subgraph[ graph, carriers ], up[ Last @ # ] == up[ First @ # ] + 1 & ] ] ]

InfraTimelikeGeodesic /: InfraMeasurement[ graph_Graph, InfraTimelikeGeodesic[ p_, q_ ], "Length" ] :=
  Lookup[ CausalHeight @ Subgraph[ graph, Intersection[ VertexOutComponent[ graph, { p } ], VertexInComponent[ graph, { q } ] ] ],
    Key @ q, - Infinity ]

InfraTimelikeGeodesic /: InfraMeasurement[ graph_Graph, InfraTimelikeGeodesic[ ], "Length" ] :=
  Max[ 0, Values @ CausalHeight @ graph ]

InfraTimelikeGeodesic /: InfraMeasurement[ graph_Graph, InfraTimelikeGeodesic[ p_ ], "Graph" ] :=
  With[ { future = Subgraph[ graph, VertexOutComponent[ graph, { p } ] ] },
    { up = CausalHeight @ future, down = CausalHeight @ ReverseGraph @ future },
    { carriers = Select[ VertexList @ future, up[ # ] + down[ # ] == Max @ Values @ up & ] },
    Graph[ carriers, Select[ EdgeList @ Subgraph[ future, carriers ], up[ Last @ # ] == up[ First @ # ] + 1 & ] ] ]

InfraTimelikeGeodesic /: InfraMeasurement[ graph_Graph, InfraTimelikeGeodesic[ p_ ], "Length" ] :=
  Max @ Values @ CausalHeight @ Subgraph[ graph, VertexOutComponent[ graph, { p } ] ]

InfraTimelikeGeodesic /: InfraMeasurement[ graph_Graph, InfraTimelikeGeodesic[ knots : Repeated[ _, { 3, Infinity } ] ], "Graph" ] :=
  With[ { legs = InfraMeasurement[ graph, InfraTimelikeGeodesic @@ #, "Graph" ] & /@ Partition[ { knots }, 2, 1 ] },
    If[ AnyTrue[ legs, VertexCount @ # == 0 & ], Graph[ { }, { } ],
      Graph[ DeleteDuplicates @ Catenate[ VertexList /@ legs ], Catenate[ EdgeList /@ legs ] ] ] ]

InfraTimelikeGeodesic /: InfraMeasurement[ graph_Graph, InfraTimelikeGeodesic[ knots : Repeated[ _, { 3, Infinity } ] ], "Length" ] :=
  Total[ InfraMeasurement[ graph, InfraTimelikeGeodesic @@ #, "Length" ] & /@ Partition[ { knots }, 2, 1 ] ]

InfraTimelikeGeodesic /: InfraMeasurement[ _Graph, _InfraTimelikeGeodesic, "Faithful" ] :=
  True

InfraTimelikeGeodesic /: InfraMeasurement[ graph_Graph, geodesic_InfraTimelikeGeodesic, All ] :=
  InfraMeasurement[ graph, geodesic,
    { "Graph", "Faithful", "Cardinality", "Length", "VertexDensity", "EdgeDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" } ]

RandomInfraTimelikeGeodesic[ graph_Graph, geodesic_InfraTimelikeGeodesic,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    MemberQ[ { opts }, RandomSeeding -> None ] &&
    SubsetQ[ First /@ Options[ RandomInfraTimelikeGeodesic ], First /@ { opts } ] &&
    ( OptionValue[ RandomInfraTimelikeGeodesic, { opts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) :=
  chainSample[ InfraMeasurement[ graph, geodesic, "Graph" ], count,
    OptionValue[ RandomInfraTimelikeGeodesic, { opts }, "NextVertexFunction" ] ]

RandomInfraTimelikeGeodesic[ graph_Graph,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    MemberQ[ { opts }, RandomSeeding -> None ] &&
    SubsetQ[ First /@ Options[ RandomInfraTimelikeGeodesic ], First /@ { opts } ] :=
  RandomInfraTimelikeGeodesic[ graph, InfraTimelikeGeodesic[ ], count, opts ]

RandomInfraTimelikeGeodesic[ graph_Graph, p_, q_,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    MemberQ[ { opts }, RandomSeeding -> None ] &&
    VertexQ[ graph, p ] && VertexQ[ graph, q ] && SubsetQ[ First /@ Options[ RandomInfraTimelikeGeodesic ], First /@ { opts } ] :=
  RandomInfraTimelikeGeodesic[ graph, InfraTimelikeGeodesic[ p, q ], count, opts ]

InfraChainQ[ graph_Graph, chains : { __List } ] /; ! AllTrue[ chains, VertexQ[ graph, # ] & ] :=
  AllTrue[ chains, InfraChainQ[ graph, # ] & ]

InfraChainQ[ graph_Graph, chain_List ] :=
  chain =!= { } && AllTrue[ chain, VertexQ[ graph, # ] & ] && DuplicateFreeQ @ chain &&
    AllTrue[ Partition[ chain, 2, 1 ], Apply[ { u, v } |-> MemberQ[ VertexOutComponent[ graph, { u } ], v ] ] ]

InfraTimelikeGeodesicQ[ graph_Graph, chains : { __List } ] /; ! AllTrue[ chains, VertexQ[ graph, # ] & ] :=
  AllTrue[ chains, InfraTimelikeGeodesicQ[ graph, # ] & ]

InfraTimelikeGeodesicQ[ graph_Graph, chain_List ] :=
  InfraWorldlineQ[ graph, chain ] &&
    Length @ chain - 1 == InfraMeasurement[ graph, InfraTimelikeGeodesic[ First @ chain, Last @ chain ], "Length" ]
