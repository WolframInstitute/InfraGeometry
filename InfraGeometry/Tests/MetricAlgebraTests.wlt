BeginTestSection["MetricAlgebra"]

(* ===== MetricInterval ===== *)

VerificationTest[
  Sort @ MetricInterval[PathGraph[Range[5]], 1, 5],
  {1, 2, 3, 4, 5},
  TestID -> "MetricInterval-PathGraph-full"
]

VerificationTest[
  Sort @ MetricInterval[PathGraph[Range[5]], 2, 4],
  {2, 3, 4},
  TestID -> "MetricInterval-PathGraph-interior"
]

VerificationTest[
  Sort @ MetricInterval[CycleGraph[4], 1, 3],
  {1, 2, 3, 4},
  TestID -> "MetricInterval-CycleGraph4-antipodes-fill"
]

VerificationTest[
  Sort @ MetricInterval[GridGraph[{3, 3}], 1, 9],
  Range[9],
  TestID -> "MetricInterval-GridGraph3x3-corners-fill"
]

VerificationTest[
  Sort @ MetricInterval[GridGraph[{3, 3}], 1, 3],
  {1, 2, 3},
  TestID -> "MetricInterval-GridGraph3x3-row"
]

VerificationTest[
  MetricInterval[Graph[{1, 2, 3, 4}, {1 <-> 2, 3 <-> 4}], 1, 3],
  {},
  TestID -> "MetricInterval-disconnected-empty"
]

(* ===== ShortestPathMultiplicityMatrix ===== *)

VerificationTest[
  Dimensions @ ShortestPathMultiplicityMatrix[CycleGraph[4]],
  {4, 4},
  TestID -> "ShortestPathMultiplicityMatrix-shape"
]

(* entry (i, j) counts the shortest paths: one on a path, two between antipodes of the square,
   six across the 3x3 grid, one along an edge, one from a vertex to itself, none across components *)
VerificationTest[
  {ShortestPathMultiplicityMatrix[PathGraph[Range[5]]][[1, 5]],
   ShortestPathMultiplicityMatrix[CycleGraph[4]][[1, 3]],
   ShortestPathMultiplicityMatrix[GridGraph[{3, 3}]][[1, 9]],
   ShortestPathMultiplicityMatrix[CompleteGraph[5]][[1, 2]],
   ShortestPathMultiplicityMatrix[PathGraph[Range[5]]][[3, 3]],
   ShortestPathMultiplicityMatrix[Graph[{1, 2, 3, 4}, {1 <-> 2, 3 <-> 4}]][[1, 3]]},
  {1, 2, 6, 1, 1, 0},
  TestID -> "ShortestPathMultiplicityMatrix-small-fixtures"
]

