BeginTestSection[ "InfraFiberedGraph" ]

VerificationTest[
  { InfraFiberedGraph[ total, projection ], InfraFiberedGraph[ total, projection ] },
  { InfraFiberedGraph[ total, projection ], InfraFiberedGraph[ total, projection ] },
  TestID -> "InfraFiberedGraph-both-description-heads-are-inert"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[
      Graph[ { { "a", 1 }, { "a", 2 }, { "b", 1 }, { "isolated", 1 } },
        { UndirectedEdge[ { "a", 1 }, { "b", 1 } ] } ],
      AssociationThread[ { { "a", 1 }, { "a", 2 }, { "b", 1 }, { "isolated", 1 } },
        { { "base", 1 }, { "base", 1 }, { "base", 2 }, { "base", 3 } } ] ] },
    InfraEdgeLiftMultiplicity[ fib ] ],
  AssociationThread[ { { "a", 1 }, { "a", 2 }, { "b", 1 }, { "isolated", 1 } },
    { Association[ { "base", 2 } -> 1 ], Association[ { "base", 2 } -> 0 ],
      Association[ { "base", 1 } -> 1 ], <| |> } ],
  TestID -> "InfraEdgeLiftMultiplicity-literal-list-keys-zeros-and-isolated-base-point"
]

VerificationTest[
  With[ { vertices = { Blank[ Integer ], Alternatives[ "left", "right" ], f[ "end" ] } },
    { fib = InfraFiberedGraph[ Graph[ vertices, { UndirectedEdge @@ Take[ vertices, 2 ] } ],
        AssociationThread[ vertices, { "p", "q", "q" } ] ] },
    { InfraEdgeLiftMultiplicity[ fib ] === AssociationThread[ vertices, { <| "q" -> 1 |>, <| "p" -> 1 |>, <| "p" -> 0 |> } ],
      InfraAtMostOneEdgeLiftQ[ fib ], InfraFibrationQ[ fib ],
      InfraBundleMorphismQ[ fib, fib, AssociationThread[ vertices, vertices ] ] } ],
  { True, True, False, True },
  TestID -> "InfraFiberedGraph-patternlike-labels-are-literal"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ Graph[ Range[ 4 ],
        { UndirectedEdge[ 1, 2 ], UndirectedEdge[ 1, 3 ], UndirectedEdge[ 1, 4 ], UndirectedEdge[ 2, 3 ] } ],
      <| 1 -> "p", 2 -> "p", 3 -> "q", 4 -> "q" |> ] },
    InfraEdgeLiftMultiplicity[ fib ] ],
  <| 1 -> <| "q" -> 2 |>, 2 -> <| "q" -> 1 |>, 3 -> <| "p" -> 2 |>, 4 -> <| "p" -> 1 |> |>,
  TestID -> "InfraEdgeLiftMultiplicity-counts-transverse-neighbors-only"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ Graph[ Range[ 4 ], { UndirectedEdge[ 1, 3 ] } ],
      <| 1 -> "p", 2 -> "p", 3 -> "q", 4 -> "q" |> ] },
    { InfraFiberedGraphQ[ fib ], InfraEqualFiberSizesQ[ fib ], InfraIsomorphicFibersQ[ fib ],
      InfraAtMostOneEdgeLiftQ[ fib ], InfraFibrationQ[ fib ], InfraUniqueEdgeLiftingQ[ fib ], InfraCoveringQ[ fib ] } ],
  { True, True, True, True, False, False, False },
  TestID -> "InfraAtMostOneEdgeLiftQ-partial-matching-does-not-assert-existence"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ Graph[ Range[ 6 ],
        { UndirectedEdge[ 1, 4 ], UndirectedEdge[ 2, 4 ], UndirectedEdge[ 3, 5 ], UndirectedEdge[ 3, 6 ] } ],
      AssociationThread[ Range[ 6 ], { "p", "p", "p", "q", "q", "q" } ] ] },
    { InfraFibrationQ[ fib ], InfraEqualFiberSizesQ[ fib ], InfraIsomorphicFibersQ[ fib ],
      InfraUniqueEdgeLiftingQ[ fib ], RandomInfraConnection[ fib ] } ],
  { True, True, True, False, { } },
  TestID -> "InfraFibrationQ-Hall-obstruction-to-a-complete-connection"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ Graph[ Range[ 6 ],
        { UndirectedEdge[ 1, 2 ], UndirectedEdge[ 3, 5 ], UndirectedEdge[ 4, 6 ] } ],
      AssociationThread[ Range[ 6 ], { "a", "b", "c", "c", "d", "d" } ] ] },
    { InfraUniqueEdgeLiftingQ[ fib ], InfraCoveringQ[ fib ],
      InfraEqualFiberSizesQ[ fib ], InfraIsomorphicFibersQ[ fib ], InfraFiberBundleQ[ fib ] } ],
  { True, True, False, False, False },
  TestID -> "InfraUniqueEdgeLiftingQ-size-equality-is-componentwise"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ Graph[ Range[ 4 ], { UndirectedEdge[ 1, 2 ] } ],
      <| 1 -> "p", 2 -> "p", 3 -> "q", 4 -> "q" |> ] },
    { InfraEqualFiberSizesQ[ fib ], InfraIsomorphicFibersQ[ fib ], InfraUniqueEdgeLiftingQ[ fib ] } ],
  { True, False, True },
  TestID -> "InfraEqualFiberSizesQ-does-not-imply-isomorphic-fibers"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ Graph[ Range[ 6 ],
        { UndirectedEdge[ 1, 2 ], UndirectedEdge[ 2, 3 ], UndirectedEdge[ 4, 5 ], UndirectedEdge[ 5, 6 ],
          UndirectedEdge[ 1, 5 ], UndirectedEdge[ 2, 4 ], UndirectedEdge[ 3, 6 ] } ],
      AssociationThread[ Range[ 6 ], { "p", "p", "p", "q", "q", "q" } ] ] },
    { InfraUniqueEdgeLiftingQ[ fib ], InfraIsomorphicFibersQ[ fib ], InfraFiberBundleQ[ fib ] } ],
  { True, True, False },
  TestID -> "InfraFiberBundleQ-requires-the-actual-transport-to-preserve-adjacency"
]

