BeginTestSection["OllivierCurvature"]

(* Moved from RiemannianTests.wlt on 2026-10-05, when the tests were split by kernel file (APISurfaceCleanup T9) *)

(* ===== OllivierRicciCurvature ===== *)

VerificationTest[
    Values @ OllivierRicciCurvature[CompleteGraph[4]],
    ConstantArray[2 / 3, 6],
    SameTest -> (Max @ Abs[#1 - #2] < 10^-8 &),
    TestID -> "OllivierRicciCurvature-K4"
]

VerificationTest[
    Values @ OllivierRicciCurvature[PathGraph[Range[5]]],
    ConstantArray[0, 4],
    SameTest -> (Max @ Abs[#1 - #2] < 10^-8 &),
    TestID -> "OllivierRicciCurvature-P5-zero"
]

VerificationTest[
    Values @ OllivierRicciCurvature[CycleGraph[6]],
    ConstantArray[0, 6],
    SameTest -> (Max @ Abs[#1 - #2] < 10^-8 &),
    TestID -> "OllivierRicciCurvature-C6-zero"
]

(* ===== EffectiveResistance: closed-form values ===== *)

VerificationTest[
    Chop[EffectiveResistance[PathGraph[Range[6]], 1, 6] - 5, 10^-10] == 0,
    True,
    TestID -> "EffectiveResistance-Path-endpoints"
]

VerificationTest[
    Chop[EffectiveResistance[PathGraph[Range[5]], 2, 4] - 2, 10^-10] == 0,
    True,
    TestID -> "EffectiveResistance-Path-interior"
]

VerificationTest[
    With[{r = EffectiveResistance[CompleteGraph[5]]},
        Max[Abs[(r + DiagonalMatrix[ConstantArray[2/5, 5]]) - ConstantArray[2/5, {5, 5}]]] < 10^-10
    ],
    True,
    TestID -> "EffectiveResistance-K5-uniform"
]

VerificationTest[
    Chop[EffectiveResistance[CycleGraph[6], 1, 4] - 6/4, 10^-10] == 0,
    True,
    TestID -> "EffectiveResistance-C6-antipodal"
]

VerificationTest[
    With[{tree = Graph[{1 <-> 2, 2 <-> 3, 3 <-> 4, 2 <-> 5}]},
        Max[Abs[EffectiveResistance[tree] - GraphDistanceMatrix[tree]]] < 10^-10
    ],
    True,
    TestID -> "EffectiveResistance-tree-equals-distance"
]

VerificationTest[
    With[{r = EffectiveResistance[PetersenGraph[]]},
        Max[Abs[r - Transpose[r]]] < 10^-10 && Max[Abs @ Diagonal[r]] < 10^-10
    ],
    True,
    TestID -> "EffectiveResistance-symmetry"
]

(* Foster's theorem: sum over edges = n - 1 *)
VerificationTest[
    With[{g = PetersenGraph[]},
        Chop[Total[EffectiveResistance[g, #1, #2] & @@@ (List @@@ EdgeList[g])] - (VertexCount[g] - 1), 10^-9] == 0
    ],
    True,
    TestID -> "Foster-Petersen"
]

VerificationTest[
    With[{g = GridGraph[{3, 3}]},
        Chop[Total[EffectiveResistance[g, #1, #2] & @@@ (List @@@ EdgeList[g])] - (VertexCount[g] - 1), 10^-9] == 0
    ],
    True,
    TestID -> "Foster-Grid3x3"
]

(* Triangle inequality for sqrt(R) *)
VerificationTest[
    With[{g = PetersenGraph[], n = 10},
        With[{r = Sqrt @ EffectiveResistance[g]},
            Max[Flatten @ Table[r[[i, k]] - r[[i, j]] - r[[j, k]], {i, n}, {j, n}, {k, n}]] < 10^-9
        ]
    ],
    True,
    TestID -> "ResistanceMetric-triangle-Petersen"
]

VerificationTest[
    Dimensions @ EffectiveResistance[PetersenGraph[], {1, 3, 5}],
    {3, 3},
    TestID -> "EffectiveResistance-submatrix-shape"
]

(* ===== ResistanceQ ===== *)

VerificationTest[
    ResistanceQ @ EffectiveResistance @ PetersenGraph[],
    True,
    TestID -> "ResistanceQ-Petersen"
]

VerificationTest[
    ResistanceQ[{{0, 1, 5}, {1, 0, 1}, {5, 1, 0}}],
    False,
    TestID -> "ResistanceQ-violates-negative-type"
]

VerificationTest[
    ResistanceQ["nonsense"],
    False,
    TestID -> "ResistanceQ-non-matrix"
]

EndTestSection[]
