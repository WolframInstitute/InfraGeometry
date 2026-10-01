BeginTestSection["InfraLine"]

(* ===== the head is inert ===== *)

VerificationTest[
  {InfraLine[1, 2], InfraLine[{1, 2, 3}]},
  {InfraLine[1, 2], InfraLine[{1, 2, 3}]},
  TestID -> "InfraLine-head-is-inert"
]

(* ===== the graph is the List of atoms ===== *)

(* one atom per compatible maximal end pair: K(a, b) = I(a, p) + I(p, q) + I(q, b), source a, sink b *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]}, {atoms = InfraMeasurement[g, InfraLine[4, 5], "Graph"]},
    {Head[atoms], Length[atoms],
     Pick[VertexList[#], VertexInDegree[#], 0] & /@ atoms,
     Pick[VertexList[#], VertexOutDegree[#], 0] & /@ atoms,
     AllTrue[atoms, dag |-> AllTrue[EdgeList[dag],
       GraphDistance[g, First[Pick[VertexList[dag], VertexInDegree[dag], 0]], Last[#]] ==
       GraphDistance[g, First[Pick[VertexList[dag], VertexInDegree[dag], 0]], First[#]] + 1 &]]}],
  {List, 2, {{1}, {7}}, {{9}, {3}}, True},
  TestID -> "InfraLine-graph-is-the-list-of-atoms"
]

(* the atoms are exactly the compatible maximal end pairs, against a brute-force sweep of V x V *)
VerificationTest[
  AllTrue[
    {{CycleGraph[6], 1, 2}, {GridGraph[{3, 3}], 4, 5}, {PetersenGraph[], 1, 2}, {HypercubeGraph[3], 1, 2}},
    Apply[{g, p, q} |->
      With[{d = GraphDistance[g, p, q]},
        Sort[{First[Pick[VertexList[#], VertexInDegree[#], 0]],
              First[Pick[VertexList[#], VertexOutDegree[#], 0]]} & /@
            InfraMeasurement[g, InfraLine[p, q], "Graph"]] ===
        Sort[Select[Tuples[{VertexList[g], VertexList[g]}],
          Apply[{a, b} |->
            GraphDistance[g, a, b] == GraphDistance[g, a, p] + d + GraphDistance[g, q, b] &&
            NoneTrue[AdjacencyList[g, a], GraphDistance[g, #, b] > GraphDistance[g, a, b] &] &&
            NoneTrue[AdjacencyList[g, b], GraphDistance[g, a, #] > GraphDistance[g, a, b] &]]]]]]],
  True,
  TestID -> "InfraLine-atoms-are-the-compatible-maximal-end-pairs"
]

(* ===== the members ===== *)

(* against a brute-force enumeration of every inextensible geodesic through p and then q *)
VerificationTest[
  AllTrue[
    {{CycleGraph[6], 1, 2}, {GridGraph[{3, 3}], 4, 5}, {GridGraph[{4, 4}], 6, 7},
     {PetersenGraph[], 1, 2}, {HypercubeGraph[3], 1, 2}, {PathGraph[Range[5]], 2, 3}},
    Apply[{g, p, q} |->
      Sort[InfraVertexList[g, InfraLine[p, q], All]] === Sort[Select[
        Catenate[Catenate[Table[FindPath[g, a, b, {GraphDistance[g, a, b]}, All],
            {a, VertexList[g]}, {b, DeleteCases[VertexList[g], a]}]]],
        path |-> MemberQ[path, p] && MemberQ[path, q] &&
          First[FirstPosition[path, p]] < First[FirstPosition[path, q]] &&
          NoneTrue[AdjacencyList[g, First[path]], GraphDistance[g, #, Last[path]] == Length[path] &] &&
          NoneTrue[AdjacencyList[g, Last[path]], GraphDistance[g, First[path], #] == Length[path] &]]]]],
  True,
  TestID -> "InfraLine-members-equal-the-brute-force-class"
]

(* every member is a line *)
VerificationTest[
  AllTrue[
    {PathGraph[Range[7]], CycleGraph[7], GridGraph[{3, 3}], PetersenGraph[], HypercubeGraph[3]},
    g |-> AllTrue[Join[List @@@ EdgeList[g], Reverse /@ List @@@ EdgeList[g]],
      pair |-> AllTrue[InfraVertexList[g, InfraLine @@ pair, All], InfraLineQ[g, #] &]]],
  True,
  TestID -> "InfraLine-members-satisfy-InfraLineQ-on-the-spread-table"
]

(* the C_6 through {1, 2} has three lines, not four (design Thm. line) *)
VerificationTest[
  With[{g = CycleGraph[6]}, {atoms = InfraMeasurement[g, InfraLine[1, 2], "Graph"]},
    {Length[atoms], Sort[InfraVertexList[g, InfraLine[1, 2], All]],
     InfraMeasurement[g, InfraLine[1, 2], "Cardinality"], InfraMeasurement[g, InfraLine[1, 2], "Length"]}],
  {3, {{1, 2, 3, 4}, {5, 6, 1, 2}, {6, 1, 2, 3}}, 3, 3},
  TestID -> "InfraLine-C6-three-lines"
]

(* the union of the atoms is not faithful: it carries the chain 5,6,1,2,3,4 while d(5, 4) == 1 *)
VerificationTest[
  With[{g = CycleGraph[6]}, {atoms = InfraMeasurement[g, InfraLine[1, 2], "Graph"]},
    {union = Graph[Union @@ (VertexList /@ atoms), Union @@ (EdgeList /@ atoms)]},
    {MemberQ[FindPath[union, 5, 4, Infinity, All], {5, 6, 1, 2, 3, 4}],
     GraphDistance[g, 5, 4],
     InfraMemberQ[g, InfraLine[1, 2], {5, 6, 1, 2, 3, 4}]}],
  {True, 1, False},
  TestID -> "InfraLine-C6-the-union-of-the-atoms-is-not-faithful"
]

(* ===== the counts add across the atoms ===== *)

VerificationTest[
  AllTrue[
    {{CycleGraph[6], 1, 2}, {GridGraph[{3, 3}], 4, 5}, {GridGraph[{4, 4}], 6, 7},
     {PetersenGraph[], 1, 2}, {HypercubeGraph[3], 1, 2}},
    Apply[{g, p, q} |->
      InfraMeasurement[g, InfraLine[p, q], "Cardinality"] === Length[InfraVertexList[g, InfraLine[p, q], All]]]],
  True,
  TestID -> "InfraLine-Cardinality-adds-across-the-atoms"
]

VerificationTest[
  AllTrue[
    {{GridGraph[{3, 3}], 4, 5}, {GridGraph[{4, 4}], 6, 7}, {PetersenGraph[], 1, 2}, {HypercubeGraph[3], 1, 2}},
    Apply[{g, p, q} |->
      InfraMeasurement[g, InfraLine[p, q], "VertexDensity"] ===
        KeySort[Counts[Catenate[InfraVertexList[g, InfraLine[p, q], All]]]]]],
  True,
  TestID -> "InfraLine-VertexDensity-counts-the-members-through-each-vertex"
]

VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    {InfraMeasurement[g, InfraLine[4, 5], "Length"],
     InfraMeasurement[g, InfraLine[1, 5], "Length"],
     InfraMeasurement[g, InfraLine[4, 5], "Faithful"],
     InfraMeasurement[g, InfraLine[4, 5], "Volume"]}],
  {4, 4, True, 9},
  TestID -> "InfraLine-Length-Faithful-Volume"
]

(* ===== FindInfraLine: the independent search ===== *)

VerificationTest[
  AllTrue[
    {{CycleGraph[6], 1, 2}, {GridGraph[{3, 3}], 4, 5}, {GridGraph[{4, 4}], 6, 7},
     {PetersenGraph[], 1, 2}, {HypercubeGraph[3], 1, 2}, {PathGraph[Range[7]], 4, 5}},
    Apply[{g, p, q} |-> Sort[FindInfraLine[g, p, q, All]] === Sort[InfraVertexList[g, InfraLine[p, q], All]]]],
  True,
  TestID -> "FindInfraLine-agrees-with-the-graph"
]

VerificationTest[
  With[{g = CycleGraph[6]},
    {InfraLineQ[g, FindInfraLine[g, 1, 2]], Length[FindInfraLine[g, 1, 2, 2]],
     Length[FindInfraLine[g, 1, 2, UpTo[9]]], FindInfraLine[g, 1, 2, 5]}],
  {True, 2, 3, { }},
  TestID -> "FindInfraLine-count-contract"
]

(* the lines through a given geodesic *)
VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    {Sort[FindInfraLine[g, {6, 7}, All]] === Sort[FindInfraLine[g, 6, 7, All]],
     AllTrue[FindInfraLine[g, {2, 6, 10}, All], path |-> InfraLineQ[g, path] && SubsetQ[path, {2, 6, 10}]],
     Sort[FindInfraLine[PathGraph[Range[7]], {3, 4}, All]]}],
  {True, True, {{1, 2, 3, 4, 5, 6, 7}}},
  TestID -> "FindInfraLine-through-a-given-geodesic"
]

(* ===== membership ===== *)

VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    {AllTrue[FindInfraLine[g, 6, 7, All], InfraMemberQ[g, InfraLine[6, 7], #] &],
     InfraMemberQ[g, InfraLine[6, 7], {6, 7}],
     InfraMemberQ[g, InfraLine[6, 7], Reverse[First[FindInfraLine[g, 6, 7, All]]]]}],
  {True, False, False},
  TestID -> "InfraLine-InfraMemberQ-accepts-exactly-the-members"
]

(* ===== small fixtures ===== *)

(* a line is inextensible, not longest: {1, 2, 3} is a line although the diameter is 3 *)
VerificationTest[
  With[{g = Graph[{1 <-> 2, 2 <-> 3, 2 <-> 4, 4 <-> 5}]},
    {FindInfraLine[g, 1, 3, All], InfraVertexList[g, InfraLine[1, 3], All]}],
  {{{1, 2, 3}}, {{1, 2, 3}}},
  TestID -> "FindInfraLine-keeps-short-inextensible-line"
]

VerificationTest[
  With[{g = PathGraph[Range[5]]}, {FindInfraLine[g, 1, 5], InfraVertexList[g, InfraLine[1, 5], All]}],
  {Range[5], {Range[5]}},
  TestID -> "FindInfraLine-already-maximal"
]

VerificationTest[
  With[{g = TorusGraph[{4, 5}]}, {lines = FindInfraLine[g, 1, 2, All]},
    {Sort[lines] === Sort[InfraVertexList[g, InfraLine[1, 2], All]], Length[lines],
     AllTrue[lines, InfraLineQ[g, #] &]}],
  {True, 24, True},
  TestID -> "FindInfraLine-agrees-with-the-graph-TorusGraph"
]

EndTestSection[]
