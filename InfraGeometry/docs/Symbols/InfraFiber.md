---
Template: Symbol
Name: InfraFiber
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFiber
Keywords: [fiber, fibration, preimage]
SeeAlso: [InfraFibers, InfraFibration, InfraFibrationAssociation, InfraTotalGraph, InfraBaseGraph]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[InfraFiber]()[*fib*, *p*]</code> gives the fiber over the base vertex *p*, the subgraph of the total graph on the vertices projecting to *p*.

## Basic Examples

The fiber of the grid product bundle over the base vertex 6 is a triangle.

```wl
With[
  {fib = InfraFiberedSubstrate["GridProductBundle", "Small"]},
  {total = InfraTotalGraph[fib]},
  GraphicsRow[{InfraSubstrateHighlight[total, {InfraDensity[total, VertexList @ InfraFiber[fib, 6]]}], InfraFiber[fib, 6]}]]
```

The fiber of the grid tangent bundle over 6: ten rays of length 2 and no edge between them.

```wl
With[
  {fib = InfraFiberedSubstrate["GridTangentBundle", "Small"]},
  {fiber = InfraFiber[fib, 6]},
  {fiber, VertexCount[fiber], EdgeCount[fiber]}]
```

## Properties and Relations

[InfraFibers]() gives every fiber at once.

```wl
With[
  {fib = InfraFiberedSubstrate["GridProductBundle", "Small"]},
  InfraFiber[fib, 6] === InfraFibers[fib][6]]
```
