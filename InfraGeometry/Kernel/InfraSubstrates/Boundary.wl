Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: InfraSubstrates :: Boundary *)

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

CenterGraph[ g_Graph, q : _?NumericQ : 1 ] :=
	If[ ! ConnectedGraphQ[ g ],
		g,
		NeighborhoodGraph[ g, GraphCenter[ g ], Floor[ Clip[ q, { 0, 1 } ] * GraphRadius[ g ] ] ]
	]
