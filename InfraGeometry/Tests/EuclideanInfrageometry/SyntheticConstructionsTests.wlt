VerificationTest[
  With[ { token = InfraHalfLine[ 1, 2 ] }, HoldComplete[ token ] ],
  HoldComplete[ InfraHalfLine[ 1, 2 ] ],
  TestID -> "synthetic-halfline-inert"
]


VerificationTest[
  With[ { token = InfraLine[ { 1, 2 } ] }, HoldComplete[ token ] ],
  HoldComplete[ InfraLine[ { 1, 2 } ] ],
  TestID -> "synthetic-legacy-line-germ-stays-inert"
]


VerificationTest[
  Keys @ InfraMeasurement[ PathGraph[ { 1, 2 } ], InfraSegment[ 1, 2 ], "Midpoint" ],
  { 1, 2 },
  TestID -> "synthetic-legacy-midpoint-retains-middle-layers"
]


VerificationTest[
  With[ { graph = PathGraph[ Range[ 5 ] ] },
    { RandomInfraHalfLine[ graph, InfraHalfLine[ 2, 3 ], All ] ===
        RandomInfraHalfLine[ graph, InfraRay[ 2, 3 ], All ],
      RandomInfraInfiniteLine[ graph, InfraInfiniteLine[ 2, 3 ], All ] ===
        RandomInfraInfiniteLine[ graph, InfraLine[ 2, 3 ], All ] } ],
  { True, True },
  TestID -> "synthetic-canonical-legacy-walk-families-agree"
]


VerificationTest[
  { NameQ[ "WolframInstitute`InfraGeometry`RandomInfraRepresentative" ],
    Names[ "WolframInstitute`InfraGeometry`RandomInfraRepresentative" ] },
  { False, {} },
  TestID -> "synthetic-removed-generic-name-absent-without-interning"
]


VerificationTest[
  RandomInfraPoint[ PathGraph[ { 3, 1, 2 } ], InfraPoint[], All ],
  { 3, 1, 2 },
  TestID -> "synthetic-point-token-pool-retains-vertex-order"
]


VerificationTest[
  RandomInfraPoint[ PathGraph[ { 1, 2 } ], InfraPoint[ 2 ], All ],
  { 2 },
  TestID -> "synthetic-fixed-integer-point-is-not-count"
]


VerificationTest[
  RandomInfraSegment[ PathGraph[ { 1, 2, 3 } ], InfraSegment[ 1, 3, 1 ], All ],
  { { 1, 2, 3, 2, 1 } },
  TestID -> "synthetic-polyline-retains-repeated-traversal"
]


VerificationTest[
  With[ { graph = PathGraph[ Range[ 5 ] ] },
    BlockRandom[ RandomInfraHalfLine[ graph, 2, 3, UpTo[ 3 ] ], RandomSeeding -> 41 ] ===
      BlockRandom[ RandomInfraRay[ graph, 2, 3, UpTo[ 3 ] ], RandomSeeding -> 41 ] ],
  True,
  TestID -> "synthetic-halfline-bare-legacy-seeded-alias"
]


VerificationTest[
  With[ { graph = PathGraph[ Range[ 5 ] ] },
    BlockRandom[ RandomInfraInfiniteLine[ graph, { 2, 3 }, UpTo[ 3 ] ], RandomSeeding -> 41 ] ===
      BlockRandom[ RandomInfraLine[ graph, { 2, 3 }, UpTo[ 3 ] ], RandomSeeding -> 41 ] ],
  True,
  TestID -> "synthetic-infiniteline-bare-sequence-legacy-seeded-alias"
]


VerificationTest[
  RandomInfraInfiniteLine[ PathGraph[ Range[ 3 ] ],
    InfraInfiniteLine[ PathGraph[ { 1, 2 }, DirectedEdges -> True ] ], All ],
  { { 1, 2, 3 } },
  TestID -> "synthetic-line-graph-germ-retains-middle-edges"
]


VerificationTest[
  With[ { graph = Graph[ Range[ 5 ], UndirectedEdge @@@
      { { 1, 2 }, { 1, 3 }, { 1, 4 }, { 1, 5 }, { 2, 3 }, { 3, 4 }, { 4, 5 }, { 5, 2 } } ] },
    { cycles = RandomInfraCircle[ graph, 1, 1, All ] },
    { Length[ cycles ], Sort /@ cycles, Length /@ cycles } ],
  { 1, { { 2, 3, 4, 5 } }, { 4 } },
  TestID -> "synthetic-circle-shortest-separating-cycle-carrier"
]


