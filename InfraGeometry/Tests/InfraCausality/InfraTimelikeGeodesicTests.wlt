BeginTestSection["InfraTimelikeGeodesic"]

Needs[ "WolframInstitute`InfraGeometry`" ]

$twoSource = Graph[ { 1 -> 3, 2 -> 4, 3 -> 4, 4 -> 5 } ];

$diamond = Graph[ Flatten @ Table[
  Select[ { { i, j } -> { i + 1, j }, { i, j } -> { i, j + 1 } }, Max @ Last @ # <= 3 & ],
  { i, 0, 3 }, { j, 0, 3 } ] ];

$cylinder = Graph[ Flatten @ Table[
  { { k, t } -> { k, t + 1 }, { k, t } -> { Mod[ k + 1, 3 ], t + 1 } },
  { k, 0, 2 }, { t, 0, 2 } ] ];

$shortcut = Graph[ { 1 -> 2, 2 -> 3, 3 -> 4, 1 -> 5, 5 -> 4, 1 -> 3 } ];

$lattice = Graph[ Flatten @ Table[
  Select[ { { i, j } -> { i + 1, j }, { i, j } -> { i, j + 1 } }, Max @ Last @ # <= 4 & ],
  { i, 0, 4 }, { j, 0, 4 } ] ];

$knots = { { 0, 0 }, { 2, 1 }, { 4, 4 } };

$cuts = { g, knots } |-> Accumulate @ Prepend[ InfraMeasurement[ g, InfraTimelikeGeodesic @@ #, "Length" ] & /@ Partition[ knots, 2, 1 ], 1 ];

$polylineQ = { g, knots } |-> With[ { members = RandomInfraTimelikeGeodesic[ g, InfraTimelikeGeodesic @@ knots, All ], cuts = $cuts[ g, knots ] },
  InfraMeasurement[ g, InfraTimelikeGeodesic @@ knots, "Cardinality" ] == Length @ members ==
      Times @@ ( InfraMeasurement[ g, InfraTimelikeGeodesic @@ #, "Cardinality" ] & /@ Partition[ knots, 2, 1 ] ) &&
    InfraMeasurement[ g, InfraTimelikeGeodesic @@ knots, "Length" ] == Total[ InfraMeasurement[ g, InfraTimelikeGeodesic @@ #, "Length" ] & /@ Partition[ knots, 2, 1 ] ] &&
    AllTrue[ members, m |-> m[[ cuts ]] === knots && InfraChainQ[ g, m ] && InfraWorldlineQ[ g, m ] &&
      AllTrue[ Range[ Length @ knots - 1 ], i |-> InfraTimelikeGeodesicQ[ g, Take[ m, { cuts[[ i ]], cuts[[ i + 1 ]] } ] ] ] ] ];

$fromQ = { g, p } |-> With[ { members = RandomInfraTimelikeGeodesic[ g, InfraTimelikeGeodesic[ p ], All ], future = VertexOutComponent[ g, { p } ] },
  { height = Max[ InfraMeasurement[ g, InfraTimelikeGeodesic[ p, # ], "Length" ] & /@ future ] },
  InfraMeasurement[ g, InfraTimelikeGeodesic[ p ], "Length" ] == height &&
    InfraMeasurement[ g, InfraTimelikeGeodesic[ p ], "Cardinality" ] == Length @ members &&
    Sort @ members === Sort @ Catenate[ Select[ $longestPaths[ g, p, # ], Length @ # == height + 1 & ] & /@ future ] &&
    InfraTimelikeGeodesicQ[ g, members ] ];

$comparablePairs = g |-> Select[ Tuples[ VertexList @ g, 2 ], pair |-> MemberQ[ VertexOutComponent[ g, { First @ pair } ], Last @ pair ] ];

$paths = { g, p, q } |-> If[ p === q, { { p } }, FindPath[ g, p, q, Infinity, All ] ];

$longestPaths = { g, p, q } |-> With[ { paths = $paths[ g, p, q ] }, Select[ paths, Length @ # == Max[ Length /@ paths ] & ] ];

$sourceSinkPaths = g |-> Catenate @ Catenate @ Outer[ $paths[ g, #1, #2 ] &,
  Pick[ VertexList @ g, VertexInDegree @ g, 0 ], Pick[ VertexList @ g, VertexOutDegree @ g, 0 ], 1 ];

$negatedDistance = { g, p, q } |-> - GraphDistance[ Graph[ g, EdgeWeight -> ConstantArray[ -1, EdgeCount @ g ] ], p, q ];

$cardinalityQ = g |-> AllTrue[ $comparablePairs @ g, pair |->
  InfraMeasurement[ g, InfraTimelikeGeodesic @@ pair, "Cardinality" ] == Length @ RandomInfraTimelikeGeodesic[ g, InfraTimelikeGeodesic @@ pair, All ] ];

$longestQ = g |-> AllTrue[ $comparablePairs @ g, pair |->
  Sort @ RandomInfraTimelikeGeodesic[ g, InfraTimelikeGeodesic @@ pair, All ] === Sort @ $longestPaths[ g, First @ pair, Last @ pair ] ];

$membersQ = g |-> AllTrue[ $comparablePairs @ g, pair |->
  With[ { members = RandomInfraTimelikeGeodesic[ g, InfraTimelikeGeodesic @@ pair, All ], length = InfraMeasurement[ g, InfraTimelikeGeodesic @@ pair, "Length" ] },
    AllTrue[ members, m |-> InfraChainQ[ g, m ] && Length @ m - 1 == length ] && InfraTimelikeGeodesicQ[ g, members ] ] ];

$lengthQ = g |-> AllTrue[ $comparablePairs @ g, pair |->
  InfraMeasurement[ g, InfraTimelikeGeodesic @@ pair, "Length" ] == $negatedDistance[ g, First @ pair, Last @ pair ] ];

$globalQ = g |-> With[ { height = Max @ CausalHeight @ g },
  InfraMeasurement[ g, InfraTimelikeGeodesic[ ], "Length" ] == height &&
    Sort @ RandomInfraTimelikeGeodesic[ g, All ] === Sort @ Select[ $sourceSinkPaths @ g, Length @ # - 1 == height & ] ];

$memberQ = g |-> AllTrue[ $comparablePairs @ g, pair |->
  With[ { geodesics = RandomInfraTimelikeGeodesic[ g, InfraTimelikeGeodesic @@ pair, All ] },
    AllTrue[ RandomInfraWorldline[ g, InfraWorldline @@ pair, All ],
      path |-> InfraMemberQ[ g, InfraTimelikeGeodesic @@ pair, path ] === MemberQ[ geodesics, path ] ] ] ];

VerificationTest[ $cardinalityQ[ $twoSource ], True, TestID -> "InfraTimelikeGeodesic-TwoSource-cardinality-counts-members" ]

VerificationTest[ $cardinalityQ[ $diamond ], True, TestID -> "InfraTimelikeGeodesic-Diamond-cardinality-counts-members" ]

VerificationTest[ $cardinalityQ[ $cylinder ], True, TestID -> "InfraTimelikeGeodesic-Cylinder-cardinality-counts-members" ]

VerificationTest[ $longestQ[ $diamond ], True, TestID -> "InfraTimelikeGeodesic-Diamond-members-are-longest-paths" ]

VerificationTest[ $longestQ[ $cylinder ], True, TestID -> "InfraTimelikeGeodesic-Cylinder-members-are-longest-paths" ]

VerificationTest[ $longestQ[ $shortcut ], True, TestID -> "InfraTimelikeGeodesic-Shortcut-members-are-longest-paths" ]

VerificationTest[ $membersQ[ $twoSource ], True, TestID -> "InfraTimelikeGeodesic-TwoSource-members-are-chains-of-length" ]

VerificationTest[ $membersQ[ $diamond ], True, TestID -> "InfraTimelikeGeodesic-Diamond-members-are-chains-of-length" ]

VerificationTest[ $membersQ[ $cylinder ], True, TestID -> "InfraTimelikeGeodesic-Cylinder-members-are-chains-of-length" ]

VerificationTest[ $lengthQ[ $diamond ], True, TestID -> "InfraTimelikeGeodesic-Diamond-length-is-negated-weighted-distance" ]

VerificationTest[ $lengthQ[ $cylinder ], True, TestID -> "InfraTimelikeGeodesic-Cylinder-length-is-negated-weighted-distance" ]

VerificationTest[ $lengthQ[ $shortcut ], True, TestID -> "InfraTimelikeGeodesic-Shortcut-length-is-negated-weighted-distance" ]

VerificationTest[
  InfraMeasurement[ $diamond, InfraTimelikeGeodesic[ { 0, 0 }, { 3, 3 } ], "Cardinality" ],
  Binomial[ 2 3, 3 ],
  TestID -> "InfraTimelikeGeodesic-Diamond-corner-to-corner-central-binomial"
]

VerificationTest[
  AllTrue[ $comparablePairs @ $diamond, pair |->
    InfraMeasurement[ $diamond, InfraTimelikeGeodesic @@ pair, "Cardinality" ] == Binomial[ Total[ Last @ pair - First @ pair ], First[ Last @ pair - First @ pair ] ] ],
  True,
  TestID -> "InfraTimelikeGeodesic-Diamond-cardinality-binomial"
]

VerificationTest[ $globalQ[ $twoSource ], True, TestID -> "InfraTimelikeGeodesic-TwoSource-global-longest-chains" ]

VerificationTest[ $globalQ[ $cylinder ], True, TestID -> "InfraTimelikeGeodesic-Cylinder-global-longest-chains" ]

VerificationTest[ $globalQ[ $shortcut ], True, TestID -> "InfraTimelikeGeodesic-Shortcut-global-longest-chains" ]

VerificationTest[
  { InfraWorldlineQ[ $shortcut, { 1, 5, 4 } ], InfraTimelikeGeodesicQ[ $shortcut, { 1, 5, 4 } ], InfraChainQ[ $twoSource, { 1, 2 } ], InfraChainQ[ $twoSource, { 3, 1 } ] },
  { True, False, False, False },
  TestID -> "InfraTimelikeGeodesicQ-Shortcut-rejects-short-observer"
]

VerificationTest[ $memberQ[ $diamond ], True, TestID -> "InfraTimelikeGeodesic-Diamond-InfraMemberQ-agrees-with-sampler" ]

VerificationTest[ $memberQ[ $shortcut ], True, TestID -> "InfraTimelikeGeodesic-Shortcut-InfraMemberQ-agrees-with-sampler" ]

VerificationTest[
  With[ { all = RandomInfraTimelikeGeodesic[ $diamond, InfraTimelikeGeodesic[ { 0, 0 }, { 3, 3 } ], All ] },
    { Length @ ( SeedRandom[ 2 ]; RandomInfraTimelikeGeodesic[ $diamond, { 0, 0 }, { 3, 3 }, 7 ] ),
      Length @ DeleteDuplicates @ ( SeedRandom[ 2 ]; RandomInfraTimelikeGeodesic[ $diamond, { 0, 0 }, { 3, 3 }, 7 ] ),
      SubsetQ[ all, ( SeedRandom[ 2 ]; RandomInfraTimelikeGeodesic[ $diamond, { 0, 0 }, { 3, 3 }, 7 ] ) ],
      RandomInfraTimelikeGeodesic[ $diamond, { 0, 0 }, { 3, 3 }, 21 ],
      Length @ RandomInfraTimelikeGeodesic[ $diamond, { 0, 0 }, { 3, 3 }, UpTo[ 30 ] ],
      MemberQ[ all, ( SeedRandom[ 2 ]; RandomInfraTimelikeGeodesic[ $diamond, { 0, 0 }, { 3, 3 } ] ) ],
      RandomInfraTimelikeGeodesic[ $diamond, { 0, 0 }, { 3, 3 }, 3, "NextVertexFunction" -> Identity ] === Take[ Sort @ all, 3 ] } ],
  { 7, 7, True, { }, 20, True, True },
  TestID -> "RandomInfraTimelikeGeodesic-Diamond-count-contract"
]

VerificationTest[
  RandomInfraTimelikeGeodesic[ $diamond, { 0, 0 }, { 3, 3 }, 3, RandomSeeding -> 1 ] === RandomInfraTimelikeGeodesic[ $diamond, { 0, 0 }, { 3, 3 }, 3, RandomSeeding -> 1 ],
  True,
  TestID -> "RandomInfraTimelikeGeodesic-Diamond-reproducible"
]

VerificationTest[
  Values @ InfraMeasurement[ $lattice, InfraTimelikeGeodesic @@ $knots, { "Cardinality", "Length" } ],
  { Binomial[ 3, 1 ] Binomial[ 5, 2 ], 3 + 5 },
  TestID -> "InfraTimelikeGeodesic-Lattice-polyline-product-cardinality-and-summed-length"
]

VerificationTest[ $polylineQ[ $lattice, $knots ], True, TestID -> "InfraTimelikeGeodesic-Lattice-polyline-members-concatenate-leg-geodesics" ]

VerificationTest[
  $polylineQ[ $lattice, { { 0, 0 }, { 1, 1 }, { 2, 1 }, { 4, 4 } } ] && $polylineQ[ $cylinder, { { 0, 0 }, { 1, 1 }, { 1, 3 } } ] && $polylineQ[ $shortcut, { 1, 3, 4 } ],
  True,
  TestID -> "InfraTimelikeGeodesic-Lattice-Cylinder-Shortcut-polyline-members-concatenate-leg-geodesics"
]

VerificationTest[
  With[ { members = RandomInfraTimelikeGeodesic[ $lattice, InfraTimelikeGeodesic @@ $knots, All ] },
    AllTrue[ RandomInfraWorldline[ $lattice, InfraWorldline[ { 0, 0 }, { 4, 4 } ], All ],
      path |-> InfraMemberQ[ $lattice, InfraTimelikeGeodesic @@ $knots, path ] === MemberQ[ members, path ] ] ],
  True,
  TestID -> "InfraTimelikeGeodesic-Lattice-polyline-InfraMemberQ-agrees-with-sampler"
]

VerificationTest[
  With[ { bad = InfraTimelikeGeodesic[ { 0, 0 }, { 4, 4 }, { 2, 1 } ] },
    { RandomInfraTimelikeGeodesic[ $lattice, bad, All ], RandomInfraTimelikeGeodesic[ $lattice, bad ], InfraMeasurement[ $lattice, bad, "Cardinality" ] } ],
  { { }, { }, 0 },
  TestID -> "InfraTimelikeGeodesic-Lattice-non-monotone-knots-empty-family"
]

VerificationTest[
  With[ { members = RandomInfraTimelikeGeodesic[ $lattice, InfraTimelikeGeodesic[ { 1, 1 } ], All ] },
    { Length @ members, Union[ Last /@ members ], Union[ Length /@ members ] - 1, InfraMeasurement[ $lattice, InfraTimelikeGeodesic[ { 1, 1 } ], "Length" ] } ],
  { 20, { { 4, 4 } }, { 6 }, 6 },
  TestID -> "InfraTimelikeGeodesic-Lattice-from-event-twenty-longest-chains-to-the-top"
]

VerificationTest[
  $fromQ[ $lattice, { 1, 1 } ] && $fromQ[ $cylinder, { 0, 0 } ] && $fromQ[ $shortcut, 1 ] && $fromQ[ $twoSource, 1 ] &&
    $fromQ[ Graph[ { 1 -> 2, 2 -> 3, 1 -> 4, 4 -> 5, 1 -> 6 } ], 1 ],
  True,
  TestID -> "InfraTimelikeGeodesic-Lattice-Cylinder-Shortcut-TwoSource-Branching-from-event-longest-chains"
]

VerificationTest[
  { RandomInfraTimelikeGeodesic[ $twoSource, InfraTimelikeGeodesic[ 2 ], All ], RandomInfraTimelikeGeodesic[ $twoSource, InfraTimelikeGeodesic[ 5 ], All ] },
  { { { 2, 4, 5 } }, { { 5 } } },
  TestID -> "InfraTimelikeGeodesic-TwoSource-from-event-literal"
]

VerificationTest[
  With[ { members = RandomInfraTimelikeGeodesic[ $lattice, InfraTimelikeGeodesic[ { 1, 1 } ], All ] },
    AllTrue[ members, InfraMemberQ[ $lattice, InfraTimelikeGeodesic[ { 1, 1 } ], # ] & ] &&
      ! InfraMemberQ[ $lattice, InfraTimelikeGeodesic[ { 1, 1 } ], { { 1, 1 }, { 2, 1 }, { 3, 1 } } ] ],
  True,
  TestID -> "InfraTimelikeGeodesic-Lattice-from-event-InfraMemberQ-agrees-with-sampler"
]

EndTestSection[]
