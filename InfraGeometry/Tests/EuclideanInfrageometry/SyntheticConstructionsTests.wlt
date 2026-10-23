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
    BlockRandom[ RandomInfraHalfLine[ graph, 2, 3, UpTo[ 3 ], RandomSeeding -> None ], RandomSeeding -> 41 ] ===
      BlockRandom[ RandomInfraRay[ graph, 2, 3, UpTo[ 3 ], RandomSeeding -> None ], RandomSeeding -> 41 ] ],
  True,
  TestID -> "synthetic-halfline-bare-legacy-seeded-alias"
]


VerificationTest[
  With[ { graph = PathGraph[ Range[ 5 ] ] },
    BlockRandom[ RandomInfraInfiniteLine[ graph, { 2, 3 }, UpTo[ 3 ], RandomSeeding -> None ], RandomSeeding -> 41 ] ===
      BlockRandom[ RandomInfraLine[ graph, { 2, 3 }, UpTo[ 3 ], RandomSeeding -> None ], RandomSeeding -> 41 ] ],
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
  Keys @ InfraMeasurement[ PathGraph[ Range[ 5 ] ], InfraBall[ 3, 1 ], "VertexDensity" ],
  { 2, 3, 4 },
  TestID -> "synthetic-ball-support"
]


VerificationTest[
  Keys @ InfraMeasurement[ PathGraph[ Range[ 5 ] ], InfraShell[ 3, { 1, 2 } ], "VertexDensity" ],
  { 1, 2, 4, 5 },
  TestID -> "synthetic-shell-band-support"
]


VerificationTest[
  RandomInfraSphere[ PathGraph[ { 1, 2, 3 } ], InfraSphere[ 2, 1 ], All, Properties -> {} ],
  { { 1, 3 } },
  TestID -> "synthetic-sphere-token-routes-properties-to-existing-engine"
]


VerificationTest[
  Keys @ InfraMeasurement[ PathGraph[ Range[ 5 ] ], InfraTube[ { 2, 3 }, 1, Method -> "Balls" ], "VertexDensity" ],
  { 1, 2, 3, 4 },
  TestID -> "synthetic-tube-balls-support"
]


VerificationTest[
  Keys @ InfraMeasurement[ PathGraph[ Range[ 5 ] ], InfraCylinder[ { 2, 3 }, 0, Method -> "Balls" ], "VertexDensity" ],
  { 2, 3 },
  TestID -> "synthetic-cylinder-forwards-explicit-method"
]


VerificationTest[
  Keys @ InfraMeasurement[ PathGraph[ Range[ 5 ] ], InfraCone[ { 2, 3 }, 1, Method -> "Balls" ], "VertexDensity" ],
  { 2, 3, 4 },
  TestID -> "synthetic-cone-preserves-apex-profile"
]


VerificationTest[
  Keys @ InfraMeasurement[ PathGraph[ Range[ 5 ] ], InfraSolidOfRevolution[ { 2, 3 }, i |-> 0, Method -> "Balls" ], "VertexDensity" ],
  { 2, 3 },
  TestID -> "synthetic-revolution-preserves-function-profile"
]


VerificationTest[
  Keys @ InfraMeasurement[ PathGraph[ { 1, 2, 3 } ], InfraBallHull[ { 2 } ], "VertexDensity" ],
  { 2 },
  TestID -> "synthetic-ball-hull-omitted-band"
]


