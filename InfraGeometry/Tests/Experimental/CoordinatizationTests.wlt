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

(* every anchor of RadarCoordinates is read through InfraMeasurement, so a set, a density
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
