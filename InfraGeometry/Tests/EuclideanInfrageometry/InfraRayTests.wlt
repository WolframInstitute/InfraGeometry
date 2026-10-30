BeginTestSection["InfraHalfLine"]

(* ===== the head is inert ===== *)

VerificationTest[
  {InfraHalfLine[1, 2], InfraHalfLine[5, 5]},
  {InfraHalfLine[1, 2], InfraHalfLine[5, 5]},
  TestID -> "InfraHalfLine-head-is-inert"
]

(* ===== the graph is the ray DAG ===== *)

(* R(p, q) = I(p, q) union F(p, q), F(p, q) = { v : d(p, v) == d(p, q) + d(q, v) } *)
VerificationTest[
  With[{g = GridGraph[{4, 4}]}, {dag = InfraMeasurement[g, InfraHalfLine[6, 7], "Graph"]},
    {k = GraphDistance[g, 6, 7]},
    {Sort[VertexList[dag]] === Sort[Select[VertexList[g],
       GraphDistance[g, 6, #] + GraphDistance[g, #, 7] == k ||
       GraphDistance[g, 6, #] == k + GraphDistance[g, 7, #] &]],
     AllTrue[EdgeList[dag], GraphDistance[g, 6, Last[#]] == GraphDistance[g, 6, First[#]] + 1 &],
     Pick[VertexList[dag], VertexInDegree[dag], 0]}],
  {True, True, {6}},
  TestID -> "InfraHalfLine-graph-is-the-ray-DAG-from-the-origin"
]

(* the part of the ray DAG within d(p, q) of p is the interval DAG *)
VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    {k = GraphDistance[g, 6, 7]},
    Sort[EdgeList[Subgraph[InfraMeasurement[g, InfraHalfLine[6, 7], "Graph"],
        Select[VertexList[g], GraphDistance[g, 6, #] <= k &]]]] ===
      Sort[EdgeList[InfraMeasurement[g, InfraSegment[6, 7], "Graph"]]]],
  True,
  TestID -> "InfraHalfLine-graph-restricted-to-the-interval"
]

(* ===== the members are the inextensible geodesics through q ===== *)

(* against a brute-force enumeration of every geodesic out of p that reaches q and stops *)
VerificationTest[
  AllTrue[
    {{GridGraph[{3, 3}], 1, 2}, {GridGraph[{4, 4}], 1, 6}, {PetersenGraph[], 1, 2},
     {HypercubeGraph[3], 1, 2}, {CycleGraph[7], 1, 2}},
    Apply[{g, p, q} |->
      Sort[RandomInfraHalfLine[ g, InfraHalfLine[p, q], All ]] === Sort[Catenate[Table[
        Select[FindPath[g, p, e, {GraphDistance[g, p, e]}, All],
          path |-> MemberQ[path, q] && NoneTrue[AdjacencyList[g, e],
            GraphDistance[g, p, #] == GraphDistance[g, p, e] + 1 &]],
        {e, DeleteCases[VertexList[g], p]}]]]]],
  True,
  TestID -> "InfraHalfLine-members-equal-the-brute-force-class"
]

(* every member is a ray *)
VerificationTest[
  AllTrue[
    {PathGraph[Range[7]], CycleGraph[7], GridGraph[{3, 3}], GridGraph[{4, 4}],
     PetersenGraph[], HypercubeGraph[3]},
    g |-> AllTrue[Join[List @@@ EdgeList[g], Reverse /@ List @@@ EdgeList[g]],
      pair |-> AllTrue[Replace[ InfraHalfLine @@ pair, { token_InfraPoint :> RandomInfraPoint[ g, token, All ], token_InfraSegment :> RandomInfraSegment[ g, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraCircle :> RandomInfraCircle[ g, token, All ], token_InfraArc :> RandomInfraArc[ g, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All ], token_InfraPlane :> RandomInfraPlane[ g, token, All ], token_InfraBall :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraShell :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraSphere :> RandomInfraSphere[ g, token, All ], token_InfraTube :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraCylinder :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraCone :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraSolidOfRevolution :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraBallHull :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraConvexHull :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraQuadric :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraWalk :> RandomInfraWalk[ g, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All ], token_InfraIntersection :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraUnion :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ] } ], InfraHalfLineQ[g, #] &]]],
  True,
  TestID -> "InfraHalfLine-members-satisfy-InfraHalfLineQ-on-the-spread-table"
]

VerificationTest[
  {RandomInfraHalfLine[ PathGraph[Range[7]], InfraHalfLine[4, 7], All ],
   Sort[RandomInfraHalfLine[ CycleGraph[6], InfraHalfLine[1, 4], All ]]},
  {{{4, 5, 6, 7}}, {{1, 2, 3, 4}, {1, 6, 5, 4}}},
  TestID -> "InfraHalfLine-small-fixtures"
]

(* the cardinality is read off the DAG, without enumeration *)
VerificationTest[
  With[{g = GridGraph[{5, 5}]},
    AllTrue[{{1, 2}, {13, 14}, {13, 8}, {7, 12}},
      pair |-> InfraMeasurement[g, InfraHalfLine @@ pair, "Cardinality"] ===
        Length[Replace[ InfraHalfLine @@ pair, { token_InfraPoint :> RandomInfraPoint[ g, token, All ], token_InfraSegment :> RandomInfraSegment[ g, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraCircle :> RandomInfraCircle[ g, token, All ], token_InfraArc :> RandomInfraArc[ g, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All ], token_InfraPlane :> RandomInfraPlane[ g, token, All ], token_InfraBall :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraShell :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraSphere :> RandomInfraSphere[ g, token, All ], token_InfraTube :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraCylinder :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraCone :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraSolidOfRevolution :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraBallHull :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraConvexHull :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraQuadric :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraWalk :> RandomInfraWalk[ g, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All ], token_InfraIntersection :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraUnion :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ] } ]]]],
  True,
  TestID -> "InfraHalfLine-Cardinality-agrees-with-enumeration"
]

(* ===== RandomInfraHalfLine: the independent search ===== *)

VerificationTest[
  AllTrue[
    {{GridGraph[{4, 4}], 6, 7}, {CycleGraph[6], 1, 4}, {PetersenGraph[], 1, 2}, {HypercubeGraph[3], 1, 2}},
    Apply[{g, p, q} |-> Sort[RandomInfraHalfLine[g, p, q, All]] === Sort[RandomInfraHalfLine[ g, InfraHalfLine[p, q], All ]]]],
  True,
  TestID -> "RandomInfraHalfLine-agrees-with-the-graph"
]

VerificationTest[
  With[{g = CycleGraph[6]},
    {InfraHalfLineQ[g, RandomInfraHalfLine[g, 1, 4]], Length[RandomInfraHalfLine[g, 1, 4, UpTo[9]]], RandomInfraHalfLine[g, 1, 4, 5]}],
  {True, 2, { }},
  TestID -> "RandomInfraHalfLine-count-contract"
]

(* ===== the pencil ===== *)

(* the pencil at O is the ray from O through O itself: every maximal geodesic out of O *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]}, {pencil = RandomInfraHalfLine[g, 5, 5, All]},
    {InfraMeasurement[g, InfraHalfLine[5, 5], "Cardinality"], Length[pencil],
     AllTrue[pencil, First[#] === 5 && InfraHalfLineQ[g, #] &],
     Sort[pencil] === Sort[Catenate[RandomInfraHalfLine[g, 5, #, All] & /@ AdjacencyList[g, 5]]]}],
  {8, 8, True, True},
  TestID -> "InfraHalfLine-pencil-is-every-ray-from-the-origin"
]

VerificationTest[
  {Sort[RandomInfraHalfLine[PathGraph[Range[7]], 4, 4, All]],
   InfraMeasurement[#1, InfraHalfLine[#2, #2], "Cardinality"] & @@@
     {{PathGraph[Range[7]], 4}, {CycleGraph[6], 1}, {CycleGraph[7], 1}, {HypercubeGraph[3], 1}}},
  {{{4, 3, 2, 1}, {4, 5, 6, 7}}, {2, 2, 2, 6}},
  TestID -> "InfraHalfLine-pencil-cardinality-small-fixtures"
]

VerificationTest[
  Length[RandomInfraHalfLine[HypercubeGraph[3], 1, 1, All]] === InfraMeasurement[HypercubeGraph[3], InfraHalfLine[1, 1], "Cardinality"],
  True,
  TestID -> "InfraHalfLine-pencil-cardinality-agrees-with-enumeration-hypercube"
]

VerificationTest[
  With[{g = TorusGraph[{4, 5}]}, {rays = RandomInfraHalfLine[g, 1, 2, All]},
    {Sort[rays] === Sort[RandomInfraHalfLine[ g, InfraHalfLine[1, 2], All ]], Length[rays],
     AllTrue[rays, InfraHalfLineQ[g, #] &]}],
  {True, 6, True},
  TestID -> "RandomInfraHalfLine-agrees-with-the-graph-TorusGraph"
]

(* Identity preserves the first member in the old enumeration order. *)
VerificationTest[
  With[{g = CycleGraph[6], rays = RandomInfraHalfLine[CycleGraph[6], 1, 4, All]},
    RandomInfraHalfLine[g, 1, 4, "NextVertexFunction" -> Identity] === First[rays]],
  True,
  TestID -> "RandomInfraHalfLine-Identity-preserves-first-member"
]

VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    BlockRandom[RandomInfraHalfLine[g, 6, 7, RandomSeeding -> None ], RandomSeeding -> 17] ===
      BlockRandom[RandomInfraHalfLine[g, 6, 7, RandomSeeding -> None ], RandomSeeding -> 17] &&
    InfraHalfLineQ[g, BlockRandom[RandomInfraHalfLine[g, 6, 7, RandomSeeding -> None ], RandomSeeding -> 17]]],
  True,
  TestID -> "RandomInfraHalfLine-default-is-seeded-and-valid"
]

VerificationTest[
  Length @ DeleteDuplicates @ Table[
    BlockRandom[RandomInfraHalfLine[GridGraph[{4, 4}], 6, 7, RandomSeeding -> None ], RandomSeeding -> s],
    {s, 1, 8}] > 1,
  True,
  TestID -> "RandomInfraHalfLine-default-varies-across-seeds"
]

EndTestSection[]