VerificationTest[
  With[ { graph = PathGraph[ { 1, 2, 3 } ] },
    Keys @ InfraMeasurement[ graph, #, "VertexDensity" ] & /@
      { InfraConvexHull[ { 1, 3 }, 0 ], InfraConvexHull[ { 1, 3 } ] } ],
  { { 1, 3 }, { 1, 2, 3 } },
  TestID -> "synthetic-convex-hull-round-zero-and-closure"
]


VerificationTest[
  Keys @ InfraMeasurement[ PathGraph[ { 1, 2, 3 } ], InfraQuadric[ { 1, 3 }, { 0, 0 }, { 1, -1 } ], "VertexDensity" ],
  { 2 },
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
  Keys @ InfraMeasurement[ PathGraph[ { 1, 2, 3 } ], InfraIntersection[ InfraBall[ 1, 1 ], InfraBall[ 3, 1 ] ], "VertexDensity" ],
  { 2 },
  TestID -> "synthetic-intersection-support"
]


VerificationTest[
  Keys @ InfraMeasurement[ PathGraph[ { 1, 2, 3 } ], InfraUnion[ InfraBall[ 1, 0 ], InfraBall[ 3, 0 ] ], "VertexDensity" ],
  { 1, 3 },
  TestID -> "synthetic-union-support"
]


VerificationTest[
  Keys @ InfraMeasurement[ PathGraph[ { 1, 2 } ], InfraShell[ 1, 5 ], "VertexDensity" ],
  {},
  TestID -> "synthetic-empty-region-has-empty-support"
]


VerificationTest[
  Head @ RandomInfraCircle[ CycleGraph[ 4 ], 1, 1, All, "NextVertexFunction" -> RandomChoice ],
  RandomInfraCircle,
  TestID -> "synthetic-randomchoice-all-remains-unsupported"
]


VerificationTest[
  With[ { graph = Graph[ { {}, { 1, 2 } }, { UndirectedEdge[ {}, { 1, 2 } ] } ] },
    { RandomInfraPoint[ graph, InfraPoint[ {} ], All ],
      RandomInfraSceneInstance[ InfraScene[ { p }, { p == InfraPoint[ {} ] } ], graph, All ] } ],
  { { {} }, { InfraSceneInstance[ <| p -> {} |> ] } },
  TestID -> "synthetic-empty-list-point-scene"
]

VerificationTest[
  With[ { graph = PathGraph[ { 1, 2 } ] },
    RandomInfraSceneInstance[ InfraScene[ { region }, { region == InfraShell[ 1, 5 ] } ], graph, All ] ],
  { InfraSceneInstance[ <| region -> {} |> ] },
  TestID -> "synthetic-empty-region-scene"
]

VerificationTest[
  With[ { graph = PathGraph[ Range[ 5 ] ] },
    BlockRandom[
      RandomInfraPoint[ graph, All, RandomSeeding -> None ];
      RandomInfraSegment[ graph, InfraSegment[ 1, 5 ], All, RandomSeeding -> None ];
      RandomInfraHalfLine[ graph, InfraHalfLine[ 2, 3 ], All, RandomSeeding -> None ];
      RandomInfraInfiniteLine[ graph, InfraInfiniteLine[ 2, 3 ], All, RandomSeeding -> None ];
      Keys @ InfraMeasurement[ graph, InfraBall[ 3, 1 ], "VertexDensity" ];
      Keys @ InfraMeasurement[ graph, InfraUnion[ InfraBall[ 1, 0 ], InfraBall[ 5, 0 ] ], "VertexDensity" ];
      InfraMeasurement[ graph, InfraHalfLine[ 2, 3 ], "VertexDensity" ];
      RandomInteger[ 1000000 ], RandomSeeding -> 71 ] ===
      BlockRandom[ RandomInteger[ 1000000 ], RandomSeeding -> 71 ] ],
  True,
  TestID -> "synthetic-t3-all-identity-readers-rng-neutral"
]

VerificationTest[
  With[ { graph = PathGraph[ Range[ 3 ] ] },
    Head /@ { RandomInfraPoint[ graph, -1 ],
      RandomInfraSegment[ graph, InfraSegment[ 1, 3 ], -1 ],
      RandomInfraCircle[ graph, 2, 1, "Typo" -> 1 ],
      RandomInfraWalk[ graph, InfraWalk[ 1, 2 ], Properties -> { "Simple" } ] } ],
  { RandomInfraPoint, RandomInfraSegment, RandomInfraCircle, RandomInfraWalk },
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
  Head @ RandomInfraSceneInstance[ InfraScene[ { p }, { p == UnknownConstruction[ 1 ] } ], PathGraph[ { 1, 2, 3 } ], All ],
  RandomInfraSceneInstance,
  TestID -> "synthetic-unsupported-scene-pool"
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
    { RandomInfraPoint[ graph, InfraIntersection[ InfraCircle[ 1, 2 ], InfraCircle[ 7, 2 ] ], All ],
      RandomInfraPoint[ graph, InfraUnion[ InfraCircle[ 1, 2 ], InfraCircle[ 7, 2 ] ], All ] ===
        Union @@ Join[ RandomInfraCircle[ graph, InfraCircle[ 1, 2 ], All ],
          RandomInfraCircle[ graph, InfraCircle[ 7, 2 ], All ] ] } ],
  { { 5, 9, 10 }, True },
  TestID -> "synthetic-set-operations-use-complete-circle-pools"
]