VerificationTest[
  AllTrue[Flatten @ ShortestPathMultiplicityMatrix[PathGraph[Range[5]]], # == 1 &],
  True,
  TestID -> "ShortestPathMultiplicityMatrix-PathGraph-all-unique"
]

(* the entry is the cardinality of the segment, read off its interval DAG *)
VerificationTest[
  With[{g = GridGraph[{3, 4}]},
    ShortestPathMultiplicityMatrix[g] ===
      Outer[InfraMeasurement[g, InfraSegment[#1, #2], "Cardinality"] &, VertexList[g], VertexList[g]]],
  True,
  TestID -> "ShortestPathMultiplicityMatrix-is-the-segment-cardinality"
]

VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    ShortestPathMultiplicityMatrix[g][[1, 9]] === Length[FindPath[g, 1, 9, {GraphDistance[g, 1, 9]}, All]]],
  True,
  TestID -> "ShortestPathMultiplicityMatrix-matches-enumeration"
]

(* ===== MedianVertices ===== *)

VerificationTest[
  Sort @ MedianVertices[PathGraph[Range[5]], {1, 5}],
  Range[5],
  TestID -> "MedianVertices-PathGraph-pair-fills-interval"
]

VerificationTest[
  Sort @ MedianVertices[PathGraph[Range[5]], {1, 4}],
  {1, 2, 3, 4},
  TestID -> "MedianVertices-PathGraph-asymmetric-pair"
]

VerificationTest[
  Sort @ MedianVertices[GridGraph[{3, 3}], {1, 3, 7}],
  {1},
  TestID -> "MedianVertices-GridGraph3x3-triple-corner"
]

VerificationTest[
  Sort @ MedianVertices[CycleGraph[6], {1, 3, 5}],
  Sort @ {1, 3, 5},
  TestID -> "MedianVertices-CycleGraph6-balanced-triple"
]

(* ===== FindSegmentHull ===== *)

VerificationTest[
  FindSegmentHull[PathGraph[Range[5]], {1, 5}],
  { 1, 2, 3, 4, 5 },
  TestID -> "FindSegmentHull-PathGraph-endpoints"
]

VerificationTest[
  FindSegmentHull[PathGraph[Range[5]], {2, 4}],
  { 2, 3, 4 },
  TestID -> "FindSegmentHull-PathGraph-interior"
]

VerificationTest[
  FindSegmentHull[PathGraph[Range[5]], {3}],
  { 3 },
  TestID -> "FindSegmentHull-singleton"
]

VerificationTest[
  FindSegmentHull[PathGraph[Range[5]], {}],
  { },
  TestID -> "FindSegmentHull-empty"
]

VerificationTest[
  FindSegmentHull[CycleGraph[4], {1, 3}],
  { 1, 2, 3, 4 },
  TestID -> "FindSegmentHull-CycleGraph4-antipodes-fill"
]

VerificationTest[
  FindSegmentHull[GridGraph[{3, 3}], {1, 9}],
  { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
  TestID -> "FindSegmentHull-GridGraph3x3-corners-fill"
]

VerificationTest[
  FindSegmentHull[GridGraph[{3, 3}], {1, 3}],
  { 1, 2, 3 },
  TestID -> "FindSegmentHull-GridGraph3x3-row-stays-row"
]

VerificationTest[
  FindSegmentHull[CompleteGraph[5], {1, 2}],
  { 1, 2 },
  TestID -> "FindSegmentHull-CompleteGraph-edge-stays-edge"
]

(* ===== SegmentHullQ ===== *)

VerificationTest[
  SegmentHullQ[PathGraph[Range[5]], {2, 3, 4}],
  True,
  TestID -> "SegmentHullQ-PathGraph-interior-true"
]

VerificationTest[
  SegmentHullQ[PathGraph[Range[5]], {1, 5}],
  False,
  TestID -> "SegmentHullQ-PathGraph-endpoints-false"
]

VerificationTest[
  SegmentHullQ[PathGraph[Range[5]], {3}],
  True,
  TestID -> "SegmentHullQ-singleton-true"
]

VerificationTest[
  SegmentHullQ[CycleGraph[4], {1, 3}],
  False,
  TestID -> "SegmentHullQ-CycleGraph4-antipodes-false"
]

VerificationTest[
  SegmentHullQ[CycleGraph[4], {1, 2, 3, 4}],
  True,
  TestID -> "SegmentHullQ-CycleGraph4-whole-true"
]

VerificationTest[
  SegmentHullQ[GridGraph[{3, 3}], {1, 2, 3}],
  True,
  TestID -> "SegmentHullQ-GridGraph3x3-row-true"
]

VerificationTest[
  SegmentHullQ[CompleteGraph[5], {1, 3, 5}],
  True,
  TestID -> "SegmentHullQ-CompleteGraph-arbitrary-true"
]

(* ===== SegmentHullQ: a C6 arc has two geodesics, so it is not segment-closed ===== *)

VerificationTest[
  SegmentHullQ[CycleGraph[6], {1, 2, 3, 4}],
  False,
  TestID -> "SegmentHullQ-CycleGraph6-arc-false"
]

EndTestSection[]
