BeginTestSection["InfraMeasurement"]

(* ===== the counts on the graph are the counts of the members ===== *)

(* the cardinality is the number of members, and the members are the geodesics *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    {InfraMeasurement[g, InfraSegment[1, 9], "Cardinality"],
     Length[RandomInfraSegment[ g, InfraSegment[1, 9], All ]],
     Length[FindPath[g, 1, 9, {4}, All]]}],
  {6, 6, 6},
  TestID -> "InfraMeasurement-Cardinality-counts-the-members"
]

(* the vertex density counts the members through each vertex *)
VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    InfraMeasurement[g, InfraSegment[1, 16], "VertexDensity"] ===
      KeySort[Counts[Catenate[RandomInfraSegment[ g, InfraSegment[1, 16], All ]]]]],
  True,
  TestID -> "InfraMeasurement-VertexDensity-is-the-occupation"
]

(* the edge density counts the members through each arrow *)
VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    {members = RandomInfraSegment[ g, InfraSegment[1, 16], All ]},
    InfraMeasurement[g, InfraSegment[1, 16], "EdgeDensity"] ===
      KeySort[Counts[Catenate[Apply[DirectedEdge, Partition[#, 2, 1], {1}] & /@ members]]]],
  True,
  TestID -> "InfraMeasurement-EdgeDensity-is-the-arrow-occupation"
]

(* every member of a segment has the same length, and the total edge mass is length times count *)
VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    {InfraMeasurement[g, InfraSegment[1, 16], "Length"] === GraphDistance[g, 1, 16],
     Total[InfraMeasurement[g, InfraSegment[1, 16], "EdgeDensity"]] ==
       InfraMeasurement[g, InfraSegment[1, 16], "Length"] InfraMeasurement[g, InfraSegment[1, 16], "Cardinality"]}],
  {True, True},
  TestID -> "InfraMeasurement-Length-and-total-edge-mass"
]

(* the rays out of a vertex may end on several layers, and then the length is the list of the
   lengths present; one number when the members share it *)
VerificationTest[
  {InfraMeasurement[PathGraph[Range[7]], InfraRay[3, 3], "Length"],
   InfraMeasurement[GridGraph[{3, 3}], InfraRay[5, 5], "Length"]},
  {{2, 4}, 2},
  TestID -> "InfraMeasurement-Length-lists-differing-lengths"
]

(* ===== the two measures of the support ===== *)

(* a row of the 3 x 3 grid: every vertex of it has a neighbour outside *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    InfraMeasurement[g, InfraSegment[1, 3], {"CountingMeasure", "RiemannianMeasure"}]],
  <|"CountingMeasure" -> 3, "RiemannianMeasure" -> 0|>,
  TestID -> "InfraMeasurement-measures-of-a-boundary-row"
]

(* the interval from corner to corner fills the grid, so nothing of it touches the outside *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    InfraMeasurement[g, InfraSegment[1, 9], {"CountingMeasure", "RiemannianMeasure"}]],
  <|"CountingMeasure" -> 9, "RiemannianMeasure" -> 9|>,
  TestID -> "InfraMeasurement-measures-of-a-filling-interval"
]

(* ===== a List of region heads reads off one distance matrix what the heads read one by one ===== *)

(* balls, shells, bands, tubes about a vertex, a set and a segment, under the three readings; a list holding a sliced solid or a profile is
   read head by head *)
