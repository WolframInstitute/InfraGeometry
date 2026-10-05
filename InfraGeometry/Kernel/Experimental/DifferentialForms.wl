Package[ "WolframInstitute`InfraGeometry`" ]

FormValue[ omega_, v_, tuple_List ] :=
  Signature[ tuple ] * Lookup[ Lookup[ omega, Key[ v ], <| |> ], Key[ Sort[ tuple ] ], 0 ]

CochainValue[ alpha_, tuple_List ] :=
  Signature[ tuple ] * Lookup[ alpha, Key[ Sort[ tuple ] ], 0 ]

OrderedCochainValue[ alpha_, tuple_List ] :=
    If[ OrderedQ[ tuple ] && DuplicateFreeQ[ tuple ],
        Lookup[ alpha, Key[ tuple ], 0 ],
        Missing[ "NonIncreasingTuple", tuple ]
    ]

FormDegree[ omega_ ] :=
  Length @ First @ Keys @ First @ Select[ Values[ omega ], # =!= <| |> & ]
CochainDegree[ alpha_ ] :=
  Length[ First[ Keys[ alpha ] ] ] - 1

ZeroForm[ g_, f_ ] :=
  AssociationMap[ v |-> <| {} -> f[ v ] |>, VertexList[ g ] ]

RestrictionMap[ g_, alpha_ ] :=
  GroupBy[
      Flatten @ Table[
          With[ { face = DeleteCases[ clique, v ] }, v -> (face -> CochainValue[ alpha, Prepend[ face, v ] ]) ],
          { clique, Keys[ alpha ] }, { v, clique }
      ],
      First -> Last,
      DeleteCases[ 0 ] @* Association
  ]

(* I : form -> cochain, (I omega)(v0..vk) = 1/(k+1) sum_i (-1)^i omega_{v_i}(v0..^vi..vk) *)
IntegrationMap[ g_, omega_ ] :=
  If[ AllTrue[ Values[ omega ], # === <| |> & ], <| |>, With[ { k = FormDegree[ omega ] },
      DeleteCases[ 0 ] @ Association @ Map[
          clique |-> clique -> Sum[ (-1)^(i - 1) FormValue[ omega, clique[[ i ]], Delete[ clique, i ] ], { i, k + 1 } ] / (k + 1),
          Union[ Sort /@ (Union @@ (Subsets[ #, { k + 1, k + 1 } ] & /@ FindClique[ g, { k + 1, Infinity }, All ])) ]
      ]
  ] ]

(* coboundary delta on cochains, (delta alpha)(v0..v_{k+1}) = sum_i (-1)^i alpha(v0..^vi..v_{k+1}) *)
Coboundary[ g_, alpha_ ] :=
  If[ alpha === <| |>, <| |>, With[ { k = CochainDegree[ alpha ] },
      DeleteCases[ 0 ] @ Association @ Map[
          clique |-> clique -> Sum[ (-1)^(i - 1) Lookup[ alpha, Key[ Delete[ clique, i ] ], 0 ], { i, k + 2 } ],
          Union[ Sort /@ (Union @@ (Subsets[ #, { k + 2, k + 2 } ] & /@ FindClique[ g, { k + 2, Infinity }, All ])) ]
      ]
  ] ]

FormDifferential[ g_, omega_ ] :=
  Which[
      AllTrue[ Values[ omega ], # === <| |> & ], <| |>,
      FormDegree[ omega ] == 0, AssociationMap[
          v |-> DeleteCases[ 0 ] @ Association @ Map[ w |-> { w } -> FormValue[ omega, w, {} ] - FormValue[ omega, v, {} ], AdjacencyList[ g, v ] ],
          VertexList[ g ]
      ],
      True, AssociationMap[
          v |-> DeleteCases[ 0 ] @ Association @ Map[
              pair |-> pair -> FormValue[ omega, v, { pair[[ 1 ]] } ] - FormValue[ omega, v, { pair[[ 2 ]] } ] +
                  (FormValue[ omega, pair[[ 1 ]], { pair[[ 2 ]] } ] - FormValue[ omega, pair[[ 2 ]], { pair[[ 1 ]] } ]) / 2,
              Subsets[ Sort @ AdjacencyList[ g, v ], { 2 } ]
          ],
          VertexList[ g ]
      ]
  ]

NaiveDifferential[ g_, omega_ ] :=
  If[ AllTrue[ Values[ omega ], # === <| |> & ], <| |>, AssociationMap[
      v |-> DeleteCases[ 0 ] @ Association @ Map[
          pair |-> pair -> FormValue[ omega, v, { pair[[ 1 ]] } ] - FormValue[ omega, v, { pair[[ 2 ]] } ],
          Subsets[ Sort @ AdjacencyList[ g, v ], { 2 } ]
      ],
      VertexList[ g ]
  ] ]

(* wedge product of forms, the exterior product on each Lambda(T_v G)^* (a shuffle sum) *)
FormWedge[ omega_, eta_ ] :=
  If[ AllTrue[ Values[ omega ], # === <| |> & ] || AllTrue[ Values[ eta ], # === <| |> & ], <| |>,
      AssociationMap[
          v |-> With[ { a = Lookup[ omega, Key[ v ], <| |> ], b = Lookup[ eta, Key[ v ], <| |> ] },
              DeleteCases[ 0 ] @ Merge[
                  Flatten @ Table[
                      If[ DisjointQ[ s1, s2 ], Union[ s1, s2 ] -> Signature[ Join[ s1, s2 ] ] Lookup[ a, Key[ s1 ], 0 ] Lookup[ b, Key[ s2 ], 0 ],
                        Nothing ],
                      { s1, Keys[ a ] }, { s2, Keys[ b ] }
                  ],
                  Total
              ]
          ],
          Intersection[ Keys[ omega ], Keys[ eta ] ]
      ]
  ]

OrderedCochainCup[ g_, alpha_, beta_ ] :=
  If[ alpha === <| |> || beta === <| |>, <| |>, With[ { p = CochainDegree[ alpha ], q = CochainDegree[ beta ] },
      DeleteCases[ 0 ] @ Association @ Map[
          clique |-> clique -> Lookup[ alpha, Key[ Take[ clique, p + 1 ] ], 0 ] Lookup[ beta, Key[ Take[ clique, -(q + 1) ] ], 0 ],
          Union[ Sort /@ (Union @@ (Subsets[ #, { p + q + 1, p + q + 1 } ] & /@ FindClique[ g, { p + q + 1, Infinity }, All ])) ]
      ]
  ] ]

(* Steenrod cup-1 product on ORDERED cochains: the primitive measuring the failure of the
   Alexander-Whitney cup to be graded-commutative. For closed alpha, beta,
     delta(alpha cup_1 beta) = OrderedCochainCup[alpha, beta] - (-1)^(p q) OrderedCochainCup[beta, alpha],
   so the graded commutator of cocycles is exact with this explicit primitive. Zero when
   p = 0. Verified for 1 <= p, q <= 3 on K6. *)
CochainCupOne[ g_, alpha_, beta_ ] :=
  If[ alpha === <| |> || beta === <| |>, <| |>, With[ { p = CochainDegree[ alpha ], q = CochainDegree[ beta ] },
      DeleteCases[ 0 ] @ Association @ Map[
          clique |-> clique -> Sum[
              (-1)^((p - i) (q + 1) + p + q + 1) *
                  Lookup[ alpha, Key[ Join[ Take[ clique, i + 1 ], Take[ clique, { i + q + 1, p + q } ] ] ], 0 ] *
                  Lookup[ beta, Key[ Take[ clique, { i + 1, i + q + 1 } ] ], 0 ],
              { i, 0, p - 1 }
          ],
          Union[ Sort /@ (Union @@ (Subsets[ #, { p + q, p + q } ] & /@ FindClique[ g, { p + q, Infinity }, All ])) ]
      ]
  ] ]

(* THE cup product, on ALTERNATING cochains: the full antisymmetrisation of the
   Alexander-Whitney product. Orientation-invariant, unital, graded-commutative, a
   derivation for the coboundary, and NOT associative. The 1/(p+q+1)! normalisation is not
   a choice: it is the one under which this product agrees with the cup product on
   cohomology (checked on the 4x4 torus, where doubling it changes the H^2 class). *)
CochainCup[ g_, alpha_, beta_ ] :=
  If[ alpha === <| |> || beta === <| |>, <| |>, With[ { p = CochainDegree[ alpha ], q = CochainDegree[ beta ] },
      DeleteCases[ 0 ] @ Association @ Map[
          clique |-> clique -> Sum[
              Signature[ perm ] CochainValue[ alpha, Take[ perm, p + 1 ] ] CochainValue[ beta, Take[ perm, -(q + 1) ] ],
              { perm, Permutations[ clique ] }
          ] / (p + q + 1)!,
          Union[ Sort /@ (Union @@ (Subsets[ #, { p + q + 1, p + q + 1 } ] & /@ FindClique[ g, { p + q + 1, Infinity }, All ])) ]
      ]
  ] ]

AntisymmetrizedCup[ g_, alpha_, beta_ ] :=
  CochainCup[ g, alpha, beta ]
