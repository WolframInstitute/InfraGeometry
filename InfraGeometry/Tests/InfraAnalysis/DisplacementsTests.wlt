BeginTestSection["Displacements"]

(* Moved from RiemannianTests.wlt on 2026-10-05, when the tests were split by kernel file (APISurfaceCleanup T9) *)

(* ===== Displacements ===== *)

dispGrid = VertexReplace[GridGraph[{5, 5}], Catenate @ Table[5 j + i + 1 -> {i + 1, j + 1}, {j, 0, 4}, {i, 0, 4}]]
dispX = AssociationMap[{{Min[#[[1]] + 1, 5], #[[2]]}} &, VertexList @ dispGrid]
dispY = AssociationMap[{{#[[1]], Min[#[[2]] + 1, 5]}} &, VertexList @ dispGrid]
dispCycleStep = AssociationMap[{Mod[#, 10] + 1} &, Range @ 10]

(* the sum is exactly commutative: the bisector construction is symmetric *)
VerificationTest[
    DisplacementSum[dispGrid, dispX, dispY] === DisplacementSum[dispGrid, dispY, dispX],
    True,
    TestID -> "Displacement-sum-commutative"
]

(* coordinate steps have zero metric bracket on the interior *)
VerificationTest[
    DisplacementBracket[dispGrid, dispX, dispY, {2, 2}],
    {{2, 2}},
    TestID -> "Displacement-bracket-coordinate-steps"
]

(* negative is the straight reflection on the interior *)
VerificationTest[
    DisplacementNegative[dispGrid, dispX] @ {3, 3},
    {{2, 3}},
    TestID -> "Displacement-negative-reflection"
]

(* inverse relations record every preimage, including empty fibers *)
VerificationTest[
    Lookup[DisplacementInverse @ dispX, {{1, 3}, {5, 3}}],
    {{}, {{4, 3}, {5, 3}}},
    TestID -> "Displacement-inverse-relation"
]

(* a Killing displacement has a genuine two-sided inverse *)
VerificationTest[
    With[{inverse = DisplacementInverse @ dispCycleStep},
      {DisplacementCompose[dispCycleStep, inverse], DisplacementCompose[inverse, dispCycleStep]}],
    ConstantArray[AssociationMap[{#} &, Range @ 10], 2],
    TestID -> "Displacement-inverse-killing"
]

(* scaling round-trip on the cycle: (1/3)(3 D) = D *)
VerificationTest[
    DisplacementScale[CycleGraph[10], DisplacementScale[CycleGraph[10], dispCycleStep, 3], 1/3],
    dispCycleStep,
    TestID -> "Displacement-scale-roundtrip"
]

(* magnitude of a unit step field is 1 *)
VerificationTest[
    DisplacementMagnitude[dispGrid, dispX],
    1,
    TestID -> "Displacement-magnitude-unit"
]

(* reduce recovers a field from its neighbourhood blur *)
VerificationTest[
    DisplacementReduce[dispGrid, Map[Union @ Flatten[{#, AdjacencyList[dispGrid, First @ #]}, 1] &, dispX]],
    dispX,
    TestID -> "Displacement-reduce-deblur"
]

(* predicate hierarchy: clamped grid step is single-valued but no bijection; cycle step is a Killing displacement *)
VerificationTest[
    {DisplacementSingleValuedQ @ dispX, DisplacementBijectionQ @ dispX,
     DisplacementBijectionQ @ dispCycleStep, DisplacementIsomorphismQ[CycleGraph[10], dispCycleStep]},
    {True, False, True, True},
    TestID -> "Displacement-predicates"
]

(* k-continuity: the clamped step is 1-continuous *)
VerificationTest[
    ContinuousDisplacementQ[dispGrid, dispX],
    True,
    TestID -> "Displacement-continuity"
]

(* weak, Hausdorff and strong continuity distinguish their set quantifiers *)
VerificationTest[
        With[{graph = PathGraph[Range[4]], displacement = <|1 -> {1, 4}, 2 -> {2}, 3 -> {3}, 4 -> {4}|>},
            ContinuousDisplacementQ[graph, displacement, Method -> #] & /@ {"Weak", "Hausdorff", "Strong"}],
        {True, False, False},
        TestID -> "Displacement-continuity-methods"
]

(* smallest Killing displacement of the cycle is a unit rotation *)
VerificationTest[
    With[{killing = FindKillingDisplacement[CycleGraph[10]]},
            {KillingDisplacementMagnitude[CycleGraph[10]], killing, DisplacementIsomorphismQ[CycleGraph[10], killing]}],
        {1, FindKillingDisplacement[CycleGraph[10]], True},
    TestID -> "Displacement-killing-cycle"
]

(* exact commutators of Killing displacements close and reverse by inversion *)
VerificationTest[
        With[
            {graph = CycleGraph[10], rotation = dispCycleStep,
             reflection = AssociationMap[{Mod[2 - #, 10, 1]} &, Range @ 10]},
            With[
                {xy = DisplacementCommutator[graph, rotation, reflection],
                 yx = DisplacementCommutator[graph, reflection, rotation]},
                {DisplacementIsomorphismQ[graph, xy], xy === DisplacementInverse @ yx}]],
        {True, True},
        TestID -> "Displacement-commutator-killing-closure-antisymmetry"
]

(* inverse and negative commutator loops remain separately selectable *)
VerificationTest[
        {DisplacementCommutator[dispGrid, dispX, dispY, Method -> "Inverse"] ===
             DisplacementCommutator[dispGrid, dispX, dispY],
         DisplacementCommutator[dispGrid, dispX, dispY, Method -> "Negative"] ===
             DisplacementBracket[dispGrid, dispX, dispY]},
        {True, True},
        TestID -> "Displacement-commutator-methods"
]

(* the outward radial displacement is the gradient of the distance from the centre *)
VerificationTest[
    First @ PolarDisplacements[dispGrid, {3, 3}] ===
      GradientDisplacement[dispGrid, AssociationThread[VertexList @ dispGrid, GraphDistance[dispGrid, {3, 3}]]],
    True,
    TestID -> "Displacement-radial-is-gradient"
]

(* random displacements are continuous sections of the scale-r tangent bundle *)
VerificationTest[
    SeedRandom[7]; With[{d = RandomDisplacement[dispGrid, 2]},
      {ContinuousDisplacementQ[dispGrid, d], DisplacementMagnitude[dispGrid, d] <= 2}],
    {True, True},
    TestID -> "Displacement-random-continuous"
]

(* DisplacementKernelFindings: a graph without symmetry has no Killing displacement, and the call stays unevaluated with no message *)
VerificationTest[
    With[{graph = InfraSubstrate["SquareMeshGraph", "Small"]},
        Head @ FindKillingDisplacement[graph]],
    FindKillingDisplacement,
    TestID -> "Displacement-killing-asymmetric-unevaluated"
]

(* the bent arc is a planar construction: a three-dimensional embedding leaves the plot unevaluated *)
VerificationTest[
    With[{graph = InfraSubstrate["SquareTorusGraph", "Small", "KeepCoordinates" -> True]},
        With[{step = AssociationMap[{#} &, VertexList @ graph]},
            {Head @ DisplacementPlot[graph, step], Head @ DisplacementPlot[graph, {step}]}]],
    {DisplacementPlot, DisplacementPlot},
    TestID -> "Displacement-plot-planar-only"
]

(* the k-th displacement is drawn in the k-th Standard colour *)
VerificationTest[
    Cases[DisplacementPlot[dispGrid, {dispX, dispY}], {color_, _Arrowheads, ___} :> color, Infinity],
    {StandardBlue, StandardRed},
    TestID -> "Displacement-plot-standard-colours"
]

(* a random displacement is continuous, or the call stays unevaluated when the repair leaves a discontinuity *)
VerificationTest[
    With[{graph = InfraSubstrate["HexagonalTilingGraph", "Small"]},
        {SeedRandom[1]; ContinuousDisplacementQ[graph, RandomDisplacement[graph, 3]],
         SeedRandom[2]; Head @ RandomDisplacement[graph, 3]}],
    {True, RandomDisplacement},
    TestID -> "Displacement-random-unevaluated-on-failure"
]

(* a translation keeps the ties up to rounding: the hexagon centres reached by a unit edge go to all six corners *)
VerificationTest[
    With[{graph = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
        Lookup[Counts[Length /@ Values @ TranslationDisplacement[graph, {1, 0}]], {1, 6}, 0]],
    {53, 36},
    TestID -> "Displacement-translation-keeps-ties"
]

EndTestSection[]
