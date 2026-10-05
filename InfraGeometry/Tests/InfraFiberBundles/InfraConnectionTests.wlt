BeginTestSection["InfraConnection"]

(* Translated from InfraGaugeTheory Tests/Connections.wlt at e5dc83b; HolonomyMatrix becomes InfraHolonomy (Cycles),
   FindHorizontalLeaf becomes the components of the connection graph read by InfraFlatConnectionQ *)

(* ===== the head ===== *)

VerificationTest[
  InfraConnection[x],
  InfraConnection[x],
  TestID -> "InfraConnection-head-is-inert"
]

VerificationTest[
  {InfraConnectionQ[foo, InfraConnection[{}]], InfraFlatConnectionQ[foo, InfraConnection[{}]], RandomInfraConnection[foo],
   InfraParallelTransport[foo, InfraConnection[{}], {1, 2}], InfraHolonomy[foo, InfraConnection[{}], {1, 2, 1}]},
  {InfraConnectionQ[foo, InfraConnection[{}]], InfraFlatConnectionQ[foo, InfraConnection[{}]], RandomInfraConnection[foo],
   InfraParallelTransport[foo, InfraConnection[{}], {1, 2}], InfraHolonomy[foo, InfraConnection[{}], {1, 2, 1}]},
  TestID -> "InfraConnection-not-a-fibration-stays-unevaluated"
]

(* ===== RandomInfraConnection and InfraConnectionQ ===== *)

VerificationTest[
  SeedRandom[1];
  With[{fib = RandomInfraFibration[CycleGraph[4]]},
    {conn = RandomInfraConnection[fib]},
    {InfraConnectionQ[fib, conn], InfraHolonomy[fib, conn, {1, 2, 3, 4, 1}]}],
  {True, Cycles[{}]},
  TestID -> "RandomInfraConnection-on-the-T1-fibration"
]

