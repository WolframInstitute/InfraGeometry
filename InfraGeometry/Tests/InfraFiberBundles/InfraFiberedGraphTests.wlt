BeginTestSection[ "InfraFiberedGraph" ]

VerificationTest[
  { InfraFiberedGraph[ total, projection ], InfraFibration[ total, projection ] },
  { InfraFiberedGraph[ total, projection ], InfraFibration[ total, projection ] },
  TestID -> "InfraFiberedGraph-both-description-heads-are-inert"
]

VerificationTest[
  With[ { total = CycleGraph[ 6 ], projection = point |-> Mod[ point, 3, 1 ] },
    { modern = InfraFiberedGraph[ total, projection ], legacy = InfraFibration[ total, projection ] },
    { InfraTotalSpace[ modern ] === total, InfraProjection[ modern ] === InfraProjection[ legacy ],
      InfraBaseSpace[ modern ] === InfraBaseSpace[ legacy ],
      InfraTotalGraph[ modern ] === InfraTotalSpace[ modern ],
      InfraFibrationAssociation[ modern ] === InfraProjection[ modern ],
      InfraBaseGraph[ modern ] === InfraBaseSpace[ modern ], InfraFiberedGraphQ[ { modern, legacy } ] } ],
  ConstantArray[ True, 7 ],
  TestID -> "InfraFiberedGraph-canonical-and-legacy-readers-agree"
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
      InfraFlatConnectionQ[ fib, InfraConnection[ EdgeList @ InfraTotalSpace[ fib ] ] ] } ],
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
      Head @ InfraEdgeLiftMultiplicity[ extra ], Head @ InfraFibrationAssociation[ missing ] } ],
  { InfraProjection, InfraBaseSpace, InfraFiberedGraphQ, InfraEqualFiberSizesQ,
    InfraEdgeLiftMultiplicity, InfraFibrationAssociation },
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
    With[ { fib = RandomInfraFiberedGraph[ Graph[ Range[ 15 ], { } ], "VerticalVertexCount" -> 7 ] },
      VertexCount /@ Values @ InfraFibers[ fib ] === expected ] ],
  True,
  TestID -> "RandomInfraFiberedGraph-scalar-vertex-count-is-uniform-positive-upper-bound"
]

VerificationTest[
  SeedRandom[ 42 ];
  With[ { expected = Table[ RandomInteger[ { 5, 7 } ], { 15 } ] },
    SeedRandom[ 42 ];
    With[ { fib = RandomInfraFiberedGraph[ Graph[ Range[ 15 ], { } ], "VerticalVertexCount" -> { 5, 7 } ] },
      VertexCount /@ Values @ InfraFibers[ fib ] === expected ] ],
  True,
  TestID -> "RandomInfraFiberedGraph-range-vertex-count-is-inclusive-discrete-uniform"
]

VerificationTest[
  SeedRandom[ 2 ];
  With[ { fib = RandomInfraFiberedGraph[ CycleGraph[ 5 ], "VerticalVertexCount" -> { 3 }, "VerticalEdgeCount" -> 99 ] },
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
      "VerticalVertexCount" -> { 2, 5 }, "VerticalEdgeCount" -> 4 ] },
    { InfraEqualFiberSizesQ[ fib ], AllTrue[ VertexCount /@ Values @ InfraFibers[ fib ], Between[ { 2, 5 } ] ] } ],
  { True, True },
  TestID -> "RandomInfraFiberedGraph-equal-fiber-sizes-share-one-draw"
]

VerificationTest[
  SeedRandom[ 4 ];
  With[ { fib = RandomInfraFiberedGraph[ CycleGraph[ 5 ], Properties -> { "IsomorphicFibers" },
      "VerticalVertexCount" -> { 3, 5 }, "VerticalEdgeCount" -> { 1, 3 } ] },
    { InfraEqualFiberSizesQ[ fib ], InfraIsomorphicFibersQ[ fib ] } ],
  { True, True },
  TestID -> "RandomInfraFiberedGraph-isomorphic-fibers-share-a-template"
]

