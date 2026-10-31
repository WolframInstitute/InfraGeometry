BeginTestSection["UniformLengthDiscretization"]

(* Moved from RiemannianTests.wlt on 2026-10-05, when the tests were split by kernel file (APISurfaceCleanup T9) *)

(* ===== Unit-length discretization & embedding ===== *)

ulEdgeLengths[g_] := With[{p = GraphEmbedding[g]},
    EuclideanDistance[p[[#[[1]]]], p[[#[[2]]]]] & /@ (List @@@ EdgeList[g])
]

VerificationTest[
    With[{e = UniformLengthEmbedding[CycleGraph[6]]}, MatrixQ[e] && Dimensions[e] === {6, 3}],
    True,
    TestID -> "UniformLengthEmbedding-matrix-shape"
]

VerificationTest[
    With[{g = CycleGraph[6], e = UniformLengthEmbedding[CycleGraph[6]]},
        Max @ Abs[(EuclideanDistance[e[[#[[1]]]], e[[#[[2]]]]] & /@ (List @@@ EdgeList[g])) - 1] < 0.01
    ],
    True,
    TestID -> "UniformLengthEmbedding-unit-edges"
]

VerificationTest[
    Dimensions @ UniformLengthEmbedding[GridGraph[{3, 3}], "Dimension" -> 2],
    {9, 2},
    TestID -> "UniformLengthEmbedding-dimension-option"
]

(* the graph is called by its edge length h; the number of spheres is the region's measure
   C over the area or volume one sphere takes: 2 C / (Sqrt[3] h^2) on a surface, the hexagonal
   packing, and C (1.12 / h)^3 in a solid *)
VerificationTest[
    {SeedRandom[1]; VertexCount @ UniformLengthGraph[Rectangle[], 0.1], SeedRandom[1]; VertexCount @ UniformLengthGraph[Cuboid[], 0.2]},
    {115, 176},
    TestID -> "UniformLengthGraph-count-from-length"
]

VerificationTest[
    Keys @ Options[UniformLengthGraph],
    {"ContactTolerance", "InitialPoints", "KeepCoordinates", MaxIterations, Tolerance},
    TestID -> "UniformLengthGraph-options"
]

(* a curve is placed at equal arclength, not packed: one cycle on a closed curve, every edge h *)
VerificationTest[
    With[{h = 2 Pi / 50},
      {g = UniformLengthGraph[Circle[], h, "KeepCoordinates" -> True]},
      {IsomorphicGraphQ[g, CycleGraph[50]], Max @ Abs[ulEdgeLengths[g] / h - 1] < 0.001}],
    {True, True},
    TestID -> "UniformLengthGraph-circle-cycle"
]

(* an open curve gives one path, C / h + 1 centres; the corner of this line falls on a centre *)
VerificationTest[
    With[{line = Line[{{0, 0}, {1, 0.5}, {2, 0}}]},
      {h = RegionMeasure[line] / 20},
      {g = UniformLengthGraph[line, h, "KeepCoordinates" -> True]},
      {IsomorphicGraphQ[g, PathGraph[Range[21]]], Max @ Abs[ulEdgeLengths[g] / h - 1] < 0.001}],
    {True, True},
    TestID -> "UniformLengthGraph-line-path"
]

VerificationTest[
    SeedRandom[1];
    With[{g = UniformLengthGraph[Sphere[], 0.38, "KeepCoordinates" -> True]},
      Max @ Abs[Norm /@ GraphEmbedding[g] - 1] < 10^-6],
    True,
    TestID -> "UniformLengthGraph-sphere-on-surface"
]

(* the zones along the long axis, |x| / 5 below 0.25, 0.25 to 0.6, 0.6 to 0.85 and above 0.85:
   the mean edge in each is within 2 % of the mean edge, the tips as dense as the waist *)
VerificationTest[
    SeedRandom[2];
    With[{g = UniformLengthGraph[RegionBoundary @ BoundaryDiscretizeRegion @ Ellipsoid[{0, 0, 0}, {5, 1, 1}], 0.76, "KeepCoordinates" -> True]},
      {edges = List @@@ EdgeList[g], p = GraphEmbedding[g]},
      {lengths = EuclideanDistance @@ p[[#]] & /@ edges,
       zones = With[{x = Abs[Mean[p[[#]]][[1]]] / 5}, Which[x < 0.25, 1, x < 0.6, 2, x < 0.85, 3, True, 4]] & /@ edges},
      Max @ Abs[Table[Mean @ Pick[lengths, zones, k], {k, 4}] / Mean[lengths] - 1] < 0.02],
    True,
    TestID -> "UniformLengthGraph-prolate-ellipsoid-zones"
]

(* the promise: an edge is a pair of centres within the contact tolerance of h *)
VerificationTest[
    SeedRandom[1];
    With[{h = 0.15, g = UniformLengthGraph[Disk[], 0.15, "KeepCoordinates" -> True, "ContactTolerance" -> 0.1]},
      {lengths = ulEdgeLengths[g]},
      {EdgeCount[g] > 0, Max @ Abs[lengths / h - 1] <= 0.1}],
    {True, True},
    TestID -> "UniformLengthGraph-disk-edges-within-tolerance"
]

VerificationTest[
    With[{points = (SeedRandom[1]; RandomPoint[Disk[], 40])},
      {g = UniformLengthGraph[Disk[], 0.3, "InitialPoints" -> points]},
      {VertexCount[g], g === UniformLengthGraph[Disk[], 0.3, "InitialPoints" -> points]}],
    {40, True},
    TestID -> "UniformLengthGraph-initial-points-fix-the-packing"
]

VerificationTest[
    SeedRandom[1];
    With[{g = UniformLengthGraph[Sphere[], 0.6]},
        GraphQ[g] && VertexCount[g] == 40 && Mean[N @ VertexDegree[g]] >= 4
    ],
    True,
    TestID -> "UniformLengthGraph-sphere-jammed"
]

VerificationTest[
    SeedRandom[1];
    With[{lens = ulEdgeLengths @ UniformLengthGraph[Sphere[], 0.6, "KeepCoordinates" -> True]}, Max[lens] / Min[lens] < 1.8],
    True,
    TestID -> "UniformLengthGraph-sphere-edges-near-uniform"
]

(* no call prints a message: a curve in space, a surface and a solid *)
VerificationTest[
    SeedRandom[1];
    GraphQ /@ {
      UniformLengthGraph[ParametricRegion[{Cos[t], Sin[t], t / 5}, {{t, 0, 4 Pi}}], 0.3],
      UniformLengthGraph[Sphere[], 0.5, MaxIterations -> 20, Tolerance -> 10^-3],
      UniformLengthGraph[Ball[], 0.5]},
    {True, True, True},
    TestID -> "UniformLengthGraph-no-messages"
]

(* a region smaller than one sphere holds one sphere *)
VerificationTest[
    SeedRandom[1];
    VertexCount /@ {UniformLengthGraph[Circle[], 10], UniformLengthGraph[Disk[], 10], UniformLengthGraph[Ball[], 10]},
    {1, 1, 1},
    TestID -> "UniformLengthGraph-one-sphere-at-least"
]

EndTestSection[]
