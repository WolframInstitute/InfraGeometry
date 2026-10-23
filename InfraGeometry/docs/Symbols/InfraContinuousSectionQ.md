---
Template: Symbol
Name: InfraContinuousSectionQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraContinuousSectionQ
Keywords: [continuous section, partial section, adjacency preservation, displacement, weak continuity]
SeeAlso: [InfraSection, InfraSectionQ, InfraParallelSectionQ, RandomInfraSection, FindInfraSection, InfraDisplacementBundle]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraContinuousSectionQ]()[*fib*, [InfraSection]()[*s*]]</code> gives [True]() if *s* is a section of the fibered graph *fib* that sends every base edge between its keys to a total edge.

<code>[InfraContinuousSectionQ]()[*fib*, {*sec1*, *sec2*, …}]</code> gives [True]() if every *secᵢ* is a continuous section.

## Details & Options

The section *s* is continuous when *s(p)* lies over *p* for every key *p*, as [InfraSectionQ]() tests, and *{s(p), s(q)}* is a total edge for every base edge *{p, q}* with both ends keys of *s*.

A section may be partial. Only the base edges inside its domain are checked, and the empty section is continuous.

On the displacement bundle at scale 1 a section is a displacement *p ↦ v(p)* with *v(p)* adjacent to *p*. It is continuous iff *d(v(p), v(q)) ≤ 1* for every base edge *{p, q}*: neighbours move to equal or adjacent vertices.

Continuity uses only the total graph. [InfraParallelSectionQ]() asks more: that a chosen connection carries *s(p)* to *s(q)*.

The empty list gives [False]().

## Basic Examples

A sheet of the trivial double cover of the square grid is continuous. Moving the value at the centre to the other sheet breaks continuity at its four edges:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {xy = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {fib = InfraFiberedGraph[GraphProduct[g, Graph[{1, 2}, {}], "Cartesian"], First]},
  {sections = Table[InfraSection @ AssociationMap[p |-> {p, If[p == c, k, 1]}, VertexList[g]], {k, 2}]},
  GraphicsRow @ Table[
    InfraFiberedGraphHighlight[fib, {s}, "BaseVertexCoordinates" -> xy, PlotLabel -> InfraContinuousSectionQ[fib, s]],
    {s, sections}]]
```

A random continuous section of the displacement bundle of the grid, and a random section:

```wl
With[{fib = InfraDisplacementBundle[InfraSubstrate["SquareGridGraph", "Small"], 1]},
  {InfraContinuousSectionQ[fib, RandomInfraSection[fib, Properties -> {"Continuous"}, RandomSeeding -> 1]],
    InfraContinuousSectionQ[fib, RandomInfraSection[fib, RandomSeeding -> 1]]}]
```

## Scope

A list of sections is tested member by member. The two sheets of the trivial double cover:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {fib = InfraFiberedGraph[GraphProduct[g, Graph[{1, 2}, {}], "Cartesian"], First]},
  InfraContinuousSectionQ[fib, FindInfraSection[fib, All]]]
```

## Properties and Relations

On the displacement bundle at scale 1, continuity is *d(v(p), v(q)) ≤ 1* on every base edge:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {fib = InfraDisplacementBundle[g, 1]},
  {sections = {RandomInfraSection[fib, Properties -> {"Continuous"}, RandomSeeding -> 1],
    RandomInfraSection[fib, RandomSeeding -> 1]}},
  Table[{InfraContinuousSectionQ[fib, s],
      AllTrue[EdgeList[g], e |-> GraphDistance[g, Last @ First[s][First @ e], Last @ First[s][Last @ e]] <= 1]},
    {s, sections}]]
```

## Possible Issues

A continuous partial section need not extend. On the connected double cover of the cycle of length 8, the first sheet over the vertices 1 to 7 is continuous, but no continuous section extends it, since both values over 8 break one of its two edges:

```wl
With[{fib = InfraFiberedSubstrate["CycleDoubleCover", "Small"]},
  {part = InfraSection @ AssociationMap[{#, 1} &, Range[7]]},
  {InfraContinuousSectionQ[fib, part], RandomInfraSection[fib, part, Properties -> {"Continuous"}],
    InfraContinuousSectionQ[fib, #] & /@ RandomInfraSection[fib, part, All]}]
```