VerificationTest[
  With[ { total = GraphProduct[ CompleteGraph[ 2 ], CycleGraph[ 3 ], "Cartesian" ] },
    { fib = InfraFiberedGraph[ total, Last ] },
    { InfraFiberBundleQ[ fib ], InfraUniqueEdgeLiftingQ[ fib ], InfraCoveringQ[ fib ] } ],
  { True, True, False },
  TestID -> "InfraCoveringQ-excludes-vertical-edges"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ CycleGraph[ 6 ], point |-> Mod[ point, 3, 1 ] ] },
    { InfraFiberBundleQ[ fib ], InfraCoveringQ[ fib ],
      InfraTrivialMonodromyQ[ fib, InfraConnection[ EdgeList @ InfraTotalSpace[ fib ] ] ] } ],
  { True, True, False },
  TestID -> "InfraFiberBundleQ-allows-twisted-coverings"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ Graph[ { }, { } ], <| |> ],
      predicates = { InfraFiberedGraphQ, InfraEqualFiberSizesQ, InfraIsomorphicFibersQ,
        InfraFibrationQ, InfraAtMostOneEdgeLiftQ, InfraUniqueEdgeLiftingQ, InfraCoveringQ, InfraFiberBundleQ } },
    { ( #[ fib ] & /@ predicates ), ( #[ { fib } ] & /@ predicates ), ( #[ { } ] & /@ predicates ),
      InfraEdgeLiftMultiplicity[ fib ] } ],
  { ConstantArray[ True, 8 ], ConstantArray[ True, 8 ], ConstantArray[ False, 8 ], <| |> },
  TestID -> "InfraFiberedGraph-predicates-empty-object-and-counted-families"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ CycleGraph[ 3 ], Identity ],
      predicates = { InfraFiberedGraphQ, InfraEqualFiberSizesQ, InfraIsomorphicFibersQ,
        InfraFibrationQ, InfraAtMostOneEdgeLiftQ, InfraUniqueEdgeLiftingQ, InfraCoveringQ, InfraFiberBundleQ } },
    And @@ ( #[ { fib, symbolic } ] === #[ symbolic ] & /@ predicates ) ],
  True,
  TestID -> "InfraFiberedGraph-predicate-families-preserve-undecided-members"
]

VerificationTest[
  With[ { missing = InfraFiberedGraph[ PathGraph[ Range[ 3 ] ], <| 1 -> "p", 2 -> "q" |> ],
      extra = InfraFiberedGraph[ PathGraph[ Range[ 3 ] ], <| 1 -> "p", 2 -> "q", 3 -> "r", 4 -> "s" |> ] },
    { Head @ InfraProjection[ missing ], Head @ InfraBaseSpace[ missing ],
      Head @ InfraFiberedGraphQ[ missing ], Head @ InfraEqualFiberSizesQ[ extra ],
      Head @ InfraEdgeLiftMultiplicity[ extra ] } ],
  { InfraProjection, InfraBaseSpace, InfraFiberedGraphQ, InfraEqualFiberSizesQ,
    InfraEdgeLiftMultiplicity },
  TestID -> "InfraFiberedGraph-malformed-projections-remain-unevaluated"
]

VerificationTest[
  With[ { directed = Graph[ { 1 -> 2 } ], weighted = Graph[ CycleGraph[ 3 ], EdgeWeight -> { 1, 2, 3 } ] },
    Map[ graph |-> With[ { fib = InfraFiberedGraph[ graph, Identity ] },
      { Head @ InfraTotalSpace[ fib ], Head @ InfraFiberedGraphQ[ fib ], Head @ RandomInfraFiberedGraph[ graph ] } ],
      { directed, weighted } ] ],
  ConstantArray[ { InfraTotalSpace, InfraFiberedGraphQ, RandomInfraFiberedGraph }, 2 ],
  TestID -> "InfraFiberedGraph-unsupported-graph-domains-remain-unevaluated"
]

VerificationTest[
  With[ { base = CycleGraph[ 4 ] },
    { fib = RandomInfraFiberedGraph[ base ] },
    { Head[ fib ], InfraFiberedGraphQ[ fib ], VertexCount @ InfraTotalSpace[ fib ],
      VertexList[ InfraBaseSpace[ fib ] ] === VertexList[ base ] &&
        Sort[ Sort /@ ( List @@@ EdgeList @ InfraBaseSpace[ fib ] ) ] === Sort[ Sort /@ ( List @@@ EdgeList[ base ] ) ],
      InfraCoveringQ[ fib ] } ],
  { InfraFiberedGraph, True, 4, True, True },
  TestID -> "RandomInfraFiberedGraph-default"
]

VerificationTest[
  With[ { fib = RandomInfraFiberedGraph[ PathGraph[ { "p", "q" } ],
      "VerticalVertexCount" -> { 3 }, "HorizontalEdgeCount" -> { 1 } ] },
    { InfraFiberedGraphQ[ fib ], InfraFibrationQ[ fib ], InfraAtMostOneEdgeLiftQ[ fib ],
      EdgeCount @ InfraTotalSpace[ fib ] } ],
  { True, False, True, 1 },
  TestID -> "RandomInfraFiberedGraph-general-class-does-not-force-lifting"
]

VerificationTest[
  With[ { fib = RandomInfraFiberedGraph[ CycleGraph[ 4 ],
      "VerticalVertexCount" -> { 3 }, "VerticalEdgeCount" -> { 2 }, "HorizontalEdgeCount" -> { 1 } ] },
    { VertexCount /@ Values @ InfraFibers[ fib ], EdgeCount /@ Values @ InfraFibers[ fib ],
      EdgeCount @ InfraTotalSpace[ fib ] } ],
  { ConstantArray[ 3, 4 ], ConstantArray[ 2, 4 ], 12 },
  TestID -> "RandomInfraFiberedGraph-singleton-counts-are-exact"
]

VerificationTest[
  SeedRandom[ 31 ];
  With[ { expected = Table[ RandomInteger[ { 1, 7 } ], { 15 } ] },
    SeedRandom[ 31 ];
    With[ { fib = RandomInfraFiberedGraph[ Graph[ Range[ 15 ], { } ], "VerticalVertexCount" -> 7, RandomSeeding -> None ] },
      VertexCount /@ Values @ InfraFibers[ fib ] === expected ] ],
  True,
  TestID -> "RandomInfraFiberedGraph-scalar-vertex-count-is-uniform-positive-upper-bound"
]

