Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: RiemannianInfrageometry :: Coordinatization *)

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
    { walkVertices = Union @@ paths, support = Lookup[ index, Keys @ InfraMeasurement[ g, centre, "VertexDensity" ] ] },
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
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
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
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
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

(* the candidates are the geodesics between pairs at distance at least "MinLength"; each next axis is a candidate farthest from the chosen
   axes, its score the least distance to one of them, until the count is reached or no candidate is "MinSeparation" away *)

FindInfraSpanningAxes[ g_Graph, count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All ) : 1, opts : OptionsPattern[] ] /;
    MemberQ[ { "MinEndpoint", "Separation", "Hausdorff" }, OptionValue[ FindInfraSpanningAxes, { opts }, "AxisDistance" ] ] :=
  With[
    {
      vertices  = VertexList @ g,
      dm        = GraphDistanceMatrix @ g,
      cap       = Replace[ count, { All -> Infinity, UpTo[ n_ ] :> n } ],
      metric    = OptionValue[ FindInfraSpanningAxes, { opts }, "AxisDistance" ],
      thickness = OptionValue[ FindInfraSpanningAxes, { opts }, "AxisThickness" ],
      pick      = If[ TrueQ @ OptionValue[ FindInfraSpanningAxes, { opts }, "RandomPick" ], RandomChoice, First ],
      hausdorff = block |-> Max[ Max[ Min /@ block ], Max[ Min /@ Transpose @ block ] ]
    },
    { least = Replace[ OptionValue[ FindInfraSpanningAxes, { opts }, "MinLength" ], Automatic -> Max @ dm ] },
    { paths = Map[ VertexIndex[ g, # ] &, Catenate[
        Apply[ { i, j } |-> FindPath[ g, vertices[[ i ]], vertices[[ j ]], { dm[[ i, j ]] }, All ] ] /@
          Select[ Position[ dm, d_ /; least <= d < Infinity, { 2 } ], Apply[ Less ] ] ], { 2 } ] },
    { first = If[ paths === { } || cap == 0, { }, pick @ paths ] },
    { separation = Replace[ OptionValue[ FindInfraSpanningAxes, { opts }, "MinSeparation" ], Automatic :> ( Length @ first - 1 ) / 2 ] },
    { score = { axes, path } |-> Switch[ metric,
        "MinEndpoint", Min @ dm[[ path[[ { 1, -1 } ]], Catenate[ #[[ { 1, -1 } ]] & /@ axes ] ]],
        "Separation",  Min @ dm[[ path, Union @@ axes ]],
        "Hausdorff",   Min[ hausdorff[ dm[[ path, # ]] ] & /@ axes ] ] },
    { axes = If[ first === { }, { },
        First @ NestWhile[
          Apply[ { chosen, candidates } |-> With[ { scores = score[ chosen, # ] & /@ candidates },
            If[ Max @ scores < separation,
              { chosen, { } },
              With[ { next = pick @ Pick[ candidates, scores, Max @ scores ] },
                { close = If[ thickness == 0, { next }, Select[ candidates, hausdorff[ dm[[ #, next ]] ] <= thickness & ] ] },
                { Join[ chosen, close ], Complement[ candidates, close ] } ] ] ] ],
          { { first }, DeleteCases[ paths, first ] },
          Apply[ { chosen, candidates } |-> candidates =!= { } && Length @ chosen < cap ] ] ] },
    Map[ vertices[[ # ]] &, If[ IntegerQ @ count && Length @ axes < count, { }, Take[ axes, UpTo[ cap ] ] ] ]
  ]