VerificationTest[
  With[ { graph = Graph[ Range[ 5 ], UndirectedEdge @@@
      { { 1, 2 }, { 1, 3 }, { 1, 4 }, { 1, 5 }, { 2, 3 }, { 3, 4 }, { 4, 5 }, { 5, 2 } } ] },
    Sort @ RandomInfraArc[ graph, 1, { 2, 4 }, All ] ],
  { { 2, 3, 4 }, { 2, 5, 4 } },
  TestID -> "synthetic-open-arc-two-ordered-geodesics"
]


VerificationTest[
  With[ { graph = Graph[ Range[ 5 ], UndirectedEdge @@@
      { { 1, 2 }, { 1, 3 }, { 1, 4 }, { 1, 5 }, { 2, 3 }, { 3, 4 }, { 4, 5 }, { 5, 2 } } ] },
    Sort /@ RandomInfraArc[ graph, InfraArc[ 1, { 2, 2 }, "RadiusDelta" -> 0 ], All ] ],
  { { 2, 3, 4, 5 } },
  TestID -> "synthetic-closed-arc-is-cycle-not-open-degenerate-pair"
]


VerificationTest[
  With[ { graph = CycleGraph[ 4 ] },
    { bare = RandomInfraRegularPolygon[ graph, { 1, 2 }, 4, All ],
      tokens = RandomInfraRegularPolygon[ graph, InfraRegularPolygon[ { 1, 2 }, 4 ], All ] },
    { Length[ bare ], AllTrue[ First[ bare ], GraphQ ], Sort /@ tokens,
      tokens === RandomInfraRegularPolygon[ graph, InfraPolygon[ { 1, 2 }, 4 ], All ] } ],
  { 1, True, { { 1, 2, 3, 4 } }, True },
  TestID -> "synthetic-regular-polygon-preserves-leg-versus-token-carriers"
]


VerificationTest[
  RandomInfraPlane[ PathGraph[ { 1, 2, 3 } ], 1, 3, All ],
  { { 2 } },
  TestID -> "synthetic-plane-minimal-separating-set"
]


VerificationTest[
  RandomInfraPlane[ CompleteGraph[ 3 ], InfraPlane[ 1, 2 ], All ],
  {},
  TestID -> "synthetic-plane-is-not-exact-bisector-locus"
]


VerificationTest[
  RandomInfraBall[ PathGraph[ Range[ 5 ] ], 3, 1, All ],
  { { 2, 3, 4 } },
  TestID -> "synthetic-ball-counts-regions-not-support-points"
]


VerificationTest[
  RandomInfraShell[ PathGraph[ Range[ 5 ] ], 3, { 1, 2 }, All ],
  { { 1, 2, 4, 5 } },
  TestID -> "synthetic-shell-band-single-region"
]


VerificationTest[
  RandomInfraSphere[ PathGraph[ { 1, 2, 3 } ], InfraSphere[ 2, 1 ], All, Properties -> {} ],
  { { 1, 3 } },
  TestID -> "synthetic-sphere-token-routes-properties-to-existing-engine"
]


VerificationTest[
  RandomInfraTube[ PathGraph[ Range[ 5 ] ], { 2, 3 }, 1, All, Method -> "Balls" ],
  { { 1, 2, 3, 4 } },
  TestID -> "synthetic-tube-balls-support"
]


VerificationTest[
  RandomInfraCylinder[ PathGraph[ Range[ 5 ] ], { 2, 3 }, 0, All, Method -> "Balls" ],
  { { 2, 3 } },
  TestID -> "synthetic-cylinder-forwards-explicit-method"
]


VerificationTest[
  RandomInfraCone[ PathGraph[ Range[ 5 ] ], { 2, 3 }, 1, All, Method -> "Balls" ],
  { { 2, 3, 4 } },
  TestID -> "synthetic-cone-preserves-apex-profile"
]


VerificationTest[
  RandomInfraSolidOfRevolution[ PathGraph[ Range[ 5 ] ], { 2, 3 }, i |-> 0, All, Method -> "Balls" ],
  { { 2, 3 } },
  TestID -> "synthetic-revolution-preserves-function-profile"
]


