---
Template: Symbol
Name: InfraFibrationAssociation
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFibrationAssociation
Keywords: [projection, fibration, fiber, total vertex, base vertex]
SeeAlso: [InfraFibration, InfraTotalGraph, InfraBaseGraph, InfraFiber, InfraFibers]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[InfraFibrationAssociation]()[*fib*]</code> gives the projection of *fib* as an association from each total vertex *x* to the base vertex *p* below it.

## Details & Options

- [InfraFibrationAssociation]() is one of the two primitives of a fibration; the other is [InfraTotalGraph]().
- For a literal fibration given by a function, the function is evaluated on every vertex of the total graph.
- Association projections must cover exactly the total vertices. Every vertex is one literal key, including a list-valued label.
- The tangent and displacement bundles project a ray or a pair to its first vertex. The cotangent bundle projects a reversed ray to its last vertex.

## Basic Examples

The total vertices that project to the base vertex 6 of the grid tangent bundle.

```wl
SeedRandom[ 7 ];
With[
  {fib = InfraFiberedSubstrate["GridTangentBundle", "Small"]},
  {total = InfraTotalGraph[fib], proj = InfraFibrationAssociation[fib]},
  InfraSubstrateHighlight[total, {InfraDensity[total, Keys @ Select[proj, # == 6 &]]}]]
```

The number of total vertices over each base vertex, drawn as a density on the base: the corners carry the fewest rays.

```wl
SeedRandom[ 7 ];
With[
  {fib = InfraFiberedSubstrate["GridTangentBundle", "Small"]},
  InfraSubstrateHighlight[First @ fib, {Counts @ Values @ InfraFibrationAssociation[fib]}]]
```

## Properties and Relations

A ray of the cotangent bundle projects to its last vertex.

```wl
SeedRandom[ 7 ];
Take[Normal @ InfraFibrationAssociation @ InfraCotangentBundle[GridGraph[{4, 4}], 2], 3]
```
