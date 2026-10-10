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
      Sort[RandomInfraHalfLine[ g, InfraRay[p, q], All ]] === Sort[Catenate[Table[
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
      pair |-> AllTrue[Replace[ InfraRay @@ pair, { token_InfraPoint :> RandomInfraPoint[ g, token, All ], token_InfraSegment :> RandomInfraSegment[ g, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraCircle :> RandomInfraCircle[ g, token, All ], token_InfraArc :> RandomInfraArc[ g, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All ], token_InfraPlane :> RandomInfraPlane[ g, token, All ], token_InfraBall :> RandomInfraBall[ g, token, All ], token_InfraShell :> RandomInfraShell[ g, token, All ], token_InfraSphere :> RandomInfraSphere[ g, token, All ], token_InfraTube :> RandomInfraTube[ g, token, All ], token_InfraCylinder :> RandomInfraCylinder[ g, token, All ], token_InfraCone :> RandomInfraCone[ g, token, All ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token, All ], token_InfraBallHull :> RandomInfraBallHull[ g, token, All ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token, All ], token_InfraQuadric :> RandomInfraQuadric[ g, token, All ], token_InfraWalk :> RandomInfraWalk[ g, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All ], token_InfraIntersection :> RandomInfraIntersection[ g, token, All ], token_InfraUnion :> RandomInfraUnion[ g, token, All ], token_InfraRay :> RandomInfraHalfLine[ g, token, All ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, All ] } ], InfraRayQ[g, #] &]]],
  True,
  TestID -> "InfraRay-members-satisfy-InfraRayQ-on-the-spread-table"
]

VerificationTest[
  {RandomInfraHalfLine[ PathGraph[Range[7]], InfraRay[4, 7], All ],
   Sort[RandomInfraHalfLine[ CycleGraph[6], InfraRay[1, 4], All ]]},
  {{{4, 5, 6, 7}}, {{1, 2, 3, 4}, {1, 6, 5, 4}}},
  TestID -> "InfraRay-small-fixtures"
]

(* the cardinality is read off the DAG, without enumeration *)
VerificationTest[
  With[{g = GridGraph[{5, 5}]},
    AllTrue[{{1, 2}, {13, 14}, {13, 8}, {7, 12}},
      pair |-> InfraMeasurement[g, InfraRay @@ pair, "Cardinality"] ===
        Length[Replace[ InfraRay @@ pair, { token_InfraPoint :> RandomInfraPoint[ g, token, All ], token_InfraSegment :> RandomInfraSegment[ g, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraCircle :> RandomInfraCircle[ g, token, All ], token_InfraArc :> RandomInfraArc[ g, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All ], token_InfraPlane :> RandomInfraPlane[ g, token, All ], token_InfraBall :> RandomInfraBall[ g, token, All ], token_InfraShell :> RandomInfraShell[ g, token, All ], token_InfraSphere :> RandomInfraSphere[ g, token, All ], token_InfraTube :> RandomInfraTube[ g, token, All ], token_InfraCylinder :> RandomInfraCylinder[ g, token, All ], token_InfraCone :> RandomInfraCone[ g, token, All ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token, All ], token_InfraBallHull :> RandomInfraBallHull[ g, token, All ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token, All ], token_InfraQuadric :> RandomInfraQuadric[ g, token, All ], token_InfraWalk :> RandomInfraWalk[ g, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All ], token_InfraIntersection :> RandomInfraIntersection[ g, token, All ], token_InfraUnion :> RandomInfraUnion[ g, token, All ], token_InfraRay :> RandomInfraHalfLine[ g, token, All ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, All ] } ]]]],
  True,
  TestID -> "InfraRay-Cardinality-agrees-with-enumeration"
]

(* ===== RandomInfraRay: the independent search ===== *)

VerificationTest[
  AllTrue[
    {{GridGraph[{4, 4}], 6, 7}, {CycleGraph[6], 1, 4}, {PetersenGraph[], 1, 2}, {HypercubeGraph[3], 1, 2}},
    Apply[{g, p, q} |-> Sort[RandomInfraRay[g, p, q, All]] === Sort[RandomInfraHalfLine[ g, InfraRay[p, q], All ]]]],
  True,
  TestID -> "RandomInfraRay-agrees-with-the-graph"
]

VerificationTest[
  With[{g = CycleGraph[6]},
    {InfraRayQ[g, RandomInfraRay[g, 1, 4]], Length[RandomInfraRay[g, 1, 4, UpTo[9]]], RandomInfraRay[g, 1, 4, 5]}],
  {True, 2, { }},
  TestID -> "RandomInfraRay-count-contract"
]

(* ===== the pencil ===== *)

(* the pencil at O is the ray from O through O itself: every maximal geodesic out of O *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]}, {pencil = RandomInfraRay[g, 5, 5, All]},
    {InfraMeasurement[g, InfraRay[5, 5], "Cardinality"], Length[pencil],
     AllTrue[pencil, First[#] === 5 && InfraRayQ[g, #] &],
     Sort[pencil] === Sort[Catenate[RandomInfraRay[g, 5, #, All] & /@ AdjacencyList[g, 5]]]}],
  {8, 8, True, True},
  TestID -> "InfraRay-pencil-is-every-ray-from-the-origin"
]

VerificationTest[
  {Sort[RandomInfraRay[PathGraph[Range[7]], 4, 4, All]],
   InfraMeasurement[#1, InfraRay[#2, #2], "Cardinality"] & @@@
     {{PathGraph[Range[7]], 4}, {CycleGraph[6], 1}, {CycleGraph[7], 1}, {HypercubeGraph[3], 1}}},
  {{{4, 3, 2, 1}, {4, 5, 6, 7}}, {2, 2, 2, 6}},
  TestID -> "InfraRay-pencil-cardinality-small-fixtures"
]

VerificationTest[
  Length[RandomInfraRay[HypercubeGraph[3], 1, 1, All]] === InfraMeasurement[HypercubeGraph[3], InfraRay[1, 1], "Cardinality"],
  True,
  TestID -> "InfraRay-pencil-cardinality-agrees-with-enumeration-hypercube"
]

VerificationTest[
  With[{g = TorusGraph[{4, 5}]}, {rays = RandomInfraRay[g, 1, 2, All]},
    {Sort[rays] === Sort[RandomInfraHalfLine[ g, InfraRay[1, 2], All ]], Length[rays],
     AllTrue[rays, InfraRayQ[g, #] &]}],
  {True, 6, True},
  TestID -> "RandomInfraRay-agrees-with-the-graph-TorusGraph"
]

(* Identity preserves the first member in the old enumeration order. *)
VerificationTest[
  With[{g = CycleGraph[6], rays = RandomInfraRay[CycleGraph[6], 1, 4, All]},
    RandomInfraRay[g, 1, 4, "NextVertexFunction" -> Identity] === First[rays]],
  True,
  TestID -> "RandomInfraRay-Identity-preserves-first-member"
]

VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    BlockRandom[RandomInfraRay[g, 6, 7], RandomSeeding -> 17] ===
      BlockRandom[RandomInfraRay[g, 6, 7], RandomSeeding -> 17] &&
    InfraRayQ[g, BlockRandom[RandomInfraRay[g, 6, 7], RandomSeeding -> 17]]],
  True,
  TestID -> "RandomInfraRay-default-is-seeded-and-valid"
]

VerificationTest[
  Length @ DeleteDuplicates @ Table[
    BlockRandom[RandomInfraRay[GridGraph[{4, 4}], 6, 7], RandomSeeding -> s],
    {s, 1, 8}] > 1,
  True,
  TestID -> "RandomInfraRay-default-varies-across-seeds"
]

EndTestSection[]
