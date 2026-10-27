BeginTestSection[ "InfraDeformations" ]
Begin[ "WolframInstitute`InfraGeometry`Tests`" ]

square = CycleGraph[ 4 ];
ladder = Graph[ { 1 <-> 2, 2 <-> 3, 4 <-> 5, 5 <-> 6, 1 <-> 4, 2 <-> 5, 3 <-> 6 } ];
doubleSquare = Graph[ { 1 <-> 2, 2 <-> 3, 1 <-> 4, 4 <-> 5, 5 <-> 2, 2 <-> 6, 6 <-> 7, 7 <-> 3 } ];
grid = Graph[ Tuples[ Range[ 0, 2 ], 2 ], Join[
    Catenate @ Table[ UndirectedEdge[ { x, y }, { x + 1, y } ], { x, 0, 1 }, { y, 0, 2 } ],
    Catenate @ Table[ UndirectedEdge[ { x, y }, { x, y + 1 } ], { x, 0, 2 }, { y, 0, 1 } ] ] ];
gridReference = { { 0, 0 }, { 1, 0 }, { 2, 0 } };
gridPaths = FindPath[ grid, First @ gridReference, Last @ gridReference, 6, All ];
gridObject = WolframInstitute`InfraGeometry`InfraDeformation[ gridReference, UpTo[ 4 ], "TubeRadius" -> 2 ];
ladderObject = WolframInstitute`InfraGeometry`InfraDeformation[ { 1, 2, 3 }, UpTo[ 2 ] ];

VerificationTest[
  Head @ WolframInstitute`InfraGeometry`InfraDeformation[ { 1, 2 }, UpTo[ 2 ] ],
  WolframInstitute`InfraGeometry`InfraDeformation,
  TestID -> "Deformation-inert-specification" ]

VerificationTest[
  WolframInstitute`InfraGeometry`RandomInfraDeformation[ square, WolframInstitute`InfraGeometry`InfraDeformation[ { 1, 2 }, { 2 } ], All ],
  { { 1, 4, 3, 2 } },
  TestID -> "Deformation-square-detour-allows-inward-final-step" ]

VerificationTest[
  Sort @ WolframInstitute`InfraGeometry`RandomInfraDeformation[ square, WolframInstitute`InfraGeometry`InfraDeformation[ { 1, 2 }, UpTo[ 2 ] ], All ],
  { { 1, 2 }, { 1, 4, 3, 2 } },
  TestID -> "Deformation-reference-and-longer-square-detour" ]

VerificationTest[
  { WolframInstitute`InfraGeometry`RandomInfraDeformation[ square, WolframInstitute`InfraGeometry`InfraDeformation[ { 1, 2, 3 }, UpTo[ 10 ], "TubeRadius" -> 0 ], All ],
    InfraMeasurement[ square, WolframInstitute`InfraGeometry`InfraDeformation[ { 1, 2, 3 }, { 2 }, "TubeRadius" -> 0 ], "Cardinality" ] },
  { { { 1, 2, 3 } }, 0 },
  TestID -> "Deformation-zero-tube-is-reference-even-with-positive-budget" ]

