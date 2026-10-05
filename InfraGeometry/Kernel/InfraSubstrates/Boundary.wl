Package[ "WolframInstitute`InfraGeometry`" ]

(* GraphBoundary[g, S]: inner vertex boundary. Two input forms, one notion (a
   vertex is boundary iff some g-edge at it escapes the given object):
     - vertex list S: the object is the INDUCED subgraph, so "escaping g-edge"
       means a neighbor outside S -- {v in S : v has a neighbor in V\S};
     - subgraph h (its own edges, e.g. a path/curve): {v in V(h) : v has a
       g-neighbor it is not joined to in h}. For an induced h this agrees with
       the list form; for a sparser h a curve is all boundary (every vertex has
       g-neighbors off the curve), so a 1-D object has empty interior. *)
GraphBoundary[ g_Graph, h_Graph ] :=
	With[ { hAdj = AssociationThread[ VertexList[ h ], AdjacencyList[ h ] ] },
		Select[ VertexList[ h ], ! SubsetQ[ Lookup[ hAdj, #, {} ], AdjacencyList[ g, # ] ] & ]
	]

GraphBoundary[ g_Graph, subset_List ] :=
	With[ { outside = Complement[ VertexList[ g ], subset ] },
		Select[ subset, IntersectingQ[ AdjacencyList[ g, # ], outside ] & ]
	]

GraphInterior[ g_Graph, h_Graph ] :=
	Complement[ VertexList[ h ], GraphBoundary[ g, h ] ]

GraphInterior[ g_Graph, subset_List ] :=
	Complement[ subset, GraphBoundary[ g, subset ] ]

Options[ GraphExteriorBoundary ] = { Method -> "AverageDegree" }

GraphExteriorBoundary[ g_Graph, OptionsPattern[] ] :=
	With[
		{ deg = AssociationThread[ VertexList[ g ], VertexDegree[ g ] ] },
		{ threshold = Switch[ OptionValue[ Method ] /. Automatic -> "AverageDegree",
			"AverageDegree", Mean[ N @ Values @ deg ],
			"MaxDegree", Max @ Values @ deg ] },
		Select[ VertexList[ g ], deg[ # ] < threshold & ]
	]

GraphExteriorBoundary[ mr_MeshRegion, OptionsPattern[] ] :=
	With[
		{ d = RegionDimension[ mr ] },
		If[ d <= 1,
			{},
			Union @@ Keys @ Select[ Counts[ Sort /@ Catenate[ Subsets[ First[ # ], { d } ] & /@ MeshCells[ mr, d ] ] ], # == 1 & ]
		]
	]

Options[ BoundarylessGraph ] = Join[ { Method -> "AverageDegree", "KeepCoordinates" -> True }, Options[ Graph ] ]

BoundarylessGraph[ g_Graph, opts : OptionsPattern[] ] :=
	With[
		{ coords = AssociationThread[ VertexList[ g ], GraphEmbedding[ g ] ],
		 bQ = Association @ Thread[ GraphExteriorBoundary[ g, Method -> OptionValue[ Method ] ] -> True ] },
		{ trimmed = EdgeDelete[ g, Select[ EdgeList[ g ], TrueQ[ bQ[ #[[ 1 ]] ] ] && TrueQ[ bQ[ #[[ 2 ]] ] ] & ] ] },
		{ h = VertexDelete[ trimmed, Pick[ VertexList[ trimmed ], VertexDegree[ trimmed ], 0 ] ] },
		If[ Length @ First @ coords === 3, Graph3D, Graph ][ h,
			Sequence @@ FilterRules[ { opts }, Options[ Graph ] ],
			Sequence @@ If[ TrueQ @ OptionValue[ "KeepCoordinates" ],
				{ VertexCoordinates -> Lookup[ coords, VertexList[ h ] ] }, {} ] ]
	]

BoundarylessGraph[ mr_MeshRegion, opts : OptionsPattern[] ] :=
	With[
		{ coords = MeshCoordinates[ mr ], edges = UndirectedEdge @@@ (First /@ MeshCells[ mr, 1 ]),
		 bQ = Association @ Thread[ GraphExteriorBoundary[ mr ] -> True ] },
		{ mesh = Graph[ Range @ Length @ coords, edges ] },
		{ trimmed = EdgeDelete[ mesh, Select[ EdgeList[ mesh ], TrueQ[ bQ[ #[[ 1 ]] ] ] && TrueQ[ bQ[ #[[ 2 ]] ] ] & ] ] },
		{ h = VertexDelete[ trimmed, Pick[ VertexList[ trimmed ], VertexDegree[ trimmed ], 0 ] ] },
		Graph[ h,
			Sequence @@ FilterRules[ { opts }, Options[ Graph ] ],
			Sequence @@ If[ TrueQ @ OptionValue[ "KeepCoordinates" ],
				{ VertexCoordinates -> coords[[ VertexList[ h ] ]] }, {} ] ]
	]

(* GraphEccentricities[x]: e(v) = max_w d(v, w), one per point in VertexList / row order --
   the list form VertexEccentricity lacks (it takes one vertex at a time). Absolute, in
   hops: the honest quantity, bounded by GraphRadius and GraphDiameter. *)

GraphEccentricities[ g_Graph ] :=
  GraphEccentricities @ GraphDistanceMatrix[ g ]

GraphEccentricities[ distMatrix_List ] :=
  Max /@ distMatrix

RelativeEccentricity[ x : (_Graph | _List) ] :=
	With[
		{ ecc = GraphEccentricities[ x ] },
		{ r = Min[ ecc ], d = Max[ ecc ] },
		If[ ! NumericQ[ d ] || d == r, ConstantArray[ 0, Length[ ecc ] ], (ecc - r) / (d - r) ]
	]

CenterGraph[ g_Graph, q : _?NumericQ : 1 ] :=
	If[ ! ConnectedGraphQ[ g ],
		g,
		NeighborhoodGraph[ g, GraphCenter[ g ], Floor[ Clip[ q, { 0, 1 } ] * GraphRadius[ g ] ] ]
	]