VerificationTest[
  SeedRandom[ 42 ];
  With[ { expected = Table[ RandomInteger[ { 5, 7 } ], { 15 } ] },
    SeedRandom[ 42 ];
    With[ { fib = RandomInfraFiberedGraph[ Graph[ Range[ 15 ], { } ], "VerticalVertexCount" -> { 5, 7 }, RandomSeeding -> None ] },
      VertexCount /@ Values @ InfraFibers[ fib ] === expected ] ],
  True,
  TestID -> "RandomInfraFiberedGraph-range-vertex-count-is-inclusive-discrete-uniform"
]

VerificationTest[
  SeedRandom[ 2 ];
  With[ { fib = RandomInfraFiberedGraph[ CycleGraph[ 5 ], "VerticalVertexCount" -> { 3 }, "VerticalEdgeCount" -> 99, RandomSeeding -> None ] },
    AllTrue[ EdgeCount /@ Values @ InfraFibers[ fib ], Between[ { 0, 3 } ] ] ],
  True,
  TestID -> "RandomInfraFiberedGraph-scalar-edge-cap-respects-capacity"
]

VerificationTest[
  With[ { base = CycleGraph[ 3 ] },
    Head /@ {
      RandomInfraFiberedGraph[ base, "VerticalVertexCount" -> { 3 }, "VerticalEdgeCount" -> { 4 } ],
      RandomInfraFiberedGraph[ base, "VerticalVertexCount" -> { 3 }, "VerticalEdgeCount" -> { 0, 4 } ],
      RandomInfraFiberedGraph[ base, "VerticalVertexCount" -> { 2, 4 }, "VerticalEdgeCount" -> { 2 } ] } ],
  ConstantArray[ RandomInfraFiberedGraph, 3 ],
  TestID -> "RandomInfraFiberedGraph-infeasible-exact-and-range-counts-are-not-clipped"
]

VerificationTest[
  SeedRandom[ 9 ];
  With[ { fib = RandomInfraFiberedGraph[ CycleGraph[ 6 ], Properties -> { "EqualFiberSizes" },
      "VerticalVertexCount" -> { 2, 5 }, "VerticalEdgeCount" -> 4, RandomSeeding -> None ] },
    { InfraEqualFiberSizesQ[ fib ], AllTrue[ VertexCount /@ Values @ InfraFibers[ fib ], Between[ { 2, 5 } ] ] } ],
  { True, True },
  TestID -> "RandomInfraFiberedGraph-equal-fiber-sizes-share-one-draw"
]

VerificationTest[
  SeedRandom[ 4 ];
  With[ { fib = RandomInfraFiberedGraph[ CycleGraph[ 5 ], Properties -> { "IsomorphicFibers" },
      "VerticalVertexCount" -> { 3, 5 }, "VerticalEdgeCount" -> { 1, 3 }, RandomSeeding -> None ] },
    { InfraEqualFiberSizesQ[ fib ], InfraIsomorphicFibersQ[ fib ] } ],
  { True, True },
  TestID -> "RandomInfraFiberedGraph-isomorphic-fibers-share-a-template"
]

VerificationTest[
  SeedRandom[ 13 ];
  With[ { first = RandomInfraFiberedGraph[ CycleGraph[ 4 ],
      Properties -> { "IsomorphicFibers", "Fibration" }, "VerticalVertexCount" -> { 3, 4 }, RandomSeeding -> None ] },
    SeedRandom[ 13 ];
    first === RandomInfraFiberedGraph[ CycleGraph[ 4 ],
      Properties -> { "Fibration", "IsomorphicFibers", "Fibration" }, "VerticalVertexCount" -> { 3, 4 }, RandomSeeding -> None ] ],
  True,
  TestID -> "RandomInfraFiberedGraph-properties-are-an-order-independent-conjunction"
]

VerificationTest[
  SeedRandom[ 6 ];
  With[ { fib = RandomInfraFiberedGraph[ PathGraph[ { "p", "q" } ], Properties -> { "Fibration" },
      "VerticalVertexCount" -> { 3 }, "HorizontalEdgeCount" -> { 4 }, RandomSeeding -> None ] },
    { InfraFibrationQ[ fib ], EdgeCount @ InfraTotalSpace[ fib ], VertexCount @ InfraBaseSpace[ fib ] } ],
  { True, 4, 2 },
  TestID -> "RandomInfraFiberedGraph-fibration-construction-covers-every-endpoint"
]

