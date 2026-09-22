BeginTestSection["InfraSegment"]

(* ===== InfraSegment[graph, p, q] stands for every geodesic ===== *)

(* the realisations are exactly the geodesics, as directed path graphs *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]}, {seg = InfraSegment[g, 1, 9]},
    Sort[VertexList /@ Normal[seg]] === Sort[FindPath[g, 1, 9, {4}, All]]],
  True,
  TestID -> "InfraSegment-realisations-are-the-geodesics"
]

(* canonical order: lexicographic in the vertex labels *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]}, {seg = InfraSegment[g, 1, 9]},
    VertexList /@ Normal[seg] === Sort[FindPath[g, 1, 9, {4}, All]]],
  True,
  TestID -> "InfraSegment-canonical-order-is-lexicographic"
]

(* the multiplicity is the geodesic count, read by DP, and Length agrees *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]}, {seg = InfraSegment[g, 1, 9]},
    {seg["Multiplicity"], Length[seg]} === {GeodesicMultiplicity[g, 1, 9], GeodesicMultiplicity[g, 1, 9]}],
  True,
  TestID -> "InfraSegment-multiplicity-is-the-geodesic-count"
]

(* Part enumerates on demand: an index, a span, a negative index, First *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]}, {seg = InfraSegment[g, 1, 9]}, {all = Normal[seg]},
    {seg[[1]] === First[all], seg[[1 ;; 2]] === Take[all, 2], seg[[-1]] === Last[all], First[seg] === First[all],
     seg[[2 ;; 5 ;; 2]] === all[[2 ;; 5 ;; 2]], seg[[All]] === all}],
  {True, True, True, True, True, True},
  TestID -> "InfraSegment-Part-enumerates-in-canonical-order"
]

(* the occupation density counts the geodesics through each vertex *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]}, {seg = InfraSegment[g, 1, 9]},
    seg["InfraDensity"] === KeySort @ Counts @ Catenate @ FindPath[g, 1, 9, {4}, All] &&
    seg[["InfraDensity"]] === seg["InfraDensity"] &&
    InfraDensity[g, seg] === seg["InfraDensity"]],
  True,
  TestID -> "InfraSegment-InfraDensity-is-the-occupation"
]

(* the edge occupation sums to length times multiplicity *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]}, {seg = InfraSegment[g, 1, 9]},
    Total[seg["EdgeDensity"]] == seg["Length"] seg["Multiplicity"] && seg["Length"] == GraphDistance[g, 1, 9]],
  True,
  TestID -> "InfraSegment-EdgeDensity-and-Length"
]

(* the vertex list is the metric interval; the graph is the acyclic interval DAG *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]}, {seg = InfraSegment[g, 1, 9]},
    Sort[VertexList[seg]] === Sort[MetricInterval[g, 1, 9]] && AcyclicGraphQ[seg["Graph"]] &&
    Sort[VertexList[seg["Graph"]]] === Sort[VertexList[GeodesicIntervalGraph[g, 1, 9]]]],
  True,
  TestID -> "InfraSegment-VertexList-is-the-metric-interval"
]

(* the predicates accept the object *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]}, {seg = InfraSegment[g, 1, 9]},
    {InfraSegmentQ[g, seg], InfraWalkQ[g, seg], InfraLineQ[g, seg]}],
  {True, True, True},
  TestID -> "InfraSegment-predicates-accept-the-object"
]

(* anchors spread: a density on one end gives one atom per pair and the multiplicities add *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]}, {seg = InfraSegment[g, <|1 -> 1, 3 -> 1|>, 9]},
    {Length[seg["Atoms"]], seg["Multiplicity"]} === {2, GeodesicMultiplicity[g, 1, 9] + GeodesicMultiplicity[g, 3, 9]}],
  True,
  TestID -> "InfraSegment-anchor-spread-adds-atoms"
]

(* no geodesic, no realisation *)
VerificationTest[
  With[{seg = InfraSegment[Graph[{1, 2}, {}], 1, 2]},
    {seg["Multiplicity"], Normal[seg], seg["InfraDensity"], VertexList[seg]}],
  {0, {}, <||>, {}},
  TestID -> "InfraSegment-disconnected-endpoints-give-the-empty-object"
]

(* an index past the family is a Part error *)
VerificationTest[
  InfraSegment[GridGraph[{3, 3}], 1, 9][[7]],
  $Failed,
  {Part::partw},
  TestID -> "InfraSegment-Part-out-of-range"
]

(* the object renders, alone and among shapes, and the summary box is interpretable *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]}, {seg = InfraSegment[g, 1, 9]},
    {Head @ InfraSceneHighlight[g, seg], Head @ InfraSceneHighlight[g, {seg -> Red, 5}], Head @ HighlightGraph[g, seg],
     Head @ ToBoxes[seg]}],
  {Graph, Graph, Graph, InterpretationBox},
  TestID -> "InfraSegment-renders-and-formats"
]

(* the scene token is untouched: without the graph the head stays inert *)
VerificationTest[
  InfraSegment[1, 9],
  InfraSegment[1, 9],
  TestID -> "InfraSegment-token-without-graph-stays-inert"
]

EndTestSection[]
