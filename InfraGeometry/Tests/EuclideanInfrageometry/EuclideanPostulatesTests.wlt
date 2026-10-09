BeginTestSection["EuclideanPostulates"]

walkGraph       = walk |-> PathGraph[ MapIndexed[ { First @ #2, #1 } &, walk ], DirectedEdges -> True ];
geodesicGraph      = WolframInstitute`InfraGeometry`PackageScope`geodesicGraph;
geodesicCycleGraph = WolframInstitute`InfraGeometry`PackageScope`geodesicCycleGraph;
walkSequence       = WolframInstitute`InfraGeometry`PackageScope`walkSequence;
infraSpread        = WolframInstitute`InfraGeometry`PackageScope`infraSpread;
closedWalkGraph = walk |-> With[ { core = MapIndexed[ { First @ #2, #1 } &, If[ Length[ walk ] >= 2 && First @ walk === Last @ walk, Most @ walk, walk ] ] },
  Graph[ core, DirectedEdge @@@ Partition[ core, 2, 1, 1 ] ] ];
walkSeq[ w_Graph ] := Last /@ VertexList[ w ]
walkSeqs[ ws_List ] := walkSeq /@ ws
stopAt[ q_ ] := "StoppingCondition" -> ( Last[ # ] === q & )
endingAt[ ws_List, q_ ] := Select[ ws, Last @ Last @ VertexList @ # === q & ]

(* ===== RandomInfraPoint ===== *)

(* RandomInfraPoint[graph, reg, n] after RandomPoint[reg, n]: the region is a vertex List, a density or an inert head,
   its pool the keys of the density; "PairwiseDistance" is a condition on the drawn tuple (FindInfraPointRegion, T1). *)

VerificationTest[
  With[ { g = PetersenGraph[ ] },
    MemberQ[ VertexList @ g, RandomInfraPoint[ g ] ] ],
  True,
  TestID -> "RandomInfraPoint-single-vertex"
]

VerificationTest[
  With[ { g = PetersenGraph[ ] },
    With[ { pts = RandomInfraPoint[ g, 3 ] },
      Length @ pts == 3 && DuplicateFreeQ @ pts && SubsetQ[ VertexList @ g, pts ] ] ],
  True,
  TestID -> "RandomInfraPoint-multiple-vertices"
]

VerificationTest[
  Keys @ Options @ RandomInfraPoint,
  { "PairwiseDistance", "MaxCliques" },
  TestID -> "RandomInfraPoint-options-From-and-Distance-gone"
]

VerificationTest[
  With[ { g = PathGraph[ Range[ 5 ] ] },
    { RandomInfraPoint[ g, { 5 } ], Length @ RandomInfraPoint[ g, 5 ] } ],
  { 5, 5 },
  TestID -> "RandomInfraPoint-bare-integer-is-a-count"
]

(* ----- one pool test per row of the translation table ----- *)

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    Sort @ RandomInfraPoint[ g, GraphCenter @ g, All ] === Sort @ GraphCenter @ g ],
  True,
  TestID -> "RandomInfraPoint-pool-center"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    RandomInfraPoint[ g, { First @ GraphCenter @ g } ] ],
  13,
  TestID -> "RandomInfraPoint-pool-one-vertex"
]

VerificationTest[
  With[ { g = PathGraph[ Range[ 5 ] ] },
    Sort @ RandomInfraPoint[ g, GraphPeriphery @ g, All ] ],
  { 1, 5 },
  TestID -> "RandomInfraPoint-pool-periphery"
]

VerificationTest[
  Sort @ RandomInfraPoint[ PetersenGraph[ ], { 4, 2, 3, 2 }, All ],
  { 2, 3, 4 },
  TestID -> "RandomInfraPoint-pool-vertex-list-distinct"
]

VerificationTest[
  With[ { g = PetersenGraph[ ] },
    { pts = RandomInfraPoint[ g, { 2, 3, 4 }, 2 ] },
    Length @ pts == 2 && SubsetQ[ { 2, 3, 4 }, pts ] ],
  True,
  TestID -> "RandomInfraPoint-draw-from-vertex-list"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    Sort @ RandomInfraPoint[ g, FindInfraMidpoint[ g, 1, 25 ], All ] ===
      Select[ VertexList @ g, v |-> GraphDistance[ g, 1, v ] == 4 && GraphDistance[ g, v, 25 ] == 4 ] ],
  True,
  TestID -> "RandomInfraPoint-pool-density-support"
]

VerificationTest[
  With[ { g = GridGraph[ { 9, 9 } ] },
    Sort @ RandomInfraPoint[ g, InfraShell[ 41, 3 ], All ] === Select[ VertexList @ g, GraphDistance[ g, 41, # ] == 3 & ] ],
  True,
  TestID -> "RandomInfraPoint-pool-shell"
]

VerificationTest[
  With[ { g = GridGraph[ { 9, 9 } ] },
    Sort @ RandomInfraPoint[ g, InfraShell[ 41, { 2, 3 } ], All ] ===
      Select[ VertexList @ g, 2 <= GraphDistance[ g, 41, # ] <= 3 & ] ],
  True,
  TestID -> "RandomInfraPoint-pool-shell-band"
]

VerificationTest[
  With[ { g = GridGraph[ { 9, 9 } ] },
    Sort @ RandomInfraPoint[ g, InfraBall[ 41, 2 ], All ] === Select[ VertexList @ g, GraphDistance[ g, 41, # ] <= 2 & ] ],
  True,
  TestID -> "RandomInfraPoint-pool-ball"
]

VerificationTest[
  With[ { g = CycleGraph[ 9 ] },
    Sort @ RandomInfraPoint[ g, InfraShell[ 1, VertexEccentricity[ g, 1 ] ], All ] ],
  { 5, 6 },
  TestID -> "RandomInfraPoint-pool-farthest"
]

VerificationTest[
  With[ { g = GridGraph[ { 9, 9 } ] },
    Sort @ RandomInfraPoint[ g, InfraIntersection[ InfraShell[ 1, 8 ], InfraShell[ 81, 8 ] ], All ] ===
      Select[ VertexList @ g, GraphDistance[ g, 1, # ] == 8 && GraphDistance[ g, 81, # ] == 8 & ] ],
  True,
  TestID -> "RandomInfraPoint-pool-every-anchor"
]

(* the distance to a vertex set C is d(v, C) = min over c in C of d(v, c): the shell about C is a layer of the set *)

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    Sort @ RandomInfraPoint[ g, InfraShell[ GraphCenter @ g, 1 ], All ] ===
      Select[ VertexList @ g, v |-> Min[ GraphDistance[ g, #, v ] & /@ GraphCenter @ g ] == 1 ] ],
  True,
  TestID -> "RandomInfraPoint-pool-shell-about-center"
]

VerificationTest[
  With[ { g = GridGraph[ { 6, 6 } ] },
    Sort @ RandomInfraPoint[ g, InfraBall[ GraphCenter @ g, 1 ], All ] ===
      Select[ VertexList @ g, v |-> Min[ GraphDistance[ g, #, v ] & /@ GraphCenter @ g ] <= 1 ] ],
  True,
  TestID -> "RandomInfraPoint-pool-ball-about-center"
]

VerificationTest[
  With[ { g = GridGraph[ { 10, 10 } ] },
    { pool = Sort @ RandomInfraPoint[ g, InfraBall[ { 12, 89 }, 3 ], All ] },
    { Length @ pool,
      pool === Union[ Select[ VertexList @ g, GraphDistance[ g, 12, # ] <= 3 & ], Select[ VertexList @ g, GraphDistance[ g, 89, # ] <= 3 & ] ] } ],
  { 34, True },
  TestID -> "RandomInfraPoint-pool-union-of-balls"
]

VerificationTest[
  With[ { g = GridGraph[ { 10, 10 } ] },
    { pool = Sort @ RandomInfraPoint[ g, InfraShell[ { 45, 47 }, 2 ], All ] },
    { Length @ pool, IntersectingQ[ pool, { 45, 47 } ],
      pool === Select[ VertexList @ g, Min[ GraphDistance[ g, 45, # ], GraphDistance[ g, 47, # ] ] == 2 & ] } ],
  { 12, False, True },
  TestID -> "RandomInfraPoint-pool-shell-of-a-set-is-the-outer-layer"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    Sort @ RandomInfraPoint[ g, InfraSegment[ 1, 13 ], All ] ===
      Select[ VertexList @ g, GraphDistance[ g, 1, # ] + GraphDistance[ g, #, 13 ] == GraphDistance[ g, 1, 13 ] & ] ],
  True,
  TestID -> "RandomInfraPoint-pool-segment"
]

VerificationTest[
  Sort @ RandomInfraPoint[ PathGraph[ Range[ 6 ] ], InfraLine[ 2, 3 ], All ],
  Range[ 6 ],
  TestID -> "RandomInfraPoint-pool-line"
]

VerificationTest[
  Sort @ RandomInfraPoint[ GridGraph[ { 5, 5 } ], InfraUnion[ InfraShell[ 1, 1 ], InfraShell[ 25, 1 ] ], All ],
  { 2, 6, 20, 24 },
  TestID -> "RandomInfraPoint-pool-union"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    Sort @ RandomInfraPoint[ g, Complement[ VertexList @ g, RandomInfraPoint[ g, InfraBall[ 13, 1 ], All ] ], All ] ===
      Select[ VertexList @ g, GraphDistance[ g, 13, # ] > 1 & ] ],
  True,
  TestID -> "RandomInfraPoint-pool-complement"
]

(* ----- "PairwiseDistance": a condition on the drawn tuple ----- *)

VerificationTest[
  Sort @ RandomInfraPoint[ PathGraph[ Range[ 5 ] ], 2, "PairwiseDistance" -> 4 ],
  { 1, 5 },
  TestID -> "RandomInfraPoint-pairwise-distance-exact"
]

VerificationTest[
  With[ { g = GridGraph[ { 6, 6 } ] },
    With[ { vs = RandomInfraPoint[ g, 4, "PairwiseDistance" -> "Max" ] },
      Min[ GraphDistance[ g, #[[ 1 ]], #[[ 2 ]] ] & /@ Subsets[ vs, { 2 } ] ] == 5 ] ],
  True,
  TestID -> "RandomInfraPoint-Max-maximizes-minimum-gap"
]

VerificationTest[
  With[ { g = GridGraph[ { 6, 6 } ] },
    With[ { spread = RandomInfraPoint[ g, 4, "PairwiseDistance" -> "Spread" ], corners = { 1, 6, 31, 36 } },
      With[ { spreadDists = GraphDistance[ g, #[[ 1 ]], #[[ 2 ]] ] & /@ Subsets[ spread, { 2 } ],
              cornerDists = GraphDistance[ g, #[[ 1 ]], #[[ 2 ]] ] & /@ Subsets[ corners, { 2 } ] },
        Min @ spreadDists == 5 && Variance @ spreadDists <= Variance @ cornerDists ] ] ],
  True,
  TestID -> "RandomInfraPoint-Spread-minimizes-variance-at-optimal-gap"
]

VerificationTest[
  With[ { g = GridGraph[ { 7, 7 } ] },
    { shell = Select[ VertexList @ g, GraphDistance[ g, 25, # ] == 3 & ],
      gap = s |-> Min[ GraphDistance[ g, #[[ 1 ]], #[[ 2 ]] ] & /@ Subsets[ s, { 2 } ] ] },
    { pts = ( SeedRandom[ 1 ]; RandomInfraPoint[ g, InfraShell[ GraphCenter @ g, 3 ], 3, "PairwiseDistance" -> "Max" ] ) },
    Length @ pts == 3 && SubsetQ[ shell, pts ] && gap @ pts == Max[ gap /@ Subsets[ shell, { 3 } ] ] ],
  True,
  TestID -> "RandomInfraPoint-spread-on-the-circle-about-the-center"
]

VerificationTest[
  With[ { g = GridGraph[ { 7, 7 } ] },
    AllTrue[
      Tuples[ { { InfraBall[ 25, 3 ], InfraShell[ 25, { 2, 3 } ], InfraSegment[ 1, 49 ], InfraUnion[ InfraBall[ 1, 2 ], InfraBall[ 49, 2 ] ] },
        Range[ 5 ] } ],
      Apply[ { reg, seed } |-> With[ { pool = Keys @ InfraMeasurement[ g, reg, "VertexDensity" ] },
        { pts = ( SeedRandom[ seed ]; RandomInfraPoint[ g, reg, 3, "PairwiseDistance" -> { 2, 4 } ] ) },
        Length @ pts == 3 && DuplicateFreeQ @ pts && SubsetQ[ pool, pts ] &&
          AllTrue[ Subsets[ pts, { 2 } ], 2 <= GraphDistance[ g, #[[ 1 ]], #[[ 2 ]] ] <= 4 & ] ] ] ] ],
  True,
  TestID -> "RandomInfraPoint-draws-lie-in-the-region-and-meet-the-pairwise-distance"
]

VerificationTest[
  With[ { g = GridGraph[ { 7, 7 } ] },
    AllTrue[ Range[ 5 ],
      seed |-> With[ { pts = ( SeedRandom[ seed ]; RandomInfraPoint[ g, InfraBall[ 25, 2 ], 2, "PairwiseDistance" -> "Max" ] ) },
        SubsetQ[ Select[ VertexList @ g, GraphDistance[ g, 25, # ] <= 2 & ], pts ] && GraphDistance[ g, Sequence @@ pts ] == 4 ] ] ],
  True,
  TestID -> "RandomInfraPoint-Max-draws-lie-in-the-region"
]

(* ----- empty results ----- *)

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    { RandomInfraPoint[ g, { } ], RandomInfraPoint[ g, { }, 2 ], RandomInfraPoint[ g, { }, UpTo[ 2 ] ], RandomInfraPoint[ g, { }, All ],
      RandomInfraPoint[ g, { }, 2, "PairwiseDistance" -> "Max" ] } ],
  { { }, { }, { }, { }, { } },
  TestID -> "RandomInfraPoint-empty-vertex-list"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    { RandomInfraPoint[ g, InfraShell[ 13, 100 ] ], RandomInfraPoint[ g, InfraShell[ 13, 100 ], 1 ],
      RandomInfraPoint[ g, InfraShell[ 13, 100 ], UpTo[ 3 ], "PairwiseDistance" -> { 1, 2 } ] } ],
  { { }, { }, { } },
  TestID -> "RandomInfraPoint-empty-region"
]

VerificationTest[
  RandomInfraPoint[ GridGraph[ { 5, 5 } ], InfraBall[ 13, 1 ], 2, "PairwiseDistance" -> 4 ],
  { },
  TestID -> "RandomInfraPoint-no-tuple-meets-the-pairwise-distance"
]

VerificationTest[
  RandomInfraPoint[ PathGraph[ Range[ 3 ] ], 3, "PairwiseDistance" -> 5 ],
  { },
  TestID -> "RandomInfraPoint-exact-fails-impossible-distance"
]

VerificationTest[
  RandomInfraPoint[ PathGraph[ Range[ 3 ] ], 10 ],
  { },
  TestID -> "RandomInfraPoint-exact-fails-when-too-few"
]

VerificationTest[
  With[ { pts = RandomInfraPoint[ PathGraph[ Range[ 3 ] ], UpTo[ 10 ] ] },
    Sort @ pts ],
  { 1, 2, 3 },
  TestID -> "RandomInfraPoint-upto-returns-available"
]

(* ----- list-labelled vertices: a region is a List of vertices, and the graph settles { 2, 2 } ----- *)

VerificationTest[
  With[ { g = VertexReplace[ GridGraph[ { 3, 3 } ], Thread[ Range[ 9 ] -> Tuples[ Range[ 3 ], 2 ] ] ] },
    { VertexQ[ g, RandomInfraPoint[ g ] ], VertexQ[ g, RandomInfraPoint[ g, InfraBall[ { 1, 1 }, 1 ] ] ],
      AllTrue[ RandomInfraPoint[ g, 3 ], VertexQ[ g, # ] & ] } ],
  { True, True, True },
  TestID -> "RandomInfraPoint-list-labelled-draws-are-vertices"
]

VerificationTest[
  With[ { g = VertexReplace[ GridGraph[ { 3, 3 } ], Thread[ Range[ 9 ] -> Tuples[ Range[ 3 ], 2 ] ] ] },
    { Sort @ RandomInfraPoint[ g, { { 1, 1 }, { 3, 3 } }, All ], RandomInfraPoint[ g, { { 2, 2 } } ], RandomInfraPoint[ g, { 2, 2 } ],
      RandomInfraPoint[ PathGraph[ Range[ 3 ] ], { 2, 2 }, All ] } ],
  { { { 1, 1 }, { 3, 3 } }, { 2, 2 }, { 2, 2 }, { 2 } },
  TestID -> "RandomInfraPoint-list-labelled-graph-settles-the-region"
]

VerificationTest[
  With[ { g = VertexReplace[ GridGraph[ { 3, 3 } ], Thread[ Range[ 9 ] -> Tuples[ Range[ 3 ], 2 ] ] ] },
    Sort @ RandomInfraPoint[ g, InfraBall[ { 2, 2 }, 1 ], All ] ],
  { { 1, 2 }, { 2, 1 }, { 2, 2 }, { 2, 3 }, { 3, 2 } },
  TestID -> "RandomInfraPoint-list-labelled-ball"
]

VerificationTest[
  With[ { g = VertexReplace[ GridGraph[ { 3, 3 } ], Thread[ Range[ 9 ] -> Tuples[ Range[ 3 ], 2 ] ] ] },
    MemberQ[ { { { 1, 1 }, { 3, 3 } }, { { 1, 3 }, { 3, 1 } } },
      Sort @ RandomInfraPoint[ g, InfraShell[ { 2, 2 }, 2 ], 2, "PairwiseDistance" -> 4 ] ] ],
  True,
  TestID -> "RandomInfraPoint-list-labelled-pairwise-distance"
]

(* FindInfraSegment's members, densities and count contract are pinned against
   brute force in InfraSegmentTests.wlt / InfraMeasurementTests.wlt
   (EuclideanInertHeads, T2); this section tested the old Method / Properties /
   DAG-return API, since removed -- the count-less call is a vertex list, not a
   geodesic DAG, and there is no Properties or Method axis to reject any more. *)

(* The narrowed bundles now come from FindInfraGeodesic at scale Infinity, where
   "Shortest" is the segment class and a selector refines it; the endpoint is a
   stopping condition, and the walks that end there a Select. *)

VerificationTest[
  With[{g = GridGraph[{3, 3}],
        degSum = w |-> VertexDegree[GridGraph[{3, 3}], w[[-2]]] + VertexDegree[GridGraph[{3, 3}], w[[-1]]]},
    With[{paths = walkSeqs @ endingAt[FindInfraGeodesic[g, 1, Infinity, Infinity, All, stopAt[9], "NextVertexFunction" -> MinimalBy[degSum]], 9]},
      Length[paths] >= 1 &&
        AllTrue[paths, Length[#] - 1 == GraphDistance[g, 1, 9] &]
    ]
  ],
  True,
  TestID -> "FindInfraGeodesic-Minimal-stays-geodesic"
]

VerificationTest[
  With[{g = GridGraph[{4, 4}],
        degSum = w |-> VertexDegree[GridGraph[{4, 4}], w[[-2]]] + VertexDegree[GridGraph[{4, 4}], w[[-1]]]},
    BlockRandom[
      Length @ walkSeqs @ endingAt[FindInfraGeodesic[g, 1, Infinity, Infinity, All, stopAt[16],
        "NextVertexFunction" -> MinimalBy[degSum] /* (RandomSample[#, UpTo[1]] &)], 16] <= 1,
      RandomSeeding -> 42
    ]
  ],
  True,
  TestID -> "FindInfraGeodesic-Minimal-pruning-beam-1"
]

VerificationTest[
  With[{g = GridGraph[{3, 3}],
        degSum = w |-> VertexDegree[GridGraph[{3, 3}], w[[-2]]] + VertexDegree[GridGraph[{3, 3}], w[[-1]]]},
    Length @ walkSeqs @ endingAt[FindInfraGeodesic[g, 1, Infinity, Infinity, UpTo[2], stopAt[9], "NextVertexFunction" -> MinimalBy[degSum]], 9]
  ],
  _Integer?(# <= 2 &),
  SameTest -> MatchQ,
  TestID -> "FindInfraGeodesic-Minimal-UpTo-truncates"
]

(* FindInfraSegment carries no Method any more (EuclideanInertHeads, T2). *)


(* ===== FindInfraWalk (walk family) ===== *)

(* Properties is the class axis: "Simple" gives the simple paths. *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    {w = First @ walkSeqs @ endingAt[FindInfraWalk[g, 1, Infinity, All, stopAt[9],
       Properties -> { "Simple" }], 9]},
    InfraWalkQ[g, w] && DuplicateFreeQ[w]],
  True,
  TestID -> "FindInfraWalk-simple-properties-class"
]

VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    AllTrue[walkSeqs @ endingAt[FindInfraWalk[g, 1, UpTo[ 8 ], All, stopAt[9], Properties -> { "Simple" }], 9], DuplicateFreeQ]],
  True,
  TestID -> "FindInfraWalk-Simple-paths"
]

(* "Simple" has no repeats at any length. *)

VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    With[{walks = walkSeqs @ endingAt[FindInfraWalk[g, 1, {4}, All, stopAt[9], Properties -> { "Simple" }], 9]},
      Length[walks] >= 1 && AllTrue[walks, DuplicateFreeQ]
    ]
  ],
  True,
  TestID -> "FindInfraWalk-Simple-no-repeats"
]

(* The local geodesic rules live on FindInfraGeodesic: "Shortest" at scale
   Infinity is the global geodesic from the first vertex. *)

VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    Sort @ walkSeqs @ endingAt[FindInfraGeodesic[g, 1, Infinity, Infinity, All, stopAt[9],
        Properties -> { "Simple" }], 9] ===
      Sort @ FindInfraSegment[g, 1, 9, All]
  ],
  True,
  TestID -> "FindInfraGeodesic-Shortest-scale-Infinity-equals-geodesics"
]

VerificationTest[
  With[{g = CycleGraph[6]},
    Sort @ walkSeqs @ endingAt[FindInfraGeodesic[g, 1, 2, Infinity, All, stopAt[4],
        Properties -> { "Simple" }], 4]
  ],
  Sort[{{1, 2, 3, 4}, {1, 6, 5, 4}}],
  TestID -> "FindInfraGeodesic-Shortest-scale-2-cycle-geodesics"
]


VerificationTest[
  With[{g = CycleGraph[6]},
    Sort @ walkSeqs @ endingAt[FindInfraGeodesic[g, 1, 2, Infinity, All, stopAt[4],
        Properties -> { "Simple", { "Stretched", 2 } }], 4]
  ],
  Sort[{{1, 2, 3, 4}, {1, 6, 5, 4}}],
  TestID -> "FindInfraGeodesic-Stretched-scale-2-cycle-symmetric"
]

VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    BlockRandom[
      Length @ walkSeqs @ endingAt[FindInfraGeodesic[g, 1, 2, Infinity, All, stopAt[16],
        Properties -> { "Simple", { "Stretched", 2 } }, "NextVertexFunction" -> (RandomSample[#, UpTo[1]] &)], 16] <= 1,
      RandomSeeding -> 42
    ]
  ],
  True,
  TestID -> "FindInfraGeodesic-Stretched-pruning-beam-1"
]

(* A selector composed with "Simple" still gives simple walks. *)

VerificationTest[
  With[{g = GridGraph[{3, 3}],
        degSum = w |-> VertexDegree[GridGraph[{3, 3}], w[[-2]]] + VertexDegree[GridGraph[{3, 3}], w[[-1]]]},
    With[{walks = walkSeqs @ endingAt[FindInfraGeodesic[g, 1, 1, {4}, All, stopAt[9],
            Properties -> { "Simple" }, "NextVertexFunction" -> { MinimalBy[degSum], 1 }], 9]},
      AllTrue[walks, DuplicateFreeQ]
    ]
  ],
  True,
  TestID -> "FindInfraGeodesic-Simple-Minimal-valid-walks"
]

(* FindInfraLine's atoms, members, densities and the C6 compatibility fixture are
   pinned against brute force in InfraLineTests.wlt (EuclideanInertHeads, T3); this
   whole section tested the old Method / Properties / DAG-pool API, since removed. *)

(* ===== FindInfraShell ===== *)

(* the level surface { v : d(c, v) = r }; the separating subsets are FindInfraSphere's, InfraSphereTests.wlt *)

VerificationTest[
  With[{g = PathGraph[Range[5]]},
    Sort @ FindInfraShell[g, 3, 2]
  ],
  {1, 5},
  TestID -> "FindInfraShell-default-equidistant"
]

VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    With[{result = FindInfraShell[g, 6, {1, 2}]},
      result =!= {} &&
      AllTrue[result, v |-> 1 <= GraphDistance[g, 6, v] <= 2]
    ]
  ],
  True,
  TestID -> "FindInfraShell-range-radius"
]

VerificationTest[
  With[{g = PetersenGraph[]},
    MatchQ[FindInfraShell[g, 1, 2], {__Integer}]
  ],
  True,
  TestID -> "FindInfraShell-default-single-result"
]

VerificationTest[
  With[ { g = GridGraph[ { 6, 6 } ] },
    FindInfraBisectingHyperplane[ g, 1, 36, 1, Properties -> { "Separating" } ] ===
      FindInfraBisectingHyperplane[ g, 1, 36, 1, Properties -> { "Separating" } ]
  ],
  True,
  TestID -> "FindInfraBisectingHyperplane-default-deterministic"
]

VerificationTest[
  With[ { g = GridGraph[ { 6, 6 } ] },
    BlockRandom[ FindInfraBisectingHyperplane[ g, 1, 36, 1, Properties -> { "Separating" }, "NextVertexFunction" -> RandomSample ], RandomSeeding -> 4 ] ===
      BlockRandom[ FindInfraBisectingHyperplane[ g, 1, 36, 1, Properties -> { "Separating" }, "NextVertexFunction" -> RandomSample ], RandomSeeding -> 4 ]
  ],
  True,
  TestID -> "FindInfraBisectingHyperplane-RandomSample-seeded-reproducible"
]

(* FindInfraSegment carries no Method any more (EuclideanInertHeads, T2): its "RandomChoice"
   modifier on FindInfraRepresentative is the uniform witness now, tested in InfraMeasurementTests.wlt. *)


(* ===== FindInfraOsculatingShell ===== *)

(* On K5 with window {1, 2, 3} every other vertex is at distance 1 from
   each window-vertex, so vertices 4 and 5 are both osculating centers
   with radius 1; expect the two shells as a List of vertex lists. *)

VerificationTest[
  With[{result = FindInfraOsculatingShell[CompleteGraph[5], {1, 2, 3}, 2, 3, All]},
    MatchQ[result, {__List}] &&
    Length[result] === 2 &&
    Sort[Sort /@ result] === Sort[{Sort[{1, 2, 3, 5}], Sort[{1, 2, 3, 4}]}]
  ],
  True,
  TestID -> "FindInfraOsculatingShell-K5-two-osculating-centers"
]

(* Realisations are sorted by ascending radius, so the first one is the
   smallest-radius shell.  Both centers here have r = 1; tie-break by
   center index puts center 4 first. *)

VerificationTest[
  Sort @ First @ FindInfraOsculatingShell[CompleteGraph[5], {1, 2, 3}, 2, 3],
  Sort[{1, 2, 3, 5}],
  TestID -> "FindInfraOsculatingShell-K5-default-smallest-radius"
]

(* PathGraph: window {3, 4, 5} has no integer vertex equidistant from
   all three.  count = All -> the empty class; exact count 1 -> $Failed. *)

VerificationTest[
  FindInfraOsculatingShell[PathGraph[Range[7]], Range[7], 4, 3, All],
  { },
  TestID -> "FindInfraOsculatingShell-PathGraph-no-centers-All"
]

VerificationTest[
  FindInfraOsculatingShell[PathGraph[Range[7]], Range[7], 4, 3, 1],
  { },
  TestID -> "FindInfraOsculatingShell-PathGraph-no-centers-default-fails"
]


VerificationTest[
  FindInfraOsculatingShell[CompleteGraph[5], walkGraph @ {1, 2, 3}, 2, 3, All],
  FindInfraOsculatingShell[CompleteGraph[5], {1, 2, 3}, 2, 3, All],
  TestID -> "FindInfraOsculatingShell-walk-graph-equiv-bare-list"
]

(* a bundle of walk graphs: centers union across walks. *)

VerificationTest[
  Length @ FindInfraOsculatingShell[CompleteGraph[5],
    walkGraph /@ {{1, 2, 3}, {1, 4, 5}}, 2, 3, All],
  4,
  TestID -> "FindInfraOsculatingShell-multi-realisation-union"
]


VerificationTest[
  Length @ FindInfraOsculatingShell[CompleteGraph[5], {1, 2, 3}, 2, 3, UpTo[1]],
  1,
  TestID -> "FindInfraOsculatingShell-UpTo-caps"
]


VerificationTest[
  FindInfraOsculatingShell[CompleteGraph[5], {1, 2, 3}, 2, 3, 3],
  { },
  TestID -> "FindInfraOsculatingShell-count-exceeds-fails"
]

(* k = 1: trivial window {path[[i]]}; every vertex is an osculating
   center at its own distance to path[[i]], so we get one shell per
   vertex. *)

VerificationTest[
  Length @ FindInfraOsculatingShell[CompleteGraph[5], {1, 2, 3}, 2, 1, All],
  VertexCount[CompleteGraph[5]],
  TestID -> "FindInfraOsculatingShell-k1-every-vertex"
]

(* Shells sorted by ascending radius: in K5 with k=1 the r=0 shell
   {path[[i]]} comes first (size 1), followed by the four r=1 shells
   (size 4 each). *)

VerificationTest[
  Length /@ FindInfraOsculatingShell[CompleteGraph[5], {1, 2, 3}, 2, 1, All],
  {1, 4, 4, 4, 4},
  TestID -> "FindInfraOsculatingShell-sorted-by-radius"
]

(* The circle's seam necklaces, its radius and band forms, cyclic instances,
   and the Q_4 / octagon / Petersen fixtures are pinned against brute force in
   InfraCircleTests.wlt (EuclideanInertHeads, T4); this section and the circle-pool
   section that followed it tested the old Method / Properties / DAG-pool API and the
   positional-tuple radius spec (a bare {rmin, rmax} third argument), both removed. *)

(* ===== FindInfraParallel ===== *)

VerificationTest[
  infraSpread @ FindInfraParallel[GridGraph[{4, 4}], {1, 2, 3, 4}, 5, All],
  {{5, 6, 7, 8}},
  TestID -> "FindInfraParallel-GridGraph-row-from-row"
]

VerificationTest[
  infraSpread @ FindInfraParallel[GridGraph[{4, 4}], {1, 2, 3, 4}, 6, All],
  {{5, 6, 7, 8}},
  TestID -> "FindInfraParallel-GridGraph-row-interior-vertex"
]

VerificationTest[
  infraSpread @ FindInfraParallel[PathGraph[Range[5]], {1, 2, 3, 4, 5}, 3, All],
  {{1, 2, 3, 4, 5}},
  TestID -> "FindInfraParallel-self-on-line"
]

VerificationTest[
  FindInfraParallel[Graph[{1, 2, 3, 4}, {1 <-> 2, 3 <-> 4}], {1, 2}, 3, All],
  { },
  TestID -> "FindInfraParallel-disconnected-empty"
]

VerificationTest[
  walkSequence /@ FindInfraParallel[GridGraph[{4, 4}], {1, 2, 3, 4}, 5, 1],
  {{5, 6, 7, 8}},
  TestID -> "FindInfraParallel-strict-1"
]

VerificationTest[
  FindInfraParallel[GridGraph[{4, 4}], {1, 2, 3, 4}, 5, 2],
  { },
  TestID -> "FindInfraParallel-strict-fails-when-too-few"
]

(* All under "Exhaustive" hands back the pool itself, as FindInfraLine does; its
   realisations are the parallels -- here the middle row of the 5 x 5 grid, one
   carrier, so the lone bundle stands alone *)
VerificationTest[
  With[{pa = FindInfraParallel[GridGraph[{5, 5}], Range[5], 13, All]},
    {MatchQ[pa, _Graph | {__Graph}], infraSpread @ pa}],
  {True, {{11, 12, 13, 14, 15}}},
  TestID -> "FindInfraParallel-All-returns-the-pool"
]

VerificationTest[
  FindInfraParallel[CycleGraph[8], {1, 2, 3}, 6, All],
  { },
  TestID -> "FindInfraParallel-CycleGraph-no-parallel"
]

VerificationTest[
  InfraParallelQ[GridGraph[{4, 4}], {1, 2, 3, 4},
    First @ infraSpread @ FindInfraParallel[GridGraph[{4, 4}], {1, 2, 3, 4}, 5]],
  True,
  TestID -> "FindInfraParallel-output-passes-InfraParallelQ"
]


(* ===== EmbeddingClosest dispatch for InfraShell ===== *)

(* Sets ranked by directed Hausdorff distance to the Euclidean sphere of
   radius r centered at c. *)

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    MatchQ[
      EmbeddingClosest[ g,
        List /@ Select[ VertexList[ g ], GraphDistance[ g, 6, # ] == 1 & ],
        { 6, 1 } ],
      { __List } ]
  ],
  True,
  TestID -> "EmbeddingClosest-set-family-returns-sets"
]

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    Length @ EmbeddingClosest[ g, List /@ VertexList[ g ], { 6, 1 } ]
  ],
  16,
  TestID -> "EmbeddingClosest-set-family-all-vertices"
]


(* ===== EmbeddingClosest dispatch for InfraCircle (pre-existing) ===== *)

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    Length @ EmbeddingClosest[ g,
      FindInfraRepresentative[ g, InfraCircle[ 6, { 1, 2 } ], All ],
      { 6, 1.5 } ] >= 1
  ],
  True,
  TestID -> "EmbeddingClosest-cycle-graphs-on-Separating-set"
]


(* ===== RandomInfraPoint All ===== *)

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    Sort @ (RandomInfraPoint[ g, All ]) === VertexList[ g ]
  ],
  True,
  TestID -> "RandomInfraPoint-All-returns-every-vertex"
]

VerificationTest[
  With[ { g = PetersenGraph[ ] },
    Length @ RandomInfraPoint[ g, All ] == VertexCount[ g ]
  ],
  True,
  TestID -> "RandomInfraPoint-All-length-equals-vertex-count"
]


(* FindInfraLine carries no Method axis any more (EuclideanInertHeads, T3): the count
   fixes the mode, and its class is pinned against brute force in InfraLineTests.wlt.
   The determinism and BothSides regression guards above stay
   meaningful only for FindInfraParallel, which the walk-family item left untouched. *)

VerificationTest[
  With[ { g = GridGraph[ { 6, 6 } ], line = First @ FindInfraLine[ GridGraph[ { 6, 6 } ], 1, 2, 1 ] },
    FindInfraParallel[ g, line, 20, 1 ] === FindInfraParallel[ g, line, 20, 1 ]
  ],
  True,
  TestID -> "FindInfraParallel-default-deterministic"
]

VerificationTest[
  With[ { g = GridGraph[ { 6, 6 } ], line = First @ FindInfraLine[ GridGraph[ { 6, 6 } ], 1, 2, 1 ] },
    BlockRandom[ FindInfraParallel[ g, line, 20, 1, "NextVertexFunction" -> RandomSample ], RandomSeeding -> 3 ] ===
      BlockRandom[ FindInfraParallel[ g, line, 20, 1, "NextVertexFunction" -> RandomSample ], RandomSeeding -> 3 ]
  ],
  True,
  TestID -> "FindInfraParallel-RandomSample-seeded-reproducible"
]

(* ===== FindInfraLine[g, segment] overload (the lines through a geodesic, InfraLine[seg]) ===== *)

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    With[ { seg = First @ FindInfraSegment[ g, 1, 6, All ] },
      With[ { lines = FindInfraLine[ g, seg, All ] },
        ListQ[ lines ] && AllTrue[ lines,
          lst |-> Length[ lst ] >= Length[ seg ] && MemberQ[ Partition[ lst, Length @ seg, 1 ], seg ] ]
      ]
    ]
  ],
  True,
  TestID -> "FindInfraLine-segment-contains-segment"
]

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    With[ { seg = First @ FindInfraSegment[ g, 1, 6, All ] },
      Sort @ FindInfraLine[ g, seg, All ] ===
        Sort @ Select[ FindInfraLine[ g, 1, 6, All ],
          lst |-> Length[ lst ] >= Length[ seg ] && MemberQ[ Partition[ lst, Length @ seg, 1 ], seg ] ]
    ]
  ],
  True,
  TestID -> "FindInfraLine-segment-matches-endpoint-filtered"
]

VerificationTest[
  With[ { g = PathGraph[ Range[ 5 ] ] },
    FindInfraLine[ g, { 2, 3 }, 1 ] === { { 1, 2, 3, 4, 5 } }
  ],
  True,
  TestID -> "FindInfraLine-segment-PathGraph-recovers-full-path"
]

VerificationTest[
  FindInfraLine[ PathGraph[ Range[ 5 ] ], { 2, 3 }, 99 ],
  { },
  TestID -> "FindInfraLine-segment-strict-undersupply-Failed"
]


(* FindInfraLine carries no "Direction" option any more (EuclideanInertHeads, T3):
   both the point form and the FindInfraLine[g, seq] prolongation form always grow
   from both ends, and there is no ::baddirection message left to raise. *)


(* ===== The extensions of a geodesic: InfraLine[germ] and FindInfraGeodesic at scale Infinity ===== *)

(* the line through a germ: InfraLine[seg] spreads to FindInfraLine, on a walk germ and on a geodesic-DAG germ *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    With[ { seg = InfraMeasurement[ g, InfraSegment[ 1, 11 ], "Graph" ] },
      Sort @ infraSpread @ InfraMeasurement[ g, InfraLine[ { 6, 7 } ], "Graph" ] ===
        Sort @ FindInfraLine[ g, 6, 7, All ] &&
      Sort @ infraSpread @ InfraMeasurement[ g, InfraLine[ seg ], "Graph" ] ===
        Sort @ FindInfraLine[ g, 1, 11, All ]
    ]
  ],
  True,
  TestID -> "InfraLine-germ-is-FindInfraLine"
]

(* a bent germ keeps its own edges in the middle, so it has fewer lines than its ends; a vertex germ, also a list-labelled one, is InfraLine[p, p] *)
VerificationTest[
  With[ { g = GridGraph[ { 7, 7 } ], torus = InfraSubstrate[ "SquareTorusGraph", "Small" ] },
    { Length @ InfraMeasurement[ g, InfraLine[ { 16, 23, 24 } ], "Graph" ],
      InfraMeasurement[ g, InfraLine[ { 16, 23, 24 } ], "Cardinality" ] < InfraMeasurement[ g, InfraLine[ 16, 24 ], "Cardinality" ],
      Sort @ infraSpread @ InfraMeasurement[ g, InfraLine[ 25 ], "Graph" ] === Sort @ infraSpread @ InfraMeasurement[ g, InfraLine[ 25, 25 ], "Graph" ],
      Sort @ infraSpread @ InfraMeasurement[ torus, InfraLine[ { 1, 1 } ], "Graph" ] ===
        Sort @ infraSpread @ InfraMeasurement[ torus, InfraLine[ { 1, 1 }, { 1, 1 } ], "Graph" ] } ],
  { 1, True, True, True },
  TestID -> "InfraLine-germ-bent-and-vertex"
]

(* a budget of no edge is the bundle itself: all six geodesics from 1 to 11 *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    With[ { seg = InfraMeasurement[ g, InfraSegment[ 1, 11 ], "Graph" ] },
      Sort @ walkSeqs @ FindInfraGeodesic[ g, seg, Infinity, UpTo[ 0 ], All, "Direction" -> "BothSides" ] === Sort @ infraSpread @ seg
    ]
  ],
  True,
  TestID -> "FindInfraGeodesic-UpTo-0-is-the-bundle"
]

(* every extension is a geodesic containing the seed, with at most k edges added on each side *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ], seed = { 6, 7 }, k = 2 },
    AllTrue[ walkSeqs @ FindInfraGeodesic[ g, seed, Infinity, UpTo[ k ], All, "Direction" -> "BothSides" ],
      w |-> InfraSegmentQ[ g, w ] &&
        With[ { pos = SequencePosition[ w, seed ] },
          pos =!= { } && pos[[ 1, 1 ]] - 1 <= k && Length[ w ] - pos[[ 1, 2 ]] <= k ] ]
  ],
  True,
  TestID -> "FindInfraGeodesic-germ-extensions-are-geodesics-within-budget"
]

(* inextensible within the budget: a side still under budget has no neighbour prolonging the geodesic *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ], seed = { 6, 7 }, k = 2 },
    AllTrue[ walkSeqs @ FindInfraGeodesic[ g, seed, Infinity, UpTo[ k ], All, "Direction" -> "BothSides" ],
      w |-> With[ { pos = First @ SequencePosition[ w, seed ] },
        ( pos[[ 1 ]] - 1 == k ||
          NoneTrue[ AdjacencyList[ g, First @ w ], GraphDistance[ g, #, Last @ w ] == Length[ w ] & ] ) &&
        ( Length[ w ] - pos[[ 2 ]] == k ||
          NoneTrue[ AdjacencyList[ g, Last @ w ], GraphDistance[ g, First @ w, # ] == Length[ w ] & ] ) ] ]
  ],
  True,
  TestID -> "FindInfraGeodesic-germ-maximal-within-budget"
]

(* where the two ends never interact -- the interior grid edge and the path -- the extensions within a budget are the lines through the germ cut at
   the budget on each side, for a budget UpTo[k], an exact {k} and a range *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ], seed = { 6, 7 } },
    { lines = FindInfraLine[ g, seed, All ] },
    { cut = { lo, hi } |-> Union @ Select[
        Map[ line |-> With[ { pos = First @ SequencePosition[ line, seed ] },
            Take[ line, { Max[ 1, pos[[ 1 ]] - hi ], Min[ Length @ line, pos[[ 2 ]] + hi ] } ] ], lines ],
        w |-> With[ { pos = First @ SequencePosition[ w, seed ] }, Max[ pos[[ 1 ]] - 1, Length[ w ] - pos[[ 2 ]] ] >= lo ] ] },
    AllTrue[ { { UpTo[ 1 ], { 0, 1 } }, { UpTo[ 2 ], { 0, 2 } }, { UpTo[ 3 ], { 0, 3 } }, { { 2 }, { 2, 2 } }, { { 1, 2 }, { 1, 2 } },
        { Infinity, { 0, Infinity } } },
      Apply[ { k, range } |-> Sort @ walkSeqs @ FindInfraGeodesic[ g, seed, Infinity, k, All, "Direction" -> "BothSides" ] === cut @@ range ] ]
  ],
  True,
  TestID -> "FindInfraGeodesic-germ-is-the-cut-lines-GridGraph"
]

VerificationTest[
  With[ { g = PathGraph[ Range[ 5 ] ], seed = { 4, 5 } },
    { lines = FindInfraLine[ g, seed, All ] },
    { cut = { lo, hi } |-> Union @ Select[
        Map[ line |-> With[ { pos = First @ SequencePosition[ line, seed ] },
            Take[ line, { Max[ 1, pos[[ 1 ]] - hi ], Min[ Length @ line, pos[[ 2 ]] + hi ] } ] ], lines ],
        w |-> With[ { pos = First @ SequencePosition[ w, seed ] }, Max[ pos[[ 1 ]] - 1, Length[ w ] - pos[[ 2 ]] ] >= lo ] ] },
    AllTrue[ { { UpTo[ 1 ], { 0, 1 } }, { UpTo[ 2 ], { 0, 2 } }, { UpTo[ 5 ], { 0, 5 } }, { { 2 }, { 2, 2 } }, { { 2, 5 }, { 2, 5 } },
        { Infinity, { 0, Infinity } } },
      Apply[ { k, range } |-> Sort @ walkSeqs @ FindInfraGeodesic[ g, seed, Infinity, k, All, "Direction" -> "BothSides" ] === cut @@ range ] ]
  ],
  True,
  TestID -> "FindInfraGeodesic-germ-is-the-cut-lines-PathGraph-asymmetric"
]

(* a geodesic-DAG germ is its geodesics: the extensions and the line atoms spread to the union over the six geodesics from 1 to 11 *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    With[ { seg = InfraMeasurement[ g, InfraSegment[ 1, 11 ], "Graph" ] },
      Sort @ walkSeqs @ FindInfraGeodesic[ g, seg, Infinity, UpTo[ 1 ], All, "Direction" -> "BothSides" ] ===
        Sort @ Union @ Catenate[ walkSeqs @ FindInfraGeodesic[ g, #, Infinity, UpTo[ 1 ], All,
            "Direction" -> "BothSides" ] & /@ infraSpread @ seg ] &&
      Sort @ infraSpread @ InfraMeasurement[ g, InfraLine[ seg ], "Graph" ] ===
        Sort @ Union @ Catenate[ FindInfraLine[ g, #, All ] & /@ infraSpread @ seg ]
    ]
  ],
  True,
  TestID -> "InfraLine-bundle-germ-spreads-to-its-geodesics"
]

(* on C_6 through the edge 1-2 the ends interact: a budget of 2 already buys all three lines, the atoms of InfraLine[{1, 2}] *)
VerificationTest[
  { Sort @ infraSpread @ InfraMeasurement[ CycleGraph[ 6 ], InfraLine[ { 1, 2 } ], "Graph" ],
    Sort @ walkSeqs @ FindInfraGeodesic[ CycleGraph[ 6 ], { 1, 2 }, Infinity, UpTo[ 2 ], All, "Direction" -> "BothSides" ] },
  { Sort @ { { 6, 1, 2, 3 }, { 1, 2, 3, 4 }, { 5, 6, 1, 2 } }, Sort @ { { 6, 1, 2, 3 }, { 1, 2, 3, 4 }, { 5, 6, 1, 2 } } },
  TestID -> "InfraLine-germ-C6-compatibility"
]

(* "Direction": only past the right end, only past the left end *)
VerificationTest[
  { walkSeqs @ FindInfraGeodesic[ PathGraph[ Range[ 7 ] ], { 3, 4 }, Infinity, UpTo[ 2 ], All, "Direction" -> "Forward" ],
    walkSeqs @ FindInfraGeodesic[ PathGraph[ Range[ 7 ] ], { 3, 4 }, Infinity, UpTo[ 2 ], All, "Direction" -> "Backward" ],
    walkSeqs @ FindInfraGeodesic[ PathGraph[ Range[ 7 ] ], { 3, 4 }, Infinity, Infinity, All, "Direction" -> "Forward" ] },
  { { { 3, 4, 5, 6 } }, { { 1, 2, 3, 4 } }, { { 3, 4, 5, 6, 7 } } },
  TestID -> "FindInfraGeodesic-germ-Direction"
]

(* one class under every next-vertex function *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    SameQ @@ ( Sort @ walkSeqs @ FindInfraGeodesic[ g, { 6, 7 }, Infinity, UpTo[ 2 ], All, "NextVertexFunction" -> #,
        "Direction" -> "BothSides" ] & /@
      { Identity, RandomSample } )
  ],
  True,
  TestID -> "FindInfraGeodesic-germ-class-invariant-under-NextVertexFunction"
]

(* the line atoms carry the family by DP -- one atom per admissible end pair, count, occupation, lengths and ends without enumeration *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    With[ { pool = InfraMeasurement[ g, InfraLine[ { 6, 7 } ], "Graph" ] },
      MatchQ[ pool, { _Graph, __Graph } ] &&
      Total[ Max @ InfraDensity[ g, # ] & /@ pool ] === Length @ infraSpread @ pool &&
      InfraMeasurement[ g, InfraLine[ { 6, 7 } ], "Cardinality" ] === Length @ infraSpread @ pool &&
      Total @ InfraDensity[ g, pool ] === Total[ Length /@ infraSpread @ pool ] &&
      Sort @ Union[ First /@ infraSpread @ pool ] === { 1, 13 } &&
      Sort @ Union[ Last /@ infraSpread @ pool ] === { 4, 16 }
    ]
  ],
  True,
  TestID -> "InfraLine-germ-DP-counts-match-enumeration"
]

(* the longest lines are a selection on the atoms, and keep the atom form *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    With[ { pool = InfraMeasurement[ g, InfraLine[ { 6, 7 } ], "Graph" ] },
      With[ { longest = SelectInfraWalk[ g, pool, All, "From" -> "MaxLength" ] },
        MatchQ[ longest, _Graph | { __Graph } ] &&
        Sort @ infraSpread @ longest === Sort @ MaximalBy[ infraSpread @ pool, Length ]
      ]
    ]
  ],
  True,
  TestID -> "InfraLine-germ-longest-by-SelectInfraWalk"
]

(* the count contract: count-less is one witness of the class, UpTo is soft, a strict n fails on under-supply *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    With[ { one = FindInfraGeodesic[ g, { 6, 7 }, Infinity, UpTo[ 2 ], "Direction" -> "BothSides" ],
            all = walkSeqs @ FindInfraGeodesic[ g, { 6, 7 }, Infinity, UpTo[ 2 ], All, "Direction" -> "BothSides" ] },
      MatchQ[ one, _Graph ] && MemberQ[ all, walkSeq @ one ] &&
      Length @ FindInfraGeodesic[ g, { 6, 7 }, Infinity, UpTo[ 2 ], UpTo[ 3 ], "Direction" -> "BothSides" ] == 3 &&
      FindInfraGeodesic[ PathGraph[ Range[ 5 ] ], { 2, 3 }, Infinity, Infinity, 99, "Direction" -> "BothSides" ] === { }
    ]
  ],
  True,
  TestID -> "FindInfraGeodesic-germ-count-contract"
]

(* FindInfraShell / the circle's representatives: a bounded radius makes the answer depend only on
   the ball B(p, r + 1) / B(p, r + 2) around the centre.  The "Metric" and
   "Separating" recipes are graph-intrinsic; the "Embedding" recipe still
   uses the full graph for its spectral coordinates, so the local-vs-global
   cross-check is for "Metric" / "Separating". *)

VerificationTest[
  With[ { g = GridGraph[ { 10, 10 } ], p = 45 },
    FindInfraShell[ g, p, 2 ] === FindInfraShell[ NeighborhoodGraph[ g, p, 3 ], p, 2 ]
  ],
  True,
  TestID -> "FindInfraShell-locality-Metric"
]

VerificationTest[
  With[ { g = GridGraph[ { 10, 10 } ], p = 45 },
    Sort[ Sort /@ FindInfraRepresentative[ g, InfraCircle[ p, { 1, 2 } ], All ] ] ===
      Sort[ Sort /@ FindInfraRepresentative[ NeighborhoodGraph[ g, p, 4 ], InfraCircle[ p, { 1, 2 } ], All ] ]
  ],
  True,
  TestID -> "FindInfraRepresentative-circle-locality-Metric"
]


(* a capped line query returns members of the full family (the cap prunes the
   enumeration, never invents realisations) *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    With[ { family = FindInfraLine[ g, 1, 9, All ] },
      MemberQ[ family, First @ FindInfraLine[ g, 1, 9, 1 ] ] &&
        SubsetQ[ family, FindInfraLine[ g, 1, 9, UpTo[ 3 ] ] ] ]
  ],
  True,
  TestID -> "FindInfraLine-cap-subset-of-family"
]

VerificationTest[
  Length @ FindInfraLine[ GridGraph[ { 3, 3 } ], 1, 9, 3 ],
  3,
  TestID -> "FindInfraLine-strict-count-exact"
]

(* the diameter lines through opposite corners are the longest ones, a selection on the pool *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    With[ { longest = SelectInfraWalk[ g, FindInfraLine[ g, 1, 9, All ], All, "From" -> "MaxLength" ] },
      AllTrue[ longest, Length[ # ] - 1 == GraphDiameter[ g ] & ] ]
  ],
  True,
  TestID -> "FindInfraLine-diameter-lines-by-MaxLength"
]

EndTestSection[]
