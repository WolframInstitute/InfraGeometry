BeginTestSection["InfraLightCone"]

Needs[ "WolframInstitute`InfraGeometry`" ]

$twoSource = Graph[ { 1 -> 3, 2 -> 4, 3 -> 4, 4 -> 5 } ];

$random12 = Graph[ Range[ 12 ], { 1 -> 2, 1 -> 6, 1 -> 9, 1 -> 10, 1 -> 12, 2 -> 3, 2 -> 6, 2 -> 10, 2 -> 11, 2 -> 12, 3 -> 6, 4 -> 6, 4 -> 7,
  4 -> 8, 5 -> 6, 6 -> 12, 7 -> 11, 8 -> 9, 9 -> 10, 10 -> 12 } ];

$diamond = Graph[ Flatten @ Table[
  Select[ { { i, j } -> { i + 1, j }, { i, j } -> { i, j + 1 } }, Max @ Last @ # <= 3 & ],
  { i, 0, 3 }, { j, 0, 3 } ] ];

$cylinder = Graph[ Flatten @ Table[
  { { k, t } -> { k, t + 1 }, { k, t } -> { Mod[ k + 1, 3 ], t + 1 } },
  { k, 0, 2 }, { t, 0, 2 } ] ];

$outgoingRaysTwoSource = <| 1 -> { 1, 3, 4, 5 }, 2 -> { 2, 4, 5 }, 3 -> { 3, 4, 5 }, 4 -> { 4, 5 }, 5 -> { 5 } |>;

$outgoingRaysRandom12 = <| 1 -> { 1, 2, 3, 6, 9, 11 }, 2 -> { 2, 3, 6, 10, 11 }, 3 -> { 3, 6, 12 }, 4 -> { 4, 6, 7, 8, 9, 10, 11 },
  5 -> { 5, 6, 12 }, 6 -> { 6, 12 }, 7 -> { 7, 11 }, 8 -> { 8, 9, 10, 12 }, 9 -> { 9, 10, 12 }, 10 -> { 10, 12 }, 11 -> { 11 }, 12 -> { 12 } |>;

$incomingRaysRandom12 = <| 1 -> { 1 }, 2 -> { 1, 2 }, 3 -> { 1, 2, 3 }, 4 -> { 4 }, 5 -> { 5 }, 6 -> { 1, 2, 3, 4, 5, 6 }, 7 -> { 4, 7 },
  8 -> { 4, 8 }, 9 -> { 1, 4, 8, 9 }, 10 -> { 2, 4, 8, 9, 10 }, 11 -> { 1, 2, 4, 7, 11 }, 12 -> { 3, 5, 6, 8, 9, 10, 12 } |>;

$longestChain = { g, v, e } |-> If[ v === e, 0, Max[ Length /@ FindPath[ g, v, e, Infinity, All ] ] - 1 ];

$cone = { g, v } |-> Keys @ InfraMeasurement[ g, InfraFutureLightCone[ v ], "VertexDensity" ];

$inFutureQ = g |-> AllTrue[ VertexList @ g, v |-> SubsetQ[ VertexOutComponent[ g, { v } ], $cone[ g, v ] ] ];

$nullQ = g |-> AllTrue[ VertexList @ g, v |-> AllTrue[ $cone[ g, v ],
  e |-> Length @ Intersection[ VertexOutComponent[ g, { v } ], VertexInComponent[ g, { e } ] ] == 1 + $longestChain[ g, v, e ] ] ];

$treeQ = g |-> AllTrue[ VertexList @ g, v |-> With[ { tree = InfraMeasurement[ g, InfraFutureLightCone[ v ], "Graph" ] },
  TreeGraphQ @ tree && Pick[ VertexList @ tree, VertexInDegree @ tree, 0 ] === { v } ] ];

$pastTreeQ = g |-> AllTrue[ VertexList @ g, v |-> With[ { tree = InfraMeasurement[ g, InfraPastLightCone[ v ], "Graph" ] },
  TreeGraphQ @ UndirectedGraph @ tree && Pick[ VertexList @ tree, VertexOutDegree @ tree, 0 ] === { v } ] ];

$raysQ = g |-> AllTrue[ VertexList @ g, v |-> With[ { rays = RandomInfraFutureLightCone[ g, v, All ] },
  AllTrue[ rays, ray |-> First @ ray === v && InfraChainQ[ g, ray ] ] && Union @ Catenate @ rays === $cone[ g, v ] ] ];

$pastRaysQ = g |-> AllTrue[ VertexList @ g, v |-> With[ { rays = RandomInfraPastLightCone[ g, v, All ] },
  AllTrue[ rays, ray |-> Last @ ray === v && InfraChainQ[ g, ray ] ] &&
    Sort @ rays === Sort[ Reverse /@ RandomInfraFutureLightCone[ ReverseGraph @ g, v, All ] ] ] ];

$cardinalityQ = g |-> AllTrue[ VertexList @ g, v |->
  InfraMeasurement[ g, InfraFutureLightCone[ v ], "Cardinality" ] == Length @ RandomInfraFutureLightCone[ g, v, All ] &&
    InfraMeasurement[ g, InfraFutureLightCone[ v ], "Length" ] === Replace[ Union[ Length /@ RandomInfraFutureLightCone[ g, v, All ] - 1 ], { one_ } :> one ] ];

$memberQ = g |-> AllTrue[ VertexList @ g, v |-> With[ { rays = RandomInfraFutureLightCone[ g, v, All ] },
  AllTrue[ rays, ray |-> InfraMemberQ[ g, InfraFutureLightCone[ v ], ray ] ] &&
    NoneTrue[ Select[ rays, Length @ # >= 2 & ], ray |-> InfraMemberQ[ g, InfraFutureLightCone[ v ], Most @ ray ] ] ] ];

$hierarchyQ = g |-> AllTrue[ Select[ Tuples[ VertexList @ g, 2 ], pair |-> MemberQ[ VertexOutComponent[ g, { First @ pair } ], Last @ pair ] ],
  pair |-> AllTrue[ If[ SameQ @@ pair, { { First @ pair } }, FindPath[ g, First @ pair, Last @ pair, Infinity, All ] ],
    path |-> Implies[ InfraLightRayQ[ g, path ], InfraTimelikeGeodesicQ[ g, path ] ] && Implies[ InfraTimelikeGeodesicQ[ g, path ], InfraWorldlineQ[ g, path ] ] &&
      Implies[ InfraWorldlineQ[ g, path ], InfraChainQ[ g, path ] ] ] ];

$sampledHierarchyQ = g |-> AllTrue[ VertexList @ g, v |->
  With[ { rays = Join[ RandomInfraFutureLightCone[ g, v, All ], RandomInfraPastLightCone[ g, v, All ] ] },
    InfraLightRayQ[ g, rays ] && InfraTimelikeGeodesicQ[ g, rays ] && InfraWorldlineQ[ g, rays ] && InfraChainQ[ g, rays ] ] ];

VerificationTest[
  KeySort @ AssociationMap[ $cone[ $twoSource, # ] &, VertexList @ $twoSource ],
  $outgoingRaysTwoSource,
  TestID -> "InfraFutureLightCone-TwoSource-support-equals-old-outgoing-rays"
]

VerificationTest[
  AssociationMap[ $cone[ $random12, # ] &, VertexList @ $random12 ],
  $outgoingRaysRandom12,
  TestID -> "InfraFutureLightCone-Random12-support-equals-old-outgoing-rays"
]

VerificationTest[
  AssociationMap[ Keys @ InfraMeasurement[ $random12, InfraPastLightCone[ # ], "VertexDensity" ] &, VertexList @ $random12 ],
  $incomingRaysRandom12,
  TestID -> "InfraPastLightCone-Random12-support-equals-old-incoming-rays"
]

VerificationTest[ $inFutureQ[ $twoSource ], True, TestID -> "InfraFutureLightCone-TwoSource-in-causal-future" ]

VerificationTest[ $inFutureQ[ $random12 ], True, TestID -> "InfraFutureLightCone-Random12-in-causal-future" ]

VerificationTest[ $nullQ[ $random12 ], True, TestID -> "InfraFutureLightCone-Random12-diamond-is-chain" ]

VerificationTest[ $nullQ[ $cylinder ], True, TestID -> "InfraFutureLightCone-Cylinder-diamond-is-chain" ]

VerificationTest[ $treeQ[ $random12 ], True, TestID -> "InfraFutureLightCone-Random12-graph-is-tree-from-v" ]

VerificationTest[ $treeQ[ $diamond ], True, TestID -> "InfraFutureLightCone-Diamond-graph-is-tree-from-v" ]

VerificationTest[ $treeQ[ $cylinder ], True, TestID -> "InfraFutureLightCone-Cylinder-graph-is-tree-from-v" ]

VerificationTest[ $pastTreeQ[ $random12 ], True, TestID -> "InfraPastLightCone-Random12-graph-is-tree-into-v" ]

VerificationTest[ $raysQ[ $random12 ], True, TestID -> "RandomInfraFutureLightCone-Random12-rays-are-chains-from-v" ]

VerificationTest[ $raysQ[ $diamond ], True, TestID -> "RandomInfraFutureLightCone-Diamond-rays-are-chains-from-v" ]

VerificationTest[ $pastRaysQ[ $random12 ], True, TestID -> "RandomInfraPastLightCone-Random12-time-reverse-of-future" ]

VerificationTest[ $pastRaysQ[ $cylinder ], True, TestID -> "RandomInfraPastLightCone-Cylinder-time-reverse-of-future" ]

VerificationTest[
  Sort @ RandomInfraFutureLightCone[ $diamond, { 1, 1 }, All ],
  { { { 1, 1 }, { 1, 2 }, { 1, 3 } }, { { 1, 1 }, { 2, 1 }, { 3, 1 } } },
  TestID -> "RandomInfraFutureLightCone-Diamond-two-null-rays"
]

VerificationTest[ $cardinalityQ[ $random12 ], True, TestID -> "InfraFutureLightCone-Random12-cardinality-and-length" ]

VerificationTest[ $cardinalityQ[ $cylinder ], True, TestID -> "InfraFutureLightCone-Cylinder-cardinality-and-length" ]

VerificationTest[ $memberQ[ $random12 ], True, TestID -> "InfraFutureLightCone-Random12-InfraMemberQ-agrees-with-sampler" ]

VerificationTest[ $memberQ[ $diamond ], True, TestID -> "InfraFutureLightCone-Diamond-InfraMemberQ-agrees-with-sampler" ]

VerificationTest[ $sampledHierarchyQ[ $random12 ], True, TestID -> "InfraLightRayQ-Random12-sampled-rays-pass-hierarchy" ]

VerificationTest[ $sampledHierarchyQ[ $cylinder ], True, TestID -> "InfraLightRayQ-Cylinder-sampled-rays-pass-hierarchy" ]

VerificationTest[ $hierarchyQ[ $random12 ], True, TestID -> "InfraLightRayQ-Random12-hierarchy-on-all-paths" ]

VerificationTest[ $hierarchyQ[ $diamond ], True, TestID -> "InfraLightRayQ-Diamond-hierarchy-on-all-paths" ]

VerificationTest[
  { InfraLightRayQ[ $diamond, { { 0, 0 }, { 0, 1 }, { 0, 2 } } ], InfraLightRayQ[ $diamond, { { 0, 0 }, { 0, 1 }, { 1, 1 } } ],
    InfraTimelikeGeodesicQ[ $diamond, { { 0, 0 }, { 0, 1 }, { 1, 1 } } ] },
  { True, False, True },
  TestID -> "InfraLightRayQ-Diamond-timelike-worldline-is-not-a-ray"
]

EndTestSection[]
