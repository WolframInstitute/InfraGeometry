BeginTestSection["InfraSection"]

(* Translated from InfraGaugeTheory Tests/Sections.wlt at e5dc83b: its tests cover FindZeroSection and FindCanonicalSection,
   which are tangent-bundle constructions and not ported here; the section predicates and searches are tested afresh *)

(* ===== the head ===== *)

VerificationTest[
  InfraSection[x],
  InfraSection[x],
  TestID -> "InfraSection-head-is-inert"
]

VerificationTest[
  {InfraSectionQ[foo, InfraSection[<||>]], InfraContinuousSectionQ[foo, InfraSection[<||>]], RandomInfraSection[foo], FindInfraSection[foo, All]},
  {InfraSectionQ[foo, InfraSection[<||>]], InfraContinuousSectionQ[foo, InfraSection[<||>]], RandomInfraSection[foo], FindInfraSection[foo, All]},
  TestID -> "InfraSection-not-a-fibration-stays-unevaluated"
]

(* ===== InfraSectionQ ===== *)

VerificationTest[
  SeedRandom[1];
  With[{fib = RandomInfraFibration[CycleGraph[5], "VerticalVertices" -> 3, "IsomorphicFibers" -> True]},
    {sec = RandomInfraSection[fib]},
    {InfraSectionQ[fib, sec], Sort[Keys[First[sec]]]}],
  {True, Range[5]},
  TestID -> "RandomInfraSection-is-a-section-over-the-whole-base"
]

VerificationTest[
  With[{fib = InfraFibration[CycleGraph[8], i |-> Mod[i, 4, 1]]},
    {InfraSectionQ[fib, InfraSection[<|1 -> 5, 2 -> 6|>]], InfraSectionQ[fib, InfraSection[<|1 -> 2|>]], InfraSectionQ[fib, InfraSection[<|1 -> 9|>]]}],
  {True, False, False},
  TestID -> "InfraSectionQ-value-over-its-key"
]

(* ===== InfraContinuousSectionQ ===== *)

VerificationTest[
  With[{fib = InfraFibration[CycleGraph[8], i |-> Mod[i, 4, 1]]},
    {InfraContinuousSectionQ[fib, InfraSection[<|1 -> 1, 2 -> 2, 3 -> 3|>]],
     InfraContinuousSectionQ[fib, InfraSection[<|1 -> 1, 2 -> 6|>]],
     InfraContinuousSectionQ[fib, InfraSection[<|1 -> 1, 3 -> 7|>]],
     InfraContinuousSectionQ[fib, InfraSection[<|1 -> 2|>]]}],
  {True, False, True, False},
  TestID -> "InfraContinuousSectionQ-partial-sections-on-the-double-cover"
]

(* On the displacement bundle at scale 1 a single-valued displacement d is the section p -> {p, d(p)}, and continuity of the
   section is weak 1-continuity of d: {p, d(p)} and {q, d(q)} are adjacent iff d(p) and d(q) are equal or adjacent *)
VerificationTest[
  SeedRandom[1];
  With[{g = GridGraph[{4, 4}]},
    {pairs = Catenate[Function[p, {p, #} & /@ AdjacencyList[g, p]] /@ VertexList[g]],
     close = {a, b} |-> a === b || EdgeQ[g, UndirectedEdge[a, b]]},
    {fib = InfraFibration[Graph[pairs, UndirectedEdge @@@ Select[Subsets[pairs, {2}], close[#[[1, 1]], #[[2, 1]]] && close[#[[1, 2]], #[[2, 2]]] &]], First]},
    {displacements = Append[
       Table[AssociationMap[{RandomChoice[AdjacencyList[g, #]]} &, VertexList[g]], 10],
       AssociationMap[{If[Mod[#, 4] == 0, # - 1, # + 1]} &, VertexList[g]]]},
    {sectionQ = InfraContinuousSectionQ[fib, InfraSection[AssociationMap[p |-> {p, First[#[p]]}, VertexList[g]]]] & /@ displacements,
     displacementQ = ContinuousDisplacementQ[g, #] & /@ displacements},
    {sectionQ === displacementQ, Last[sectionQ]}],
  {True, True},
  TestID -> "InfraContinuousSectionQ-agrees-with-ContinuousDisplacementQ"
]

(* ===== FindInfraSection ===== *)

(* The trivial bundle K3 x C4: a section {f(p), p} is continuous iff f is constant along the cycle *)
VerificationTest[
  With[{fib = InfraFibration[GraphProduct[CompleteGraph[3], CycleGraph[4], "Cartesian"], Last]},
    {sections = FindInfraSection[fib, All]},
    {Length[sections], AllTrue[sections, InfraContinuousSectionQ[fib, #] &], Sort[CountDistinct[First /@ Values[First[#]]] & /@ sections]}],
  {3, True, {1, 1, 1}},
  TestID -> "FindInfraSection-trivial-bundle-constant-sections"
]

VerificationTest[
  With[{fib = InfraFibration[GraphProduct[CompleteGraph[3], CycleGraph[4], "Cartesian"], Last]},
    Length /@ {FindInfraSection[fib, 2], FindInfraSection[fib, UpTo[2]], FindInfraSection[fib, UpTo[5]], FindInfraSection[fib, 4]}],
  {2, 2, 3, 0},
  TestID -> "FindInfraSection-calling-triple"
]

VerificationTest[
  {Length[FindInfraSection[InfraFibration[CycleGraph[8], i |-> Mod[i, 4, 1]], All]],
   Length[FindInfraSection[InfraFibration[GraphUnion[CycleGraph[4], IndexGraph[CycleGraph[4], 5]], i |-> Mod[i, 4, 1]], All]]},
  {0, 2},
  TestID -> "FindInfraSection-connected-double-cover-has-none"
]

EndTestSection[]
