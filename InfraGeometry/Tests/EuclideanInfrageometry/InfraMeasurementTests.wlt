BeginTestSection["InfraMeasurement"]

(* ===== the counts on the graph are the counts of the members ===== *)

(* the cardinality is the number of members, and the members are the geodesics *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    {InfraMeasurement[g, InfraSegment[1, 9], "Cardinality"],
     Length[FindInfraRepresentative[g, InfraSegment[1, 9], All]],
     Length[FindPath[g, 1, 9, {4}, All]]}],
  {6, 6, 6},
  TestID -> "InfraMeasurement-Cardinality-counts-the-members"
]

(* the vertex density counts the members through each vertex *)
VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    InfraMeasurement[g, InfraSegment[1, 16], "VertexDensity"] ===
      KeySort[Counts[Catenate[FindInfraRepresentative[g, InfraSegment[1, 16], All]]]]],
  True,
  TestID -> "InfraMeasurement-VertexDensity-is-the-occupation"
]

(* the edge density counts the members through each arrow *)
VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    {members = FindInfraRepresentative[g, InfraSegment[1, 16], All]},
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
  With[{g = GridGraph[{5, 5}]},
    InfraMeasurement[g, #, "Faithful"] & /@
      {InfraSegment[1, 25], InfraRay[1, 2], InfraLine[1, 2], InfraCircle[13, 3], InfraArc[13, {3, 11}]}],
  {True, True, True, Undetermined, Undetermined},
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

(* ===== FindInfraRepresentative: the count contract ===== *)

(* count-less is one member, a bounded count a List of them, All the whole family in lexicographic order *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]}, {obj = InfraSegment[1, 9]},
    {FindInfraRepresentative[g, obj] === First[Sort[FindPath[g, 1, 9, {4}, All]]],
     Length[FindInfraRepresentative[g, obj, 3]] === 3,
     Length[FindInfraRepresentative[g, obj, UpTo[100]]] === 6,
     FindInfraRepresentative[g, obj, All] === Sort[FindPath[g, 1, 9, {4}, All]]}],
  {True, True, True, True},
  TestID -> "FindInfraRepresentative-count-contract"
]

(* a strict count larger than the family has no answer *)
VerificationTest[
  FindInfraRepresentative[CycleGraph[6], InfraSegment[1, 4], 5],
  { },
  TestID -> "FindInfraRepresentative-strict-shortfall"
]

(* an empty family gives the empty shape *)
VerificationTest[
  With[{g = Graph[{1, 2}, {}]},
    {FindInfraRepresentative[g, InfraSegment[1, 2]], FindInfraRepresentative[g, InfraSegment[1, 2], All],
     InfraMeasurement[g, InfraSegment[1, 2], "Cardinality"]}],
  {{}, {}, 0},
  TestID -> "FindInfraRepresentative-empty-family"
]

(* a vertex is its own segment *)
VerificationTest[
  FindInfraRepresentative[GridGraph[{3, 3}], InfraSegment[5, 5], All],
  {{5}},
  TestID -> "FindInfraRepresentative-degenerate-segment"
]

(* "RandomChoice" draws every member with probability 1 / N: 3000 draws of a family of 6 *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    {counts = (SeedRandom[42]; Values[Counts[FindInfraRepresentative[g, InfraSegment[1, 9], 3000, "RandomChoice"]]])},
    Length[counts] === 6 && Min[counts] > 400 && Max[counts] < 600],
  True,
  TestID -> "FindInfraRepresentative-RandomChoice-is-uniform-on-members"
]

(* "Pruning" thins the enumeration: what comes back is still a set of members *)
VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    {all = FindInfraRepresentative[g, InfraSegment[1, 16], All],
     pruned = (SeedRandom[7]; FindInfraRepresentative[g, InfraSegment[1, 16], All, "Pruning" -> 0.3])},
    SubsetQ[all, pruned] && Length[pruned] < Length[all]],
  True,
  TestID -> "FindInfraRepresentative-Pruning-thins-the-enumeration"
]

(* ===== InfraMemberQ ===== *)

VerificationTest[
  With[{g = GridGraph[{3, 3}]}, {obj = InfraSegment[1, 9]},
    {AllTrue[FindInfraRepresentative[g, obj, All], InfraMemberQ[g, obj, #] &],
     InfraMemberQ[g, obj, {1, 2, 5}],
     InfraMemberQ[g, obj, {1, 2, 3, 6, 5, 8, 9}]}],
  {True, False, False},
  TestID -> "InfraMemberQ-accepts-exactly-the-members"
]

(* ===== InfraSubgraph ===== *)

VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    {Sort[VertexList[InfraSubgraph[g, InfraSegment[1, 3]]]],
     Sort[VertexList[InfraSubgraph[g, InfraSegment[1, 3] -> 1]]]}],
  {{1, 2, 3}, {1, 2, 3, 4, 5, 6}},
  TestID -> "InfraSubgraph-support-and-thickening"
]

(* ===== list-valued vertex labels ===== *)

(* a vertex label may itself be a List, so every lookup goes through Key *)
VerificationTest[
  With[{g = Graph[Map[{Quotient[# - 1, 3] + 1, Mod[# - 1, 3] + 1} &, EdgeList[GridGraph[{3, 3}]], {2}]]},
    {obj = InfraSegment[{1, 1}, {3, 3}]},
    {InfraMeasurement[g, obj, "Cardinality"], Length[FindInfraRepresentative[g, obj, All]],
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
    {FindInfraRepresentative[g, InfraShell[13, 2]] === FindInfraShell[g, 13, 2],
     FindInfraRepresentative[g, InfraBall[13, 1], All] === {FindInfraRepresentative[g, InfraBall[13, 1]]},
     FindInfraRepresentative[g, InfraPoint[13], All],
     FindInfraRepresentative[g, InfraWalk[1, 2, 3]], FindInfraRepresentative[g, InfraWalk[1, 3], All],
     Length @ FindInfraRepresentative[g, InfraShell[13, 2], 1, "RandomChoice"]}],
  {True, True, {13}, {1, 2, 3}, {}, 1},
  TestID -> "FindInfraRepresentative-token-heads-read-by-their-searches"
]

(* a scene circle reads its second argument as a radius, the head as a point *)
VerificationTest[
  With[{g = GridGraph[{7, 7}]},
    {WolframInstitute`InfraGeometry`PackageScope`dispatchConstruction[g, InfraCircle[25, {2, 3}]] ===
       FindInfraRepresentative[g, InfraCircle[25, {2, 3}], All],
     WolframInstitute`InfraGeometry`PackageScope`dispatchConstruction[g, InfraCircle[25, {2, 3}, "Branches" -> 1]] ===
       FindInfraRepresentative[g, InfraCircle[25, {2, 3}], UpTo[1]]}],
  {True, True},
  TestID -> "FindInfraRepresentative-scene-circle-is-by-radius"
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

EndTestSection[]
