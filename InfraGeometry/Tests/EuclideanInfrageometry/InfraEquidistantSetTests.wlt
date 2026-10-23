VerificationTest[
  NameQ[ "System`InfraEquidistantSet" ],
  False,
  TestID -> "equidistant-no-system-collision"
]

VerificationTest[
  InfraMeasurement[ CompleteGraph[ 4 ], InfraEquidistantSet[ { 1, 2, 3 } ], "VertexDensity" ],
  <| 4 -> 1 |>,
  TestID -> "equidistant-three-anchor-locus"
]

VerificationTest[
  With[ { graph = CycleGraph[ 4 ] },
    InfraMeasurement[ graph, InfraEquidistantSet[ { 1, 3 } ], "VertexDensity" ] ===
      InfraMeasurement[ graph, InfraPerpendicularBisector[ 1, 3 ], "VertexDensity" ] ],
  True,
  TestID -> "equidistant-two-anchors-are-bisector"
]

VerificationTest[
  With[ { graph = CompleteGraph[ 5 ] },
    InfraMeasurement[ graph, InfraEquidistantSet[ { 1, 2, 3, 4 } ], "VertexDensity" ] ===
      InfraMeasurement[ graph, InfraIntersection[ InfraPerpendicularBisector[ 1, 2 ],
        InfraPerpendicularBisector[ 2, 3 ], InfraPerpendicularBisector[ 3, 4 ] ], "VertexDensity" ] ],
  True,
  TestID -> "equidistant-is-intersection-of-bisectors"
]

VerificationTest[
  With[ { graph = Graph[ { 1, 2, 3 }, { UndirectedEdge[ 1, 2 ] } ] },
    { InfraMeasurement[ graph, InfraEquidistantSet[ { 1 } ], "VertexDensity" ],
      InfraMeasurement[ graph, InfraEquidistantSet[ { 1, 1 } ], "VertexDensity" ],
      InfraMeasurement[ graph, InfraEquidistantSet[ { 1, 3 } ], "VertexDensity" ] } ],
  { <| 1 -> 1, 2 -> 1 |>, <| 1 -> 1, 2 -> 1 |>, <| |> },
  TestID -> "equidistant-finite-distance-components"
]

VerificationTest[
  InfraMeasurement[ Graph[ { 3, 1, 2 }, { } ], InfraEquidistantSet[ { } ], "VertexDensity" ],
  <| 3 -> 1, 1 -> 1, 2 -> 1 |>,
  TestID -> "equidistant-empty-anchors-all-vertices"
]

VerificationTest[
  InfraMeasurement[ Graph[ { }, { } ], InfraEquidistantSet[ { } ], "CountingMeasure" ],
  0,
  TestID -> "equidistant-empty-graph"
]

VerificationTest[
  With[ { graph = PathGraph[ { 1, 2 } ], object = InfraEquidistantSet[ { 1, 2 } ] },
    { InfraMeasurement[ graph, object, "Cardinality" ], InfraMeasurement[ graph, object, "CountingMeasure" ],
      InfraMemberQ[ graph, object, { } ] } ],
  { 1, 0, True },
  TestID -> "equidistant-empty-locus-one-object"
]

VerificationTest[
  With[ { graph = CycleGraph[ 4 ], object = InfraEquidistantSet[ { 1, 3 } ] },
    { InfraMemberQ[ graph, object, { 4, 2, 4 } ], InfraMemberQ[ graph, object, { 2 } ],
      InfraMeasurement[ graph, object, "CountingMeasure" ], VertexList @ InfraMeasurement[ graph, object, "Subgraph" ] } ],
  { True, False, 2, { 2, 4 } },
  TestID -> "equidistant-whole-set-membership-and-measures"
]

VerificationTest[
  InfraMeasurement[ PathGraph[ Range[ 4 ] ], InfraEquidistantSet[ { 1 } ], "RiemannianMeasure" ],
  4,
  TestID -> "equidistant-component-interior-measure"
]

VerificationTest[
  With[ { graph = Graph[ { { }, { 1 }, { 2 } },
      { UndirectedEdge[ { }, { 1 } ], UndirectedEdge[ { 1 }, { 2 } ] } ] },
    InfraMeasurement[ graph, InfraEquidistantSet[ { { }, { 2 } } ], "VertexDensity" ] ],
  <| { 1 } -> 1 |>,
  TestID -> "equidistant-list-and-empty-list-labels"
]

