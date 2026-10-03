---
Template: Symbol
Name: FindInfraSection
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraSection
Keywords: [continuous section, global section, clique]
SeeAlso: [InfraSection, InfraContinuousSectionQ, RandomInfraSection, InfraFiberBundleQ, InfraFiberedSubstrate]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[FindInfraSection]()[*fib*, *n*]</code> gives *n* continuous sections of *fib* over the whole base, as [InfraSection]() objects.

<code>[FindInfraSection]()[*fib*, [UpTo]()[*n*]]</code> gives at most *n*, and <code>[FindInfraSection]()[*fib*, [All]()]</code> gives every one.

## Details & Options

- A continuous section picks one total vertex over each base vertex, adjacent over every base edge.
- The sections are found as cliques of the graph joining total vertices over distinct base vertices that are not adjacent in the base or adjacent in the total graph.
- With an exact count *n*, the result is {} when fewer than *n* sections exist.
- The count is required. [All]() can be exponential in the size of the base.

## Basic Examples

The prism has two continuous sections, its two sheets.

```wl
With[
  {fib = InfraFiberedSubstrate["CycleProductBundle", "Small"]},
  {total = InfraTotalGraph[fib]},
  GraphicsRow[InfraSubstrateHighlight[total, {InfraDensity[total, Values @ First @ #]}] & /@ FindInfraSection[fib, All]]]
```

The Moebius ladder has the same base and the same fibers, and no continuous section.

```wl
With[
  {fib = InfraFiberedSubstrate["MoebiusLadderCover", "Small"]},
  {InfraTotalGraph[fib], FindInfraSection[fib, All]}]
```

A continuous vector field at scale 2 on the grid.

```wl
With[
  {fib = InfraFiberedSubstrate["GridTangentBundle", "Small"]},
  {field = First @ FindInfraSection[fib, 1]},
  {InfraSubstrateHighlight[First @ fib, InfraWalk /@ Values @ First @ field], InfraContinuousSectionQ[fib, field]}]
```

## Scope

The grid product bundle has three continuous sections, one for each vertex of the triangle. [UpTo]() gives all three, an exact count of five gives none.

```wl
With[
  {fib = InfraFiberedSubstrate["GridProductBundle", "Small"]},
  {Length @ FindInfraSection[fib, UpTo[5]], FindInfraSection[fib, 5]}]
```
