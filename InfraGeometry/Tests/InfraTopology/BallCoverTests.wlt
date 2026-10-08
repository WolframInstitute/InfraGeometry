BeginTestSection["BallCover"]

(* Moved from RiemannianTests.wlt on 2026-10-05, when the tests were split by kernel file (APISurfaceCleanup T9) *)

(* ===== Ball covers: FindBallCover, BallCoverQ, BallCoverNumber ===== *)

VerificationTest[
    BallCoverNumber[CycleGraph[7], 2],
    2,
    TestID -> "BallCoverNumber-C7-r2"
]

VerificationTest[
    BallCoverNumber[PetersenGraph[], 1],
    3,
    TestID -> "BallCoverNumber-Petersen-r1"
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
        {BallCoverQ[g, 1, FindBallCover[g, 1, {1, 7}], {1, 7}], BallCoverNumber[g, 1, {1, 7}] < BallCoverNumber[g, 1]}
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

(* Method -> "Symmetric" on a graph without symmetry: every vertex is its own orbit, so the
   symmetric program is the exhaustive one and returns a minimum cover, no message *)
VerificationTest[
    With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {s = FindBallCover[g, 2, All, 1, Method -> "Symmetric"]},
        {Length[s], BallCoverQ[g, 2, s], BallCoverNumber[g, 2]}
    ],
    {8, True, 8},
    TestID -> "FindBallCover-symmetric-asymmetric-graph"
]

(* A count other than 1 gives a list of covers for every method; "Greedy" and "Symmetric"
   a list of their one cover *)
VerificationTest[
    With[{g = CycleGraph[6]},
        Table[
            With[{covers = FindBallCover[g, 1, All, All, Method -> m]},
                MatchQ[covers, {{__Integer} ..}] && AllTrue[covers, BallCoverQ[g, 1, #] &]
            ],
            {m, {"Exhaustive", "Greedy", "Symmetric"}}
        ]
    ],
    {True, True, True},
    TestID -> "FindBallCover-count-list-every-method"
]

VerificationTest[
    {FindBallCover[CycleGraph[6], 1, All, All, Method -> "Greedy"], FindBallCover[CycleGraph[6], 1, All, UpTo[0], Method -> "Greedy"]},
    {{{6, 3}}, {}},
    TestID -> "FindBallCover-greedy-count-wraps-one-cover"
]

(* BallCoverNumber counts the cover FindBallCover finds under the same Method: on the cuboctahedron
   the exhaustive and the symmetric count are the domination number 3, the greedy count 4 *)
VerificationTest[
    With[{g = GraphData["CuboctahedralGraph"]},
        Table[BallCoverNumber[g, 1, Method -> m], {m, {"Exhaustive", "Greedy", "Symmetric"}}]
    ],
    {3, 4, 3},
    TestID -> "BallCoverNumber-Method-cuboctahedron"
]

(* the radius defaults to 1 and the targets to All *)
VerificationTest[
    {BallCoverNumber[PetersenGraph[]], BallCoverNumber[PetersenGraph[], 1, All]},
    {3, 3},
    TestID -> "BallCoverNumber-defaults"
]

EndTestSection[]
