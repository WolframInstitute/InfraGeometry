BeginTestSection["InfraRay"]

(* ===== the head is inert ===== *)

VerificationTest[
  {InfraRay[1, 2], InfraRay[5, 5]},
  {InfraRay[1, 2], InfraRay[5, 5]},
  TestID -> "InfraRay-head-is-inert"
]

(* ===== the graph is the ray DAG ===== *)

(* R(p, q) = I(p, q) union F(p, q), F(p, q) = { v : d(p, v) == d(p, q) + d(q, v) } *)
VerificationTest[
  With[{g = GridGraph[{4, 4}]}, {dag = InfraMeasurement[g, InfraRay[6, 7], "Graph"]},
    {k = GraphDistance[g, 6, 7]},
    {Sort[VertexList[dag]] === Sort[Select[VertexList[g],
       GraphDistance[g, 6, #] + GraphDistance[g, #, 7] == k ||
       GraphDistance[g, 6, #] == k + GraphDistance[g, 7, #] &]],
     AllTrue[EdgeList[dag], GraphDistance[g, 6, Last[#]] == GraphDistance[g, 6, First[#]] + 1 &],
     Pick[VertexList[dag], VertexInDegree[dag], 0]}],
  {True, True, {6}},
  TestID -> "InfraRay-graph-is-the-ray-DAG-from-the-origin"
]

(* the part of the ray DAG within d(p, q) of p is the interval DAG *)
VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    {k = GraphDistance[g, 6, 7]},
    Sort[EdgeList[Subgraph[InfraMeasurement[g, InfraRay[6, 7], "Graph"],
        Select[VertexList[g], GraphDistance[g, 6, #] <= k &]]]] ===
      Sort[EdgeList[InfraMeasurement[g, InfraSegment[6, 7], "Graph"]]]],
  True,
  TestID -> "InfraRay-graph-restricted-to-the-interval"
]

(* ===== the members are the inextensible geodesics through q ===== *)

(* against a brute-force enumeration of every geodesic out of p that reaches q and stops *)
VerificationTest[
  AllTrue[
    {{GridGraph[{3, 3}], 1, 2}, {GridGraph[{4, 4}], 1, 6}, {PetersenGraph[], 1, 2},
     {HypercubeGraph[3], 1, 2}, {CycleGraph[7], 1, 2}},
    Apply[{g, p, q} |->
      Sort[FindInfraRepresentative[g, InfraRay[p, q], All]] === Sort[Catenate[Table[
        Select[FindPath[g, p, e, {GraphDistance[g, p, e]}, All],
          path |-> MemberQ[path, q] && NoneTrue[AdjacencyList[g, e],
            GraphDistance[g, p, #] == GraphDistance[g, p, e] + 1 &]],
        {e, DeleteCases[VertexList[g], p]}]]]]],
  True,
  TestID -> "InfraRay-members-equal-the-brute-force-class"
]

(* every member is a ray *)
VerificationTest[
  AllTrue[
    {PathGraph[Range[7]], CycleGraph[7], GridGraph[{3, 3}], GridGraph[{4, 4}],
     PetersenGraph[], HypercubeGraph[3]},
    g |-> AllTrue[Join[List @@@ EdgeList[g], Reverse /@ List @@@ EdgeList[g]],
      pair |-> AllTrue[FindInfraRepresentative[g, InfraRay @@ pair, All], InfraRayQ[g, #] &]]],
  True,
  TestID -> "InfraRay-members-satisfy-InfraRayQ-on-the-spread-table"
]

VerificationTest[
  {FindInfraRepresentative[PathGraph[Range[7]], InfraRay[4, 7], All],
   Sort[FindInfraRepresentative[CycleGraph[6], InfraRay[1, 4], All]]},
  {{{4, 5, 6, 7}}, {{1, 2, 3, 4}, {1, 6, 5, 4}}},
  TestID -> "InfraRay-small-fixtures"
]

(* the cardinality is read off the DAG, without enumeration *)
VerificationTest[
  With[{g = GridGraph[{5, 5}]},
    AllTrue[{{1, 2}, {13, 14}, {13, 8}, {7, 12}},
      pair |-> InfraMeasurement[g, InfraRay @@ pair, "Cardinality"] ===
        Length[FindInfraRepresentative[g, InfraRay @@ pair, All]]]],
  True,
  TestID -> "InfraRay-Cardinality-agrees-with-enumeration"
]

(* ===== FindInfraRay: the independent search ===== *)

VerificationTest[
  AllTrue[
    {{GridGraph[{4, 4}], 6, 7}, {CycleGraph[6], 1, 4}, {PetersenGraph[], 1, 2}, {HypercubeGraph[3], 1, 2}},
    Apply[{g, p, q} |-> Sort[FindInfraRay[g, p, q, All]] === Sort[FindInfraRepresentative[g, InfraRay[p, q], All]]]],
  True,
  TestID -> "FindInfraRay-agrees-with-the-graph"
]

VerificationTest[
  With[{g = CycleGraph[6]},
    {InfraRayQ[g, FindInfraRay[g, 1, 4]], Length[FindInfraRay[g, 1, 4, UpTo[9]]], FindInfraRay[g, 1, 4, 5]}],
  {True, 2, { }},
  TestID -> "FindInfraRay-count-contract"
]

(* ===== the pencil ===== *)

(* the pencil at O is the ray from O through O itself: every maximal geodesic out of O *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    {PencilCardinality[g, 5], Length[PencilDirections[g, 5]],
     AllTrue[PencilDirections[g, 5], First[#] === 5 && InfraRayQ[g, #] &],
     Sort[PencilDirections[g, 5]] ===
       Sort[Catenate[FindInfraRay[g, 5, #, All] & /@ AdjacencyList[g, 5]]]}],
  {8, 8, True, True},
  TestID -> "PencilDirections-is-every-ray-from-the-origin"
]

VerificationTest[
  {Sort[PencilDirections[PathGraph[Range[7]], 4]], PencilCardinality[PathGraph[Range[7]], 4],
   PencilCardinality[CycleGraph[6], 1], PencilCardinality[CycleGraph[7], 1],
   PencilCardinality[HypercubeGraph[3], 1]},
  {{{4, 3, 2, 1}, {4, 5, 6, 7}}, 2, 2, 2, 6},
  TestID -> "PencilCardinality-small-fixtures"
]

VerificationTest[
  Length[PencilDirections[HypercubeGraph[3], 1]] === PencilCardinality[HypercubeGraph[3], 1],
  True,
  TestID -> "PencilDirections-Cardinality-agree-hypercube"
]

VerificationTest[
  With[{g = TorusGraph[{4, 5}]}, {rays = FindInfraRay[g, 1, 2, All]},
    {Sort[rays] === Sort[FindInfraRepresentative[g, InfraRay[1, 2], All]], Length[rays],
     AllTrue[rays, InfraRayQ[g, #] &]}],
  {True, 6, True},
  TestID -> "FindInfraRay-agrees-with-the-graph-TorusGraph"
]

EndTestSection[]