VerificationTest[
  With[{g = GridGraph[{7, 7}],
        regions = {InfraBall[25, 2], InfraBall[25, 2.5], InfraBall[{1, 49}, 3], InfraShell[25, 3], InfraShell[25, {1, 2}],
          InfraBall[25, {1.5, 3}], InfraTube[25, 1], InfraTube[{1, 49}, 2], InfraTube[InfraSegment[1, 49], 1],
          InfraTube[InfraSegment[25, 3], {1, 2}]},
        solids = {InfraCylinder[Range[8, 14], 1], InfraCone[{1, 9, 17, 25}, 1], InfraTube[{1, 9, 17}, {0, 1, 2}]}},
    Table[{InfraMeasurement[g, regions, prop] === (InfraMeasurement[g, #, prop] & /@ regions),
        InfraMeasurement[g, Join[regions, solids], prop] === (InfraMeasurement[g, #, prop] & /@ Join[regions, solids])},
      {prop, {"VertexDensity", "CountingMeasure", "RiemannianMeasure"}}]],
  ConstantArray[True, {3, 2}],
  TestID -> "InfraMeasurement-region-list-agrees-with-the-heads"
]

(* a segment between components has no interval, so its tube is empty; the other component is out of every ball *)
VerificationTest[
  With[{g = Graph[{1 <-> 2, 2 <-> 3, 4 <-> 5}]},
    InfraMeasurement[g, {InfraTube[InfraSegment[1, 4], 1], InfraBall[1, 5], InfraShell[4, 1]}, "CountingMeasure"]],
  {0, 3, 1},
  TestID -> "InfraMeasurement-region-list-on-a-disconnected-graph"
]

(* ===== faithfulness ===== *)

(* segments, rays and lines carry a theorem; circles and arcs need (W), and this band of the circle is cut by its seam into pieces *)
VerificationTest[
  Replace[
    With[{g = GridGraph[{5, 5}]},
    InfraMeasurement[g, #, "Faithful"] & /@
      {InfraSegment[1, 25], InfraRay[1, 2], InfraLine[1, 2], InfraCircle[13, 3], InfraArc[13, {3, 11}]}],
    HoldPattern[ InfraMeasurement[ _Graph, _, "Faithful" ] ] :> Missing[ "NotCertified" ], { 0, Infinity } ],
  {True, True, True, Missing[ "NotCertified" ], Missing[ "NotCertified" ]},
  TestID -> "InfraMeasurement-Faithful-per-head"
]

(* ===== the calling shapes ===== *)

(* a list of properties gives an association, All gives every property *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    {Keys[InfraMeasurement[g, InfraSegment[1, 9], {"Length", "Cardinality"}]],
     Keys[InfraMeasurement[g, InfraSegment[1, 9], All]]}],
  {{"Length", "Cardinality"},
   {"Graph", "Faithful", "Cardinality", "Length", "VertexDensity", "EdgeDensity", "Subgraph",
    "CountingMeasure", "RiemannianMeasure"}},
  TestID -> "InfraMeasurement-property-list-and-All"
]

(* a list of heads measures each *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    InfraMeasurement[g, {InfraSegment[1, 3], InfraSegment[1, 9]}, "Cardinality"]],
  {1, 6},
  TestID -> "InfraMeasurement-list-of-heads"
]

(* ===== NamedConstructionSampler: the count contract ===== *)

(* the default draw changes with the random state, and a seed makes it reproducible *)
VerificationTest[
  With[{g = GridGraph[{3, 3}], obj = InfraSegment[1, 9]},
    With[{draws = BlockRandom[Table[Replace[ obj, { token_InfraPoint :> RandomInfraPoint[ g, token, RandomSeeding -> None ], token_InfraSegment :> RandomInfraSegment[ g, token, RandomSeeding -> None ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, RandomSeeding -> None ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, RandomSeeding -> None ], token_InfraCircle :> RandomInfraCircle[ g, token, RandomSeeding -> None ], token_InfraArc :> RandomInfraArc[ g, token, RandomSeeding -> None ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, RandomSeeding -> None ], token_InfraPlane :> RandomInfraPlane[ g, token, RandomSeeding -> None ], token_InfraBall :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraShell :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraSphere :> RandomInfraSphere[ g, token, RandomSeeding -> None ], token_InfraTube :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraCylinder :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraCone :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraSolidOfRevolution :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraBallHull :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraConvexHull :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraQuadric :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraWalk :> RandomInfraWalk[ g, token, RandomSeeding -> None ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, RandomSeeding -> None ], token_InfraEllipse :> RandomInfraEllipse[ g, token, RandomSeeding -> None ], token_InfraIntersection :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraUnion :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraRay :> RandomInfraHalfLine[ g, token, RandomSeeding -> None ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, RandomSeeding -> None ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, RandomSeeding -> None ] } ], {10}], RandomSeeding -> 1]},
      {draws === BlockRandom[Table[Replace[ obj, { token_InfraPoint :> RandomInfraPoint[ g, token, RandomSeeding -> None ], token_InfraSegment :> RandomInfraSegment[ g, token, RandomSeeding -> None ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, RandomSeeding -> None ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, RandomSeeding -> None ], token_InfraCircle :> RandomInfraCircle[ g, token, RandomSeeding -> None ], token_InfraArc :> RandomInfraArc[ g, token, RandomSeeding -> None ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, RandomSeeding -> None ], token_InfraPlane :> RandomInfraPlane[ g, token, RandomSeeding -> None ], token_InfraBall :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraShell :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraSphere :> RandomInfraSphere[ g, token, RandomSeeding -> None ], token_InfraTube :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraCylinder :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraCone :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraSolidOfRevolution :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraBallHull :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraConvexHull :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraQuadric :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraWalk :> RandomInfraWalk[ g, token, RandomSeeding -> None ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, RandomSeeding -> None ], token_InfraEllipse :> RandomInfraEllipse[ g, token, RandomSeeding -> None ], token_InfraIntersection :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraUnion :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraRay :> RandomInfraHalfLine[ g, token, RandomSeeding -> None ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, RandomSeeding -> None ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, RandomSeeding -> None ] } ], {10}], RandomSeeding -> 1],
       Length[DeleteDuplicates[draws]] > 1}]],
  {True, True},
  TestID -> "NamedConstructionSampler-default-draw-is-random-and-seeded"
]

(* a finite draw contains distinct members, and UpTo exhausts a smaller class *)
VerificationTest[
  With[{g = GridGraph[{3, 3}], obj = InfraSegment[1, 9]},
    {members = BlockRandom[Replace[ obj, { token_InfraPoint :> RandomInfraPoint[ g, token, 3, RandomSeeding -> None ], token_InfraSegment :> RandomInfraSegment[ g, token, 3, RandomSeeding -> None ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, 3, RandomSeeding -> None ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, 3, RandomSeeding -> None ], token_InfraCircle :> RandomInfraCircle[ g, token, 3, RandomSeeding -> None ], token_InfraArc :> RandomInfraArc[ g, token, 3, RandomSeeding -> None ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, 3, RandomSeeding -> None ], token_InfraPlane :> RandomInfraPlane[ g, token, 3, RandomSeeding -> None ], token_InfraBall :> { }, token_InfraShell :> { }, token_InfraSphere :> RandomInfraSphere[ g, token, 3, RandomSeeding -> None ], token_InfraTube :> { }, token_InfraCylinder :> { }, token_InfraCone :> { }, token_InfraSolidOfRevolution :> { }, token_InfraBallHull :> { }, token_InfraConvexHull :> { }, token_InfraQuadric :> { }, token_InfraWalk :> RandomInfraWalk[ g, token, 3, RandomSeeding -> None ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, 3, RandomSeeding -> None ], token_InfraEllipse :> RandomInfraEllipse[ g, token, 3, RandomSeeding -> None ], token_InfraIntersection :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraUnion :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraRay :> RandomInfraHalfLine[ g, token, 3, RandomSeeding -> None ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, 3, RandomSeeding -> None ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, 3, RandomSeeding -> None ] } ], RandomSeeding -> 9],
     upTo = BlockRandom[Replace[ obj, { token_InfraPoint :> RandomInfraPoint[ g, token, UpTo[100], RandomSeeding -> None ], token_InfraSegment :> RandomInfraSegment[ g, token, UpTo[100], RandomSeeding -> None ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, UpTo[100], RandomSeeding -> None ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, UpTo[100], RandomSeeding -> None ], token_InfraCircle :> RandomInfraCircle[ g, token, UpTo[100], RandomSeeding -> None ], token_InfraArc :> RandomInfraArc[ g, token, UpTo[100], RandomSeeding -> None ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, UpTo[100], RandomSeeding -> None ], token_InfraPlane :> RandomInfraPlane[ g, token, UpTo[100], RandomSeeding -> None ], token_InfraBall :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraShell :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraSphere :> RandomInfraSphere[ g, token, UpTo[100], RandomSeeding -> None ], token_InfraTube :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraCylinder :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraCone :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraSolidOfRevolution :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraBallHull :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraConvexHull :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraQuadric :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraWalk :> RandomInfraWalk[ g, token, UpTo[100], RandomSeeding -> None ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, UpTo[100], RandomSeeding -> None ], token_InfraEllipse :> RandomInfraEllipse[ g, token, UpTo[100], RandomSeeding -> None ], token_InfraIntersection :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraUnion :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraRay :> RandomInfraHalfLine[ g, token, UpTo[100], RandomSeeding -> None ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, UpTo[100], RandomSeeding -> None ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, UpTo[100], RandomSeeding -> None ] } ], RandomSeeding -> 9]},
    {Length[members], DuplicateFreeQ[members], AllTrue[members, InfraMemberQ[g, obj, #] &],
     Length[upTo], DuplicateFreeQ[upTo], Sort[upTo] === Sort[FindPath[g, 1, 9, {4}, All]]}],
  {3, True, True, 6, True, True},
  TestID -> "NamedConstructionSampler-counts-are-distinct-and-UpTo-exhausts"
]

(* All keeps the enumeration order; Identity keeps the old first member *)
VerificationTest[
  With[{g = GridGraph[{3, 3}], obj = InfraSegment[1, 9]},
    {paths = Replace[ obj, { token_InfraPoint :> RandomInfraPoint[ g, token, All ], token_InfraSegment :> RandomInfraSegment[ g, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraCircle :> RandomInfraCircle[ g, token, All ], token_InfraArc :> RandomInfraArc[ g, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All ], token_InfraPlane :> RandomInfraPlane[ g, token, All ], token_InfraBall :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraShell :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraSphere :> RandomInfraSphere[ g, token, All ], token_InfraTube :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraCylinder :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraCone :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraSolidOfRevolution :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraBallHull :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraConvexHull :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraQuadric :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraWalk :> RandomInfraWalk[ g, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All ], token_InfraIntersection :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraUnion :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraRay :> RandomInfraHalfLine[ g, token, All ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, All ] } ]},
    {paths === Sort[FindPath[g, 1, 9, {4}, All]],
     Replace[ obj, { token_InfraPoint :> RandomInfraPoint[ g, token, All, "NextVertexFunction" -> Identity ], token_InfraSegment :> RandomInfraSegment[ g, token, All, "NextVertexFunction" -> Identity ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All, "NextVertexFunction" -> Identity ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All, "NextVertexFunction" -> Identity ], token_InfraCircle :> RandomInfraCircle[ g, token, All, "NextVertexFunction" -> Identity ], token_InfraArc :> RandomInfraArc[ g, token, All, "NextVertexFunction" -> Identity ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All, "NextVertexFunction" -> Identity ], token_InfraPlane :> RandomInfraPlane[ g, token, All, "NextVertexFunction" -> Identity ], token_InfraBall :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraShell :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraSphere :> RandomInfraSphere[ g, token, All, "NextVertexFunction" -> Identity ], token_InfraTube :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraCylinder :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraCone :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraSolidOfRevolution :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraBallHull :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraConvexHull :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraQuadric :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraWalk :> RandomInfraWalk[ g, token, All, "NextVertexFunction" -> Identity ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All, "NextVertexFunction" -> Identity ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All, "NextVertexFunction" -> Identity ], token_InfraIntersection :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraUnion :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraRay :> RandomInfraHalfLine[ g, token, All, "NextVertexFunction" -> Identity ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, All, "NextVertexFunction" -> Identity ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, All, "NextVertexFunction" -> Identity ] } ] === paths,
     Replace[ obj, { token_InfraPoint :> RandomInfraPoint[ g, token, "NextVertexFunction" -> Identity ], token_InfraSegment :> RandomInfraSegment[ g, token, "NextVertexFunction" -> Identity ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, "NextVertexFunction" -> Identity ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, "NextVertexFunction" -> Identity ], token_InfraCircle :> RandomInfraCircle[ g, token, "NextVertexFunction" -> Identity ], token_InfraArc :> RandomInfraArc[ g, token, "NextVertexFunction" -> Identity ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, "NextVertexFunction" -> Identity ], token_InfraPlane :> RandomInfraPlane[ g, token, "NextVertexFunction" -> Identity ], token_InfraBall :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraShell :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraSphere :> RandomInfraSphere[ g, token, "NextVertexFunction" -> Identity ], token_InfraTube :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraCylinder :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraCone :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraSolidOfRevolution :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraBallHull :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraConvexHull :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraQuadric :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraWalk :> RandomInfraWalk[ g, token, "NextVertexFunction" -> Identity ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, "NextVertexFunction" -> Identity ], token_InfraEllipse :> RandomInfraEllipse[ g, token, "NextVertexFunction" -> Identity ], token_InfraIntersection :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraUnion :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraRay :> RandomInfraHalfLine[ g, token, "NextVertexFunction" -> Identity ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, "NextVertexFunction" -> Identity ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, "NextVertexFunction" -> Identity ] } ] === First[paths]}],
  {True, True, True},
  TestID -> "NamedConstructionSampler-All-and-Identity-are-deterministic"
]

(* strict counts return no result when there are too few members *)
VerificationTest[
  RandomInfraSegment[ CycleGraph[6], InfraSegment[1, 4], 3 ],
  { },
  TestID -> "NamedConstructionSampler-strict-shortfall"
]

(* an empty family gives the empty shape *)
VerificationTest[
  With[{g = Graph[{1, 2}, {}]},
    {RandomInfraSegment[ g, InfraSegment[1, 2] ], RandomInfraSegment[ g, InfraSegment[1, 2], All ],
     InfraMeasurement[g, InfraSegment[1, 2], "Cardinality"]}],
  {{}, {}, 0},
  TestID -> "NamedConstructionSampler-empty-family"
]

(* a vertex is its own segment *)
VerificationTest[
  RandomInfraSegment[ GridGraph[{3, 3}], InfraSegment[5, 5], All ],
  {{5}},
  TestID -> "NamedConstructionSampler-degenerate-segment"
]

(* ===== InfraMemberQ ===== *)

VerificationTest[
  With[{g = GridGraph[{3, 3}]}, {obj = InfraSegment[1, 9]},
    {AllTrue[Replace[ obj, { token_InfraPoint :> RandomInfraPoint[ g, token, All ], token_InfraSegment :> RandomInfraSegment[ g, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraCircle :> RandomInfraCircle[ g, token, All ], token_InfraArc :> RandomInfraArc[ g, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All ], token_InfraPlane :> RandomInfraPlane[ g, token, All ], token_InfraBall :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraShell :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraSphere :> RandomInfraSphere[ g, token, All ], token_InfraTube :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraCylinder :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraCone :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraSolidOfRevolution :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraBallHull :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraConvexHull :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraQuadric :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraWalk :> RandomInfraWalk[ g, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All ], token_InfraIntersection :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraUnion :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraRay :> RandomInfraHalfLine[ g, token, All ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, All ] } ], InfraMemberQ[g, obj, #] &],
     InfraMemberQ[g, obj, {1, 2, 5}],
     InfraMemberQ[g, obj, {1, 2, 3, 6, 5, 8, 9}]}],
  {True, False, False},
  TestID -> "InfraMemberQ-accepts-exactly-the-members"
]

(* ===== support and thickening ===== *)

VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    {Sort[VertexList[InfraMeasurement[g, InfraSegment[1, 3], "Subgraph"]]],
     Sort[VertexList[NeighborhoodGraph[g, Keys @ InfraMeasurement[g, InfraSegment[1, 3], "VertexDensity"], 1]]]}],
  {{1, 2, 3}, {1, 2, 3, 4, 5, 6}},
  TestID -> "InfraMeasurement-support-and-built-in-thickening"
]

(* ===== list-valued vertex labels ===== *)

(* a vertex label may itself be a List, so every lookup goes through Key *)
VerificationTest[
  With[{g = Graph[Map[{Quotient[# - 1, 3] + 1, Mod[# - 1, 3] + 1} &, EdgeList[GridGraph[{3, 3}]], {2}]]},
    {obj = InfraSegment[{1, 1}, {3, 3}]},
    {InfraMeasurement[g, obj, "Cardinality"], Length[Replace[ obj, { token_InfraPoint :> RandomInfraPoint[ g, token, All ], token_InfraSegment :> RandomInfraSegment[ g, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraCircle :> RandomInfraCircle[ g, token, All ], token_InfraArc :> RandomInfraArc[ g, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All ], token_InfraPlane :> RandomInfraPlane[ g, token, All ], token_InfraBall :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraShell :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraSphere :> RandomInfraSphere[ g, token, All ], token_InfraTube :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraCylinder :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraCone :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraSolidOfRevolution :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraBallHull :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraConvexHull :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraQuadric :> { Keys @ InfraMeasurement[ g, token, "VertexDensity" ] }, token_InfraWalk :> RandomInfraWalk[ g, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All ], token_InfraIntersection :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraUnion :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraRay :> RandomInfraHalfLine[ g, token, All ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, All ] } ]],
     Lookup[InfraMeasurement[g, obj, "VertexDensity"], Key[{2, 2}]]}],
  {6, 6, 4},
  TestID -> "InfraMeasurement-list-valued-vertex-labels"
]

(* ===== InfraIntersection / InfraUnion ===== *)

(* the meeting point of a segment and a circle: the density counts the pairs (geodesic, circle)
   meeting at v, so it is the product of the two occupations on the common vertices *)
VerificationTest[
  With[{g = GridGraph[{9, 9}], c = 41},
    {seg = InfraSegment[41, 59], cir = InfraCircle[c, {2, 3}]},
    {ds = InfraMeasurement[g, seg, "VertexDensity"],
     dc = InfraMeasurement[g, cir, "VertexDensity"]},
    {meet = InfraMeasurement[g, InfraIntersection[seg, cir], "VertexDensity"]},
    {Keys @ meet === Sort @ Intersection[Keys @ ds, Keys @ dc],
     Values @ meet === (Lookup[ds, Key @ #] Lookup[dc, Key @ #] & /@ Keys @ meet),
     meet =!= <||>}],
  {True, True, True},
  TestID -> "InfraIntersection-segment-meets-circle-density"
]

(* two triangles of the grid meeting at a corner: 3 x 3 geodesics through 8, 6 x 6 through 13 *)
VerificationTest[
  With[{g = GridGraph[{5, 5}]},
    InfraMeasurement[g, InfraIntersection[InfraSegment[1, 13], InfraSegment[5, 13]], "VertexDensity"]],
  <|3 -> 1, 8 -> 9, 13 -> 36|>,
  TestID -> "InfraIntersection-two-triangles-of-the-grid"
]

(* the union takes the joint support and the sum of the occupations *)
VerificationTest[
  With[{g = GridGraph[{5, 5}]},
    {a = InfraSegment[1, 13], b = InfraSegment[13, 25]},
    {both = InfraMeasurement[g, InfraUnion[a, b], "VertexDensity"]},
    both === KeySort @ Merge[{InfraMeasurement[g, a, "VertexDensity"],
                              InfraMeasurement[g, b, "VertexDensity"]}, Total]],
  True,
  TestID -> "InfraUnion-density-is-the-sum"
]

(* so is its edge density, the sum of its parts', for two crossing segments; an intersection has no edge density *)
VerificationTest[
  With[{g = GridGraph[{5, 5}]},
    {a = InfraSegment[1, 25], b = InfraSegment[5, 21]},
    {both = InfraMeasurement[g, InfraUnion[a, b], "EdgeDensity"]},
    {both === KeySort @ Merge[{InfraMeasurement[g, a, "EdgeDensity"],
                               InfraMeasurement[g, b, "EdgeDensity"]}, Total],
     FreeQ[both, _Missing],
     Head @ InfraMeasurement[g, InfraIntersection[a, b], "EdgeDensity"],
     Keys @ InfraMeasurement[g, InfraUnion[a, b], All]}],
  {True, True, InfraMeasurement, {"VertexDensity", "EdgeDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure"}},
  TestID -> "InfraUnion-edge-density-is-the-sum"
]

(* the volumes of an intersection and a union read the same support the density does *)
VerificationTest[
  With[{g = GridGraph[{5, 5}]},
    {a = InfraSegment[1, 13], b = InfraSegment[13, 25]},
    {InfraMeasurement[g, InfraUnion[a, b], "CountingMeasure"] ===
       Length @ Union[Keys @ InfraMeasurement[g, a, "VertexDensity"],
                      Keys @ InfraMeasurement[g, b, "VertexDensity"]],
     InfraMeasurement[g, InfraIntersection[a, b], "CountingMeasure"],
     Sort @ VertexList @ InfraMeasurement[g, InfraIntersection[a, b], "Subgraph"]}],
  {True, 1, {13}},
  TestID -> "InfraIntersection-volumes-off-the-support"
]

(* an intersection has no members, so All lists only the properties it has *)
VerificationTest[
  Keys @ InfraMeasurement[GridGraph[{5, 5}],
    InfraIntersection[InfraSegment[1, 25], InfraSegment[5, 21]], All],
  {"VertexDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure"},
  TestID -> "InfraIntersection-All-lists-its-own-properties"
]

(* a density is its own vertex density, signed or not *)
VerificationTest[
  With[{g = GridGraph[{5, 5}]},
    InfraMeasurement[g, #, "VertexDensity"] & /@ {<|14 -> 1, 12 -> -1|>, <|13 -> 2, 7 -> 1|>}],
  {<|12 -> -1, 14 -> 1|>, <|7 -> 1, 13 -> 2|>},
  TestID -> "InfraMeasurement-density-is-its-own-vertex-density"
]

(* the union of signed densities is the sum, a cancelled mass kept as 0; the difference of two balls is the union with a negative *)
VerificationTest[
  With[{g = GridGraph[{5, 5}]},
    {InfraMeasurement[g, InfraUnion[<|12 -> 1, 13 -> 2|>, <|13 -> -2, 14 -> -1|>], "VertexDensity"],
     InfraMeasurement[g, InfraUnion[InfraBall[12, 1], - InfraMeasurement[g, InfraBall[14, 1], "VertexDensity"]], "VertexDensity"]}],
  {<|12 -> 1, 13 -> 0, 14 -> -1|>, <|7 -> 1, 9 -> -1, 11 -> 1, 12 -> 1, 13 -> 0, 14 -> -1, 15 -> -1, 17 -> 1, 19 -> -1|>},
  TestID -> "InfraUnion-signed-density-is-the-sum"
]

(* the intersection of signed densities is the product on the common support, also beside a region *)
VerificationTest[
  With[{g = GridGraph[{5, 5}]},
    {InfraMeasurement[g, InfraIntersection[<|12 -> 1, 13 -> 2|>, <|13 -> -2, 14 -> -1|>], "VertexDensity"],
     InfraMeasurement[g, InfraIntersection[InfraBall[13, 1], <|13 -> -2, 14 -> -1, 1 -> 5|>], "VertexDensity"]}],
  {<|13 -> -4|>, <|13 -> -2, 14 -> -1|>},
  TestID -> "InfraIntersection-signed-density-is-the-product"
]

(* heads on heads are inert without a graph *)
VerificationTest[
  {InfraIntersection[InfraSegment[1, 5], InfraCircle[1, 2]],
   InfraUnion[InfraSegment[1, 5], InfraCircle[1, 2]]},
  {InfraIntersection[InfraSegment[1, 5], InfraCircle[1, 2]],
   InfraUnion[InfraSegment[1, 5], InfraCircle[1, 2]]},
  TestID -> "InfraIntersection-on-heads-stays-inert"
]

(* a head without a graph is read by its search at the defaults *)
VerificationTest[
  With[{g = GridGraph[{5, 5}]},
    {Keys @ InfraMeasurement[ g, InfraShell[13, 2], "VertexDensity" ] === Keys @ InfraMeasurement[ g, InfraShell[ 13, 2 ], "VertexDensity" ],
     MemberQ[{ Keys @ InfraMeasurement[ g, InfraBall[13, 1], "VertexDensity" ] }, Keys @ InfraMeasurement[ g, InfraBall[13, 1], "VertexDensity" ]],
     RandomInfraPoint[ g, InfraPoint[13], All ],
     RandomInfraWalk[ g, InfraWalk[1, 2, 3] ], RandomInfraWalk[ g, InfraWalk[1, 3], All ],
     Length @ { Keys @ InfraMeasurement[ g, InfraShell[13, 2], "VertexDensity" ] }}],
  {True, True, {13}, {1, 2, 3}, {}, 1},
  TestID -> "NamedConstructionSampler-token-heads-read-by-their-searches"
]

(* a scene circle reads its second argument as a radius, the head as a point *)
VerificationTest[
  With[{g = GridGraph[{7, 7}]},
    {({ graph, token } |-> ( instance |-> instance[[ 1 ]][ syntheticTarget ] ) /@ RandomInfraSceneInstance[ InfraScene[ { syntheticTarget }, { syntheticTarget == token } ], graph, All ])[g, InfraCircle[25, {2, 3}]] ===
       RandomInfraCircle[ g, InfraCircle[25, {2, 3}], All ],
     ({ graph, token } |-> ( instance |-> instance[[ 1 ]][ syntheticTarget ] ) /@ RandomInfraSceneInstance[ InfraScene[ { syntheticTarget }, { syntheticTarget == token } ], graph, All ])[g, InfraCircle[25, {2, 3}, "Branches" -> 1]] ===
       RandomInfraCircle[ g, InfraCircle[25, {2, 3}], UpTo[1] ]}],
  {True, True},
  TestID -> "NamedConstructionSampler-scene-circle-is-by-radius"
]

(* the circle and the closed arc carry the two measures through the support of their vertex density, like every head;
   the band {2, 3} is thin, so every vertex of its circle touches the complement *)
VerificationTest[
  With[{g = GridGraph[{9, 9}]},
    {circle = InfraCircle[41, {2, 3}], closed = InfraArc[41, {23, 23}, "RadiusDelta" -> 1]},
    {InfraMeasurement[g, circle, "CountingMeasure"] === Length @ InfraMeasurement[g, circle, "VertexDensity"],
     KeyTake[InfraMeasurement[g, circle, All], {"CountingMeasure", "RiemannianMeasure"}],
     InfraMeasurement[g, closed, {"CountingMeasure", "RiemannianMeasure"}]}],
  {True, <|"CountingMeasure" -> 16, "RiemannianMeasure" -> 0|>, <|"CountingMeasure" -> 16, "RiemannianMeasure" -> 0|>},
  TestID -> "InfraMeasurement-two-measures-on-circle-and-closed-arc"
]


geodesicGraph = vertices |-> PathGraph[ vertices, DirectedEdges -> True ];
g33 = GridGraph[ { 3, 3 } ];


(* ===================== InfraMeasurement ===================== *)

(* InfraMeasurement is the marginal of any shape to the vertex set with respect to the
   counting measure -- the anchor rule made public.  Raw masses, not a normalisation:
   Total, Merge, KeyMap and KeySelect are the density's own algebra, and dividing by
   Total is the caller's one-liner.  A family of two sets: the shared vertices carry 2 *)
VerificationTest[
  InfraMeasurement[ g33, { { 1, 2, 3 }, { 2, 3, 4 } }, "VertexDensity" ],
  <| 1 -> 1, 2 -> 2, 3 -> 2, 4 -> 1 |>,
  TestID -> "InfraMeasurement-family-of-sets-sums-multiplicities"
]

(* one walk: every vertex visited exactly once maps to 1 *)
VerificationTest[
  InfraMeasurement[ g33, geodesicGraph @ { 1, 2, 3 }, "VertexDensity" ],
  <| 1 -> 1, 2 -> 1, 3 -> 1 |>,
  TestID -> "InfraMeasurement-single-realisation-all-one"
]

(* a bundle: the total mass is the total length of its realisations, since every
   realisation contributes each of its vertices once *)
VerificationTest[
  With[ { reps = { { 1, 2, 3, 6, 9 }, { 1, 4, 7, 8, 9 }, { 1, 2, 5, 8, 9 } } },
    Total @ Values @ InfraMeasurement[ g33, geodesicGraph /@ reps, "VertexDensity" ] === Total[ Length /@ reps ] ],
  True,
  TestID -> "InfraMeasurement-total-mass-is-total-length"
]

(* an interval DAG gives its occupation, the segment's vertex density, list-valued labels included *)
VerificationTest[
  With[ { gList = Graph[ Map[ { Quotient[ # - 1, 3 ] + 1, Mod[ # - 1, 3 ] + 1 } &, EdgeList @ g33, { 2 } ] ] },
    { InfraMeasurement[ g33, InfraMeasurement[ g33, InfraSegment[ 1, 9 ], "Graph" ], "VertexDensity" ] ===
        InfraMeasurement[ g33, InfraSegment[ 1, 9 ], "VertexDensity" ],
      InfraMeasurement[ gList, InfraMeasurement[ gList, InfraSegment[ { 1, 1 }, { 3, 3 } ], "Graph" ], "VertexDensity" ][ { 2, 2 } ] } ],
  { True, 4 },
  TestID -> "InfraMeasurement-interval-DAG-is-the-occupation"
]

(* the empty class yields the empty density *)
VerificationTest[
  InfraMeasurement[ g33, { }, "VertexDensity" ],
  <||>,
  TestID -> "InfraMeasurement-empty-class"
]

(* a density is already the marginal, so InfraMeasurement is the identity on it up to
   key order -- the guarantee that two built by different routes compare SameQ *)
VerificationTest[
  InfraMeasurement[ g33, <| 2 -> 3, 1 -> 1 |>, "VertexDensity" ],
  <| 1 -> 1, 2 -> 3 |>,
  TestID -> "InfraMeasurement-density-is-key-sorted-identity"
]

(* Counts promotes a list, Keys demotes a density: the two steps InfraMeasurement sits
   between, and the reason there is no second coercion in the API *)
VerificationTest[
  With[ { ball = Keys @ InfraMeasurement[ g33, InfraBall[5, 1], "VertexDensity" ] },
    Keys @ InfraMeasurement[ g33, ball, "VertexDensity" ] === Union[ ball ] &&
      InfraMeasurement[ g33, ball, "VertexDensity" ] === KeySort @ Counts @ ball ],
  True,
  TestID -> "InfraMeasurement-Counts-promotes-Keys-demotes"
]

(* a bare vertex is the unit mass, even where the label is itself a List: only the
   graph tells a list-labelled vertex from a two-element set *)
VerificationTest[
  With[ { g = GridGraph[ { 2, 2 }, VertexLabels -> None ] },
    { InfraMeasurement[ g33, 5, "VertexDensity" ],
      InfraMeasurement[ TessellationGraph[ { 4, 4 }, 1 ], { 1, 1 }, "VertexDensity" ] } ],
  { <| 5 -> 1 |>, <| { 1, 1 } -> 1 |> },
  TestID -> "InfraMeasurement-vertex-is-unit-mass"
]

(* normalising is the caller's, and both readings the old measure head carried are
   one division away *)
VerificationTest[
  With[ { d = InfraMeasurement[ g33, <| 1 -> 3, 2 -> 1 |>, "VertexDensity" ] },
    { Max @ Values[ d / Max @ Values @ d ], Total @ Values[ d / Total @ Values @ d ] } ],
  { 1, 1 },
  TestID -> "InfraMeasurement-normalisations-are-one-division-away"
]

(* ===== the shape reader ===== *)

(* the three rows of the ontology, on a graph whose vertices are integers *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], w = PathGraph[ { 1, 2, 3 }, DirectedEdges -> True ] },
    { InfraMeasurement[ g, 5, "VertexDensity" ], InfraMeasurement[ g, { 1, 2 }, "VertexDensity" ], InfraMeasurement[ g, <| 1 -> 2 |>, "VertexDensity" ], InfraMeasurement[ g, w, "VertexDensity" ] } ],
  { <| 5 -> 1 |>, <| 1 -> 1, 2 -> 1 |>, <| 1 -> 2 |>, <| 1 -> 1, 2 -> 1, 3 -> 1 |> },
  TestID -> "shape-reader-three-rows"
]

(* the substrate is not decoration: on a graph whose vertex labels are themselves
   lists, only the graph separates a point from a two-element multiset *)
VerificationTest[
  With[ { t = Graph[ { { 1, 1 }, { 2, 1 } }, { { 1, 1 } <-> { 2, 1 } } ],
          g = GridGraph[ { 3, 3 } ] },
    { InfraMeasurement[ t, { 1, 1 }, "VertexDensity" ], InfraMeasurement[ g, { 1, 1 }, "VertexDensity" ] } ],
  { <| { 1, 1 } -> 1 |>, <| 1 -> 2 |> },
  TestID -> "shape-reader-is-graph-relative"
]

(* a vertex a graph does not have is neither a point nor -- being an atom -- a multiset *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    { VertexQ[ g, 99 ], Head[ InfraMeasurement[ g, 99, "VertexDensity" ] ] } ],
  { False, InfraMeasurement },
  TestID -> "shape-reader-off-substrate-vertex"
]

(* a family of realisations reads as its vertex occupation, the sum of the per-member
   Counts, rather than a unit mass -- RandomInfraSegment[g, p, q] no longer wraps its
   family in a DAG (EuclideanInertHeads), so the occupation is just Merge/Total *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    With[ { paths = RandomInfraSegment[ g, 1, 9, All ] },
      InfraMeasurement[ g, paths, "VertexDensity" ] === KeySort @ Merge[ Counts /@ paths, Total ] ] ],
  True,
  TestID -> "walk-anchor-reads-as-occupation"
]

(* the multiset layer is a headless <| atom -> weight |> Association: repetition in
   a list reads as mass, and Keys is the step down to the support *)
VerificationTest[
  With[ { g = PathGraph @ Range[ 4 ] },
    { Counts[ { 1, 1, 2 } ],
      InfraMeasurement[ g, { 1, 1, 2 }, "VertexDensity" ],
      Keys @ InfraMeasurement[ g, { 1, 1, 2 }, "VertexDensity" ] } ],
  { <| 1 -> 2, 2 -> 1 |>,
    <| 1 -> 2, 2 -> 1 |>,
    { 1, 2 } },
  TestID -> "multiset-layer-is-a-headless-association"
]

(* the ANCHOR RULE: a vertex, a vertex list, a density and a walk graph all coerce
   to one 0-d density on bare vertices, so every construction reads its anchors
   through a single step *)
VerificationTest[
  With[ { g = PathGraph @ Range[ 4 ] },
    { InfraMeasurement[ g, 1, "VertexDensity" ],
      InfraMeasurement[ g, <| 1 -> 1, 2 -> 1 |>, "VertexDensity" ], InfraMeasurement[ g, { 1, 1, 2 }, "VertexDensity" ],
      InfraMeasurement[ g, <| 1 -> 3 |>, "VertexDensity" ], InfraMeasurement[ g, PathGraph[ { 1, 2, 3 }, DirectedEdges -> True ], "VertexDensity" ] } ],
  { <| 1 -> 1 |>,
    <| 1 -> 1, 2 -> 1 |>,
    <| 1 -> 2, 2 -> 1 |>,
    <| 1 -> 3 |>,
    <| 1 -> 1, 2 -> 1, 3 -> 1 |> },
  TestID -> "anchor-rule-coerces-everything-to-a-density"
]

(* the density algebra is the Association's own -- Keys, Values, Total, and division
   for either normalisation.  No engine call is involved, which is the point *)
VerificationTest[
  With[ { p = <| 1 -> 3, 2 -> 1 |> },
    { Keys @ p, Values @ p, Total @ p, p / Total @ p, p / Max @ Values @ p } ],
  { { 1, 2 }, { 3, 1 }, 4, <| 1 -> 3/4, 2 -> 1/4 |>, <| 1 -> 1, 2 -> 1/3 |> },
  TestID -> "density-algebra-is-the-Association-s-own"
]

(* the measure is CONSTRUCTED at a projection off a family, never carried by it:
   the endpoints are a set-level fact (every geodesic of the family shares them),
   the midpoint a genuine density *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], s = RandomInfraSegment[ GridGraph[ { 3, 3 } ], 1, 9, All ] },
    { Union[ First /@ s ], Union[ Last /@ s ], InfraMeasurement[ g, InfraSegment[ 1, 9 ], "Midpoint" ] } ],
  { { 1 }, { 9 }, <| 3 -> 1, 5 -> 4, 7 -> 1 |> },
  TestID -> "Measure-constructed-at-projection"
]

(* a bounded count is a prefix of the whole class, and a strict count fails on
   under-supply rather than returning fewer *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    { Length @ RandomInfraSegment[ g, 1, 16, UpTo[ 2 ] ],
      SubsetQ[ RandomInfraSegment[ g, 1, 16, All ],
               RandomInfraSegment[ g, 1, 16, UpTo[ 2 ] ] ],
      RandomInfraSegment[ g, 1, 16, 1000 ] } ],
  { 2, True, { } },
  TestID -> "bounded-count-is-a-prefix"
]

(* the count contract on RandomInfraSegment: count-less is ONE vertex list, a bounded
   count a List of them, All the whole class -- no DAG any more (EuclideanInertHeads) *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    { MatchQ[ RandomInfraSegment[ g, 1, 9 ], { __Integer } ],
      MatchQ[ RandomInfraSegment[ g, 1, 9, 1 ], { { __Integer } } ],
      MatchQ[ RandomInfraSegment[ g, 1, 9, UpTo[ 100 ] ], { { __Integer } .. } ],
      MatchQ[ RandomInfraSegment[ g, 1, 9, All ], { { __Integer } .. } ],
      Length @ RandomInfraSegment[ g, 1, 9, All ] === 6,
      RandomInfraSegment[ g, 1, 9, 7 ] === { } } ],
  { True, True, True, True, True, True },
  TestID -> "RandomInfraSegment-count-contract"
]

(* ===================== the interval DAG carries the family it stands for ===================== *)

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    InfraMeasurement[ g, InfraMeasurement[ g, InfraSegment[ 1, 16 ], "Graph" ], "VertexDensity" ] ===
      InfraMeasurement[ g, InfraSegment[ 1, 16 ], "VertexDensity" ] ],
  True,
  TestID -> "DAG-equals-enumerated-density"
]

(* both parities of d(1, t) *)
VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    Keys @ InfraMeasurement[ g, InfraSegment[ 1, # ], "Midpoint" ] & /@ { 16, 12 } ],
  { { 4, 7, 10, 13 }, { 3, 4, 6, 7, 9, 10 } },
  TestID -> "Midpoint-both-parities"
]


VerificationTest[
  With[ { graph = PathGraph[ Range[ 3 ] ] },
    Module[ { object },
      With[ { result = InfraMeasurement[ graph, object[ ], "Cardinality" ] },
        HoldComplete[ result ] === HoldComplete[ InfraMeasurement[ graph, object[ ], "Cardinality" ] ] ] ] ],
  True,
  TestID -> "InfraMeasurement-Cardinality-without-reading-stays-unevaluated"
]

VerificationTest[
  With[ { graph = PathGraph[ Range[ 3 ] ] },
    Module[ { object },
      With[ { result = InfraMeasurement[ graph, object[ ], "Length" ] },
        HoldComplete[ result ] === HoldComplete[ InfraMeasurement[ graph, object[ ], "Length" ] ] ] ] ],
  True,
  TestID -> "InfraMeasurement-Length-without-reading-stays-unevaluated"
]

VerificationTest[
  With[ { graph = PathGraph[ Range[ 3 ] ] },
    Module[ { object },
      With[ { result = InfraMeasurement[ graph, object[ ], "VertexDensity" ] },
        HoldComplete[ result ] === HoldComplete[ InfraMeasurement[ graph, object[ ], "VertexDensity" ] ] ] ] ],
  True,
  TestID -> "InfraMeasurement-VertexDensity-without-reading-stays-unevaluated"
]

VerificationTest[
  With[ { graph = PathGraph[ Range[ 3 ] ] },
    Module[ { object },
      With[ { result = InfraMeasurement[ graph, object[ ], "EdgeDensity" ] },
        HoldComplete[ result ] === HoldComplete[ InfraMeasurement[ graph, object[ ], "EdgeDensity" ] ] ] ] ],
  True,
  TestID -> "InfraMeasurement-EdgeDensity-without-reading-stays-unevaluated"
]

VerificationTest[
  With[ { graph = PathGraph[ Range[ 3 ] ] },
    Module[ { object },
      With[ { result = InfraMeasurement[ graph, object[ ], "Subgraph" ] },
        HoldComplete[ result ] === HoldComplete[ InfraMeasurement[ graph, object[ ], "Subgraph" ] ] ] ] ],
  True,
  TestID -> "InfraMeasurement-Subgraph-without-reading-stays-unevaluated"
]

VerificationTest[
  With[ { graph = PathGraph[ Range[ 3 ] ] },
    Module[ { object },
      With[ { result = InfraMeasurement[ graph, object[ ], "CountingMeasure" ] },
        HoldComplete[ result ] === HoldComplete[ InfraMeasurement[ graph, object[ ], "CountingMeasure" ] ] ] ] ],
  True,
  TestID -> "InfraMeasurement-CountingMeasure-without-reading-stays-unevaluated"
]

VerificationTest[
  With[ { graph = PathGraph[ Range[ 3 ] ] },
    Module[ { object },
      With[ { result = InfraMeasurement[ graph, object[ ], "RiemannianMeasure" ] },
        HoldComplete[ result ] === HoldComplete[ InfraMeasurement[ graph, object[ ], "RiemannianMeasure" ] ] ] ] ],
  True,
  TestID -> "InfraMeasurement-RiemannianMeasure-without-reading-stays-unevaluated"
]

VerificationTest[
  With[ { graph = PathGraph[ Range[ 3 ] ] },
    Module[ { object },
      With[ { result = InfraMemberQ[ graph, object[ ], { 1, 2 } ] },
        HoldComplete[ result ] === HoldComplete[ InfraMemberQ[ graph, object[ ], { 1, 2 } ] ] ] ] ],
  True,
  TestID -> "InfraMemberQ-without-graph-stays-unevaluated"
]

(* ===== a List of vertices is one vertex set ===== *)

(* every property reads a vertex list as one set: the corner square of the 3 x 3 grid has one interior vertex *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    { InfraMeasurement[ g, { 1, 2, 4, 5 }, "CountingMeasure" ], InfraMeasurement[ g, { 1, 2, 4, 5 }, "RiemannianMeasure" ],
      VertexList @ InfraMeasurement[ g, { 1, 2, 4, 5 }, "Subgraph" ] } ],
  { 4, 1, { 1, 2, 4, 5 } },
  TestID -> "InfraMeasurement-vertex-list-is-one-set"
]

(* a list of properties and All on a vertex list; the density keeps the multiplicity of a repeated vertex *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    { InfraMeasurement[ g, { 1, 2, 2 }, { "VertexDensity", "CountingMeasure" } ], Keys @ InfraMeasurement[ g, { 1, 2 }, All ] } ],
  { <| "VertexDensity" -> <| 1 -> 1, 2 -> 2 |>, "CountingMeasure" -> 2 |>, { "VertexDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" } },
  TestID -> "InfraMeasurement-vertex-list-property-list-and-All"
]

(* a density has the properties of a set: All on the corner square's density gives its four set readings *)
VerificationTest[
  With[ { readings = InfraMeasurement[ GridGraph[ { 3, 3 } ], <| 1 -> 1, 2 -> 1, 4 -> 1, 5 -> 2 |>, All ] },
    { Keys @ readings, readings[ "CountingMeasure" ], readings[ "RiemannianMeasure" ], VertexList @ readings[ "Subgraph" ] } ],
  { { "VertexDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" }, 4, 1, { 1, 2, 4, 5 } },
  TestID -> "InfraMeasurement-density-All-is-the-set-readings"
]

EndTestSection[]
