BeginTestSection[ "InfraCircleThrough" ]

CircleThroughOracle[ graph_Graph, points_List, center_, band_List ] :=
  With[
    { vertices = VertexList[ graph ], indexed = IndexGraph[ graph ] },
    { requested = Sort @ DeleteDuplicates[ (point |-> First @ FirstPosition[ SameQ[ #, point ] & /@ vertices, True ]) /@ points ],
      centerIndex = First @ FirstPosition[ SameQ[ #, center ] & /@ vertices, True ] },
    { distances = GraphDistance[ indexed, centerIndex ] },
    { shell = Select[ Range[ Length[ vertices ] ], index |-> TrueQ[ band[[ 1 ]] <= distances[[ index ]] <= band[[ 2 ]] ] ],
      outside = Select[ Range[ Length[ vertices ] ], index |-> band[[ 2 ]] < distances[[ index ]] < Infinity ] },
    { cycles = (cycle |-> First /@ cycle) /@ FindCycle[ Subgraph[ indexed, shell ], Infinity, All ] },
    { admitted = Select[ cycles, cycle |-> SubsetQ[ cycle, requested ] &&
        Intersection[ outside, VertexComponent[ VertexDelete[ indexed, cycle ], centerIndex ] ] === {} ] },
    { shortest = If[ admitted === {}, {}, MinimalBy[ admitted, Length ] ] },
    { canonical = (cycle |-> With[
        { rotated = RotateLeft[ cycle, First @ FirstPosition[ cycle, First[ requested ] ] - 1 ] },
        If[ rotated[[ 2 ]] < Last[ rotated ], rotated, Prepend[ Reverse[ Rest[ rotated ] ], First[ rotated ] ] ] ]) /@ shortest },
    Sort[ DeleteDuplicates[ (cycle |-> vertices[[ cycle ]]) /@ canonical ] ]
  ]

CircleThroughAgreement[ graph_Graph, points_List, center_, band_List ] :=
  With[ { token = InfraCircleThrough[ points, InfraCircle[ center, band ] ],
      expected = CircleThroughOracle[ graph, points, center, band ] },
    { data = InfraMeasurement[ graph, token, All ] },
    { actual = RandomInfraCircleThrough[ data[ "Graph" ], All ],
      paths = If[ VertexCount[ data[ "Graph" ] ] == 0, {},
        FindPath[ data[ "Graph" ],
          First @ Pick[ VertexList[ data[ "Graph" ] ], VertexInDegree[ data[ "Graph" ] ], 0 ],
          First @ Pick[ VertexList[ data[ "Graph" ] ], VertexOutDegree[ data[ "Graph" ] ], 0 ], Infinity, All ] ] },
    Sort[ actual ] === expected && Length[ actual ] == data[ "Cardinality" ] && DuplicateFreeQ[ actual ] &&
      AcyclicGraphQ[ data[ "Graph" ] ] && data[ "Faithful" ] &&
      data[ "Length" ] === If[ expected === {}, Infinity, Length[ First[ expected ] ] ] &&
      Sort[ ( Last /@ Most[ # ] & ) /@ paths ] === expected &&
      data[ "VertexDensity" ] === KeySort @ Counts @ Catenate[ actual ] &&
      data[ "EdgeDensity" ] === KeySort @ Counts @ Catenate[
        ( UndirectedEdge @@ Sort[ # ] & /@ Partition[ Append[ #, First[ # ] ], 2, 1 ] & ) /@ actual ]
  ]

CircleThroughDiamondGraph[ number_Integer?Positive ] :=
  With[
    { joints = Range[ 2, number + 2 ], branches = Partition[ Range[ number + 3, 3 number + 2 ], 2 ] },
    { ring = Join[
        Catenate @ MapThread[ { left, right, pair } |-> Catenate[ ({ left <-> #, # <-> right } &) /@ pair ],
          { Most[ joints ], Rest[ joints ], branches } ], { Last[ joints ] <-> First[ joints ] } ] },
    Graph[ Range[ 3 number + 2 ], Join[ ring, (1 <-> # &) /@ Range[ 2, 3 number + 2 ] ] ]
  ]


VerificationTest[
  CircleThroughAgreement[ WheelGraph[ 5 ], { 2, 4 }, 1, { 1, 1 } ], True,
  TestID -> "wheel-path-bijection"
]

VerificationTest[
  CircleThroughAgreement[ StarGraph[ 5 ], { 2, 3, 4 }, 1, { 1, 1 } ], True,
  TestID -> "star-has-no-circle"
]

VerificationTest[
  With[ { graph = CompleteGraph[ 5 ] },
    { dag = InfraMeasurement[ graph, InfraCircleThrough[ { 2, 3, 4, 5 }, InfraCircle[ 1, { 1, 1 } ] ], All ] },
    CircleThroughAgreement[ graph, { 2, 3, 4, 5 }, 1, { 1, 1 } ] && dag[ "Cardinality" ] == 3 &&
      Length[ DeleteDuplicates[ Sort /@ RandomInfraCircleThrough[ dag[ "Graph" ], All ] ] ] == 1 ],
  True, TestID -> "distinct-cycles-on-identical-support"
]

VerificationTest[
  CircleThroughAgreement[ WheelGraph[ 5 ], { 1 }, 1, { 1, 1 } ] &&
    CircleThroughAgreement[ WheelGraph[ 5 ], { 2 }, 1, { 1, 1 } ],
  True, TestID -> "singleton-request-and-center-outside-band"
]

VerificationTest[
  With[ { graph = Graph[ { 1 <-> 2, 1 <-> 3, 1 <-> 4, 2 <-> 3, 3 <-> 4, 4 <-> 2,
      5 <-> 6, 6 <-> 7, 7 <-> 8, 8 <-> 5, 2 <-> 5, 2 <-> 8, 3 <-> 6, 4 <-> 7, 5 <-> 9 } ] },
    { dag = InfraMeasurement[ graph, InfraCircleThrough[ { 5, 6, 7, 8 }, InfraCircle[ 1, { 1, 2 } ] ], All ] },
    { CircleThroughAgreement[ graph, { 5, 6, 7, 8 }, 1, { 1, 2 } ], dag[ "Length" ],
      Select[ RandomInfraCircle[ graph, InfraCircle[ 1, { 1, 2 } ], All ], cycle |-> SubsetQ[ cycle, { 5, 6, 7, 8 } ] ],
      RandomInfraCircleThrough[ dag[ "Graph" ], All ] } ],
  { True, 4, {}, { { 5, 6, 7, 8 } } }, TestID -> "constrained-minimum-not-filtering"
]

VerificationTest[
  And @@ Table[ With[ { graph = CircleThroughDiamondGraph[ number ] },
    { dag = InfraMeasurement[ graph, InfraCircleThrough[ Range[ 2, number + 2 ], InfraCircle[ 1, { 1, 1 } ] ], All ] },
    CircleThroughAgreement[ graph, Range[ 2, number + 2 ], 1, { 1, 1 } ] &&
      dag[ "Cardinality" ] == 2^number && dag[ "Length" ] == 2 number + 1 && VertexCount[ dag[ "Graph" ] ] <= 6 number + 6 ],
    { number, 2, 6 } ], True, TestID -> "diamond-exponential-family-linear-storage"
]

VerificationTest[
  BlockRandom[ SeedRandom[ 261011 ];
    And @@ Table[ With[ { graph = RandomGraph[ { 7, RandomInteger[ { 0, 14 } ] } ] },
      CircleThroughAgreement[ graph, RandomSample[ Range[ 2, 7 ], RandomInteger[ { 1, 3 } ] ], 1,
        { 1, RandomInteger[ { 1, 3 } ] } ] ], { 80 } ] ],
  True, TestID -> "80-exhaustive-random-graph-oracles"
]

VerificationTest[
  With[ { graph = Graph[ { 1, 2, 3, 4, 5, 6, 7 }, { 1 <-> 2, 1 <-> 3, 1 <-> 4,
      2 <-> 3, 3 <-> 4, 4 <-> 2, 5 <-> 6, 6 <-> 7, 7 <-> 5 } ] },
    CircleThroughAgreement[ graph, { 2, 5 }, 1, { 1, 1 } ] ], True,
  TestID -> "disconnected-requests-empty"
]

VerificationTest[
  With[ { graph = VertexReplace[ WheelGraph[ 5 ], { 1 -> "center", 2 -> {}, 3 -> { 1 }, 4 -> { 2, 3 }, 5 -> "last" } ] },
    CircleThroughAgreement[ graph, { {}, { 2, 3 } }, "center", { 1, 1 } ] ], True,
  TestID -> "literal-list-and-empty-list-labels"
]

VerificationTest[
  With[ { graph = WheelGraph[ 5 ] },
    RandomInfraCircleThrough[ graph, InfraCircleThrough[ { 4, 2, 4 }, InfraCircle[ 1, { 1, 1 } ] ], All ] ===
      RandomInfraCircleThrough[ graph, InfraCircleThrough[ { 2, 4 }, InfraCircle[ 1, { 1, 1 } ] ], All ] ],
  True, TestID -> "request-order-and-repetitions"
]

VerificationTest[
  With[ { dag = InfraMeasurement[ CircleThroughDiamondGraph[ 4 ], InfraCircleThrough[ Range[ 2, 6 ], InfraCircle[ 1, { 1, 1 } ] ], All ] },
    BlockRandom[ SeedRandom[ 261011 ]; With[ { sample = RandomInfraCircleThrough[ dag[ "Graph" ], 5, RandomSeeding -> None ] },
      Length[ sample ] == 5 && DuplicateFreeQ[ sample ] && SubsetQ[ RandomInfraCircleThrough[ dag[ "Graph" ], All, RandomSeeding -> None ], sample ] &&
      RandomInfraCircleThrough[ dag[ "Graph" ], 17, RandomSeeding -> None ] === {} && Length[ RandomInfraCircleThrough[ dag[ "Graph" ], UpTo[ 17 ], RandomSeeding -> None ] ] == 16 &&
      RandomInfraCircleThrough[ dag[ "Graph" ], 0, RandomSeeding -> None ] === {} ] ] ], True, TestID -> "sampling-and-shortage"
]

VerificationTest[
  BlockRandom[ SeedRandom[ 44 ]; With[ { expected = RandomInteger[ 1000000, 10 ] },
    SeedRandom[ 44 ];
    RandomInfraCircleThrough[ WheelGraph[ 5 ], InfraCircleThrough[ { 2 }, InfraCircle[ 1, { 1, 1 } ] ], All, RandomSeeding -> None ];
    RandomInteger[ 1000000, 10 ] === expected ] ], True, TestID -> "all-does-not-consume-rng"
]

VerificationTest[
  Head /@ {
    InfraMeasurement[ WheelGraph[ 5 ], InfraCircleThrough[ {}, InfraCircle[ 1, { 1, 1 } ] ], "Graph" ],
    InfraMeasurement[ Graph[ { 1 -> 2, 2 -> 3, 3 -> 1 } ], InfraCircleThrough[ { 2 }, InfraCircle[ 1, { 1, 1 } ] ], "Graph" ],
    InfraMeasurement[ Graph[ WheelGraph[ 5 ], EdgeWeight -> 1 ], InfraCircleThrough[ { 2 }, InfraCircle[ 1, { 1, 1 } ] ], "Graph" ] },
  { InfraMeasurement, InfraMeasurement, InfraMeasurement },
  TestID -> "unsupported-inputs-remain-unevaluated"
]

VerificationTest[
  CircleThroughAgreement[ PetersenGraph[], { 3, 4 }, 1, { 2, 2 } ], True,
  TestID -> "petersen-independent-oracle"
]

VerificationTest[
  And @@ Map[ name |-> With[ { graph = InfraSubstrate[ name, "Small" ] },
    { center = First[ GraphCenter[ graph ] ], band = If[ name == "HexagonalTilingGraph", { 1, 3 }, { 1, 2 } ] },
    { circles = RandomInfraCircle[ graph, InfraCircle[ center, band ], All ] },
    { points = Take[ First[ circles ], UpTo[ 3 ] ] },
    CircleThroughAgreement[ graph, points, center, band ] ],
    { "SquareGridGraph", "TriangularTilingGraph", "HexagonalTilingGraph" } ], True,
  TestID -> "three-named-substrate-oracles"
]


VerificationTest[
  Head @ InfraMeasurement[ WheelGraph[ 5 ], InfraCircleThrough[ { Blank[] }, InfraCircle[ 1, { 1, 1 } ] ], All ],
  InfraMeasurement,
  TestID -> "absent-pattern-shaped-request-remains-unevaluated"
]

VerificationTest[
  With[ { labels = { 0, 1, 2, Blank[ Integer ] } },
    { graph = Graph[ labels, ( UndirectedEdge @@ labels[[ # ]] & ) /@ Subsets[ Range[ 4 ], { 2 } ] ] },
    { dag = InfraMeasurement[ graph, InfraCircleThrough[ { Blank[ Integer ] }, InfraCircle[ 0, { 1, 1 } ] ], All ] },
    { dag[ "Cardinality" ], KeyExistsQ[ dag[ "VertexDensity" ], Blank[ Integer ] ],
      CircleThroughAgreement[ graph, { Blank[ Integer ] }, 0, { 1, 1 } ] } ],
  { 1, True, True },
  TestID -> "literal-pattern-shaped-rim-vertex"
]

VerificationTest[
  With[ { labels = { Blank[ Integer ], 1, 2, 3 } },
    { graph = Graph[ labels, ( UndirectedEdge @@ labels[[ # ]] & ) /@ Subsets[ Range[ 4 ], { 2 } ] ] },
    { dag = InfraMeasurement[ graph, InfraCircleThrough[ { 1 }, InfraCircle[ Blank[ Integer ], { 1, 1 } ] ], All ] },
    { dag[ "Cardinality" ], FreeQ[ Values[ dag[ "VertexDensity" ] ], _Missing ], CircleThroughAgreement[ graph, { 1 }, Blank[ Integer ], { 1, 1 } ] } ],
  { 1, True, True },
  TestID -> "literal-pattern-shaped-center"
]

VerificationTest[
  With[ { graph = CompleteGraph[ 5 ], token = InfraCircleThrough[ { 2, 3, 4, 5 }, InfraCircle[ 1, { 1, 1 } ] ] },
    { Length[ RandomInfraCircleThrough[ graph, token ] ], Length[ RandomInfraCircleThrough[ graph, token, 2 ] ],
      RandomInfraCircleThrough[ graph, token, 4 ], Length[ RandomInfraCircleThrough[ graph, token, UpTo[ 4 ] ] ] } ],
  { 4, 2, {}, 3 },
  TestID -> "named-sampler-count-contract"
]

VerificationTest[
  With[ { graph = CompleteGraph[ 5 ], token = InfraCircleThrough[ { 2, 3, 4, 5 }, InfraCircle[ 1, { 1, 1 } ] ] },
    AllTrue[ RandomInfraCircleThrough[ graph, token, All ], cycle |->
      InfraMemberQ[ graph, token, RotateLeft[ Reverse[ cycle ] ] ] ] &&
      ! InfraMemberQ[ graph, token, { 2, 3, 2, 4 } ] ],
  True,
  TestID -> "circle-membership-cyclic-identity-and-simplicity"
]

VerificationTest[
  With[ { graph = CompleteGraph[ 5 ], token = InfraCircleThrough[ { 2, 3, 4, 5 }, InfraCircle[ 1, { 1, 1 } ] ] },
    { scene = InfraScene[ { circle }, { circle == token } ] },
    { Sort[ ( #[[ 1 ]][ circle ] & ) /@ RandomInfraSceneInstance[ scene, graph, All ] ] ===
        Sort[ RandomInfraCircleThrough[ graph, token, All ] ],
      Length[ InfraSceneMultiway[ scene, graph ][ "Instances" ] ],
      Head[ InfraSubstrateHighlight[ graph, { token } ] ],
      Head[ InfraScenePlot[ scene, graph, First[ RandomInfraSceneInstance[ scene, graph, All ] ] ] ] } ],
  { True, 3, Graph, Graph },
  TestID -> "circle-through-scene-multiway-and-drawing"
]


VerificationTest[
  Head @ InfraMeasurement[ StarGraph[ 5 ], InfraCircleThrough[ {}, InfraCircle[ 1, { 1, 1 } ] ], "VertexDensity" ],
  InfraMeasurement,
  TestID -> "invalid-circle-through-density-stays-unevaluated"
]

VerificationTest[
  Head @ InfraMeasurement[ WheelGraph[ 5 ], InfraCircleThrough[ { 2 }, InfraCircle[ 1, { 1, 1 } ] ], "Area" ],
  InfraMeasurement,
  TestID -> "unsupported-circle-through-property-stays-unevaluated"
]

VerificationTest[
  Head @ InfraMeasurement[ WheelGraph[ 5 ], InfraCircleThrough[ { Blank[] }, InfraCircle[ 1, { 1, 1 } ] ],
    { "Graph", "VertexDensity" } ],
  InfraMeasurement,
  TestID -> "invalid-circle-through-property-list-stays-unevaluated"
]

EndTestSection[]
