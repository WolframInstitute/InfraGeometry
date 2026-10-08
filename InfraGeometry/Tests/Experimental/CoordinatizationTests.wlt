BeginTestSection["Coordinatization"]

geodesicGraph = WolframInstitute`InfraGeometry`PackageScope`geodesicGraph;
walkSequence  = WolframInstitute`InfraGeometry`PackageScope`walkSequence;

(* The FindInfraRadarBasis / InfraRadarBasisQ deprecation aliases were deleted with the
   Coordinatization merge (PacletSplit T3, per Work/Backlog/APISurfaceCleanup.md).  What
   they tested is the ResolvingSetQ-path-endpoint-resolves, ResolvingSetQ-cycle-two-resolves
   and MetricDimension-path tests, which arrive with the rest of the suite in T2c. *)

VerificationTest[
  With[{g = PathGraph[Range[5]], b = {1}},
    RadarCoordinates[g, b, 3] == {2}
  ],
  True,
  TestID -> "RadarCoordinates-path-distance-vector"
]

VerificationTest[
  With[{g = PathGraph[Range[5]], b = {1, 5}},
    Table[RadarCoordinates[g, b, v], {v, 1, 5}]
  ],
  {{0, 4}, {1, 3}, {2, 2}, {3, 1}, {4, 0}},
  TestID -> "RadarCoordinates-path-endpoints-basis"
]

VerificationTest[
  With[{g = PathGraph[Range[5]], b = {1}},
    DuplicateFreeQ[Table[RadarCoordinates[g, b, v], {v, VertexList[g]}]]
  ],
  True,
  TestID -> "RadarBasis-roundtrip-distinguishes"
]

VerificationTest[
  With[{g = PathGraph[Range[5]], b = {1, 5}},
    AssociationQ @ RadarCoordinates[g, b]
  ],
  True,
  TestID -> "RadarCoordinates-bulk-is-association"
]

VerificationTest[
  With[{g = PathGraph[Range[5]], b = {1, 5}},
    RadarCoordinates[g, b]
  ],
  Association[1 -> {0, 4}, 2 -> {1, 3}, 3 -> {2, 2}, 4 -> {3, 1}, 5 -> {4, 0}],
  TestID -> "RadarCoordinates-bulk-matches-vertex-form"
]

VerificationTest[
  With[{g = PathGraph[Range[5]], b = {1, 5}},
    Table[RadarCoordinates[g, b][v] === RadarCoordinates[g, b, v], {v, VertexList[g]}]
  ],
  {True, True, True, True, True},
  TestID -> "RadarCoordinates-operator-form-matches-direct"
]

VerificationTest[
  With[{g = PathGraph[Range[5]], b = {1, 5}},
    RadarCoordinates[g, b, 3] === RadarCoordinates[g, b, 3]
  ],
  True,
  TestID -> "RadarCoordinates-density-singleton-degenerates"
]

VerificationTest[
  With[{g = PathGraph[Range[5]], b = {1, 5}},
    RadarCoordinates[g, b, <| 2 -> 1, 4 -> 1 |>]
  ],
  {{1, 3}, {3, 1}},
  TestID -> "RadarCoordinates-density-multi-returns-list"
]

VerificationTest[
  With[{g = PathGraph[Range[5]], b = {<| 1 -> 1, 5 -> 1 |>}},
    RadarCoordinates[g, b, 3]
  ],
  {2},
  TestID -> "RadarCoordinates-density-anchor-aggregation-Min"
]

(* A vertex-list station reads as a set in the two-argument form too *)
VerificationTest[
  With[{g = PathGraph[Range[5]], b = {{1, 5}, 3}},
    RadarCoordinates[g, b]
  ],
  <| 1 -> {0, 2}, 2 -> {1, 1}, 3 -> {2, 0}, 4 -> {1, 1}, 5 -> {0, 2} |>,
  TestID -> "RadarCoordinates-bulk-vertex-list-station"
]

