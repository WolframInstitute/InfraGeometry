BeginTestSection["InfraTangentBundle"]

(* The numbers are those of the InfraFibrations Prototype (2026-10-03), on GridGraph[{4, 4}] at scale 2 *)

(* ===== the heads ===== *)

VerificationTest[
  {InfraTangentBundle[x, 2], InfraCotangentBundle[x, 2], InfraDisplacementBundle[x, 2]},
  {InfraTangentBundle[x, 2], InfraCotangentBundle[x, 2], InfraDisplacementBundle[x, 2]},
  TestID -> "InfraTangentBundle-heads-are-inert"
]

VerificationTest[
  {InfraTotalGraph[InfraTangentBundle[GridGraph[{4, 4}], 0]], InfraFibrationAssociation[InfraDisplacementBundle[foo, 2]]},
  {InfraTotalGraph[InfraTangentBundle[GridGraph[{4, 4}], 0]], InfraFibrationAssociation[InfraDisplacementBundle[foo, 2]]},
  TestID -> "InfraTangentBundle-scale-zero-and-non-graph-stay-unevaluated"
]

(* ===== InfraRays ===== *)

VerificationTest[
  InfraRays[GridGraph[{4, 4}], 6, 2],
  {{6, 2, 1}, {6, 2, 3}, {6, 5, 1}, {6, 5, 9}, {6, 7, 3}, {6, 7, 8}, {6, 7, 11}, {6, 10, 9}, {6, 10, 11}, {6, 10, 14}},
  TestID -> "InfraRays-grid-interior"
]

VerificationTest[
  {InfraRays[GridGraph[{4, 4}], 6, 0], Length[InfraRays[GridGraph[{4, 4}], 1, 3]], InfraRays[CycleGraph[6], 1, 3]},
  {{{6}}, 8, {{1, 2, 3, 4}, {1, 6, 5, 4}}},
  TestID -> "InfraRays-scale-zero-corner-and-cycle"
]

VerificationTest[
  InfraRays[PathGraph[{{0, 0}, {1, 0}, {2, 0}}], {0, 0}, 2],
  {{{0, 0}, {1, 0}, {2, 0}}},
  TestID -> "InfraRays-tuple-vertices-are-literal"
]

(* ===== the total graphs ===== *)

VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    {VertexCount[#], EdgeCount[#]} & /@ (InfraTotalGraph /@ {InfraTangentBundle[g, 2], InfraDisplacementBundle[g, 2], InfraCotangentBundle[g, 2]})],
  {{104, 520}, {68, 220}, {104, 520}},
  TestID -> "InfraTangentBundle-grid-counts"
]

VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    {VertexCount /@ {InfraFiber[InfraTangentBundle[g, 2], 6], InfraFiber[InfraDisplacementBundle[g, 2], 6]},
      EdgeCount[InfraFiber[InfraTangentBundle[g, 2], 6]]}],
  {{10, 6}, 0},
  TestID -> "InfraTangentBundle-fiber-over-6-ten-rays-six-endpoints-no-edges"
]

(* the vertexwise rule: {6, 5, 1} and {6, 2, 1} share both ends, but 5 and 2 are not adjacent *)
VerificationTest[
  With[{total = InfraTotalGraph[InfraTangentBundle[GridGraph[{4, 4}], 2]]},
    {EdgeQ[total, UndirectedEdge[{6, 5, 1}, {6, 2, 1}]], EdgeQ[total, UndirectedEdge[{6, 5, 1}, {7, 6, 2}]]}],
  {False, True},
  TestID -> "InfraTangentBundle-vertexwise-adjacency"
]

VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    {Lookup[InfraFibrationAssociation[InfraTangentBundle[g, 2]], Key[{6, 5, 1}]],
      Lookup[InfraFibrationAssociation[InfraCotangentBundle[g, 2]], Key[{1, 5, 6}]],
      Lookup[InfraFibrationAssociation[InfraDisplacementBundle[g, 2]], Key[{6, 1}]]}],
  {6, 6, 6},
  TestID -> "InfraTangentBundle-projections-first-last-first"
]

VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    {fib = InfraDisplacementBundle[g, 2]},
    {Head[InfraFibration[fib]], InfraTotalGraph[InfraFibration[fib]] === InfraTotalGraph[fib],
      InfraFibrationAssociation[InfraFibration[fib]] === InfraFibrationAssociation[fib],
      IsomorphicGraphQ[InfraBaseGraph[InfraFibration[fib]], g], IsomorphicGraphQ[InfraBaseGraph[InfraTangentBundle[g, 2]], g]}],
  {InfraFibration, True, True, True, True},
  TestID -> "InfraFibration-of-a-construction-is-literal"
]

VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    Options[InfraTotalGraph[#], VertexCoordinates] & /@
      {InfraTangentBundle[g, 2], InfraDisplacementBundle[g, 2], InfraCotangentBundle[g, 2]}],
  ConstantArray[{VertexCoordinates -> Automatic}, 3],
  TestID -> "InfraTangentBundle-totals-do-not-store-layout"
]

VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    {drawn = Graph[g, VertexCoordinates -> Table[{i, (-1)^i}, {i, VertexCount[g]}]]},
    Map[head |-> {InfraTotalGraph[head[g, 2]] === InfraTotalGraph[head[drawn, 2]],
        InfraFibrationAssociation[head[g, 2]] === InfraFibrationAssociation[head[drawn, 2]]},
      {InfraTangentBundle, InfraDisplacementBundle, InfraCotangentBundle}]],
  ConstantArray[{True, True}, 3],
  TestID -> "InfraTangentBundle-structure-is-independent-of-base-layout"
]

VerificationTest[
  Table[With[{fib = head[g, 2]},
      {VertexCount[InfraTotalGraph[fib]], EdgeCount[InfraTotalGraph[fib]], InfraFibrationAssociation[fib]}],
    {g, {Graph[{}, {}], PathGraph[{1, 2}]}}, {head, {InfraTangentBundle, InfraDisplacementBundle, InfraCotangentBundle}}],
  ConstantArray[{0, 0, <||>}, {2, 3}],
  TestID -> "InfraTangentBundle-empty-ray-and-displacement-sets"
]

VerificationTest[
  Table[{InfraFibrationQ[head[g, 2]], InfraFiberBundleQ[head[g, 2]]},
    {g, {GridGraph[{4, 4}], CycleGraph[8]}}, {head, {InfraTangentBundle, InfraCotangentBundle, InfraDisplacementBundle}}],
  {{{True, False}, {True, False}, {True, False}}, {{True, True}, {True, True}, {True, True}}},
  TestID -> "InfraTangentBundle-fibration-everywhere-bundle-on-the-cycle"
]

(* ===== InfraBundleMorphism ===== *)

VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    {tangent = InfraTangentBundle[g, 2], displacement = InfraDisplacementBundle[g, 2], tangent1 = InfraTangentBundle[g, 1],
      cotangent = InfraCotangentBundle[g, 2]},
    {InfraBundleMorphismQ[tangent, displacement, InfraBundleMorphism[tangent, displacement]],
      InfraBundleMorphismQ[tangent, tangent1, InfraBundleMorphism[tangent, tangent1]],
      InfraBundleMorphismQ[tangent, displacement, ray |-> {First[ray], ray[[2]]}],
      InfraBundleMorphismQ[tangent, cotangent, Reverse],
      InfraBundleMorphismQ[cotangent, tangent, InfraBundleMorphism[cotangent, tangent]]}],
  {True, True, False, True, True},
  TestID -> "InfraBundleMorphism-endpoint-truncation-reversal"
]

VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    {InfraBundleMorphism[InfraTangentBundle[g, 2], InfraTangentBundle[g, 2]], InfraBundleMorphism[InfraTangentBundle[g, 2], InfraDisplacementBundle[g, 1]]}],
  With[{g = GridGraph[{4, 4}]},
    {InfraBundleMorphism[InfraTangentBundle[g, 2], InfraTangentBundle[g, 2]], InfraBundleMorphism[InfraTangentBundle[g, 2], InfraDisplacementBundle[g, 1]]}],
  TestID -> "InfraBundleMorphism-no-natural-map-stays-unevaluated"
]

VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    {tangent = InfraTangentBundle[g, 2]},
    {displacement = InfraDisplacementBundle[InfraBaseGraph[tangent], 2]},
    {InfraBundleMorphismQ[tangent, displacement, InfraBundleMorphism[tangent, displacement]],
      Head[InfraBundleMorphism[tangent, InfraDisplacementBundle[GridGraph[{4, 5}], 2]]]}],
  {True, InfraBundleMorphism},
  TestID -> "InfraBundleMorphism-base-equal-not-identical"
]

(* ===== the Prototype example (the item's Acceptance) ===== *)

VerificationTest[
  With[
    {g = GridGraph[{4, 4}]},
    {tangent = InfraTangentBundle[g, 2], displacement = InfraDisplacementBundle[g, 2], tangent1 = InfraTangentBundle[g, 1]},
    {endpoint = InfraBundleMorphism[tangent, displacement], truncate = InfraBundleMorphism[tangent, tangent1]},
    {up = InfraSection @ AssociationMap[p |-> {p, p + 1, p + 2}, {1, 2, 5, 6, 9, 10, 13, 14}]},
    {conn = RandomInfraConnection[displacement, "NextVertexFunction" -> Identity]},
    {InfraBundleMorphismQ[tangent, displacement, endpoint],
      InfraBundleMorphismQ[tangent, tangent1, truncate],
      InfraBundleMorphismQ[tangent, displacement, ray |-> {First @ ray, ray[[2]]}],
      InfraContinuousSectionQ[tangent, up],
      InfraContinuousSectionQ[displacement, InfraSection[endpoint /@ First @ up]],
      VertexCount /@ {InfraFiber[tangent, 6], InfraFiber[displacement, 6]},
      IsomorphicGraphQ[InfraBaseGraph @ InfraFibration @ displacement, g],
      conn === {}}],
  {True, True, False, True, True, {10, 6}, True, True},
  TestID -> "InfraTangentBundle-prototype-acceptance"
]

EndTestSection[]