VerificationTest[
  With[ { token = InfraMidpoint[ p, q ] /. { p -> 1, q -> 2 } }, HoldComplete[ token ] ],
  HoldComplete[ InfraMidpoint[ 1, 2 ] ],
  TestID -> "synthetic-t4-inert"
]

VerificationTest[
  With[ { graph = CycleGraph[ 4 ] }, RandomInfraMidpoint[ graph, 1, 3, All ] === RandomInfraMidpoint[ graph, InfraMidpoint[ 1, 3 ], All ] ],
  True,
  TestID -> "synthetic-t4-midpoint-bare-token"
]

VerificationTest[
  With[ { graph = CycleGraph[ 4 ] }, RandomInfraRegionNearest[ graph, InfraBall[ 2, 1 ], 1, All ] === RandomInfraRegionNearest[ graph, InfraRegionNearest[ InfraBall[ 2, 1 ], 1 ], All ] ],
  True,
  TestID -> "synthetic-t4-regionnearest-bare-token"
]

VerificationTest[
  RandomInfraMidpoint[ PathGraph[ { 1, 2 } ], 1, 2, All ],
  { 1, 2 },
  TestID -> "synthetic-t4-k2-midpoint-central-pair"
]

VerificationTest[
  RandomInfraMidpoint[ CycleGraph[ 4 ], 1, 3, All ],
  { 2, 4 },
  TestID -> "synthetic-t4-c4-midpoint-ties"
]

VerificationTest[
  RandomInfraMidpoint[ PathGraph[ Range[ 4 ] ], 1, 4, All ],
  { 2, 3 },
  TestID -> "synthetic-t4-odd-distance"
]

VerificationTest[
  RandomInfraMidpoint[ Graph[ { 1, 2 }, { } ], 1, 2, All ],
  { },
  TestID -> "synthetic-t4-disconnected-midpoint"
]

VerificationTest[
  RandomInfraMidpoint[ PathGraph[ Range[ 3 ] ], 2, 2, All ],
  { 2 },
  TestID -> "synthetic-t4-same-midpoint"
]

VerificationTest[
  Keys @ InfraMeasurement[ CompleteGraph[ 3 ], InfraPerpendicularBisector[ 1, 2 ], "VertexDensity" ],
  { 3 },
  TestID -> "synthetic-t4-k3-bisector"
]

VerificationTest[
  Keys @ InfraMeasurement[ PathGraph[ { 1, 2 } ], InfraPerpendicularBisector[ 1, 2 ], "VertexDensity" ],
  { },
  TestID -> "synthetic-t4-k2-bisector-empty"
]

VerificationTest[
  Keys @ InfraMeasurement[ Graph[ { 1, 2, 3 }, { UndirectedEdge[ 1, 2 ] } ], InfraPerpendicularBisector[ 1, 3 ], "VertexDensity" ],
  { },
  TestID -> "synthetic-t4-disconnected-bisector"
]

VerificationTest[
  Keys @ InfraMeasurement[ Graph[ { 1, 2, 3 }, { UndirectedEdge[ 1, 2 ] } ], InfraPerpendicularBisector[ 1, 1 ], "VertexDensity" ],
  { 1, 2 },
  TestID -> "synthetic-t4-same-bisector-component"
]

VerificationTest[
  RandomInfraRegionNearest[ CycleGraph[ 4 ], { 1, 3 }, 2, All ],
  { 1, 3 },
  TestID -> "synthetic-t4-nearest-ties"
]

VerificationTest[
  RandomInfraRegionNearest[ CycleGraph[ 4 ], { 1, 3 }, 1, All ],
  { 1 },
  TestID -> "synthetic-t4-nearest-in-support"
]

VerificationTest[
  RandomInfraRegionNearest[ PathGraph[ Range[ 3 ] ], <| 1 -> 0, 3 -> -2 |>, 1, All ],
  { 3 },
  TestID -> "synthetic-t4-nonzero-density"
]

VerificationTest[
  RandomInfraRegionNearest[ Graph[ { 1, 2 }, { } ], { 2 }, 1, All ],
  { },
  TestID -> "synthetic-t4-nearest-unreachable"
]

