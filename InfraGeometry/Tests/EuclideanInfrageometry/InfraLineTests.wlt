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
      Sort[RandomInfraRepresentative[g, InfraLine[p, q], All]] === Sort[Select[
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
      pair |-> AllTrue[RandomInfraRepresentative[g, InfraLine @@ pair, All], InfraLineQ[g, #] &]]],
  True,
  TestID -> "InfraLine-members-satisfy-InfraLineQ-on-the-spread-table"
]

(* the C_6 through {1, 2} has three lines, not four (design Thm. line) *)
VerificationTest[
  With[{g = CycleGraph[6]}, {atoms = InfraMeasurement[g, InfraLine[1, 2], "Graph"]},
    {Length[atoms], Sort[RandomInfraRepresentative[g, InfraLine[1, 2], All]],
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
      InfraMeasurement[g, InfraLine[p, q], "Cardinality"] === Length[RandomInfraRepresentative[g, InfraLine[p, q], All]]]],
  True,
  TestID -> "InfraLine-Cardinality-adds-across-the-atoms"
]

VerificationTest[
  AllTrue[
    {{GridGraph[{3, 3}], 4, 5}, {GridGraph[{4, 4}], 6, 7}, {PetersenGraph[], 1, 2}, {HypercubeGraph[3], 1, 2}},
    Apply[{g, p, q} |->
      InfraMeasurement[g, InfraLine[p, q], "VertexDensity"] ===
        KeySort[Counts[Catenate[RandomInfraRepresentative[g, InfraLine[p, q], All]]]]]],
  True,
  TestID -> "InfraLine-VertexDensity-counts-the-members-through-each-vertex"
]

VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    {InfraMeasurement[g, InfraLine[4, 5], "Length"],
     InfraMeasurement[g, InfraLine[1, 5], "Length"],
     InfraMeasurement[g, InfraLine[4, 5], "Faithful"],
     InfraMeasurement[g, InfraLine[4, 5], "CountingMeasure"]}],
  {4, 4, True, 9},
  TestID -> "InfraLine-Length-Faithful-CountingMeasure"
]

(* ===== RandomInfraLine: the independent search ===== *)

VerificationTest[
  AllTrue[
    {{CycleGraph[6], 1, 2}, {GridGraph[{3, 3}], 4, 5}, {GridGraph[{4, 4}], 6, 7},
     {PetersenGraph[], 1, 2}, {HypercubeGraph[3], 1, 2}, {PathGraph[Range[7]], 4, 5}},
    Apply[{g, p, q} |-> Sort[RandomInfraLine[g, p, q, All]] === Sort[RandomInfraRepresentative[g, InfraLine[p, q], All]]]],
  True,
  TestID -> "RandomInfraLine-agrees-with-the-graph"
]

VerificationTest[
  With[{g = CycleGraph[6]},
    {InfraLineQ[g, RandomInfraLine[g, 1, 2]], Length[RandomInfraLine[g, 1, 2, 2]],
     Length[RandomInfraLine[g, 1, 2, UpTo[9]]], RandomInfraLine[g, 1, 2, 5]}],
  {True, 2, 3, { }},
  TestID -> "RandomInfraLine-count-contract"
]

(* the lines through a given geodesic *)
VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    {Sort[RandomInfraLine[g, {6, 7}, All]] === Sort[RandomInfraLine[g, 6, 7, All]],
     AllTrue[RandomInfraLine[g, {2, 6, 10}, All], path |-> InfraLineQ[g, path] && SubsetQ[path, {2, 6, 10}]],
     Sort[RandomInfraLine[PathGraph[Range[7]], {3, 4}, All]]}],
  {True, True, {{1, 2, 3, 4, 5, 6, 7}}},
  TestID -> "RandomInfraLine-through-a-given-geodesic"
]

(* ===== membership ===== *)

VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    {AllTrue[RandomInfraLine[g, 6, 7, All], InfraMemberQ[g, InfraLine[6, 7], #] &],
     InfraMemberQ[g, InfraLine[6, 7], {6, 7}],
     InfraMemberQ[g, InfraLine[6, 7], Reverse[First[RandomInfraLine[g, 6, 7, All]]]]}],
  {True, False, False},
  TestID -> "InfraLine-InfraMemberQ-accepts-exactly-the-members"
]

(* ===== small fixtures ===== *)

(* a line is inextensible, not longest: {1, 2, 3} is a line although the diameter is 3 *)
VerificationTest[
  With[{g = Graph[{1 <-> 2, 2 <-> 3, 2 <-> 4, 4 <-> 5}]},
    {RandomInfraLine[g, 1, 3, All], RandomInfraRepresentative[g, InfraLine[1, 3], All]}],
  {{{1, 2, 3}}, {{1, 2, 3}}},
  TestID -> "RandomInfraLine-keeps-short-inextensible-line"
]

