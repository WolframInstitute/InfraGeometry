BeginTestSection["UniformLengthDiscretization"]

(* Moved from RiemannianTests.wlt on 2026-10-05, when the tests were split by kernel file (APISurfaceCleanup T9) *)

(* ===== Unit-length discretization & embedding ===== *)

ulEdgeLengths[g_] := With[{p = GraphEmbedding[g]},
    EuclideanDistance[p[[#[[1]]]], p[[#[[2]]]]] & /@ (List @@@ EdgeList[g])
]

VerificationTest[
    With[{e = UniformLengthEmbedding[CycleGraph[6]]}, MatrixQ[e] && Dimensions[e] === {6, 3}],
    True,
    TestID -> "UniformLengthEmbedding-matrix-shape"
]

VerificationTest[
    With[{g = CycleGraph[6], e = UniformLengthEmbedding[CycleGraph[6]]},
        Max @ Abs[(EuclideanDistance[e[[#[[1]]]], e[[#[[2]]]]] & /@ (List @@@ EdgeList[g])) - 1] < 0.01
    ],
    True,
    TestID -> "UniformLengthEmbedding-unit-edges"
]

VerificationTest[
    Dimensions @ UniformLengthEmbedding[GridGraph[{3, 3}], "Dimension" -> 2],
    {9, 2},
    TestID -> "UniformLengthEmbedding-dimension-option"
]

VerificationTest[
    With[{g = UniformLengthGraph[Sphere[], 40]},
        GraphQ[g] && VertexCount[g] == 40 && Mean[N @ VertexDegree[g]] >= 4
    ],
    True,
    TestID -> "UniformLengthGraph-sphere-jammed"
]

VerificationTest[
    With[{lens = ulEdgeLengths @ UniformLengthGraph[Sphere[], 40]}, Max[lens] / Min[lens] < 1.8],
    True,
    TestID -> "UniformLengthGraph-sphere-edges-near-uniform"
]

VerificationTest[
    Block[{}, SeedRandom[1];
        With[{g = UniformLengthGraph[Circle[{0, 0}, 1], 20]},
            GraphQ[g] && VertexCount[g] == 20 && Mean[N @ VertexDegree[g]] > 1.8
        ]
    ],
    True,
    TestID -> "UniformLengthGraph-circle-cycle"
]

VerificationTest[
    Block[{}, SeedRandom[3];
        With[{lens = ulEdgeLengths @ Quiet @ UniformLengthGraph[Circle[{0, 0}, 1], 12, Method -> "ConstrainedPacking"]},
            Max[lens] - Min[lens] < 0.05
        ]
    ],
    True,
    TestID -> "UniformLengthGraph-constrained-uniform"
]

EndTestSection[]
