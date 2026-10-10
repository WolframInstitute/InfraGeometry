VerificationTest[
  With[ { assertion = InfraGeometricAssertion[ { p, q }, "Distinct" ] }, HoldComplete[ assertion ] ],
  HoldComplete[ InfraGeometricAssertion[ { p, q }, "Distinct" ] ],
  TestID -> "synthetic-t6-assertion-inert"
]

VerificationTest[
  InfraGeometricTest[ PathGraph[ { 1, 2 } ], InfraGeometricAssertion[ { }, "Distinct" ] ],
  True,
  TestID -> "synthetic-t6-distinct-empty"
]

VerificationTest[
  InfraGeometricTest[ PathGraph[ { 1, 2 } ], InfraGeometricAssertion[ { 1 }, "Distinct" ] ],
  True,
  TestID -> "synthetic-t6-distinct-singleton"
]

VerificationTest[
  InfraGeometricTest[ PathGraph[ { 1, 2 } ], InfraGeometricAssertion[ { 1, 2 }, "Distinct" ] ],
  True,
  TestID -> "synthetic-t6-distinct-distinct"
]

VerificationTest[
  InfraGeometricTest[ PathGraph[ { 1, 2 } ], InfraGeometricAssertion[ { 1, 1 }, "Distinct" ] ],
  False,
  TestID -> "synthetic-t6-distinct-repeated"
]

VerificationTest[
  Head @ InfraGeometricTest[ PathGraph[ { 1, 2 } ], InfraGeometricAssertion[ { 1, p }, "Distinct" ] ],
  InfraGeometricTest,
  TestID -> "synthetic-t6-unbound-assertion"
]

VerificationTest[
  InfraGeometricTest[ PathGraph[ { 1, 2, 3 } ], InfraGeometricAssertion[ { 1, InfraBall[ 1, 1 ] }, "Member" ] ],
  True,
  TestID -> "synthetic-t6-member-1"
]

VerificationTest[
  InfraGeometricTest[ PathGraph[ { 1, 2, 3 } ], InfraGeometricAssertion[ { 3, InfraBall[ 1, 1 ] }, "Member" ] ],
  False,
  TestID -> "synthetic-t6-member-3"
]

VerificationTest[
  InfraGeometricTest[ CycleGraph[ 4 ], InfraGeometricAssertion[ { 2, InfraMidpoint[ 1, 3 ] }, "Member" ] ],
  True,
  TestID -> "synthetic-t6-member-midpoint"
]

VerificationTest[
  InfraGeometricTest[ PathGraph[ { 1, 2 } ], InfraGeometricAssertion[ { 1, InfraMidpoint[ 1, 2 ] }, "Member" ] ],
  False,
  TestID -> "synthetic-t6-member-empty"
]

VerificationTest[
  InfraGeometricTest[ PathGraph[ { 1, 2 } ], InfraGeometricAssertion[ { 1, <| 1 -> 0, 2 -> 1 |> }, "Member" ] ],
  False,
  TestID -> "synthetic-t6-member-zero-density"
]

VerificationTest[
  Head @ InfraGeometricTest[ PathGraph[ { 1, 2 } ], InfraGeometricAssertion[ { 1, unknown[ 1 ] }, "Member" ] ],
  InfraGeometricTest,
  TestID -> "synthetic-t6-member-unsupported"
]

VerificationTest[
  InfraGeometricTest[ CycleGraph[ 4 ], InfraGeometricAssertion[ { { 1, 2 }, { 3, 4 } }, "EqualDistance" ] ],
  True,
  TestID -> "synthetic-t6-equal"
]

VerificationTest[
  InfraGeometricTest[ CycleGraph[ 4 ], InfraGeometricAssertion[ { { 1, 2 }, { 1, 3 } }, "EqualDistance" ] ],
  False,
  TestID -> "synthetic-t6-unequal"
]