VerificationTest[
  With[ { label = InfraEquidistantSet[ { 99 } ] },
    InfraMeasurement[ Graph[ { label }, { } ], label, "VertexDensity" ] ],
  <| InfraEquidistantSet[ { 99 } ] -> 1 |>,
  TestID -> "equidistant-object-headed-vertex-is-literal"
]

VerificationTest[
  With[ { graph = PathGraph[ Range[ 3 ] ], object = InfraEquidistantSet[ { 1, 99 } ] },
    Head /@ Map[ property |-> InfraMeasurement[ graph, object, property ],
      { "VertexDensity", "Cardinality", "CountingMeasure", "Subgraph", "RiemannianMeasure", All } ] ],
  ConstantArray[ InfraMeasurement, 6 ],
  TestID -> "equidistant-invalid-anchors-stay-unevaluated"
]

VerificationTest[
  With[ { graph = PathGraph[ Range[ 3 ], DirectedEdges -> True ] },
    Head @ InfraMeasurement[ graph, InfraEquidistantSet[ { 1, 2 } ], "CountingMeasure" ] ],
  InfraMeasurement,
  TestID -> "equidistant-directed-graph-unsupported"
]

VerificationTest[
  With[ { graph = Graph[ { 1, 2 }, { UndirectedEdge[ 1, 2 ] }, EdgeWeight -> { 1 } ] },
    Head @ InfraMeasurement[ graph, InfraEquidistantSet[ { 1, 2 } ], "VertexDensity" ] ],
  InfraMeasurement,
  TestID -> "equidistant-weighted-graph-unsupported"
]

VerificationTest[
  With[ { graph = CycleGraph[ 4 ] },
    ( instance |-> instance[[ 1 ]][ locus ] ) /@
      RandomInfraSceneInstance[ InfraScene[ { locus }, { locus == InfraEquidistantSet[ { 1, 3 } ] } ], graph, All ] ],
  { { 2, 4 } },
  TestID -> "equidistant-scene-one-vertex-set"
]

VerificationTest[
  With[ { graph = CompleteGraph[ 4 ] },
    ( instance |-> instance[[ 1 ]][ locus ] ) /@
      RandomInfraSceneInstance[ InfraScene[ { locus }, { locus == InfraEquidistantSet[ { 1, 2, 3 } ] } ], graph, All ] ],
  { { 4 } },
  TestID -> "equidistant-scene-three-centres-one-vertex-set"
]

VerificationTest[
  RandomInfraPoint[ CycleGraph[ 4 ], InfraPoint[ InfraEquidistantSet[ { 1, 3 } ] ], All ],
  { 2, 4 },
  TestID -> "equidistant-explicit-point-sampling"
]

VerificationTest[
  GraphQ[ InfraSubstrateHighlight[ CycleGraph[ 4 ], { InfraEquidistantSet[ { 1, 3 } ] } ] ],
  True,
  TestID -> "equidistant-highlighter"
]

VerificationTest[
  With[ { graph = CycleGraph[ 4 ], scene = InfraScene[ { locus }, { locus == InfraEquidistantSet[ { 1, 3 } ] } ] },
    GraphQ[ InfraScenePlot[ scene, graph, RandomInfraSceneInstance[ scene, graph ] ] ] ],
  True,
  TestID -> "equidistant-scene-plot"
]

VerificationTest[
  With[ { graph = CycleGraph[ 4 ] },
    BlockRandom[ InfraMeasurement[ graph, InfraEquidistantSet[ { 1, 3 } ], All ]; RandomInteger[ 1000000 ], RandomSeeding -> 41 ] ===
      BlockRandom[ RandomInteger[ 1000000 ], RandomSeeding -> 41 ] ],
  True,
  TestID -> "equidistant-readers-preserve-random-state"
]


VerificationTest[
  InfraMeasurement[ CycleGraph[ 4 ], InfraEquidistantSet[ { 1, 3 } ], { "Cardinality", "CountingMeasure" } ],
  <| "Cardinality" -> 1, "CountingMeasure" -> 2 |>,
  TestID -> "equidistant-property-list"
]

VerificationTest[
  Head @ InfraMeasurement[ CycleGraph[ 4 ], InfraEquidistantSet[ { 1, 3 } ], { "CountingMeasure", "Length" } ],
  InfraMeasurement,
  TestID -> "equidistant-unsupported-property-list-stays-unevaluated"
]
