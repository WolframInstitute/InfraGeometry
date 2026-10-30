BeginTestSection["InfraFiberedGraph"]

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

EndTestSection[]