VerificationTest[
  SeedRandom[ 27 ];
  With[ { samples = Table[
      RandomInfraFiberedGraph[ PathGraph[ { 1, 2 } ], Properties -> { "Fibration" },
        "VerticalVertexCount" -> { 3 }, "HorizontalEdgeCount" -> { 4 }, RandomSeeding -> None ], { 60 } ] },
    { And @@ ( InfraFibrationQ /@ samples ), AnyTrue[ samples, RandomInfraConnection[ #, RandomSeeding -> None ] === { } & ] } ],
  { True, True },
  TestID -> "RandomInfraFiberedGraph-weak-fibrations-include-Hall-obstructions"
]

VerificationTest[
  With[ { fib = RandomInfraFiberedGraph[ CycleGraph[ 4 ], Properties -> { "AtMostOneEdgeLift" },
      "VerticalVertexCount" -> { 3 }, "HorizontalEdgeCount" -> { 2 } ] },
    { InfraAtMostOneEdgeLiftQ[ fib ], InfraFibrationQ[ fib ], EdgeCount @ InfraTotalSpace[ fib ] } ],
  { True, False, 8 },
  TestID -> "RandomInfraFiberedGraph-partial-matchings"
]

VerificationTest[
  SeedRandom[ 21 ];
  With[ { base = Graph[ Range[ 4 ], { UndirectedEdge[ 1, 2 ], UndirectedEdge[ 3, 4 ] } ] },
    { fib = RandomInfraFiberedGraph[ base, Properties -> { "UniqueEdgeLifting" }, "VerticalVertexCount" -> { 2, 5 }, RandomSeeding -> None ] },
    { counts = VertexCount /@ Values @ InfraFibers[ fib ] },
    { InfraUniqueEdgeLiftingQ[ fib ], counts[[ 1 ]] == counts[[ 2 ]], counts[[ 3 ]] == counts[[ 4 ]],
      AllTrue[ counts, Between[ { 2, 5 } ] ] } ],
  { True, True, True, True },
  TestID -> "RandomInfraFiberedGraph-unique-lifting-couples-sizes-by-base-component"
]

VerificationTest[
  SeedRandom[ 18 ];
  With[ { first = RandomInfraFiberedGraph[ CycleGraph[ 3 ], Properties -> { "UniqueEdgeLifting" },
      "VerticalVertexCount" -> { 2, 4 }, RandomSeeding -> None ] },
    SeedRandom[ 18 ];
    first === RandomInfraFiberedGraph[ CycleGraph[ 3 ], Properties -> { "AtMostOneEdgeLift", "Fibration" },
      "VerticalVertexCount" -> { 2, 4 }, RandomSeeding -> None ] ],
  True,
  TestID -> "RandomInfraFiberedGraph-unique-lifting-is-existence-and-at-most-one"
]

VerificationTest[
  With[ { fib = RandomInfraFiberedGraph[ CycleGraph[ 4 ], Properties -> { "Covering" },
      "VerticalVertexCount" -> { 3 }, "VerticalEdgeCount" -> 9 ] },
    { InfraCoveringQ[ fib ], EdgeCount /@ Values @ InfraFibers[ fib ] } ],
  { True, { 0, 0, 0, 0 } },
  TestID -> "RandomInfraFiberedGraph-covering-restricts-scalar-vertical-cap-to-zero"
]

VerificationTest[
  Head @ RandomInfraFiberedGraph[ CycleGraph[ 4 ], Properties -> { "Covering" },
    "VerticalVertexCount" -> { 3 }, "VerticalEdgeCount" -> { 1 } ],
  RandomInfraFiberedGraph,
  TestID -> "RandomInfraFiberedGraph-covering-cannot-override-an-exact-positive-vertical-count"
]

VerificationTest[
  SeedRandom[ 19 ];
  And @@ Table[
    InfraFiberBundleQ @ RandomInfraFiberedGraph[ CycleGraph[ 3 ], Properties -> { "FiberBundle" },
      "VerticalVertexCount" -> { 4 }, "VerticalEdgeCount" -> { 3 }, RandomSeeding -> None ], { 12 } ],
  True,
  TestID -> "RandomInfraFiberedGraph-bundle-transports-are-fiber-automorphisms"
]

VerificationTest[
  With[ { fib = RandomInfraFiberedGraph[ CycleGraph[ 4 ], "VerticalVertexCount" -> { 3 }, "HorizontalEdgeCount" -> All ] },
    { InfraFibrationQ[ fib ], InfraUniqueEdgeLiftingQ[ fib ], EdgeCount @ InfraTotalSpace[ fib ] } ],
  { True, False, 36 },
  TestID -> "RandomInfraFiberedGraph-All-means-complete-transverse-joins"
]

VerificationTest[
  { Head @ RandomInfraFiberedGraph[ CycleGraph[ 3 ], Properties -> { "UniqueEdgeLifting" },
      "VerticalVertexCount" -> { 2 }, "HorizontalEdgeCount" -> All ],
    InfraUniqueEdgeLiftingQ @ RandomInfraFiberedGraph[ CycleGraph[ 3 ],
      Properties -> { "UniqueEdgeLifting" }, "HorizontalEdgeCount" -> All ] },
  { RandomInfraFiberedGraph, True },
  TestID -> "RandomInfraFiberedGraph-complete-joins-must-be-compatible-with-properties"
]

VerificationTest[
  SeedRandom[ 8 ];
  With[ { fib = RandomInfraFiberedGraph[ CycleGraph[ 6 ], Properties -> { "Fibration" },
      "VerticalVertexCount" -> { 3, 4 }, "HorizontalEdgeCount" -> { 4, 6 }, RandomSeeding -> None ] },
    { projection = InfraProjection[ fib ], total = InfraTotalSpace[ fib ] },
    { InfraFibrationQ[ fib ],
      AllTrue[ EdgeList @ InfraBaseSpace[ fib ], edge |->
        Count[ EdgeList[ total ], candidate_ /;
          Sort[ Lookup[ projection, Key /@ List @@ candidate ] ] === Sort[ List @@ edge ] ] >= 4 &&
        Count[ EdgeList[ total ], candidate_ /;
          Sort[ Lookup[ projection, Key /@ List @@ candidate ] ] === Sort[ List @@ edge ] ] <= 6 ] } ],
  { True, True },
  TestID -> "RandomInfraFiberedGraph-explicit-horizontal-range-is-realized-without-clipping"
]

VerificationTest[
  With[ { base = CycleGraph[ 3 ] },
    Head /@ {
      RandomInfraFiberedGraph[ base, Properties -> { "Fibration" },
        "VerticalVertexCount" -> { 3, 4 }, "HorizontalEdgeCount" -> { 2, 4 } ],
      RandomInfraFiberedGraph[ base, "VerticalVertexCount" -> { 2, 3 }, "HorizontalEdgeCount" -> { 1, 5 } ],
      RandomInfraFiberedGraph[ base, Properties -> { "UniqueEdgeLifting" },
        "VerticalVertexCount" -> { 3, 5 }, "HorizontalEdgeCount" -> { 4 } ],
      RandomInfraFiberedGraph[ base, Properties -> { "Fibration" },
        "VerticalVertexCount" -> { 2, 4 }, "HorizontalEdgeCount" -> 3 ] } ],
  ConstantArray[ RandomInfraFiberedGraph, 4 ],
  TestID -> "RandomInfraFiberedGraph-horizontal-specifications-must-fit-every-permitted-size"
]

VerificationTest[
  SeedRandom[ 5 ];
  InfraFibrationQ @ RandomInfraFiberedGraph[ CycleGraph[ 8 ], Properties -> { "Fibration" },
    "VerticalVertexCount" -> { 2, 4 }, "HorizontalEdgeCount" -> 4, RandomSeeding -> None ],
  True,
  TestID -> "RandomInfraFiberedGraph-horizontal-scalar-cap-adapts-to-actual-sizes"
]

VerificationTest[
  With[ { base = Graph[ { { "p", 1 }, { "q", 2 }, { "isolated", 3 } },
        { UndirectedEdge[ { "p", 1 }, { "q", 2 } ] } ] },
    { fib = RandomInfraFiberedGraph[ base, "VerticalVertexCount" -> { 2 }, "HorizontalEdgeCount" -> { 1 } ] },
    { VertexList @ InfraBaseSpace[ fib ] === VertexList[ base ],
      EdgeList @ InfraBaseSpace[ fib ] === EdgeList[ base ],
      VertexCount @ InfraFiber[ fib, { "isolated", 3 } ] } ],
  { True, True, 2 },
  TestID -> "RandomInfraFiberedGraph-preserves-literal-base-labels-and-isolated-points"
]

VerificationTest[
  With[ { fib = RandomInfraFiberedGraph[ Graph[ { }, { } ], Properties -> { "FiberBundle" },
      "VerticalVertexCount" -> { 3, 5 }, "VerticalEdgeCount" -> { 99 }, "HorizontalEdgeCount" -> { 999 } ] },
    { InfraFiberedGraphQ[ fib ], InfraFiberBundleQ[ fib ], VertexCount @ InfraTotalSpace[ fib ], InfraProjection[ fib ] } ],
  { True, True, 0, <| |> },
  TestID -> "RandomInfraFiberedGraph-empty-base-has-no-count-constraints-to-realize"
]

VerificationTest[
  With[ { fib = RandomInfraFiberedGraph[ Graph[ { "p", "q" }, { } ],
      Properties -> { "UniqueEdgeLifting" }, "VerticalVertexCount" -> { 3 }, "HorizontalEdgeCount" -> { 0 } ] },
    { VertexCount @ InfraTotalSpace[ fib ], EdgeCount @ InfraTotalSpace[ fib ], InfraUniqueEdgeLiftingQ[ fib ] } ],
  { 6, 0, True },
  TestID -> "RandomInfraFiberedGraph-edgeless-base-has-no-horizontal-count-constraint"
]

VerificationTest[
  With[ { base = CycleGraph[ 3 ] },
    Head /@ {
      RandomInfraFiberedGraph[ base, Properties -> { "UnknownProperty" } ],
      RandomInfraFiberedGraph[ base, Properties -> "Fibration" ],
      RandomInfraFiberedGraph[ base, "UnknownOption" -> 1 ],
      RandomInfraFiberedGraph[ base, "VerticalVertexCount" -> 3. ],
      RandomInfraFiberedGraph[ base, "VerticalVertexCount" -> { 0 } ],
      RandomInfraFiberedGraph[ base, "VerticalVertexCount" -> { 3, 2 } ],
      RandomInfraFiberedGraph[ base, "HorizontalEdgeCount" -> { 0 } ],
      RandomInfraFiberedGraph[ base, "VerticalEdgeCount" -> -1 ] } ],
  ConstantArray[ RandomInfraFiberedGraph, 8 ],
  TestID -> "RandomInfraFiberedGraph-unsupported-options-remain-unevaluated"
]

VerificationTest[
  With[ { fib = RandomInfraFiberedGraph[ CycleGraph[ 3 ],
      { "VerticalVertexCount" -> { 2 }, "VerticalVertexCount" -> { 3 } } ] },
    VertexCount @ InfraTotalSpace[ fib ] ],
  6,
  TestID -> "RandomInfraFiberedGraph-standard-option-lists-and-first-duplicate"
]

VerificationTest[
  SeedRandom[ 77 ];
  With[ { first = RandomInfraFiberedGraph[ CycleGraph[ 4 ], "VerticalVertexCount" -> { 2, 4 }, "VerticalEdgeCount" -> 3, RandomSeeding -> None ] },
    SeedRandom[ 77 ];
    first === RandomInfraFiberedGraph[ CycleGraph[ 4 ], "VerticalVertexCount" -> { 2, 4 }, "VerticalEdgeCount" -> 3, RandomSeeding -> None ] ],
  True,
  TestID -> "RandomInfraFiberedGraph-uses-the-ambient-random-stream"
]

VerificationTest[
  Trace[ RandomInfraFiberedGraph[ CycleGraph[ 3 ], "VerticalVertexCount" -> { 2 } ],
    HoldPattern[ GraphEmbedding[ ___ ] ], TraceInternal -> True ],
  { },
  TestID -> "RandomInfraFiberedGraph-generation-does-not-compute-a-layout"
]

VerificationTest[
  With[ { tagged = Graph[ { 1, 2 }, { UndirectedEdge[ 1, 2, "tag" ] } ] },
    { fib = InfraFiberedGraph[ tagged, Identity ] },
    { Head @ InfraTotalSpace[ fib ], Head @ InfraFiberedGraphQ[ fib ], Head @ InfraEdgeLiftMultiplicity[ fib ],
      Head @ RandomInfraFiberedGraph[ tagged ] } ],
  { InfraTotalSpace, InfraFiberedGraphQ, InfraEdgeLiftMultiplicity, RandomInfraFiberedGraph },
  TestID -> "InfraFiberedGraph-tagged-edges-remain-unevaluated"
]

(* Translated from InfraGaugeTheory Tests/FiberedGraph.wlt at e5dc83b *)

(* ===== the head and the primitives ===== *)

VerificationTest[
  InfraFiberedGraph[x, y],
  InfraFiberedGraph[x, y],
  TestID -> "InfraFiberedGraph-head-is-inert"
]

VerificationTest[
  With[{fib = InfraFiberedGraph[CycleGraph[8], i |-> Mod[i, 4, 1]]},
    {VertexCount[InfraTotalSpace[fib]], InfraProjection[fib] === AssociationMap[Mod[#, 4, 1] &, Range[8]]}],
  {8, True},
  TestID -> "InfraFiberedGraph-projection-as-function"
]

VerificationTest[
  With[{fib = InfraFiberedGraph[CycleGraph[8], i |-> Mod[i, 4, 1]]},
    {EdgeList[InfraFiber[fib, 1]], Sort[VertexList[InfraFiber[fib, 1]]], Keys[InfraFibers[fib]], VertexCount /@ Values[InfraFibers[fib]]}],
  {{}, {1, 5}, {1, 2, 3, 4}, {2, 2, 2, 2}},
  TestID -> "InfraFiber-preimage-of-a-base-vertex"
]

VerificationTest[
  {InfraFibrationQ[foo], InfraFiberBundleQ[foo], InfraBaseSpace[foo]},
  {InfraFibrationQ[foo], InfraFiberBundleQ[foo], InfraBaseSpace[foo]},
  TestID -> "InfraFibrationQ-not-a-fibration-stays-unevaluated"
]

(* ===== RandomInfraFibration ===== *)

VerificationTest[
  SeedRandom[1];
  With[{fib = RandomInfraFibration[CycleGraph[4], RandomSeeding -> None ]},
    {InfraFibrationQ[fib], IsomorphicGraphQ[InfraBaseSpace[fib], CycleGraph[4]], Length[InfraFibers[fib]]}],
  {True, True, 4},
  TestID -> "RandomInfraFibration-default"
]

VerificationTest[
  With[{fib = RandomInfraFibration[CycleGraph[5]]},
    {Head[fib], GraphQ[InfraTotalSpace[fib]], AssociationQ[InfraProjection[fib]]}],
  {InfraFiberedGraph, True, True},
  TestID -> "RandomInfraFibration-BasicOutput"
]

VerificationTest[
  VertexCount[InfraTotalSpace[RandomInfraFibration[CycleGraph[5], "VerticalVertices" -> 3]]],
  15,
  TestID -> "RandomInfraFibration-FiberSize"
]

VerificationTest[
  Sort[DeleteDuplicates[Values[InfraProjection[RandomInfraFibration[CycleGraph[5], "VerticalVertices" -> 3]]]]],
  Range[5],
  TestID -> "RandomInfraFibration-ProjectionSurjective"
]

VerificationTest[
  VertexCount /@ Values[InfraFibers[RandomInfraFibration[CycleGraph[5], "VerticalVertices" -> 3]]],
  {3, 3, 3, 3, 3},
  TestID -> "RandomInfraFibration-UniformFibers"
]

VerificationTest[
  SeedRandom[42];
  AllTrue[VertexCount /@ Values[InfraFibers[RandomInfraFibration[CycleGraph[5], "VerticalVertices" -> {1, 4}, RandomSeeding -> None ]]], Between[{1, 4}]],
  True,
  TestID -> "RandomInfraFibration-RandomFiberSizes"
]

VerificationTest[
  EdgeCount[InfraTotalSpace[RandomInfraFibration[CycleGraph[5], "VerticalVertices" -> 3, "VerticalEdges" -> 2]]] > 15,
  True,
  TestID -> "RandomInfraFibration-VerticalEdges"
]

VerificationTest[
  SeedRandom[3];
  Equal @@ (VertexCount /@ Values[InfraFibers[RandomInfraFibration[CycleGraph[5], "VerticalVertices" -> {1, 4}, "IsomorphicFibers" -> True, RandomSeeding -> None ]]]),
  True,
  TestID -> "RandomInfraFibration-IsomorphicFibers-SameSize"
]

VerificationTest[
  With[{fibers = Values[InfraFibers[RandomInfraFibration[CycleGraph[5], "VerticalVertices" -> 3, "VerticalEdges" -> 2, "IsomorphicFibers" -> True]]]},
    AllTrue[Rest[fibers], IsomorphicGraphQ[First[fibers], #] &]],
  True,
  TestID -> "RandomInfraFibration-IsomorphicFibers-IsomorphicGraphs"
]

VerificationTest[
  Trace[ RandomInfraFibration[ GridGraph[ { 3, 3 } ], "VerticalVertices" -> 2 ],
    HoldPattern[ GraphEmbedding[ ___ ] ], TraceInternal -> True ],
  { },
  TestID -> "RandomInfraFibration-structural-generation-has-no-embedding"
]

(* ===== InfraBaseSpace ===== *)

VerificationTest[
  IsomorphicGraphQ[InfraBaseSpace[RandomInfraFibration[CycleGraph[5], "VerticalVertices" -> 3]], CycleGraph[5]],
  True,
  TestID -> "InfraBaseSpace-CycleGraph"
]

VerificationTest[
  IsomorphicGraphQ[InfraBaseSpace[RandomInfraFibration[GridGraph[{3, 3}], "VerticalVertices" -> 2]], GridGraph[{3, 3}]],
  True,
  TestID -> "InfraBaseSpace-GridGraph"
]

VerificationTest[
  IsomorphicGraphQ[InfraBaseSpace[RandomInfraFibration[CompleteGraph[4], "VerticalVertices" -> 2]], CompleteGraph[4]],
  True,
  TestID -> "InfraBaseSpace-CompleteGraph"
]

(* ===== isomorphic fibers ===== *)

VerificationTest[
  InfraFiberBundleQ[RandomInfraFibration[CycleGraph[4], "VerticalVertices" -> 3, "VerticalEdges" -> 0]],
  True,
  TestID -> "InfraFiberBundleQ-UniformEmptyFibers"
]

VerificationTest[
  InfraFiberBundleQ[InfraFiberedGraph[Graph[{1, 2, 3, 4}, {UndirectedEdge[1, 2], UndirectedEdge[3, 4]}], <|1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b"|>]],
  True,
  TestID -> "InfraFiberBundleQ-IsomorphicEdgeFibers"
]

VerificationTest[
  InfraFiberBundleQ[InfraFiberedGraph[Graph[{1, 2, 3, 4}, {UndirectedEdge[1, 2]}], <|1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b"|>]],
  False,
  TestID -> "InfraFiberBundleQ-NonIsomorphicFibers"
]

VerificationTest[
  Equal @@ (VertexCount /@ Values[InfraFibers[InfraFiberedGraph[Graph[{1, 2, 3, 4}, {UndirectedEdge[1, 2]}], <|1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b"|>]]]),
  True,
  TestID -> "InfraFibers-SameVertexCountOnly"
]

(* ===== InfraFibrationQ: edge lifting ===== *)

VerificationTest[
  InfraFibrationQ[InfraFiberedGraph[
    Graph[{1, 2, 3, 4}, {UndirectedEdge[1, 3], UndirectedEdge[1, 4], UndirectedEdge[2, 3], UndirectedEdge[2, 4]}],
    <|1 -> "u", 2 -> "u", 3 -> "v", 4 -> "v"|>]],
  True,
  TestID -> "InfraFibrationQ-CompleteBipartiteFibers"
]

VerificationTest[
  InfraFibrationQ[InfraFiberedGraph[Graph[{1, 2, 3}, {UndirectedEdge[1, 3]}], <|1 -> "u", 2 -> "u", 3 -> "v"|>]],
  False,
  TestID -> "InfraFibrationQ-MissingLift"
]

VerificationTest[
  InfraFibrationQ[RandomInfraFibration[CycleGraph[4], "VerticalVertices" -> 2, "HorizontalEdgesDensity" -> 1]],
  True,
  TestID -> "InfraFibrationQ-DiagonalFibration"
]

(* two lifts of each base edge: a fibration, not a fiber bundle *)
VerificationTest[
  With[{fib = InfraFiberedGraph[
      Graph[{1, 2, 3, 4}, {UndirectedEdge[1, 3], UndirectedEdge[1, 4], UndirectedEdge[2, 3], UndirectedEdge[2, 4]}],
      <|1 -> "u", 2 -> "u", 3 -> "v", 4 -> "v"|>]},
    {InfraFibrationQ[fib], InfraFiberBundleQ[fib]}],
  {True, False},
  TestID -> "InfraFiberBundleQ-two-lifts"
]

(* ===== InfraFiberBundleQ: edgewise fiber products ===== *)

VerificationTest[
  With[{total = GraphProduct[PathGraph[{1, 2}], CompleteGraph[3], "Cartesian"]},
    InfraFiberBundleQ[InfraFiberedGraph[total, Last]]],
  True,
  TestID -> "InfraFiberBundleQ-ProductBundle-over-triangle"
]

VerificationTest[
  With[{verts = Flatten[Table[{i, j}, {i, 3}, {j, 2}], 1]},
    {edges = {UndirectedEdge[{1, 1}, {2, 1}], UndirectedEdge[{1, 2}, {2, 2}],
      UndirectedEdge[{2, 1}, {3, 1}], UndirectedEdge[{2, 2}, {3, 2}],
      UndirectedEdge[{3, 1}, {1, 2}], UndirectedEdge[{3, 2}, {1, 1}]}},
    InfraFiberBundleQ[InfraFiberedGraph[Graph[verts, edges], First]]],
  True,
  TestID -> "InfraFiberBundleQ-TwistedTriangle"
]

VerificationTest[
  With[{total = GraphProduct[CompleteGraph[3], CycleGraph[5], "Cartesian"]},
    InfraFiberBundleQ[InfraFiberedGraph[total, Last]]],
  True,
  TestID -> "InfraFiberBundleQ-ProductBundle"
]

VerificationTest[
  With[{verts = Flatten[Table[{i, j}, {i, 5}, {j, 2}], 1]},
    {edges = Join[
      Flatten @ Table[UndirectedEdge[{i, j}, {Mod[i, 5] + 1, j}], {i, 4}, {j, 2}],
      {UndirectedEdge[{5, 1}, {1, 2}], UndirectedEdge[{5, 2}, {1, 1}]}]},
    InfraFiberBundleQ[InfraFiberedGraph[Graph[verts, edges], First]]],
  True,
  TestID -> "InfraFiberBundleQ-MobiusBundle"
]

(* Nontrivial monodromy is compatible with edgewise local products. *)
VerificationTest[
  {InfraFiberBundleQ[InfraFiberedGraph[CycleGraph[8], i |-> Mod[i, 4, 1]]],
   InfraFiberBundleQ[InfraFiberedGraph[CycleGraph[6], i |-> Mod[i, 3, 1]]]},
  {True, True},
  TestID -> "InfraFiberBundleQ-double-covers"
]

(* ===== InfraBundleMorphismQ ===== *)

VerificationTest[
  SeedRandom[1];
  With[{fib = RandomInfraFibration[CycleGraph[4], RandomSeeding -> None ]},
    {InfraBundleMorphismQ[fib, fib, Identity],
     With[{vertices = VertexList[InfraTotalSpace[fib]]}, {map = AssociationThread[vertices, RandomChoice[vertices, Length[vertices]]]},
       {DuplicateFreeQ[Values[map]], InfraBundleMorphismQ[fib, fib, map]}]}],
  {True, {False, False}},
  TestID -> "InfraBundleMorphismQ-identity-and-a-random-non-injective-map"
]

VerificationTest[
  InfraBundleMorphismQ[InfraFiberedGraph[CycleGraph[8], i |-> Mod[i, 4, 1]], InfraFiberedGraph[CycleGraph[4], Identity], i |-> Mod[i, 4, 1]],
  True,
  TestID -> "InfraBundleMorphismQ-covering-onto-the-trivial-bundle"
]

VerificationTest[
  With[{fib = InfraFiberedGraph[CycleGraph[8], i |-> Mod[i, 4, 1]]},
    {InfraBundleMorphismQ[fib, fib, i |-> Mod[i + 2, 8, 1], p |-> Mod[p + 2, 4, 1]],
     InfraBundleMorphismQ[fib, fib, i |-> Mod[i + 2, 8, 1]]}],
  {True, False},
  TestID -> "InfraBundleMorphismQ-over-a-base-rotation"
]

VerificationTest[
  InfraBundleMorphismQ[InfraFiberedGraph[CycleGraph[8], i |-> Mod[i, 4, 1]], InfraFiberedGraph[CycleGraph[8], i |-> Mod[i, 4, 1]], i |-> Mod[i + 1, 8, 1], p |-> Mod[p + 1, 4, 1]],
  True,
  TestID -> "InfraBundleMorphismQ-deck-shift"
]

VerificationTest[
  With[ { total = Graph[ Range[ 6 ], { UndirectedEdge[ 1, 2 ], UndirectedEdge[ 2, 3 ], UndirectedEdge[ 4, 5 ], UndirectedEdge[ 5, 6 ],
        UndirectedEdge[ 1, 5 ], UndirectedEdge[ 2, 4 ], UndirectedEdge[ 3, 6 ] } ] },
    InfraFiberBundleQ[ InfraFiberedGraph[ total, AssociationThread[ Range[ 6 ], { "p", "p", "p", "q", "q", "q" } ] ] ] ],
  False,
  TestID -> "InfraFiberBundleQ-matching-must-preserve-fiber-adjacency"
]

VerificationTest[
  With[ { vertices = { { 1, "a" }, { 2, "b" }, { 3, "c" }, { 4, "d" } } },
    { projection = AssociationThread[ vertices, { { "p", 1 }, { "p", 1 }, { "q", 2 }, { "q", 2 } } ],
      total = Graph[ vertices, UndirectedEdge @@@ Partition[ vertices, 2, 1 ] ] },
    { fib = InfraFiberedGraph[ total, projection ] },
    { InfraProjection[ fib ] === projection,
      VertexList[ InfraFiber[ fib, { "p", 1 } ] ] === Take[ vertices, 2 ],
      VertexList[ InfraBaseSpace[ fib ] ] === { { "p", 1 }, { "q", 2 } },
      EdgeList[ InfraBaseSpace[ fib ] ] === { UndirectedEdge[ { "p", 1 }, { "q", 2 } ] } } ],
  { True, True, True, True },
  TestID -> "InfraFiberedGraph-literal-list-total-and-base-vertices"
]

VerificationTest[
  With[ { vertices = { Blank[ Integer ], Alternatives[ "left", "right" ], "end" } },
    { total = Graph[ vertices, UndirectedEdge @@@ Partition[ vertices, 2, 1 ] ],
      projection = AssociationThread[ vertices, { "p", "q", "q" } ] },
    { fib = InfraFiberedGraph[ total, projection ] },
    { InfraProjection[ fib ] === projection,
      VertexList[ InfraFiber[ fib, "p" ] ] === Take[ vertices, 1 ],
      InfraBundleMorphismQ[ fib, fib, AssociationThread[ vertices, vertices ] ] } ],
  { True, True, True },
  TestID -> "InfraFiberedGraph-patternlike-vertices-are-literal"
]

VerificationTest[
  With[ { total = PathGraph[ Range[ 3 ] ] },
    { missing = InfraFiberedGraph[ total, <| 1 -> "p", 2 -> "q" |> ],
      extra = InfraFiberedGraph[ total, <| 1 -> "p", 2 -> "q", 3 -> "r", 4 -> "s" |> ] },
    { Head @ InfraProjection[ missing ], Head @ InfraProjection[ extra ],
      Head @ InfraBaseSpace[ missing ], Head @ InfraFibrationQ[ missing ], Head @ InfraFiberBundleQ[ extra ] } ],
  { InfraProjection, InfraProjection, InfraBaseSpace, InfraFibrationQ, InfraFiberBundleQ },
  TestID -> "InfraFiberedGraph-malformed-projections-leave-predicates-unevaluated"
]

VerificationTest[
  With[ { directed = Graph[ { 1 -> 2 } ], weighted = Graph[ CycleGraph[ 3 ], EdgeWeight -> { 1, 2, 3 } ] },
    Map[ total |-> With[ { fib = InfraFiberedGraph[ total, Identity ] },
      { Head @ InfraTotalSpace[ fib ], Head @ InfraBaseSpace[ fib ], Head @ RandomInfraFibration[ total ] } ],
      { directed, weighted } ] ],
  { { InfraTotalSpace, InfraBaseSpace, RandomInfraFibration }, { InfraTotalSpace, InfraBaseSpace, RandomInfraFibration } },
  TestID -> "InfraFiberedGraph-directed-and-weighted-domain-is-unsupported"
]

VerificationTest[
  With[ { base = PathGraph[ Range[ 3 ] ] },
    { fib = RandomInfraFibration[ base, "VerticalVertices" -> 3, "VerticalEdges" -> 0,
        "HorizontalEdgesDensity" -> All ] },
    { EdgeCount @ InfraTotalSpace[ fib ], EdgeList @ InfraBaseSpace[ fib ] === EdgeList @ base,
      InfraFibrationQ[ fib ], InfraFiberBundleQ[ fib ] } ],
  { 18, True, True, False },
  TestID -> "RandomInfraFibration-complete-joins-preserve-requested-base"
]

VerificationTest[
  With[ { base = CycleGraph[ 4 ] },
    Head /@ { RandomInfraFibration[ base, "HorizontalEdgesRadius" -> 2 ],
      RandomInfraFibration[ base, "HorizontalEdgesDensity" -> 0 ],
      RandomInfraFibration[ base, "UnknownOption" -> True ],
      RandomInfraFibration[ base, "VerticalVertices" -> { 0, 2 } ],
      RandomInfraFibration[ base, "IsomorphicFibers" -> "Unknown" ] } ],
  ConstantArray[ RandomInfraFibration, 5 ],
  TestID -> "RandomInfraFibration-unsupported-options-remain-unevaluated"
]

VerificationTest[
  With[ { base = Graph[ { { "p", 1 }, { "q", 2 }, { "isolated", 3 } },
        { UndirectedEdge[ { "p", 1 }, { "q", 2 } ] } ] },
    { fib = RandomInfraFibration[ base, "VerticalVertices" -> 2, "HorizontalEdgesDensity" -> All ] },
    { VertexList @ InfraBaseSpace[ fib ] === VertexList @ base,
      EdgeList @ InfraBaseSpace[ fib ] === EdgeList @ base,
      VertexCount @ InfraFiber[ fib, { "isolated", 3 } ], InfraFibrationQ[ fib ] } ],
  { True, True, 2, True },
  TestID -> "RandomInfraFibration-preserves-isolated-and-list-base-vertices"
]

VerificationTest[
  With[ { fib = RandomInfraFibration[ Graph[ { }, { } ] ] },
    { VertexCount @ InfraTotalSpace[ fib ], InfraProjection[ fib ], VertexCount @ InfraBaseSpace[ fib ],
      InfraFibrationQ[ fib ], InfraFiberBundleQ[ fib ] } ],
  { 0, <| |>, 0, True, True },
  TestID -> "RandomInfraFibration-empty-base"
]

VerificationTest[
  SeedRandom[ 17 ];
  With[ { expected = Table[ RandomInteger[ { 3, 5 } ], { 12 } ] },
    SeedRandom[ 17 ];
    With[ { fib = RandomInfraFibration[ Graph[ Range[ 12 ], { } ], "VerticalVertices" -> { 3, 5 }, RandomSeeding -> None ] },
      VertexCount /@ Values @ InfraFibers[ fib ] === expected ] ],
  True,
  TestID -> "RandomInfraFibration-integer-range-is-discrete-uniform"
]

VerificationTest[
  With[ { fib = RandomInfraFibration[ CycleGraph[ 4 ], "VerticalVertices" -> 2, "VerticalVertices" -> 3 ] },
    VertexCount @ InfraTotalSpace[ fib ] ],
  8,
  TestID -> "RandomInfraFibration-first-duplicate-option"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ CycleGraph[ 6 ], point |-> Mod[ point, 3, 1 ] ] },
    { InfraFibrationQ[ { } ], InfraFiberBundleQ[ { } ], InfraFibrationQ[ { fib } ], InfraFiberBundleQ[ { fib } ] } ],
  { False, False, True, True },
  TestID -> "InfraFiberedGraph-counted-predicate-shapes"
]

VerificationTest[
  With[ { base = CycleGraph[ 3 ] },
    { fib = RandomInfraFibration[ base, { "VerticalVertices" -> 2, "VerticalVertices" -> 3 } ] },
    { VertexCount @ InfraTotalSpace[ fib ], IsomorphicGraphQ[ InfraBaseSpace[ fib ], base ] } ],
  { 6, True },
  TestID -> "RandomInfraFibration-standard-option-list-and-first-duplicate"
]

EndTestSection[ ]
