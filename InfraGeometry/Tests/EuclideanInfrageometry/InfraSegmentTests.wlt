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
      Sort[RandomInfraSegment[ g, InfraSegment[p, q], All ]] === Sort[FindPath[g, p, q, {GraphDistance[g, p, q]}, All]]]],
  True,
  TestID -> "InfraSegment-members-are-the-geodesics"
]

(* a segment draw is random by default and reproducible after resetting the random state *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    With[{draws = BlockRandom[Table[RandomInfraSegment[g, 1, 9], {10}], RandomSeeding -> 1]},
      {draws === BlockRandom[Table[RandomInfraSegment[g, 1, 9], {10}], RandomSeeding -> 1],
       Length[DeleteDuplicates[draws]] > 1, InfraSegmentQ[g, First[draws]]}]],
  {True, True, True},
  TestID -> "RandomInfraSegment-default-draw-is-random-and-seeded"
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
     Length[Replace[ obj, { token_InfraPoint :> RandomInfraPoint[ g, token, All ], token_InfraSegment :> RandomInfraSegment[ g, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraCircle :> RandomInfraCircle[ g, token, All ], token_InfraArc :> RandomInfraArc[ g, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All ], token_InfraPlane :> RandomInfraPlane[ g, token, All ], token_InfraBall :> RandomInfraBall[ g, token, All ], token_InfraShell :> RandomInfraShell[ g, token, All ], token_InfraSphere :> RandomInfraSphere[ g, token, All ], token_InfraTube :> RandomInfraTube[ g, token, All ], token_InfraCylinder :> RandomInfraCylinder[ g, token, All ], token_InfraCone :> RandomInfraCone[ g, token, All ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token, All ], token_InfraBallHull :> RandomInfraBallHull[ g, token, All ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token, All ], token_InfraQuadric :> RandomInfraQuadric[ g, token, All ], token_InfraWalk :> RandomInfraWalk[ g, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All ], token_InfraIntersection :> RandomInfraIntersection[ g, token, All ], token_InfraUnion :> RandomInfraUnion[ g, token, All ], token_InfraRay :> RandomInfraHalfLine[ g, token, All ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, All ] } ]] === InfraMeasurement[g, obj, "Cardinality"],
     InfraMeasurement[g, obj, "Length"] === GraphDistance[g, 1, 5] + GraphDistance[g, 5, 9],
     AllTrue[Replace[ obj, { token_InfraPoint :> RandomInfraPoint[ g, token, All ], token_InfraSegment :> RandomInfraSegment[ g, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraCircle :> RandomInfraCircle[ g, token, All ], token_InfraArc :> RandomInfraArc[ g, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All ], token_InfraPlane :> RandomInfraPlane[ g, token, All ], token_InfraBall :> RandomInfraBall[ g, token, All ], token_InfraShell :> RandomInfraShell[ g, token, All ], token_InfraSphere :> RandomInfraSphere[ g, token, All ], token_InfraTube :> RandomInfraTube[ g, token, All ], token_InfraCylinder :> RandomInfraCylinder[ g, token, All ], token_InfraCone :> RandomInfraCone[ g, token, All ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token, All ], token_InfraBallHull :> RandomInfraBallHull[ g, token, All ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token, All ], token_InfraQuadric :> RandomInfraQuadric[ g, token, All ], token_InfraWalk :> RandomInfraWalk[ g, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All ], token_InfraIntersection :> RandomInfraIntersection[ g, token, All ], token_InfraUnion :> RandomInfraUnion[ g, token, All ], token_InfraRay :> RandomInfraHalfLine[ g, token, All ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, All ] } ], Length[#] === InfraMeasurement[g, obj, "Length"] + 1 &]}],
  {True, True, True, True},
  TestID -> "InfraSegment-polyline-members-concatenate-the-pieces"
]

(* the union of the pieces is not faithful, which is why the graph stays a List: the polyline
   p, q, p retraces its one edge, and a union would carry both orientations of it *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    {RandomInfraSegment[ g, InfraSegment[1, 2, 1], All ], InfraMeasurement[g, InfraSegment[1, 2, 1], "Cardinality"]}],
  {{{1, 2, 1}}, 1},
  TestID -> "InfraSegment-polyline-may-retrace-a-side"
]

(* membership on a polyline cuts the path at the knots *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]}, {obj = InfraSegment[1, 5, 9]},
    {AllTrue[Replace[ obj, { token_InfraPoint :> RandomInfraPoint[ g, token, All ], token_InfraSegment :> RandomInfraSegment[ g, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraCircle :> RandomInfraCircle[ g, token, All ], token_InfraArc :> RandomInfraArc[ g, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All ], token_InfraPlane :> RandomInfraPlane[ g, token, All ], token_InfraBall :> RandomInfraBall[ g, token, All ], token_InfraShell :> RandomInfraShell[ g, token, All ], token_InfraSphere :> RandomInfraSphere[ g, token, All ], token_InfraTube :> RandomInfraTube[ g, token, All ], token_InfraCylinder :> RandomInfraCylinder[ g, token, All ], token_InfraCone :> RandomInfraCone[ g, token, All ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token, All ], token_InfraBallHull :> RandomInfraBallHull[ g, token, All ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token, All ], token_InfraQuadric :> RandomInfraQuadric[ g, token, All ], token_InfraWalk :> RandomInfraWalk[ g, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All ], token_InfraIntersection :> RandomInfraIntersection[ g, token, All ], token_InfraUnion :> RandomInfraUnion[ g, token, All ], token_InfraRay :> RandomInfraHalfLine[ g, token, All ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, All ] } ], InfraMemberQ[g, obj, #] &],
     InfraMemberQ[g, obj, {1, 2, 3, 6, 9}]}],
  {True, False},
  TestID -> "InfraSegment-polyline-membership"
]

(* the density of a polyline counts its members: a vertex of one piece lies on every member of the
   others, and a knot is visited once *)
VerificationTest[
  With[{g = GridGraph[{6, 6}]}, {obj = InfraSegment[1, 16, 36]},
    {members = Replace[ obj, { token_InfraPoint :> RandomInfraPoint[ g, token, All ], token_InfraSegment :> RandomInfraSegment[ g, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraCircle :> RandomInfraCircle[ g, token, All ], token_InfraArc :> RandomInfraArc[ g, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All ], token_InfraPlane :> RandomInfraPlane[ g, token, All ], token_InfraBall :> RandomInfraBall[ g, token, All ], token_InfraShell :> RandomInfraShell[ g, token, All ], token_InfraSphere :> RandomInfraSphere[ g, token, All ], token_InfraTube :> RandomInfraTube[ g, token, All ], token_InfraCylinder :> RandomInfraCylinder[ g, token, All ], token_InfraCone :> RandomInfraCone[ g, token, All ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token, All ], token_InfraBallHull :> RandomInfraBallHull[ g, token, All ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token, All ], token_InfraQuadric :> RandomInfraQuadric[ g, token, All ], token_InfraWalk :> RandomInfraWalk[ g, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All ], token_InfraIntersection :> RandomInfraIntersection[ g, token, All ], token_InfraUnion :> RandomInfraUnion[ g, token, All ], token_InfraRay :> RandomInfraHalfLine[ g, token, All ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, All ] } ]},
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
    {members = Replace[ obj, { token_InfraPoint :> RandomInfraPoint[ g, token, All ], token_InfraSegment :> RandomInfraSegment[ g, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraCircle :> RandomInfraCircle[ g, token, All ], token_InfraArc :> RandomInfraArc[ g, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All ], token_InfraPlane :> RandomInfraPlane[ g, token, All ], token_InfraBall :> RandomInfraBall[ g, token, All ], token_InfraShell :> RandomInfraShell[ g, token, All ], token_InfraSphere :> RandomInfraSphere[ g, token, All ], token_InfraTube :> RandomInfraTube[ g, token, All ], token_InfraCylinder :> RandomInfraCylinder[ g, token, All ], token_InfraCone :> RandomInfraCone[ g, token, All ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token, All ], token_InfraBallHull :> RandomInfraBallHull[ g, token, All ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token, All ], token_InfraQuadric :> RandomInfraQuadric[ g, token, All ], token_InfraWalk :> RandomInfraWalk[ g, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All ], token_InfraIntersection :> RandomInfraIntersection[ g, token, All ], token_InfraUnion :> RandomInfraUnion[ g, token, All ], token_InfraRay :> RandomInfraHalfLine[ g, token, All ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, All ] } ]},
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
    {members = Replace[ obj, { token_InfraPoint :> RandomInfraPoint[ g, token, All ], token_InfraSegment :> RandomInfraSegment[ g, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraCircle :> RandomInfraCircle[ g, token, All ], token_InfraArc :> RandomInfraArc[ g, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All ], token_InfraPlane :> RandomInfraPlane[ g, token, All ], token_InfraBall :> RandomInfraBall[ g, token, All ], token_InfraShell :> RandomInfraShell[ g, token, All ], token_InfraSphere :> RandomInfraSphere[ g, token, All ], token_InfraTube :> RandomInfraTube[ g, token, All ], token_InfraCylinder :> RandomInfraCylinder[ g, token, All ], token_InfraCone :> RandomInfraCone[ g, token, All ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token, All ], token_InfraBallHull :> RandomInfraBallHull[ g, token, All ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token, All ], token_InfraQuadric :> RandomInfraQuadric[ g, token, All ], token_InfraWalk :> RandomInfraWalk[ g, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All ], token_InfraIntersection :> RandomInfraIntersection[ g, token, All ], token_InfraUnion :> RandomInfraUnion[ g, token, All ], token_InfraRay :> RandomInfraHalfLine[ g, token, All ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, All ] } ]},
    {InfraMeasurement[g, obj, "VertexDensity"] === KeySort @ Counts @ Catenate @ members,
     InfraMeasurement[g, obj, "EdgeDensity"] === KeySort @ Counts @ Catenate[DirectedEdge @@@ Partition[#, 2, 1] & /@ members],
     InfraMeasurement[g, obj, "VertexDensity"][1] === 2 InfraMeasurement[g, obj, "Cardinality"],
     InfraMeasurement[g, obj, "CountingMeasure"]}],
  {True, True, True, 9},
  TestID -> "InfraSegment-closed-polyline-density-counts-the-return"
]

(* a count-less closed-polyline draw is random, reproducible by seed, and remains a member *)
VerificationTest[
  With[{g = GridGraph[{3, 3}], obj = InfraSegment[1, 3, 9, 1]},
    With[{draws = BlockRandom[Table[Replace[ obj, { token_InfraPoint :> RandomInfraPoint[ g, token ], token_InfraSegment :> RandomInfraSegment[ g, token ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token ], token_InfraCircle :> RandomInfraCircle[ g, token ], token_InfraArc :> RandomInfraArc[ g, token ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token ], token_InfraPlane :> RandomInfraPlane[ g, token ], token_InfraBall :> RandomInfraBall[ g, token ], token_InfraShell :> RandomInfraShell[ g, token ], token_InfraSphere :> RandomInfraSphere[ g, token ], token_InfraTube :> RandomInfraTube[ g, token ], token_InfraCylinder :> RandomInfraCylinder[ g, token ], token_InfraCone :> RandomInfraCone[ g, token ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token ], token_InfraBallHull :> RandomInfraBallHull[ g, token ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token ], token_InfraQuadric :> RandomInfraQuadric[ g, token ], token_InfraWalk :> RandomInfraWalk[ g, token ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token ], token_InfraEllipse :> RandomInfraEllipse[ g, token ], token_InfraIntersection :> RandomInfraIntersection[ g, token ], token_InfraUnion :> RandomInfraUnion[ g, token ], token_InfraRay :> RandomInfraHalfLine[ g, token ], token_InfraLine :> RandomInfraInfiniteLine[ g, token ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token ] } ], {10}], RandomSeeding -> 1]},
      {draws === BlockRandom[Table[Replace[ obj, { token_InfraPoint :> RandomInfraPoint[ g, token ], token_InfraSegment :> RandomInfraSegment[ g, token ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token ], token_InfraCircle :> RandomInfraCircle[ g, token ], token_InfraArc :> RandomInfraArc[ g, token ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token ], token_InfraPlane :> RandomInfraPlane[ g, token ], token_InfraBall :> RandomInfraBall[ g, token ], token_InfraShell :> RandomInfraShell[ g, token ], token_InfraSphere :> RandomInfraSphere[ g, token ], token_InfraTube :> RandomInfraTube[ g, token ], token_InfraCylinder :> RandomInfraCylinder[ g, token ], token_InfraCone :> RandomInfraCone[ g, token ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token ], token_InfraBallHull :> RandomInfraBallHull[ g, token ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token ], token_InfraQuadric :> RandomInfraQuadric[ g, token ], token_InfraWalk :> RandomInfraWalk[ g, token ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token ], token_InfraEllipse :> RandomInfraEllipse[ g, token ], token_InfraIntersection :> RandomInfraIntersection[ g, token ], token_InfraUnion :> RandomInfraUnion[ g, token ], token_InfraRay :> RandomInfraHalfLine[ g, token ], token_InfraLine :> RandomInfraInfiniteLine[ g, token ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token ] } ], {10}], RandomSeeding -> 1],
       Length[DeleteDuplicates[draws]] > 1, AllTrue[draws, InfraMemberQ[g, obj, #] &],
       Length[Replace[ obj, { token_InfraPoint :> RandomInfraPoint[ g, token, UpTo[1] ], token_InfraSegment :> RandomInfraSegment[ g, token, UpTo[1] ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, UpTo[1] ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, UpTo[1] ], token_InfraCircle :> RandomInfraCircle[ g, token, UpTo[1] ], token_InfraArc :> RandomInfraArc[ g, token, UpTo[1] ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, UpTo[1] ], token_InfraPlane :> RandomInfraPlane[ g, token, UpTo[1] ], token_InfraBall :> RandomInfraBall[ g, token, UpTo[1] ], token_InfraShell :> RandomInfraShell[ g, token, UpTo[1] ], token_InfraSphere :> RandomInfraSphere[ g, token, UpTo[1] ], token_InfraTube :> RandomInfraTube[ g, token, UpTo[1] ], token_InfraCylinder :> RandomInfraCylinder[ g, token, UpTo[1] ], token_InfraCone :> RandomInfraCone[ g, token, UpTo[1] ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token, UpTo[1] ], token_InfraBallHull :> RandomInfraBallHull[ g, token, UpTo[1] ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token, UpTo[1] ], token_InfraQuadric :> RandomInfraQuadric[ g, token, UpTo[1] ], token_InfraWalk :> RandomInfraWalk[ g, token, UpTo[1] ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, UpTo[1] ], token_InfraEllipse :> RandomInfraEllipse[ g, token, UpTo[1] ], token_InfraIntersection :> RandomInfraIntersection[ g, token, UpTo[1] ], token_InfraUnion :> RandomInfraUnion[ g, token, UpTo[1] ], token_InfraRay :> RandomInfraHalfLine[ g, token, UpTo[1] ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, UpTo[1] ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, UpTo[1] ] } ]] === 1}]],
  {True, True, True, True},
  TestID -> "InfraSegment-closed-polyline-random-draw"
]

VerificationTest[
  With[{g3 = GridGraph[{3, 3}]}, {g8 = GridGraph[{8, 8}]}, {obj8 = InfraSegment[1, 64, 1, 2, 1]},
    {g20 = GridGraph[{20, 20}]}, {obj20 = InfraSegment[1, 210, 400, 191, 1]},
    {w8 = BlockRandom[Replace[ obj8, { token_InfraPoint :> RandomInfraPoint[ g8, token ], token_InfraSegment :> RandomInfraSegment[ g8, token ], token_InfraHalfLine :> RandomInfraHalfLine[ g8, token ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g8, token ], token_InfraCircle :> RandomInfraCircle[ g8, token ], token_InfraArc :> RandomInfraArc[ g8, token ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g8, token ], token_InfraPlane :> RandomInfraPlane[ g8, token ], token_InfraBall :> RandomInfraBall[ g8, token ], token_InfraShell :> RandomInfraShell[ g8, token ], token_InfraSphere :> RandomInfraSphere[ g8, token ], token_InfraTube :> RandomInfraTube[ g8, token ], token_InfraCylinder :> RandomInfraCylinder[ g8, token ], token_InfraCone :> RandomInfraCone[ g8, token ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g8, token ], token_InfraBallHull :> RandomInfraBallHull[ g8, token ], token_InfraConvexHull :> RandomInfraConvexHull[ g8, token ], token_InfraQuadric :> RandomInfraQuadric[ g8, token ], token_InfraWalk :> RandomInfraWalk[ g8, token ], token_InfraGeodesic :> RandomInfraGeodesic[ g8, token ], token_InfraEllipse :> RandomInfraEllipse[ g8, token ], token_InfraIntersection :> RandomInfraIntersection[ g8, token ], token_InfraUnion :> RandomInfraUnion[ g8, token ], token_InfraRay :> RandomInfraHalfLine[ g8, token ], token_InfraLine :> RandomInfraInfiniteLine[ g8, token ], token_InfraPolygon :> RandomInfraRegularPolygon[ g8, token ] } ], RandomSeeding -> 12],
     upTo = BlockRandom[Replace[ obj8, { token_InfraPoint :> RandomInfraPoint[ g8, token, UpTo[1] ], token_InfraSegment :> RandomInfraSegment[ g8, token, UpTo[1] ], token_InfraHalfLine :> RandomInfraHalfLine[ g8, token, UpTo[1] ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g8, token, UpTo[1] ], token_InfraCircle :> RandomInfraCircle[ g8, token, UpTo[1] ], token_InfraArc :> RandomInfraArc[ g8, token, UpTo[1] ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g8, token, UpTo[1] ], token_InfraPlane :> RandomInfraPlane[ g8, token, UpTo[1] ], token_InfraBall :> RandomInfraBall[ g8, token, UpTo[1] ], token_InfraShell :> RandomInfraShell[ g8, token, UpTo[1] ], token_InfraSphere :> RandomInfraSphere[ g8, token, UpTo[1] ], token_InfraTube :> RandomInfraTube[ g8, token, UpTo[1] ], token_InfraCylinder :> RandomInfraCylinder[ g8, token, UpTo[1] ], token_InfraCone :> RandomInfraCone[ g8, token, UpTo[1] ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g8, token, UpTo[1] ], token_InfraBallHull :> RandomInfraBallHull[ g8, token, UpTo[1] ], token_InfraConvexHull :> RandomInfraConvexHull[ g8, token, UpTo[1] ], token_InfraQuadric :> RandomInfraQuadric[ g8, token, UpTo[1] ], token_InfraWalk :> RandomInfraWalk[ g8, token, UpTo[1] ], token_InfraGeodesic :> RandomInfraGeodesic[ g8, token, UpTo[1] ], token_InfraEllipse :> RandomInfraEllipse[ g8, token, UpTo[1] ], token_InfraIntersection :> RandomInfraIntersection[ g8, token, UpTo[1] ], token_InfraUnion :> RandomInfraUnion[ g8, token, UpTo[1] ], token_InfraRay :> RandomInfraHalfLine[ g8, token, UpTo[1] ], token_InfraLine :> RandomInfraInfiniteLine[ g8, token, UpTo[1] ], token_InfraPolygon :> RandomInfraRegularPolygon[ g8, token, UpTo[1] ] } ], RandomSeeding -> 12],
     w20 = Replace[ obj20, { token_InfraPoint :> RandomInfraPoint[ g20, token ], token_InfraSegment :> RandomInfraSegment[ g20, token ], token_InfraHalfLine :> RandomInfraHalfLine[ g20, token ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g20, token ], token_InfraCircle :> RandomInfraCircle[ g20, token ], token_InfraArc :> RandomInfraArc[ g20, token ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g20, token ], token_InfraPlane :> RandomInfraPlane[ g20, token ], token_InfraBall :> RandomInfraBall[ g20, token ], token_InfraShell :> RandomInfraShell[ g20, token ], token_InfraSphere :> RandomInfraSphere[ g20, token ], token_InfraTube :> RandomInfraTube[ g20, token ], token_InfraCylinder :> RandomInfraCylinder[ g20, token ], token_InfraCone :> RandomInfraCone[ g20, token ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g20, token ], token_InfraBallHull :> RandomInfraBallHull[ g20, token ], token_InfraConvexHull :> RandomInfraConvexHull[ g20, token ], token_InfraQuadric :> RandomInfraQuadric[ g20, token ], token_InfraWalk :> RandomInfraWalk[ g20, token ], token_InfraGeodesic :> RandomInfraGeodesic[ g20, token ], token_InfraEllipse :> RandomInfraEllipse[ g20, token ], token_InfraIntersection :> RandomInfraIntersection[ g20, token ], token_InfraUnion :> RandomInfraUnion[ g20, token ], token_InfraRay :> RandomInfraHalfLine[ g20, token ], token_InfraLine :> RandomInfraInfiniteLine[ g20, token ], token_InfraPolygon :> RandomInfraRegularPolygon[ g20, token ] } ]},
    {RandomInfraSegment[ g3, InfraSegment[1, 2, 1], "NextVertexFunction" -> Identity ],
     w8 === First[upTo], InfraMemberQ[g8, obj8, w8], InfraMemberQ[g20, obj20, w20]}],
  {{1, 2, 1}, True, True, True},
  TestID -> "InfraSegment-closed-polyline-witness-fallback-and-scale"
]

(* a bounded count reads the first members of the product of the sides: the 4x4 grid square
   1, 16, 1, 16 has 20^4 members, and fifty of them come without forming the class *)
VerificationTest[
  With[{g = GridGraph[{4, 4}], obj = InfraSegment[1, 16, 1, 16, 1]},
    {members = Replace[ obj, { token_InfraPoint :> RandomInfraPoint[ g, token, 50 ], token_InfraSegment :> RandomInfraSegment[ g, token, 50 ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, 50 ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, 50 ], token_InfraCircle :> RandomInfraCircle[ g, token, 50 ], token_InfraArc :> RandomInfraArc[ g, token, 50 ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, 50 ], token_InfraPlane :> RandomInfraPlane[ g, token, 50 ], token_InfraBall :> RandomInfraBall[ g, token, 50 ], token_InfraShell :> RandomInfraShell[ g, token, 50 ], token_InfraSphere :> RandomInfraSphere[ g, token, 50 ], token_InfraTube :> RandomInfraTube[ g, token, 50 ], token_InfraCylinder :> RandomInfraCylinder[ g, token, 50 ], token_InfraCone :> RandomInfraCone[ g, token, 50 ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token, 50 ], token_InfraBallHull :> RandomInfraBallHull[ g, token, 50 ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token, 50 ], token_InfraQuadric :> RandomInfraQuadric[ g, token, 50 ], token_InfraWalk :> RandomInfraWalk[ g, token, 50 ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, 50 ], token_InfraEllipse :> RandomInfraEllipse[ g, token, 50 ], token_InfraIntersection :> RandomInfraIntersection[ g, token, 50 ], token_InfraUnion :> RandomInfraUnion[ g, token, 50 ], token_InfraRay :> RandomInfraHalfLine[ g, token, 50 ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, 50 ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, 50 ] } ]},
    {InfraMeasurement[g, obj, "Cardinality"], Length[members], DuplicateFreeQ[members],
     AllTrue[members, InfraMemberQ[g, obj, #] &],
     AllTrue[BlockRandom[Replace[ obj, { token_InfraPoint :> RandomInfraPoint[ g, token, 5, "NextVertexFunction" -> RandomChoice ], token_InfraSegment :> RandomInfraSegment[ g, token, 5, "NextVertexFunction" -> RandomChoice ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, 5, "NextVertexFunction" -> RandomChoice ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, 5, "NextVertexFunction" -> RandomChoice ], token_InfraCircle :> RandomInfraCircle[ g, token, 5, "NextVertexFunction" -> RandomChoice ], token_InfraArc :> RandomInfraArc[ g, token, 5, "NextVertexFunction" -> RandomChoice ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, 5, "NextVertexFunction" -> RandomChoice ], token_InfraPlane :> RandomInfraPlane[ g, token, 5, "NextVertexFunction" -> RandomChoice ], token_InfraBall :> RandomInfraBall[ g, token, 5, "NextVertexFunction" -> RandomChoice ], token_InfraShell :> RandomInfraShell[ g, token, 5, "NextVertexFunction" -> RandomChoice ], token_InfraSphere :> RandomInfraSphere[ g, token, 5, "NextVertexFunction" -> RandomChoice ], token_InfraTube :> RandomInfraTube[ g, token, 5, "NextVertexFunction" -> RandomChoice ], token_InfraCylinder :> RandomInfraCylinder[ g, token, 5, "NextVertexFunction" -> RandomChoice ], token_InfraCone :> RandomInfraCone[ g, token, 5, "NextVertexFunction" -> RandomChoice ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token, 5, "NextVertexFunction" -> RandomChoice ], token_InfraBallHull :> RandomInfraBallHull[ g, token, 5, "NextVertexFunction" -> RandomChoice ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token, 5, "NextVertexFunction" -> RandomChoice ], token_InfraQuadric :> RandomInfraQuadric[ g, token, 5, "NextVertexFunction" -> RandomChoice ], token_InfraWalk :> RandomInfraWalk[ g, token, 5, "NextVertexFunction" -> RandomChoice ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, 5, "NextVertexFunction" -> RandomChoice ], token_InfraEllipse :> RandomInfraEllipse[ g, token, 5, "NextVertexFunction" -> RandomChoice ], token_InfraIntersection :> RandomInfraIntersection[ g, token, 5, "NextVertexFunction" -> RandomChoice ], token_InfraUnion :> RandomInfraUnion[ g, token, 5, "NextVertexFunction" -> RandomChoice ], token_InfraRay :> RandomInfraHalfLine[ g, token, 5, "NextVertexFunction" -> RandomChoice ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, 5, "NextVertexFunction" -> RandomChoice ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, 5, "NextVertexFunction" -> RandomChoice ] } ],
       RandomSeeding -> 1], InfraMemberQ[g, obj, #] &]}],
  {160000, 50, True, True, True},
  TestID -> "InfraSegment-closed-polyline-bounded-count"
]

(* the segment from a point back to itself is no polygon: the one-vertex walk *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    {RandomInfraSegment[ g, InfraSegment[5, 5], All ], InfraMeasurement[g, InfraSegment[5, 5], "VertexDensity"]}],
  {{{5}}, <|5 -> 1|>},
  TestID -> "InfraSegment-point-to-itself-is-not-a-polygon"
]

(* ===== RandomInfraSegment: the independent search ===== *)

(* the search and the graph agree on the whole class *)
VerificationTest[
  AllTrue[
    {{GridGraph[{4, 4}], 1, 16}, {CycleGraph[6], 1, 4}, {HypercubeGraph[4], 1, 16}, {PetersenGraph[], 1, 3}},
    Apply[{g, p, q} |->
      Sort[RandomInfraSegment[g, p, q, All]] === Sort[RandomInfraSegment[ g, InfraSegment[p, q], All ]]]],
  True,
  TestID -> "RandomInfraSegment-agrees-with-the-graph"
]

(* the count contract: one geodesic, a List under a count, the class under All *)
VerificationTest[
  With[{g = CycleGraph[6]},
    {InfraSegmentQ[g, RandomInfraSegment[g, 1, 4]],
     Length[RandomInfraSegment[g, 1, 4, 2]], Length[RandomInfraSegment[g, 1, 4, UpTo[9]]],
     RandomInfraSegment[g, 1, 4, 5]}],
  {True, 2, 2, { }},
  TestID -> "RandomInfraSegment-count-contract"
]

(* unreachable endpoints have no geodesic *)
VerificationTest[
  With[{g = Graph[{1, 2}, {}]}, {RandomInfraSegment[g, 1, 2], RandomInfraSegment[g, 1, 2, All]}],
  {{}, {}},
  TestID -> "RandomInfraSegment-disconnected-endpoints"
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
  RandomInfraSegment[GridGraph[{3, 3}], 5, 5, All],
  {{5}},
  TestID -> "RandomInfraSegment-same-point"
]

VerificationTest[
  InfraMeasurement[ PathGraph[ Range[ 7 ] ], InfraSegment[ 1, 7 ], "Midpoint" ],
  <| 4 -> 1 |>,
  TestID -> "Midpoint-path"
]

VerificationTest[
  InfraMeasurement[ GridGraph[ { 5, 5 } ], InfraSegment[ 1, 25 ], "Midpoint" ],
  <| 5 -> 1, 9 -> 16, 13 -> 36, 17 -> 16, 21 -> 1 |>,
  TestID -> "Midpoint-grid"
]

VerificationTest[
  InfraMeasurement[ CycleGraph[ 8 ], InfraSegment[ 1, 5 ], "Midpoint" ],
  <| 3 -> 1, 7 -> 1 |>,
  TestID -> "Midpoint-cycle"
]

VerificationTest[
  InfraMeasurement[ PathGraph[ Range[ 5 ] ], InfraSegment[ 2, 2 ], "Midpoint" ],
  <| 2 -> 1 |>,
  TestID -> "Midpoint-degenerate"
]

VerificationTest[
  InfraMeasurement[ PathGraph[ Range[ 6 ] ], InfraSegment[ 1, 6 ], "Midpoint" ],
  <| 3 -> 1, 4 -> 1 |>,
  TestID -> "Midpoint-odd-distance-central-pair"
]

VerificationTest[
  InfraMeasurement[ Graph[ { 1 <-> 2, 3 <-> 4 } ], InfraSegment[ 1, 4 ], "Midpoint" ],
  <| |>,
  TestID -> "Midpoint-disconnected-anchors"
]

VerificationTest[
  InfraMeasurement[ PathGraph[ Range[ 7 ] ], InfraSegment[ { 1, 2 }, { 6, 7 } ], "Midpoint" ],
  <| 4 -> 1 |>,
  TestID -> "Midpoint-list-anchors-set-distance"
]

VerificationTest[
  With[ { graph = GridGraph[ { 5, 5 } ] },
    { interval = Select[ VertexList @ graph,
        v |-> GraphDistance[ graph, 1, v ] + GraphDistance[ graph, v, 25 ] == GraphDistance[ graph, 1, 25 ] ] },
    Sort @ Keys @ InfraMeasurement[ graph, InfraSegment[ 1, 25 ], "Midpoint" ] ===
      Sort @ MinimalBy[ interval, v |-> Max[ GraphDistance[ graph, 1, v ], GraphDistance[ graph, v, 25 ] ] ] ],
  True,
  TestID -> "Midpoint-is-centre-of-interval"
]

VerificationTest[
  Table[
    With[ { graph = InfraSubstrate[ name, "Large", "KeepCoordinates" -> True ] },
      { a = First @ GraphCenter[ graph ] },
      { b = First @ Sort @ Select[ VertexList @ graph, v |-> GraphDistance[ graph, a, v ] == 6 ] },
      { GraphDistance[ graph, a, b ], Length @ InfraMeasurement[ graph, InfraSegment[ a, b ], "Midpoint" ] } ],
    { name, { "SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph" } } ],
  { { 6, 2 }, { 6, 3 }, { 6, 2 } },
  TestID -> "Midpoint-historical-distance-six-support-counts"
]

VerificationTest[
  InfraMeasurement[ PathGraph[ { { 1, 2 }, { 3, 4 }, { 5, 6 } } ],
    InfraSegment[ { 1, 2 }, { 5, 6 } ], "Midpoint" ],
  <| { 3, 4 } -> 1 |>,
  TestID -> "Midpoint-list-valued-vertices-are-single-anchors"
]

VerificationTest[
  Table[
    With[ { graph = InfraSubstrate[ name, "Large", "KeepCoordinates" -> True ] },
      { a = First @ GraphCenter[ graph ] },
      { b = First @ Sort @ Select[ VertexList @ graph, v |-> GraphDistance[ graph, a, v ] == 6 ] },
      InfraMeasurement[ graph, InfraSegment[ a, b ], "Midpoint" ] ],
    { name, { "SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph" } } ],
  { <| 23 -> 2, 199 -> 2 |>, <| 8 -> 3, 10 -> 9, 21 -> 3 |>, <| 11 -> 2, 13 -> 1 |> },
  TestID -> "Midpoint-historical-default-densities"
]

EndTestSection[]