VerificationTest[
  RandomInfraBallHull[ PathGraph[ { 1, 2, 3 } ], InfraBallHull[ { 2 } ], All ],
  { { 2 } },
  TestID -> "synthetic-ball-hull-omitted-band-token-count"
]


VerificationTest[
  With[ { graph = PathGraph[ { 1, 2, 3 } ] },
    { RandomInfraConvexHull[ graph, { 1, 3 }, 0, All ],
      RandomInfraConvexHull[ graph, InfraConvexHull[ { 1, 3 } ], All ],
      RandomInfraConvexHull[ graph, InfraConvexHull[ { 1, 3 } ], 2 ] } ],
  { { { 1, 3 } }, { { 1, 2, 3 } }, {} },
  TestID -> "synthetic-convex-hull-round-is-distinct-from-count"
]


VerificationTest[
  RandomInfraQuadric[ PathGraph[ { 1, 2, 3 } ], { 1, 3 }, { 0, 0 }, { 1, -1 }, All ],
  { { 2 } },
  TestID -> "synthetic-quadric-retains-signed-weight-band"
]


VerificationTest[
  RandomInfraWalk[ PathGraph[ { 1, 2, 3 } ], InfraWalk[ 1, 2, 1 ], All ],
  { { 1, 2, 1 } },
  TestID -> "synthetic-fixed-walk-token-does-not-grow"
]


VerificationTest[
  RandomInfraGeodesic[ PathGraph[ { 1, 2, 3 } ], InfraGeodesic[ { 1, 2 }, Infinity ], All ],
  { { 1, 2, 3 } },
  TestID -> "synthetic-geodesic-token-keeps-sequence-carrier"
]


VerificationTest[
  With[ { pool = RandomInfraEllipse[ CycleGraph[ 4 ], InfraEllipse[ { 1, 3 }, 2, Properties -> {} ], All ] },
    { Length[ pool ], AllTrue[ pool, GraphQ ], Sort /@ ( VertexList /@ pool ) } ],
  { 1, True, { { 1, 2, 3, 4 } } },
  TestID -> "synthetic-ellipse-token-preserves-cycle-graph"
]


VerificationTest[
  RandomInfraIntersection[ PathGraph[ { 1, 2, 3 } ], { InfraBall[ 1, 1 ], InfraBall[ 3, 1 ] }, All ],
  { 2 },
  TestID -> "synthetic-intersection-samples-support-points"
]


VerificationTest[
  RandomInfraUnion[ PathGraph[ { 1, 2, 3 } ], InfraUnion[ InfraBall[ 1, 0 ], InfraBall[ 3, 0 ] ], All ],
  { 1, 3 },
  TestID -> "synthetic-union-token-samples-support-points"
]


VerificationTest[
  With[ { graph = PathGraph[ { 1, 2 } ] },
    { RandomInfraShell[ graph, 1, 5, All ], RandomInfraShell[ graph, 1, 5, 1 ],
      RandomInfraShell[ graph, 1, 5, 2 ] } ],
  { { {} }, { {} }, {} },
  TestID -> "synthetic-empty-region-is-one-representative"
]


VerificationTest[
  Head @ RandomInfraCircle[ CycleGraph[ 4 ], 1, 1, All, "NextVertexFunction" -> RandomChoice ],
  RandomInfraCircle,
  TestID -> "synthetic-randomchoice-all-remains-unsupported"
]


VerificationTest[
  With[ { graph = Graph[ { {}, { 1, 2 } }, { UndirectedEdge[ {}, { 1, 2 } ] } ] },
    { RandomInfraPoint[ graph, InfraPoint[ {} ], All ],
      RandomInfraInstance[ InfraScene[ { p }, { p == InfraPoint[ {} ] } ], graph, All ] } ],
  { { {} }, { InfraSceneInstance[ <| p -> {} |> ] } },
  TestID -> "synthetic-empty-list-point-scene"
]

VerificationTest[
  With[ { graph = PathGraph[ { 1, 2 } ] },
    RandomInfraInstance[ InfraScene[ { region }, { region == InfraShell[ 1, 5 ] } ], graph, All ] ],
  { InfraSceneInstance[ <| region -> {} |> ] },
  TestID -> "synthetic-empty-region-scene"
]

