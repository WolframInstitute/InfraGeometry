VerificationTest[
  With[{g = PathGraph[Range[6]], plane = InfraPlane[1, 6, {-1, 1}]},
    {all = Replace[ plane, { token_InfraPoint :> RandomInfraPoint[ g, token, All ], token_InfraSegment :> RandomInfraSegment[ g, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraCircle :> RandomInfraCircle[ g, token, All ], token_InfraArc :> RandomInfraArc[ g, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All ], token_InfraPlane :> RandomInfraPlane[ g, token, All ], token_InfraBall :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraShell :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraSphere :> RandomInfraSphere[ g, token, All ], token_InfraTube :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraCylinder :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraCone :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraSolidOfRevolution :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraBallHull :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraConvexHull :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraQuadric :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraWalk :> RandomInfraWalk[ g, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All ], token_InfraIntersection :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraUnion :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraRay :> RandomInfraHalfLine[ g, token, All ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, All ] } ]},
    {Sort[all] === {{3}, {4}},
     Replace[ plane, { token_InfraPoint :> RandomInfraPoint[ g, token, All, "NextVertexFunction" -> Identity ], token_InfraSegment :> RandomInfraSegment[ g, token, All, "NextVertexFunction" -> Identity ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All, "NextVertexFunction" -> Identity ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All, "NextVertexFunction" -> Identity ], token_InfraCircle :> RandomInfraCircle[ g, token, All, "NextVertexFunction" -> Identity ], token_InfraArc :> RandomInfraArc[ g, token, All, "NextVertexFunction" -> Identity ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All, "NextVertexFunction" -> Identity ], token_InfraPlane :> RandomInfraPlane[ g, token, All, "NextVertexFunction" -> Identity ], token_InfraBall :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraShell :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraSphere :> RandomInfraSphere[ g, token, All, "NextVertexFunction" -> Identity ], token_InfraTube :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraCylinder :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraCone :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraSolidOfRevolution :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraBallHull :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraConvexHull :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraQuadric :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraWalk :> RandomInfraWalk[ g, token, All, "NextVertexFunction" -> Identity ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All, "NextVertexFunction" -> Identity ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All, "NextVertexFunction" -> Identity ], token_InfraIntersection :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraUnion :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraRay :> RandomInfraHalfLine[ g, token, All, "NextVertexFunction" -> Identity ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, All, "NextVertexFunction" -> Identity ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, All, "NextVertexFunction" -> Identity ] } ] === all}],
  {True, True},
  TestID -> "NamedConstructionSampler-InfraPlane-All-is-deterministic"
]

VerificationTest[
  With[{g = PathGraph[Range[6]], plane = InfraPlane[1, 6, {-1, 1}]},
    {draw = BlockRandom[Replace[ plane, { token_InfraPoint :> RandomInfraPoint[ g, token, RandomSeeding -> None ], token_InfraSegment :> RandomInfraSegment[ g, token, RandomSeeding -> None ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, RandomSeeding -> None ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, RandomSeeding -> None ], token_InfraCircle :> RandomInfraCircle[ g, token, RandomSeeding -> None ], token_InfraArc :> RandomInfraArc[ g, token, RandomSeeding -> None ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, RandomSeeding -> None ], token_InfraPlane :> RandomInfraPlane[ g, token, RandomSeeding -> None ], token_InfraBall :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraShell :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraSphere :> RandomInfraSphere[ g, token, RandomSeeding -> None ], token_InfraTube :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraCylinder :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraCone :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraSolidOfRevolution :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraBallHull :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraConvexHull :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraQuadric :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraWalk :> RandomInfraWalk[ g, token, RandomSeeding -> None ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, RandomSeeding -> None ], token_InfraEllipse :> RandomInfraEllipse[ g, token, RandomSeeding -> None ], token_InfraIntersection :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraUnion :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraRay :> RandomInfraHalfLine[ g, token, RandomSeeding -> None ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, RandomSeeding -> None ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, RandomSeeding -> None ] } ], RandomSeeding -> 17]},
    {draw === BlockRandom[Replace[ plane, { token_InfraPoint :> RandomInfraPoint[ g, token, RandomSeeding -> None ], token_InfraSegment :> RandomInfraSegment[ g, token, RandomSeeding -> None ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, RandomSeeding -> None ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, RandomSeeding -> None ], token_InfraCircle :> RandomInfraCircle[ g, token, RandomSeeding -> None ], token_InfraArc :> RandomInfraArc[ g, token, RandomSeeding -> None ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, RandomSeeding -> None ], token_InfraPlane :> RandomInfraPlane[ g, token, RandomSeeding -> None ], token_InfraBall :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraShell :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraSphere :> RandomInfraSphere[ g, token, RandomSeeding -> None ], token_InfraTube :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraCylinder :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraCone :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraSolidOfRevolution :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraBallHull :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraConvexHull :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraQuadric :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraWalk :> RandomInfraWalk[ g, token, RandomSeeding -> None ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, RandomSeeding -> None ], token_InfraEllipse :> RandomInfraEllipse[ g, token, RandomSeeding -> None ], token_InfraIntersection :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraUnion :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraRay :> RandomInfraHalfLine[ g, token, RandomSeeding -> None ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, RandomSeeding -> None ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, RandomSeeding -> None ] } ], RandomSeeding -> 17],
     InfraPlaneQ[g, draw, 1, 6, {-1, 1}],
     Length @ DeleteDuplicates @ Table[
       BlockRandom[Replace[ plane, { token_InfraPoint :> RandomInfraPoint[ g, token, RandomSeeding -> None ], token_InfraSegment :> RandomInfraSegment[ g, token, RandomSeeding -> None ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, RandomSeeding -> None ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, RandomSeeding -> None ], token_InfraCircle :> RandomInfraCircle[ g, token, RandomSeeding -> None ], token_InfraArc :> RandomInfraArc[ g, token, RandomSeeding -> None ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, RandomSeeding -> None ], token_InfraPlane :> RandomInfraPlane[ g, token, RandomSeeding -> None ], token_InfraBall :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraShell :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraSphere :> RandomInfraSphere[ g, token, RandomSeeding -> None ], token_InfraTube :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraCylinder :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraCone :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraSolidOfRevolution :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraBallHull :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraConvexHull :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraQuadric :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraWalk :> RandomInfraWalk[ g, token, RandomSeeding -> None ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, RandomSeeding -> None ], token_InfraEllipse :> RandomInfraEllipse[ g, token, RandomSeeding -> None ], token_InfraIntersection :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraUnion :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraRay :> RandomInfraHalfLine[ g, token, RandomSeeding -> None ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, RandomSeeding -> None ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, RandomSeeding -> None ] } ], RandomSeeding -> s], {s, 1, 32}] > 1}],
  {True, True, True},
  TestID -> "NamedConstructionSampler-InfraPlane-random-and-seeded"
]

planeOracle[ g_Graph, p_, q_, window_List ] :=
  With[ { slab = FindInfraBisectingHyperplane[ g, p, q, window ],
      separatesQ = set |-> ! MemberQ[ VertexComponent[ VertexDelete[ g, set ], p ], q ] },
    Sort @ Select[ Subsets[ slab ], set |-> separatesQ[ set ] && NoneTrue[ set, v |-> separatesQ[ DeleteCases[ set, v ] ] ] ] ]

VerificationTest[
  And @@ Join[
    Flatten @ Table[ Sort @ FindInfraBisectingHyperplane[ GridGraph[ { 4, 4 } ], 1, q, w, All, Properties -> { "Separating" } ] ===
      planeOracle[ GridGraph[ { 4, 4 } ], 1, q, w ], { q, 2, 16 }, { w, { { 0, 0 }, { -1, 1 } } } ],
    Table[ Sort @ FindInfraBisectingHyperplane[ PetersenGraph[ ], 1, q, { -1, 1 }, All, Properties -> { "Separating" } ] ===
      planeOracle[ PetersenGraph[ ], 1, q, { -1, 1 } ], { q, 2, 10 } ],
    BlockRandom[ SeedRandom[ 261022 ]; Table[ With[ { g = RandomGraph[ { 8, RandomInteger[ { 8, 16 } ] } ] },
      { q = RandomInteger[ { 2, 8 } ], w = RandomChoice[ { { 0, 0 }, { -1, 1 }, { -2, 2 } } ] },
      ! ConnectedGraphQ[ g ] || Sort @ FindInfraBisectingHyperplane[ g, 1, q, w, All, Properties -> { "Separating" } ] === planeOracle[ g, 1, q, w ] ],
      { 25 } ] ] ],
  True,
  TestID -> "Separating-planes-are-all-minimal-separators-in-the-slab"
]

VerificationTest[
  With[ { g = InfraSubstrate[ "SquareGridGraph", "Small" ] },
    { planes = TimeConstrained[ FindInfraBisectingHyperplane[ g, 45, 56, All, Properties -> { "Separating" } ], 60 ] },
    { separatesQ = set |-> ! MemberQ[ VertexComponent[ VertexDelete[ g, set ], 45 ], 56 ] },
    { Length[ planes ], Union[ Length /@ planes ], DuplicateFreeQ[ planes ],
      AllTrue[ planes[[ ;; ;; 37 ]], set |-> separatesQ[ set ] && NoneTrue[ set, v |-> separatesQ[ DeleteCases[ set, v ] ] ] ] } ],
  { 1369, { 8, 9, 10 }, True, True },
  TestID -> "grid-diagonal-pair-has-1369-planes"
]

(* the walls of the slab: the connected separating subsets of slab - {p, q} with no proper connected separating subset, by brute force *)
wallOracle[ g_Graph, p_, q_, window_List ] :=
  With[ { slab = DeleteCases[ FindInfraBisectingHyperplane[ g, p, q, window ], p | q ],
      separatesQ = set |-> ! MemberQ[ VertexComponent[ VertexDelete[ g, set ], p ], q ] },
    { admissible = Select[ Subsets[ slab ], set |-> ConnectedGraphQ @ Subgraph[ g, set ] && separatesQ[ set ] ] },
    Sort @ Fold[ { minimal, set } |-> If[ AnyTrue[ minimal, SubsetQ[ set, # ] & ], minimal, Append[ minimal, set ] ], { }, admissible ] ]

$wallCases := Join[
  Table[ { GridGraph[ { 4, 4 } ], 1, q, { 0, 0 } }, { q, 2, 16 } ],
  Flatten[ Table[ { GridGraph[ { 5, 5 } ], 13, q, w }, { q, { 3, 7, 8, 9, 14, 15, 19 } }, { w, { { 0, 0 }, { -1, 1 } } } ], 1 ],
  Table[ { PetersenGraph[ ], 1, q, { -1, 1 } }, { q, 2, 10 } ],
  Table[ { IndexGraph @ GraphProduct[ CycleGraph[ 3 ], CycleGraph[ 3 ], "Cartesian" ], 1, q, { -1, 1 } }, { q, 2, 9 } ],
  Table[ { InfraSubstrate[ "SquareMeshGraph", "Small" ], 5, q, { 0, 0 } }, { q, VertexList @ NeighborhoodGraph[ InfraSubstrate[ "SquareMeshGraph", "Small" ], 5, 2 ] } ] ]

VerificationTest[
  With[ { checked = Select[ $wallCases, case |-> Length[ FindInfraBisectingHyperplane @@ case ] <= 12 ] },
    { Length @ checked, Count[ checked, case_ /; FindInfraBisectingHyperplane @@ case =!= { } ],
      Select[ checked, case |-> FindInfraBisectingHyperplane @@ Join[ case, { All, Properties -> { "Separating", "Connected" } } ] =!= wallOracle @@ case ] } ],
  { 46, 36, { } },
  TestID -> "Connected-planes-are-all-walls-in-the-slab"
]

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    { separating = FindInfraBisectingHyperplane[ g, 1, 4, { -1, 1 }, All, Properties -> { "Separating" } ],
      walls = FindInfraBisectingHyperplane[ g, 1, 4, { -1, 1 }, All, Properties -> { "Separating", "Connected" } ] },
    { SubsetQ[ walls, Select[ separating, ConnectedGraphQ @ Subgraph[ g, # ] & ] ], Length @ separating, Length @ walls } ],
  { True, 16, 6 },
  TestID -> "Connected-minimal-separators-are-walls"
]

(* on the square grid no minimal separator of a diagonal pair is connected, and neither is any wall in its bisector *)
VerificationTest[
  With[ { g = InfraSubstrate[ "SquareGridGraph", "Small" ] },
    { FindInfraBisectingHyperplane[ g, 45, 56, All, Properties -> { "Separating", "Connected" } ],
      FindInfraBisectingHyperplane[ g, 45, 47, All, Properties -> { "Separating", "Connected" } ],
      Length /@ FindInfraBisectingHyperplane[ g, 45, 48, { -1, 1 }, UpTo[ 2 ], Properties -> { "Separating", "Connected" } ] } ],
  { { }, { { 16, 26, 36, 46, 56, 66, 76, 86 } }, { 8, 9 } },
  TestID -> "grid-walls-of-axis-and-diagonal-pairs"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ], props = Properties -> { "Separating", "Connected" } },
    { walls = Join @@ Table[ FindInfraBisectingHyperplane[ g, 13, q, { -1, 1 }, All, props ], { q, { 8, 9, 14, 15 } } ] },
    AllTrue[ Flatten[ Table[ RandomInfraPlane[ g, 13, q, { -1, 1 }, UpTo[ 3 ], props, RandomSeeding -> s ], { q, { 8, 9, 14, 15 } }, { s, 10 } ], 2 ],
      MemberQ[ walls, # ] & ] ],
  True,
  TestID -> "every-greedy-plane-draw-is-a-wall"
]

VerificationTest[
  With[ { g = InfraSubstrate[ "SquareMeshGraph", "Small" ], props = Properties -> { "Separating", "Connected" } }, { p = First @ GraphCenter[ g ] },
    { q = RandomInfraPoint[ g, InfraShell[ p, 2 ], RandomSeeding -> 1 ] },
    { draws = RandomInfraPlane[ g, InfraPlane[ p, q, { -1, 1 } ], 3, props, RandomSeeding -> 1 ] },
    { Length @ draws, DuplicateFreeQ @ draws, draws === RandomInfraPlane[ g, InfraPlane[ p, q, { -1, 1 } ], 3, props, RandomSeeding -> 1 ],
      AllTrue[ draws, InfraPlaneQ[ g, #, p, q, 1 ] && ConnectedGraphQ @ Subgraph[ g, # ] & ],
      FindInfraBisectingHyperplane[ g, p, q, { -1, 1 }, props ] === FindInfraBisectingHyperplane[ g, p, q, { -1, 1 }, props, "NextVertexFunction" -> Identity ],
      First @ AbsoluteTiming[ RandomInfraPlane[ g, InfraPlane[ p, q, { -1, 1 } ], props, RandomSeeding -> 2 ] ] < 1 } ],
  { 3, True, True, True, True, True },
  TestID -> "mesh-random-walls-distinct-seeded-quick"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    { RandomInfraPlane[ g, InfraPlane[ 13, 3 ], All ] === FindInfraBisectingHyperplane[ g, 13, 3, All, Properties -> { "Separating" } ],
      RandomInfraPlane[ g, InfraPlane[ 13, 9, { -1, 1 } ], All, Properties -> { "Separating", "Connected" } ] ===
        FindInfraBisectingHyperplane[ g, 13, 9, { -1, 1 }, All, Properties -> { "Separating", "Connected" } ] } ],
  { True, True },
  TestID -> "RandomInfraPlane-Properties-default-is-the-separators"
]

VerificationTest[
  With[ { g = InfraSubstrate[ "SquareMeshGraph", "Small" ] }, { p = First @ GraphCenter[ g ] },
    { q = RandomInfraPoint[ g, InfraShell[ p, 2 ], RandomSeeding -> 1 ] },
    { planes = TimeConstrained[ RandomInfraPlane[ g, InfraPlane[ p, q, { -1, 1 } ], 3, RandomSeeding -> 1 ], 60 ] },
    { Length[ planes ], DuplicateFreeQ[ planes ], AllTrue[ planes, InfraPlaneQ[ g, #, p, q, 1 ] & ] } ],
  { 3, True, True },
  TestID -> "mesh-random-planes-with-a-count"
]

VerificationTest[
  With[ { g = InfraSubstrate[ "SquareGridGraph", "Small" ] },
    { scene = InfraScene[ { pA, pB, h }, { pA == InfraPoint[ 45 ], pB == InfraPoint[ 56 ], h == InfraPlane[ pA, pB ] } ] },
    Length @ TimeConstrained[ RandomInfraSceneInstance[ scene, g, All ], 60 ] ],
  1369,
  TestID -> "plane-in-scene"
]
