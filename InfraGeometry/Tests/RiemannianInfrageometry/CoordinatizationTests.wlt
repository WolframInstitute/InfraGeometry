BeginTestSection["RiemannianCoordinatization"]

geodesicGraph = WolframInstitute`InfraGeometry`PackageScope`geodesicGraph;
walkSequence = WolframInstitute`InfraGeometry`PackageScope`walkSequence;

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

(* the default tie-breaker is Median: vertex 4 ties at positions 0 and 2 *)
VerificationTest[
  With[{g = CycleGraph[4], axes = {{1, 2, 3}}},
    OrthogonalCoordinates[g, 1, axes, 4] === OrthogonalCoordinates[g, 1, axes, 4, "SelectCoordinate" -> Median]],
  True,
  TestID -> "OrthogonalCoordinates-default-tie-breaker-Median"
]

(* the tie rule on CycleGraph[4]: the antipode 3 ties at -1 and 1, so Median puts it at 0 with the centre; All shows the tie *)
VerificationTest[
  With[{g = CycleGraph[4], c = 1},
    With[{axes = FindInfraOrthogonalAxes[g, c, 1]},
      {axes, OrthogonalCoordinates[g, c, axes], OrthogonalCoordinates[g, c, axes, "SelectCoordinate" -> All]}]],
  {{{2, 1, 4}}, <|1 -> {0}, 2 -> {-1}, 3 -> {0}, 4 -> {1}|>, <|1 -> {{0}}, 2 -> {{-1}}, 3 -> {{-1, 1}}, 4 -> {{1}}|>},
  TestID -> "OrthogonalCoordinates-CycleGraph4-antipode"
]

(* a tie straddling the centre gives a half-integer: vertex 4 is nearest to 3 and to the centre 1 on the walk {3, 1, 2} *)
VerificationTest[
  With[{g = CycleGraph[4], axes = {{3, 1, 2}}},
    OrthogonalCoordinates[g, 1, axes, 4]],
  {-1/2},
  TestID -> "OrthogonalCoordinates-Median-half-integer"
]

(* on the straight cross of the grid the coordinates are integers, the grid's own *)
VerificationTest[
  With[{g = GridGraph[{5, 5}], c = 13},
    With[{coords = OrthogonalCoordinates[g, c, FindInfraOrthogonalAxes[g, c, 2]]},
      {AllTrue[Catenate @ Values @ coords, IntegerQ], Sort @ Values @ coords}]],
  {True, Tuples[Range[-2, 2], 2]},
  TestID -> "OrthogonalCoordinates-straight-cross-integer-grid"
]

(* the walks are vertex lists; a walk graph is read as its vertex sequence *)
VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    OrthogonalCoordinates[g, 6, {geodesicGraph @ {1, 2, 3, 4}, {1, 5, 9, 13}}] === OrthogonalCoordinates[g, 6, {{1, 2, 3, 4}, {1, 5, 9, 13}}]],
  True,
  TestID -> "OrthogonalCoordinates-walk-graph-reads-as-list"
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

(* ===== the fibration over the coordinate grid ===== *)

(* the 9 x 9 grid over its full straight cross: the projection is a bijection onto {-4, ..., 4}^2 and the base is the grid itself *)
VerificationTest[
  With[{g = GridGraph[{9, 9}], c = 41},
    With[{fib = InfraFibration[g, OrthogonalCoordinates[g, c, FindInfraOrthogonalAxes[g, c, 4]]]},
      {Sort @ VertexList @ InfraBaseGraph @ fib, IsomorphicGraphQ[InfraBaseGraph @ fib, g], Union[VertexCount /@ Values @ InfraFibers @ fib],
        InfraFibrationQ @ fib}]],
  {Tuples[Range[-4, 4], 2], True, {1}, True},
  TestID -> "OrthogonalCoordinates-fibration-9x9-full-cross"
]

(* over the cross of half-length 2 a vertex beyond the window projects to the nearest end: the base is the 5 x 5 grid, the fibres are 3 x 3
   blocks over the corners, strips of 3 over the rest of the boundary and single vertices inside; edges do not lift at the corner blocks *)
VerificationTest[
  With[{g = GridGraph[{9, 9}], c = 41},
    With[{fib = InfraFibration[g, OrthogonalCoordinates[g, c, FindInfraOrthogonalAxes[g, c, 2]]]},
      {Sort @ VertexList @ InfraBaseGraph @ fib, IsomorphicGraphQ[InfraBaseGraph @ fib, GridGraph[{5, 5}]],
        KeySort @ Counts[VertexCount /@ Values @ InfraFibers @ fib], IsomorphicGraphQ[InfraFiber[fib, {2, 2}], GridGraph[{3, 3}]],
        InfraFibrationQ @ fib}]],
  {Tuples[Range[-2, 2], 2], True, <|1 -> 9, 3 -> 12, 9 -> 4|>, True, False},
  TestID -> "OrthogonalCoordinates-fibration-9x9-short-cross"
]

