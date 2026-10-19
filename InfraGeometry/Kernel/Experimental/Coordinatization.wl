Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: Experimental :: Coordinatization *)

(* the distance vector (d(v, b1), ..., d(v, bk)).  An anchor is a vertex, a set, a density
   or a walk graph; "AnchorAggregation" reduces its support to one distance.  On a bare
   vertex density gives <| v -> 1 |>, on which every aggregation is the distance itself,
   so the crisp case needs no separate rule. *)

Options[ RadarCoordinates ] = { "AnchorAggregation" -> Min }

RadarCoordinates[ g_Graph, b_List, v : Except[ _Rule | _RuleDelayed | _Association ], opts : OptionsPattern[] ] /;
  MemberQ[ VertexList[ g ], v ] :=
  With[ { agg = OptionValue[ "AnchorAggregation" ] },
    ( anchor |-> agg[ GraphDistance[ g, v, # ] & /@ Keys @ InfraMeasurement[ g, anchor, "VertexDensity" ] ] ) /@ b
  ]

(* Outer over a basis of vertices stays the fast path: one GraphDistance call per (vertex, anchor).
   VertexQ, not a head test, since a vertex name may itself be a list. *)
RadarCoordinates[ g_Graph, b_List, opts : OptionsPattern[] ] :=
  AssociationThread[ VertexList[ g ],
    If[ AllTrue[ b, VertexQ[ g, # ] & ],
      Outer[ GraphDistance[ g, #1, #2 ] &, VertexList[ g ], b, 1 ],
      RadarCoordinates[ g, b, #, opts ] & /@ VertexList[ g ]
    ]
  ]

RadarCoordinates[ g_Graph, b_List, fam_Association, opts : OptionsPattern[] ] /;
  SubsetQ[ VertexList[ g ], Keys @ fam ] :=
  If[ Length[ fam ] === 1,
    RadarCoordinates[ g, b, First @ Keys @ fam, opts ],
    RadarCoordinates[ g, b, #, opts ] & /@ Keys @ fam ]

(* b resolves g iff the radar map v |-> (d(v, b_i))_i is injective over V(g) *)
ResolvingSetQ[ g_Graph, b_List ] :=
    DuplicateFreeQ[ Outer[ GraphDistance[ g, #1, #2 ] &, VertexList[ g ], b, 1 ] ]

FindResolvingSet[ g_Graph, n_Integer : 1, m_ : All ] :=
  With[
    { v = VertexList[ g ], dm = GraphDistanceMatrix[ g ], vc = VertexCount[ g ] },
    Map[
      v[[ # ]] &,
      First @ Fold[
        { state, k } |-> If[ Last[ state ],
          state,
          Rest @ NestWhile[
            Apply[ { mask, found, done } |-> With[
              { s = Pick[ Range[ vc ], IntegerDigits[ mask, 2, vc ], 1 ] },
              { next = If[ DuplicateFreeQ[ dm[[ All, s ]] ], Append[ found, s ], found ] },
              {
                If[ mask == 0, 1, With[ { c = BitAnd[ mask, -mask ] }, { r = mask + c }, BitOr[ r, Quotient[ BitXor[ r, mask ], 4 c ] ] ] ],
                next,
                Length[ next ] > Length[ found ] && Length[ next ] >= n
              }
            ] ],
            { 2 ^ k - 1, First[ state ], False },
            Apply[ { mask, found, done } |-> mask <= BitShiftLeft[ 2 ^ k - 1, vc - k ] && ! done ]
          ]
        ],
        { { }, False },
        Replace[ m, { All :> Range[ 0, vc ], _Integer :> Range[ 0, m ], { min_, max_ } :> Range[ min, max ], { num_ } :> { num } } ]
      ]
    ]
  ]

MetricDimension[ g_Graph ] :=
  Length @ First @ FindResolvingSet[ g, 1, All ]

Options[ ResistanceCoordinates ] = { "Rescaling" -> "ResistanceMatching", "Dimension" -> Automatic, "Origin" -> None }

(* spectral embedding Phi with ||Phi(u) - Phi(v)||^2 == EffectiveResistance(u, v)
   (Klein-Randic).  "Rescaling" -> "None" gives plain Laplacian eigenvectors,
   "Diffusion" -> t the diffusion-map embedding; "Origin" -> v recentres on v. *)
ResistanceCoordinates[ g_Graph, opts : OptionsPattern[] ] /; ConnectedGraphQ[ g ] :=
    With[ { es = Eigensystem[ N @ Normal @ KirchhoffMatrix[ g ] ], rescaling = OptionValue[ "Rescaling" ], dimSpec = OptionValue[ "Dimension" ],
        origin = OptionValue[ "Origin" ] },
        { ord = Ordering[ es[[ 1 ]] ] },
        { vals = es[[ 1, ord ]], vecs = es[[ 2, ord ]] },
        { keep = Select[ Range @ Length @ vals, vals[[ # ]] > 10^-10 Max[ Abs @ vals, 1 ] & ] },
        { idx = Take[ keep, Replace[ dimSpec, { Automatic | All :> Length[ keep ], UpTo[ k_Integer ] :> Min[ k, Length[ keep ] ], k_Integer :> Min[ k,
                  Length[ keep ] ] } ] ] },
        { weights = Replace[ rescaling,
            { "ResistanceMatching" :> 1 / Sqrt[ vals[[ idx ]] ], "None" :> ConstantArray[ 1, Length[ idx ] ],
              ("Diffusion" -> t_) :> Exp[ -t vals[[ idx ]] ] } ] },
        { mat = Transpose[ weights vecs[[ idx ]] ] },
        { originVec = If[ origin === None, ConstantArray[ 0., Length @ First @ mat ], mat[[ First @ FirstPosition[ VertexList[ g ], origin ] ]] ] },
        AssociationThread[ VertexList[ g ], # - originVec & /@ mat ]
    ]

ResistanceCoordinates[ g_Graph, v_, opts : OptionsPattern[] ] /; ConnectedGraphQ[ g ] && MemberQ[ VertexList[ g ], v ] :=
    ResistanceCoordinates[ g, opts ][ v ]

ResistanceCoordinates[ g_Graph, fam_Association, opts : OptionsPattern[] ] /; ConnectedGraphQ[ g ] && SubsetQ[ VertexList[ g ], Keys @ fam ] :=
  With[ { all = ResistanceCoordinates[ g, opts ] }, all /@ Keys @ fam ]
