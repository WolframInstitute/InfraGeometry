BeginTestSection["Boundary"]

(* Moved from RiemannianTests.wlt on 2026-10-05, when the tests were split by kernel file (APISurfaceCleanup T9) *)

(* ===== 5a. Mesh Tests ===== *)

VerificationTest[
    With[{g = BoundarylessGraph @ MeshRegion[
        {{0}, {1}, {2}, {3}},
        Line /@ {{1, 2}, {2, 3}, {3, 4}}
    ]},
        Sort[VertexList[g]] == {1, 2, 3, 4} && Sort[List @@@ EdgeList[g]] == {{1, 2}, {2, 3}, {3, 4}}
    ],
    True,
    TestID -> "BoundarylessGraph-Mesh-Path"
]

VerificationTest[
    With[{g = BoundarylessGraph @ MeshRegion[
        {{0, 0}, {1, 0}, {1, 1}, {0, 1}, {1/2, 1/2}},
        Triangle /@ {{1, 2, 5}, {2, 3, 5}, {3, 4, 5}, {4, 1, 5}}
    ]},
        Sort[VertexList[g]] == {1, 2, 3, 4, 5} && Sort[Sort /@ (List @@@ EdgeList[g])] == {{1, 5}, {2, 5}, {3, 5}, {4, 5}}
    ],
    True,
    TestID -> "BoundarylessGraph-Mesh-Disk"
]

VerificationTest[
    With[{g = BoundarylessGraph @ MeshRegion[
        {{0, 0, 0}, {1, 0, 0}, {0, 1, 0}, {0, 0, 1}},
        Triangle /@ {{1, 2, 3}, {1, 2, 4}, {1, 3, 4}, {2, 3, 4}}
    ]},
        Sort[VertexList[g]] == {1, 2, 3, 4} && Length[EdgeList[g]] == 6
    ],
    True,
    TestID -> "BoundarylessGraph-Mesh-ClosedSurface"
]

VerificationTest[
    (* solid tetrahedron split into 4 sub-tets around interior vertex 5: the surface contour is deleted, the 4 spokes survive as whiskers *)
    With[{g = BoundarylessGraph @ MeshRegion[
        {{0, 0, 0}, {1, 0, 0}, {0, 1, 0}, {0, 0, 1}, {1/4, 1/4, 1/4}},
        Tetrahedron /@ {{1, 2, 3, 5}, {1, 2, 4, 5}, {1, 3, 4, 5}, {2, 3, 4, 5}}
    ]},
        Sort[VertexList[g]] == {1, 2, 3, 4, 5} && Sort[Sort /@ (List @@@ EdgeList[g])] == {{1, 5}, {2, 5}, {3, 5}, {4, 5}}
    ],
    True,
    TestID -> "BoundarylessGraph-Mesh-SolidVolume"
]

VerificationTest[
    {GraphExteriorBoundary @ MeshRegion[
        {{0, 0}, {1, 0}, {1, 1}, {0, 1}, {1/2, 1/2}},
        Triangle /@ {{1, 2, 5}, {2, 3, 5}, {3, 4, 5}, {4, 1, 5}}],
     GraphExteriorBoundary @ MeshRegion[
        {{0, 0, 0}, {1, 0, 0}, {0, 1, 0}, {0, 0, 1}, {1/4, 1/4, 1/4}},
        Tetrahedron /@ {{1, 2, 3, 5}, {1, 2, 4, 5}, {1, 3, 4, 5}, {2, 3, 4, 5}}]},
    {{1, 2, 3, 4}, {1, 2, 3, 4}},
    TestID -> "GraphExteriorBoundary-mesh-surface"
]

