---
Template: Symbol
Name: InfraSection
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSection
Keywords: [section, vector field, displacement, inert map]
SeeAlso: [InfraSectionQ, InfraContinuousSectionQ, RandomInfraSection, FindInfraSection, InfraCovariantDerivative, InfraFibration]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[InfraSection]()[*s*]</code> is a section of a fibration, the association *s* from base vertices to total vertices over them; it carries no graph.

## Details & Options

- [InfraSection]() is inert. The fibration it is a section of is given to each function that reads it: [InfraSectionQ](), [InfraContinuousSectionQ](), [InfraCovariantDerivative]().
- The keys of *s* may be a part of the base: a section over a subset.
- A section of [InfraTangentBundle]() is a vector field at the scale of the bundle. A section of [InfraDisplacementBundle]() is a displacement.

## Basic Examples

The up field on the grid: every vertex below the top row moved one step up, a section of the displacement bundle at scale 1. On the grid it reads as the vertical edges.

```wl
With[
  {g = First @ InfraFiberedSubstrate["GridDisplacementBundle", "Small"]},
  {up = InfraSection @ AssociationMap[p |-> {p, p + 1}, Select[Range[16], Mod[#, 4] != 0 &]]},
  InfraSubstrateHighlight[g, Prepend[InfraWalk /@ Values @ First @ up, Directive[StandardBlue]]]]
```

The same section in the total graph: its values, with the total edges between them.

```wl
With[
  {fib = InfraFiberedSubstrate["GridDisplacementBundle", "Small"]},
  {total = InfraTotalGraph[fib]},
  {up = InfraSection @ AssociationMap[p |-> {p, p + 1}, Select[Range[16], Mod[#, 4] != 0 &]]},
  InfraSubstrateHighlight[total, Prepend[InfraWalk /@ List @@@ EdgeList @ Subgraph[total, Values @ First @ up], Directive[StandardBlue]]]]
```

## Properties and Relations

The up field is a section, and it is continuous: every base edge between its keys goes to a total edge.

```wl
With[
  {fib = InfraFiberedSubstrate["GridDisplacementBundle", "Small"]},
  {up = InfraSection @ AssociationMap[p |-> {p, p + 1}, Select[Range[16], Mod[#, 4] != 0 &]]},
  {InfraSectionQ[fib, up], InfraContinuousSectionQ[fib, up]}]
```
