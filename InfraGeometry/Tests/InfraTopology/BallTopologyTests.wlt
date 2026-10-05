BeginTestSection["BallTopology"]

(* Moved from RiemannianTests.wlt on 2026-10-05, when the tests were split by kernel file (APISurfaceCleanup T9) *)

(* ===== Alexandrov topology: BallTopology / Topological* / ContinuousMapQ ===== *)

(* Carrier set is recoverable from the preorder digraph alone, incl. isolated vertices *)
VerificationTest[
    With[{g = Graph[{1, 2, 3, 4, 5}, {1 <-> 2, 2 <-> 3, 3 <-> 4}]},
        Sort @ VertexList @ BallTopology[g, 1] === Sort @ VertexList[g]
    ],
    True,
    TestID -> "BallTopology-carrier"
]

(* int(S) subset S subset cl(S) *)
VerificationTest[
    With[{topo = BallTopology[GridGraph[{4, 4}], 1], s = {1, 2, 3, 6, 7}},
        SubsetQ[s, TopologicalInterior[topo, s]] && SubsetQ[TopologicalClosure[topo, s], s]
    ],
    True,
    TestID -> "Topological-sandwich"
]

(* Duality: cl(V\S) == V \ int(S) *)
VerificationTest[
    With[{topo = BallTopology[CycleGraph[8], 1], s = {1, 2, 3}},
        With[{v = VertexList[topo]},
            Sort @ TopologicalClosure[topo, Complement[v, s]] === Sort @ Complement[v, TopologicalInterior[topo, s]]
        ]
    ],
    True,
    TestID -> "Topological-duality"
]

(* Boundary is two-sided: bd(S) = cl(S)\int(S) and bd(S) = bd(V\S) *)
VerificationTest[
    With[{topo = BallTopology[GridGraph[{4, 4}], 1], s = {1, 2, 3, 6, 7}},
        With[{v = VertexList[topo]},
            Sort @ TopologicalBoundary[topo, s] === Sort @ Complement[TopologicalClosure[topo, s], TopologicalInterior[topo, s]] &&
            Sort @ TopologicalBoundary[topo, s] === Sort @ TopologicalBoundary[topo, Complement[v, s]]
        ]
    ],
    True,
    TestID -> "Topological-boundary-two-sided"
]

(* Alexandrov idempotence: cl(cl(S)) = cl(S), int(int(S)) = int(S) *)
VerificationTest[
    With[{topo = BallTopology[GridGraph[{4, 4}], 2], s = {1, 2, 3, 6, 7}},
        With[{cl = TopologicalClosure[topo, s], int = TopologicalInterior[topo, s]},
            Sort @ TopologicalClosure[topo, cl] === Sort @ cl &&
            Sort @ TopologicalInterior[topo, int] === Sort @ int
        ]
    ],
    True,
    TestID -> "Topological-idempotence"
]

(* Minimal open neighborhood is the up-set; contains S and is open (= its own interior) *)
VerificationTest[
    With[{topo = BallTopology[CycleGraph[8], 1], s = {1, 4}},
        With[{nb = TopologicalNeighborhood[topo, s]},
            SubsetQ[nb, s] && Sort @ TopologicalInterior[topo, nb] === Sort @ nb
        ]
    ],
    True,
    TestID -> "Topological-neighborhood-open"
]

(* ContinuousMapQ: identity is continuous topo->topo, but not topo->dual (edges reversed) *)
VerificationTest[
    With[{topo = BallTopology[PathGraph[Range[5]], 1], dual = BallTopology[PathGraph[Range[5]], 1, "Dual" -> True]},
        With[{id = AssociationMap[Identity, VertexList[topo]]},
            {ContinuousMapQ[id, topo, topo], ContinuousMapQ[id, topo, dual]}
        ]
    ],
    {True, False},
    TestID -> "ContinuousMapQ-identity-vs-dual"
]

EndTestSection[]
