BeginTestSection[ "InfraSection" ]

VerificationTest[
  InfraSection[ x ],
  InfraSection[ x ],
  TestID -> "InfraSection-head-is-inert"
]

VerificationTest[
  Head /@ { InfraSectionQ[ foo, InfraSection[ <| |> ] ], InfraContinuousSectionQ[ foo, InfraSection[ <| |> ] ],
    RandomInfraSection[ foo ], FindInfraSection[ foo, All ] },
  { InfraSectionQ, InfraContinuousSectionQ, RandomInfraSection, FindInfraSection },
  TestID -> "InfraSection-not-a-fibration-stays-unevaluated"
]

VerificationTest[
  With[ { fib = InfraFibration[ CycleGraph[ 8 ], i |-> Mod[ i, 4, 1 ] ] },
    { InfraSectionQ[ fib, InfraSection[ <| 1 -> 5, 2 -> 6 |> ] ],
      InfraSectionQ[ fib, InfraSection[ <| 1 -> 2 |> ] ], InfraSectionQ[ fib, InfraSection[ <| 1 -> 9 |> ] ] } ],
  { True, False, False },
  TestID -> "InfraSectionQ-value-over-its-key"
]

VerificationTest[
  With[ { fib = InfraFibration[ CycleGraph[ 8 ], i |-> Mod[ i, 4, 1 ] ] },
    InfraContinuousSectionQ[ fib, # ] & /@ {
      InfraSection[ <| 1 -> 1, 2 -> 2, 3 -> 3 |> ], InfraSection[ <| 1 -> 1, 2 -> 6 |> ],
      InfraSection[ <| 1 -> 1, 3 -> 7 |> ], InfraSection[ <| 1 -> 2 |> ], InfraSection[ <| |> ] } ],
  { True, False, True, False, True },
  TestID -> "InfraContinuousSectionQ-partial-domain"
]

VerificationTest[
  With[ { fib = InfraFibration[ PathGraph[ { 1, 2 } ], Identity ],
          good = InfraSection[ <| 1 -> 1 |> ], bad = InfraSection[ <| 1 -> 2 |> ] },
    { InfraSectionQ[ fib, { good, InfraSection[ <| |> ] } ], InfraSectionQ[ fib, { good, bad } ],
      InfraContinuousSectionQ[ fib, { good } ], InfraSectionQ[ fib, { } ], InfraContinuousSectionQ[ fib, { } ],
      InfraSectionQ[ fib, { unknown } ] === InfraSectionQ[ fib, unknown ] } ],
  { True, False, True, False, False, True },
  TestID -> "InfraSection-predicate-collections-are-nonempty-conjunctions"
]