VerificationTest[
  InfraGeometricTest[ Graph[ { 1, 2, 3, 4 }, { } ], InfraGeometricAssertion[ { { 1, 2 }, { 3, 4 } }, "EqualDistance" ] ],
  False,
  TestID -> "synthetic-t6-disconnected"
]

VerificationTest[
  Head @ InfraGeometricTest[ CycleGraph[ 4 ], InfraGeometricAssertion[ { 1 }, "Unknown" ] ],
  InfraGeometricTest,
  TestID -> "synthetic-t6-unknown-property"
]

VerificationTest[
  Head @ InfraGeometricTest[ Graph[ { 1, 2 }, { DirectedEdge[ 1, 2 ] } ], InfraGeometricAssertion[ { 1, 2 }, "Distinct" ] ],
  InfraGeometricTest,
  TestID -> "synthetic-t6-unsupported-domain"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraMidpoint[ 1, 3 ] } ] }, ( instance |-> instance[[ 1 ]][ p ] ) /@ RandomInfraInstance[ scene, CycleGraph[ 4 ], All ] ],
  { 2, 4 },
  TestID -> "synthetic-t6-scene-midpoint"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraPerpendicularBisector[ 1, 2 ] } ] }, ( instance |-> instance[[ 1 ]][ p ] ) /@ RandomInfraInstance[ scene, CycleGraph[ 4 ], All ] ],
  { },
  TestID -> "synthetic-t6-scene-bisector-empty"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraRegionNearest[ { 1, 3 }, 2 ] } ] }, ( instance |-> instance[[ 1 ]][ p ] ) /@ RandomInfraInstance[ scene, CycleGraph[ 4 ], All ] ],
  { 1, 3 },
  TestID -> "synthetic-t6-scene-nearest"
]

VerificationTest[
  RandomInfraInstance[ InfraScene[ { p }, { p == InfraMidpoint[ 1, 2 ] } ], PathGraph[ { 1, 2 } ], All ],
  { },
  TestID -> "synthetic-t6-scene-empty-point-pool"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraShell[ 1, 5 ] } ] }, ( instance |-> instance[[ 1 ]][ p ] ) /@ RandomInfraInstance[ scene, PathGraph[ { 1, 2 } ], All ] ],
  { { } },
  TestID -> "synthetic-t6-scene-empty-region-singleton"
]

VerificationTest[
  Length @ RandomInfraInstance[ InfraScene[ { p, q }, { p == InfraPoint[], q == InfraPoint[], InfraGeometricAssertion[ { p, q }, "Distinct" ] } ], PathGraph[ { 1, 2 } ], All ],
  2,
  TestID -> "synthetic-t6-scene-distinct"
]

VerificationTest[
  Length @ RandomInfraInstance[ InfraScene[ { p, q }, { p == InfraPoint[], q == InfraPoint[], InfraDistance[ p, q ] == 1 } ], PathGraph[ { 1, 2 } ], All ],
  2,
  TestID -> "synthetic-t6-scene-scalar-equality"
]

VerificationTest[
  Length @ RandomInfraInstance[ InfraScene[ { p, q }, { p == InfraPoint[], q == InfraPoint[], InfraMeasurement[ InfraMidpoint[ p, q ], "Cardinality" ] == 0 } ], PathGraph[ { 1, 2 } ], All ],
  2,
  TestID -> "synthetic-t6-scene-measurement-equality"
]

VerificationTest[
  Length @ RandomInfraInstance[ InfraScene[ { p, q }, { p == InfraPoint[], q == InfraPoint[], InfraGeometricAssertion[ { p, InfraBall[ q, 0 ] }, "Member" ] } ], PathGraph[ { 1, 2 } ], All ],
  2,
  TestID -> "synthetic-t6-scene-member"
]

