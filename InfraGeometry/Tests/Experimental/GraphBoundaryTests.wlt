BeginTestSection["GraphBoundary"]

(* Moved from RiemannianTests.wlt on 2026-10-05, when the tests were split by kernel file (APISurfaceCleanup T9) *)

(* ===== GraphBoundary & GraphInterior ===== *)

(* Worked example: path 1-2-3-4-5, S = {2,3,4} -> boundary {2,4}, interior {3} *)
VerificationTest[
    With[{g = PathGraph[Range[5]]},
        {GraphBoundary[g, {2, 3, 4}], GraphInterior[g, {2, 3, 4}]}
    ],
    {{2, 4}, {3}},
    TestID -> "GraphBoundary-path-arc"
]

(* Partition: boundary and interior are disjoint and union to S *)
VerificationTest[
    With[{g = GridGraph[{4, 4}], s = {1, 2, 3, 6, 7, 11}},
        {Sort @ Union[GraphBoundary[g, s], GraphInterior[g, s]],
         Intersection[GraphBoundary[g, s], GraphInterior[g, s]]}
    ],
    {{1, 2, 3, 6, 7, 11}, {}},
    TestID -> "GraphBoundary-partition"
]

(* Interior characterization: every interior vertex has all neighbors inside S *)
VerificationTest[
    With[{g = GridGraph[{4, 4}], s = {1, 2, 3, 6, 7, 11}},
        AllTrue[GraphInterior[g, s], SubsetQ[s, AdjacencyList[g, #]] &]
    ],
    True,
    TestID -> "GraphInterior-characterization"
]

(* Boundary characterization: every boundary vertex has a neighbor outside S *)
VerificationTest[
    With[{g = GridGraph[{4, 4}], s = {1, 2, 3, 6, 7, 11}},
        AllTrue[GraphBoundary[g, s], IntersectingQ[AdjacencyList[g, #], Complement[VertexList[g], s]] &]
    ],
    True,
    TestID -> "GraphBoundary-characterization"
]

(* Full vertex set: boundary empty, interior is everything *)
VerificationTest[
    With[{g = GridGraph[{3, 3}], v = VertexList @ GridGraph[{3, 3}]},
        {GraphBoundary[g, v], Sort @ GraphInterior[g, v]}
    ],
    {{}, Sort @ VertexList @ GridGraph[{3, 3}]},
    TestID -> "GraphBoundary-full-set"
]

(* Grid plus-shape: center is interior, the four arms are boundary *)
VerificationTest[
    With[{g = GridGraph[{3, 3}]},
        {Sort @ GraphBoundary[g, {2, 4, 5, 6, 8}], GraphInterior[g, {2, 4, 5, 6, 8}]}
    ],
    {{2, 4, 6, 8}, {5}},
    TestID -> "GraphBoundary-grid-plus"
]

(* Cycle arc: the two ends are boundary, the middle is interior *)
VerificationTest[
    With[{g = CycleGraph[6]},
        {Sort @ GraphBoundary[g, {1, 2, 3}], GraphInterior[g, {1, 2, 3}]}
    ],
    {{1, 3}, {2}},
    TestID -> "GraphBoundary-cycle-arc"
]

(* Subgraph form agrees with the vertex-list form when the subgraph is induced *)
VerificationTest[
    With[{g = GridGraph[{4, 4}], s = {1, 2, 3, 6, 7, 11}},
        GraphBoundary[g, Subgraph[g, s]] === GraphBoundary[g, s] &&
        GraphInterior[g, Subgraph[g, s]] === GraphInterior[g, s]
    ],
    True,
    TestID -> "GraphBoundary-subgraph-form"
]

(* A NON-induced subgraph (a Hamiltonian path/curve through every vertex) is
   edge-aware: as a curve it is all boundary but for two pass-through corners,
   whereas the same vertices as a list (full set) are entirely interior *)
VerificationTest[
    With[{g = GridGraph[{3, 3}],
          curve = Graph[Range[9], UndirectedEdge @@@ Partition[{1, 2, 3, 6, 5, 4, 7, 8, 9}, 2, 1]]},
        {Length @ GraphInterior[g, curve], Length @ GraphInterior[g, VertexList[g]]}
    ],
    {2, 9},
    TestID -> "GraphInterior-noninduced-curve-vs-list"
]

(* Empty subset; isolated vertex is interior *)
VerificationTest[
    With[{g = Graph[{1, 2, 3, 4}, {1 <-> 2, 2 <-> 3}]},
        {GraphBoundary[g, {}], GraphInterior[g, {}],
         GraphBoundary[g, {1, 4}], GraphInterior[g, {1, 4}]}
    ],
    {{}, {}, {1}, {4}},
    TestID -> "GraphBoundary-empty-isolated"
]

(* Complement identity: outer boundary of S = inner boundary of V\S *)
VerificationTest[
    With[{g = PathGraph[Range[5]], s = {2, 3, 4}},
        With[{outer = GraphBoundary[g, Complement[VertexList[g], s]]},
            outer === {1, 5} &&
            AllTrue[outer, ! MemberQ[s, #] && IntersectingQ[AdjacencyList[g, #], s] &]
        ]
    ],
    True,
    TestID -> "GraphBoundary-complement-identity"
]

(* ===== Eccentricities / CenterGraph ===== *)

(* t is 0 exactly on the center and 1 exactly on the periphery. *)
VerificationTest[
	With[
		{g = GridGraph[{4, 6}]},
		{t = AssociationThread[VertexList[g], RelativeEccentricity[g]]},
		Sort[Keys @ Select[t, # == 0 &]] === Sort[GraphCenter[g]] &&
			Sort[Keys @ Select[t, # == 1 &]] === Sort[GraphPeriphery[g]]
	],
	True,
	TestID -> "RelativeEccentricity-center-and-periphery"
]

(* On a vertex-transitive graph diameter == radius, every vertex is both center and
   periphery, and the coordinate degenerates to 0. Same for a disconnected graph. *)
VerificationTest[
	{RelativeEccentricity[CycleGraph[8]],
	 RelativeEccentricity[GraphDisjointUnion[PathGraph[{1, 2}], PathGraph[{3, 4}]]]},
	{ConstantArray[0, 8], ConstantArray[0, 4]},
	TestID -> "RelativeEccentricity-degenerate-cases"
]

VerificationTest[
	With[{g = GridGraph[{3, 5}]}, RelativeEccentricity[g] === RelativeEccentricity[GraphDistanceMatrix[g]]],
	True,
	TestID -> "RelativeEccentricity-graph-is-distance-matrix"
]

(* e is the list form of VertexEccentricity, in VertexList order even when the vertex
   names are scrambled, and it is bounded by the radius and the diameter. *)
VerificationTest[
	With[
		{g = Graph[RandomSample[Range[24]], EdgeList[GridGraph[{4, 6}]]]},
		{e = GraphEccentricities[g]},
		e === (VertexEccentricity[g, #] & /@ VertexList[g]) &&
			Min[e] === GraphRadius[g] && Max[e] === GraphDiameter[g] &&
			e === GraphEccentricities[GraphDistanceMatrix[g]]
	],
	True,
	TestID -> "GraphEccentricities-is-vertex-eccentricity-in-order"
]

EndTestSection[]