VerificationTest[
  With[ { graph = PathGraph[ Range[ 5 ] ] },
    BlockRandom[
      RandomInfraPoint[ graph, All ];
      RandomInfraSegment[ graph, InfraSegment[ 1, 5 ], All ];
      RandomInfraHalfLine[ graph, InfraHalfLine[ 2, 3 ], All ];
      RandomInfraInfiniteLine[ graph, InfraInfiniteLine[ 2, 3 ], All ];
      RandomInfraBall[ graph, 3, 1, "NextVertexFunction" -> Identity ];
      RandomInfraUnion[ graph, { InfraBall[ 1, 0 ], InfraBall[ 5, 0 ] }, All ];
      InfraMeasurement[ graph, InfraHalfLine[ 2, 3 ], "VertexDensity" ];
      RandomInteger[ 1000000 ], RandomSeeding -> 71 ] ===
      BlockRandom[ RandomInteger[ 1000000 ], RandomSeeding -> 71 ] ],
  True,
  TestID -> "synthetic-t3-all-identity-readers-rng-neutral"
]

VerificationTest[
  With[ { graph = PathGraph[ Range[ 3 ] ] },
    Head /@ { RandomInfraBall[ graph, 2, 1, -1 ], RandomInfraPoint[ graph, -1 ],
      RandomInfraSegment[ graph, InfraSegment[ 1, 3 ], -1 ],
      RandomInfraCircle[ graph, 2, 1, "Typo" -> 1 ],
      RandomInfraWalk[ graph, InfraWalk[ 1, 2 ], Properties -> { "Simple" } ],
      RandomInfraIntersection[ graph, { InfraBall[ 1, 0 ] }, "NextVertexFunction" -> RandomSample ] } ],
  { RandomInfraBall, RandomInfraPoint, RandomInfraSegment, RandomInfraCircle, RandomInfraWalk, RandomInfraIntersection },
  TestID -> "synthetic-unsupported-counts-options-and-token-growth-rules"
]

VerificationTest[
  With[ { graph = PathGraph[ { InfraLine[ 1 ], InfraRay[ 2 ] } ] },
    { RandomInfraPoint[ graph, InfraPoint[ InfraLine[ 1 ] ], All ],
      InfraMeasurement[ graph, InfraHalfLine[ InfraLine[ 1 ], InfraRay[ 2 ] ], "VertexDensity" ] } ],
  { { InfraLine[ 1 ] }, <| InfraLine[ 1 ] -> 1, InfraRay[ 2 ] -> 1 |> },
  TestID -> "synthetic-legacy-heads-inside-vertex-labels-stay-literal"
]

VerificationTest[
  With[ { graph = PathGraph[ { 1, 2, 3 } ] },
    { Head @ RandomInfraUnion[ graph, { UnknownConstruction[ 1 ] }, All ],
      Head @ RandomInfraInstance[ InfraScene[ { p }, { p == UnknownConstruction[ 1 ] } ], graph, All ] } ],
  { RandomInfraUnion, RandomInfraInstance },
  TestID -> "synthetic-unsupported-set-operand-and-scene-pool"
]

VerificationTest[
  With[ { graph = PathGraph[ { 1, 2, 3 } ] },
    { RandomInfraInfiniteLine[ graph, InfraInfiniteLine[ 2 ], All ],
      RandomInfraInfiniteLine[ graph, InfraInfiniteLine[ PathGraph[ { { 1, 1 }, { 2, 2 } }, DirectedEdges -> True ] ], All ] } ],
  { { { 1, 2, 3 }, { 3, 2, 1 } }, { { 1, 2, 3 } } },
  TestID -> "synthetic-vertex-and-position-spelled-graph-line-germs"
]

VerificationTest[
  With[ { graph = PetersenGraph[] },
    { RandomInfraIntersection[ graph, { InfraCircle[ 1, 2 ], InfraCircle[ 7, 2 ] }, All ],
      RandomInfraUnion[ graph, { InfraCircle[ 1, 2 ], InfraCircle[ 7, 2 ] }, All ] ===
        Union @@ Join[ RandomInfraCircle[ graph, InfraCircle[ 1, 2 ], All ],
          RandomInfraCircle[ graph, InfraCircle[ 7, 2 ], All ] ] } ],
  { { 5, 9, 10 }, True },
  TestID -> "synthetic-set-operations-use-complete-circle-pools"
]