VerificationTest[
  Head @ RandomInfraInstance[ InfraScene[ { p }, { p == InfraPoint[ 1 ], InfraGeometricAssertion[ { p }, "Unknown" ] } ], PathGraph[ { 1, 2 } ], All ],
  RandomInfraInstance,
  TestID -> "synthetic-t6-scene-unknown-is-not-empty"
]

VerificationTest[
  Head @ RandomInfraInstance[ InfraScene[ { p }, { p == InfraPoint[ 1 ], InfraMeasurement[ InfraMidpoint[ 1, 1 ], "Area" ] == 0 } ], PathGraph[ { 1, 2 } ], All ],
  RandomInfraInstance,
  TestID -> "synthetic-t6-scene-unresolved-query-is-not-false"
]

VerificationTest[
  Head @ RandomInfraInstance[ InfraScene[ { p }, { p == unknown[ 1 ] } ], PathGraph[ { 1, 2 } ], All ],
  RandomInfraInstance,
  TestID -> "synthetic-t6-unsupported-binding"
]

VerificationTest[
  With[ { scene = InfraScene[ { p, q }, { InfraStep[ { p == InfraPoint[] } ], InfraStep[ { q == InfraPoint[] } ], InfraGeometricAssertion[ { p, q }, "Distinct" ] } ] }, { Length @ RandomInfraInstance[ scene, PathGraph[ { 1, 2 } ], All, "Steps" -> 1 ], Length @ RandomInfraInstance[ scene, PathGraph[ { 1, 2 } ], All ], Length @ RandomInfraInstance[ scene, PathGraph[ { 1, 2 } ], 1, "Steps" -> 1 ] } ],
  { 2, 2, 1 },
  TestID -> "synthetic-t6-partial-and-count-independent"
]

VerificationTest[
  With[ { scene = InfraScene[ { p, q }, { InfraStep[ { p == InfraPoint[] } ], InfraStep[ { q == InfraPoint[] } ], InfraGeometricAssertion[ { q }, "Unknown" ] } ] }, { Length @ RandomInfraInstance[ scene, PathGraph[ { 1, 2 } ], All, "Steps" -> 1 ], Head @ RandomInfraInstance[ scene, PathGraph[ { 1, 2 } ], All ] } ],
  { 2, RandomInfraInstance },
  TestID -> "synthetic-t6-pending-unknown-at-frontier"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraPoint[] , InfraGeometricAssertion[ { p, p }, "Distinct" ], InfraGeometricAssertion[ { p }, "Unknown" ] } ] }, RandomInfraInstance[ scene, PathGraph[ { 1, 2 } ], All ] ],
  { },
  TestID -> "synthetic-t6-false-dominates-unsupported"
]

VerificationTest[
  With[ { graph = Graph[ { { }, { 1, 2 }, { 3, 4 } }, { UndirectedEdge[ { }, { 1, 2 } ], UndirectedEdge[ { 1, 2 }, { 3, 4 } ] } ], scene = InfraScene[ { p }, { p == InfraMidpoint[ { }, { } ] } ] }, ( instance |-> instance[[ 1 ]][ p ] ) /@ RandomInfraInstance[ scene, graph, All ] ],
  { { } },
  TestID -> "synthetic-t6-empty-list-vertex"
]

VerificationTest[
  With[ { graph = Graph[ { { p, InfraRay[ 1, 2 ] }, { 3, 4 } }, { UndirectedEdge[ { p, InfraRay[ 1, 2 ] }, { 3, 4 } ] } ], scene = InfraScene[ { p, q }, { q == InfraPoint[ { p, InfraRay[ 1, 2 ] } ] } ] }, ( instance |-> instance[[ 1 ]][ q ] ) /@ RandomInfraInstance[ scene, graph, All, <| p -> 9 |> ] ],
  { { p, InfraRay[ 1, 2 ] } },
  TestID -> "synthetic-t6-label-interior-not-rewritten"
]

