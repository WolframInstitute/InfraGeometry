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

(* ===== FindInfraPoint ===== *)

VerificationTest[
  With[{g = PetersenGraph[]},
    With[{pt = FindInfraPoint[g]},
      MemberQ[VertexList[g], pt]
    ]
  ],
  True,
  TestID -> "FindInfraPoint-single-vertex"
]

VerificationTest[
  With[{g = PetersenGraph[]},
    With[{pts = FindInfraPoint[g, 3]},
      Length @ pts == 3 && DuplicateFreeQ[(pts)] && SubsetQ[VertexList[g], (pts)]
    ]
  ],
  True,
  TestID -> "FindInfraPoint-multiple-vertices"
]

VerificationTest[
  With[{g = PathGraph[Range[5]]},
    SubsetQ[GraphCenter[g], (FindInfraPoint[g, 1, "From" -> "Center"])]
  ],
  True,
  TestID -> "FindInfraPoint-from-center"
]

VerificationTest[
  With[{g = PathGraph[Range[5]]},
    SubsetQ[GraphPeriphery[g], (FindInfraPoint[g, 1, "From" -> "Periphery"])]
  ],
  True,
  TestID -> "FindInfraPoint-from-periphery"
]

(* {"Center", 0} runs zero iterations -- identical pool to plain "Center". *)
VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    Sort[FindInfraPoint[g, All, "From" -> {"Center", 0}]] ===
      Sort[FindInfraPoint[g, All, "From" -> "Center"]]
  ],
  True,
  TestID -> "FindInfraPoint-iterated-center-cap0-equals-center"
]

(* On a graph with a dominating center the orbit is already a fixed point, so the
   iterated (uncapped) pool is the center of that fixed point -- a subset of the graph. *)
VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    SubsetQ[VertexList[g], FindInfraPoint[g, All, "From" -> {"Center", Infinity}]]
  ],
  True,
  TestID -> "FindInfraPoint-iterated-center-stabilizes-in-graph"
]

(* A disconnected input is already a shattered region: the pool is its whole vertex set. *)
VerificationTest[
  With[{g = GraphDisjointUnion[PathGraph[{1, 2, 3}], PathGraph[{4, 5, 6}]]},
    Sort[FindInfraPoint[g, All, "From" -> {"Center", Infinity}]] === VertexList[g]
  ],
  True,
  TestID -> "FindInfraPoint-iterated-center-disconnected-region"
]

(* Refusing a legitimate selector would be worse than the silence it replaces:
   every admissible "From" shape must still produce a pool. *)
