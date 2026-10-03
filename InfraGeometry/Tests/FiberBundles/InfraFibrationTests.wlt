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
  With[{fib = RandomInfraFibration[CycleGraph[4]]},
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
  AllTrue[VertexCount /@ Values[InfraFibers[RandomInfraFibration[CycleGraph[5], "VerticalVertices" -> {1, 4}]]], Between[{1, 4}]],
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
  Equal @@ (VertexCount /@ Values[InfraFibers[RandomInfraFibration[CycleGraph[5], "VerticalVertices" -> {1, 4}, "IsomorphicFibers" -> True]]]),
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
  With[{total = InfraTotalGraph[RandomInfraFibration[GridGraph[{3, 3}], "VerticalVertices" -> 2]]},
    Length[DeleteDuplicates[GraphEmbedding[total]]] == VertexCount[total]],
  True,
  TestID -> "RandomInfraFibration-fibers-drawn-around-the-base"
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

(* ===== InfraFiberBundleQ: local triviality ===== *)

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
  False,
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

(* the connected double cover is locally trivial over the square, not over the triangle, whose ball of radius 1 is the whole triangle *)
VerificationTest[
  {InfraFiberBundleQ[InfraFibration[CycleGraph[8], i |-> Mod[i, 4, 1]]],
   InfraFiberBundleQ[InfraFibration[CycleGraph[6], i |-> Mod[i, 3, 1]]]},
  {True, False},
  TestID -> "InfraFiberBundleQ-double-covers"
]

(* ===== InfraBundleMorphismQ ===== *)

VerificationTest[
  SeedRandom[1];
  With[{fib = RandomInfraFibration[CycleGraph[4]]},
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

EndTestSection[]