VerificationTest[
  With[ { graph = Graph[ { { p, InfraRay[ 1, 2 ] }, { 3, 4 } }, { UndirectedEdge[ { p, InfraRay[ 1, 2 ] }, { 3, 4 } ] } ], scene = InfraScene[ { p, q }, { q == InfraPoint[ { 3, 4 } ], InfraGeometricAssertion[ { q, { p, InfraRay[ 1, 2 ] } }, "Distinct" ] } ] }, Length @ RandomInfraInstance[ scene, graph, All ] ],
  1,
  TestID -> "synthetic-t6-assertion-label-interior-not-dependency"
]

VerificationTest[
  With[ { graph = Graph[ { { }, { 1, 2 } }, { UndirectedEdge[ { }, { 1, 2 } ] } ] }, { InfraGeometricTest[ graph, InfraGeometricAssertion[ { { }, { 1, 2 } }, "Distinct" ] ], InfraGeometricTest[ graph, InfraGeometricAssertion[ { { }, { { } } }, "Member" ] ], InfraGeometricTest[ graph, InfraGeometricAssertion[ { { { }, { 1, 2 } }, { { 1, 2 }, { } } }, "EqualDistance" ] ] } ],
  { True, True, True },
  TestID -> "synthetic-t6-list-label-assertions"
]

VerificationTest[
  With[ { scene = InfraScene[ { p, q }, { { p, q } == InfraSegment[ { 1, 2 }, { 3, 4 } ] } ] }, { ( instance |-> InfraSceneInstance[ instance, { p, q } ] ) /@ RandomInfraInstance[ scene, CompleteGraph[ 4 ], All, <| p -> 1 |> ], InfraSceneInstance[ RandomInfraInstance[ scene, CompleteGraph[ 4 ], <| p -> 4, q -> 4 |> ], { p, q } ] } ],
  { { { 1, 3 }, { 1, 4 } }, { 4, 4 } },
  TestID -> "synthetic-t6-fixed-partial-tuple"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraPoint[], InfraDistance[ p, 1 ] == 0 } ] }, { scene[ "Constructions" ], Length @ RandomInfraInstance[ scene, PathGraph[ { 1, 2 } ], All ] } ],
  { <| p -> InfraPoint[] |>, 1 },
  TestID -> "synthetic-t6-equality-not-binding"
]

VerificationTest[
  RandomInfraIntersection[ CycleGraph[ 4 ], InfraIntersection[ InfraMidpoint[ 1, 3 ], InfraBall[ 2, 0 ] ], All ],
  { 2 },
  TestID -> "synthetic-t6-exact-family-set-operation"
]

VerificationTest[
  BlockRandom[ InfraGeometricTest[ CycleGraph[ 4 ], InfraGeometricAssertion[ { 2, InfraMidpoint[ 1, 3 ] }, "Member" ] ]; RandomInfraInstance[ InfraScene[ { p }, { p == InfraMidpoint[ 1, 3 ], InfraDistance[ p, 1 ] == 1 } ], CycleGraph[ 4 ], All ]; RandomInteger[ 1000000 ], RandomSeeding -> 71 ] === BlockRandom[ RandomInteger[ 1000000 ], RandomSeeding -> 71 ],
  True,
  TestID -> "synthetic-t6-readers-no-rng"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ RandomInfraInstance[ InfraScene[ { sceneTarget }, { sceneTarget == InfraPoint[] } ], PathGraph[ { 1, 2, 3 } ], All ],
  { 1, 2, 3 },
  TestID -> "synthetic-t6-dispatch-Point"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ RandomInfraInstance[ InfraScene[ { sceneTarget }, { sceneTarget == InfraSegment[ 1, 3 ] } ], PathGraph[ { 1, 2, 3 } ], All ],
  { { 1, 2, 3 } },
  TestID -> "synthetic-t6-dispatch-Segment"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ RandomInfraInstance[ InfraScene[ { sceneTarget }, { sceneTarget == InfraHalfLine[ 1, 2 ] } ], PathGraph[ { 1, 2, 3 } ], All ],
  { { 1, 2, 3 } },
  TestID -> "synthetic-t6-dispatch-HalfLine"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ RandomInfraInstance[ InfraScene[ { sceneTarget }, { sceneTarget == InfraInfiniteLine[ 1, 2 ] } ], PathGraph[ { 1, 2, 3 } ], All ],
  { { 1, 2, 3 } },
  TestID -> "synthetic-t6-dispatch-InfiniteLine"
]