VerificationTest[
  With[{g = GridGraph[{5, 5}]},
    FreeQ[
      FindInfraPoint[g, All, "From" -> #] & /@
        {All, "Random", "Center", "Periphery", {"Center", 0}, {"Center", Infinity},
         7, 1 -> 2, {2, 3, 4}, 9, <| 2 -> 1, 5 -> 1, 7 -> 1 |>,
         <| 3 -> 1, 4 -> 1 |>},
      _FindInfraPoint]
  ],
  True,
  TestID -> "FindInfraPoint-From-vocabulary-not-refused"
]

VerificationTest[
  With[{g = PathGraph[Range[5]]},
    With[{pts = (FindInfraPoint[g, 2, "Distance" -> 4])},
      Length[pts] == 2 && GraphDistance[g, pts[[1]], pts[[2]]] >= 4
    ]
  ],
  True,
  TestID -> "FindInfraPoint-with-distance-constraint"
]

VerificationTest[
  With[{g = GridGraph[{6, 6}]},
    With[{vs = FindInfraPoint[g, 4, "Distance" -> "Max"]},
      Min[GraphDistance[g, #[[1]], #[[2]]] & /@ Subsets[vs, {2}]] == 5
    ]
  ],
  True,
  TestID -> "FindInfraPoint-Max-maximizes-minimum-gap"
]

VerificationTest[
  With[{g = GridGraph[{6, 6}]},
    With[{spread = FindInfraPoint[g, 4, "Distance" -> "Spread"],
          corners = {1, 6, 31, 36}},
      With[{spreadDists = GraphDistance[g, #[[1]], #[[2]]] & /@ Subsets[spread, {2}],
            cornerDists = GraphDistance[g, #[[1]], #[[2]]] & /@ Subsets[corners, {2}]},
        Min[spreadDists] == 5 && Variance[spreadDists] <= Variance[cornerDists]
      ]
    ]
  ],
  True,
  TestID -> "FindInfraPoint-Spread-minimizes-variance-at-optimal-gap"
]

VerificationTest[
  With[{g = PetersenGraph[]},
    With[{pt = FindInfraPoint[g, 1, "From" -> {2, 3, 4}]},
      Length @ pt == 1 && SubsetQ[{2, 3, 4}, (pt)]
    ]
  ],
  True,
  TestID -> "FindInfraPoint-from-vertex-list"
]

VerificationTest[
  With[{g = PathGraph[Range[5]]},
    With[{pts = (FindInfraPoint[g, 2, "From" -> {1, 2, 3, 4, 5}, "Distance" -> 4])},
      Length[pts] == 2 && GraphDistance[g, pts[[1]], pts[[2]]] >= 4
    ]
  ],
  True,
  TestID -> "FindInfraPoint-vertex-list-with-distance"
]

VerificationTest[
  FindInfraPoint[PathGraph[Range[3]], 10],
  { },
  TestID -> "FindInfraPoint-exact-fails-when-too-few"
]

VerificationTest[
  With[{pts = FindInfraPoint[PathGraph[Range[3]], UpTo[10]]},
    Length @ pts == 3 && SubsetQ[VertexList[PathGraph[Range[3]]], (pts)]
  ],
  True,
  TestID -> "FindInfraPoint-upto-returns-available"
]

VerificationTest[
  FindInfraPoint[PathGraph[Range[3]], 3, "Distance" -> 5],
  { },
  TestID -> "FindInfraPoint-exact-fails-impossible-distance"
]

VerificationTest[
  With[{g = PathGraph[Range[7]]},
    With[{pt = FindInfraPoint[g, 1, "From" -> 3 -> 2]},
      Length @ pt == 1 && GraphDistance[g, 3, First[pt]] == 2
    ]
  ],
  True,
  TestID -> "FindInfraPoint-from-origin-exact-distance"
]

VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    With[{pts = (FindInfraPoint[g, UpTo[20], "From" -> 1 -> {2, 3}])},
      AllTrue[pts, 2 <= GraphDistance[g, 1, #] <= 3 &]
    ]
  ],
  True,
  TestID -> "FindInfraPoint-from-origin-distance-range"
]

VerificationTest[
  With[{g = CycleGraph[8]},
    With[{ecc = Max[GraphDistance[g, 1, #] & /@ VertexList[g]]},
      With[{pts = (FindInfraPoint[g, UpTo[VertexCount[g]], "From" -> 1 -> "Max"])},
        AllTrue[pts, GraphDistance[g, 1, #] == ecc &]
      ]
    ]
  ],
  True,
  TestID -> "FindInfraPoint-from-origin-max-distance"
]

VerificationTest[
  With[ { g = PetersenGraph[] },
    With[ { pts = FindInfraPoint[ g, 3 ] },
      Length[ pts ] === 3 && SubsetQ[ VertexList @ g, pts ] ] ],
  True,
  TestID -> "FindInfraPoint-returns-list-of-vertices"
]

VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    With[{pts = (FindInfraPoint[g, UpTo[VertexCount[g]],
      "From" -> <| 1 -> 1, 16 -> 1 |> -> 3])},
      AllTrue[pts, GraphDistance[g, 1, #] == 3 && GraphDistance[g, 16, #] == 3 &]
    ]
  ],
  True,
  TestID -> "FindInfraPoint-multi-anchor-intersection"
]

VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    Sort @ (FindInfraPoint[g, UpTo[VertexCount[g]], "From" -> <| 2 -> 1, 5 -> 1, 7 -> 1 |>])
  ],
  {2, 5, 7},
  TestID -> "FindInfraPoint-multi-anchor-pool-no-distance"
]

(* FindInfraSegment's members, densities and count contract are pinned against
   brute force in InfraSegmentTests.wlt / InfraMeasurementTests.wlt
   (EuclideanInertHeads, T2); this section tested the old Method / Properties /
   DAG-return API, since removed -- the count-less call is a vertex list, not a
   geodesic DAG, and there is no Properties or Method axis to reject any more. *)

(* The narrowed bundles now come from FindInfraGeodesic at scale Infinity, where
   "Minimizing" is the segment class and a selector refines it. *)

VerificationTest[
  With[{g = GridGraph[{3, 3}],
        degSum = w |-> VertexDegree[GridGraph[{3, 3}], w[[-2]]] + VertexDegree[GridGraph[{3, 3}], w[[-1]]]},
    With[{paths = walkSeqs @ FindInfraGeodesic[g, 1, 9, Infinity, Infinity, All,
            Properties -> {"Minimizing"}, "NextVertexFunction" -> MinimalBy[degSum]]},
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
      Length @ walkSeqs @ FindInfraGeodesic[g, 1, 16, Infinity, Infinity, All,
        Properties -> {"Minimizing"},
        "NextVertexFunction" -> MinimalBy[degSum] /* (RandomSample[#, UpTo[1]] &)] <= 1,
      RandomSeeding -> 42
    ]
  ],
  True,
  TestID -> "FindInfraGeodesic-Minimal-pruning-beam-1"
]

VerificationTest[
  With[{g = GridGraph[{3, 3}],
        degSum = w |-> VertexDegree[GridGraph[{3, 3}], w[[-2]]] + VertexDegree[GridGraph[{3, 3}], w[[-1]]]},
    Length @ walkSeqs @ FindInfraGeodesic[g, 1, 9, Infinity, Infinity, UpTo[2],
      Properties -> {"Minimizing"}, "NextVertexFunction" -> MinimalBy[degSum]]
  ],
  _Integer?(# <= 2 &),
  SameTest -> MatchQ,
  TestID -> "FindInfraGeodesic-Minimal-UpTo-truncates"
]

(* FindInfraSegment carries no Method any more (EuclideanInertHeads, T2). *)


(* ===== FindInfraWalk (walk family) ===== *)

(* Properties is the class axis: the default is the simple paths, and
   "Generic" widens to the generic immersed walks. *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    {w = First @ walkSeqs @ FindInfraWalk[g, 1, 9, Infinity, 1,
       Properties -> {"Simple"}]},
    InfraWalkQ[g, w] && DuplicateFreeQ[w]],
  True,
  TestID -> "FindInfraWalk-simple-properties-class"
]

VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    AllTrue[walkSeqs @ FindInfraWalk[g, 1, 9, UpTo[ 8 ], All], DuplicateFreeQ]],
  True,
  TestID -> "FindInfraWalk-default-simple"
]

(* the default class has no repeats at any length. *)

VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    With[{walks = walkSeqs @ FindInfraWalk[g, 1, 9, {4}, All]},
      Length[walks] >= 1 && AllTrue[walks, DuplicateFreeQ]
    ]
  ],
  True,
  TestID -> "FindInfraWalk-Simple-no-repeats"
]

(* The local geodesic rules live on FindInfraGeodesic: "Minimizing" at scale
   Infinity is the global geodesic from the first vertex. *)

VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    Sort @ walkSeqs @ FindInfraGeodesic[g, 1, 9, Infinity, Infinity, All,
        Properties -> {"Simple", "Minimizing"}] ===
      Sort @ FindInfraSegment[g, 1, 9, All]
  ],
  True,
  TestID -> "FindInfraGeodesic-Minimizing-scale-Infinity-equals-geodesics"
]

VerificationTest[
  With[{g = CycleGraph[6]},
    Sort @ walkSeqs @ FindInfraGeodesic[g, 1, 4, 2, Infinity, All,
        Properties -> {"Simple", "Minimizing"}]
  ],
  Sort[{{1, 2, 3, 4}, {1, 6, 5, 4}}],
  TestID -> "FindInfraGeodesic-Minimizing-scale-2-cycle-geodesics"
]


VerificationTest[
  With[{g = CycleGraph[6]},
    Sort @ walkSeqs @ FindInfraGeodesic[g, 1, 4, 2, Infinity, All,
        Properties -> {"Simple"},
        "NextVertexFunction" -> MaximalBy[w |-> Map[GraphDistance[g, #, Last @ w] &, Reverse @ Most @ w]]]
  ],
  Sort[{{1, 2, 3, 4}, {1, 6, 5, 4}}],
  TestID -> "FindInfraGeodesic-farthest-from-window-scale-2-cycle-symmetric"
]

VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    BlockRandom[
      Length @ walkSeqs @ FindInfraGeodesic[g, 1, 16, 2, Infinity, All,
        Properties -> {"Simple"},
        "NextVertexFunction" -> (windows |-> RandomSample[MaximalBy[windows, w |-> Map[GraphDistance[g, #, Last @ w] &, Reverse @ Most @ w]], UpTo[1]])] <= 1,
      RandomSeeding -> 42
    ]
  ],
  True,
  TestID -> "FindInfraGeodesic-farthest-from-window-pruning-beam-1"
]

(* A selector composed with "Simple" still gives simple walks. *)

VerificationTest[
  With[{g = GridGraph[{3, 3}],
        degSum = w |-> VertexDegree[GridGraph[{3, 3}], w[[-2]]] + VertexDegree[GridGraph[{3, 3}], w[[-1]]]},
    With[{walks = walkSeqs @ FindInfraGeodesic[g, 1, 9, 1, {4}, All,
            Properties -> {"Simple"}, "NextVertexFunction" -> MinimalBy[degSum]]},
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
    FindInfraBisectingHyperplane[ g, 1, 36, 1, Properties -> { "Separating" }, Method -> "Greedy" ] ===
      FindInfraBisectingHyperplane[ g, 1, 36, 1, Properties -> { "Separating" }, Method -> "Greedy" ]
  ],
  True,
  TestID -> "FindInfraBisectingHyperplane-Greedy-deterministic"
]

VerificationTest[
  With[ { g = GridGraph[ { 6, 6 } ] },
    BlockRandom[ FindInfraBisectingHyperplane[ g, 1, 36, 1, Properties -> { "Separating" }, Method -> "RandomGreedy" ], RandomSeeding -> 4 ] ===
      BlockRandom[ FindInfraBisectingHyperplane[ g, 1, 36, 1, Properties -> { "Separating" }, Method -> "RandomGreedy" ], RandomSeeding -> 4 ]
  ],
  True,
  TestID -> "FindInfraBisectingHyperplane-RandomGreedy-seeded-reproducible"
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


(* ===== FindInfraPoint All ===== *)

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    Sort @ (FindInfraPoint[ g, All ]) === VertexList[ g ]
  ],
  True,
  TestID -> "FindInfraPoint-All-returns-every-vertex"
]

VerificationTest[
  With[ { g = PetersenGraph[ ] },
    Length @ FindInfraPoint[ g, All ] == VertexCount[ g ]
  ],
  True,
  TestID -> "FindInfraPoint-All-length-equals-vertex-count"
]


(* FindInfraLine carries no Method axis any more (EuclideanInertHeads, T3): the count
   fixes the mode, and its class is pinned against brute force in InfraLineTests.wlt.
   The Greedy / RandomGreedy determinism and BothSides regression guards above stay
   meaningful only for FindInfraParallel, which the walk-family item left untouched. *)

VerificationTest[
  With[ { g = GridGraph[ { 6, 6 } ], line = First @ FindInfraLine[ GridGraph[ { 6, 6 } ], 1, 2, 1 ] },
    FindInfraParallel[ g, line, 20, 1, Method -> "Greedy" ] === FindInfraParallel[ g, line, 20, 1, Method -> "Greedy" ]
  ],
  True,
  TestID -> "FindInfraParallel-Greedy-deterministic"
]

VerificationTest[
  With[ { g = GridGraph[ { 6, 6 } ], line = First @ FindInfraLine[ GridGraph[ { 6, 6 } ], 1, 2, 1 ] },
    BlockRandom[ FindInfraParallel[ g, line, 20, 1, Method -> "RandomGreedy" ], RandomSeeding -> 3 ] ===
      BlockRandom[ FindInfraParallel[ g, line, 20, 1, Method -> "RandomGreedy" ], RandomSeeding -> 3 ]
  ],
  True,
  TestID -> "FindInfraParallel-RandomGreedy-seeded-reproducible"
]

(* ===== FindInfraLine[g, segment] overload (the extension pool at kspec Infinity, ExtendInfraSegment[g, seg]) ===== *)

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


(* ===== ExtendInfraSegment: the extension pool on the distance matrix ===== *)

(* kspec Infinity is the line pool: FindInfraLine[g, seg] is ExtendInfraSegment[g, seg, Infinity], on a walk seed and on a geodesic-DAG seed *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    With[ { seg = InfraMeasurement[ g, InfraSegment[ 1, 11 ], "Graph" ] },
      Sort @ infraSpread @ ExtendInfraSegment[ g, { 6, 7 }, Infinity, All ] ===
        Sort @ FindInfraLine[ g, 6, 7, All ] &&
      Sort @ infraSpread @ ExtendInfraSegment[ g, seg, Infinity, All ] ===
        Sort @ FindInfraLine[ g, 1, 11, All ]
    ]
  ],
  True,
  TestID -> "ExtendInfraSegment-Infinity-is-FindInfraLine"
]

(* kspec 0 is the bundle itself: all six geodesics from 1 to 11 *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    With[ { seg = InfraMeasurement[ g, InfraSegment[ 1, 11 ], "Graph" ] },
      Sort @ infraSpread @ ExtendInfraSegment[ g, seg, 0, All ] === Sort @ infraSpread @ seg
    ]
  ],
  True,
  TestID -> "ExtendInfraSegment-kspec-0-is-the-bundle"
]

(* every extension is a geodesic containing the seed, with at most k edges added on each side *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ], seed = { 6, 7 }, k = 2 },
    AllTrue[ infraSpread @ ExtendInfraSegment[ g, seed, k, All ],
      w |-> InfraSegmentQ[ g, w ] &&
        With[ { pos = SequencePosition[ w, seed ] },
          pos =!= { } && pos[[ 1, 1 ]] - 1 <= k && Length[ w ] - pos[[ 1, 2 ]] <= k ] ]
  ],
  True,
  TestID -> "ExtendInfraSegment-extensions-are-geodesics-within-budget"
]

(* inextensible within the budget: a side still under budget has no neighbour prolonging the geodesic *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ], seed = { 6, 7 }, k = 2 },
    AllTrue[ infraSpread @ ExtendInfraSegment[ g, seed, k, All ],
      w |-> With[ { pos = First @ SequencePosition[ w, seed ] },
        ( pos[[ 1 ]] - 1 == k ||
          NoneTrue[ AdjacencyList[ g, First @ w ], GraphDistance[ g, #, Last @ w ] == Length[ w ] & ] ) &&
        ( Length[ w ] - pos[[ 2 ]] == k ||
          NoneTrue[ AdjacencyList[ g, Last @ w ], GraphDistance[ g, First @ w, # ] == Length[ w ] & ] ) ] ]
  ],
  True,
  TestID -> "ExtendInfraSegment-maximal-within-budget"
]

(* agreement with the walk engine where the two ends never interact -- the interior grid edge and the path -- for a budget k, an exact {k} and a range *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    AllTrue[ { 1, 2, 3, { 2 }, { 1, 2 }, Infinity },
      k |-> Sort @ infraSpread @ ExtendInfraSegment[ g, { 6, 7 }, k, All ] ===
        Sort @ walkSeqs @ ExtendInfraGeodesic[ g, { 6, 7 }, Infinity, Replace[ k, n_Integer :> UpTo[ n ] ], All, Properties -> { "Minimizing" } ] ]
  ],
  True,
  TestID -> "ExtendInfraSegment-equals-walk-engine-GridGraph"
]

VerificationTest[
  AllTrue[ { 1, 2, 5, { 2 }, { 2, 5 }, Infinity },
    k |-> Sort @ infraSpread @ ExtendInfraSegment[ PathGraph[ Range[ 5 ] ], { 4, 5 }, k, All ] ===
      Sort @ walkSeqs @ ExtendInfraGeodesic[ PathGraph[ Range[ 5 ] ], { 4, 5 }, Infinity, Replace[ k, n_Integer :> UpTo[ n ] ], All,
        Properties -> { "Minimizing" } ] ],
  True,
  TestID -> "ExtendInfraSegment-equals-walk-engine-PathGraph-asymmetric"
]

(* a geodesic-DAG seed extends as one object, the same set the walk engine gets by spreading over the six geodesics *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    With[ { seg = InfraMeasurement[ g, InfraSegment[ 1, 11 ], "Graph" ] },
      Sort @ infraSpread @ ExtendInfraSegment[ g, seg, 1, All ] ===
        Sort @ walkSeqs @ ExtendInfraGeodesic[ g, seg, Infinity, UpTo[ 1 ], All, Properties -> { "Minimizing" } ]
    ]
  ],
  True,
  TestID -> "ExtendInfraSegment-bundle-seed-equals-walk-engine-spread"
]

(* where the ends interact the global observer sees more: on C_6 through the edge 1-2 a budget of 2 buys all three lines, the ones FindInfraLine finds; the two-sided walk engine, stepping both sides at once, reaches only {6, 1, 2, 3} *)
VerificationTest[
  Sort @ infraSpread @ ExtendInfraSegment[ CycleGraph[ 6 ], { 1, 2 }, 2, All ],
  Sort @ { { 6, 1, 2, 3 }, { 1, 2, 3, 4 }, { 5, 6, 1, 2 } },
  TestID -> "ExtendInfraSegment-C6-compatibility"
]

(* "Direction" as on FindInfraLine: only past the right end, only past the left end *)
VerificationTest[
  { infraSpread @ ExtendInfraSegment[ PathGraph[ Range[ 7 ] ], { 3, 4 }, 2, All, "Direction" -> "Forward" ],
    infraSpread @ ExtendInfraSegment[ PathGraph[ Range[ 7 ] ], { 3, 4 }, 2, All, "Direction" -> "Backward" ],
    infraSpread @ ExtendInfraSegment[ PathGraph[ Range[ 7 ] ], { 3, 4 }, Infinity, All, "Direction" -> "Forward" ] },
  { { { 3, 4, 5, 6 } }, { { 1, 2, 3, 4 } }, { { 3, 4, 5, 6, 7 } } },
  TestID -> "ExtendInfraSegment-Direction"
]

(* one class under every Method *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    SameQ @@ ( Sort @ infraSpread @ ExtendInfraSegment[ g, { 6, 7 }, 2, All, Method -> # ] & /@
      { "Exhaustive", "Greedy", "RandomGreedy" } )
  ],
  True,
  TestID -> "ExtendInfraSegment-class-invariant-under-Method"
]

(* the pool carries the family by DP -- one atom per admissible end pair, count, occupation, lengths and ends without enumeration *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    With[ { pool = ExtendInfraSegment[ g, { 6, 7 }, 2, All ] },
      MatchQ[ pool, { _Graph, __Graph } ] &&
      Total[ Max @ InfraDensity[ g, # ] & /@ pool ] === Length @ infraSpread @ pool &&
      Total @ InfraDensity[ g, pool ] === Total[ Length /@ infraSpread @ pool ] &&
      Sort @ Union[ First /@ infraSpread @ pool ] === { 1, 9, 14 } &&
      Sort @ Union[ Last /@ infraSpread @ pool ] === { 4, 12, 15 }
    ]
  ],
  True,
  TestID -> "ExtendInfraSegment-pool-DP-counts-match-enumeration"
]

(* the longest extensions are a selection on the pool, and keep the pool form *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    With[ { pool = ExtendInfraSegment[ g, { 6, 7 }, Infinity, All ] },
      With[ { longest = SelectInfraWalk[ g, pool, All, "From" -> "MaxLength" ] },
        MatchQ[ longest, _Graph | { __Graph } ] &&
        Sort @ infraSpread @ longest === Sort @ MaximalBy[ infraSpread @ pool, Length ]
      ]
    ]
  ],
  True,
  TestID -> "ExtendInfraSegment-longest-by-SelectInfraWalk"
]

(* the count contract: count-less is one witness of the class, UpTo is soft, a strict n fails on under-supply *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    With[ { one = ExtendInfraSegment[ g, { 6, 7 }, 2 ], all = infraSpread @ ExtendInfraSegment[ g, { 6, 7 }, 2, All ] },
      Length @ infraSpread @ one == 1 && MemberQ[ all, First @ infraSpread @ one ] &&
      Length @ infraSpread @ ExtendInfraSegment[ g, { 6, 7 }, 2, UpTo[ 3 ] ] == 3 &&
      ExtendInfraSegment[ PathGraph[ Range[ 5 ] ], { 2, 3 }, Infinity, 99 ] === { }
    ]
  ],
  True,
  TestID -> "ExtendInfraSegment-count-contract"
]

(* the 6-ary Tarski A4 form is untouched, with and without its count *)
VerificationTest[
  { ExtendInfraSegment[ PathGraph[ Range[ 5 ] ], 1, 2, 1, 2 ],
    ExtendInfraSegment[ PathGraph[ Range[ 5 ] ], 1, 2, 1, 2, All ] },
  { { 3 }, { 3 } },
  TestID -> "ExtendInfraSegment-A4-PathGraph"
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
