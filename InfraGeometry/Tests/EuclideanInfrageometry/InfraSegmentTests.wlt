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
      Sort[FindInfraRepresentative[g, InfraSegment[p, q], All]] === Sort[FindPath[g, p, q, {GraphDistance[g, p, q]}, All]]]],
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

(* the family size is the occupation of the endpoints: the 3x3 grid centre lies on 4 of the 6 geodesics,
   a path has one geodesic and antipodal points of the hexagon two *)
VerificationTest[
  {With[{d = InfraMeasurement[GridGraph[{3, 3}], InfraSegment[1, 9], "VertexDensity"]}, {Max[d], d[5]}],
   Max @ InfraMeasurement[PathGraph[Range[5]], InfraSegment[1, 5], "VertexDensity"],
   Max @ InfraMeasurement[CycleGraph[6], InfraSegment[1, 4], "VertexDensity"]},
  {{6, 4}, 1, 2},
  TestID -> "InfraSegment-vertex-density-counts"
]

(* every arrow of a unique geodesic carries 1, and the arrows out of the source carry the whole family *)
VerificationTest[
  {Values @ InfraMeasurement[PathGraph[Range[5]], InfraSegment[1, 5], "EdgeDensity"],
   Total @ KeySelect[InfraMeasurement[GridGraph[{3, 3}], InfraSegment[1, 9], "EdgeDensity"], First[#] === 1 &]},
  {{1, 1, 1, 1}, 6},
  TestID -> "InfraSegment-edge-density-conserves-the-family"
]

(* list-valued vertex labels: the arrow occupation finds every arrow *)
VerificationTest[
  With[{g = Graph[Map[{Quotient[# - 1, 3] + 1, Mod[# - 1, 3] + 1} &, EdgeList[GridGraph[{3, 3}]], {2}]]},
    {d = InfraMeasurement[g, InfraSegment[{1, 1}, {3, 3}], "EdgeDensity"]},
    {FreeQ[d, _Missing], Length[d], Total @ KeySelect[d, First[#] === {1, 1} &]}],
  {True, 12, 6},
  TestID -> "InfraSegment-edge-density-list-valued-labels"
]

(* endpoints in different components: the graph is empty *)
VerificationTest[
  VertexCount @ InfraMeasurement[Graph[{1, 2, 3}, {1 <-> 2}], InfraSegment[1, 3], "Graph"],
  0,
  TestID -> "InfraSegment-disconnected-endpoints-empty-graph"
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
     Length[FindInfraRepresentative[g, obj, All]] === InfraMeasurement[g, obj, "Cardinality"],
     InfraMeasurement[g, obj, "Length"] === GraphDistance[g, 1, 5] + GraphDistance[g, 5, 9],
     AllTrue[FindInfraRepresentative[g, obj, All], Length[#] === InfraMeasurement[g, obj, "Length"] + 1 &]}],
  {True, True, True, True},
  TestID -> "InfraSegment-polyline-members-concatenate-the-pieces"
]

(* the union of the pieces is not faithful, which is why the graph stays a List: the polyline
   p, q, p retraces its one edge, and a union would carry both orientations of it *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    {FindInfraRepresentative[g, InfraSegment[1, 2, 1], All], InfraMeasurement[g, InfraSegment[1, 2, 1], "Cardinality"]}],
  {{{1, 2, 1}}, 1},
  TestID -> "InfraSegment-polyline-may-retrace-a-side"
]

(* membership on a polyline cuts the path at the knots *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]}, {obj = InfraSegment[1, 5, 9]},
    {AllTrue[FindInfraRepresentative[g, obj, All], InfraMemberQ[g, obj, #] &],
     InfraMemberQ[g, obj, {1, 2, 3, 6, 9}]}],
  {True, False},
  TestID -> "InfraSegment-polyline-membership"
]

(* the density of a polyline counts its members: a vertex of one piece lies on every member of the
   others, and a knot is visited once *)
VerificationTest[
  With[{g = GridGraph[{6, 6}]}, {obj = InfraSegment[1, 16, 36]},
    {members = FindInfraRepresentative[g, obj, All]},
    {InfraMeasurement[g, obj, "VertexDensity"] === KeySort @ Counts @ Catenate @ members,
     InfraMeasurement[g, obj, "EdgeDensity"] ===
       KeySort @ Counts @ Catenate[DirectedEdge @@@ Partition[#, 2, 1] & /@ members],
     InfraMeasurement[g, obj, "VertexDensity"][16] === InfraMeasurement[g, obj, "Cardinality"]}],
  {True, True, True},
  TestID -> "InfraSegment-polyline-density-counts-members"
]

(* a retraced side is visited twice at the vertex it returns to *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]}, InfraMeasurement[g, InfraSegment[1, 2, 1], "VertexDensity"]],
  <|1 -> 2, 2 -> 1|>,
  TestID -> "InfraSegment-polyline-density-on-a-retraced-side"
]

(* ===== the closed polyline: a polygon ===== *)

(* the first corner repeated at the end closes the polyline: the triangle 1, 3, 9 of the 3x3 grid
   is the product of its sides, two unique and the diagonal one six-fold, and every member is a
   closed walk through the corners *)
VerificationTest[
  With[{g = GridGraph[{3, 3}], obj = InfraSegment[1, 3, 9, 1]},
    {members = FindInfraRepresentative[g, obj, All]},
    {Length[InfraMeasurement[g, obj, "Graph"]], InfraMeasurement[g, obj, "Cardinality"], InfraMeasurement[g, obj, "Length"],
     Length[members], AllTrue[members, First[#] === 1 && Last[#] === 1 && Length[#] === 9 &],
     AllTrue[members, SubsetQ[#, {1, 3, 9}] &], AllTrue[members, InfraMemberQ[g, obj, #] &]}],
  {3, 6, 8, 6, True, True, True},
  TestID -> "InfraSegment-closed-polyline-is-the-polygon"
]

(* the density of a closed polyline counts its members as for an open one, so the corner it
   returns to is visited twice by every member *)
VerificationTest[
  With[{g = GridGraph[{3, 3}], obj = InfraSegment[1, 3, 9, 1]},
    {members = FindInfraRepresentative[g, obj, All]},
    {InfraMeasurement[g, obj, "VertexDensity"] === KeySort @ Counts @ Catenate @ members,
     InfraMeasurement[g, obj, "EdgeDensity"] === KeySort @ Counts @ Catenate[DirectedEdge @@@ Partition[#, 2, 1] & /@ members],
     InfraMeasurement[g, obj, "VertexDensity"][1] === 2 InfraMeasurement[g, obj, "Cardinality"],
     InfraMeasurement[g, obj, "CountingMeasure"]}],
  {True, True, True, 9},
  TestID -> "InfraSegment-closed-polyline-density-counts-the-return"
]

(* a bounded count reads the first members of the product of the sides: the 4x4 grid square
   1, 16, 1, 16 has 20^4 members, and fifty of them come without forming the class *)
VerificationTest[
  With[{g = GridGraph[{4, 4}], obj = InfraSegment[1, 16, 1, 16, 1]},
    {members = FindInfraRepresentative[g, obj, 50]},
    {InfraMeasurement[g, obj, "Cardinality"], Length[members], DuplicateFreeQ[members],
     AllTrue[members, InfraMemberQ[g, obj, #] &],
     AllTrue[SeedRandom[1]; FindInfraRepresentative[g, obj, 5, "RandomChoice"], InfraMemberQ[g, obj, #] &]}],
  {160000, 50, True, True, True},
  TestID -> "InfraSegment-closed-polyline-bounded-count"
]

(* the segment from a point back to itself is no polygon: the one-vertex walk *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    {FindInfraRepresentative[g, InfraSegment[5, 5], All], InfraMeasurement[g, InfraSegment[5, 5], "VertexDensity"]}],
  {{{5}}, <|5 -> 1|>},
  TestID -> "InfraSegment-point-to-itself-is-not-a-polygon"
]

(* ===== FindInfraSegment: the independent search ===== *)

(* the search and the graph agree on the whole class *)
VerificationTest[
  AllTrue[
    {{GridGraph[{4, 4}], 1, 16}, {CycleGraph[6], 1, 4}, {HypercubeGraph[4], 1, 16}, {PetersenGraph[], 1, 3}},
    Apply[{g, p, q} |->
      Sort[FindInfraSegment[g, p, q, All]] === Sort[FindInfraRepresentative[g, InfraSegment[p, q], All]]]],
  True,
  TestID -> "FindInfraSegment-agrees-with-the-graph"
]

(* the count contract: one geodesic, a List under a count, the class under All *)
VerificationTest[
  With[{g = CycleGraph[6]},
    {InfraSegmentQ[g, FindInfraSegment[g, 1, 4]],
     Length[FindInfraSegment[g, 1, 4, 2]], Length[FindInfraSegment[g, 1, 4, UpTo[9]]],
     FindInfraSegment[g, 1, 4, 5]}],
  {True, 2, 2, { }},
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