VerificationTest[
  RandomInfraRegionNearest[ PathGraph[ { 1, 2 } ], { }, 1, All ],
  { },
  TestID -> "synthetic-t4-nearest-empty-list"
]

VerificationTest[
  RandomInfraRegionNearest[ PathGraph[ { 1, 2 } ], <| |>, 1, All ],
  { },
  TestID -> "synthetic-t4-nearest-empty-density"
]

VerificationTest[
  RandomInfraRegionNearest[ PathGraph[ { 1, 2 } ], InfraShell[ 1, 5 ], 1, All ],
  { },
  TestID -> "synthetic-t4-nearest-empty-construction"
]

VerificationTest[
  Head @ RandomInfraRegionNearest[ PathGraph[ { 1, 2 } ], UnknownConstruction[ 1 ], 1, All ],
  RandomInfraRegionNearest,
  TestID -> "synthetic-t4-unsupported-support"
]

VerificationTest[
  With[ { graph = Graph[ { { 0, 0 }, { 1, 0 }, { 2, 0 } }, { UndirectedEdge[ { 0, 0 }, { 1, 0 } ], UndirectedEdge[ { 1, 0 }, { 2, 0 } ] } ] }, { RandomInfraMidpoint[ graph, { 0, 0 }, { 2, 0 }, All ], RandomInfraRegionNearest[ graph, { 1, 0 }, { 0, 0 }, All ] } ],
  { { { 1, 0 } }, { { 1, 0 } } },
  TestID -> "synthetic-t4-list-labels"
]

VerificationTest[
  With[ { graph = PathGraph[ { InfraMidpoint[ 1, 2 ], InfraPlane[ 3, 4 ], InfraSegment[ 5, 6 ] } ] }, RandomInfraMidpoint[ graph, InfraMidpoint[ 1, 2 ], InfraSegment[ 5, 6 ], All ] ],
  { InfraPlane[ 3, 4 ] },
  TestID -> "synthetic-t4-infra-headed-labels"
]

VerificationTest[
  With[ { graph = Graph[ { 1, { }, 2 }, { UndirectedEdge[ 1, { } ], UndirectedEdge[ { }, 2 ] } ] }, { RandomInfraMidpoint[ graph, 1, 2, All ], RandomInfraMidpoint[ graph, 1, 2, 1 ], RandomInfraMidpoint[ graph, 1, 2 ], RandomInfraRegionNearest[ graph, { }, 1, All ] } ],
  { { { } }, { { } }, { }, { { } } },
  TestID -> "synthetic-t4-empty-list-label"
]

VerificationTest[
  With[ { graph = CycleGraph[ 4 ] }, { RandomInfraMidpoint[ graph, 1, 3, 0 ], RandomInfraMidpoint[ graph, 1, 3, 1, "NextVertexFunction" -> Identity ], RandomInfraMidpoint[ graph, 1, 3, 2, "NextVertexFunction" -> Identity ], RandomInfraMidpoint[ graph, 1, 3, 3 ], RandomInfraMidpoint[ graph, 1, 3, UpTo[ 3 ], "NextVertexFunction" -> Identity ], RandomInfraMidpoint[ graph, 1, 3, Automatic, "NextVertexFunction" -> Identity ] } ],
  { { }, { 2 }, { 2, 4 }, { }, { 2, 4 }, 2 },
  TestID -> "synthetic-t4-counts"
]

VerificationTest[
  With[ { graph = CycleGraph[ 4 ] }, BlockRandom[ RandomInfraMidpoint[ graph, 1, 3, All, RandomSeeding -> None ]; RandomInfraMidpoint[ graph, 1, 3, 1, "NextVertexFunction" -> Identity, RandomSeeding -> None ]; RandomInteger[ 1000000 ], RandomSeeding -> 71 ] === BlockRandom[ RandomInteger[ 1000000 ], RandomSeeding -> 71 ] ],
  True,
  TestID -> "synthetic-t4-midpoint-rng-neutral"
]

VerificationTest[
  With[ { graph = CycleGraph[ 4 ] }, BlockRandom[ Table[ RandomInfraMidpoint[ graph, 1, 3, RandomSeeding -> None ], { 10 } ], RandomSeeding -> 41 ] === BlockRandom[ Table[ RandomInfraMidpoint[ graph, 1, 3, RandomSeeding -> None ], { 10 } ], RandomSeeding -> 41 ] ],
  True,
  TestID -> "synthetic-t4-midpoint-seed"
]

