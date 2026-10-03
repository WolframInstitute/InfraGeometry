---
Template: Symbol
Name: InfraContinuousSectionQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraContinuousSectionQ
Keywords: [continuous section, smooth section, displacement, vector field]
SeeAlso: [InfraSection, InfraSectionQ, FindInfraSection, RandomInfraSection, InfraDisplacementBundle]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[InfraContinuousSectionQ]()[*fib*, [InfraSection]()[*s*]]</code> tests whether *s* is a section of *fib* mapping every base edge between its keys to a total edge.

## Details & Options

- Only base edges with both endpoints among the keys of *s* are checked, so a section over a part of the base is continuous when it is continuous there.
- On a displacement bundle a continuous section is a continuous displacement: adjacent vertices move to adjacent or equal vertices.

## Basic Examples

The up field on the grid is continuous: its values, with the total edges between them, form a copy of the base under it.

```wl
With[
  {fib = InfraFiberedSubstrate["GridDisplacementBundle", "Small"]},
  {total = InfraTotalGraph[fib]},
  {up = InfraSection @ AssociationMap[p |-> {p, p + 1}, Select[Range[16], Mod[#, 4] != 0 &]]},
  {InfraSubstrateHighlight[total, Prepend[InfraWalk /@ List @@@ EdgeList @ Subgraph[total, Values @ First @ up], Directive[StandardBlue]]],
    InfraContinuousSectionQ[fib, up]}]
```

A random section is not: few of the total edges between its values remain.

```wl
With[
  {fib = InfraFiberedSubstrate["GridDisplacementBundle", "Small"]},
  {total = InfraTotalGraph[fib]},
  {random = (SeedRandom[2]; RandomInfraSection[fib])},
  {InfraSubstrateHighlight[total, Prepend[InfraWalk /@ List @@@ EdgeList @ Subgraph[total, Values @ First @ random], Directive[StandardBlue]]],
    InfraContinuousSectionQ[fib, random]}]
```
