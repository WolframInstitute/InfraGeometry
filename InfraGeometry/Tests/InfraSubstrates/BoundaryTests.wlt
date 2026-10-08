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

(* ===== GraphExteriorBoundary: one rule, the rim is where the neighbourhood is not closed ===== *)

(* a lattice: the vertices of less than full degree; a closed lattice has no rim *)
VerificationTest[
    {Sort @ GraphExteriorBoundary[GridGraph[{5, 5}]] ==
       Sort @ Pick[VertexList @ #, Thread[VertexDegree @ # < 4]] & @ GridGraph[{5, 5}],
     GraphExteriorBoundary[TorusGraph[{5, 5}]]},
    {True, {}},
    TestID -> "GraphExteriorBoundary-degree-rim"
]

VerificationTest[
    Length @ GraphExteriorBoundary[GridGraph[{7, 7}]],
    24,
    TestID -> "GraphExteriorBoundary-grid-7x7"
]

(* the cubic grid: the 98 face vertices, not the 44 below the average degree *)
VerificationTest[
    Length @ GraphExteriorBoundary[GridGraph[{5, 5, 5}]],
    98,
    TestID -> "GraphExteriorBoundary-cubic-grid-faces"
]

(* the tiling balls of radius 4: the vertices of less than full degree, as before *)
VerificationTest[
    Map[t |-> With[{g = TessellationNeighborhoodGraph[t, 4]},
        Sort @ GraphExteriorBoundary[g] === Sort @ Pick[VertexList @ g, Thread[VertexDegree @ g < Max @ VertexDegree @ g]]],
      {{3, 6}, {6, 3}, {7, 3}, {3, 7}}],
    {True, True, True, True},
    TestID -> "GraphExteriorBoundary-tiling-balls-unchanged"
]

VerificationTest[
    Length @ GraphExteriorBoundary[TessellationNeighborhoodGraph[{3, 6}, 4]],
    24,
    TestID -> "GraphExteriorBoundary-triangular-ball"
]

(* the hexagonal ball has the vertices of less than full degree as its rim, not its outer face *)
VerificationTest[
    Length @ GraphExteriorBoundary[TessellationNeighborhoodGraph[{6, 3}, 4]],
    12,
    TestID -> "GraphExteriorBoundary-hexagonal-ball"
]

VerificationTest[
    Length @ GraphExteriorBoundary[TessellationNeighborhoodGraph[{7, 3}, 4]],
    18,
    TestID -> "GraphExteriorBoundary-heptagonal-ball"
]

VerificationTest[
    Length @ GraphExteriorBoundary[TessellationNeighborhoodGraph[{3, 7}, 4]],
    147,
    TestID -> "GraphExteriorBoundary-hyperbolic-triangular-ball"
]

(* a mesh graph: the graph form finds the exact surface vertices of the mesh form *)
VerificationTest[
    With[{mr = DiscretizeRegion[Disk[], MaxCellMeasure -> 0.01]},
        {g = Graph[Range @ MeshCellCount[mr, 0], UndirectedEdge @@@ (First /@ MeshCells[mr, 1])]},
        {Length @ GraphExteriorBoundary[mr], Sort @ GraphExteriorBoundary[g] === Sort @ GraphExteriorBoundary[mr]}],
    {43, True},
    TestID -> "GraphExteriorBoundary-disk-mesh-graph"
]

VerificationTest[
    With[{mr = DiscretizeRegion[Rectangle[], MaxCellMeasure -> 0.0085, PrecisionGoal -> Infinity]},
        {g = Graph[Range @ MeshCellCount[mr, 0], UndirectedEdge @@@ (First /@ MeshCells[mr, 1])]},
        {Length @ GraphExteriorBoundary[mr], Sort @ GraphExteriorBoundary[g] === Sort @ GraphExteriorBoundary[mr]}],
    {28, True},
    TestID -> "GraphExteriorBoundary-rectangle-mesh-graph"
]

(* a closed surface has no rim *)
VerificationTest[
    With[{mr = DiscretizeRegion[Sphere[], MaxCellMeasure -> {"Area" -> 0.1}, PrecisionGoal -> 1]},
        GraphExteriorBoundary @ Graph[Range @ MeshCellCount[mr, 0], UndirectedEdge @@@ (First /@ MeshCells[mr, 1])]],
    {},
    TestID -> "GraphExteriorBoundary-sphere-mesh-graph"
]

(* a mesh of tetrahedra: no link is a cycle longer than three, and the rim is the vertices
   whose link has an edge on exactly one of its triangles; at the second size a corner of the
   cube has a triangle as its link, which a surface would read as closed *)
VerificationTest[
    Map[m |-> With[{mr = DiscretizeRegion[Cuboid[], MaxCellMeasure -> m, PrecisionGoal -> Infinity]},
        {g = Graph[Range @ MeshCellCount[mr, 0], UndirectedEdge @@@ (First /@ MeshCells[mr, 1])]},
        {Length @ GraphExteriorBoundary[mr], Sort @ GraphExteriorBoundary[g] === Sort @ GraphExteriorBoundary[mr]}],
      {0.004, 0.00133}],
    {{126, True}, {257, True}},
    TestID -> "GraphExteriorBoundary-cube-mesh-graph"
]

(* the rule applies to any graph: a tree gives its leaves and its root *)
VerificationTest[
    Sort @ GraphExteriorBoundary[KaryTree[63]],
    Prepend[Range[32, 63], 1],
    TestID -> "GraphExteriorBoundary-tree-leaves-and-root"
]

(* no method any more: a call with one stays unevaluated *)
VerificationTest[
    {Head @ GraphExteriorBoundary[GridGraph[{5, 5}], Method -> "MaxDegree"],
     Head @ BoundarylessGraph[GridGraph[{5, 5}], Method -> "MaxDegree"]},
    {GraphExteriorBoundary, BoundarylessGraph},
    TestID -> "GraphExteriorBoundary-method-unevaluated"
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

(* a mesh substrate: the graph form deletes the same edges and vertices as the mesh form *)
VerificationTest[
    Map[mr |-> With[{g = Graph[Range @ MeshCellCount[mr, 0], UndirectedEdge @@@ (First /@ MeshCells[mr, 1])]},
        {a = BoundarylessGraph[g], b = BoundarylessGraph[mr]},
        Sort @ VertexList[a] === Sort @ VertexList[b] && Sort[Sort /@ List @@@ EdgeList[a]] === Sort[Sort /@ List @@@ EdgeList[b]]],
      {DiscretizeRegion[Rectangle[], MaxCellMeasure -> 0.0085, PrecisionGoal -> Infinity],
       DiscretizeRegion[Cuboid[], MaxCellMeasure -> 0.004, PrecisionGoal -> Infinity]}],
    {True, True},
    TestID -> "BoundarylessGraph-mesh-graph-equals-mesh-form"
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
		Sort @ VertexList @ CenterGraph[g] === Sort @ VertexList @ CenterGraph[g, 0] === Sort @ GraphCenter[g]
	],
	True,
	TestID -> "CenterGraph-default-and-zero-are-the-center"
]

VerificationTest[
	With[
		{g = GridGraph[{5, 7}]},
		{r = GraphRadius[g]},
		AllTrue[Range[0, r + 2], k |-> Sort @ VertexList @ CenterGraph[g, k] === Sort @ VertexList @ NeighborhoodGraph[g, GraphCenter[g], k]] &&
			Sort @ VertexList @ CenterGraph[g, r] === Sort @ VertexList[g]
	],
	True,
	TestID -> "CenterGraph-hops-are-the-ball-about-the-center"
]

VerificationTest[
	With[
		{g = GridGraph[{5, 7}]},
		{r = GraphRadius[g]},
		AllTrue[Range[r], k |-> Sort @ VertexList @ CenterGraph[g, -k] === Sort @ VertexList @ CenterGraph[g, r - k]] &&
			Sort @ VertexList @ CenterGraph[g, -r - 3] === Sort @ GraphCenter[g]
	],
	True,
	TestID -> "CenterGraph-negative-counts-back-from-the-radius"
]

VerificationTest[
	With[
		{g = NeighborhoodGraph[GridGraph[{9, 9}], 41, 4]},
		Sort @ VertexList @ CenterGraph[g, -1] === Sort @ Pick[VertexList[g], VertexDegree[g], 4]
	],
	True,
	TestID -> "CenterGraph-minus-one-drops-the-rim-of-a-round-patch"
]

VerificationTest[
	With[
		{g = GridGraph[{5, 7}]},
		{r = GraphRadius[g]},
		AllTrue[{0, 1/4, 1/2, 0.9, 1}, q |-> Sort @ VertexList @ CenterGraph[g, Scaled[q]] === Sort @ VertexList @ CenterGraph[g, Floor[q r]]] &&
			Sort @ VertexList @ CenterGraph[g, Scaled[3/2]] === Sort @ VertexList[g] &&
			Sort @ VertexList @ CenterGraph[g, Scaled[-1]] === Sort @ GraphCenter[g]
	],
	True,
	TestID -> "CenterGraph-scaled-is-a-fraction-of-the-radius"
]

VerificationTest[
	Head @ CenterGraph[GridGraph[{5, 7}], 0.9],
	CenterGraph,
	TestID -> "CenterGraph-bare-fraction-stays-unevaluated"
]

VerificationTest[
	With[
		{g = GridGraph[{5, 5}, VertexCoordinates -> Tuples[Range[5], 2]]},
		{h = CenterGraph[g, 2]},
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
		AllTrue[{0, 2, -1, -100, Scaled[1/2]}, k |-> Sort @ VertexList @ CenterGraph[g, k] === Sort @ VertexList[g]]
	],
	True,
	TestID -> "CenterGraph-vertex-transitive-is-its-own-center"
]

VerificationTest[
	With[
		{g = GraphDisjointUnion[PathGraph[Range[4]], PathGraph[Range[3]]]},
		CenterGraph[g, 2] === g && CenterGraph[g, -1] === g && CenterGraph[g, Scaled[1/2]] === g
	],
	True,
	TestID -> "CenterGraph-disconnected-returns-the-graph"
]

EndTestSection[]