VerificationTest[
  With[ { graph = CycleGraph[ 4 ] }, Head /@ { RandomInfraMidpoint[ graph, 1, 3, -1 ], RandomInfraMidpoint[ graph, 1, 3, All, "NextVertexFunction" -> RandomChoice ], RandomInfraMidpoint[ graph, 1, 3, "Typo" -> 1 ] } ],
  { RandomInfraMidpoint, RandomInfraMidpoint, RandomInfraMidpoint },
  TestID -> "synthetic-t4-midpoint-unsupported"
]

VerificationTest[
  With[ { graph = CycleGraph[ 4 ] }, BlockRandom[ RandomInfraRegionNearest[ graph, { 1, 3 }, 2, All, RandomSeeding -> None ]; RandomInfraRegionNearest[ graph, { 1, 3 }, 2, 1, "NextVertexFunction" -> Identity, RandomSeeding -> None ]; RandomInteger[ 1000000 ], RandomSeeding -> 71 ] === BlockRandom[ RandomInteger[ 1000000 ], RandomSeeding -> 71 ] ],
  True,
  TestID -> "synthetic-t4-regionnearest-rng-neutral"
]

VerificationTest[
  With[ { graph = CycleGraph[ 4 ] }, BlockRandom[ Table[ RandomInfraRegionNearest[ graph, { 1, 3 }, 2, RandomSeeding -> None ], { 10 } ], RandomSeeding -> 41 ] === BlockRandom[ Table[ RandomInfraRegionNearest[ graph, { 1, 3 }, 2, RandomSeeding -> None ], { 10 } ], RandomSeeding -> 41 ] ],
  True,
  TestID -> "synthetic-t4-regionnearest-seed"
]

VerificationTest[
  With[ { graph = CycleGraph[ 4 ] }, Head /@ { RandomInfraRegionNearest[ graph, { 1, 3 }, 2, -1 ], RandomInfraRegionNearest[ graph, { 1, 3 }, 2, All, "NextVertexFunction" -> RandomChoice ], RandomInfraRegionNearest[ graph, { 1, 3 }, 2, "Typo" -> 1 ] } ],
  { RandomInfraRegionNearest, RandomInfraRegionNearest, RandomInfraRegionNearest },
  TestID -> "synthetic-t4-regionnearest-unsupported"
]

VerificationTest[
  With[ { graph = PathGraph[ Range[ 3 ], DirectedEdges -> True ] }, Head /@ { RandomInfraMidpoint[ graph, 1, 2, All ], InfraMeasurement[ graph, InfraPerpendicularBisector[ 1, 2 ], "VertexDensity" ], RandomInfraRegionNearest[ graph, { 1 }, 2, All ] } ],
  { RandomInfraMidpoint, InfraMeasurement, RandomInfraRegionNearest },
  TestID -> "synthetic-t4-unsupported-directed"
]

VerificationTest[
  With[ { graph = Graph[ Range[ 3 ], { UndirectedEdge[ 1, 2 ], UndirectedEdge[ 2, 3 ] }, EdgeWeight -> { 1, 1 } ] }, Head /@ { RandomInfraMidpoint[ graph, 1, 2, All ], InfraMeasurement[ graph, InfraPerpendicularBisector[ 1, 2 ], "VertexDensity" ], RandomInfraRegionNearest[ graph, { 1 }, 2, All ] } ],
  { RandomInfraMidpoint, InfraMeasurement, RandomInfraRegionNearest },
  TestID -> "synthetic-t4-unsupported-weighted"
]

VerificationTest[
  With[ { graph = Graph[ Range[ 3 ], { UndirectedEdge[ 1, 1 ], UndirectedEdge[ 1, 2 ] } ] }, Head /@ { RandomInfraMidpoint[ graph, 1, 2, All ], InfraMeasurement[ graph, InfraPerpendicularBisector[ 1, 2 ], "VertexDensity" ], RandomInfraRegionNearest[ graph, { 1 }, 2, All ] } ],
  { RandomInfraMidpoint, InfraMeasurement, RandomInfraRegionNearest },
  TestID -> "synthetic-t4-unsupported-loop"
]

