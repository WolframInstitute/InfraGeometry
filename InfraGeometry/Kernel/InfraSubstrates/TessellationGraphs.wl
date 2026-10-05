Package[ "WolframInstitute`InfraGeometry`" ]

PackageScope[ CosetEnumeration ]
PackageScope[ LowIndexMaps ]
PackageScope[ RotationMapGraph ]

Options[ TessellationGraph ] = { Method -> Automatic }

TessellationGraph[ { p_Integer, q_Integer }, n_Integer : 1, opts : OptionsPattern[ { TessellationGraph, Graph } ] ] /;
    MatchQ[ OptionValue[ TessellationGraph, FilterRules[ { opts }, Options[ TessellationGraph ] ], Method ],
      Automatic | "Platonic" | "Torus" | "PSL2" | "Congruence" | "CosetEnumeration" |
        { Automatic | "Platonic" | "Torus" | "PSL2" | "Congruence" | "CosetEnumeration", ___ } ] :=
  With[
    { method = OptionValue[ TessellationGraph, FilterRules[ { opts }, Options[ TessellationGraph ] ], Method ], c = ( p - 2 ) ( q - 2 ) },
    {
      name = If[ ListQ[ method ], First[ method ], method ],
      budget = If[ ListQ[ method ], Lookup[ Rest[ method ], "MaxIndex", 24 ], If[ c < 4, 4 p q / ( 2 p + 2 q - p q ), 24 ] ]
    },
    {
      cosetMap = { } |-> With[
        { maps = SortBy[ Select[ LowIndexMaps[ p, q, budget ], #[ "Regular" ] & ], #[ "Index" ] & ] },
        If[ Length[ maps ] < n, Missing[ "NotFound" ], TessellationGraph[ { p, q }, maps[[ n ]][ "Generators" ] ] ]
      ]
    },
    {
      g = Switch[ { name, Sign[ c - 4 ] },
        { Automatic, -1 } | { "Platonic", _ },
        TessellationGraph[
          { p, q },
          <|
            { 3, 3 } -> AlternatingGroup[ 4 ], { 3, 4 } -> SymmetricGroup[ 4 ], { 4, 3 } -> SymmetricGroup[ 4 ],
            { 3, 5 } -> AlternatingGroup[ 5 ], { 5, 3 } -> AlternatingGroup[ 5 ]
          |>[ { p, q } ]
        ],
        { Automatic, 0 } | { "Torus", _ },
        TorusTessellation[ { n, n }, <| { 4, 4 } -> "Square", { 3, 6 } -> "Triangular", { 6, 3 } -> "Hexagonal" |>[ { p, q } ] ],
        { Automatic, 1 } | { "PSL2" | "Congruence", _ },
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
                { If[ Head[ gens ] === List, Append[ acc, gens ], acc ], ell }
              ] ],
              { { }, 1 },
              Apply[ { acc, ell } |-> Length[ acc ] < n && ell < 50 ]
            ]
          },
          Which[ Length[ found ] >= n, TessellationGraph[ { p, q }, Last[ found ] ], name === Automatic, cosetMap[ ], True, Missing[ "NotFound" ] ]
        ],
        { "CosetEnumeration", _ },
        cosetMap[ ]
      ]
    },
    Graph[ g, Sequence @@ FilterRules[ { opts }, Options[ Graph ] ] ] /; GraphQ[ g ]
  ]

TessellationGraph[ { p_Integer, q_Integer }, { m_Integer, n_Integer }, opts : OptionsPattern[ { TessellationGraph, Graph } ] ] :=
  With[ { g = TorusTessellation[ { m, n }, <| { 4, 4 } -> "Square", { 3, 6 } -> "Triangular", { 6, 3 } -> "Hexagonal" |>[ { p, q } ] ] },
    Graph[ g, Sequence @@ FilterRules[ { opts }, Options[ Graph ] ] ] /; GraphQ[ g ] ]

(* 1-skeleton of the regular map of type {p, q} carried by the (2,p,q)-generation
   r^p == s^q == (rs)^2 == 1: the coset graph on the vertex cosets G/<s>, joined by
   the edge-involution rs; q-regular with girth p, V == |G|/q, E == |G|/2, F == |G|/p *)
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