VerificationTest[
  Sort /@ ( ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ RandomInfraInstance[ InfraScene[ { sceneTarget }, { sceneTarget == InfraCircle[ 1, 1 ] } ], Graph[ Range[ 5 ], UndirectedEdge @@@ { { 1, 2 }, { 1, 3 }, { 1, 4 }, { 1, 5 }, { 2, 3 }, { 3, 4 }, { 4, 5 }, { 5, 2 } } ], All ] ),
  { { 2, 3, 4, 5 } },
  TestID -> "synthetic-t6-dispatch-Circle"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ RandomInfraInstance[ InfraScene[ { sceneTarget }, { sceneTarget == InfraArc[ 1, { 2, 4 } ] } ], Graph[ Range[ 5 ], UndirectedEdge @@@ { { 1, 2 }, { 1, 3 }, { 1, 4 }, { 1, 5 }, { 2, 3 }, { 3, 4 }, { 4, 5 }, { 5, 2 } } ], All ],
  { { 2, 3, 4 }, { 2, 5, 4 } },
  TestID -> "synthetic-t6-dispatch-Arc"
]

VerificationTest[
  Sort /@ ( ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ RandomInfraInstance[ InfraScene[ { sceneTarget }, { sceneTarget == InfraRegularPolygon[ { 1, 2 }, 4 ] } ], CycleGraph[ 4 ], All ] ),
  { { 1, 2, 3, 4 } },
  TestID -> "synthetic-t6-dispatch-RegularPolygon"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ RandomInfraInstance[ InfraScene[ { sceneTarget }, { sceneTarget == InfraPlane[ 1, 3 ] } ], PathGraph[ { 1, 2, 3 } ], All ],
  { { 2 } },
  TestID -> "synthetic-t6-dispatch-Plane"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ RandomInfraInstance[ InfraScene[ { sceneTarget }, { sceneTarget == InfraBall[ 2, 1 ] } ], PathGraph[ { 1, 2, 3 } ], All ],
  { { 1, 2, 3 } },
  TestID -> "synthetic-t6-dispatch-Ball"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ RandomInfraInstance[ InfraScene[ { sceneTarget }, { sceneTarget == InfraShell[ 2, 1 ] } ], PathGraph[ { 1, 2, 3 } ], All ],
  { { 1, 3 } },
  TestID -> "synthetic-t6-dispatch-Shell"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ RandomInfraInstance[ InfraScene[ { sceneTarget }, { sceneTarget == InfraSphere[ 1, 1 ] } ], PathGraph[ { 1, 2, 3 } ], All ],
  { { 2 } },
  TestID -> "synthetic-t6-dispatch-Sphere"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ RandomInfraInstance[ InfraScene[ { sceneTarget }, { sceneTarget == InfraTube[ { 1, 2 }, 0, Method -> "Balls" ] } ], PathGraph[ { 1, 2, 3 } ], All ],
  { { 1, 2 } },
  TestID -> "synthetic-t6-dispatch-Tube"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ RandomInfraInstance[ InfraScene[ { sceneTarget }, { sceneTarget == InfraCylinder[ { 1, 2 }, 0, Method -> "Balls" ] } ], PathGraph[ { 1, 2, 3 } ], All ],
  { { 1, 2 } },
  TestID -> "synthetic-t6-dispatch-Cylinder"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ RandomInfraInstance[ InfraScene[ { sceneTarget }, { sceneTarget == InfraCone[ { 1, 2 }, 0, Method -> "Balls" ] } ], PathGraph[ { 1, 2, 3 } ], All ],
  { { 1, 2 } },
  TestID -> "synthetic-t6-dispatch-Cone"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ RandomInfraInstance[ InfraScene[ { sceneTarget }, { sceneTarget == InfraSolidOfRevolution[ { 1, 2 }, i |-> 0, Method -> "Balls" ] } ], PathGraph[ { 1, 2, 3 } ], All ],
  { { 1, 2 } },
  TestID -> "synthetic-t6-dispatch-SolidOfRevolution"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ RandomInfraInstance[ InfraScene[ { sceneTarget }, { sceneTarget == InfraBallHull[ { 2 } ] } ], PathGraph[ { 1, 2, 3 } ], All ],
  { { 2 } },
  TestID -> "synthetic-t6-dispatch-BallHull"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ RandomInfraInstance[ InfraScene[ { sceneTarget }, { sceneTarget == InfraConvexHull[ { 1, 3 } ] } ], PathGraph[ { 1, 2, 3 } ], All ],
  { { 1, 2, 3 } },
  TestID -> "synthetic-t6-dispatch-ConvexHull"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ RandomInfraInstance[ InfraScene[ { sceneTarget }, { sceneTarget == InfraQuadric[ { 1, 3 }, 2 ] } ], PathGraph[ { 1, 2, 3 } ], All ],
  { { 1, 2, 3 } },
  TestID -> "synthetic-t6-dispatch-Quadric"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ RandomInfraInstance[ InfraScene[ { sceneTarget }, { sceneTarget == InfraWalk[ 1, 2, 1 ] } ], PathGraph[ { 1, 2, 3 } ], All ],
  { { 1, 2, 1 } },
  TestID -> "synthetic-t6-dispatch-Walk"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ RandomInfraInstance[ InfraScene[ { sceneTarget }, { sceneTarget == InfraGeodesic[ { 1, 2 }, Infinity ] } ], PathGraph[ { 1, 2, 3 } ], All ],
  { { 1, 2, 3 } },
  TestID -> "synthetic-t6-dispatch-Geodesic"
]