(* the degree detector on a lattice: MaxDegree finds exactly the rim, a closed lattice has no rim *)
VerificationTest[
    {Sort @ GraphExteriorBoundary[GridGraph[{5, 5}], Method -> "MaxDegree"] ==
       Sort @ Pick[VertexList @ #, Thread[VertexDegree @ # < 4]] & @ GridGraph[{5, 5}],
     GraphExteriorBoundary[TorusGraph[{5, 5}]]},
    {True, {}},
    TestID -> "GraphExteriorBoundary-degree-rim"
]

(* ===== BoundarylessGraph ===== *)

(* Defining property: no surviving edge joins two exterior-boundary vertices, boundary
   vertices with an inward edge survive as whiskers, only isolated vertices (the corners)
   are dropped *)
VerificationTest[
    With[{g = GridGraph[{5, 5}]},
        {b = GraphExteriorBoundary[g], h = BoundarylessGraph[g]},
        {ConnectedGraphQ[h],
         Select[EdgeList[h], SubsetQ[b, List @@ #] &] === {},
         VertexCount[h]}
    ],
    {True, True, 21},
    TestID -> "BoundarylessGraph-rim-contour-deleted"
]

(* A substrate embedded in R^3 stays in R^3, every surviving vertex at its original position *)
VerificationTest[
    With[{g = Graph3D @ GridGraph[{3, 3, 3}]},
        {h = BoundarylessGraph[g]},
        {Last @ Dimensions @ GraphEmbedding[h],
         GraphEmbedding[h] === Lookup[AssociationThread[VertexList[g], GraphEmbedding[g]], VertexList[h]]}
    ],
    {3, True},
    TestID -> "BoundarylessGraph-3D-coordinates"
]

(* A planar substrate stays planar *)
VerificationTest[
    Last @ Dimensions @ GraphEmbedding @ BoundarylessGraph @ GridGraph[{5, 5}],
    2,
    TestID -> "BoundarylessGraph-2D-coordinates"
]

(* ===== CenterGraph ===== *)

VerificationTest[
	With[
		{g = GridGraph[{5, 7}]},
		Sort @ VertexList @ CenterGraph[g, 0] === Sort @ GraphCenter[g]
	],
	True,
	TestID -> "CenterGraph-at-zero-is-the-center"
]

VerificationTest[
	With[
		{g = GridGraph[{5, 7}]},
		Sort @ VertexList @ CenterGraph[g, 1] === Sort @ VertexList[g] &&
			Sort @ VertexList @ CenterGraph[g] === Sort @ VertexList[g] &&
			Sort @ VertexList @ CenterGraph[g, 3] === Sort @ VertexList[g] &&
			Sort @ VertexList @ CenterGraph[g, -1] === Sort @ GraphCenter[g]
	],
	True,
	TestID -> "CenterGraph-endpoints-and-clipping"
]

VerificationTest[
	With[
		{g = GridGraph[{5, 7}]},
		{r = GraphRadius[g]},
		{pools = Sort @ VertexList @ CenterGraph[g, #/r] & /@ Range[0, r]},
		AllTrue[Partition[pools, 2, 1], Apply[SubsetQ[#2, #1] &]] &&
			AllTrue[Transpose[{pools, Range[0, r]}],
				Apply[{pool, k} |-> AllTrue[pool, v |-> GraphDistance[g, v, First @ GraphCenter[g]] <= k + r]]]
	],
	True,
	TestID -> "CenterGraph-monotone-in-q"
]

VerificationTest[
	With[
		{g = GridGraph[{5, 5}, VertexCoordinates -> Tuples[Range[5], 2]]},
		{h = CenterGraph[g, 1/2]},
		{coords = AssociationThread[VertexList[g], GraphEmbedding[g]]},
		SubsetQ[VertexList[g], VertexList[h]] &&
			GraphEmbedding[h] === Lookup[coords, VertexList[h]] &&
			AllTrue[EdgeList[h], EdgeQ[g, #] &]
	],
	True,
	TestID -> "CenterGraph-keeps-labels-and-coordinates"
]

VerificationTest[
	With[
		{g = CycleGraph[9]},
		AllTrue[{0, 1/2, 1}, q |-> Sort @ VertexList @ CenterGraph[g, q] === Sort @ VertexList[g]]
	],
	True,
	TestID -> "CenterGraph-vertex-transitive-is-its-own-center"
]

VerificationTest[
	With[
		{g = GraphDisjointUnion[PathGraph[Range[4]], PathGraph[Range[3]]]},
		CenterGraph[g, 1/2] === g
	],
	True,
	TestID -> "CenterGraph-disconnected-returns-the-graph"
]

EndTestSection[]
