BeginTestSection["InfraFibration"]

(* Translated from InfraGaugeTheory Tests/FiberedGraph.wlt at e5dc83b *)

(* ===== the head and the primitives ===== *)

VerificationTest[
  InfraFibration[x, y],
  InfraFibration[x, y],
  TestID -> "InfraFibration-head-is-inert"
]

VerificationTest[
  With[{fib = InfraFibration[CycleGraph[8], i |-> Mod[i, 4, 1]]},
    {VertexCount[InfraTotalGraph[fib]], InfraFibrationAssociation[fib] === AssociationMap[Mod[#, 4, 1] &, Range[8]]}],
  {8, True},
  TestID -> "InfraFibration-projection-as-function"
]

VerificationTest[
  With[{fib = InfraFibration[CycleGraph[8], i |-> Mod[i, 4, 1]]},
    {EdgeList[InfraFiber[fib, 1]], Sort[VertexList[InfraFiber[fib, 1]]], Keys[InfraFibers[fib]], VertexCount /@ Values[InfraFibers[fib]]}],
  {{}, {1, 5}, {1, 2, 3, 4}, {2, 2, 2, 2}},
  TestID -> "InfraFiber-preimage-of-a-base-vertex"
]

VerificationTest[
  {InfraFibrationQ[foo], InfraFiberBundleQ[foo], InfraBaseGraph[foo]},
  {InfraFibrationQ[foo], InfraFiberBundleQ[foo], InfraBaseGraph[foo]},
  TestID -> "InfraFibrationQ-not-a-fibration-stays-unevaluated"
]

(* ===== RandomInfraFibration ===== *)

VerificationTest[
  SeedRandom[1];
  With[{fib = RandomInfraFibration[CycleGraph[4], RandomSeeding -> None ]},
    {InfraFibrationQ[fib], IsomorphicGraphQ[InfraBaseGraph[fib], CycleGraph[4]], Length[InfraFibers[fib]]}],
  {True, True, 4},
  TestID -> "RandomInfraFibration-default"
]

VerificationTest[
  With[{fib = RandomInfraFibration[CycleGraph[5]]},
    {Head[fib], GraphQ[InfraTotalGraph[fib]], AssociationQ[InfraFibrationAssociation[fib]]}],
  {InfraFibration, True, True},
  TestID -> "RandomInfraFibration-BasicOutput"
]

VerificationTest[
  VertexCount[InfraTotalGraph[RandomInfraFibration[CycleGraph[5], "VerticalVertices" -> 3]]],
  15,
  TestID -> "RandomInfraFibration-FiberSize"
]

VerificationTest[
  Sort[DeleteDuplicates[Values[InfraFibrationAssociation[RandomInfraFibration[CycleGraph[5], "VerticalVertices" -> 3]]]]],
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
  EdgeCount[InfraTotalGraph[RandomInfraFibration[CycleGraph[5], "VerticalVertices" -> 3, "VerticalEdges" -> 2]]] > 15,
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

(* ===== InfraBaseGraph ===== *)

VerificationTest[
  IsomorphicGraphQ[InfraBaseGraph[RandomInfraFibration[CycleGraph[5], "VerticalVertices" -> 3]], CycleGraph[5]],
  True,
  TestID -> "InfraBaseGraph-CycleGraph"
]

VerificationTest[
  IsomorphicGraphQ[InfraBaseGraph[RandomInfraFibration[GridGraph[{3, 3}], "VerticalVertices" -> 2]], GridGraph[{3, 3}]],
  True,
  TestID -> "InfraBaseGraph-GridGraph"
]

VerificationTest[
  IsomorphicGraphQ[InfraBaseGraph[RandomInfraFibration[CompleteGraph[4], "VerticalVertices" -> 2]], CompleteGraph[4]],
  True,
  TestID -> "InfraBaseGraph-CompleteGraph"
]

(* ===== isomorphic fibers ===== *)

VerificationTest[
  InfraFiberBundleQ[RandomInfraFibration[CycleGraph[4], "VerticalVertices" -> 3, "VerticalEdges" -> 0]],
  True,
  TestID -> "InfraFiberBundleQ-UniformEmptyFibers"
]

VerificationTest[
  InfraFiberBundleQ[InfraFibration[Graph[{1, 2, 3, 4}, {UndirectedEdge[1, 2], UndirectedEdge[3, 4]}], <|1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b"|>]],
  True,
  TestID -> "InfraFiberBundleQ-IsomorphicEdgeFibers"
]

VerificationTest[
  InfraFiberBundleQ[InfraFibration[Graph[{1, 2, 3, 4}, {UndirectedEdge[1, 2]}], <|1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b"|>]],
  False,
  TestID -> "InfraFiberBundleQ-NonIsomorphicFibers"
]

VerificationTest[
  Equal @@ (VertexCount /@ Values[InfraFibers[InfraFibration[Graph[{1, 2, 3, 4}, {UndirectedEdge[1, 2]}], <|1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b"|>]]]),
  True,
  TestID -> "InfraFibers-SameVertexCountOnly"
]

(* ===== InfraFibrationQ: edge lifting ===== *)

VerificationTest[
  InfraFibrationQ[InfraFibration[
    Graph[{1, 2, 3, 4}, {UndirectedEdge[1, 3], UndirectedEdge[1, 4], UndirectedEdge[2, 3], UndirectedEdge[2, 4]}],
    <|1 -> "u", 2 -> "u", 3 -> "v", 4 -> "v"|>]],
  True,
  TestID -> "InfraFibrationQ-CompleteBipartiteFibers"
]

VerificationTest[
  InfraFibrationQ[InfraFibration[Graph[{1, 2, 3}, {UndirectedEdge[1, 3]}], <|1 -> "u", 2 -> "u", 3 -> "v"|>]],
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
  With[{fib = InfraFibration[
      Graph[{1, 2, 3, 4}, {UndirectedEdge[1, 3], UndirectedEdge[1, 4], UndirectedEdge[2, 3], UndirectedEdge[2, 4]}],
      <|1 -> "u", 2 -> "u", 3 -> "v", 4 -> "v"|>]},
    {InfraFibrationQ[fib], InfraFiberBundleQ[fib]}],
  {True, False},
  TestID -> "InfraFiberBundleQ-two-lifts"
]

(* ===== InfraFiberBundleQ: edgewise fiber products ===== *)

VerificationTest[
  With[{total = GraphProduct[PathGraph[{1, 2}], CompleteGraph[3], "Cartesian"]},
    InfraFiberBundleQ[InfraFibration[total, Last]]],
  True,
  TestID -> "InfraFiberBundleQ-ProductBundle-over-triangle"
]

VerificationTest[
  With[{verts = Flatten[Table[{i, j}, {i, 3}, {j, 2}], 1]},
    {edges = {UndirectedEdge[{1, 1}, {2, 1}], UndirectedEdge[{1, 2}, {2, 2}],
      UndirectedEdge[{2, 1}, {3, 1}], UndirectedEdge[{2, 2}, {3, 2}],
      UndirectedEdge[{3, 1}, {1, 2}], UndirectedEdge[{3, 2}, {1, 1}]}},
    InfraFiberBundleQ[InfraFibration[Graph[verts, edges], First]]],
  True,
  TestID -> "InfraFiberBundleQ-TwistedTriangle"
]

VerificationTest[
  With[{total = GraphProduct[CompleteGraph[3], CycleGraph[5], "Cartesian"]},
    InfraFiberBundleQ[InfraFibration[total, Last]]],
  True,
  TestID -> "InfraFiberBundleQ-ProductBundle"
]

VerificationTest[
  With[{verts = Flatten[Table[{i, j}, {i, 5}, {j, 2}], 1]},
    {edges = Join[
      Flatten @ Table[UndirectedEdge[{i, j}, {Mod[i, 5] + 1, j}], {i, 4}, {j, 2}],
      {UndirectedEdge[{5, 1}, {1, 2}], UndirectedEdge[{5, 2}, {1, 1}]}]},
    InfraFiberBundleQ[InfraFibration[Graph[verts, edges], First]]],
  True,
  TestID -> "InfraFiberBundleQ-MobiusBundle"
]

(* Nontrivial monodromy is compatible with edgewise local products. *)
VerificationTest[
  {InfraFiberBundleQ[InfraFibration[CycleGraph[8], i |-> Mod[i, 4, 1]]],
   InfraFiberBundleQ[InfraFibration[CycleGraph[6], i |-> Mod[i, 3, 1]]]},
  {True, True},
  TestID -> "InfraFiberBundleQ-double-covers"
]

(* ===== InfraBundleMorphismQ ===== *)

VerificationTest[
  SeedRandom[1];
  With[{fib = RandomInfraFibration[CycleGraph[4], RandomSeeding -> None ]},
    {InfraBundleMorphismQ[fib, fib, Identity],
     With[{vertices = VertexList[InfraTotalGraph[fib]]}, {map = AssociationThread[vertices, RandomChoice[vertices, Length[vertices]]]},
       {DuplicateFreeQ[Values[map]], InfraBundleMorphismQ[fib, fib, map]}]}],
  {True, {False, False}},
  TestID -> "InfraBundleMorphismQ-identity-and-a-random-non-injective-map"
]

VerificationTest[
  InfraBundleMorphismQ[InfraFibration[CycleGraph[8], i |-> Mod[i, 4, 1]], InfraFibration[CycleGraph[4], Identity], i |-> Mod[i, 4, 1]],
  True,
  TestID -> "InfraBundleMorphismQ-covering-onto-the-trivial-bundle"
]

VerificationTest[
  With[{fib = InfraFibration[CycleGraph[8], i |-> Mod[i, 4, 1]]},
    {InfraBundleMorphismQ[fib, fib, i |-> Mod[i + 2, 8, 1], p |-> Mod[p + 2, 4, 1]],
     InfraBundleMorphismQ[fib, fib, i |-> Mod[i + 2, 8, 1]]}],
  {True, False},
  TestID -> "InfraBundleMorphismQ-over-a-base-rotation"
]

VerificationTest[
  InfraBundleMorphismQ[InfraFibration[CycleGraph[8], i |-> Mod[i, 4, 1]], InfraFibration[CycleGraph[8], i |-> Mod[i, 4, 1]], i |-> Mod[i + 1, 8, 1], p |-> Mod[p + 1, 4, 1]],
  True,
  TestID -> "InfraBundleMorphismQ-deck-shift"
]

VerificationTest[
  With[ { total = Graph[ Range[ 6 ], { UndirectedEdge[ 1, 2 ], UndirectedEdge[ 2, 3 ], UndirectedEdge[ 4, 5 ], UndirectedEdge[ 5, 6 ],
        UndirectedEdge[ 1, 5 ], UndirectedEdge[ 2, 4 ], UndirectedEdge[ 3, 6 ] } ] },
    InfraFiberBundleQ[ InfraFibration[ total, AssociationThread[ Range[ 6 ], { "p", "p", "p", "q", "q", "q" } ] ] ] ],
  False,
  TestID -> "InfraFiberBundleQ-matching-must-preserve-fiber-adjacency"
]

VerificationTest[
  With[ { vertices = { { 1, "a" }, { 2, "b" }, { 3, "c" }, { 4, "d" } } },
    { projection = AssociationThread[ vertices, { { "p", 1 }, { "p", 1 }, { "q", 2 }, { "q", 2 } } ],
      total = Graph[ vertices, UndirectedEdge @@@ Partition[ vertices, 2, 1 ] ] },
    { fib = InfraFibration[ total, projection ] },
    { InfraFibrationAssociation[ fib ] === projection,
      VertexList[ InfraFiber[ fib, { "p", 1 } ] ] === Take[ vertices, 2 ],
      VertexList[ InfraBaseGraph[ fib ] ] === { { "p", 1 }, { "q", 2 } },
      EdgeList[ InfraBaseGraph[ fib ] ] === { UndirectedEdge[ { "p", 1 }, { "q", 2 } ] } } ],
  { True, True, True, True },
  TestID -> "InfraFibration-literal-list-total-and-base-vertices"
]

VerificationTest[
  With[ { vertices = { Blank[ Integer ], Alternatives[ "left", "right" ], "end" } },
    { total = Graph[ vertices, UndirectedEdge @@@ Partition[ vertices, 2, 1 ] ],
      projection = AssociationThread[ vertices, { "p", "q", "q" } ] },
    { fib = InfraFibration[ total, projection ] },
    { InfraFibrationAssociation[ fib ] === projection,
      VertexList[ InfraFiber[ fib, "p" ] ] === Take[ vertices, 1 ],
      InfraBundleMorphismQ[ fib, fib, AssociationThread[ vertices, vertices ] ] } ],
  { True, True, True },
  TestID -> "InfraFibration-patternlike-vertices-are-literal"
]

VerificationTest[
  With[ { total = PathGraph[ Range[ 3 ] ] },
    { missing = InfraFibration[ total, <| 1 -> "p", 2 -> "q" |> ],
      extra = InfraFibration[ total, <| 1 -> "p", 2 -> "q", 3 -> "r", 4 -> "s" |> ] },
    { Head @ InfraFibrationAssociation[ missing ], Head @ InfraFibrationAssociation[ extra ],
      Head @ InfraBaseGraph[ missing ], Head @ InfraFibrationQ[ missing ], Head @ InfraFiberBundleQ[ extra ] } ],
  { InfraFibrationAssociation, InfraFibrationAssociation, InfraBaseGraph, InfraFibrationQ, InfraFiberBundleQ },
  TestID -> "InfraFibration-malformed-projections-remain-unevaluated"
]

VerificationTest[
  With[ { directed = Graph[ { 1 -> 2 } ], weighted = Graph[ CycleGraph[ 3 ], EdgeWeight -> { 1, 2, 3 } ] },
    Map[ total |-> With[ { fib = InfraFibration[ total, Identity ] },
      { Head @ InfraTotalGraph[ fib ], Head @ InfraBaseGraph[ fib ], Head @ RandomInfraFibration[ total ] } ],
      { directed, weighted } ] ],
  { { InfraTotalGraph, InfraBaseGraph, RandomInfraFibration }, { InfraTotalGraph, InfraBaseGraph, RandomInfraFibration } },
  TestID -> "InfraFibration-directed-and-weighted-domain-is-unsupported"
]

VerificationTest[
  With[ { base = PathGraph[ Range[ 3 ] ] },
    { fib = RandomInfraFibration[ base, "VerticalVertices" -> 3, "VerticalEdges" -> 0,
        "HorizontalEdgesDensity" -> All ] },
    { EdgeCount @ InfraTotalGraph[ fib ], EdgeList @ InfraBaseGraph[ fib ] === EdgeList @ base,
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
    { VertexList @ InfraBaseGraph[ fib ] === VertexList @ base,
      EdgeList @ InfraBaseGraph[ fib ] === EdgeList @ base,
      VertexCount @ InfraFiber[ fib, { "isolated", 3 } ], InfraFibrationQ[ fib ] } ],
  { True, True, 2, True },
  TestID -> "RandomInfraFibration-preserves-isolated-and-list-base-vertices"
]

VerificationTest[
  With[ { fib = RandomInfraFibration[ Graph[ { }, { } ] ] },
    { VertexCount @ InfraTotalGraph[ fib ], InfraFibrationAssociation[ fib ], VertexCount @ InfraBaseGraph[ fib ],
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
    VertexCount @ InfraTotalGraph[ fib ] ],
  8,
  TestID -> "RandomInfraFibration-first-duplicate-option"
]

VerificationTest[
  With[ { fib = InfraFibration[ CycleGraph[ 6 ], point |-> Mod[ point, 3, 1 ] ] },
    { InfraFibrationQ[ { } ], InfraFiberBundleQ[ { } ], InfraFibrationQ[ { fib } ], InfraFiberBundleQ[ { fib } ] } ],
  { False, False, True, True },
  TestID -> "InfraFibration-counted-predicate-shapes"
]

VerificationTest[
  With[ { base = CycleGraph[ 3 ] },
    { fib = RandomInfraFibration[ base, { "VerticalVertices" -> 2, "VerticalVertices" -> 3 } ] },
    { VertexCount @ InfraTotalGraph[ fib ], IsomorphicGraphQ[ InfraBaseGraph[ fib ], base ] } ],
  { 6, True },
  TestID -> "RandomInfraFibration-standard-option-list-and-first-duplicate"
]

(* a projection that is not a map, so that its values are inert applications, is not a fibered graph *)
VerificationTest[
  With[ { predicates = { InfraFiberedGraphQ, InfraEqualFiberSizesQ, InfraIsomorphicFibersQ,
        InfraFibrationQ, InfraAtMostOneEdgeLiftQ, InfraUniqueEdgeLiftingQ, InfraCoveringQ, InfraFiberBundleQ } },
    { #[ InfraFiberedGraph[ CycleGraph[ 4 ], "bad" ] ] & /@ predicates,
      InfraFiberedGraphQ /@ { InfraFibration[ CycleGraph[ 4 ], { 1, 2 } ], InfraFiberedGraph[ CycleGraph[ 4 ], Mod[ #, 2 ] & ],
        InfraFiberedGraph[ CycleGraph[ 4 ], Floor ] } } ],
  { ConstantArray[ False, 8 ], { False, True, True } },
  TestID -> "InfraFiberedGraphQ-projection-that-is-not-a-map"
]

EndTestSection[]