VerificationTest[
  Sort /@ ( VertexList /@ ( ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ RandomInfraInstance[ InfraScene[ { sceneTarget }, { sceneTarget == InfraEllipse[ { 1, 3 }, 2, Properties -> {} ] } ], CycleGraph[ 4 ], All ] ) ),
  { { 1, 2, 3, 4 } },
  TestID -> "synthetic-t6-dispatch-Ellipse"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ RandomInfraInstance[ InfraScene[ { sceneTarget }, { sceneTarget == InfraIntersection[ InfraBall[ 1, 1 ], InfraBall[ 3, 1 ] ] } ], PathGraph[ { 1, 2, 3 } ], All ],
  { 2 },
  TestID -> "synthetic-t6-dispatch-Intersection"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ RandomInfraInstance[ InfraScene[ { sceneTarget }, { sceneTarget == InfraUnion[ InfraBall[ 1, 0 ], InfraBall[ 3, 0 ] ] } ], PathGraph[ { 1, 2, 3 } ], All ],
  { 1, 3 },
  TestID -> "synthetic-t6-dispatch-Union"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ RandomInfraInstance[ InfraScene[ { sceneTarget }, { sceneTarget == InfraMidpoint[ 1, 3 ] } ], CycleGraph[ 4 ], All ],
  { 2, 4 },
  TestID -> "synthetic-t6-dispatch-Midpoint"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ RandomInfraInstance[ InfraScene[ { sceneTarget }, { sceneTarget == InfraPerpendicularBisector[ 1, 2 ] } ], CompleteGraph[ 3 ], All ],
  { 3 },
  TestID -> "synthetic-t6-dispatch-PerpendicularBisector"
]