VerificationTest[
  ( WolframInstitute`InfraGeometry`RandomInfraDeformation[ square, WolframInstitute`InfraGeometry`InfraDeformation[ #, UpTo[ 2 ], "TubeRadius" -> 0 ], All ] & ) /@
    { { 1, 2, 3 }, { 1, 4, 3 } },
  { { { 1, 2, 3 } }, { { 1, 4, 3 } } },
  TestID -> "Deformation-family-uses-reference-not-only-endpoints" ]

VerificationTest[
  Sort @ WolframInstitute`InfraGeometry`RandomInfraDeformation[ CycleGraph[ 6 ], WolframInstitute`InfraGeometry`InfraDeformation[ { 1, 2, 3, 4 }, { 0 }, "TubeRadius" -> 2 ], All ],
  { { 1, 2, 3, 4 }, { 1, 6, 5, 4 } },
  TestID -> "Deformation-metric-neighbourhood-can-cross-six-cycle-homotopy-classes" ]

VerificationTest[
  With[ { object = WolframInstitute`InfraGeometry`InfraDeformation[ { 2 }, UpTo[ 6 ] ] },
    { InfraMeasurement[ square, object, "Cardinality" ], WolframInstitute`InfraGeometry`RandomInfraDeformation[ square, object, All ],
      InfraMeasurement[ square, object, "VertexDensity" ], InfraMeasurement[ square, object, "EdgeDensity" ],
      InfraMemberQ[ square, object, { 2, 1, 2 } ] } ],
  { 1, { { 2 } }, <| 2 -> 1 |>, <| |>, False },
  TestID -> "Deformation-constant-reference-excludes-every-nonconstant-loop" ]

VerificationTest[
  ( InfraMeasurement[ CompleteGraph[ 3 ], WolframInstitute`InfraGeometry`InfraDeformation[ { 1, 2 }, { # } ], "Cardinality" ] & ) /@ { 0, 1, 2, 3 },
  { 1, 1, 0, 0 },
  TestID -> "Deformation-triangle-odd-excess-and-simple-length-limit" ]

VerificationTest[
  { InfraMeasurement[ ladder, WolframInstitute`InfraGeometry`InfraDeformation[ { 1, 2, 3 }, { 1, 2 } ], "Cardinality" ],
    InfraMeasurement[ ladder, WolframInstitute`InfraGeometry`InfraDeformation[ { 1, 2, 3 }, { 2 } ], "Length" ],
    InfraMeasurement[ ladder, ladderObject, "Length" ],
    Lookup[ InfraMeasurement[ ladder, ladderObject, "CountsByExcess" ], { 0, 1, 2 } ] },
  { 3, 4, { 2, 4 }, { 1, 0, 3 } },
  TestID -> "Deformation-exact-range-and-up-to-excess-specifications" ]

VerificationTest[
  { WolframInstitute`InfraGeometry`RandomInfraDeformation[ doubleSquare, WolframInstitute`InfraGeometry`InfraDeformation[ { 1, 2, 3 }, { 4 } ], All ],
    InfraMeasurement[ doubleSquare, WolframInstitute`InfraGeometry`InfraDeformation[ { 1, 2, 3 }, UpTo[ 4 ] ], "Cardinality" ] },
  { { { 1, 4, 5, 2, 6, 7, 3 } }, 4 },
  TestID -> "Deformation-allows-two-separated-simple-excursions" ]

VerificationTest[
  Sort @ WolframInstitute`InfraGeometry`RandomInfraDeformation[ grid, WolframInstitute`InfraGeometry`InfraDeformation[ gridReference, { 4 }, "TubeRadius" -> 2 ], All ],
  Sort @ Select[ gridPaths, Length[ # ] == 7 & ],
  TestID -> "Deformation-excess-four-agrees-with-independent-simple-path-enumeration" ]

VerificationTest[
  Sort @ WolframInstitute`InfraGeometry`RandomInfraDeformation[ grid, gridObject, All ],
  Sort @ gridPaths,
  TestID -> "Deformation-full-small-grid-family-agrees-with-built-in-simple-paths" ]

VerificationTest[
  { InfraMeasurement[ grid, gridObject, "Cardinality" ],
    KeySort @ InfraMeasurement[ grid, gridObject, "VertexDensity" ],
    KeySort @ InfraMeasurement[ grid, gridObject, "EdgeDensity" ] },
  { Length @ gridPaths, KeySort @ Counts @ Catenate @ gridPaths,
    KeySort @ Counts @ Catenate[ ( DirectedEdge @@@ Partition[ #, 2, 1 ] ) & /@ gridPaths ] },
  TestID -> "Deformation-dynamic-count-and-densities-match-independent-enumeration" ]

VerificationTest[
  With[ { repeated = { { 0, 0 }, { 1, 0 }, { 1, 1 }, { 0, 1 }, { 0, 0 }, { 1, 0 }, { 2, 0 } } },
    { InfraMemberQ[ grid, gridObject, repeated ],
      MemberQ[ WolframInstitute`InfraGeometry`RandomInfraDeformation[ grid, gridObject, All ], repeated ] } ],
  { False, False },
  TestID -> "Deformation-excess-four-rejects-nonbacktracking-square-loop" ]

VerificationTest[
  InfraMemberQ[ square, WolframInstitute`InfraGeometry`InfraDeformation[ { 1, 2 }, UpTo[ 2 ] ], # ] & /@
    { { 1, 2 }, { 1, 4, 3, 2 }, { 1, 4, 1, 2 }, { 2, 1 }, { 1, 3, 2 }, { 1 }, { } },
  { True, True, False, False, False, False, False },
  TestID -> "Deformation-membership-checks-simplicity-endpoints-and-edges" ]

VerificationTest[
  With[ { graph = Graph[ { { 1 }, { 2 }, { 3 } },
        { UndirectedEdge[ { 1 }, { 2 } ], UndirectedEdge[ { 2 }, { 3 } ] } ],
      reference = { { 1 }, { 2 }, { 3 } } },
    { object = WolframInstitute`InfraGeometry`InfraDeformation[ reference, UpTo[ 4 ] ] },
    { WolframInstitute`InfraGeometry`RandomInfraDeformation[ graph, object, All ], InfraMeasurement[ graph, object, "VertexDensity" ],
      InfraMemberQ[ graph, object, reference ] } ],
  { { { { 1 }, { 2 }, { 3 } } }, <| { 1 } -> 1, { 2 } -> 1, { 3 } -> 1 |>, True },
  TestID -> "Deformation-list-valued-vertices-remain-atomic-labels" ]

VerificationTest[
  With[ { graph = Graph[ { "a" <-> "b", "b" <-> "c", "c" <-> "d", "d" <-> "a" } ],
      object = WolframInstitute`InfraGeometry`InfraDeformation[ { "a", "b" }, UpTo[ 2 ] ] },
    { Sort @ WolframInstitute`InfraGeometry`RandomInfraDeformation[ graph, object, All ],
      InfraMeasurement[ graph, object, "Cardinality" ] } ],
  { { { "a", "b" }, { "a", "d", "c", "b" } }, 2 },
  TestID -> "Deformation-string-vertex-labels" ]

VerificationTest[
  With[ { graph = Graph[ { 1 <-> 2, 2 <-> 3, 10 <-> 11 } ],
      object = WolframInstitute`InfraGeometry`InfraDeformation[ { 1, 2, 3 }, UpTo[ 4 ], "TubeRadius" -> Infinity ] },
    { WolframInstitute`InfraGeometry`RandomInfraDeformation[ graph, object, All ], InfraMeasurement[ graph, object, "Cardinality" ] } ],
  { { { 1, 2, 3 } }, 1 },
  TestID -> "Deformation-disconnected-components-do-not-enter-state-space" ]

VerificationTest[
  With[ { dag = InfraMeasurement[ grid, gridObject, "Graph" ] },
    { source = First @ Pick[ VertexList @ dag, VertexInDegree @ dag, 0 ],
      sink = First @ Pick[ VertexList @ dag, VertexOutDegree @ dag, 0 ] },
    { AcyclicGraphQ @ dag, Sort @ VertexOutComponent[ dag, source ] === Sort @ VertexList @ dag,
      Sort @ VertexInComponent[ dag, sink ] === Sort @ VertexList @ dag } ],
  { True, True, True },
  TestID -> "Deformation-graph-is-acyclic-and-pruned-at-both-ends" ]

VerificationTest[
  With[ { paths = WolframInstitute`InfraGeometry`RandomInfraDeformation[ grid, gridObject, All ],
      density = InfraMeasurement[ grid, gridObject, "VertexDensity" ],
      edges = InfraMeasurement[ grid, gridObject, "EdgeDensity" ] },
    { DuplicateFreeQ @ paths, AllTrue[ paths, DuplicateFreeQ ],
      Lookup[ density, Key @ First @ gridReference ] == Length @ paths,
      Lookup[ density, Key @ Last @ gridReference ] == Length @ paths,
      Total @ Values @ density == Total[ Length /@ paths ],
      Total @ Values @ edges == Total[ Length /@ paths ] - Length @ paths } ],
  { True, True, True, True, True, True },
  TestID -> "Deformation-acceptance-is-once-per-simple-path-and-density-is-occupancy" ]

VerificationTest[
  { InfraMemberQ[ ladder, ladderObject, WolframInstitute`InfraGeometry`RandomInfraDeformation[ ladder, ladderObject ] ],
    Length @ WolframInstitute`InfraGeometry`RandomInfraDeformation[ ladder, ladderObject, 4 ],
    WolframInstitute`InfraGeometry`RandomInfraDeformation[ ladder, ladderObject, 5 ],
    Length @ WolframInstitute`InfraGeometry`RandomInfraDeformation[ ladder, ladderObject, UpTo[ 5 ] ],
    WolframInstitute`InfraGeometry`RandomInfraDeformation[ ladder, ladderObject, 0 ],
    WolframInstitute`InfraGeometry`RandomInfraDeformation[ ladder, ladderObject, UpTo[ 0 ] ] },
  { True, 4, { }, 4, { }, { } },
  TestID -> "Deformation-sampler-automatic-strict-up-to-and-zero-counts" ]

VerificationTest[
  With[ { object = WolframInstitute`InfraGeometry`InfraDeformation[ { 1, 2 }, { 1 } ] },
    { InfraMeasurement[ square, object, "Cardinality" ], InfraMeasurement[ square, object, "Length" ],
      VertexCount @ InfraMeasurement[ square, object, "Graph" ], WolframInstitute`InfraGeometry`RandomInfraDeformation[ square, object ],
      WolframInstitute`InfraGeometry`RandomInfraDeformation[ square, object, All ] } ],
  { 0, { }, 0, { }, { } },
  TestID -> "Deformation-empty-family-remains-distinct-from-unknown" ]

VerificationTest[
  With[ { samples = WolframInstitute`InfraGeometry`RandomInfraDeformation[ grid, gridObject, 5, RandomSeeding -> 531 ] },
    { samples === WolframInstitute`InfraGeometry`RandomInfraDeformation[ grid, gridObject, 5, RandomSeeding -> 531 ],
      Length @ samples, DuplicateFreeQ @ samples, AllTrue[ samples, InfraMemberQ[ grid, gridObject, # ] & ] } ],
  { True, 5, True, True },
  TestID -> "Deformation-seeded-sampling-is-repeatable-distinct-and-valid" ]

VerificationTest[
  BlockRandom[
    SeedRandom[ 713 ];
    With[ { expected = RandomInteger[ 10^9 ] },
      SeedRandom[ 713 ];
      WolframInstitute`InfraGeometry`RandomInfraDeformation[ ladder, ladderObject, 2, RandomSeeding -> 919 ];
      RandomInteger[ 10^9 ] === expected ] ],
  True,
  TestID -> "Deformation-explicit-seed-restores-ambient-random-stream" ]

VerificationTest[
  BlockRandom[
    SeedRandom[ 717 ];
    With[ { expected = RandomInteger[ 10^9 ] },
      SeedRandom[ 717 ];
      WolframInstitute`InfraGeometry`RandomInfraDeformation[ ladder, ladderObject, All, RandomSeeding -> None ];
      RandomInteger[ 10^9 ] === expected ] ],
  True,
  TestID -> "Deformation-all-enumeration-does-not-draw-random-numbers" ]

VerificationTest[
  BlockRandom[
    SeedRandom[ 719 ];
    With[ { expected = RandomInteger[ 10^9 ] },
      SeedRandom[ 719 ];
      WolframInstitute`InfraGeometry`RandomInfraDeformation[ ladder, ladderObject, 2, "NextVertexFunction" -> Identity, RandomSeeding -> None ];
      RandomInteger[ 10^9 ] === expected ] ],
  True,
  TestID -> "Deformation-identity-selection-does-not-draw-random-numbers" ]

VerificationTest[
  WolframInstitute`InfraGeometry`RandomInfraDeformation[ ladder, ladderObject, 4, "NextVertexFunction" -> Identity ] ===
    WolframInstitute`InfraGeometry`RandomInfraDeformation[ ladder, ladderObject, All ],
  True,
  TestID -> "Deformation-deterministic-rank-order-agrees-with-all" ]

VerificationTest[
  With[ { object = WolframInstitute`InfraGeometry`InfraDeformation[ { 1, 2, 3 }, UpTo[ 2 ], "MaxStates" -> 1 ] },
    { MatchQ[ InfraMeasurement[ ladder, object, "Cardinality" ], _InfraMeasurement ],
      InfraMemberQ[ ladder, object, { 1, 2, 3 } ] } ],
  { True, True },
  TestID -> "Deformation-state-budget-is-unknown-count-not-empty-family" ]

VerificationTest[
  MatchQ[ InfraMeasurement[ CompleteGraph[ 3 ], WolframInstitute`InfraGeometry`InfraDeformation[ { 1, 2, 3 }, UpTo[ 2 ] ], "Graph" ],
    _InfraMeasurement ],
  True,
  TestID -> "Deformation-nonshortest-reference-is-nonmatch" ]

VerificationTest[
  With[ { object = WolframInstitute`InfraGeometry`InfraDeformation[ { 1, 2, 3 }, UpTo[ 2 ], "TubeRadius" -> 0 ] },
    InfraMemberQ[ square, object, # ] & /@ { { 1, 2, 3 }, { 1, 4, 3 } } ],
  { True, False },
  TestID -> "Deformation-membership-respects-reference-tube" ]

VerificationTest[
  With[ { graph = Graph @ Catenate @ Table[
        { UndirectedEdge[ index - 1, 70 + 2 index - 1 ], UndirectedEdge[ 70 + 2 index - 1, index ],
          UndirectedEdge[ index - 1, 70 + 2 index ], UndirectedEdge[ 70 + 2 index, index ] }, { index, 1, 70 } ],
      reference = Join[ Catenate @ Table[ { index - 1, 70 + 2 index - 1 }, { index, 1, 70 } ], { 70 } ] },
    { object = WolframInstitute`InfraGeometry`InfraDeformation[ reference, { 0 } ] },
    { samples = WolframInstitute`InfraGeometry`RandomInfraDeformation[ graph, object, 3, RandomSeeding -> 123 ] },
    { InfraMeasurement[ graph, object, "Cardinality" ], Length @ samples, DuplicateFreeQ @ samples,
      AllTrue[ samples, InfraMemberQ[ graph, object, # ] & ] } ],
  { 2^70, 3, True, True },
  TestID -> "Deformation-arbitrary-precision-ranks-sample-huge-family-without-enumeration" ]

VerificationTest[
  BlockRandom[
    SeedRandom[ 727 ];
    With[ { expectedNext = RandomInteger[ 10^9 ] },
      SeedRandom[ 727 ];
      With[ { first = WolframInstitute`InfraGeometry`RandomInfraDeformation[
            ladder, ladderObject, 3, RandomSeeding -> Inherited ],
          second = WolframInstitute`InfraGeometry`RandomInfraDeformation[
            ladder, ladderObject, 3, RandomSeeding -> Inherited ],
          expected = BlockRandom[ WolframInstitute`InfraGeometry`RandomInfraDeformation[
            ladder, ladderObject, 3, RandomSeeding -> None ] ] },
        { first === second, first === expected, RandomInteger[ 10^9 ] === expectedNext } ] ] ],
  { True, True, True },
  TestID -> "Deformation-inherited-seed-clones-current-stream-and-restores-it" ]

VerificationTest[
  With[ { graph = CycleGraph[ 4 ] },
    WolframInstitute`InfraGeometry`InfraMeasurement[ graph, WolframInstitute`InfraGeometry`InfraSegment[ 1, 3 ], { "Cardinality", "Length" } ] ],
  <| "Cardinality" -> 2, "Length" -> 2 |>,
  TestID -> "Deformation-public-load-preserves-segment-readings" ]

VerificationTest[
  With[ { graph = CycleGraph[ 4 ], object = WolframInstitute`InfraGeometry`InfraDeformation[ { 1, 2 }, UpTo[ 2 ], "MaxStates" -> 1 ] },
    { MatchQ[ WolframInstitute`InfraGeometry`InfraMeasurement[ graph, object, "Cardinality" ], _WolframInstitute`InfraGeometry`InfraMeasurement ],
      WolframInstitute`InfraGeometry`InfraMemberQ[ graph, object, { 1, 4, 3, 2 } ] } ],
  { True, True },
  TestID -> "Deformation-public-budget-preserves-membership" ]

End[ ]
EndTestSection[ ]
