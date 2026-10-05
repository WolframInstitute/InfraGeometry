BeginTestSection["BallCover"]

(* Moved from RiemannianTests.wlt on 2026-10-05, when the tests were split by kernel file (APISurfaceCleanup T9) *)

(* ===== Ball covers: FindBallCover, BallCoverQ, DominationNumber ===== *)

VerificationTest[
    DominationNumber[CycleGraph[7], 2],
    2,
    TestID -> "DominationNumber-C7-r2"
]

VerificationTest[
    DominationNumber[PetersenGraph[], 1],
    3,
    TestID -> "DominationNumber-Petersen-r1"
]

VerificationTest[
    BallCoverQ[CycleGraph[7], 2, FindBallCover[CycleGraph[7], 2]],
    True,
    TestID -> "FindBallCover-covers-C7"
]

VerificationTest[
    BallCoverQ[CycleGraph[7], 1, {1}],
    False,
    TestID -> "BallCoverQ-single-ball-too-small"
]

(* a cover of a vertex subset covers its targets and can be smaller than a full cover *)
VerificationTest[
    With[{g = PathGraph[Range[7]]},
        {BallCoverQ[g, 1, FindBallCover[g, 1, {1, 7}], {1, 7}], DominationNumber[g, 1, {1, 7}] < DominationNumber[g, 1]}
    ],
    {True, True},
    TestID -> "FindBallCover-subset-covers-targets"
]

(* Method -> "Greedy" always returns a valid cover ... *)
VerificationTest[
    With[{g = GraphData["CuboctahedralGraph"]},
        BallCoverQ[g, 1, FindBallCover[g, 1, All, 1, Method -> "Greedy"]]
    ],
    True,
    TestID -> "FindBallCover-greedy-covers"
]

(* ... but is not minimum in general: the cuboctahedron is vertex-transitive with gamma = 3,
   yet every greedy run returns 4 *)
VerificationTest[
    With[{g = GraphData["CuboctahedralGraph"]},
        {Length @ FindBallCover[g, 1], Length @ FindBallCover[g, 1, All, 1, Method -> "Greedy"]}
    ],
    {3, 4},
    TestID -> "FindBallCover-greedy-suboptimal-cuboctahedron"
]

(* Method -> "Symmetric" recovers the orbit-shaped minimum cover greedy misses: the
   cuboctahedron's gamma = 3 is a single Aut-orbit, so the symmetric search finds 3, not 4 *)
VerificationTest[
    With[{g = GraphData["CuboctahedralGraph"]}, {s = FindBallCover[g, 1, All, 1, Method -> "Symmetric"]},
        {Length[s], BallCoverQ[g, 1, s]}
    ],
    {3, True},
    TestID -> "FindBallCover-symmetric-cuboctahedron"
]

EndTestSection[]
