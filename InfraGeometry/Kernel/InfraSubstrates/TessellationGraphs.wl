Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: InfraSubstrates :: TessellationGraphs *)

PackageScope[ regularMap ]
PackageScope[ triangleQuotientSearch ]

Options[ TessellationGraph ] = { Method -> Automatic }

TessellationGraph[ { p_Integer, q_Integer }, k : _Integer?Positive : 1, opts : OptionsPattern[ { TessellationGraph, Graph } ] ] /;
    OptionValue[ TessellationGraph, FilterRules[ { opts }, Options[ TessellationGraph ] ], Method ] === Automatic :=
  With[
    {
      map = If[ ( p - 2 ) ( q - 2 ) == 4,
        TorusTessellation[ { k, k }, <| { 4, 4 } -> "Square", { 3, 6 } -> "Triangular", { 6, 3 } -> "Hexagonal" |>[ { p, q } ] ],
        First @ regularMap[ { p, q }, k ]
      ]
    },
    Graph[ map, Sequence @@ FilterRules[ { opts }, Options[ Graph ] ] ] /; GraphQ[ map ]
  ]

TessellationGraph[ { p_Integer, q_Integer }, k : _Integer?Positive : 1, opts : OptionsPattern[ { TessellationGraph, Graph } ] ] /;
    OptionValue[ TessellationGraph, FilterRules[ { opts }, Options[ TessellationGraph ] ], Method ] === "PSL2" :=
  With[
    {
      found = First @ NestWhile[
        Apply[ { acc, previous } |-> With[
          { ell = NextPrime[ previous ] },
          {
            grp = PermutationGroup[
              ( { a, b, cc, d } |-> With[
                { pts = Append[ Range[ 0, ell - 1 ], Infinity ], ix = z |-> If[ z === Infinity, ell + 1, z + 1 ] },
                PermutationCycles @ Map[
                  ix @ Which[
                    # === Infinity, If[ Mod[ cc, ell ] == 0, Infinity, Mod[ a PowerMod[ cc, -1, ell ], ell ] ],
                    Mod[ cc # + d, ell ] == 0, Infinity,
                    True, Mod[ ( a # + b ) PowerMod[ Mod[ cc # + d, ell ], -1, ell ], ell ]
                  ] &,
                  pts
                ]
              ] ) @@@ { { 1, 1, 0, 1 }, { 0, -1, 1, 0 } }
            ]
          },
          { ord = GroupOrder[ grp ], e = GroupElements[ grp ] },
          { rs = Select[ e, PermutationOrder[ # ] == p & ], ss = Select[ e, PermutationOrder[ # ] == q & ] },
          {
            gens = Catch[
              Do[
                If[ PermutationOrder[ PermutationProduct[ r, s ] ] == 2 && GroupOrder[ PermutationGroup[ { r, s } ] ] == ord,
                  Throw[ { r, s } ]
                ],
                { r, rs },
                { s, ss }
              ];
              Missing[ "NotFound" ]
            ]
          },
          { If[ ListQ[ gens ], Append[ acc, gens ], acc ], ell }
        ] ],
        { { }, 1 },
        Apply[ { acc, ell } |-> Length[ acc ] < k && ell < 50 ]
      ]
    },
    TessellationGraph[ { p, q }, Last @ found, Sequence @@ FilterRules[ { opts }, Options[ Graph ] ] ] /; Length[ found ] >= k
  ]

TessellationGraph[ { p_Integer, q_Integer }, { m_Integer, n_Integer }, opts : OptionsPattern[ { TessellationGraph, Graph } ] ] :=
  With[ { g = TorusTessellation[ { m, n }, <| { 4, 4 } -> "Square", { 3, 6 } -> "Triangular", { 6, 3 } -> "Hexagonal" |>[ { p, q } ] ] },
    Graph[ g, Sequence @@ FilterRules[ { opts }, Options[ Graph ] ] ] /; GraphQ[ g ] ]

(* 1-skeleton of the regular map of type {p, q} carried by the (2,p,q)-generation
   r^p == s^q == (rs)^2 == 1: the coset graph on the vertex cosets G/<s>, joined by
   the edge-involution rs; V == |G|/q, E == |G|/2, F == |G|/p *)
TessellationGraph[ { p_Integer, q_Integer }, { r_Cycles, s_Cycles }, opts : OptionsPattern[ { TessellationGraph, Graph } ] ] :=
  With[
    { t = PermutationProduct[ r, s ], deg = Max[ PermutationMax[ r ], PermutationMax[ s ] ] },
    { sub = PermutationPower[ s, # ] & /@ Range[ 0, q - 1 ],
     els = GroupElements[ PermutationGroup[ { r, s } ] ] },
    { key = g |-> Sort[ PermutationList[ PermutationProduct[ g, # ], deg ] & /@ sub ] },
    { reps = DeleteDuplicatesBy[ els, key ] },
    { idx = AssociationThread[ key /@ reps -> Range[ Length[ reps ] ] ] },
    { map = Graph[ Range[ Length[ reps ] ],
      DeleteCases[
        DeleteDuplicates @ Flatten @ Table[
          UndirectedEdge @@ Sort[ { idx[ key[ g ] ], idx[ key[ PermutationProduct[ g, PermutationPower[ s, i ], t ] ] ] } ],
          { g, reps }, { i, 0, q - 1 } ],
        _?(Apply[ SameQ ]) ] ] },
    Graph[ map, Sequence @@ FilterRules[ { opts }, Options[ Graph ] ] ] ]

TessellationGraph[ { p_Integer, q_Integer }, group : _PermutationGroup | _SymmetricGroup | _AlternatingGroup | _CyclicGroup | _DihedralGroup | _AbelianGroup,
    opts : OptionsPattern[ { TessellationGraph, Graph } ] ] :=
  With[
    { order = GroupOrder[ group ], elements = GroupElements[ group ] },
    { rs = Select[ elements, PermutationOrder[ # ] == p & ], ss = Select[ elements, PermutationOrder[ # ] == q & ] },
    {
      generation = Catch[
        Do[
          If[ PermutationOrder[ PermutationProduct[ r, s ] ] == 2 && GroupOrder[ PermutationGroup[ { r, s } ] ] == order, Throw[ { r, s } ] ],
          { r, rs },
          { s, ss }
        ];
        Missing[ "NotFound" ]
      ]
    },
    TessellationGraph[ { p, q }, generation, opts ] /; ListQ[ generation ]
  ]

TessellationGraph[ config_List /; Length[ config ] >= 3, k : _Integer?Positive : 1, opts : OptionsPattern[ { TessellationGraph, Graph } ] ] /;
    OptionValue[ TessellationGraph, FilterRules[ { opts }, Options[ TessellationGraph ] ], Method ] === Automatic :=
  With[
    {
      defect = Total[ 1 / config ] - ( Length[ config ] - 2 ) / 2,
      key = First @ Sort @ Join[
        Table[ RotateLeft[ config, i ], { i, 0, Length[ config ] - 1 } ],
        Table[ RotateLeft[ Reverse @ config, i ], { i, 0, Length[ config ] - 1 } ]
      ],
      faceToEdges = face |-> Sort /@ Partition[ face, 2, 1, 1 ],
      boundaryEdges = face |-> UndirectedEdge @@@ Partition[ face, 2, 1, 1 ],
      cycleVertices = cycle |-> With[
        { vs = List @@@ cycle },
        { start = If[ MemberQ[ vs[[ 2 ]], vs[[ 1, 2 ]] ], vs[[ 1, 1 ]], vs[[ 1, 2 ]] ] },
        Most @ FoldList[ { prev, e } |-> First @ Complement[ e, { prev } ], start, vs ]
      ]
    },
    {
      vertexRotation = { vertex, faceEdges } |-> With[
        {
          corners = DeleteDuplicates @ Flatten[
            ( fl |-> Cases[ Transpose[ { fl, RotateLeft[ fl ] } ], { a_, b_ } /; MemberQ[ a, vertex ] && MemberQ[ b, vertex ] :> Sort[ { a, b } ] ] ) /@ faceEdges,
            1
          ]
        },
        cycleVertices @ First @ FindCycle[ Graph[ UndirectedEdge @@@ corners ], { Length @ DeleteDuplicates @ Flatten[ corners, 1 ] }, 1 ]
      ]
    },
    {
      rectify = { graph, faces } |-> With[
        { edgeFaces = faceToEdges /@ faces },
        { newFaces = Join[ edgeFaces, vertexRotation[ #, edgeFaces ] & /@ VertexList[ graph ] ] },
        { SimpleGraph @ Graph @ Flatten[ boundaryEdges /@ newFaces ], newFaces }
      ],
      truncate = { graph, faces } |-> With[
        { edgeFaces = faceToEdges /@ faces },
        {
          newFaces = Join[
            ( v |-> ( { v, # } & /@ vertexRotation[ v, edgeFaces ] ) ) /@ VertexList[ graph ],
            ( face |-> With[ { fe = faceToEdges @ face },
              Flatten[ Table[ { { face[[ i ]], fe[[ i ]] }, { face[[ Mod[ i, Length @ face ] + 1 ]], fe[[ i ]] } }, { i, Length @ face } ], 1 ] ] ) /@ faces
          ]
        },
        { SimpleGraph @ Graph @ Flatten[ boundaryEdges /@ newFaces ], newFaces }
      ]
    },
    {
      (* the operators read the rotation at a vertex off the faces, so they need a simple graph whose faces are cycles *)
      conway = { ops, graph, faces } |-> If[ SimpleGraphQ[ graph ] && AllTrue[ faces, DuplicateFreeQ ],
        First @ Fold[ { current, op } |-> op @@ current, { graph, faces }, ops ],
        Missing[ "NotAvailable" ]
      ],
      seed = Which[
        Length[ key ] == 4 && key[[ 1 ]] == key[[ 3 ]] && key[[ 2 ]] == key[[ 4 ]], { { rectify }, { key[[ 1 ]], key[[ 2 ]] } },
        Length[ key ] == 4 && key[[ 2 ]] == 4 && key[[ 4 ]] == 4, { { rectify, rectify }, { key[[ 1 ]], key[[ 3 ]] } },
        Length[ key ] == 3 && MemberQ[ key, 4 ], { { rectify, truncate }, DeleteCases[ key, 4 ] / 2 },
        Length[ key ] == 3 && Length[ Union @ key ] == 2,
        { { truncate }, { First[ Select[ key, Count[ key, # ] == 2 & ] ] / 2, First[ Select[ key, Count[ key, # ] == 1 & ] ] } },
        True, None
      ],
      torus = shape |-> {
        TorusTessellation[ { k, k }, shape ],
        Switch[ shape,
          "Square", Flatten[ Table[ { { i, j }, { Mod[ i + 1, k, 1 ], j }, { Mod[ i + 1, k, 1 ], Mod[ j + 1, k, 1 ] }, { i, Mod[ j + 1, k, 1 ] } }, { i, k }, { j, k } ], 1 ],
          "Triangular", Flatten[
            Table[
              { { { i, j }, { Mod[ i + 1, k ], j }, { Mod[ i + 1, k ], Mod[ j + 1, k ] } }, { { i, j }, { i, Mod[ j + 1, k ] }, { Mod[ i + 1, k ], Mod[ j + 1, k ] } } },
              { i, 0, k - 1 }, { j, 0, k - 1 }
            ],
            2
          ],
          "Hexagonal", Flatten[
            Table[
              {
                { i, j, 0 }, { i, j, 1 }, { Mod[ i + 1, k ], j, 0 }, { Mod[ i + 1, k ], Mod[ j - 1, k ], 1 },
                { Mod[ i + 1, k ], Mod[ j - 1, k ], 0 }, { i, Mod[ j - 1, k ], 1 }
              },
              { i, 0, k - 1 }, { j, 0, k - 1 }
            ],
            1
          ]
        ]
      }
    },
    {
      map = Which[
        Equal @@ config, TessellationGraph[ { First @ config, Length @ config }, k ],
        defect > 0 && k == 1 && Length[ config ] == 3 && Count[ config, 4 ] == 2,
        With[ { n = First @ DeleteCases[ config, 4 ] },
          Graph @ Join[
            Table[ UndirectedEdge[ { 1, i }, { 1, Mod[ i, n ] + 1 } ], { i, n } ],
            Table[ UndirectedEdge[ { 2, i }, { 2, Mod[ i, n ] + 1 } ], { i, n } ],
            Table[ UndirectedEdge[ { 1, i }, { 2, i } ], { i, n } ]
          ]
        ],
        defect > 0 && k == 1 && Length[ config ] == 4 && Count[ config, 3 ] == 3,
        With[ { n = First @ DeleteCases[ config, 3 ] },
          Graph @ Join[
            Table[ UndirectedEdge[ { 1, i }, { 1, Mod[ i, n ] + 1 } ], { i, n } ],
            Table[ UndirectedEdge[ { 2, i }, { 2, Mod[ i, n ] + 1 } ], { i, n } ],
            Table[ UndirectedEdge[ { 1, i }, { 2, i } ], { i, n } ],
            Table[ UndirectedEdge[ { 1, i }, { 2, Mod[ i, n ] + 1 } ], { i, n } ]
          ]
        ],
        defect == 0,
        Replace[ key, {
          { 3, 6, 3, 6 } :> conway[ { rectify }, Sequence @@ torus[ "Triangular" ] ],
          { 3, 4, 6, 4 } :> conway[ { rectify, rectify }, Sequence @@ torus[ "Triangular" ] ],
          { 4, 6, 12 } :> conway[ { rectify, truncate }, Sequence @@ torus[ "Triangular" ] ],
          { 4, 8, 8 } :> conway[ { truncate }, Sequence @@ torus[ "Square" ] ],
          { 3, 12, 12 } :> conway[ { truncate }, Sequence @@ torus[ "Hexagonal" ] ],
          _ :> Missing[ "NotAvailable" ]
        } ],
        seed === None, Missing[ "NotAvailable" ],
        True,
        With[ { parent = regularMap[ Last @ seed, k ] }, If[ ListQ[ parent ], conway[ First @ seed, Sequence @@ parent ], Missing[ "NotAvailable" ] ] ]
      ]
    },
    Graph[ map, Sequence @@ FilterRules[ { opts }, Options[ Graph ] ] ] /; GraphQ[ map ]
  ]

TorusTessellation[ { m_Integer, n_Integer }, opts : OptionsPattern[ ] ] :=
  TorusTessellation[ { m, n }, "Triangular", opts ]

TorusTessellation[ { m_Integer, n_Integer }, "Square", opts : OptionsPattern[ ] ] :=
  Graph[ GraphProduct[ CycleGraph[ m ], CycleGraph[ n ], "Cartesian" ], opts, VertexCoordinates -> Automatic ]

TorusTessellation[ { m_Integer, n_Integer }, "Triangular", opts : OptionsPattern[ ] ] :=
  Graph[
    Flatten @ Table[
      { { i, j } <-> { Mod[ i + 1, m ], j }
      , { i, j } <-> { i, Mod[ j + 1, n ] }
      , { i, j } <-> { Mod[ i + 1, m ], Mod[ j + 1, n ] } },
      { i, 0, m - 1 }, { j, 0, n - 1 }
    ],
    opts
  ]

TorusTessellation[ { m_Integer, n_Integer }, "Hexagonal", opts : OptionsPattern[ ] ] :=
  Graph[
    Flatten @ Table[
      { { i, j, 0 } <-> { i, j, 1 }
      , { i, j, 0 } <-> { Mod[ i - 1, m ], j, 1 }
      , { i, j, 0 } <-> { i, Mod[ j - 1, n ], 1 } },
      { i, 0, m - 1 }, { j, 0, n - 1 }
    ],
    opts
  ]

TessellationNeighborhoodGraph[ { p_Integer, q_Integer }, r_Integer : 3, opts : OptionsPattern[ Graph ] ] :=
  With[
    {
      geometry = Which[
        ( p - 2 ) ( q - 2 ) < 4,
        With[ { cR = Cot[ Pi / p ] Cot[ Pi / q ] }, { sR = Sqrt[ 1 - cR ^ 2 ] },
          {
            N @ Table[ { sR Cos[ 2 Pi k / p ], sR Sin[ 2 Pi k / p ], cR }, { k, 0, p - 1 } ],
            { a, b, z } |-> With[ { nv = Normalize @ Cross[ a, b ] }, z - 2 ( z . nv ) nv ],
            Round[ Mean @ #, 10. ^ -5 ] &,
            True &,
            Identity,
            10. ^ -3,
            { 0, 0, 1 }
          }
        ],
        ( p - 2 ) ( q - 2 ) == 4,
        With[ { e = 2 Sin[ Pi / p ] },
          {
            N @ Table[ Exp[ I 2 Pi k / p ], { k, 0, p - 1 } ],
            { a, b, z } |-> a + ( b - a ) Conjugate[ ( z - a ) / ( b - a ) ],
            Round[ Mean @ #, 10. ^ -6 ] &,
            Abs[ # ] <= 1 + ( r + 1 ) e &,
            { Re @ #, Im @ # } &,
            10. ^ -6,
            { 0, 0 }
          }
        ],
        True,
        With[ { cc = Cot[ Pi / p ] Cot[ Pi / q ] }, { r0 = Tanh[ ArcCosh[ cc ] / 2 ], rr = ArcCosh[ cc ] },
          { polygon = N @ Table[ r0 Exp[ I 2 Pi k / p ], { k, 0, p - 1 } ] },
          {
            elen = ArcCosh[
              1 + 2 Abs[ polygon[[ 1 ]] - polygon[[ 2 ]] ] ^ 2 / ( ( 1 - Abs[ polygon[[ 1 ]] ] ^ 2 ) ( 1 - Abs[ polygon[[ 2 ]] ] ^ 2 ) )
            ]
          },
          { rho = rr + ( r + 1 ) elen },
          {
            polygon,
            { a, b, z } |-> With[ { det = Im[ Conjugate[ a ] b ] },
              If[ Abs[ det ] < 10. ^ -12,
                Exp[ 2 I Arg[ a ] ] Conjugate[ z ],
                ( o |-> o + ( Abs[ o ] ^ 2 - 1 ) / Conjugate[ z - o ] ) @
                  (
                    ( ( Abs[ a ] ^ 2 + 1 ) Im[ b ] - ( Abs[ b ] ^ 2 + 1 ) Im[ a ] ) / ( 2 det ) +
                      I ( ( Abs[ b ] ^ 2 + 1 ) Re[ a ] - ( Abs[ a ] ^ 2 + 1 ) Re[ b ] ) / ( 2 det )
                  )
              ]
            ],
            Round[ Mean @ #, 10. ^ -5 ] &,
            2 ArcTanh[ Abs[ # ] ] <= rho &,
            { Re @ #, Im @ # } &,
            10. ^ -5,
            { 0, 0 }
          }
        ]
      ]
    },
    {
      seed = geometry[[ 1 ]],
      reflect = geometry[[ 2 ]],
      snap = geometry[[ 3 ]],
      inRegion = geometry[[ 4 ]],
      toVec = geometry[[ 5 ]],
      tol = geometry[[ 6 ]],
      ref = geometry[[ 7 ]]
    },
    {
      faces = First @ NestWhile[
        Apply[ { done, frontier, seen } |-> With[
          {
            fresh = Select[
              Flatten[ Table[ reflect[ f[[ i ]], f[[ Mod[ i, p ] + 1 ]], # ] & /@ f, { f, frontier }, { i, p } ], 1 ],
              nf |-> inRegion @ Mean @ nf && ! KeyExistsQ[ seen, snap @ nf ]
            ]
          },
          { new = fresh[[ First /@ Values @ PositionIndex[ snap /@ fresh ] ]] },
          { Join[ done, new ], new, Join[ seen, AssociationThread[ snap /@ new -> True ] ] }
        ] ],
        { { seed }, { seed }, <| snap[ seed ] -> True |> },
        Apply[ { done, frontier, seen } |-> frontier =!= { } ]
      ]
    },
    With[ { vecs = toVec /@ Flatten[ faces, 1 ] },
      { keys = Round[ vecs, tol ] },
      { uniq = DeleteDuplicates @ keys },
      { idOf = AssociationThread[ uniq -> Range @ Length @ uniq ] },
      { fids = Lookup[ idOf, # ] & /@ TakeList[ keys, Length /@ faces ] },
      {
        edges = DeleteCases[
          DeleteDuplicates @ Flatten[ ( fc |-> UndirectedEdge @@ Sort[ # ] & /@ Partition[ Append[ fc, First @ fc ], 2, 1 ] ) /@ fids ],
          _?( Apply[ SameQ ] )
        ]
      },
      {
        tiling = Graph[
          Range @ Length @ uniq,
          edges,
          VertexCoordinates -> Lookup[ GroupBy[ Transpose[ { keys, vecs } ], First -> Last, Mean ], uniq ]
        ]
      },
      Graph[
        NeighborhoodGraph[
          tiling,
          VertexList[ tiling ][[ First @ Ordering[ SquaredEuclideanDistance[ ref, # ] & /@ GraphEmbedding @ tiling, 1 ] ]],
          r
        ],
        Sequence @@ FilterRules[ { opts }, Options[ Graph ] ]
      ]
    ]
  ]

TessellationNeighborhoodGraph[ { p_Integer, q_Integer }, { m_Integer, n_Integer }, opts : OptionsPattern[ Graph ] ] /; (p - 2) (q - 2) == 4 :=
    Graph[
      Switch[ { p, q },
        { 4, 4 }, GridGraph[ { m, n } ],
        { 3, 6 },
          Graph[
            Flatten @ Table[
              { If[ i < m, { i, j } <-> { i + 1, j }, Nothing ],
               If[ j < n, { i, j } <-> { i, j + 1 }, Nothing ],
               If[ i < m && j < n, { i, j } <-> { i + 1, j + 1 }, Nothing ] },
              { i, 0, m }, { j, 0, n } ],
            VertexCoordinates -> (v |-> v -> { v[[ 1 ]] + v[[ 2 ]]/2, v[[ 2 ]] Sqrt[ 3 ]/2 }) /@ Flatten[ Table[ { i, j }, { i, 0, m }, { j, 0, n } ],
              1 ] ],
        { 6, 3 },
          With[ { a0 = { -Sqrt[ 3 ]/2, 3/2 }, a1 = { Sqrt[ 3 ]/2, 3/2 }, d = { 0, 1 } },
            { g = Graph[
              Flatten @ Table[
                { { i, j, 0 } <-> { i, j, 1 },
                 If[ i > 0, { i, j, 0 } <-> { i - 1, j, 1 }, Nothing ],
                 If[ j > 0, { i, j, 0 } <-> { i, j - 1, 1 }, Nothing ] },
                { i, 0, m }, { j, 0, n } ],
              VertexCoordinates -> Flatten[ Table[
                { { i, j, 0 } -> i a0 + j a1, { i, j, 1 } -> i a0 + j a1 + d }, { i, 0, m }, { j, 0, n } ], 2 ] ] },
            Subgraph[ g, Select[ VertexList @ g, VertexDegree[ g, # ] > 1 & ] ] ] ],
      Sequence @@ FilterRules[ { opts }, Options[ Graph ] ] ]

TessellationNeighborhoodGraph[ config_List /; Length[ config ] >= 3, r_Integer : 3, opts : OptionsPattern[ Graph ] ] :=
  With[
    { defect = Total[ 1 / config ] - ( Length[ config ] - 2 ) / 2 },
    {
      g = Which[
        Equal @@ config, TessellationNeighborhoodGraph[ { First @ config, Length @ config }, r ],
        defect > 0,
        With[ { solid = TessellationGraph[ config ] },
          If[ GraphQ[ solid ], NeighborhoodGraph[ solid, First @ VertexList @ solid, r ], Missing[ "NotAvailable" ] ]
        ],
        defect == 0 && ! MemberQ[
          { { 3, 6, 3, 6 }, { 3, 4, 6, 4 }, { 4, 6, 12 }, { 4, 8, 8 }, { 3, 12, 12 } },
          First @ Sort @ Join[
            Table[ RotateLeft[ config, i ], { i, 0, Length[ config ] - 1 } ],
            Table[ RotateLeft[ Reverse @ config, i ], { i, 0, Length[ config ] - 1 } ]
          ]
        ],
        Missing[ "NotAvailable" ],
        True,
        With[
          { u = If[ defect == 0, 1, Re[ edge /. FindRoot[ Total[ 2 ArcSin[ Cos[ Pi / # ] / edge ] & /@ config ] == 2 Pi, { edge, 1.3 } ] ] ] },
          {
            s = If[ u === 1, 1, 2 ArcCosh[ u ] ],
            angle = f |-> 2 ArcSin[ Cos[ Pi / f ] / u ],
            mob = { a, z } |-> ( z + a ) / ( 1 + Conjugate[ a ] z ),
            imob = { a, z } |-> ( z - a ) / ( 1 - Conjugate[ a ] z )
          },
          {
            place = If[ u === 1,
              { a, b, f } |-> FoldList[ Plus, a, Table[ ( b - a ) Exp[ I 2. Pi k / f ], { k, 0, f - 2 } ] ],
              { a, b, f } |-> With[ { rho = Tanh[ ArcSinh[ Sinh[ ArcCosh[ u ] ] / Sin[ Pi / f ] ] / 2 ] },
                { std = Table[ rho Exp[ I 2. Pi j / f ], { j, 0, f - 1 } ] },
                { theta = Arg[ imob[ a, b ] ] - Arg[ imob[ std[[ 1 ]], std[[ 2 ]] ] ] },
                Table[ mob[ a, Exp[ I theta ] imob[ std[[ 1 ]], std[[ j ]] ] ], { j, 1, f } ]
              ]
            ],
            direction = If[ u === 1, { v, w } |-> Arg[ w - v ], { v, w } |-> Arg[ imob[ v, w ] ] ],
            step = If[ u === 1, { v, dir } |-> v + Exp[ I dir ], { v, dir } |-> mob[ v, Tanh[ s / 2 ] Exp[ I dir ] ] ],
            (* grow to a margin past radius r, so B_r is contained: graph distance >= Euclidean distance for
               unit edges, and hyperbolic edges have length s *)
            inRegion = If[ u === 1, Abs[ # ] <= r + 2.5 &, Abs[ # ] < 1 && 2 ArcTanh[ Abs[ # ] ] <= ( r + 2 ) s & ]
          },
          {
            start = Select[
              MapThread[ place[ 0, step[ 0, #2 ], #1 ] &, { config, Most @ Prepend[ Accumulate[ angle /@ config ], 0. ] } ],
              inRegion[ Mean @ # ] &
            ]
          },
          {
            faces = First @ NestWhile[
              Apply[ { current, seen, growing } |-> Fold[
                { acc, corner } |-> With[
                  { done = acc[[ 1 ]], known = acc[[ 2 ]] },
                  {
                    added = If[ 2 Pi - Total[ angle /@ corner[[ All, 2 ]] ] < 0.01,
                      { },
                      With[ { v = corner[[ 1, 1 ]], sizes = corner[[ All, 2 ]], starts = corner[[ All, 3 ]], ends = corner[[ All, 4 ]] },
                        { begin = SelectFirst[ starts, a |-> NoneTrue[ ends, Abs[ Mod[ a - # + Pi, 2 Pi ] - Pi ] < 10. ^ -3 & ] ] },
                        { order = SortBy[ Range @ Length @ sizes, Mod[ starts[[ # ]] - begin, 2 Pi ] & ] },
                        {
                          endAngle = ends[[ Last @ order ]],
                          remaining = DeleteDuplicates @ Cases[
                            Join @@ ( Table[ RotateLeft[ #, i ], { i, 0, Length @ config - 1 } ] & /@ { config, Reverse @ config } ),
                            sq_ /; Take[ sq, Length @ order ] === sizes[[ order ]] :> Drop[ sq, Length @ order ]
                          ]
                        },
                        If[ Length @ remaining != 1,
                          { },
                          Last @ Fold[
                            { state, size } |-> With[ { poly = place[ v, First @ state, size ] },
                              {
                                poly[[ -1 ]],
                                If[ ! KeyExistsQ[ known, Round[ Mean @ poly, 10. ^ -5 ] ] && inRegion[ Mean @ poly ],
                                  Append[ Last @ state, poly ],
                                  Last @ state
                                ]
                              }
                            ],
                            { step[ v, endAngle ], { } },
                            First @ remaining
                          ]
                        ]
                      ]
                    ]
                  },
                  If[ added =!= { },
                    { Join[ done, added ], Join[ known, AssociationThread[ ( Round[ Mean @ #, 10. ^ -5 ] & /@ added ) -> True ] ], True },
                    acc
                  ]
                ],
                { current, seen, False },
                Values @ GroupBy[
                  Flatten[
                    ( poly |-> With[ { len = Length @ poly },
                      Table[
                        With[ { v = poly[[ i ]], nxt = poly[[ Mod[ i, len ] + 1 ]], prv = poly[[ Mod[ i - 2, len ] + 1 ]] },
                          { Round[ { Re @ v, Im @ v }, 10. ^ -5 ], v, len, direction[ v, nxt ], direction[ v, prv ] }
                        ],
                        { i, len }
                      ]
                    ] ) /@ current,
                    1
                  ],
                  First -> Rest
                ]
              ] ],
              { start, Association[ ( Round[ Mean @ #, 10. ^ -5 ] -> True ) & /@ start ], True },
              Apply[ { current, seen, growing } |-> growing ]
            ]
          },
          With[ { vecs = { Re @ #, Im @ # } & /@ Flatten[ faces, 1 ] },
            { keys = Round[ vecs, 10. ^ -5 ] },
            { uniq = DeleteDuplicates @ keys },
            { idOf = AssociationThread[ uniq -> Range @ Length @ uniq ] },
            { fids = Lookup[ idOf, # ] & /@ TakeList[ keys, Length /@ faces ] },
            {
              edges = DeleteCases[
                DeleteDuplicates @ Flatten[ ( fc |-> UndirectedEdge @@ Sort[ # ] & /@ Partition[ Append[ fc, First @ fc ], 2, 1 ] ) /@ fids ],
                _?( Apply[ SameQ ] )
              ]
            },
            {
              tiling = Graph[
                Range @ Length @ uniq,
                edges,
                VertexCoordinates -> Lookup[ GroupBy[ Transpose[ { keys, vecs } ], First -> Last, Mean ], uniq ]
              ]
            },
            NeighborhoodGraph[
              tiling,
              VertexList[ tiling ][[ First @ Ordering[ SquaredEuclideanDistance[ { 0, 0 }, # ] & /@ GraphEmbedding @ tiling, 1 ] ]],
              r
            ]
          ]
        ]
      ]
    },
    Graph[ g, Sequence @@ FilterRules[ { opts }, Options[ Graph ] ] ] /; GraphQ[ g ]
  ]

(* combinatorial (angle-defect) Gaussian curvature at a vertex of the map:
   kappa = Sum 1/f_i - (k - 2)/2; sign is spherical / flat / hyperbolic and the geometric
   angle defect is 2 Pi kappa. Depends only on the local configuration, not the realisation.
   A Schlafli {p, q} has q p-gons around each vertex; a longer list is the vertex configuration.
   With a graph and no spec, the map is read as regular: q copies of the girth p. *)
TessellationCurvature[ spec_List ] :=
  With[ { sizes = Replace[ spec, { p_Integer, q_Integer } :> ConstantArray[ p, q ] ] }, Total[ 1/sizes ] - (Length[ sizes ] - 2)/2 ]
TessellationCurvature[ g_Graph ] :=
  TessellationCurvature[ ConstantArray[ First @ Select[ Range[ 3, EdgeCount[ g ] + 1 ], FindCycle[ g, { # }, 1 ] =!= {} &, 1 ],
      First @ Union @ VertexDegree @ g ] ]

(* Euler characteristic of the closed map, V - E + F read off the realised graph: each
   f-gon owns f of the V*k vertex-face corners, so F = V Sum 1/f_i (works for the mixed
   faces of an Archimedean map). Discrete Gauss-Bonnet gives the same value as V kappa.
   The spec defaults to the regular configuration detected from the graph. *)
TessellationEulerCharacteristic[ graph_Graph, spec_List ] :=
  VertexCount[ graph ] - EdgeCount[ graph ] + VertexCount[ graph ] Total[ 1 / Replace[ spec, { p_Integer, q_Integer } :> ConstantArray[ p, q ] ] ]
TessellationEulerCharacteristic[ graph_Graph ] :=
  TessellationEulerCharacteristic[ graph,
    ConstantArray[ First @ Select[ Range[ 3, EdgeCount[ graph ] + 1 ], FindCycle[ graph, { # }, 1 ] =!= {} &, 1 ],
      First @ Union @ VertexDegree @ graph ] ]

TessellationGenus[ graph_Graph, spec_List ] :=
  (2 - TessellationEulerCharacteristic[ graph, spec ]) / 2
TessellationGenus[ graph_Graph ] :=
  (2 - TessellationEulerCharacteristic[ graph ]) / 2

(* The regular maps of type {p, q} are the smooth quotients G = D/N of the triangle group D = <x, y | x^p, y^q, (x y)^2>
   by its normal subgroups N of finite index: x the face rotation, y the vertex rotation, x y the edge involution.
   regularMap[{p, q}, k] is the k-th of them in increasing order of |G|, one per normal subgroup, among those whose
   skeleton is a simple graph, as {graph, faces}: the darts are G, the vertices the cycles of y, the edges the
   cycles of x y, the faces the cycles of x as vertex cycles. The orders are searched up to the bounds 168, 336, 672
   and the maximal order 1100; past it the call stays unevaluated. *)
regularMap[ { p_Integer, q_Integer }, k_Integer?Positive ] /; p >= 2 && q >= 2 :=
  With[
    {
      vertexOf = y |-> Ceiling[ Ordering[ Flatten @ First @ PermutationCycles[ y ] ] / q ],
      quotients = order |-> With[
        { raw = triangleQuotientSearch[ p, q, order ] },
        {
          tables = Last @ Reap[
            NestWhile[ position |-> ( Sow[ Partition[ raw[[ position + 1 ;; position + 2 raw[[ position ]] ]], raw[[ position ]] ] ]; position + 2 raw[[ position ]] + 1 ), 1, # <= Length[ raw ] & ],
            _,
            Sequence @@ #2 &
          ]
        },
        tables[[ Ordering[ Length @ First @ # & /@ tables ] ]]
      ]
    },
    {
      simpleQ = { x, y } |-> With[
        { vertex = vertexOf[ y ] },
        { ends = Sort /@ Transpose[ { vertex, vertex[[ y[[ x ]] ]] } ] },
        FreeQ[ ends, { a_, a_ } ] && 2 Length @ Union @ ends == Length @ ends
      ]
    },
    { found = Fold[ { maps, order } |-> If[ Length[ maps ] >= k, maps, Select[ quotients[ order ], simpleQ @@ # & ] ], { }, { 168, 336, 672, 1100 } ] },
    With[
      { x = found[[ k, 1 ]], y = found[[ k, 2 ]] },
      { vertex = vertexOf[ y ] },
      { Graph[ Range[ Length[ x ] / q ], UndirectedEdge @@@ Union[ Sort /@ Transpose[ { vertex, vertex[[ y[[ x ]] ]] } ] ] ], vertex[[ # ]] & /@ First @ PermutationCycles[ x ] }
    ] /; Length[ found ] >= k
  ]

(* Sims' low-index search restricted to normal subgroups, after Conder and Dobcsanyi: a coset table is filled entry by
   entry in standard order, an entry is either an existing coset or a new one, and every choice of an existing coset
   is a word of N, which is added as a relator and scanned at every coset, because a word of a normal subgroup fixes
   every coset. A complete table is the Cayley table of G, and each normal subgroup is found exactly once.
   The result is the flat list of the tables found, each as its order m, the m images under x, the m images under y.
   Compiled once, on first use, for the WVM, which TimeConstrained can abort. *)
triangleQuotientSearch := triangleQuotientSearch = Compile[
  { { p, _Integer }, { q, _Integer }, { maxOrder, _Integer } },
  Module[
    {
      inv = { 2, 1, 4, 3 },
      tab = Table[ 0, { maxOrder + 1 }, { 4 } ], parent = Table[ 0, { maxOrder + 1 } ], pgen = Table[ 0, { maxOrder + 1 } ],
      trailA = Table[ 0, { 4 maxOrder + 8 } ], trailS = Table[ 0, { 4 maxOrder + 8 } ], trailN = 0,
      dedA = Table[ 0, { 4 maxOrder + 8 } ], dedS = Table[ 0, { 4 maxOrder + 8 } ], dedN = 0,
      relBuf = Table[ 0, { 128 maxOrder + 256 } ], relStart = Table[ 0, { 8 maxOrder + 16 } ], relLen = Table[ 0, { 8 maxOrder + 16 } ],
      relN = 0, bufN = 0,
      occRel = Table[ 0, { 256 maxOrder + 512 } ], occPos = Table[ 0, { 256 maxOrder + 512 } ], occN = { 0, 0, 0, 0 },
      frI = Table[ 0, { 4 maxOrder + 8 } ], frS = Table[ 0, { 4 maxOrder + 8 } ], frJ = Table[ 0, { 4 maxOrder + 8 } ],
      frM = Table[ 0, { 4 maxOrder + 8 } ], frTrail = Table[ 0, { 4 maxOrder + 8 } ], frRelN = Table[ 0, { 4 maxOrder + 8 } ],
      frBufN = Table[ 0, { 4 maxOrder + 8 } ], frOcc = Table[ 0, { 16 maxOrder + 32 } ],
      pendBuf = Table[ 0, { 2 maxOrder + p + q + 16 } ], pendOff = { 0, 0, 0 }, pendLen = { 0, 0, 0 }, pendN = 0,
      bag = Internal`Bag[ Most[ { 0 } ] ],
      init = True, bad = False, same = True,
      depth = 0, m = 1, i = 1, s = 1, j = 0, k = 0, f = 0, b = 0, g = 0, t = 0, r = 0,
      len = 0, base = 0, lo = 0, hi = 0, period = 0, letter = 0, w = 0, newFrom = 0, row0 = 1, fi = 0, fs = 0,
      phRel = 0, phRelMax = -1, phPt = 1, curA = 0, curS = 0, curO = 1, curEnd = 0, sa = 0, sk = 0, st = 0
    },
    While[ init || depth > 0,
      dedN = 0;
      pendN = 0;
      bad = False;
      If[ init,
        pendN = 3;
        pendOff = { 0, p, p + q };
        pendLen = { p, q, 4 };
        Do[ pendBuf[[ t ]] = 1, { t, p } ];
        Do[ pendBuf[[ p + t ]] = 3, { t, q } ];
        Do[ pendBuf[[ p + q + t ]] = { 1, 3, 1, 3 }[[ t ]], { t, 4 } ];
        row0 = 1,
        While[ trailN > frTrail[[ depth ]], tab[[ trailA[[ trailN ]], trailS[[ trailN ]] ]] = 0; trailN-- ];
        relN = frRelN[[ depth ]];
        bufN = frBufN[[ depth ]];
        Do[ occN[[ g ]] = frOcc[[ 4 ( depth - 1 ) + g ]], { g, 4 } ];
        m = frM[[ depth ]];
        i = frI[[ depth ]];
        s = frS[[ depth ]];
        j = frJ[[ depth ]];
        While[ j <= m && tab[[ j, inv[[ s ]] ]] != 0, j++ ];
        If[ j > m + 1 || ( j == m + 1 && m >= maxOrder ), depth--; Continue[] ];
        frJ[[ depth ]] = j + 1;
        row0 = i;
        If[ j <= m,
          tab[[ i, s ]] = j; tab[[ j, inv[[ s ]] ]] = i;
          trailN++; trailA[[ trailN ]] = i; trailS[[ trailN ]] = s;
          trailN++; trailA[[ trailN ]] = j; trailS[[ trailN ]] = inv[[ s ]];
          dedN++; dedA[[ dedN ]] = i; dedS[[ dedN ]] = s;
          (* the word w_i s w_j^-1 of N, freely and cyclically reduced *)
          len = 0;
          k = i;
          While[ k != 1, len++; pendBuf[[ len ]] = pgen[[ k ]]; k = parent[[ k ]] ];
          Do[ letter = pendBuf[[ t ]]; pendBuf[[ t ]] = pendBuf[[ len + 1 - t ]]; pendBuf[[ len + 1 - t ]] = letter, { t, Quotient[ len, 2 ] } ];
          If[ len > 0 && pendBuf[[ len ]] == inv[[ s ]], len--, len++; pendBuf[[ len ]] = s ];
          k = j;
          While[ k != 1,
            letter = inv[[ pgen[[ k ]] ]];
            If[ len > 0 && pendBuf[[ len ]] == inv[[ letter ]], len--, len++; pendBuf[[ len ]] = letter ];
            k = parent[[ k ]] ];
          lo = 1;
          hi = len;
          While[ hi > lo && pendBuf[[ lo ]] == inv[[ pendBuf[[ hi ]] ]], lo++; hi-- ];
          If[ hi >= lo,
            Do[ pendBuf[[ t ]] = pendBuf[[ t + lo - 1 ]], { t, hi - lo + 1 } ];
            pendN = 1;
            pendOff[[ 1 ]] = 0;
            pendLen[[ 1 ]] = hi - lo + 1 ],
          m++;
          parent[[ m ]] = i;
          pgen[[ m ]] = s;
          tab[[ i, s ]] = m; tab[[ m, inv[[ s ]] ]] = i;
          trailN++; trailA[[ trailN ]] = i; trailS[[ trailN ]] = s;
          trailN++; trailA[[ trailN ]] = m; trailS[[ trailN ]] = inv[[ s ]];
          dedN++; dedA[[ dedN ]] = i; dedS[[ dedN ]] = s ]
      ];
      If[ bufN + 4 ( pendLen[[ 1 ]] + pendLen[[ 2 ]] + pendLen[[ 3 ]] ) + 8 > Length[ relBuf ], relBuf = Join[ relBuf, relBuf ] ];
      If[ 4 ( Max[ occN ] + 2 ( pendLen[[ 1 ]] + pendLen[[ 2 ]] + pendLen[[ 3 ]] ) ) + 8 > Length[ occRel ],
        occRel = Join[ occRel, occRel ]; occPos = Join[ occPos, occPos ] ];
      (* each new relator and its inverse, stored twice for cyclic reading, with one occurrence per distinct rotation *)
      newFrom = relN + 1;
      Do[
        w = If[ k <= pendN, k, k - pendN ];
        len = pendLen[[ w ]];
        relN++;
        relStart[[ relN ]] = bufN + 1;
        relLen[[ relN ]] = len;
        Do[
          letter = If[ k <= pendN, pendBuf[[ pendOff[[ w ]] + t ]], inv[[ pendBuf[[ pendOff[[ w ]] + len + 1 - t ]] ]] ];
          relBuf[[ bufN + t ]] = letter;
          relBuf[[ bufN + len + t ]] = letter,
          { t, len } ];
        period = len;
        Do[
          If[ period == len && Mod[ len, r ] == 0,
            same = True;
            Do[ If[ relBuf[[ bufN + t ]] != relBuf[[ bufN + t + r ]], same = False; Break[] ], { t, len } ];
            If[ same, period = r ] ],
          { r, len - 1 } ];
        Do[
          letter = relBuf[[ bufN + t ]];
          occN[[ letter ]] = occN[[ letter ]] + 1;
          occRel[[ 4 ( occN[[ letter ]] - 1 ) + letter ]] = relN;
          occPos[[ 4 ( occN[[ letter ]] - 1 ) + letter ]] = t,
          { t, period } ];
        bufN = bufN + 2 len,
        { k, 2 pendN } ];
      (* the new relators are scanned at every coset, then every deduction is closed under all relators *)
      phRel = newFrom;
      phRelMax = newFrom + pendN - 1;
      phPt = 1;
      curO = 1;
      curEnd = 0;
      While[ ! bad,
        If[ phRel <= phRelMax,
          sa = phPt; sk = phRel; st = 1;
          phPt++;
          If[ phPt > m, phPt = 1; phRel++ ],
          If[ curO > curEnd,
            If[ dedN == 0, Break[] ];
            curA = dedA[[ dedN ]]; curS = dedS[[ dedN ]]; dedN--;
            curO = 1; curEnd = occN[[ curS ]];
            Continue[] ];
          sa = curA;
          sk = occRel[[ 4 ( curO - 1 ) + curS ]];
          st = occPos[[ 4 ( curO - 1 ) + curS ]];
          curO++ ];
        len = relLen[[ sk ]];
        base = relStart[[ sk ]] + st - 2;
        f = sa;
        t = 0;
        While[ t < len && tab[[ f, relBuf[[ base + t + 1 ]] ]] != 0, f = tab[[ f, relBuf[[ base + t + 1 ]] ]]; t++ ];
        If[ t == len,
          If[ f != sa, bad = True ],
          b = sa;
          r = len - 1;
          While[ r >= t && tab[[ b, inv[[ relBuf[[ base + r + 1 ]] ]] ]] != 0, b = tab[[ b, inv[[ relBuf[[ base + r + 1 ]] ]] ]]; r-- ];
          If[ r < t,
            If[ f != b, bad = True ],
            If[ r == t,
              g = relBuf[[ base + t + 1 ]];
              tab[[ f, g ]] = b; tab[[ b, inv[[ g ]] ]] = f;
              trailN++; trailA[[ trailN ]] = f; trailS[[ trailN ]] = g;
              trailN++; trailA[[ trailN ]] = b; trailS[[ trailN ]] = inv[[ g ]];
              dedN++; dedA[[ dedN ]] = f; dedS[[ dedN ]] = g ] ] ] ];
      (* x and y keep their orders p and q *)
      If[ ! bad,
        f = 1;
        Do[ f = tab[[ f, 1 ]]; If[ f == 0, Break[] ]; If[ f == 1, bad = True; Break[] ], { p - 1 } ];
        f = 1;
        Do[ f = tab[[ f, 3 ]]; If[ f == 0, Break[] ]; If[ f == 1, bad = True; Break[] ], { q - 1 } ] ];
      If[ ! bad,
        fi = 0;
        fs = 0;
        r = row0;
        While[ fi == 0 && r <= m, Do[ If[ tab[[ r, g ]] == 0, fi = r; fs = g; Break[] ], { g, 4 } ]; r++ ];
        If[ fi == 0,
          If[ tab[[ tab[[ 1, 1 ]], 3 ]] != 1,
            Internal`StuffBag[ bag, m ];
            Do[ Internal`StuffBag[ bag, tab[[ t, 1 ]] ], { t, m } ];
            Do[ Internal`StuffBag[ bag, tab[[ t, 3 ]] ], { t, m } ] ],
          depth++;
          frI[[ depth ]] = fi;
          frS[[ depth ]] = fs;
          frJ[[ depth ]] = 1;
          frM[[ depth ]] = m;
          frTrail[[ depth ]] = trailN;
          frRelN[[ depth ]] = relN;
          frBufN[[ depth ]] = bufN;
          Do[ frOcc[[ 4 ( depth - 1 ) + g ]] = occN[[ g ]], { g, 4 } ] ] ];
      init = False ];
    Internal`BagPart[ bag, All ]
  ],
  RuntimeOptions -> "Speed"
]
