Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: Experimental :: OllivierCurvature *)

(* kappa(u, v) = 1 - W_1(mu_u, mu_v) / d(u, v),
   mu_x = uniform on the open neighborhood N(x); idleness alpha = 0;
   W_1 is the Wasserstein-1 (Earth-Mover) distance under graph distance,
   solved as a transport LP via LinearOptimization. *)

OllivierRicciCurvature[ g_Graph ] :=
  With[
    { vs = VertexList[ g ], dist = GraphDistanceMatrix[ g ] },
    { idx = AssociationThread[ vs, Range @ Length @ vs ], adj = AssociationMap[ AdjacencyList[ g, # ] &, vs ] },
    AssociationMap[
      e |-> With[
        { nu = adj[ e[[ 1 ]] ], nv = adj[ e[[ 2 ]] ] },
        { m = Length[ nu ], n = Length[ nv ], costs = dist[[ idx /@ nu, idx /@ nv ]], vars = Array[ t, { Length[ nu ], Length[ nv ] } ] },
        1 - LinearOptimization[
          Total[ Flatten[ costs * vars ] ],
          Join[
            Table[ Total[ vars[[ i, All ]] ] == 1.0 / m, { i, m } ],
            Table[ Total[ vars[[ All, j ]] ] == 1.0 / n, { j, n } ],
            Thread[ Flatten[ vars ] >= 0 ]
          ],
          Flatten[ vars ],
          "PrimalMinimumValue"
        ] / dist[[ idx[ e[[ 1 ]] ], idx[ e[[ 2 ]] ] ]]
      ],
      EdgeList[ g ]
    ]
  ]

(* Klein-Randic resistance distance R(u, v) = (e_u - e_v)^T L^+ (e_u - e_v),
   where L^+ is the Moore-Penrose pseudoinverse of the graph Laplacian
   (= the 0-block of GreenOperatorMatrix[GraphComplex[g]]).  Three forms:
   pair, full V x V matrix, submatrix on a vertex list. *)

EffectiveResistance[ g_Graph ] :=
  With[
    { lp = PseudoInverse[ N @ Normal @ KirchhoffMatrix[ g ] ], n = VertexCount[ g ] },
    { d = Diagonal[ lp ] },
    Table[ d[[ i ]] + d[[ j ]] - 2 lp[[ i, j ]], { i, n }, { j, n } ]
  ]

EffectiveResistance[ g_Graph, u_, v_ ] /; MemberQ[ VertexList[ g ], u ] && MemberQ[ VertexList[ g ], v ] :=
    With[ { lp = PseudoInverse[ N @ Normal @ KirchhoffMatrix[ g ] ],
          idx = AssociationThread[ VertexList[ g ], Range @ VertexCount[ g ] ] },
        With[ { i = idx[ u ], j = idx[ v ] },
            lp[[ i, i ]] + lp[[ j, j ]] - 2 lp[[ i, j ]]
        ]
    ]

EffectiveResistance[ g_Graph, vs_List ] /; SubsetQ[ VertexList[ g ], vs ] :=
    With[ { full = EffectiveResistance[ g ],
          ix = AssociationThread[ VertexList[ g ], Range @ VertexCount[ g ] ] /@ vs },
        full[[ ix, ix ]]
    ]

(* Klein-Randic / Schoenberg negative-type predicate: a real symmetric
   n x n matrix R with zero diagonal is realisable as a resistance
   distance matrix iff the centred Gram matrix
       B[i, j] = (R[1, j] + R[i, 1] - R[i, j]) / 2,  i, j >= 2
   is positive semidefinite. *)

ResistanceQ[ r_ ? MatrixQ ] :=
    SquareMatrixQ[ r ] &&
    (Transpose[ r ] === r || N @ Transpose[ r ] == N @ r) &&
    AllTrue[ Diagonal[ r ], # == 0 & ] &&
    With[ { n = Length[ r ] },
        n <= 1 || AllTrue[
            Eigenvalues[ N @ Table[ (r[[ 1, j ]] + r[[ i, 1 ]] - r[[ i, j ]]) / 2, { i, 2, n }, { j, 2, n } ] ],
            # >= -10^-9 &
        ]
    ]

ResistanceQ[ _ ] :=
  False