VerificationTest[
  Head /@ { RandomInfraMidpoint[ Graph[ { }, { } ], 1, 1, All ], RandomInfraRegionNearest[ Graph[ { }, { } ], { }, 1, All ] },
  { RandomInfraMidpoint, RandomInfraRegionNearest },
  TestID -> "synthetic-t4-empty-graph-anchors-unsupported"
]

VerificationTest[
  With[ { graph = CycleGraph[ 4 ] }, { RandomInfraRegionNearest[ graph, { 2, 4 }, 1, 0, "NextVertexFunction" -> Identity ], RandomInfraRegionNearest[ graph, { 2, 4 }, 1, 1, "NextVertexFunction" -> Identity ], RandomInfraRegionNearest[ graph, { 2, 4 }, 1, 2, "NextVertexFunction" -> Identity ], RandomInfraRegionNearest[ graph, { 2, 4 }, 1, 3, "NextVertexFunction" -> Identity ], RandomInfraRegionNearest[ graph, { 2, 4 }, 1, UpTo[ 3 ], "NextVertexFunction" -> Identity ], RandomInfraRegionNearest[ graph, { 2, 4 }, 1, Automatic, "NextVertexFunction" -> Identity ] } ],
  { { }, { 2 }, { 2, 4 }, { }, { 2, 4 }, 2 },
  TestID -> "synthetic-t4-regionnearest-counts"
]

VerificationTest[
  RandomInfraRegionNearest[ PathGraph[ { 1, 2, 3 } ], PathGraph[ { 2, 3 } ], 1, All ],
  { 2 },
  TestID -> "synthetic-t4-raw-graph-support"
]

VerificationTest[
  RandomInfraRegionNearest[ PathGraph[ { 1, 2, 3 } ], Graph[ { }, { } ], 1, All ],
  { },
  TestID -> "synthetic-t4-raw-empty-graph"
]

VerificationTest[
  Head /@ { RandomInfraRegionNearest[ PathGraph[ { 1, 2 } ], <| 3 -> 1 |>, 1, All ], RandomInfraRegionNearest[ PathGraph[ { 1, 2 } ], <| 1 -> symbolic |>, 1, All ], RandomInfraRegionNearest[ PathGraph[ { 1, 2 } ], { 99 }, 1, All ] },
  { RandomInfraRegionNearest, RandomInfraRegionNearest, RandomInfraRegionNearest },
  TestID -> "synthetic-t4-unsupported-density-and-region"
]

VerificationTest[
  With[ { graph = CycleGraph[ 4 ] }, Head /@ { RandomInfraMidpoint[ graph, InfraMidpoint[ 1, 3 ], "Typo" -> 1 ], InfraMeasurement[ graph, InfraPerpendicularBisector[ 1 ], "VertexDensity" ], RandomInfraRegionNearest[ graph, InfraRegionNearest[ UnknownConstruction[ 1 ], 2 ], All ] } ],
  { RandomInfraMidpoint, InfraMeasurement, RandomInfraRegionNearest },
  TestID -> "synthetic-t4-unsupported-token-forms"
]

VerificationTest[
  With[ { graph = PathGraph[ { 1, RandomInfraMidpoint[ "label" ], 2 } ] },
    RandomInfraMidpoint[ graph, InfraMidpoint[ 1, 2 ], Automatic, "NextVertexFunction" -> Identity ] ],
  RandomInfraMidpoint[ "label" ],
  TestID -> "synthetic-t4-sampler-headed-label-is-literal"
]

VerificationTest[
  With[ { graph = CycleGraph[ 4 ] },
    BlockRandom[ { RandomInfraMidpoint[ graph, 1, 3, RandomSeeding -> None ], RandomInfraMidpoint[ graph, 1, 3, 2, RandomSeeding -> None ], RandomInteger[ 1000000 ] }, RandomSeeding -> 41 ] ===
      BlockRandom[ { RandomChoice[ { 2, 4 } ], RandomSample[ { 2, 4 }, 2 ], RandomInteger[ 1000000 ] }, RandomSeeding -> 41 ] ],
  True,
  TestID -> "synthetic-t4-midpoint-ambient-uniform-law"
]

