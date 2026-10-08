Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: InfraSubstrates :: Boundary *)

GraphExteriorBoundary[ g_Graph ] :=
	With[
		{ adjacency = AdjacencyMatrix[ g ] },
		{ onTriangle = Thread[ Total[ adjacency * adjacency . adjacency, { 2 } ] > 0 ] },
		If[ ! And @@ onTriangle,
			Pick[ VertexList[ g ], Thread[ VertexDegree[ g ] < Max @ VertexDegree[ g ] ] ],
			With[
				{ links = Subgraph[ g, AdjacencyList[ g, # ] ] & /@ VertexList[ g ] },
				{ cycles = Map[ link |-> ConnectedGraphQ[ link ] && Union @ VertexDegree[ link ] === { 2 }, links ] },
				(* a link that is a cycle of length at least four marks a surface; in a mesh of tetrahedra a link is a triangulated sphere, open when an edge lies on exactly one of its triangles *)
				Pick[ VertexList[ g ], If[ AnyTrue[ Pick[ links, cycles ], VertexCount[ # ] > 3 & ],
					Not /@ cycles,
					Map[ link |-> MemberQ[ Flatten @ Normal[ # * # . # ] & @ AdjacencyMatrix[ link ], 1 ], links ] ] ]
			]
		]
	]

GraphExteriorBoundary[ mr_MeshRegion ] :=
	With[
		{ d = RegionDimension[ mr ] },
		If[ d <= 1,
			{},
			Union @@ Keys @ Select[ Counts[ Sort /@ Catenate[ Subsets[ First[ # ], { d } ] & /@ MeshCells[ mr, d ] ] ], # == 1 & ]
		]
	]

Options[ BoundarylessGraph ] = Join[ { "KeepCoordinates" -> True }, Options[ Graph ] ]

BoundarylessGraph[ g_Graph, opts : OptionsPattern[] ] /; SubsetQ[ Keys @ Options @ BoundarylessGraph, Keys @ { opts } ] :=
	With[
		{ coords = AssociationThread[ VertexList[ g ], GraphEmbedding[ g ] ],
		 bQ = Association @ Thread[ GraphExteriorBoundary[ g ] -> True ] },
		{ trimmed = EdgeDelete[ g, Select[ EdgeList[ g ], TrueQ[ bQ[ #[[ 1 ]] ] ] && TrueQ[ bQ[ #[[ 2 ]] ] ] & ] ] },
		{ h = VertexDelete[ trimmed, Pick[ VertexList[ trimmed ], VertexDegree[ trimmed ], 0 ] ] },
		If[ Length @ First @ coords === 3, Graph3D, Graph ][ h,
			Sequence @@ FilterRules[ { opts }, Options[ Graph ] ],
			Sequence @@ If[ TrueQ @ OptionValue[ "KeepCoordinates" ],
				{ VertexCoordinates -> Lookup[ coords, VertexList[ h ] ] }, {} ] ]
	]

BoundarylessGraph[ mr_MeshRegion, opts : OptionsPattern[] ] /; SubsetQ[ Keys @ Options @ BoundarylessGraph, Keys @ { opts } ] :=
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

CenterGraph[ graph_Graph, hops_Integer : 0 ] :=
	If[ ! ConnectedGraphQ[ graph ],
		graph,
		NeighborhoodGraph[ graph, GraphCenter[ graph ], If[ hops < 0, Max[ 0, GraphRadius[ graph ] + hops ], hops ] ]
	]

CenterGraph[ graph_Graph, Scaled[ fraction_?NumericQ ] ] :=
	If[ ! ConnectedGraphQ[ graph ],
		graph,
		CenterGraph[ graph, Floor[ Clip[ fraction, { 0, 1 } ] * GraphRadius[ graph ] ] ]
	]
