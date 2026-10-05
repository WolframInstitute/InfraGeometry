Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: Experimental :: GraphBoundary *)

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