VerificationTest[
  With[ { graph = CycleGraph[ 4 ] },
    BlockRandom[ { RandomInfraRegionNearest[ graph, { 2, 4 }, 1, RandomSeeding -> None ], RandomInfraRegionNearest[ graph, { 2, 4 }, 1, 2, RandomSeeding -> None ], RandomInteger[ 1000000 ] }, RandomSeeding -> 41 ] ===
      BlockRandom[ { RandomChoice[ { 2, 4 } ], RandomSample[ { 2, 4 }, 2 ], RandomInteger[ 1000000 ] }, RandomSeeding -> 41 ] ],
  True,
  TestID -> "synthetic-t4-regionnearest-ambient-uniform-law"
]


VerificationTest[
  With[ { graph = GridGraph[ { 3, 3 } ] },
    InfraMeasurement[ graph, InfraMidpoint[ 1, 9 ], "VertexDensity" ] ],
  <| 3 -> 1, 5 -> 4, 7 -> 1 |>,
  TestID -> "synthetic-midpoint-retains-central-shortest-path-occupation"
]

VerificationTest[
  InfraMeasurement[ PathGraph[ Range[ 4 ] ], InfraMidpoint[ 1, 4 ], "VertexDensity" ],
  <| 2 -> 1, 3 -> 1 |>,
  TestID -> "synthetic-midpoint-odd-distance-has-two-central-layers"
]

VerificationTest[
  With[ { graph = GridGraph[ { 3, 3 } ] },
    { dag = InfraMeasurement[ graph, InfraSegment[ 1, 9 ], "Graph" ] },
    Sort @ RandomInfraMidpoint[ graph, 1, 9, All ] ===
      Sort @ MinimalBy[ VertexList[ dag ], vertex |->
        Max[ GraphDistance[ dag, 1, vertex ], GraphDistance[ dag, vertex, 9 ] ] ] ],
  True,
  TestID -> "synthetic-midpoint-is-oriented-source-sink-center"
]

VerificationTest[
  With[ { graph = GridGraph[ { 3, 3 } ] },
    InfraMeasurement[ graph, InfraMidpoint[ 1, 9 ], "VertexDensity" ] ===
      InfraMeasurement[ graph, InfraMidpoint[ 9, 1 ], "VertexDensity" ] ],
  True,
  TestID -> "synthetic-midpoint-reversing-segment-preserves-center-density"
]

VerificationTest[
  RandomInfraMidpoint[ PathGraph[ { 4, 3, 2, 1 } ], 1, 4, All ],
  { 3, 2 },
  TestID -> "synthetic-midpoint-center-pool-retains-graph-vertex-order"
]


VerificationTest[
  With[ { graph = PathGraph[ { 1, 2, InfraMidpoint[ 1, 2 ] } ] },
    { RandomInfraMidpoint[ graph, 1, 2, All ],
      InfraMeasurement[ graph, InfraMidpoint[ 1, 2 ], "VertexDensity" ] } ],
  { { 1, 2 }, <| InfraMidpoint[ 1, 2 ] -> 1 |> },
  TestID -> "synthetic-midpoint-sampling-keeps-token-headed-vertex-label-literal"
]


VerificationTest[
  RandomInfraPoint[ PathGraph[ Range[ 3 ] ], InfraPoint[ <| 1 -> 0, 3 -> -2 |> ], All ],
  { 3 },
  TestID -> "synthetic-explicit-point-excludes-zero-density"
]

VerificationTest[
  RandomInfraPoint[ PathGraph[ Range[ 3 ] ],
    InfraPoint[ InfraIntersection[ <| 1 -> 0, 2 -> 1 |>, { 1, 2 } ] ], All ],
  { 2 },
  TestID -> "synthetic-composite-point-excludes-zero-density"
]

(* a list of properties gives an Association for the three synthetic heads too; on the 4-cycle all three are { 2, 4 } *)
VerificationTest[
  InfraMeasurement[ CycleGraph[ 4 ], #, { "VertexDensity", "CountingMeasure" } ] & /@
    { InfraMidpoint[ 1, 3 ], InfraPerpendicularBisector[ 1, 3 ], InfraRegionNearest[ InfraBall[ 3, 1 ], 1 ] },
  ConstantArray[ <| "VertexDensity" -> <| 2 -> 1, 4 -> 1 |>, "CountingMeasure" -> 2 |>, 3 ],
  TestID -> "synthetic-heads-take-a-property-list"
]