VerificationTest[
  With[{g = GridGraph[{5, 5, 5}], c = 63},
    With[{fib = InfraFibration[g, OrthogonalCoordinates[g, c, FindInfraOrthogonalAxes[g, c, 2]]]},
      {Sort @ VertexList @ InfraBaseGraph @ fib, IsomorphicGraphQ[InfraBaseGraph @ fib, g], InfraFibrationQ @ fib}]],
  {Tuples[Range[-2, 2], 3], True, True},
  TestID -> "OrthogonalCoordinates-fibration-5x5x5-cross"
]

(* the straight frame of 4 rays reads each axis twice, as its positive and its negative part: c at 0, every vertex its own point *)
VerificationTest[
  With[{g = GridGraph[{5, 5}], c = 13},
    With[{coords = OrthogonalCoordinates[g, c, FindInfraOrthogonalRays[g, c, 2]]},
      {coords[c], DuplicateFreeQ @ Values @ coords, AllTrue[Catenate @ Values @ coords, NonNegative],
        IsomorphicGraphQ[InfraBaseGraph @ InfraFibration[g, coords], g]}]],
  {{0, 0, 0, 0}, True, True, True},
  TestID -> "OrthogonalCoordinates-fibration-rays"
]

(* the strict perpendicularity keeps every found set well-conditioned: a vertex of one walk reads 0 on every other walk, with no tie *)
VerificationTest[
  With[{g = GridGraph[{9, 9}], c = 41},
    AllTrue[FindInfraOrthogonalAxes[g, c, 2, All],
      axes |-> With[{coords = OrthogonalCoordinates[g, c, axes, "SelectCoordinate" -> All]},
        AllTrue[Range @ Length @ axes, i |-> AllTrue[axes[[i]],
          v |-> coords[v] === ReplacePart[ConstantArray[{0}, Length @ axes],
            i -> {First @ FirstPosition[axes[[i]], v] - First @ FirstPosition[axes[[i]], c]}]]]]]],
  True,
  TestID -> "OrthogonalCoordinates-found-sets-well-conditioned"
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

(* "Hausdorff" scores a candidate by its least Hausdorff distance to one chosen axis, so on the 5 x 5 grid the axes are a few
   diametral geodesics, pairwise at least half a diameter apart, not all 140 of them *)
VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] }, { axes = FindInfraSpanningAxes[ g, All, "AxisDistance" -> "Hausdorff" ] },
    { dm = GraphDistanceMatrix @ g },
    { hausdorff = { a, b } |-> Max[ Max[ Min /@ dm[[ a, b ]] ], Max[ Min /@ dm[[ b, a ]] ] ] },
    { Length @ axes < 10, AllTrue[ Subsets[ axes, { 2 } ], hausdorff @@ # >= 4 & ] } ],
  { True, True },
  TestID -> "FindInfraSpanningAxes-Hausdorff-against-each-axis"
]

VerificationTest[
  TimeConstrained[ Length @ FindInfraSpanningAxes[ GridGraph[ { 4, 6 } ], 2, "MinLength" -> 6, "AxisDistance" -> "Hausdorff" ], 10 ],
  2,
  TestID -> "FindInfraSpanningAxes-stops-at-the-count"
]

VerificationTest[
  MatchQ[ FindInfraSpanningAxes[ GridGraph[ { 4, 4 } ], All, "AxisDistance" -> "Frechet" ], _FindInfraSpanningAxes ],
  True,
  TestID -> "FindInfraSpanningAxes-unknown-AxisDistance-unevaluated"
]

(* ===== FindInfraOrthogonalAxes with an InfraPerpendicularQ method ===== *)

(* perpendicular lines meet in one vertex, so the "Projection" axes meet only at the centre *)
VerificationTest[
  With[ { g = GridGraph[ { 7, 7 } ] }, { axes = FindInfraOrthogonalAxes[ g, 25, 2, Properties -> "Projection" ] },
    { Length @ axes, AllTrue[ Subsets[ axes, { 2 } ], Intersection @@ # === { 25 } & ] } ],
  { 2, True },
  TestID -> "FindInfraOrthogonalAxes-Projection-axes-meet-at-the-centre"
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


(* the centre of OrthogonalCoordinates is an anchor too: a set centre reads as its
   support, projected onto the walk like any vertex; {1, 2} ties at positions 0 and 1, so its Median is 1/2 *)
VerificationTest[
  With[{g = GridGraph[{3, 3}], axis = geodesicGraph @ {1, 2, 3}},
    { OrthogonalCoordinates[g, 2, {axis}, 3],
      OrthogonalCoordinates[g, {1, 2}, {axis}, 3],
      OrthogonalCoordinates[g, <| 2 -> 1 |>, {axis}, 3] }],
  { {1}, {3/2}, {1} },
  TestID -> "OrthogonalCoordinates-centre-is-an-anchor"
]

EndTestSection[]