VerificationTest[
  With[{g = PathGraph[Range[5]]}, {RandomInfraLine[g, 1, 5], RandomInfraRepresentative[g, InfraLine[1, 5], All]}],
  {Range[5], {Range[5]}},
  TestID -> "RandomInfraLine-already-maximal"
]

VerificationTest[
  With[{g = TorusGraph[{4, 5}]}, {lines = RandomInfraLine[g, 1, 2, All]},
    {Sort[lines] === Sort[RandomInfraRepresentative[g, InfraLine[1, 2], All]], Length[lines],
     AllTrue[lines, InfraLineQ[g, #] &]}],
  {True, 24, True},
  TestID -> "RandomInfraLine-agrees-with-the-graph-TorusGraph"
]

(* Identity preserves the first member in the old enumeration order. *)
VerificationTest[
  With[{g = CycleGraph[6], lines = RandomInfraLine[CycleGraph[6], 1, 2, All]},
    RandomInfraLine[g, 1, 2, "NextVertexFunction" -> Identity] === First[lines]],
  True,
  TestID -> "RandomInfraLine-Identity-preserves-first-member"
]

VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    BlockRandom[RandomInfraLine[g, 6, 7], RandomSeeding -> 17] ===
      BlockRandom[RandomInfraLine[g, 6, 7], RandomSeeding -> 17] &&
    InfraLineQ[g, BlockRandom[RandomInfraLine[g, 6, 7], RandomSeeding -> 17]]],
  True,
  TestID -> "RandomInfraLine-default-is-seeded-and-valid"
]

VerificationTest[
  Length @ DeleteDuplicates @ Table[
    BlockRandom[RandomInfraLine[GridGraph[{4, 4}], 6, 7], RandomSeeding -> s],
    {s, 1, 8}] > 1,
  True,
  TestID -> "RandomInfraLine-default-varies-across-seeds"
]

VerificationTest[
  With[{g = Graph[
      {"a", "b", "s", "u", "v", "p", "t"},
      Join[
        {UndirectedEdge["a", "b"]},
        Flatten[Table[UndirectedEdge[x, y], {x, {"a", "b"}}, {y, {"s", "u", "v", "p", "t"}}]],
        {UndirectedEdge["s", "u"], UndirectedEdge["s", "v"], UndirectedEdge["u", "p"],
         UndirectedEdge["v", "p"], UndirectedEdge["p", "t"]}]],
      line = {"a", "b"}, p = "p"},
    {all = Replace[RandomInfraParallel[g, line, p, All], w_Graph :> {w}]},
    {RandomInfraParallel[g, line, p, Automatic, "NextVertexFunction" -> Identity] === First[all],
     AllTrue[all, InfraParallelQ[g, line, #] &],
     Length[all] > 1}],
  {True, True, True},
  TestID -> "RandomInfraParallel-Identity-preserves-first-member"
]

VerificationTest[
  With[{g = Graph[
      {"a", "b", "s", "u", "v", "p", "t"},
      Join[
        {UndirectedEdge["a", "b"]},
        Flatten[Table[UndirectedEdge[x, y], {x, {"a", "b"}}, {y, {"s", "u", "v", "p", "t"}}]],
        {UndirectedEdge["s", "u"], UndirectedEdge["s", "v"], UndirectedEdge["u", "p"],
         UndirectedEdge["v", "p"], UndirectedEdge["p", "t"]}]],
      line = {"a", "b"}, p = "p"},
    {draw = BlockRandom[RandomInfraParallel[g, line, p], RandomSeeding -> 17]},
    {draw === BlockRandom[RandomInfraParallel[g, line, p], RandomSeeding -> 17],
     InfraParallelQ[g, line, draw],
     Length @ DeleteDuplicates @ Table[
       BlockRandom[RandomInfraParallel[g, line, p], RandomSeeding -> s], {s, 1, 8}] > 1}],
  {True, True, True},
  TestID -> "RandomInfraParallel-default-is-seeded-and-valid"
]

VerificationTest[
  With[{g = Graph[
      {"a", "b", "s", "u", "v", "p", "t"},
      Join[
        {UndirectedEdge["a", "b"]},
        Flatten[Table[UndirectedEdge[x, y], {x, {"a", "b"}}, {y, {"s", "u", "v", "p", "t"}}]],
        {UndirectedEdge["s", "u"], UndirectedEdge["s", "v"], UndirectedEdge["u", "p"],
         UndirectedEdge["v", "p"], UndirectedEdge["p", "t"]}]],
      line = {"a", "b"}, p = "p"},
    {all = Replace[RandomInfraParallel[g, line, p, All], w_Graph :> {w}]},
    {pruned = Replace[
       RandomInfraParallel[g, line, p, All,
         "NextVertexFunction" -> (cands |-> If[MatchQ[First[cands], {_String, _String}], cands, Take[cands, 1]])],
       w_Graph :> {w}]},
    Length[pruned] < Length[all] && AllTrue[pruned, MemberQ[all, #] &]],
  True,
  TestID -> "RandomInfraParallel-All-honors-pruning-function"
]

walkSequence = WolframInstitute`InfraGeometry`PackageScope`walkSequence;
infraSpread  = WolframInstitute`InfraGeometry`PackageScope`infraSpread;

(* ===== LineCount ===== *)

VerificationTest[
  LineCount[PathGraph[Range[5]]],
  1,
  TestID -> "LineCount-PathGraph-5"
]

VerificationTest[
  LineCount[CompleteGraph[4]],
  6,
  TestID -> "LineCount-CompleteGraph4-equals-edges"
]

VerificationTest[
  LineCount[PathGraph[Range[7]]],
  1,
  TestID -> "LineCount-PathGraph-7"
]

(* ===== UniversalLineQ ===== *)

(* the path is a single universal line; C4 has one (antipodes 1, 3 span the whole cycle); C5 has none (every line covers at
   most 4 of 5) *)

VerificationTest[
  UniversalLineQ[ PathGraph @ Range[ 5 ] ],
  True,
  TestID -> "UniversalLineQ-path"
]

VerificationTest[
  UniversalLineQ[ CycleGraph[ 4 ], { 1, 3 } ],
  True,
  TestID -> "UniversalLineQ-C4-pair"
]

VerificationTest[
  UniversalLineQ[ CycleGraph[ 4 ] ],
  True,
  TestID -> "UniversalLineQ-C4"
]

VerificationTest[
  UniversalLineQ[ CycleGraph[ 5 ] ],
  False,
  TestID -> "UniversalLineQ-C5-none"
]

(* ===== FindInfraCommonLine ===== *)

(* count-less is the one line as a path graph; All is the lone bundle, here the
   same carrier since the path has exactly one line; a bounded count is a List *)

VerificationTest[
  walkSequence @ FindInfraCommonLine[PathGraph[Range[5]], {1, 3}],
  {1, 2, 3, 4, 5},
  TestID -> "FindInfraCommonLine-PathGraph-default-1"
]

VerificationTest[
  infraSpread @ FindInfraCommonLine[PathGraph[Range[5]], {1, 3}, All],
  {{1, 2, 3, 4, 5}},
  TestID -> "FindInfraCommonLine-PathGraph-All"
]

VerificationTest[
  { MatchQ[#, {_Graph}], walkSequence /@ # } & @
    FindInfraCommonLine[PathGraph[Range[5]], {1, 3}, UpTo[3]],
  { True, {{1, 2, 3, 4, 5}} },
  TestID -> "FindInfraCommonLine-PathGraph-UpTo-soft"
]

VerificationTest[
  FindInfraCommonLine[PathGraph[Range[5]], {1, 3}, 2],
  { },
  TestID -> "FindInfraCommonLine-strict-fails-when-too-few"
]

VerificationTest[
  walkSequence @ FindInfraCommonLine[PathGraph[Range[5]], {1, 5, 3}],
  {1, 2, 3, 4, 5},
  TestID -> "FindInfraCommonLine-three-collinear-vertices"
]

VerificationTest[
  Length @ infraSpread @ FindInfraCommonLine[CycleGraph[6], {1, 4}, All],
  2,
  TestID -> "FindInfraCommonLine-CycleGraph6-antipode-two-lines"
]

VerificationTest[
  With[{result = infraSpread @ FindInfraCommonLine[GridGraph[{3, 3}], {1, 9, 5}, All]},
    Length @ result >= 1 && AllTrue[result, SubsetQ[#, {1, 9, 5}] &]
  ],
  True,
  TestID -> "FindInfraCommonLine-GridGraph-diagonal"
]

(* ===== FindInfraCommonLine multi-anchor (density entries) ===== *)

VerificationTest[
  infraSpread @ FindInfraCommonLine[PathGraph[Range[5]], {<| 1 -> 1, 3 -> 1 |>}, All],
  {{1, 2, 3, 4, 5}},
  TestID -> "FindInfraCommonLine-density-anchor"
]

VerificationTest[
  infraSpread @ FindInfraCommonLine[PathGraph[Range[5]], {<| 1 -> 1, 3 -> 1 |>, 5}, All],
  {{1, 2, 3, 4, 5}},
  TestID -> "FindInfraCommonLine-mixed-anchor"
]

EndTestSection[]