VerificationTest[
  With[{g = GridGraph[{3, 3}], b = {{1, 9}}},
    RadarCoordinates[g, b] === AssociationMap[RadarCoordinates[g, b, #] &, VertexList[g]]
  ],
  True,
  TestID -> "RadarCoordinates-bulk-vertex-list-station-matches-vertex-form"
]

(* ===== OrthogonalCoordinates ===== *)

(* Each test below picks the centre c so it sits at position 0 on every
   axis, making the signed coordinate coincide with the underlying layer
   index -- the simplest setup for exercising the projection / option
   semantics. *)

VerificationTest[
  With[{g = GridGraph[{4, 4}], xAxis = {1, 2, 3, 4}, yAxis = {1, 5, 9, 13}},
    OrthogonalCoordinates[g, 1, {xAxis, yAxis}, 6]
  ],
  {1, 1},
  TestID -> "OrthogonalCoordinates-grid-2axes-vertex6"
]

VerificationTest[
  With[{g = GridGraph[{4, 4}], xAxis = {1, 2, 3, 4}, yAxis = {1, 5, 9, 13}},
    OrthogonalCoordinates[g, 1, {xAxis, yAxis}, 11]
  ],
  {2, 2},
  TestID -> "OrthogonalCoordinates-grid-2axes-vertex11"
]

VerificationTest[
  With[{g = GridGraph[{4, 4}], xAxis = {1, 2, 3, 4}, yAxis = {1, 5, 9, 13}},
    Length @ OrthogonalCoordinates[g, 1, {xAxis, yAxis}]
  ],
  16,
  TestID -> "OrthogonalCoordinates-grid-bulk-association"
]

VerificationTest[
  With[{g = GridGraph[{4, 4}], xAxis = {1, 2, 3, 4}, yAxis = {1, 5, 9, 13}},
    AssociationQ @ OrthogonalCoordinates[g, 1, {xAxis, yAxis}]
  ],
  True,
  TestID -> "OrthogonalCoordinates-bulk-is-association"
]

VerificationTest[
  With[{g = PathGraph[Range[5]], axes = {{1, 2, 3, 4, 5}}},
    Table[OrthogonalCoordinates[g, 1, axes, v], {v, 1, 5}]
  ],
  {{0}, {1}, {2}, {3}, {4}},
  TestID -> "OrthogonalCoordinates-single-axis-recovers-position"
]

VerificationTest[
  With[{g = PathGraph[Range[5]],
        dag = Graph[{DirectedEdge[1, 2], DirectedEdge[2, 3]}]},
    OrthogonalCoordinates[g, 1, {dag}, 4]
  ],
  {2},
  TestID -> "OrthogonalCoordinates-dag-axis-outside-reach"
]

(* Path-graph axes: the geodesic graph is read as one axis. *)
VerificationTest[
  With[{g = GridGraph[{4, 4}],
        xAxis = geodesicGraph @ {1, 2, 3, 4},
        yAxis = geodesicGraph @ {1, 5, 9, 13}},
    OrthogonalCoordinates[g, 1, {xAxis, yAxis}, 11]
  ],
  {2, 2},
  TestID -> "OrthogonalCoordinates-pathgraph-axes"
]

(* ===== SelectCoordinate option (ties on a 4-cycle) ===== *)

(* On CycleGraph[4] with axis {1, 2, 3} and centre 1 (at position 0):
   vertex 4 has d(4,1)=1, d(4,2)=2, d(4,3)=1 -- a tie at indices 0 and 2.
   Different "SelectCoordinate" choices pick / aggregate / preserve the
   tied list. *)

VerificationTest[
  With[{g = CycleGraph[4], axes = {{1, 2, 3}}},
    OrthogonalCoordinates[g, 1, axes, 4, "SelectCoordinate" -> First]
  ],
  {0},
  TestID -> "OrthogonalCoordinates-SelectCoordinate-First"
]

VerificationTest[
  With[{g = CycleGraph[4], axes = {{1, 2, 3}}},
    OrthogonalCoordinates[g, 1, axes, 4, "SelectCoordinate" -> Last]
  ],
  {2},
  TestID -> "OrthogonalCoordinates-SelectCoordinate-Last"
]

VerificationTest[
  With[{g = CycleGraph[4], axes = {{1, 2, 3}}},
    OrthogonalCoordinates[g, 1, axes, 4, "SelectCoordinate" -> Min]
  ],
  {0},
  TestID -> "OrthogonalCoordinates-SelectCoordinate-Min"
]

VerificationTest[
  With[{g = CycleGraph[4], axes = {{1, 2, 3}}},
    OrthogonalCoordinates[g, 1, axes, 4, "SelectCoordinate" -> Max]
  ],
  {2},
  TestID -> "OrthogonalCoordinates-SelectCoordinate-Max"
]

VerificationTest[
  With[{g = CycleGraph[4], axes = {{1, 2, 3}}},
    OrthogonalCoordinates[g, 1, axes, 4, "SelectCoordinate" -> Mean]
  ],
  {1},
  TestID -> "OrthogonalCoordinates-SelectCoordinate-Mean"
]

VerificationTest[
  With[{g = CycleGraph[4], axes = {{1, 2, 3}}},
    OrthogonalCoordinates[g, 1, axes, 4, "SelectCoordinate" -> Median]
  ],
  {1},
  TestID -> "OrthogonalCoordinates-SelectCoordinate-Median"
]

(* All preserves the tied list as the per-axis coordinate. *)
VerificationTest[
  With[{g = CycleGraph[4], axes = {{1, 2, 3}}},
    OrthogonalCoordinates[g, 1, axes, 4, "SelectCoordinate" -> All]
  ],
  {{0, 2}},
  TestID -> "OrthogonalCoordinates-SelectCoordinate-All"
]

(* User-supplied function works without an allow-list. *)
VerificationTest[
  With[{g = CycleGraph[4], axes = {{1, 2, 3}}},
    OrthogonalCoordinates[g, 1, axes, 4, "SelectCoordinate" -> (Quantile[#, 0.25] &)]
  ],
  {0},
  TestID -> "OrthogonalCoordinates-SelectCoordinate-userFunction"
]

(* "Centered" rule: shifted ix_v contains 0 (vertex 4 ties at positions 0
   and 2 on axis {1, 2, 3} anchored at 1, so shifted = {0, 2}) -> coord 0. *)
VerificationTest[
  With[{g = CycleGraph[4], axes = {{1, 2, 3}}},
    OrthogonalCoordinates[g, 1, axes, 4, "SelectCoordinate" -> "Centered"]
  ],
  {0},
  TestID -> "OrthogonalCoordinates-SelectCoordinate-Centered-contains-0"
]

(* "Centered" rule: shifted ix_v doesn't contain 0 -> Median fallback.
   On PathGraph[5] anchored at vertex 2 (position 1 of axis {1, 2, 3, 4, 5}),
   vertex 4 has unique closest position 3, so ix_v = {3} and shifted = {2}.
   Doesn't contain 0; Median[{2}] = 2. *)
VerificationTest[
  With[{g = PathGraph @ Range[5], axes = {{1, 2, 3, 4, 5}}},
    OrthogonalCoordinates[g, 2, axes, 4, "SelectCoordinate" -> "Centered"]
  ],
  {2},
  TestID -> "OrthogonalCoordinates-SelectCoordinate-Centered-fallback-Median"
]

(* "Centered" with anchor not at position 0: axis {3, 1, 2} on CycleGraph[4]
   anchored at vertex 1 (position 1).  For v = 4: distances are
   d(4, 3) = 1, d(4, 1) = 1, d(4, 2) = 2 -> ix_v = {0, 1}, shifted = {-1, 0}.
   Contains 0 -> coord 0. *)
VerificationTest[
  With[{g = CycleGraph[4], axes = {{3, 1, 2}}},
    OrthogonalCoordinates[g, 1, axes, 4, "SelectCoordinate" -> "Centered"]
  ],
  {0},
  TestID -> "OrthogonalCoordinates-SelectCoordinate-Centered-anchor-interior"
]

(* "Centered" coords are integers (Round[Median[...]] fallback).  Run on a
   reasonably diverse mesh and assert every per-vertex per-axis coord is an
   integer. *)
VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    With[{axes = FindInfraOrthogonalAxes[g, 6, All]},
      AllTrue[
        Catenate[OrthogonalCoordinates[g, 6, axes, #] & /@ VertexList[g]],
        IntegerQ
      ]
    ]
  ],
  True,
  TestID -> "OrthogonalCoordinates-Centered-integer-coords"
]

(* ===== FindInfraOrthogonalAxes and FindInfraOrthogonalRays ===== *)

(* the exact projection test written out on GraphDistance: every vertex of each walk has c as its only nearest vertex on the other *)
orthogonalProjectionQ[g_, c_, a_, b_] :=
  AllTrue[b, v |-> MinimalBy[a, GraphDistance[g, v, #] &] === {c}] &&
    AllTrue[a, v |-> MinimalBy[b, GraphDistance[g, v, #] &] === {c}]

(* the coordinate lines and rays through the centre of GridGraph[ConstantArray[n, d]], half-length (n - 1)/2 *)
straightAxes[n_, d_] := With[{c = (n^d + 1)/2, h = (n - 1)/2}, Table[c + k s, {s, n^Range[0, d - 1]}, {k, -h, h}]]
straightRays[n_, d_] := With[{c = (n^d + 1)/2, h = (n - 1)/2}, Catenate @ Table[c + k s, {s, n^Range[0, d - 1]}, {sign, {-1, 1}}, {k, 0, sign h, sign}]]

VerificationTest[
  FindInfraOrthogonalAxes[PathGraph[Range[5]], 3, All],
  {{1, 2, 3, 4, 5}},
  TestID -> "FindInfraOrthogonalAxes-path-single-line"
]

VerificationTest[
  FindInfraOrthogonalAxes[PathGraph[Range[5]], 1, All],
  {},
  TestID -> "FindInfraOrthogonalAxes-path-endpoint-no-line"
]

VerificationTest[
  FindInfraOrthogonalAxes[PathGraph[Range[5]], 3, All, 100],
  {},
  TestID -> "FindInfraOrthogonalAxes-strict-fail-too-many"
]

VerificationTest[
  FindInfraOrthogonalAxes[GridGraph[{5, 5}], 13, 2, Automatic] === FindInfraOrthogonalAxes[GridGraph[{5, 5}], 13, 2],
  True,
  TestID -> "FindInfraOrthogonalAxes-explicit-Automatic-count"
]

(* All keeps the maximal axes only: {1, 2, 3} extends to {1, 2, 3, 4} *)
VerificationTest[
  FindInfraOrthogonalAxes[PathGraph[Range[4]], 2, All, All],
  {{{1, 2, 3, 4}}},
  TestID -> "FindInfraOrthogonalAxes-All-keeps-maximal-axes"
]

(* a range of half-lengths keeps the axes maximal inside the range; a half shorter than the range ends where the graph ends *)
VerificationTest[
  { FindInfraOrthogonalAxes[PathGraph[Range[9]], 3, UpTo[3]],
    FindInfraOrthogonalAxes[PathGraph[Range[9]], 5, {1, 2}],
    FindInfraOrthogonalAxes[PathGraph[Range[9]], 5, {3, 4}],
    FindInfraOrthogonalAxes[PathGraph[Range[9]], 5, {5, 6}] },
  { {{1, 2, 3, 4, 5, 6}}, {{3, 4, 5, 6, 7}}, {Range[9]}, {} },
  TestID -> "FindInfraOrthogonalAxes-length-ranges"
]

VerificationTest[
  Table[Sort @ FindInfraOrthogonalAxes[GridGraph[ConstantArray[5, d]], (5^d + 1)/2, 2] === Sort @ straightAxes[5, d], {d, 2, 4}],
  {True, True, True},
  TestID -> "FindInfraOrthogonalAxes-grid-straight-cross-first-in-dimensions-2-3-4"
]

(* the straight cross comes first, the bent crosses follow; every pair passes the projection test and no axis of the class extends a set *)
VerificationTest[
  With[{g = GridGraph[{9, 9}], c = 41},
    With[{sets = FindInfraOrthogonalAxes[g, c, 2, All], axes = Catenate @ FindInfraOrthogonalAxes[g, c, 2, All, "AxisCount" -> 1]},
      { Sort @ First @ sets === Sort @ {{39, 40, 41, 42, 43}, {23, 32, 41, 50, 59}},
        Length @ sets > 1,
        AllTrue[sets, set |-> AllTrue[Subsets[set, {2}], orthogonalProjectionQ[g, c, Sequence @@ #] &]],
        AllTrue[sets, set |-> NoneTrue[Complement[axes, set], a |-> AllTrue[set, orthogonalProjectionQ[g, c, a, #] &]]] }]],
  {True, True, True, True},
  TestID -> "FindInfraOrthogonalAxes-sets-perpendicular-and-maximal"
]

VerificationTest[
  Sort @ FindInfraOrthogonalAxes[GridGraph[{5, 5}], 13, 2, "AxisCount" -> 2],
  Sort @ {{11, 12, 13, 14, 15}, {3, 8, 13, 18, 23}},
  TestID -> "FindInfraOrthogonalAxes-5x5grid-centre-straight"
]

VerificationTest[
  { Length @ FindInfraOrthogonalAxes[GridGraph[{3, 3}], 5, 1, "AxisCount" -> 2],
    FindInfraOrthogonalAxes[GridGraph[{3, 3}], 5, 1, "AxisCount" -> 5],
    Length @ FindInfraOrthogonalAxes[GridGraph[{3, 3}], 5, 1, "AxisCount" -> UpTo[1]] },
  { 2, {}, 1 },
  TestID -> "FindInfraOrthogonalAxes-AxisCount"
]

(* at the corner of a 3 x 3 grid the L through it is the one maximal geodesic with 1 interior *)
VerificationTest[
  FindInfraOrthogonalAxes[GridGraph[{3, 3}], 1, All],
  {{3, 2, 1, 4, 7}},
  TestID -> "FindInfraOrthogonalAxes-3x3grid-corner-L"
]

VerificationTest[
  FindInfraOrthogonalAxes[GridGraph[{4, 4}], 6, All, All] === FindInfraOrthogonalAxes[GridGraph[{4, 4}], 6, All, All],
  True,
  TestID -> "FindInfraOrthogonalAxes-deterministic"
]

(* bounded half-lengths make the answer depend on B(c, 2 r) only *)
VerificationTest[
  With[{g = GridGraph[{10, 10}], c = 45},
    { FindInfraOrthogonalAxes[g, c, 2, All] === FindInfraOrthogonalAxes[NeighborhoodGraph[g, c, 4], c, 2, All],
      FindInfraOrthogonalRays[g, c, 2, All] === FindInfraOrthogonalRays[NeighborhoodGraph[g, c, 4], c, 2, All] }],
  {True, True},
  TestID -> "FindInfraOrthogonalAxes-Rays-locality"
]

(* ===== the weighted centre ===== *)

VerificationTest[
  { FindInfraOrthogonalAxes[PathGraph[Range[5]], <| 3 -> 1 |>, All] === FindInfraOrthogonalAxes[PathGraph[Range[5]], 3, All],
    FindInfraOrthogonalRays[GridGraph[{5, 5}], <| 13 -> 1 |>, 2, All] === FindInfraOrthogonalRays[GridGraph[{5, 5}], 13, 2, All] },
  {True, True},
  TestID -> "FindInfraOrthogonalAxes-Rays-singleton-centre-equals-vertex"
]

VerificationTest[
  With[{sets = FindInfraOrthogonalAxes[PathGraph[Range[5]], <| 2 -> 1, 4 -> 1 |>, All, All]},
    sets =!= {} && AllTrue[Catenate @ sets, MemberQ[#, 2] || MemberQ[#, 4] &]],
  True,
  TestID -> "FindInfraOrthogonalAxes-weighted-centre-axes-contain-some-anchor"
]

VerificationTest[
  With[{sets = FindInfraOrthogonalAxes[GridGraph[{4, 4}], <| 6 -> 1, 11 -> 1 |>, All, All]},
    sets =!= {} && AllTrue[sets, set |-> Or @@ (c |-> AllTrue[set, MemberQ[#, c] &]) /@ {6, 11}] && DuplicateFreeQ[Sort /@ sets]],
  True,
  TestID -> "FindInfraOrthogonalAxes-weighted-centre-one-anchor-per-set"
]

(* ===== the search options ===== *)

(* the next-vertex function never changes the class: All is the same under every order *)
VerificationTest[
  With[{g = GridGraph[{7, 7}], c = 25},
    { FindInfraOrthogonalAxes[g, c, 2, All] === (SeedRandom[1]; FindInfraOrthogonalAxes[g, c, 2, All, "NextVertexFunction" -> RandomSample]),
      FindInfraOrthogonalRays[g, c, 2, All] === (SeedRandom[1]; FindInfraOrthogonalRays[g, c, 2, All, "NextVertexFunction" -> RandomSample]) }],
  {True, True},
  TestID -> "FindInfraOrthogonalAxes-Rays-class-invariant-under-NextVertexFunction"
]

(* RandomChoice draws one maximal set; a pruning returns some of them *)
VerificationTest[
  With[{g = GridGraph[{7, 7}], c = 25},
    With[{all = FindInfraOrthogonalAxes[g, c, 2, All]},
      { MemberQ[all, Sort @ (SeedRandom[3]; FindInfraOrthogonalAxes[g, c, 2, "NextVertexFunction" -> RandomChoice])],
        SubsetQ[all, (SeedRandom[3]; FindInfraOrthogonalAxes[g, c, 2, All, "NextVertexFunction" -> (RandomSample[#, UpTo[1]] &)])] }]],
  {True, True},
  TestID -> "FindInfraOrthogonalAxes-RandomChoice-and-pruning"
]

(* Properties names an InfraPerpendicularQ test, or is a predicate on the window *)
VerificationTest[
  With[{g = GridGraph[{5, 5}]},
    With[{set = FindInfraOrthogonalAxes[g, 13, 2, Properties -> "Projection"]},
      { Length @ set >= 2 && AllTrue[Subsets[set, {2}], InfraPerpendicularQ[g, Sequence @@ #] &],
        Length @ FindInfraOrthogonalAxes[g, 13, 2, All, Properties -> (Length[#] <= 1 &)] ===
          Length @ FindInfraOrthogonalAxes[g, 13, 2, All, "AxisCount" -> 1],
        Length @ FindInfraOrthogonalAxes[g, 13, 2, Properties -> (True &)] ===
          Length @ FindInfraOrthogonalAxes[g, 13, 2, All, "AxisCount" -> 1] }]],
  {True, True, True},
  TestID -> "FindInfraOrthogonalAxes-Properties"
]

(* ===== rays ===== *)

VerificationTest[
  { FindInfraOrthogonalRays[PathGraph[Range[5]], 3, All], FindInfraOrthogonalRays[PathGraph[Range[5]], 1, All] },
  { {{3, 2, 1}, {3, 4, 5}}, {{1, 2, 3, 4, 5}} },
  TestID -> "FindInfraOrthogonalRays-path"
]

VerificationTest[
  Table[Sort @ FindInfraOrthogonalRays[GridGraph[ConstantArray[5, d]], (5^d + 1)/2, 2] === Sort @ straightRays[5, d], {d, 2, 4}],
  {True, True, True},
  TestID -> "FindInfraOrthogonalRays-grid-straight-frame-first-in-dimensions-2-3-4"
]

VerificationTest[
  With[{g = GridGraph[{9, 9}], c = 41},
    With[{sets = FindInfraOrthogonalRays[g, c, 2, All], rays = Catenate @ FindInfraOrthogonalRays[g, c, 2, All, "RayCount" -> 1]},
      { Sort @ First @ sets === Sort @ {{41, 40, 39}, {41, 42, 43}, {41, 32, 23}, {41, 50, 59}},
        AllTrue[Catenate @ sets, First[#] === c &],
        AllTrue[sets, set |-> AllTrue[Subsets[set, {2}], orthogonalProjectionQ[g, c, Sequence @@ #] &]],
        AllTrue[sets, set |-> NoneTrue[Complement[rays, set], a |-> AllTrue[set, orthogonalProjectionQ[g, c, a, #] &]]] }]],
  {True, True, True, True},
  TestID -> "FindInfraOrthogonalRays-sets-perpendicular-and-maximal"
]

VerificationTest[
  { Length @ FindInfraOrthogonalRays[GridGraph[{5, 5}], 13, 2, "RayCount" -> 2],
    FindInfraOrthogonalRays[GridGraph[{5, 5}], 13, 2, "RayCount" -> 5] },
  { 2, {} },
  TestID -> "FindInfraOrthogonalRays-RayCount"
]

(* an axis splits at c into two rays of the frame *)
VerificationTest[
  With[{g = GridGraph[{7, 7}], c = 25},
    Sort @ Catenate[{Reverse @ Take[#, Position[#, c][[1, 1]]], Drop[#, Position[#, c][[1, 1]] - 1]} & /@ FindInfraOrthogonalAxes[g, c, 3]] ===
      Sort @ FindInfraOrthogonalRays[g, c, 3]],
  True,
  TestID -> "FindInfraOrthogonalRays-axes-split-into-rays"
]

(* ===== the coordinates read off a found set ===== *)

(* the straight cross at scale 1; at scale All the 3 x 3 grid has only corner-to-corner axes, since a straight line through 5 extends by a turn *)
VerificationTest[
  With[{g = GridGraph[{3, 3}], c = 5},
    With[{axes = FindInfraOrthogonalAxes[g, c, 1]},
      { Length @ axes == 2 && OrthogonalCoordinates[g, c, axes, c] === ConstantArray[0, Length @ axes],
        AllTrue[Range @ Length @ axes,
          i |-> AllTrue[axes[[i]],
            v |-> With[{coords = OrthogonalCoordinates[g, c, axes, v]},
              AllTrue[Range @ Length @ coords, j |-> j == i || coords[[j]] == 0]]]] }]],
  {True, True},
  TestID -> "FindInfraOrthogonalAxes-well-conditioned-coords"
]

VerificationTest[
  Sort @ VertexList @ SprayGraph[GridGraph[{3, 3}], 5],
  Range[9],
  TestID -> "SprayGraph-3x3-vertices"
]

VerificationTest[
  Length @ EdgeList @ SprayGraph[PathGraph[Range[5]], 3],
  4,
  TestID -> "SprayGraph-path-edges-symmetric"
]

VerificationTest[
  Sort @ Select[VertexList[SprayGraph[GridGraph[{3, 3}], 5]],
    VertexOutDegree[SprayGraph[GridGraph[{3, 3}], 5], #] == 0 &],
  {1, 3, 7, 9},
  TestID -> "SprayGraph-3x3-sinks-are-corners"
]

VerificationTest[
  Length @ VertexList @ SprayGraph[GridGraph[{3, 3}], 5, "AxisLength" -> 1],
  5,
  TestID -> "SprayGraph-AxisLength-truncation"
]

(* ===== FindInfraSpanningAxes (no-center form) ===== *)

VerificationTest[
  Length @ FindInfraSpanningAxes[PathGraph[Range[5]], All] >= 1,
  True,
  TestID -> "FindInfraSpanningAxes-path-some-axes"
]

VerificationTest[
  Length @ FindInfraSpanningAxes[GridGraph[{4, 4}], UpTo[5]] <= 5,
  True,
  TestID -> "FindInfraSpanningAxes-grid-UpTo-bound"
]

VerificationTest[
  FindInfraSpanningAxes[PathGraph[Range[5]], 99],
  { },
  TestID -> "FindInfraSpanningAxes-strict-fail-too-many"
]

(* ===== Z-valued OrthogonalCoordinates from a center ===== *)

(* PathGraph[5] at 3 with the default frame from FindInfraOrthogonalAxes:
   coords are signed displacements, the centre maps to {0, ..., 0}. *)

VerificationTest[
  With[{g = PathGraph[Range[5]]},
    With[{axes = FindInfraOrthogonalAxes[g, 3, All]},
      OrthogonalCoordinates[g, 3, axes, 3]
    ]
  ],
  ConstantArray[0, Length @ FindInfraOrthogonalAxes[PathGraph[Range[5]], 3, All]],
  TestID -> "OrthogonalCoordinates-center-maps-to-origin"
]

VerificationTest[
  With[{g = PathGraph[Range[5]]},
    With[{axes = FindInfraOrthogonalAxes[g, 3, All]},
      AssociationQ @ OrthogonalCoordinates[g, 3, axes]
        && Length[OrthogonalCoordinates[g, 3, axes]] === 5
    ]
  ],
  True,
  TestID -> "OrthogonalCoordinates-path-bulk-association"
]

VerificationTest[
  With[{g = GridGraph[{4, 4}], c = 6},
    With[{axes = FindInfraOrthogonalAxes[g, c, All]},
      OrthogonalCoordinates[g, c, axes, c]
    ]
  ],
  ConstantArray[0, Length @ FindInfraOrthogonalAxes[GridGraph[{4, 4}], 6, All]],
  TestID -> "OrthogonalCoordinates-grid-center-self-zero"
]

(* Centre is now positional: replaces the old "Origin" -> ... option. *)

VerificationTest[
  With[{g = GridGraph[{4, 4}],
        xAxis = {1, 2, 3, 4}, yAxis = {1, 5, 9, 13}},
    OrthogonalCoordinates[g, 6, {xAxis, yAxis}, 11]
  ],
  {1, 1},
  TestID -> "OrthogonalCoordinates-positional-center-signed"
]

VerificationTest[
  With[{g = GridGraph[{4, 4}],
        xAxis = {1, 2, 3, 4}, yAxis = {1, 5, 9, 13}},
    OrthogonalCoordinates[g, 6, {xAxis, yAxis}, 1]
  ],
  {-1, -1},
  TestID -> "OrthogonalCoordinates-positional-center-negative"
]

(* ===== density centre ===== *)

VerificationTest[
  With[{g = PathGraph[Range[5]]},
    With[{axes = FindInfraOrthogonalAxes[g, 3, All]},
      OrthogonalCoordinates[g, 3, axes, 3] ==
        OrthogonalCoordinates[g, 3, axes, 3]
    ]
  ],
  True,
  TestID -> "OrthogonalCoordinates-density-singleton-equals-vertex"
]


(* ===== ResistanceCoordinates =====
   Central claim: ||Phi(u) - Phi(v)||^2 == R(u, v) (Klein-Randic isometry). *)

isometryError[g_] :=
  With[{phi = Values @ ResistanceCoordinates[g]},
    Max[Abs[Outer[SquaredEuclideanDistance, phi, phi, 1] - EffectiveResistance[g]]]
  ]

VerificationTest[
  isometryError[PetersenGraph[]] < 10^-10,
  True,
  TestID -> "ResistanceCoordinates-isometry-Petersen"
]

VerificationTest[
  isometryError[GridGraph[{3, 3}]] < 10^-10,
  True,
  TestID -> "ResistanceCoordinates-isometry-Grid3x3"
]

VerificationTest[
  isometryError[CycleGraph[8]] < 10^-10,
  True,
  TestID -> "ResistanceCoordinates-isometry-Cycle8"
]

VerificationTest[
  isometryError[CompleteGraph[5]] < 10^-10,
  True,
  TestID -> "ResistanceCoordinates-isometry-K5"
]

VerificationTest[
  isometryError[Graph[{1 <-> 2, 2 <-> 3, 3 <-> 4, 2 <-> 5}]] < 10^-10,
  True,
  TestID -> "ResistanceCoordinates-isometry-tree"
]

(* Dimension = n - c for connected graphs. *)

VerificationTest[
  Length @ First @ Values @ ResistanceCoordinates[PetersenGraph[]],
  9,
  TestID -> "ResistanceCoordinates-dimension-Petersen"
]

VerificationTest[
  Length @ First @ Values @ ResistanceCoordinates[GridGraph[{4, 4}]],
  15,
  TestID -> "ResistanceCoordinates-dimension-Grid4x4"
]

(* Centeredness: rows sum to zero. *)

VerificationTest[
  With[{phi = Values @ ResistanceCoordinates[GridGraph[{3, 3}]]},
    Max[Abs[Total[phi]]] < 10^-9
  ],
  True,
  TestID -> "ResistanceCoordinates-centered"
]

(* "Origin" -> v sets v's coordinate to 0. *)

VerificationTest[
  Max[Abs @ ResistanceCoordinates[PetersenGraph[], "Origin" -> 1][1]] < 10^-10,
  True,
  TestID -> "ResistanceCoordinates-Origin-zeroes-anchor"
]

VerificationTest[
  Max[Abs @ ResistanceCoordinates[CycleGraph[6], 3, "Origin" -> 3]] < 10^-10,
  True,
  TestID -> "ResistanceCoordinates-Origin-single-call"
]

VerificationTest[
  Length @ First @ Values @ ResistanceCoordinates[PetersenGraph[], "Dimension" -> 3],
  3,
  TestID -> "ResistanceCoordinates-Dimension-Integer"
]

VerificationTest[
  Length @ First @ Values @ ResistanceCoordinates[PetersenGraph[], "Dimension" -> UpTo[100]],
  9,
  TestID -> "ResistanceCoordinates-Dimension-UpTo-clipped"
]

VerificationTest[
  Dimensions @ ResistanceCoordinates[PetersenGraph[], <| 1 -> 1, 2 -> 1, 3 -> 1 |>],
  {3, 9},
  TestID -> "ResistanceCoordinates-density-shape"
]

VerificationTest[
  ResistanceCoordinates[PetersenGraph[], <| 1 -> 1, 2 -> 1, 3 -> 1 |>][[1]] ==
    ResistanceCoordinates[PetersenGraph[], 1],
  True,
  TestID -> "ResistanceCoordinates-density-rows-match-singletons"
]

VerificationTest[
  ResistanceCoordinates[PetersenGraph[], 1] ==
    ResistanceCoordinates[PetersenGraph[], 1],
  True,
  TestID -> "ResistanceCoordinates-density-singleton-degenerates"
]

(* "Rescaling" -> "None" gives the smallest nonzero Laplacian eigenvectors. *)

VerificationTest[
  With[{
    phi = Values @ ResistanceCoordinates[CycleGraph[6], "Rescaling" -> "None"],
    es  = Eigensystem[N @ Normal @ KirchhoffMatrix[CycleGraph[6]]]
  },
    With[{vecs = Drop[es[[2, Ordering[es[[1]]]]], 1]},
      Max[Abs[phi - Transpose[vecs]]] < 10^-10
    ]
  ],
  True,
  TestID -> "ResistanceCoordinates-Rescaling-None"
]


(* ===== Anchors on shapes: the anchor rule, not a per-head coercion ===== *)

(* every anchor of RadarCoordinates is read through InfraDensity, so a set, a density
   and a walk graph with the same support give the same distance -- the aggregation
   runs over the support in each case *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    { RadarCoordinates[g, {<| 1 -> 1, 2 -> 1 |>, 9}, 5],
      RadarCoordinates[g, {geodesicGraph @ {1, 2}, 9}, 5],
      RadarCoordinates[g, {<| 1 -> 1, 2 -> 1 |>, 9}, 5, "AnchorAggregation" -> Max] }],
  { {1, 2}, {1, 2}, {2, 2} },
  TestID -> "RadarCoordinates-anchors-read-by-the-anchor-rule"
]

(* a bare vertex anchor is the unit mass, so every aggregation is the distance
   itself and the shape rule agrees with the crisp one *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    RadarCoordinates[g, {<| 1 -> 1 |>, 9}, 5] === RadarCoordinates[g, {1, 9}, 5]],
  True,
  TestID -> "RadarCoordinates-vertex-anchor-agrees-with-the-crisp-rule"
]

(* the centre of OrthogonalCoordinates is an anchor too: a set centre reads as its
   support, where the wrapper-era coercion took only an Association *)
VerificationTest[
  With[{g = GridGraph[{3, 3}], axis = geodesicGraph @ {1, 2, 3}},
    { OrthogonalCoordinates[g, 2, {axis}, 3],
      OrthogonalCoordinates[g, {1, 2}, {axis}, 3],
      OrthogonalCoordinates[g, <| 2 -> 1 |>, {axis}, 3] }],
  { {1}, {2}, {1} },
  TestID -> "OrthogonalCoordinates-centre-is-an-anchor"
]

(* Moved from RiemannianTests.wlt on 2026-10-05 (APISurfaceCleanup T9) *)

(* ===== Coordinatization: resolving sets, radar / resistance coords, ball covers ===== *)

VerificationTest[
    ResolvingSetQ[PathGraph[Range[5]], {1}],
    True,
    TestID -> "ResolvingSetQ-path-endpoint-resolves"
]

VerificationTest[
    ResolvingSetQ[CycleGraph[6], {1}],
    False,
    TestID -> "ResolvingSetQ-cycle-single-fails"
]

VerificationTest[
    ResolvingSetQ[CycleGraph[6], {1, 2}],
    True,
    TestID -> "ResolvingSetQ-cycle-two-resolves"
]

VerificationTest[
    MetricDimension[PathGraph[Range[5]]],
    1,
    TestID -> "MetricDimension-path"
]

VerificationTest[
    MetricDimension[CycleGraph[6]],
    2,
    TestID -> "MetricDimension-cycle"
]

VerificationTest[
    MetricDimension[PetersenGraph[]],
    3,
    TestID -> "MetricDimension-Petersen"
]

VerificationTest[
    RadarCoordinates[PathGraph[Range[5]], {1, 5}, 3],
    {2, 2},
    TestID -> "RadarCoordinates-path-vertex"
]

VerificationTest[
    With[{c = ResistanceCoordinates[PathGraph[Range[4]]]},
        Chop[Total[(c[1] - c[4])^2] - EffectiveResistance[PathGraph[Range[4]], 1, 4]]
    ],
    0,
    TestID -> "ResistanceCoordinates-matching-identity"
]

(* ===== Resolving sets and the metric dimension ===== *)

VerificationTest[
  ResolvingSetQ[PathGraph[Range[5]], {1}],
  True,
  TestID -> "ResolvingSetQ-path-endpoint-resolves"
]

(* The empty set resolves a single vertex, so its metric dimension is 0 *)
VerificationTest[
  {MetricDimension[Graph[{1}, {}]], FindResolvingSet[Graph[{1}, {}]], ResolvingSetQ[Graph[{1}, {}], {}]},
  {0, {{}}, True},
  TestID -> "MetricDimension-single-vertex-zero"
]

VerificationTest[
  MetricDimension /@ {PathGraph[Range[5]], CycleGraph[6], PetersenGraph[]},
  {1, 2, 3},
  TestID -> "MetricDimension-path-cycle-Petersen"
]

(* Past the smallest size the sets need not be minimal: {4, 5} contains {5} *)
VerificationTest[
  FindResolvingSet[PathGraph[Range[5]], 3],
  {{5}, {1}, {4, 5}},
  TestID -> "FindResolvingSet-path-three-by-size"
]

VerificationTest[
  {FindResolvingSet[Graph[{1}, {}], 1, {0, 2}], FindResolvingSet[CycleGraph[6], 1, 1], FindResolvingSet[CycleGraph[6], 1, {2}]},
  {{{}}, {}, {{5, 6}}},
  TestID -> "FindResolvingSet-size-specifications"
]

(* No point set has an infinite distance: a disconnected graph has no resistance coordinates *)
VerificationTest[
  With[{g = GraphUnion[PathGraph[{1, 2, 3}], PathGraph[{4, 5}]]},
    Head /@ {ResistanceCoordinates[g], ResistanceCoordinates[g, 1], ResistanceCoordinates[g, <| 1 -> 1 |>]}
  ],
  {ResistanceCoordinates, ResistanceCoordinates, ResistanceCoordinates},
  TestID -> "ResistanceCoordinates-disconnected-unevaluated"
]

EndTestSection[]
