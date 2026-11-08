BeginTestSection["InfraWorldline"]

Needs[ "WolframInstitute`InfraGeometry`" ]

$twoSource = Graph[ { 1 -> 3, 2 -> 4, 3 -> 4, 4 -> 5 } ];

$diamond = Graph[ Flatten @ Table[
  Select[ { { i, j } -> { i + 1, j }, { i, j } -> { i, j + 1 } }, Max @ Last @ # <= 3 & ],
  { i, 0, 3 }, { j, 0, 3 } ] ];

$cylinder = Graph[ Flatten @ Table[
  { { k, t } -> { k, t + 1 }, { k, t } -> { Mod[ k + 1, 3 ], t + 1 } },
  { k, 0, 2 }, { t, 0, 2 } ] ];

$shortcut = Graph[ { 1 -> 2, 2 -> 3, 3 -> 4, 1 -> 5, 5 -> 4, 1 -> 3 } ];

$comparablePairs = g |-> Select[ Tuples[ VertexList @ g, 2 ], pair |-> MemberQ[ VertexOutComponent[ g, { First @ pair } ], Last @ pair ] ];

$paths = { g, p, q } |-> If[ p === q, { { p } }, FindPath[ g, p, q, Infinity, All ] ];

$saturatedQ = { g, path } |-> AllTrue[ Partition[ path, 2, 1 ], pair |-> FindPath[ g, First @ pair, Last @ pair, { 2, Infinity } ] === { } ];

$sourceSinkPaths = g |-> Catenate @ Catenate @ Outer[ $paths[ g, #1, #2 ] &,
  Pick[ VertexList @ g, VertexInDegree @ g, 0 ], Pick[ VertexList @ g, VertexOutDegree @ g, 0 ], 1 ];

$worldlineQ = g |-> AllTrue[ $comparablePairs @ g, pair |->
  Sort @ RandomInfraWorldline[ g, InfraWorldline @@ pair, All ] === Sort @ Select[ $paths[ g, First @ pair, Last @ pair ], path |-> $saturatedQ[ g, path ] ] ];

$containsGeodesicsQ = g |-> AllTrue[ $comparablePairs @ g, pair |->
  With[ { worldlines = RandomInfraWorldline[ g, InfraWorldline @@ pair, All ] },
    SubsetQ[ worldlines, RandomInfraTimelikeGeodesic[ g, InfraTimelikeGeodesic @@ pair, All ] ] && InfraWorldlineQ[ g, worldlines ] &&
      InfraMeasurement[ g, InfraWorldline @@ pair, "Cardinality" ] == Length @ worldlines ] ];

$lengthQ = g |-> AllTrue[ $comparablePairs @ g, pair |->
  InfraMeasurement[ g, InfraWorldline @@ pair, "Length" ] ===
    Replace[ Union[ Length /@ RandomInfraWorldline[ g, InfraWorldline @@ pair, All ] - 1 ], { one_ } :> one ] ];

$inextendibleQ = g |-> Sort @ RandomInfraWorldline[ g, All ] === Sort @ Select[ $sourceSinkPaths @ g, path |-> $saturatedQ[ g, path ] ];

VerificationTest[ $worldlineQ[ $diamond ], True, TestID -> "InfraWorldline-Diamond-members-are-saturated-paths" ]

VerificationTest[ $worldlineQ[ $shortcut ], True, TestID -> "InfraWorldline-Shortcut-members-are-saturated-paths" ]

VerificationTest[ $containsGeodesicsQ[ $diamond ], True, TestID -> "InfraWorldline-Diamond-contains-timelike-geodesics" ]

VerificationTest[ $containsGeodesicsQ[ $shortcut ], True, TestID -> "InfraWorldline-Shortcut-contains-timelike-geodesics" ]

VerificationTest[ $lengthQ[ $shortcut ], True, TestID -> "InfraWorldline-Shortcut-length-is-member-lengths" ]

VerificationTest[ InfraMeasurement[ $shortcut, InfraWorldline[ 1, 4 ], "Length" ], { 2, 3 }, TestID -> "InfraWorldline-Shortcut-two-proper-times" ]

VerificationTest[ $inextendibleQ[ $twoSource ], True, TestID -> "InfraWorldline-TwoSource-inextendible-saturated-chains" ]

VerificationTest[ $inextendibleQ[ $cylinder ], True, TestID -> "InfraWorldline-Cylinder-inextendible-saturated-chains" ]

VerificationTest[
  { InfraChainQ[ $shortcut, { 1, 3, 4 } ], InfraWorldlineQ[ $shortcut, { 1, 3, 4 } ],
    InfraChainQ[ $diamond, { { 0, 0 }, { 1, 1 } } ], InfraWorldlineQ[ $diamond, { { 0, 0 }, { 1, 1 } } ] },
  { True, False, True, False },
  TestID -> "InfraWorldlineQ-Shortcut-Diamond-rejects-unsaturated-chain"
]

VerificationTest[
  With[ { g = Graph[ { 1 -> 2, 1 -> 3, 2 -> 4, 3 -> 5, 3 -> 6, 4 -> 7, 5 -> 7, 6 -> 7 } ] },
    BlockRandom[ SeedRandom[ 3 ];
      Abs[ Count[ Table[ RandomInfraWorldline[ g, 1, 7, RandomSeeding -> None ], 1500 ], { 1, 2, 4, 7 } ] / 1500. - 1 / 3 ] < 0.04 ] ],
  True,
  TestID -> "RandomInfraWorldline-Branching-uniform-over-members"
]

EndTestSection[]