VerificationTest[
  SeedRandom[42];
  With[{fib = RandomInfraFibration[CycleGraph[5], "VerticalVertices" -> 3, "IsomorphicFibers" -> True]},
    {conn = RandomInfraConnection[fib]},
    {Head[conn], InfraConnectionQ[fib, conn], AllTrue[First[conn], EdgeQ[InfraTotalGraph[fib], #] &], Length[First[conn]]}],
  {InfraConnection, True, True, 15},
  TestID -> "RandomInfraConnection-horizontal-total-edges"
]

VerificationTest[
  SeedRandom[42];
  With[{fib = RandomInfraFibration[CompleteGraph[4], "VerticalVertices" -> 2, "IsomorphicFibers" -> True]},
    InfraConnectionQ[fib, RandomInfraConnection[fib]]],
  True,
  TestID -> "InfraConnectionQ-complete-base"
]

VerificationTest[
  SeedRandom[42];
  With[{fib = RandomInfraFibration[CycleGraph[5], "VerticalVertices" -> 3, "IsomorphicFibers" -> True]},
    InfraConnectionQ[fib, InfraConnection[{}]]],
  False,
  TestID -> "InfraConnectionQ-empty-is-not-a-connection"
]

VerificationTest[
  With[{fib = InfraFibration[Graph[UndirectedEdge @@@ Subsets[{{1, 1}, {2, 1}, {1, 2}, {2, 2}}, {2}]], Last]},
    {InfraConnectionQ[fib, InfraConnection[Select[EdgeList[InfraTotalGraph[fib]], #[[1, 2]] =!= #[[2, 2]] &]]],
     InfraConnectionQ[fib, InfraConnection[{UndirectedEdge[{1, 1}, {2, 1}], UndirectedEdge[{1, 2}, {2, 2}]}]]}],
  {False, False},
  TestID -> "InfraConnectionQ-two-lifts-or-a-vertical-edge"
]

(* ===== FindInfraHorizontalLift ===== *)

VerificationTest[
  SeedRandom[42];
  With[{fib = RandomInfraFibration[CycleGraph[5], "VerticalVertices" -> 3, "IsomorphicFibers" -> True]},
    {conn = RandomInfraConnection[fib], start = First[VertexList[InfraFiber[fib, 1]]]},
    {lifts = FindInfraHorizontalLift[fib, conn, start, {1, 2, 3}, All]},
    {Length[lifts], InfraFibrationAssociation[fib] /@ First[lifts], First[First[lifts]] === start,
     FindInfraHorizontalLift[fib, conn, start, {1}, All], FindInfraHorizontalLift[fib, conn, start, {2, 3}, All]}],
  {1, {1, 2, 3}, True, {{{1, 1}}}, {}},
  TestID -> "FindInfraHorizontalLift-projects-to-the-walk"
]

VerificationTest[
  With[{fib = InfraFibration[CycleGraph[8], i |-> Mod[i, 4, 1]]},
    {conn = InfraConnection[EdgeList[CycleGraph[8]]]},
    {FindInfraHorizontalLift[fib, conn, 1, {1, 2, 3, 4, 1}, All], FindInfraHorizontalLift[fib, conn, 1, {1, 2, 3, 4, 1}, 2],
     FindInfraHorizontalLift[fib, conn, 1, {1, 3}, UpTo[1]]}],
  {{{1, 2, 3, 4, 5}}, {}, {}},
  TestID -> "FindInfraHorizontalLift-calling-triple"
]

(* ===== InfraParallelTransport ===== *)

VerificationTest[
  SeedRandom[42];
  With[{fib = RandomInfraFibration[CycleGraph[5], "VerticalVertices" -> 3, "IsomorphicFibers" -> True]},
    {conn = RandomInfraConnection[fib]},
    {transport = InfraParallelTransport[fib, conn, {1, 2, 3}]},
    {Length[transport], Union[InfraFibrationAssociation[fib] /@ Values[transport]], InfraParallelTransport[fib, conn, {1}]}],
  {3, {3}, <|{1, 1} -> {1, 1}, {1, 2} -> {1, 2}, {1, 3} -> {1, 3}|>},
  TestID -> "InfraParallelTransport-maps-to-the-end-fiber"
]

VerificationTest[
  With[{fib = InfraFibration[Graph[{{1, 1}, {1, 2}, {2, 1}, {2, 2}}, {UndirectedEdge[{1, 1}, {2, 1}]}], First]},
    {conn = InfraConnection[{UndirectedEdge[{1, 1}, {2, 1}]}]},
    {InfraConnectionQ[fib, conn], InfraParallelTransport[fib, conn, {1, 2, 1}], Head[InfraHolonomy[fib, conn, {1, 2, 1}]]}],
  {True, <|{1, 1} -> {1, 1}|>, InfraHolonomy},
  TestID -> "InfraParallelTransport-blocked-vertices-dropped"
]

(* ===== InfraHolonomy ===== *)

VerificationTest[
  With[{fib = InfraFibration[GraphProduct[CompleteGraph[3], CycleGraph[4], "Cartesian"], Last]},
    {conn = RandomInfraConnection[fib]},
    {InfraHolonomy[fib, conn, {1, 2, 3, 4, 1}], InfraFlatConnectionQ[fib, conn]}],
  {Cycles[{}], True},
  TestID -> "InfraHolonomy-trivial-bundle-is-identity"
]

VerificationTest[
  With[{fib = InfraFibration[CycleGraph[8], i |-> Mod[i, 4, 1]]},
    {conn = RandomInfraConnection[fib]},
    {InfraHolonomy[fib, conn, {1, 2, 3, 4, 1}], InfraHolonomy[fib, conn, {1, 2, 1}], InfraFlatConnectionQ[fib, conn],
     Head[InfraHolonomy[fib, conn, {1, 2, 3}]]}],
  {Cycles[{{1, 2}}], Cycles[{}], False, InfraHolonomy},
  TestID -> "InfraHolonomy-mobius-double-cover-swaps-the-sheets"
]

VerificationTest[
  With[{verts = Flatten[Table[{i, j}, {i, 4}, {j, 3}], 1]},
    {fib = InfraFibration[Graph[verts, Join[Flatten[Table[UndirectedEdge[{i, j}, {i + 1, j}], {i, 3}, {j, 3}]],
       {UndirectedEdge[{4, 1}, {1, 2}], UndirectedEdge[{4, 2}, {1, 1}], UndirectedEdge[{4, 3}, {1, 3}]}]], First]},
    {conn = RandomInfraConnection[fib]},
    {InfraHolonomy[fib, conn, {1, 2, 3, 4, 1}], InfraFlatConnectionQ[fib, conn]}],
  {Cycles[{{1, 2}}], False},
  TestID -> "InfraHolonomy-partial-twist-fixes-the-third-sheet"
]

(* The prototype of the InfraFibrations item, on the displacement bundle at scale 2 over the 4 x 4 grid built as a literal fibration *)
VerificationTest[
  With[{g = GridGraph[{4, 4}]},
    {pairs = Catenate[Function[p, {p, #} & /@ Pick[VertexList[g], GraphDistance[g, p], 2]] /@ VertexList[g]],
     close = {a, b} |-> a === b || EdgeQ[g, UndirectedEdge[a, b]]},
    {fib = InfraFibration[Graph[pairs, UndirectedEdge @@@ Select[Subsets[pairs, {2}], close[#[[1, 1]], #[[2, 1]]] && close[#[[1, 2]], #[[2, 2]]] &]], First]},
    {conn = (SeedRandom[1]; RandomInfraConnection[fib])},
    InfraHolonomy[fib, conn, {6, 7, 11, 10, 6}]],
  Cycles[{{1, 4, 6, 5, 3, 2}}],
  TestID -> "InfraHolonomy-prototype-displacement-bundle"
]

(* ===== InfraFlatConnectionQ ===== *)

VerificationTest[
  SeedRandom[1];
  Map[
    base |-> With[{fib = RandomInfraFibration[base, "VerticalVertices" -> 3, "IsomorphicFibers" -> True]},
      InfraFlatConnectionQ[fib, RandomInfraConnection[fib]]],
    {PathGraph[Range[6]], StarGraph[5], KaryTree[7]}],
  {True, True, True},
  TestID -> "InfraFlatConnectionQ-tree-base-is-always-flat"
]

VerificationTest[
  With[{fib = InfraFibration[GraphUnion[CycleGraph[4], IndexGraph[CycleGraph[4], 5]], i |-> Mod[i, 4, 1]]},
    {InfraFlatConnectionQ[fib, RandomInfraConnection[fib]], InfraFlatConnectionQ[fib, InfraConnection[{UndirectedEdge[1, 2]}]]}],
  {True, False},
  TestID -> "InfraFlatConnectionQ-needs-a-connection"
]

EndTestSection[]
