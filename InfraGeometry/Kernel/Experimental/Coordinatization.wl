Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: Experimental :: Coordinatization *)

(* the distance vector (d(v, b1), ..., d(v, bk)).  An anchor is a vertex, a set, a density
   or a walk graph; "AnchorAggregation" reduces its support to one distance.  On a bare
   vertex InfraDensity gives <| v -> 1 |>, on which every aggregation is the distance itself,
   so the crisp case needs no separate rule. *)

Options[ RadarCoordinates ] = { "AnchorAggregation" -> Min }

RadarCoordinates[ g_Graph, b_List, v : Except[ _Rule | _RuleDelayed | _Association ], opts : OptionsPattern[] ] /;
  MemberQ[ VertexList[ g ], v ] :=
  With[ { agg = OptionValue[ "AnchorAggregation" ] },
    ( anchor |-> agg[ GraphDistance[ g, v, # ] & /@ Keys @ InfraDensity[ g, anchor ] ] ) /@ b
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

(* the coordinate of v on a walk is the position of its shortest-path projection, the walk vertices nearest to v, counted from the projection
   of the centre's support; a tie is broken by "SelectCoordinate", the centre's own tie by the same function, so the centre reads 0 *)

Options[ OrthogonalCoordinates ] = { "SelectCoordinate" -> Median }

OrthogonalCoordinates[ g_Graph, centre_, walks : { __ }, opts : OptionsPattern[] ] :=
  With[
    {
      paths   = Replace[ walks, w_Graph :> walkSequence @ w, { 1 } ],
      select  = Replace[ OptionValue[ "SelectCoordinate" ], All -> Identity ],
      origin  = Replace[ OptionValue[ "SelectCoordinate" ], All -> Median ],
      index   = AssociationThread[ VertexList @ g, Range @ VertexCount @ g ],
      nearest = d |-> Flatten @ Position[ d, Min @ d ]
    },
    { walkVertices = Union @@ paths, support = Lookup[ index, Keys @ InfraDensity[ g, centre ] ] },
    { rows = AssociationThread[ walkVertices, GraphDistance[ g, # ] & /@ walkVertices ] },
    { tables = Transpose[ Lookup[ rows, # ] ] & /@ paths },
    { shifts = ( table |-> origin @ nearest[ Min /@ Transpose @ table[[ support ]] ] ) /@ tables },
    AssociationThread[ VertexList @ g, Transpose @ MapThread[ { table, shift } |-> ( select[ nearest[ # ] - shift ] & /@ table ), { tables, shifts } ] ]
  ]

OrthogonalCoordinates[ g_Graph, centre_, walks : { __ }, v_, opts : OptionsPattern[] ] /; VertexQ[ g, v ] :=
  OrthogonalCoordinates[ g, centre, walks, opts ][ v ]

(* an axis at c is a geodesic through c whose halves have lengths in the range, maximal there: neither end extends by one step to a longer
   geodesic through c; the axes depend on the endpoint pair only, so maximality is read on the pair.  Two walks are perpendicular when every
   vertex of each has c as its only nearest vertex on the other, which on the distance matrix is d(v, w) > max(d(c, v), d(c, w)) for every v
   of one and w of the other off c.  The sets are the cliques of that relation, grown by Bron-Kerbosch over the axes ranked straight-first
   (longer, then fewer vertices in the geodesic interval of the ends, then by name), so under Identity the sets surface in lexicographic order
   of their ranks: the count-less call is the greedy set and All that order *)

Options[ FindInfraOrthogonalAxes ] = {
  Properties           -> Automatic,
  "NextVertexFunction" -> Identity,
  "AxisCount"          -> Automatic
}

FindInfraOrthogonalAxes[ g_Graph, centre_, axisLength : ( All | _Integer | UpTo[ _Integer ] | { _Integer, _Integer | Infinity } ),
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    VertexQ[ g, centre ] || AssociationQ[ centre ] && SubsetQ[ VertexList @ g, Keys @ centre ] :=
  With[
    {
      centres    = If[ AssociationQ @ centre, Keys @ centre, { centre } ],
      range      = Replace[ axisLength, { All -> { 1, Infinity }, k_Integer :> { k, k }, UpTo[ k_ ] :> { 1, k } } ],
      properties = OptionValue[ FindInfraOrthogonalAxes, { opts }, Properties ],
      nextFn     = OptionValue[ FindInfraOrthogonalAxes, { opts }, "NextVertexFunction" ],
      axisCount  = OptionValue[ FindInfraOrthogonalAxes, { opts }, "AxisCount" ],
      needed     = Replace[ count, { Automatic -> 1, All -> Infinity, UpTo[ n_ ] :> n } ]
    },
    { local = If[ Last @ range === Infinity, Subgraph[ g, VertexComponent[ g, centres ] ], NeighborhoodGraph[ g, centres, 2 Last @ range ] ] },
    { verts = VertexList @ local, dm = GraphDistanceMatrix @ local, nbrs = AdjacencyList @ IndexGraph @ local },
    { index = AssociationThread[ verts, Range @ Length @ verts ] },
    { found = Fold[
        { acc, k } |-> If[ Length @ acc >= needed,
          acc,
          With[
            { ci = index @ centres[[ k ]] },
            { depth = dm[[ ci ]] },
            { up = Table[ If[ depth[[ v ]] < Last @ range, Select[ nbrs[[ v ]], depth[[ # ]] == depth[[ v ]] + 1 & ], { } ],
                { v, Length @ verts } ] },
            { halves = GroupBy[
                Select[
                  Catenate @ NestWhileList[ Catenate[ ( path |-> Append[ path, # ] & /@ up[[ Last @ path ]] ) /@ # ] &, { { ci } }, # =!= { } & ],
                  Length[ # ] > First @ range & ],
                Last ] },
            { pairs = Select[ Subsets[ Keys @ halves, { 2 } ], Apply[ { p, q } |->
                dm[[ p, q ]] == depth[[ p ]] + depth[[ q ]] && ! MemberQ[ dm[[ up[[ p ]], q ]], dm[[ p, q ]] + 1 ] &&
                  ! MemberQ[ dm[[ p, up[[ q ]] ]], dm[[ p, q ]] + 1 ] ] ] },
            { axes = SortBy[
                If[ OrderedQ[ { verts[[ # ]], verts[[ Reverse @ # ]] } ], #, Reverse @ # ] & /@
                  Catenate[ Apply[ { p, q } |-> Catenate @ Outer[ Join[ Reverse @ #1, Rest @ #2 ] &, halves @ p, halves @ q, 1 ] ] /@ pairs ],
                { -Length @ #, Count[ dm[[ First @ # ]] + dm[[ Last @ # ]], dm[[ First @ #, Last @ # ]] ], verts[[ # ]] } & ] },
            { support = DeleteCases[ Union @@ axes, ci ] },
            { slot = AssociationThread[ support, Range @ Length @ support ] },
            { incidence = SparseArray[ Catenate @ MapIndexed[ { axis, i } |-> ( { First @ i, slot @ # } -> 1 & ) /@ DeleteCases[ axis, ci ], axes ],
                { Length @ axes, Length @ support } ] },
            (* a pair of vertices off c clashes when one of them has a nearest vertex of the other's walk besides c *)
            { blocked = If[ axes === { }, { }, Unitize[ incidence . ( 1 - UnitStep[ dm[[ support, support ]] -
                Outer[ Max, depth[[ support ]], depth[[ support ]] ] - 1 ] ) ] ] },
            { admissible = Which[
                properties === Automatic,
                  { chosen, pool } |-> If[ chosen === { } || pool === { }, pool,
                    Pick[ pool, Normal[ incidence[[ pool ]] . Unitize[ Total @ blocked[[ chosen ]] ] ], 0 ] ],
                MatchQ[ properties, _String | { _String, ___ } ],
                  { chosen, pool } |-> Select[ pool, i |-> AllTrue[ chosen,
                    j |-> InfraPerpendicularQ[ local, verts[[ axes[[ j ]] ]], verts[[ axes[[ i ]] ]], Method -> properties ] ] ],
                True,
                  { chosen, pool } |-> Select[ pool, i |-> TrueQ @ properties[ verts[[ # ]] & /@ axes[[ Append[ chosen, i ] ]] ] ] ],
              branch = If[ nextFn === Identity, Identity,
                pool |-> With[ { named = verts[[ axes[[ # ]] ]] & /@ pool },
                  Lookup[ AssociationThread[ named, pool ], Replace[ nextFn @ named, one_ /; MemberQ[ named, Verbatim @ one ] :> { one } ] ] ] ],
              limit = Replace[ axisCount, { UpTo[ n_ ] :> n, Automatic | All -> Infinity } ] },
            { search = { self, sets, chosen, pool, excluded } |-> With[
                { open = admissible[ chosen, pool ], closed = admissible[ chosen, excluded ] },
                { record = chosen =!= { } && Switch[ axisCount,
                    Automatic, open === { } && closed === { },
                    All,       True,
                    _Integer,  Length @ chosen == axisCount,
                    _UpTo,     Length @ chosen == limit || open === { } && closed === { } ] },
                { next = If[ record, Append[ sets, Sort @ chosen ], sets ] },
                If[ Length @ next >= needed - Length @ acc || Length @ chosen >= limit || open === { },
                  next,
                  First @ Fold[
                    { state, i } |-> If[ Length @ First @ state >= needed - Length @ acc,
                      state,
                      { self[ self, First @ state, Append[ chosen, i ], DeleteCases[ state[[ 2 ]], i ], state[[ 3 ]] ],
                        DeleteCases[ state[[ 2 ]], i ], Append[ state[[ 3 ]], i ] } ],
                    { next, open, closed },
                    branch @ open ] ] ] },
            DeleteDuplicatesBy[
              Join[ acc, { k, # , verts[[ axes[[ # ]] ]] & /@ # } & /@ search[ search, { }, { }, Range @ Length @ axes, { } ] ],
              Sort @ Last @ # & ] ] ],
        { },
        Range @ Length @ centres ] },
    { sets = Last /@ If[ count === All, SortBy[ found, { First @ #, PadRight[ #[[ 2 ]], Max[ Length /@ found[[ All, 2 ]] ] ] } & ], found ] },
    Switch[ count,
      Automatic, First[ sets, { } ],
      _Integer,  If[ Length @ sets < count, { }, Take[ sets, count ] ],
      _,         sets ]
  ]

(* a ray at c is a geodesic from c with length in the range, maximal there; rays are perpendicular by the test of the axes, so opposite rays
   pass it as well as perpendicular ones, and the straight frame of the grid Z^d has 2 d rays *)

Options[ FindInfraOrthogonalRays ] = {
  Properties           -> Automatic,
  "NextVertexFunction" -> Identity,
  "RayCount"           -> Automatic
}

FindInfraOrthogonalRays[ g_Graph, centre_, rayLength : ( All | _Integer | UpTo[ _Integer ] | { _Integer, _Integer | Infinity } ),
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    VertexQ[ g, centre ] || AssociationQ[ centre ] && SubsetQ[ VertexList @ g, Keys @ centre ] :=
  With[
    {
      centres    = If[ AssociationQ @ centre, Keys @ centre, { centre } ],
      range      = Replace[ rayLength, { All -> { 1, Infinity }, k_Integer :> { k, k }, UpTo[ k_ ] :> { 1, k } } ],
      properties = OptionValue[ FindInfraOrthogonalRays, { opts }, Properties ],
      nextFn     = OptionValue[ FindInfraOrthogonalRays, { opts }, "NextVertexFunction" ],
      rayCount   = OptionValue[ FindInfraOrthogonalRays, { opts }, "RayCount" ],
      needed     = Replace[ count, { Automatic -> 1, All -> Infinity, UpTo[ n_ ] :> n } ]
    },
    { local = If[ Last @ range === Infinity, Subgraph[ g, VertexComponent[ g, centres ] ], NeighborhoodGraph[ g, centres, 2 Last @ range ] ] },
    { verts = VertexList @ local, dm = GraphDistanceMatrix @ local, nbrs = AdjacencyList @ IndexGraph @ local },
    { index = AssociationThread[ verts, Range @ Length @ verts ] },
    { found = Fold[
        { acc, k } |-> If[ Length @ acc >= needed,
          acc,
          With[
            { ci = index @ centres[[ k ]] },
            { depth = dm[[ ci ]] },
            { up = Table[ If[ depth[[ v ]] < Last @ range, Select[ nbrs[[ v ]], depth[[ # ]] == depth[[ v ]] + 1 & ], { } ],
                { v, Length @ verts } ] },
            { rays = SortBy[
                Select[
                  Catenate @ NestWhileList[ Catenate[ ( path |-> Append[ path, # ] & /@ up[[ Last @ path ]] ) /@ # ] &, { { ci } }, # =!= { } & ],
                  Length[ # ] > First @ range && up[[ Last @ # ]] === { } & ],
                { -Length @ #, Count[ depth + dm[[ Last @ # ]], depth[[ Last @ # ]] ], verts[[ # ]] } & ] },
            { support = DeleteCases[ Union @@ rays, ci ] },
            { slot = AssociationThread[ support, Range @ Length @ support ] },
            { incidence = SparseArray[ Catenate @ MapIndexed[ { ray, i } |-> ( { First @ i, slot @ # } -> 1 & ) /@ Rest @ ray, rays ],
                { Length @ rays, Length @ support } ] },
            (* a pair of vertices off c clashes when one of them has a nearest vertex of the other's walk besides c *)
            { blocked = If[ rays === { }, { }, Unitize[ incidence . ( 1 - UnitStep[ dm[[ support, support ]] -
                Outer[ Max, depth[[ support ]], depth[[ support ]] ] - 1 ] ) ] ] },
            { admissible = Which[
                properties === Automatic,
                  { chosen, pool } |-> If[ chosen === { } || pool === { }, pool,
                    Pick[ pool, Normal[ incidence[[ pool ]] . Unitize[ Total @ blocked[[ chosen ]] ] ], 0 ] ],
                MatchQ[ properties, _String | { _String, ___ } ],
                  { chosen, pool } |-> Select[ pool, i |-> AllTrue[ chosen,
                    j |-> InfraPerpendicularQ[ local, verts[[ rays[[ j ]] ]], verts[[ rays[[ i ]] ]], Method -> properties ] ] ],
                True,
                  { chosen, pool } |-> Select[ pool, i |-> TrueQ @ properties[ verts[[ # ]] & /@ rays[[ Append[ chosen, i ] ]] ] ] ],
              branch = If[ nextFn === Identity, Identity,
                pool |-> With[ { named = verts[[ rays[[ # ]] ]] & /@ pool },
                  Lookup[ AssociationThread[ named, pool ], Replace[ nextFn @ named, one_ /; MemberQ[ named, Verbatim @ one ] :> { one } ] ] ] ],
              limit = Replace[ rayCount, { UpTo[ n_ ] :> n, Automatic | All -> Infinity } ] },
            { search = { self, sets, chosen, pool, excluded } |-> With[
                { open = admissible[ chosen, pool ], closed = admissible[ chosen, excluded ] },
                { record = chosen =!= { } && Switch[ rayCount,
                    Automatic, open === { } && closed === { },
                    All,       True,
                    _Integer,  Length @ chosen == rayCount,
                    _UpTo,     Length @ chosen == limit || open === { } && closed === { } ] },
                { next = If[ record, Append[ sets, Sort @ chosen ], sets ] },
                If[ Length @ next >= needed - Length @ acc || Length @ chosen >= limit || open === { },
                  next,
                  First @ Fold[
                    { state, i } |-> If[ Length @ First @ state >= needed - Length @ acc,
                      state,
                      { self[ self, First @ state, Append[ chosen, i ], DeleteCases[ state[[ 2 ]], i ], state[[ 3 ]] ],
                        DeleteCases[ state[[ 2 ]], i ], Append[ state[[ 3 ]], i ] } ],
                    { next, open, closed },
                    branch @ open ] ] ] },
            DeleteDuplicatesBy[
              Join[ acc, { k, #, verts[[ rays[[ # ]] ]] & /@ # } & /@ search[ search, { }, { }, Range @ Length @ rays, { } ] ],
              Sort @ Last @ # & ] ] ],
        { },
        Range @ Length @ centres ] },
    { sets = Last /@ If[ count === All, SortBy[ found, { First @ #, PadRight[ #[[ 2 ]], Max[ Length /@ found[[ All, 2 ]] ] ] } & ], found ] },
    Switch[ count,
      Automatic, First[ sets, { } ],
      _Integer,  If[ Length @ sets < count, { }, Take[ sets, count ] ],
      _,         sets ]
  ]

Options[ FindInfraSpanningAxes ] = {
  "AxisDistance"  -> "MinEndpoint",
  "MinLength"     -> Automatic,
  "MinSeparation" -> Automatic,
  "AxisThickness" -> 0,
  "RandomPick"    -> False
}

FindInfraSpanningAxes[ g_Graph, All, opts : OptionsPattern[] ] :=
  With[
    { vertices = VertexList[ g ], distMatrix = GraphDistanceMatrix[ g ] },
    { maxDist = Max[ distMatrix ] },
    { epsilon = maxDist - Replace[ OptionValue[ "MinLength" ], Automatic -> maxDist ] },
    {
      paths = Flatten[
        FindPath[ g, vertices[[ #[[ 1 ]] ]], vertices[[ #[[ 2 ]] ]], { distMatrix[[ #[[ 1 ]], #[[ 2 ]] ]] }, All ] & /@ Select[
          DeleteDuplicatesBy[ Position[ distMatrix, _?( # >= maxDist - epsilon & ) ], Sort ],
          #[[ 1 ]] =!= #[[ 2 ]] &
        ],
        1
      ],
      distanceFunction = "AxisDistance" /. { opts } /. "AxisDistance" -> "MinEndpoint",
      thickness = "AxisThickness" /. { opts } /. "AxisThickness" -> 0,
      pick = If[ ! TrueQ[ "RandomPick" /. { opts } /. "RandomPick" -> False ], First, RandomChoice ],
      vertexIndex = AssociationThread[ vertices, Range @ Length @ vertices ],
      hausdorff = sub |-> Max[ Max[ Min /@ sub ], Max[ Min /@ Transpose @ sub ] ]
    },
    {
      minSeparation = Replace[ "MinSeparation" /. { opts } /. "MinSeparation" -> Automatic,
        Automatic :> ( Length[ First[ paths, { } ] ] - 1 ) / 2
      ]
    },
    If[ paths === { },
      { },
      With[
        { first = pick[ paths ] },
        First @ NestWhile[
          Apply[ { axes, previousIndices, previousEndpoints, candidates, done } |-> With[
            {
              scores = Switch[ distanceFunction,
                "MinEndpoint",
                ( Min[
                  distMatrix[[ vertexIndex[ #[[ 1 ]] ], previousEndpoints ]],
                  distMatrix[[ vertexIndex[ #[[ -1 ]] ], previousEndpoints ]] ] & ) /@ candidates,
                "Hausdorff",
                ( p |-> hausdorff[ distMatrix[[ Lookup[ vertexIndex, p ], previousIndices ]] ] ) /@ candidates,
                "Separation",
                ( p |-> Min[ distMatrix[[ Lookup[ vertexIndex, p ], previousIndices ]] ] ) /@ candidates,
                _, None
              ]
            },
            If[ scores === None || Max[ scores ] < minSeparation,
              { axes, previousIndices, previousEndpoints, candidates, True },
              With[
                { next = pick[ candidates[[ Flatten @ Position[ scores, Max[ scores ] ] ]] ] },
                {
                  closeAxes = If[ thickness == 0,
                    { next },
                    Select[ candidates, hausdorff[ distMatrix[[ Lookup[ vertexIndex, # ], Lookup[ vertexIndex, next ] ]] ] <= thickness & ]
                  ]
                },
                {
                  Join[ axes, closeAxes ],
                  Union[ previousIndices, Flatten[ Lookup[ vertexIndex, # ] & /@ closeAxes ] ],
                  Union[ previousEndpoints, Flatten[ { vertexIndex[ #[[ 1 ]] ], vertexIndex[ #[[ -1 ]] ] } & /@ closeAxes ] ],
                  Complement[ candidates, closeAxes ],
                  False
                }
              ]
            ]
          ] ],
          {
            { first },
            Lookup[ vertexIndex, first ],
            { vertexIndex[ first[[ 1 ]] ], vertexIndex[ first[[ -1 ]] ] },
            Complement[ paths, { first } ],
            False
          },
          Apply[ { axes, previousIndices, previousEndpoints, candidates, done } |-> candidates =!= { } && ! done ]
        ]
      ]
    ]
  ]

FindInfraSpanningAxes[ g_Graph, UpTo[ n_Integer ], opts : OptionsPattern[] ] :=
  Take[ FindInfraSpanningAxes[ g, All, opts ], UpTo[ n ] ]

FindInfraSpanningAxes[ g_Graph, n_Integer : 1, opts : OptionsPattern[] ] :=
  With[ { result = FindInfraSpanningAxes[ g, UpTo[ n ], opts ] },
    If[ Length[ result ] >= n, Take[ result, n ], { } ]
  ]