VerificationTest[
  SeedRandom[ 13 ];
  With[ { first = RandomInfraFiberedGraph[ CycleGraph[ 4 ],
      Properties -> { "IsomorphicFibers", "Fibration" }, "VerticalVertexCount" -> { 3, 4 } ] },
    SeedRandom[ 13 ];
    first === RandomInfraFiberedGraph[ CycleGraph[ 4 ],
      Properties -> { "Fibration", "IsomorphicFibers", "Fibration" }, "VerticalVertexCount" -> { 3, 4 } ] ],
  True,
  TestID -> "RandomInfraFiberedGraph-properties-are-an-order-independent-conjunction"
]

VerificationTest[
  SeedRandom[ 6 ];
  With[ { fib = RandomInfraFiberedGraph[ PathGraph[ { "p", "q" } ], Properties -> { "Fibration" },
      "VerticalVertexCount" -> { 3 }, "HorizontalEdgeCount" -> { 4 } ] },
    { InfraFibrationQ[ fib ], EdgeCount @ InfraTotalSpace[ fib ], VertexCount @ InfraBaseSpace[ fib ] } ],
  { True, 4, 2 },
  TestID -> "RandomInfraFiberedGraph-fibration-construction-covers-every-endpoint"
]

VerificationTest[
  SeedRandom[ 27 ];
  With[ { samples = Table[
      RandomInfraFiberedGraph[ PathGraph[ { 1, 2 } ], Properties -> { "Fibration" },
        "VerticalVertexCount" -> { 3 }, "HorizontalEdgeCount" -> { 4 } ], { 60 } ] },
    { And @@ ( InfraFibrationQ /@ samples ), AnyTrue[ samples, RandomInfraConnection[ # ] === { } & ] } ],
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
    { fib = RandomInfraFiberedGraph[ base, Properties -> { "UniqueEdgeLifting" }, "VerticalVertexCount" -> { 2, 5 } ] },
    { counts = VertexCount /@ Values @ InfraFibers[ fib ] },
    { InfraUniqueEdgeLiftingQ[ fib ], counts[[ 1 ]] == counts[[ 2 ]], counts[[ 3 ]] == counts[[ 4 ]],
      AllTrue[ counts, Between[ { 2, 5 } ] ] } ],
  { True, True, True, True },
  TestID -> "RandomInfraFiberedGraph-unique-lifting-couples-sizes-by-base-component"
]

VerificationTest[
  SeedRandom[ 18 ];
  With[ { first = RandomInfraFiberedGraph[ CycleGraph[ 3 ], Properties -> { "UniqueEdgeLifting" },
      "VerticalVertexCount" -> { 2, 4 } ] },
    SeedRandom[ 18 ];
    first === RandomInfraFiberedGraph[ CycleGraph[ 3 ], Properties -> { "AtMostOneEdgeLift", "Fibration" },
      "VerticalVertexCount" -> { 2, 4 } ] ],
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
      "VerticalVertexCount" -> { 4 }, "VerticalEdgeCount" -> { 3 } ], { 12 } ],
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
      "VerticalVertexCount" -> { 3, 4 }, "HorizontalEdgeCount" -> { 4, 6 } ] },
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
    "VerticalVertexCount" -> { 2, 4 }, "HorizontalEdgeCount" -> 4 ],
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
  With[ { first = RandomInfraFiberedGraph[ CycleGraph[ 4 ], "VerticalVertexCount" -> { 2, 4 }, "VerticalEdgeCount" -> 3 ] },
    SeedRandom[ 77 ];
    first === RandomInfraFiberedGraph[ CycleGraph[ 4 ], "VerticalVertexCount" -> { 2, 4 }, "VerticalEdgeCount" -> 3 ] ],
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

EndTestSection[ ]
