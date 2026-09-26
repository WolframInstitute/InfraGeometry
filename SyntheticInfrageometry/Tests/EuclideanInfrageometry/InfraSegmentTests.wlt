BeginTestSection["InfraSegment"]

(* ===== the head is inert ===== *)

VerificationTest[
  {InfraSegment[1, 9], InfraSegment[1, 9, 3]},
  {InfraSegment[1, 9], InfraSegment[1, 9, 3]},
  TestID -> "InfraSegment-head-is-inert"
]

(* ===== the graph is the interval DAG and its chains are the geodesics ===== *)

(* I(p, q) = { v : d(p, v) + d(v, q) == d(p, q) }, arrows by rising d(p, .) *)
VerificationTest[
  With[{g = GridGraph[{4, 4}]}, {dag = InfraMeasurement[g, InfraSegment[2, 15], "Graph"]},
    {Sort[VertexList[dag]] === Sort[Select[VertexList[g],
       GraphDistance[g, 2, #] + GraphDistance[g, #, 15] == GraphDistance[g, 2, 15] &]],
     AllTrue[EdgeList[dag], GraphDistance[g, 2, Last[#]] == GraphDistance[g, 2, First[#]] + 1 &],
     AcyclicGraphQ[dag]}],
  {True, True, True},
  TestID -> "InfraSegment-graph-is-the-interval-DAG"
]

(* a DAG with a unique source and a unique sink *)
VerificationTest[
  With[{g = GridGraph[{4, 4}]}, {dag = InfraMeasurement[g, InfraSegment[2, 15], "Graph"]},
    {Pick[VertexList[dag], VertexInDegree[dag], 0], Pick[VertexList[dag], VertexOutDegree[dag], 0]}],
  {{2}, {15}},
  TestID -> "InfraSegment-graph-has-one-source-and-one-sink"
]

(* the members are exactly the geodesics, on graphs with very different interval shapes *)
VerificationTest[
  AllTrue[
    {{GridGraph[{4, 4}], 1, 16}, {CycleGraph[6], 1, 4}, {HypercubeGraph[4], 1, 16},
     {PetersenGraph[], 1, 3}, {PathGraph[Range[7]], 2, 6}},
    Apply[{g, p, q} |->
      Sort[InfraVertexList[g, InfraSegment[p, q], All]] === Sort[FindPath[g, p, q, {GraphDistance[g, p, q]}, All]]]],
  True,
  TestID -> "InfraSegment-members-are-the-geodesics"
]

(* every vertex and every arrow of the DAG lies on a member *)
VerificationTest[
  With[{g = GridGraph[{4, 4}]}, {obj = InfraSegment[1, 16]},
    {Min[InfraMeasurement[g, obj, "VertexDensity"]] > 0, Min[InfraMeasurement[g, obj, "EdgeDensity"]] > 0}],
  {True, True},
  TestID -> "InfraSegment-every-vertex-and-arrow-lies-on-a-member"
]

(* ===== the polyline ===== *)

(* the graph of a polyline is the List of its pieces' DAGs *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]}, {gs = InfraMeasurement[g, InfraSegment[1, 9, 3], "Graph"]},
    {Head /@ gs, Length[gs], Sort[VertexList[Last[gs]]]}],
  {{Graph, Graph}, 2, {3, 6, 9}},
  TestID -> "InfraSegment-polyline-graph-is-a-list-of-pieces"
]

(* a member concatenates one chain per piece, so the pieces are factors *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]}, {obj = InfraSegment[1, 5, 9]},
    {InfraMeasurement[g, obj, "Cardinality"] ===
       InfraMeasurement[g, InfraSegment[1, 5], "Cardinality"] InfraMeasurement[g, InfraSegment[5, 9], "Cardinality"],
     Length[InfraVertexList[g, obj, All]] === InfraMeasurement[g, obj, "Cardinality"],
     InfraMeasurement[g, obj, "Length"] === GraphDistance[g, 1, 5] + GraphDistance[g, 5, 9],
     AllTrue[InfraVertexList[g, obj, All], Length[#] === InfraMeasurement[g, obj, "Length"] + 1 &]}],
  {True, True, True, True},
  TestID -> "InfraSegment-polyline-members-concatenate-the-pieces"
]

(* the union of the pieces is not faithful, which is why the graph stays a List: the polyline
   p, q, p retraces its one edge, and a union would carry both orientations of it *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    {InfraVertexList[g, InfraSegment[1, 2, 1], All], InfraMeasurement[g, InfraSegment[1, 2, 1], "Cardinality"]}],
  {{{1, 2, 1}}, 1},
  TestID -> "InfraSegment-polyline-may-retrace-a-side"
]

(* membership on a polyline cuts the path at the knots *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]}, {obj = InfraSegment[1, 5, 9]},
    {AllTrue[InfraVertexList[g, obj, All], InfraMemberQ[g, obj, #] &],
     InfraMemberQ[g, obj, {1, 2, 3, 6, 9}]}],
  {True, False},
  TestID -> "InfraSegment-polyline-membership"
]

(* ===== FindInfraSegment: the independent search ===== *)

(* the search and the graph agree on the whole class *)
VerificationTest[
  AllTrue[
    {{GridGraph[{4, 4}], 1, 16}, {CycleGraph[6], 1, 4}, {HypercubeGraph[4], 1, 16}, {PetersenGraph[], 1, 3}},
    Apply[{g, p, q} |->
      Sort[FindInfraSegment[g, p, q, All]] === Sort[InfraVertexList[g, InfraSegment[p, q], All]]]],
  True,
  TestID -> "FindInfraSegment-agrees-with-the-graph"
]

(* the count contract: one geodesic, a List under a count, the class under All *)
VerificationTest[
  With[{g = CycleGraph[6]},
    {InfraSegmentQ[g, FindInfraSegment[g, 1, 4]],
     Length[FindInfraSegment[g, 1, 4, 2]], Length[FindInfraSegment[g, 1, 4, UpTo[9]]],
     FindInfraSegment[g, 1, 4, 5]}],
  {True, 2, 2, $Failed},
  TestID -> "FindInfraSegment-count-contract"
]

(* unreachable endpoints have no geodesic *)
VerificationTest[
  With[{g = Graph[{1, 2}, {}]}, {FindInfraSegment[g, 1, 2], FindInfraSegment[g, 1, 2, All]}],
  {{}, {}},
  TestID -> "FindInfraSegment-disconnected-endpoints"
]

(* ===== the predicates ===== *)

VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    {InfraSegmentQ[g, {1, 2, 3, 6, 9}], InfraSegmentQ[g, {1, 2, 5, 4, 7, 8, 9}],
     InfraWalkQ[g, {1, 2, 5, 4, 7, 8, 9}], InfraWalkQ[g, {1, 3}],
     UniqueInfraSegmentQ[g, 1, 3], UniqueInfraSegmentQ[g, 1, 9]}],
  {True, False, True, False, True, False},
  TestID -> "InfraSegment-predicates-on-vertex-lists"
]

(* the segment from a point to itself is the one-vertex walk *)
VerificationTest[
  FindInfraSegment[GridGraph[{3, 3}], 5, 5, All],
  {{5}},
  TestID -> "FindInfraSegment-same-point"
]

EndTestSection[]
