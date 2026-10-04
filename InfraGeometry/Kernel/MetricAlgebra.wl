Package[ "WolframInstitute`InfraGeometry`" ]

(* I(u, v) = { w : d(u, w) + d(w, v) == d(u, v) }, the union of all geodesics from u to v *)

MetricInterval[ graph_Graph, u_, v_ ] :=
  With[ { d = GraphDistance[ graph, u, v ] },
    If[ d === Infinity, {},
      Select[ VertexList[ graph ],
        w |-> GraphDistance[ graph, u, w ] + GraphDistance[ graph, w, v ] == d
      ]
    ]
  ]

(* M[i, j] = (A^d)[i, j] with d = d(i, j): a walk of length d(i, j) is automatically a shortest path, so the entry counts the shortest paths *)

ShortestPathMultiplicityMatrix[ graph_Graph ] :=
  With[ { n = VertexCount @ graph, dMat = GraphDistanceMatrix @ graph, adjacency = Normal @ AdjacencyMatrix @ graph },
    { finite = Cases[ Flatten @ dMat, _Integer ] },
    { powers = NestList[ # . adjacency &, IdentityMatrix @ n, If[ finite === { }, 0, Max @ finite ] ] },
    Table[
      If[ dMat[[ i, j ]] === Infinity, 0, powers[[ dMat[[ i, j ]] + 1, i, j ]] ],
      { i, n }, { j, n } ] ]

(* argmin over w of Sum_x d(w, x) for x in vs; a graph is median iff every triple has a unique median, and median graphs are the 1-skeletons of
   CAT(0) cube complexes (Chepoi 2000, https://doi.org/10.1006/aama.1999.0681) *)

MedianVertices[ graph_Graph, vs_List ] :=
  With[ { V = VertexList[ graph ] },
    MinimalBy[ V,
      w |-> Total @ ( GraphDistance[ graph, w, # ] & /@ vs )
    ]
  ]

FindSegmentHull[ graph_Graph, s_ ] :=
  Union @ FixedPoint[
    T |-> Union[ T, Catenate @ Map[
      pair |-> MetricInterval[ graph, pair[[ 1 ]], pair[[ 2 ]] ], Subsets[ T, { 2 } ] ] ],
    Union @ Keys @ InfraDensity[ graph, s ]
  ]

SegmentHullQ[ graph_Graph, s_ ] :=
  With[ { vs = Keys @ InfraDensity[ graph, s ] }, FindSegmentHull[ graph, vs ] === vs ]