VerificationTest[
  With[ { fib = InfraFibration[ Graph[ Range[ 4 ], { UndirectedEdge[1, 3], UndirectedEdge[2, 4] } ], <| 1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b" |> ] },
    { section = RandomInfraSection[ fib, "NextVertexFunction" -> Identity ] },
    { Head @ section, InfraSectionQ[ fib, section ], Keys @ First @ section,
      RandomInfraSection[ fib, Automatic, "NextVertexFunction" -> Identity ] === section } ],
  { InfraSection, True, { "a", "b" }, True },
  TestID -> "RandomInfraSection-default-and-Automatic-return-one-object"
]

VerificationTest[
  With[ { fib = InfraFibration[ Graph[ Range[ 4 ], { UndirectedEdge[1, 3], UndirectedEdge[2, 4] } ], <| 1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b" |> ] },
    { sections = RandomInfraSection[ fib, All ] },
    { Length @ sections, DuplicateFreeQ @ sections, InfraSectionQ[ fib, sections ],
      Count[ InfraContinuousSectionQ[ fib, # ] & /@ sections, True ] } ],
  { 4, True, True, 2 },
  TestID -> "RandomInfraSection-default-enumerates-set-theoretic-class"
]

VerificationTest[
  With[ { fib = InfraFibration[ Graph[ Range[ 4 ], { UndirectedEdge[1, 3], UndirectedEdge[2, 4] } ], <| 1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b" |> ] },
    { sections = RandomInfraSection[ fib, All, Properties -> { "Continuous" } ] },
    { Length @ sections, InfraContinuousSectionQ[ fib, sections ],
      sections === FindInfraSection[ fib, All ] } ],
  { 2, True, True },
  TestID -> "RandomInfraSection-continuous-class-and-legacy-shim"
]

VerificationTest[
  With[ { fib = InfraFibration[ Graph[ Range[ 4 ], { UndirectedEdge[ 1, 3 ], UndirectedEdge[ 2, 4 ] } ],
      <| 1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b" |> ] },
    { RandomInfraSection[ fib, All, { Properties -> { "Continuous" } } ],
      RandomInfraSection[ fib, All, { { Properties -> { "Continuous" } }, { { "NextVertexFunction" -> Identity } } } ] } ],
  ConstantArray[ { InfraSection[ <| "a" -> 1, "b" -> 3 |> ], InfraSection[ <| "a" -> 2, "b" -> 4 |> ] }, 2 ],
  TestID -> "RandomInfraSection-explicit-count-accepts-option-lists"
]

VerificationTest[
  With[ { fib = InfraFibration[ Graph[ Range[ 4 ], { UndirectedEdge[ 1, 3 ], UndirectedEdge[ 2, 4 ] } ],
      <| 1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b" |> ] },
    Length /@ { RandomInfraSection[ fib, All, { Properties -> { }, Properties -> { "Continuous" } } ],
      RandomInfraSection[ fib, All, { Properties -> { "Continuous" }, Properties -> { } } ] } ],
  { 4, 2 },
  TestID -> "RandomInfraSection-option-list-uses-first-duplicate"
]

VerificationTest[
  With[ { fib = InfraFibration[ Graph[ Range[ 4 ], { UndirectedEdge[1, 3], UndirectedEdge[2, 4] } ], <| 1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b" |> ] },
    Length /@ { RandomInfraSection[ fib, 2, "NextVertexFunction" -> Identity ],
      RandomInfraSection[ fib, UpTo[ 6 ], "NextVertexFunction" -> Identity ], RandomInfraSection[ fib, 5 ],
      RandomInfraSection[ fib, 0 ], RandomInfraSection[ fib, UpTo[ 0 ] ],
      RandomInfraSection[ fib, 3, Properties -> { "Continuous" } ] } ],
  { 2, 4, 0, 0, 0, 0 },
  TestID -> "RandomInfraSection-count-shapes-and-shortage"
]

VerificationTest[
  With[ { fib = InfraFibration[ Graph[ Range[ 6 ], { UndirectedEdge[1, 3], UndirectedEdge[2, 4], UndirectedEdge[3, 5], UndirectedEdge[4, 6] } ],
            <| 1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b", 5 -> "c", 6 -> "c" |> ] },
    { sections = RandomInfraSection[ fib, { "a", "c" }, All, Properties -> { "Continuous" } ] },
    { Length @ sections, InfraContinuousSectionQ[ fib, sections ],
      AllTrue[ sections, Keys @ First @ # === { "a", "c" } & ] } ],
  { 4, True, True },
  TestID -> "RandomInfraSection-domain-means-induced-base-subgraph"
]

VerificationTest[
  With[ { fib = InfraFibration[ Graph[ Range[ 4 ], { UndirectedEdge[1, 3], UndirectedEdge[2, 4] } ], <| 1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b" |> ],
          seed = InfraSection[ <| "b" -> 4 |> ] },
    { arbitrary = RandomInfraSection[ fib, seed, All ],
      continuous = RandomInfraSection[ fib, seed, Properties -> { "Continuous" }, "NextVertexFunction" -> Identity ] },
    { Length @ arbitrary, AllTrue[ arbitrary, Lookup[ First @ #, "b" ] === 4 & ],
      continuous, InfraContinuousSectionQ[ fib, continuous ] } ],
  { 2, True, InfraSection[ <| "a" -> 2, "b" -> 4 |> ], True },
  TestID -> "RandomInfraSection-seed-fixed-values-and-uniform-property-default"
]

VerificationTest[
  With[ { fib = InfraFibration[ Graph[ Range[ 4 ], { UndirectedEdge[1, 3], UndirectedEdge[2, 4] } ], <| 1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b" |> ],
          seed = InfraSection[ <| "a" -> 1, "b" -> 4 |> ] },
    { InfraSectionQ[ fib, seed ], InfraContinuousSectionQ[ fib, seed ],
      RandomInfraSection[ fib, seed, "NextVertexFunction" -> Identity ],
      RandomInfraSection[ fib, seed, Properties -> { "Continuous" } ] } ],
  { True, False, InfraSection[ <| "a" -> 1, "b" -> 4 |> ], { } },
  TestID -> "RandomInfraSection-discontinuous-valid-seed-has-no-continuous-extension"
]

VerificationTest[
  With[ { fib = InfraFibration[ Graph[ Range[ 6 ], { UndirectedEdge[1, 3], UndirectedEdge[2, 4], UndirectedEdge[3, 5], UndirectedEdge[4, 6] } ],
            <| 1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b", 5 -> "c", 6 -> "c" |> ],
          seed = InfraSection[ <| "a" -> 1, "c" -> 6 |> ] },
    { InfraContinuousSectionQ[ fib, seed ],
      RandomInfraSection[ fib, seed, Properties -> { "Continuous" } ],
      Length @ RandomInfraSection[ fib, seed, All ] } ],
  { True, { }, 2 },
  TestID -> "RandomInfraSection-nonextendible-continuous-seed"
]

VerificationTest[
  With[ { fib = InfraFibration[ Graph[ Range[ 6 ], { UndirectedEdge[1, 3], UndirectedEdge[2, 4] } ],
            <| 1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b", 5 -> "c", 6 -> "c" |> ] },
    { sections = RandomInfraSection[ fib, InfraSection[ <| "c" -> 6 |> ], All, Properties -> { "Continuous" } ] },
    { Length @ sections, InfraContinuousSectionQ[ fib, sections ],
      AllTrue[ sections, Keys @ First @ # === { "a", "b", "c" } && Lookup[ First @ #, "c" ] === 6 & ] } ],
  { 2, True, True },
  TestID -> "RandomInfraSection-extends-across-disconnected-base-components"
]

VerificationTest[
  With[ { fib = InfraFibration[ Graph[ { }, { } ], <| |> ], empty = InfraSection[ <| |> ] },
    { RandomInfraSection[ fib ], RandomInfraSection[ fib, All ],
      RandomInfraSection[ fib, All, Properties -> { "Continuous" } ], RandomInfraSection[ fib, 2 ],
      InfraSectionQ[ fib, empty ], InfraContinuousSectionQ[ fib, empty ] } ],
  { InfraSection[ <| |> ], { InfraSection[ <| |> ] }, { InfraSection[ <| |> ] }, { }, True, True },
  TestID -> "RandomInfraSection-empty-base-has-one-empty-section"
]

VerificationTest[
  With[ { fib = InfraFibration[ PathGraph[ { 1, 2 } ], Identity ] },
    { RandomInfraSection[ fib, { } ], RandomInfraSection[ fib, { }, All ],
      RandomInfraSection[ fib, { }, Properties -> { "Continuous" } ] } ],
  { InfraSection[ <| |> ], { InfraSection[ <| |> ] }, InfraSection[ <| |> ] },
  TestID -> "RandomInfraSection-empty-domain-is-a-section-not-failure"
]

VerificationTest[
  With[ { left = { "left", 1 }, right = { "right", 2 } },
    { vertices = { { left, 1 }, { left, 2 }, { right, 1 }, { right, 2 } } },
    { fib = InfraFibration[ Graph[ vertices, { UndirectedEdge[vertices[[ 1 ]], vertices[[ 3 ]]], UndirectedEdge[vertices[[ 2 ]], vertices[[ 4 ]]] } ],
        AssociationThread[ vertices, { left, left, right, right } ] ] },
    { seed = InfraSection @ AssociationThread[ { left }, { vertices[[ 1 ]] } ] },
    { section = RandomInfraSection[ fib, seed, Properties -> { "Continuous" }, "NextVertexFunction" -> First ] },
    { InfraContinuousSectionQ[ fib, section ], Keys @ First @ section,
      Lookup[ First @ section, Key @ right ] === vertices[[ 3 ]], Length @ RandomInfraSection[ fib, { left }, All ] } ],
  { True, { { "left", 1 }, { "right", 2 } }, True, 2 },
  TestID -> "InfraSection-literal-nested-list-vertices-and-base-labels"
]

VerificationTest[
  With[ { vertices = { Blank[ ], Alternatives[ "x", "y" ], "one", "two" },
          left = Blank[ Integer ], right = Alternatives[ "left", "right" ] },
    { fib = InfraFibration[ Graph[ vertices, { UndirectedEdge[vertices[[ 1 ]], vertices[[ 3 ]]], UndirectedEdge[vertices[[ 2 ]], vertices[[ 4 ]]] } ],
        AssociationThread[ vertices, { left, left, right, right } ] ] },
    { sections = RandomInfraSection[ fib, All, Properties -> { "Continuous" } ] },
    { Length @ sections, InfraContinuousSectionQ[ fib, sections ],
      InfraSectionQ[ fib, InfraSection @ AssociationThread[ { left }, { "absent" } ] ],
      InfraContinuousSectionQ[ fib, RandomInfraSection[ fib, Properties -> { "Continuous" }, "NextVertexFunction" -> First ] ] } ],
  { 2, True, False, True },
  TestID -> "InfraSection-patternlike-labels-are-literal"
]

VerificationTest[
  With[ { fib = InfraFibration[ Graph[ Range[ 4 ], { } ], <| 1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b" |> ] },
    Values @ First @ # & /@ RandomInfraSection[ fib, All, "NextVertexFunction" -> Reverse ] ],
  { { 2, 4 }, { 2, 3 }, { 1, 4 }, { 1, 3 } },
  TestID -> "RandomInfraSection-callback-orders-each-fiber"
]

VerificationTest[
  With[ { fib = InfraFibration[ Graph[ Range[ 4 ], { } ], <| 1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b" |> ] },
    { RandomInfraSection[ fib, All, "NextVertexFunction" -> ( Take[ #, UpTo[ 1 ] ] & ) ],
      RandomInfraSection[ fib, All, "NextVertexFunction" -> ( { } & ) ] } ],
  { { InfraSection[ <| "a" -> 1, "b" -> 3 |> ] }, { } },
  TestID -> "RandomInfraSection-pruning-retains-only-the-selected-tree"
]

VerificationTest[
  With[ { fib = InfraFibration[ Graph[ Range[ 4 ], { } ], <| 1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b" |> ] },
    BlockRandom[
      { Length @ RandomInfraSection[ fib, UpTo[ 2 ], "NextVertexFunction" -> RandomChoice ],
        RandomInfraSection[ fib, 2, "NextVertexFunction" -> RandomChoice ],
        Head @ RandomInfraSection[ fib, All, "NextVertexFunction" -> RandomChoice ] }, RandomSeeding -> 7 ] ],
  { 1, { }, RandomInfraSection },
  TestID -> "RandomInfraSection-RandomChoice-is-one-route-and-refuses-All"
]

VerificationTest[
  With[ { fib = InfraFibration[ Graph[ Range[ 8 ], { } ], i |-> Ceiling[ i / 2 ] ] },
    BlockRandom[ RandomInfraSection[ fib ], RandomSeeding -> 37 ] ===
      BlockRandom[ RandomInfraSection[ fib ], RandomSeeding -> 37 ] ],
  True,
  TestID -> "RandomInfraSection-ambient-seed-reproduces-selection"
]

VerificationTest[
  With[ { fib = InfraFibration[ Graph[ Range[ 8 ], { } ], i |-> Ceiling[ i / 2 ] ] },
    BlockRandom[
      With[ { state = $RandomGeneratorState },
        RandomInfraSection[ fib ]; $RandomGeneratorState =!= state ], RandomSeeding -> 37 ] ],
  True,
  TestID -> "RandomInfraSection-default-advances-ambient-random-state"
]

VerificationTest[
  With[ { fib = InfraFibration[ Graph[ Range[ 6 ], { } ], i |-> Ceiling[ i / 2 ] ] },
    BlockRandom[
      With[ { state = $RandomGeneratorState },
        RandomInfraSection[ fib, All ];
        RandomInfraSection[ fib, "NextVertexFunction" -> Identity ];
        RandomInfraSection[ fib, 0 ];
        FindInfraSection[ fib, UpTo[ 2 ] ];
        $RandomGeneratorState === state ], RandomSeeding -> 37 ] ],
  True,
  TestID -> "RandomInfraSection-enumeration-Identity-zero-and-legacy-do-not-draw"
]

VerificationTest[
  Module[ { visits = 0 },
    With[ { fib = InfraFibration[ Graph[ Range[ 48 ], { } ], i |-> Ceiling[ i / 2 ] ] },
      { section = RandomInfraSection[ fib, "NextVertexFunction" -> ( visits++; # & ) ] },
      InfraSectionQ[ fib, section ] && Length @ First @ section === 24 && visits <= 48 ] ],
  True,
  TestID -> "RandomInfraSection-bounded-selection-does-not-enumerate-exponential-class"
]

VerificationTest[
  With[ { fib = InfraFibration[ PathGraph[ { 1, 2 } ], Identity ] },
    Head /@ { RandomInfraSection[ fib, -1 ], Quiet[ RandomInfraSection[ fib, UpTo[ -1 ] ], UpTo::innf ],
      RandomInfraSection[ fib, Properties -> { "Smooth" } ], RandomInfraSection[ fib, "Seed" -> 1 ],
      RandomInfraSection[ fib, "NextVertexFunction" -> 17 ], RandomInfraSection[ fib, { 3 } ],
      RandomInfraSection[ fib, InfraSection[ <| 1 -> 2 |> ] ], RandomInfraSection[ fib, InfraSection[ { 1, 2 } ] ] } ],
  ConstantArray[ RandomInfraSection, 8 ],
  TestID -> "RandomInfraSection-unsupported-options-count-domain-and-seed-stay-unevaluated"
]

VerificationTest[
  With[ { fib = InfraFibration[ Graph[ Range[ 4 ], { } ], <| 1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b" |> ] },
    Head /@ { RandomInfraSection[ fib, "NextVertexFunction" -> ( { 99 } & ) ],
      RandomInfraSection[ fib, "NextVertexFunction" -> ( { First @ #, First @ # } & ) ],
      RandomInfraSection[ fib, "NextVertexFunction" -> unknownSelector ] } ],
  ConstantArray[ RandomInfraSection, 3 ],
  TestID -> "RandomInfraSection-invalid-callback-results-stay-unevaluated"
]

VerificationTest[
  With[ { fib = InfraFibration[ Graph[ Range[ 4 ], { UndirectedEdge[1, 3], UndirectedEdge[1, 4], UndirectedEdge[2, 3], UndirectedEdge[2, 4] } ],
            <| 1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b" |> ], connection = InfraConnection[ { UndirectedEdge[1, 3], UndirectedEdge[2, 4] } ],
          parallel = InfraSection[ <| "a" -> 1, "b" -> 3 |> ], transverse = InfraSection[ <| "a" -> 1, "b" -> 4 |> ] },
    { InfraContinuousSectionQ[ fib, transverse ], InfraParallelSectionQ[ fib, connection, transverse ],
      InfraParallelSectionQ[ fib, connection, parallel ], InfraParallelSectionQ[ fib, connection, InfraSection[ <| "a" -> 1 |> ] ],
      InfraParallelSectionQ[ fib, connection, { parallel, InfraSection[ <| |> ] } ], InfraParallelSectionQ[ fib, connection, { } ] } ],
  { True, False, True, True, True, False },
  TestID -> "InfraParallelSectionQ-differs-from-ambient-continuity"
]

VerificationTest[
  With[ { fib = InfraFibration[ Graph[ { }, { } ], <| |> ] },
    InfraParallelSectionQ[ fib, InfraConnection[ { } ], InfraSection[ <| |> ] ] ],
  True,
  TestID -> "InfraParallelSectionQ-empty-base-empty-section"
]

VerificationTest[
  With[ { fib = InfraFibration[ PathGraph[ { 1, 2 } ], Identity ] },
    Head @ InfraParallelSectionQ[ fib, InfraConnection[ { } ], InfraSection[ <| 1 -> 1, 2 -> 2 |> ] ] ],
  InfraParallelSectionQ,
  TestID -> "InfraParallelSectionQ-requires-valid-complete-connection"
]

VerificationTest[
  With[ { fib = InfraFibration[ GraphProduct[ CompleteGraph[ 3 ], CycleGraph[ 4 ], "Cartesian" ], Last ] },
    { sections = FindInfraSection[ fib, All ] },
    { Length @ sections, InfraContinuousSectionQ[ fib, sections ],
      Sort[ CountDistinct[ First /@ Values @ First @ # ] & /@ sections ] } ],
  { 3, True, { 1, 1, 1 } },
  TestID -> "FindInfraSection-trivial-bundle-constant-sections"
]

VerificationTest[
  With[ { fib = InfraFibration[ GraphProduct[ CompleteGraph[ 3 ], CycleGraph[ 4 ], "Cartesian" ], Last ] },
    Length /@ { FindInfraSection[ fib, 2 ], FindInfraSection[ fib, UpTo[ 2 ] ],
      FindInfraSection[ fib, UpTo[ 5 ] ], FindInfraSection[ fib, 4 ] } ],
  { 2, 2, 3, 0 },
  TestID -> "FindInfraSection-retains-count-and-shortage-shapes"
]

VerificationTest[
  With[ { fib = InfraFibration[ CycleGraph[ 8 ], i |-> Mod[ i, 4, 1 ] ] },
    { RandomInfraSection[ fib, Properties -> { "Continuous" } ], FindInfraSection[ fib, All ] } ],
  { { }, { } },
  TestID -> "InfraSection-connected-double-cover-has-no-continuous-section"
]

EndTestSection[ ]