TessellationGraph[ { p_Integer, q_Integer }, grp_ /; ! MatchQ[ grp, _Integer | { _Integer, _Integer } | _Rule | { ___Rule } ],
    opts : OptionsPattern[ { TessellationGraph, Graph } ] ] :=
  TessellationGraph[
    { p, q },
    With[
      { ord = GroupOrder[ grp ], e = GroupElements[ grp ] },
      { rs = Select[ e, PermutationOrder[ # ] == p & ], ss = Select[ e, PermutationOrder[ # ] == q & ] },
      Catch[
        Do[
          If[ PermutationOrder[ PermutationProduct[ r, s ] ] == 2 && GroupOrder[ PermutationGroup[ { r, s } ] ] == ord, Throw[ { r, s } ] ],
          { r, rs },
          { s, ss }
        ];
        Missing[ "NotFound" ]
      ]
    ],
    opts
  ]

TessellationGraph[ config_List /; Length[ config ] >= 3, n_Integer : 1, opts : OptionsPattern[ { TessellationGraph, Graph } ] ] :=
  With[
    { defect = Total[ 1/config ] - (Length[ config ] - 2)/2,
     key = First @ Sort @ Join[
       Table[ RotateLeft[ config, i ], { i, 0, Length[ config ] - 1 } ],
       Table[ RotateLeft[ Reverse @ config, i ], { i, 0, Length[ config ] - 1 } ] ],
     solids = <|
       { 3, 4, 3, 4 } -> "Cuboctahedron", { 3, 5, 3, 5 } -> "Icosidodecahedron",
       { 3, 6, 6 } -> "TruncatedTetrahedron", { 3, 8, 8 } -> "TruncatedCube",
       { 4, 6, 6 } -> "TruncatedOctahedron", { 3, 10, 10 } -> "TruncatedDodecahedron",
       { 5, 6, 6 } -> "TruncatedIcosahedron", { 3, 4, 4, 4 } -> "SmallRhombicuboctahedron",
       { 4, 6, 8 } -> "GreatRhombicuboctahedron", { 3, 4, 5, 4 } -> "SmallRhombicosidodecahedron",
       { 4, 6, 10 } -> "GreatRhombicosidodecahedron", { 3, 3, 3, 3, 4 } -> "SnubCube",
       { 3, 3, 3, 3, 5 } -> "SnubDodecahedron" |>,
     cycleVertices = cycle |-> With[ { vs = List @@@ cycle },
       { start = If[ MemberQ[ vs[[ 2 ]], vs[[ 1, 2 ]] ], vs[[ 1, 1 ]], vs[[ 1, 2 ]] ] },
       Most @ FoldList[ { prev, e } |-> First @ Complement[ e, { prev } ], start, vs ] ],
     faceToEdges = fc |-> Sort /@ Partition[ Append[ fc, First @ fc ], 2, 1 ],
     boundaryEdges = cyc |-> With[ { len = Length[ cyc ] }, Table[ UndirectedEdge[ cyc[[ i ]], cyc[[ Mod[ i, len ] + 1 ]] ], { i, len } ] ] },
    { vertexRotation = { vertex, faceEdges } |-> With[
       { prs = DeleteDuplicates @ Flatten[
          (fl |-> Cases[ Transpose[ { fl, RotateLeft[ fl ] } ],
              { a_, b_ } /; MemberQ[ a, vertex ] && MemberQ[ b, vertex ] :> Sort[ { a, b } ] ]) /@ faceEdges, 1 ] },
       { es = DeleteDuplicates @ Flatten[ prs, 1 ] },
       cycleVertices @ First @ FindCycle[ Graph[ UndirectedEdge @@@ prs ], { Length @ es }, 1 ] ] },
    { rectify = { graph, fcs } |-> With[ { efs = faceToEdges /@ fcs },
       { faces = Join[ efs, vertexRotation[ #, efs ] & /@ VertexList[ graph ] ] },
       { SimpleGraph @ Graph @ Flatten[ boundaryEdges /@ faces ], faces } ],
     truncate = { graph, fcs } |-> With[ { efs = faceToEdges /@ fcs },
       { vpoly = (v |-> ({ v, # } & /@ vertexRotation[ v, efs ])) /@ VertexList[ graph ],
        fpoly = (f |-> With[ { len = Length @ f, fe = faceToEdges @ f },
          Flatten[ Table[ { { f[[ i ]], fe[[ i ]] }, { f[[ Mod[ i, len ] + 1 ]], fe[[ i ]] } }, { i, len } ], 1 ] ]) /@ fcs },
       { faces = Join[ vpoly, fpoly ] },
       { SimpleGraph @ Graph @ Flatten[ boundaryEdges /@ faces ], faces } ] },
    { conway = { ops, graph } |-> First @ Fold[ #2 @@ #1 &,
       { graph, cycleVertices /@ FindCycle[ graph, { First @ Select[ Range[ 3, EdgeCount[ graph ] + 1 ], FindCycle[ graph, { # }, 1 ] =!= {} &, 1 ] },
           All ] },
       ops ] },
    (* the seed torus is taken at size >= 5 so wraparound loops exceed the girth and the
       girth-cycle face recovery returns the true faces, not non-contractible cycles *)
    { size = Max[ n, 5 ],
     seed = Which[
       Length[ key ] == 4 && key[[ 1 ]] == key[[ 3 ]] && key[[ 2 ]] == key[[ 4 ]], { { rectify }, { key[[ 1 ]], key[[ 2 ]] } },
       Length[ key ] == 4 && key[[ 2 ]] == 4 && key[[ 4 ]] == 4, { { rectify, rectify }, { key[[ 1 ]], key[[ 3 ]] } },
       Length[ key ] == 3 && MemberQ[ key, 4 ], { { rectify, truncate }, DeleteCases[ key, 4 ]/2 },
       Length[ key ] == 3 && Length[ Union @ key ] == 2,
         { { truncate }, { First[ Select[ key, Count[ key, # ] == 2 & ] ]/2, First[ Select[ key, Count[ key, # ] == 1 & ] ] } },
       True, None ] },
    { map = Which[
       Equal @@ config, TessellationGraph[ { First @ config, Length @ config }, n ],
       defect > 0, Which[
         KeyExistsQ[ solids, key ], PolyhedronData[ solids[ key ], "SkeletonGraph" ],
         Count[ config, 4 ] == 2 && Length[ config ] == 3,
           With[ { k = First @ DeleteCases[ config, 4 ] }, Graph @ Join[
             Table[ UndirectedEdge[ { 1, i }, { 1, Mod[ i, k ] + 1 } ], { i, k } ],
             Table[ UndirectedEdge[ { 2, i }, { 2, Mod[ i, k ] + 1 } ], { i, k } ],
             Table[ UndirectedEdge[ { 1, i }, { 2, i } ], { i, k } ] ] ],
         Count[ config, 3 ] == 3 && Length[ config ] == 4,
           With[ { k = First @ DeleteCases[ config, 3 ] }, Graph @ Join[
             Table[ UndirectedEdge[ { 1, i }, { 1, Mod[ i, k ] + 1 } ], { i, k } ],
             Table[ UndirectedEdge[ { 2, i }, { 2, Mod[ i, k ] + 1 } ], { i, k } ],
             Table[ UndirectedEdge[ { 1, i }, { 2, i } ], { i, k } ],
             Table[ UndirectedEdge[ { 1, i }, { 2, Mod[ i, k ] + 1 } ], { i, k } ] ] ],
         True, Missing[ "NotAvailable" ] ],
       defect == 0, Switch[ key,
         { 3, 6, 3, 6 }, conway[ { rectify }, TorusTessellation[ { size, size }, "Triangular" ] ],
         { 3, 4, 6, 4 }, conway[ { rectify, rectify }, TorusTessellation[ { size, size }, "Triangular" ] ],
         { 4, 6, 12 }, conway[ { rectify, truncate }, TorusTessellation[ { size, size }, "Triangular" ] ],
         { 4, 8, 8 }, conway[ { truncate }, TorusTessellation[ { size, size }, "Square" ] ],
         { 3, 12, 12 }, conway[ { truncate }, TorusTessellation[ { size, size }, "Hexagonal" ] ],
         _, Missing[ "NotAvailable" ] ],
       seed === None, Missing[ "NotAvailable" ],
       True, conway[ First @ seed, TessellationGraph[ Last @ seed, n ] ] ] },
    Graph[ map, Sequence @@ FilterRules[ { opts }, Options[ Graph ] ] ] /; GraphQ[ map ] ]

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

(* ===================== General coset enumeration (Todd-Coxeter / low-index) =====================

   The curvature-agnostic method behind every regular map: maps of type {p, q} <-> finite-index
   subgroups of the von Dyck group D(p,q,2) = <x, y | x^p = y^q = (x y)^2 = 1>, x = face rotation
   (order p), y = vertex rotation (order q), x y = edge involution. Regular maps <-> NORMAL
   subgroups. This is what GAP/Magma do; the Wolfram Language has no finitely-presented-group
   machinery, so it is reimplemented here. Naive backtracking, so feasible only at small index
   (all five Platonic solids, small Euclidean/hyperbolic maps -- NOT the Klein quartic at index 168).
   Consumed by TessellationGraph's Method -> "CosetEnumeration" above.
   Word alphabet for subgroup generators: 1 = x, 2 = x^-1, 3 = y, 4 = y^-1. *)

CosetEnumeration[ p_, q_, subwords_, maxc_ ] :=
  Module[
    { rels = { ConstantArray[ 1, p ], ConstantArray[ 3, q ], { 1, 3, 1, 3 } }, cosetInv = { 2, 1, 4, 3 }, tab = { { 0, 0, 0, 0 } }, repl = { 1 },
      n = 1, rep, merge, coinc, scan, defc, w, c, i, g, qq = {} },
    rep[ x0_ ] := Module[ { x = x0 }, While[ repl[[ x ]] != x, x = repl[[ x ]] ]; x ];
    defc[ cc_, gg_ ] := (n++; AppendTo[ tab, { 0, 0, 0, 0 } ]; AppendTo[ repl, n ]; tab[[ cc, gg ]] = n; tab[[ n, cosetInv[[ gg ]] ]] = cc);
    merge[ a0_, b0_ ] := With[ { a = rep[ a0 ], b = rep[ b0 ] }, If[ a != b, repl[[ Max[ a, b ] ]] = Min[ a, b ]; AppendTo[ qq, Max[ a, b ] ] ] ];
    coinc[ a_, b_ ] := Module[ { e, d, e1, d1 },
      qq = {}; merge[ a, b ];
      While[ qq =!= {}, e = First[ qq ]; qq = Rest[ qq ];
        Do[ d = tab[[ e, g ]];
          If[ d != 0,
            tab[[ d, cosetInv[[ g ]] ]] = 0; e1 = rep[ e ]; d1 = rep[ d ];
            Which[
              tab[[ e1, g ]] != 0, merge[ d1, tab[[ e1, g ]] ],
              tab[[ d1, cosetInv[[ g ]] ]] != 0, merge[ e1, tab[[ d1, cosetInv[[ g ]] ]] ],
              True, tab[[ e1, g ]] = d1; tab[[ d1, cosetInv[[ g ]] ]] = e1 ] ],
          { g, 4 } ] ] ];
    scan[ cc_, rel_ ] := Module[ { f = cc, b = cc, len = Length[ rel ], ii = 1, jj },
      jj = len;
      While[ ii <= len && tab[[ rep[ f ], rel[[ ii ]] ]] != 0, f = rep[ tab[[ rep[ f ], rel[[ ii ]] ]] ]; ii++ ];
      While[ jj >= ii && tab[[ rep[ b ], cosetInv[[ rel[[ jj ]] ]] ]] != 0, b = rep[ tab[[ rep[ b ], cosetInv[[ rel[[ jj ]] ]] ]] ]; jj-- ];
      Which[
        ii == jj + 1, If[ rep[ f ] != rep[ b ], coinc[ f, b ] ],
        ii == jj, tab[[ rep[ f ], rel[[ ii ]] ]] = rep[ b ]; tab[[ rep[ b ], cosetInv[[ rel[[ ii ]] ]] ]] = rep[ f ],
        True, Null ] ];
    Do[ c = 1;
      Do[ If[ tab[[ c, w[[ i ]] ]] == 0, defc[ c, w[[ i ]] ] ]; c = rep[ tab[[ c, w[[ i ]] ]] ], { i, Length[ w ] - 1 } ];
      g = Last[ w ];
      If[ tab[[ c, g ]] == 0, tab[[ c, g ]] = 1; tab[[ 1, cosetInv[[ g ]] ]] = c, If[ rep[ tab[[ c, g ]] ] != 1, coinc[ tab[[ c, g ]], 1 ] ] ],
      { w, subwords } ];
    c = 1;
    While[ c <= n && n <= maxc + 5,
      If[ rep[ c ] == c, Do[ If[ rep[ c ] == c && tab[[ c, g ]] == 0, defc[ c, g ]; Do[ scan[ c, rel ], { rel, rels } ] ], { g, 4 } ] ];
      c++ ];
    If[ n > maxc + 5, $Failed, Count[ Range[ n ], _?(rep[ # ] == # &) ] ] ]

RotationMapGraph[ { x_, y_ } ] :=
  With[
    { ycyc = First @ PermutationCycles[ y ] },
    { vlab = Association @@ Flatten[ MapIndexed[ { cyc, i } |-> ( # -> First[ i ] ) & /@ cyc, ycyc ] ] },
    Graph[ Range[ Length[ ycyc ] ], ( UndirectedEdge @@ ( vlab /@ # ) ) & /@ First @ PermutationCycles[ PermutationProduct[ x, y ] ] ]
  ]

(* every genuine {p,q} map of index <= maxIndex up to isomorphism:
   <|"Index", "Generators" -> {Cycles x, Cycles y}, "Skeleton", "Regular", "Genus"|>. The subgroups are the
   standardized complete coset tables; the lex-least BFS relabel over all base cosets is a conjugacy invariant *)
LowIndexMaps[ p_, q_, maxIndex_ ] :=
  Module[
    { rels = { ConstantArray[ 1, p ], ConstantArray[ 3, q ], { 1, 3, 1, 3 } }, cosetInv = { 2, 1, 4, 3 }, out = {},
     close, search, canonical, t, changed, m, f, b, i, j, len, map, nxt, queue, cur, d, newt },
    close[ t0_ ] := (t = t0; changed = True;
      Catch[
        While[ changed, changed = False; m = Length[ t ];
          Do[ len = Length[ rel ];
            f = c; i = 1; While[ i <= len && t[[ f, rel[[ i ]] ]] != 0, f = t[[ f, rel[[ i ]] ]]; i++ ];
            b = c; j = len; While[ j >= i && t[[ b, cosetInv[[ rel[[ j ]] ]] ]] != 0, b = t[[ b, cosetInv[[ rel[[ j ]] ]] ]]; j-- ];
            Which[
              i == j + 1, If[ f != b, Throw[ Nothing ] ],
              i == j,
                If[ t[[ f, rel[[ i ]] ]] != 0 && t[[ f, rel[[ i ]] ]] != b, Throw[ Nothing ] ];
                If[ t[[ b, cosetInv[[ rel[[ i ]] ]] ]] != 0 && t[[ b, cosetInv[[ rel[[ i ]] ]] ]] != f, Throw[ Nothing ] ];
                t[[ f, rel[[ i ]] ]] = b; t[[ b, cosetInv[[ rel[[ i ]] ]] ]] = f; changed = True,
              True, Null ],
            { c, m }, { rel, rels } ] ];
        t ]);
    search[ tt_ ] := With[ { size = Length[ tt ], slot = FirstPosition[ tt, 0, { 0, 0 }, { 2 } ] }, { c = First[ slot ], g = Last[ slot ] },
      If[ c == 0, AppendTo[ out, tt ],
        Scan[ search, close /@ Join[
            (e |-> ReplacePart[ tt, { { c, g } -> e, { e, cosetInv[[ g ]] } -> c } ]) /@ Select[ Range[ size ], tt[[ #, cosetInv[[ g ]] ]] == 0 & ],
            If[ size < maxIndex, { ReplacePart[ Append[ tt, { 0, 0, 0, 0 } ], { { c, g } -> size + 1, { size + 1, cosetInv[[ g ]] } -> c } ] },
              {} ] ] ] ] ];
    canonical[ tt_ ] := First @ Sort @ Table[
      map = ConstantArray[ 0, Length[ tt ] ]; nxt = 2; map[[ base ]] = 1; queue = { base };
      While[ queue =!= {}, cur = First[ queue ]; queue = Rest[ queue ];
        Do[ d = tt[[ cur, g ]]; If[ map[[ d ]] == 0, map[[ d ]] = nxt++; AppendTo[ queue, d ] ], { g, 4 } ] ];
      newt = ConstantArray[ 0, { Length[ tt ], 4 } ];
      Do[ newt[[ map[[ cur ]], g ]] = map[[ tt[[ cur, g ]] ]], { cur, Length[ tt ] }, { g, 4 } ]; newt,
      { base, Length[ tt ] } ];
    search[ close[ { { 0, 0, 0, 0 } } ] ];
    With[ { uniformCycleQ = { pl, idx, size } |-> With[ { lengths = Length /@ First @ PermutationCycles[ pl ] },
        Total[ lengths ] == idx && AllTrue[ lengths, # == size & ] ] },
      { recs = Select[ { { #[[ All, 1 ]], #[[ All, 3 ]] }, Length[ # ] } & /@ DeleteDuplicatesBy[ out, canonical ],
        rec |-> uniformCycleQ[ rec[[ 1, 1 ]], rec[[ 2 ]], p ] && uniformCycleQ[ rec[[ 1, 2 ]], rec[[ 2 ]], q ] &&
          uniformCycleQ[ PermutationProduct @@ rec[[ 1 ]], rec[[ 2 ]], 2 ] ] },
      Map[ rec |-> With[ { perms = rec[[ 1 ]], idx = rec[[ 2 ]] },
        <| "Index" -> idx, "Generators" -> (PermutationCycles /@ perms), "Skeleton" -> RotationMapGraph[ perms ],
          "Regular" -> GroupOrder[ PermutationGroup[ PermutationCycles /@ perms ] ] == idx, "Genus" -> 1 - (idx/q - idx/2 + idx/p)/2 |> ], recs ] ] ]