VerificationTest[
  ( instance |-> instance[[ 1 ]][ sceneTarget ] ) /@ RandomInfraInstance[ InfraScene[ { sceneTarget }, { sceneTarget == InfraRegionNearest[ { 1, 3 }, 2 ] } ], CycleGraph[ 4 ], All ],
  { 1, 3 },
  TestID -> "synthetic-t6-dispatch-RegionNearest"
]

VerificationTest[
  With[ { graph = Graph[ { { p }, { 1, 2 } }, { UndirectedEdge[ { p }, { 1, 2 } ] } ],
      scene = InfraScene[ { p }, { p == InfraPoint[ { p } ] } ] },
    ( instance |-> instance[[ 1 ]][ p ] ) /@ RandomInfraInstance[ scene, graph, All ] ],
  { { p } },
  TestID -> "synthetic-t6-self-containing-literal-label"
]

VerificationTest[
  With[ { label = { p, InfraDistance[ 1, 2 ], InfraMeasurement[ InfraMidpoint[ 1, 1 ], "Cardinality" ] } },
    { graph = Graph[ { label, { 3, 4 } }, { UndirectedEdge[ label, { 3, 4 } ] } ],
      scene = InfraScene[ { p, q }, { q == InfraPoint[ label ], InfraGeometricAssertion[ { q, { 3, 4 } }, "Distinct" ] } ] },
    ( instance |-> instance[[ 1 ]][ q ] ) /@ RandomInfraInstance[ scene, graph, All, <| p -> 9 |> ] ],
  { { p, InfraDistance[ 1, 2 ], InfraMeasurement[ InfraMidpoint[ 1, 1 ], "Cardinality" ] } },
  TestID -> "synthetic-t6-query-inside-literal-label-stays-inert"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraPoint[], p == InfraDistance[ 1, 3 ] } ] },
    ( instance |-> instance[[ 1 ]][ p ] ) /@ RandomInfraInstance[ scene, PathGraph[ { 1, 2, 3 } ], All ] ],
  { 2 },
  TestID -> "synthetic-t6-declared-lhs-scalar-equality-is-assertion"
]

VerificationTest[
  With[ { graph = Graph[ { { 0, 0 }, { 1, 0 }, { 2, 0 } },
      { UndirectedEdge[ { 0, 0 }, { 1, 0 } ], UndirectedEdge[ { 1, 0 }, { 2, 0 } ] } ],
      scene = InfraScene[ { p }, { p == InfraMidpoint[ { 0, 0 }, { 2, 0 } ] } ] },
    ( instance |-> instance[[ 1 ]][ p ] ) /@ RandomInfraInstance[ scene, graph, All ] ],
  { { 1, 0 } },
  TestID -> "synthetic-t6-list-valued-point-has-one-target"
]

VerificationTest[
  Head @ RandomInfraInstance[ InfraScene[ { p, q }, { { p, q } == InfraMidpoint[ 1, 3 ] } ], CycleGraph[ 4 ], All ],
  RandomInfraInstance,
  TestID -> "synthetic-t6-point-family-tuple-is-unsupported"
]

VerificationTest[
  With[ { scene = InfraScene[ { p, q }, { InfraStep[ { p == InfraPoint[] } ], InfraStep[ { q == InfraPoint[] } ],
        InfraGeometricAssertion[ { p, q }, "Distinct" ] } ], graph = PathGraph[ { 1, 2 } ] },
    { instances = RandomInfraInstance[ scene, graph, All, "Steps" -> 1 ] },
    AllTrue[ instances, instance |-> ! KeyExistsQ[ instance[[ 1 ]], q ] &&
      Head[ InfraGeometricTest[ graph, InfraGeometricAssertion[ { instance[[ 1 ]][ p ], q }, "Distinct" ] ] ] === InfraGeometricTest ] ],
  True,
  TestID -> "synthetic-t6-partial-assertion-explicitly-remains-unresolved"
]
