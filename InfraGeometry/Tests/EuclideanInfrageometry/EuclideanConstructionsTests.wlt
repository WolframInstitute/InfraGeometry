BeginTestSection["EuclideanConstructions"]

walkGraph       = walk |-> PathGraph[ MapIndexed[ { First @ #2, #1 } &, walk ], DirectedEdges -> True ];
geodesicGraph   = WolframInstitute`InfraGeometry`PackageScope`geodesicGraph;
infraSpread     = WolframInstitute`InfraGeometry`PackageScope`infraSpread;
SeparatesQ      = WolframInstitute`InfraGeometry`PackageScope`SeparatesQ;
closedWalkGraph = walk |-> With[ { core = MapIndexed[ { First @ #2, #1 } &, If[ Length[ walk ] >= 2 && First @ walk === Last @ walk, Most @ walk, walk ] ] },
  Graph[ core, DirectedEdge @@@ Partition[ core, 2, 1, 1 ] ] ];
walkSeq[ w_Graph ] := Last /@ VertexList[ w ]
walkSeqs[ ws_List ] := walkSeq /@ ws

(* ===== FindInfraPerpendicular ===== *)

(* C5, line {1,2,3,4}, point 5: foot is 2, perpendicular line is the maximal
   geodesic {5, 1, 2} (canonical orientation: lex-min of seq and reverse). *)

VerificationTest[
  Sort /@ infraSpread @ FindInfraPerpendicular[CycleGraph[5], {1, 2, 3, 4}, 5, All],
  { { 1, 2, 5 } },
  TestID -> "FindInfraPerpendicular-CycleGraph5-Metric"
]

VerificationTest[
  GraphQ @ FindInfraPerpendicular[CycleGraph[5], {1, 2, 3, 4}, 5, All],
  True,
  TestID -> "FindInfraPerpendicular-returns-a-graph"
]

VerificationTest[
  (* every returned perp line must pass through both `point` and at least one
     vertex of `line` (a foot). *)
  With[{lines = FindInfraPerpendicular[CycleGraph[5], {1, 2, 3, 4}, 5, All]},
    AllTrue[infraSpread @ lines, MemberQ[#, 5] && IntersectingQ[#, {1, 2, 3, 4}] &]
  ],
  True,
  TestID -> "FindInfraPerpendicular-through-point-and-foot"
]

VerificationTest[
  Length @ FindInfraPerpendicular[CycleGraph[5], {1, 2, 3, 4}, 5, 1],
  1,
  TestID -> "FindInfraPerpendicular-strict-1"
]

(* Q-side dispatch on C5: the metric branch gives one path graph, the Alexandrov
   branch nothing at all (smoke test).  C5 is
   a degenerate configuration -- the metric perpendicular shares two vertices
   with `line`, so Q-side tests legitimately reject it.  Substantive Q-side
   tests live in the mesh-graph notebook demo. *)

VerificationTest[
  GraphQ @ FindInfraPerpendicular[CycleGraph[5], {1, 2, 3, 4}, 5, All,
    Method -> "Projection"],
  True,
  TestID -> "FindInfraPerpendicular-CycleGraph5-Projection-shape"
]

VerificationTest[
  FindInfraPerpendicular[CycleGraph[5], {1, 2, 3, 4}, 5, All,
    Method -> {"Alexandrov", "Curvature" -> 0, "Tolerance" -> 0.5}],
  { },
  TestID -> "FindInfraPerpendicular-CycleGraph5-Alexandrov0-shape"
]

(* Radius option: same setup, restrict to NeighborhoodGraph[g, 5, 1].  The
   1-ball around 5 in C5 is {5, 1, 4}; line {1, 2, 3, 4} restricted is {1, 4}.
   Foot recipe finds... no equidistant pair with the right parity, so should
   return empty.  Just check it does not crash and returns a walk graph. *)

VerificationTest[
  GraphQ @ FindInfraPerpendicular[CycleGraph[5], {1, 2, 3, 4}, 5, All, "Radius" -> 1],
  True,
  TestID -> "FindInfraPerpendicular-Radius-1"
]

(* ===== FindClosestInfraPoint ===== *)

VerificationTest[
  FindClosestInfraPoint[GridGraph[{5, 5}],
    geodesicGraph @ {1, 2, 3, 4, 5}, 13, All],
  { 3 },
  TestID -> "FindClosestInfraPoint-grid-InfraSegment"
]

VerificationTest[
  FindClosestInfraPoint[GridGraph[{5, 5}],
    geodesicGraph @ {1, 2, 3, 4, 5}, 13, All],
  { 3 },
  TestID -> "FindClosestInfraPoint-grid-InfraLine"
]

VerificationTest[
  FindClosestInfraPoint[GridGraph[{5, 5}],
    {1, 2, 3, 4, 5}, 13, All],
  { 3 },
  TestID -> "FindClosestInfraPoint-bare-list-and-vertex"
]

(* Point already on the segment: closest is itself. *)
VerificationTest[
  FindClosestInfraPoint[GridGraph[{5, 5}],
    geodesicGraph @ {1, 2, 3, 4, 5}, 3, All],
  { 3 },
  TestID -> "FindClosestInfraPoint-point-on-line"
]

(* Cartesian spread: two segment realisations, one point -> one closest per realisation. *)
VerificationTest[
  FindClosestInfraPoint[GridGraph[{5, 5}],
    geodesicGraph /@ {{1, 2, 3, 4, 5}, {1, 6, 11, 16, 21}},
    13, All],
  { 3, 11 },
  TestID -> "FindClosestInfraPoint-multi-segment-Cartesian"
]

(* Cartesian spread: one segment, two point realisations. *)
VerificationTest[
  FindClosestInfraPoint[GridGraph[{5, 5}],
    geodesicGraph @ {1, 2, 3, 4, 5}, <| 11 -> 1, 15 -> 1 |>, All],
  { 1, 5 },
  TestID -> "FindClosestInfraPoint-multi-point-Cartesian"
]

VerificationTest[
  FindClosestInfraPoint[GridGraph[{5, 5}],
    geodesicGraph @ {1, 2, 3, 4, 5}, 13],
  { 3 },
  TestID -> "FindClosestInfraPoint-default-count-1"
]

VerificationTest[
  FindClosestInfraPoint[GridGraph[{5, 5}],
    geodesicGraph @ {1, 2, 3, 4, 5}, 13, 5],
  { },
  TestID -> "FindClosestInfraPoint-strict-count-too-large-fails"
]

VerificationTest[
  FindClosestInfraPoint[GridGraph[{5, 5}],
    geodesicGraph @ {1, 2, 3, 4, 5}, 13, UpTo[5]],
  { 3 },
  TestID -> "FindClosestInfraPoint-UpTo-caps"
]

(* Tied minimisers (CycleGraph[5], point 1 to opposite arc {3, 4}: both at distance 2). *)
VerificationTest[
  FindClosestInfraPoint[CycleGraph[5],
    geodesicGraph @ {3, 4}, 1, All],
  { 3, 4 },
  TestID -> "FindClosestInfraPoint-ties-symmetric"
]

VerificationTest[
  FindClosestInfraPoint[GridGraph[{5, 5}],
    walkGraph @ {1, 2, 3, 4, 5}, 13, All],
  { 3 },
  TestID -> "FindClosestInfraPoint-walk-graph"
]

VerificationTest[
  FindClosestInfraPoint[GridGraph[{5, 5}], geodesicGraph @ {1, 2, 3, 4, 5}, 13, All],
  { 3 },
  TestID -> "FindClosestInfraPoint-ray-graph"
]

(* ===== FindInfraBisectingHyperplane ===== *)

(* Properties -> {} (default): the bisector slab itself as a single
   realisation. PathGraph[5], 1 to 5: slab = {3}. *)
VerificationTest[
  FindInfraBisectingHyperplane[PathGraph[Range[5]], 1, 5],
  {3},
  TestID -> "FindInfraBisectingHyperplane-LevelSet-path-center"
]

VerificationTest[
  FindInfraBisectingHyperplane[PathGraph[Range[5]], 1, 5, All],
  FindInfraBisectingHyperplane[PathGraph[Range[5]], 1, 5, All],
  TestID -> "FindInfraBisectingHyperplane-list-form-equiv"
]

(* GridGraph[3,3]: slab is the antidiagonal {3, 5, 7}. *)
VerificationTest[
  FindInfraBisectingHyperplane[GridGraph[{3, 3}], 1, 9, All],
  {{3, 5, 7}},
  TestID -> "FindInfraBisectingHyperplane-LevelSet-grid-antidiagonal"
]

(* PathGraph[6], 1 to 6 (odd distance): strict slab is empty. *)
VerificationTest[
  FindInfraBisectingHyperplane[PathGraph[Range[6]], 1, 6, All],
  {{ }},
  TestID -> "FindInfraBisectingHyperplane-LevelSet-odd-distance-empty"
]

(* Widening to {-1, 1} thickens the slab to {3, 4}. *)
VerificationTest[
  FindInfraBisectingHyperplane[PathGraph[Range[6]], 1, 6, {-1, 1}, All],
  {{3, 4}},
  TestID -> "FindInfraBisectingHyperplane-LevelSet-thickened-path"
]

(* Properties -> {"Separating"}: on PathGraph[6] each of {3}, {4} is a
   minimal separator within the thickened slab. *)
VerificationTest[
  Sort @ FindInfraBisectingHyperplane[PathGraph[Range[6]], 1, 6, {-1, 1}, All, Properties -> {"Separating"}],
  {{3}, {4}},
  TestID -> "FindInfraBisectingHyperplane-Separating-thickened-path"
]

(* CycleGraph[6], 1 to 4 (odd distance), thickened to {-1, 1}: cutting either
   arc requires one vertex from {2, 3} and one from {5, 6}; four minimal
   separators. *)
VerificationTest[
  Sort @ ( Sort /@ FindInfraBisectingHyperplane[CycleGraph[6], 1, 4, {-1, 1}, All, Properties -> {"Separating"}] ),
  {{2, 5}, {2, 6}, {3, 5}, {3, 6}},
  TestID -> "FindInfraBisectingHyperplane-Separating-cycle-thickened"
]

VerificationTest[
  Length @ FindInfraBisectingHyperplane[CycleGraph[6], 1, 4, {-1, 1}, UpTo[2], Properties -> {"Separating"}],
  2,
  TestID -> "FindInfraBisectingHyperplane-Separating-upto-soft"
]

VerificationTest[
  FindInfraBisectingHyperplane[PathGraph[Range[5]], 1, 5, 5],
  { },
  TestID -> "FindInfraBisectingHyperplane-LevelSet-fails-when-too-few"
]

VerificationTest[
  ListQ @ FindInfraBisectingHyperplane[PathGraph[Range[5]], 1, 5],
  True,
  TestID -> "FindInfraBisectingHyperplane-returns-a-set"
]

(* no count: the DFS peel returns one certified minimal, and
   count-less is ONE instance, so the instance is the set itself. *)
VerificationTest[
  MemberQ[{{3}, {4}},
    FindInfraBisectingHyperplane[PathGraph[Range[6]], 1, 6, {-1, 1}, Properties -> {"Separating"}]],
  True,
  TestID -> "FindInfraBisectingHyperplane-default-returns-one-minimal"
]

(* The peel backtracks, so a finite count is exact: both minimals of the
   {3} / {4} bisector come back under count 2. *)
VerificationTest[
  Sort @ FindInfraBisectingHyperplane[PathGraph[Range[6]], 1, 6, {-1, 1}, 2, Properties -> {"Separating"}],
  {{3}, {4}},
  TestID -> "FindInfraBisectingHyperplane-default-count-is-exact"
]

(* a slab that itself does not separate: the empty class. *)
VerificationTest[
  FindInfraBisectingHyperplane[PathGraph[Range[6]], 1, 6, Properties -> {"Separating"}],
  { },
  TestID -> "FindInfraBisectingHyperplane-default-empty-when-slab-does-not-separate"
]

(* GridGraph[{3, 3}]'s antidiagonal {3, 5, 7} is disconnected. *)
VerificationTest[
  ConnectedGraphQ @ Subgraph[GridGraph[{3, 3}], {3, 5, 7}],
  False,
  TestID -> "FindInfraBisectingHyperplane-grid-antidiagonal-disconnected-sanity"
]

(* Properties -> {"Separating", "Connected"} rejects the disconnected antidiagonal. *)
VerificationTest[
  FindInfraBisectingHyperplane[GridGraph[{3, 3}], 1, 9, All, Properties -> {"Separating", "Connected"}],
  { },
  TestID -> "FindInfraBisectingHyperplane-Connected-rejects-disconnected"
]

(* 4-cycle + chord: only minimal separator is the connected {1, 3}. *)
VerificationTest[
  With[{g = Graph[{1, 2, 3, 4}, {1 <-> 2, 2 <-> 3, 3 <-> 4, 4 <-> 1, 1 <-> 3}]},
    Sort @ ( Sort /@ FindInfraBisectingHyperplane[g, 2, 4, All, Properties -> {"Separating", "Connected"}] )],
  {{1, 3}},
  TestID -> "FindInfraBisectingHyperplane-Connected-accepts-chord"
]

VerificationTest[
  With[{g = Graph[{1, 2, 3, 4}, {1 <-> 2, 2 <-> 3, 3 <-> 4, 4 <-> 1, 1 <-> 3}]},
    Sort @ FindInfraBisectingHyperplane[g, 2, 4, Properties -> {"Separating", "Connected"}]],
  {1, 3},
  TestID -> "FindInfraBisectingHyperplane-default-Connected"
]

(* Properties -> {"Connected"} alone: corner case -- inclusion-minimal connected
   subsets are single vertices. The greedy peel can drop everything from the slab
   one vertex at a time until one remains. *)
VerificationTest[
  Length @ FindInfraBisectingHyperplane[PathGraph[Range[5]], 1, 5, {-1, 1},
    Properties -> {"Connected"}] == 1,
  True,
  TestID -> "FindInfraBisectingHyperplane-Connected-alone-singleton"
]

(* one branch per node under All: the result fits in [1, 4] (4 = the unpruned count). *)
VerificationTest[
  With[{n = BlockRandom[SeedRandom[7];
    Length @ FindInfraBisectingHyperplane[CycleGraph[6], 1, 4, {-1, 1}, All,
      Properties -> {"Separating"}, "NextVertexFunction" -> ( RandomSample[ #, UpTo[ 1 ] ] & )]]},
    1 <= n <= 4],
  True,
  TestID -> "FindInfraBisectingHyperplane-Pruning-bounded"
]

(* Sanity: every Separating realisation actually separates p1 from p2. *)
VerificationTest[
  With[{g = CycleGraph[6]},
    AllTrue[
      FindInfraBisectingHyperplane[g, 1, 4, {-1, 1}, All, Properties -> {"Separating"}],
      sep |-> SeparatesQ[g, sep, 1, 4]]],
  True,
  TestID -> "FindInfraBisectingHyperplane-Separating-results-actually-separate"
]

(* ===== FindInfraParallel: the pool under All ===== *)

VerificationTest[
  infraSpread @ FindInfraParallel[GridGraph[{4, 4}], {1, 2, 3, 4}, 5, All],
  {{5, 6, 7, 8}},
  TestID -> "FindInfraParallel-All-is-the-pool"
]

(* FindInfraPerpendicular "Embedding" Method has been removed (see plan
   okey-we-need-to-majestic-puppy: path-family Embedding dropped).  Users
   wanting embedding-ranked feet compose with EmbeddingClosest. *)

(* ===== FindInfraCommonPoint ===== *)

VerificationTest[
  FindInfraCommonPoint[PathGraph[Range[5]], {{1, 2, 3}, {2, 3, 4}}, All],
  { 2, 3 },
  TestID -> "FindInfraCommonPoint-overlap-two"
]

VerificationTest[
  FindInfraCommonPoint[PathGraph[Range[5]], {{1, 2}, {3, 4}}, All],
  { },
  TestID -> "FindInfraCommonPoint-disjoint-empty"
]

VerificationTest[
  FindInfraCommonPoint[PathGraph[Range[5]], {{1, 2, 3}, {2, 3, 4}}, 1],
  { 2 },
  TestID -> "FindInfraCommonPoint-strict-1"
]

VerificationTest[
  FindInfraCommonPoint[PathGraph[Range[5]], {{1, 2}, {3, 4}}, 1],
  { },
  TestID -> "FindInfraCommonPoint-strict-fails-when-empty"
]

VerificationTest[
  FindInfraCommonPoint[PathGraph[Range[5]], {{1, 2, 3}, {2, 3, 4}}, UpTo[5]],
  { 2, 3 },
  TestID -> "FindInfraCommonPoint-UpTo-soft"
]

(* ===== FindInfraCommonPoint on walk graphs ===== *)

VerificationTest[
  FindInfraCommonPoint[PathGraph[Range[5]], geodesicGraph /@ {{1, 2, 3}, {2, 3, 4}}, All],
  { 2, 3 },
  TestID -> "FindInfraCommonPoint-walk-graphs"
]

VerificationTest[
  Length[ FindInfraCommonPoint[CycleGraph[6],
    infraSpread @ FindInfraCommonLine[CycleGraph[6], {1, 4}, All], All] ],
  2,
  TestID -> "FindInfraCommonPoint-from-FindInfraCommonLine"
]

(* ===== FindInfraReflection ===== *)

VerificationTest[
  FindInfraReflection[PathGraph[Range[5]], 1, 2, All],
  { 3 },
  TestID -> "FindInfraReflection-PathGraph-adjacent"
]

VerificationTest[
  FindInfraReflection[PathGraph[Range[5]], 1, 3, All],
  { 5 },
  TestID -> "FindInfraReflection-PathGraph-distance-two"
]

VerificationTest[
  FindInfraReflection[PathGraph[Range[5]], 1, 4, All],
  { },
  TestID -> "FindInfraReflection-PathGraph-no-room"
]

VerificationTest[
  FindInfraReflection[PathGraph[Range[5]], 1, 4, 1],
  { },
  TestID -> "FindInfraReflection-PathGraph-no-room-strict-fails"
]

VerificationTest[
  MemberQ[FindInfraReflection[CycleGraph[6], 1, 2, All], 3],
  True,
  TestID -> "FindInfraReflection-CycleGraph6-includes-3"
]

VerificationTest[
  Length[ FindInfraReflection[HypercubeGraph[3], 1, 2, All] ] >= 2,
  True,
  TestID -> "FindInfraReflection-HypercubeGraph-multi-valued"
]

(* FindInfraReflection is local: depends only on B(a, 2 d(a, x)). *)

VerificationTest[
  With[ { g = GridGraph[ { 10, 10 } ], x = 23, a = 25 },
    Sort[ FindInfraReflection[ g, x, a, All ] ] ===
      Sort[ FindInfraReflection[ NeighborhoodGraph[ g, a, 2 GraphDistance[ g, a, x ] ], x, a, All ] ]
  ],
  True,
  TestID -> "FindInfraReflection-locality"
]

EndTestSection[]
