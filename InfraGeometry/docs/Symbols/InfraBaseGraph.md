---
Template: Symbol
Name: InfraBaseGraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraBaseGraph
Keywords: [base graph, fibration, projection]
SeeAlso: [InfraFibration, InfraTotalGraph, InfraFibrationAssociation, InfraFiber, InfraFibers]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[InfraBaseGraph]()[*fib*]</code> gives the base graph of *fib*: the projected vertices, *p* and *q* adjacent iff some total edge projects onto {*p*, *q*}.

## Details & Options

- A fibration does not store its base. [InfraBaseGraph]() reconstructs it from [InfraTotalGraph]() and [InfraFibrationAssociation]().
- A base vertex over which there is no total vertex is not in the base graph.

## Basic Examples

The Moebius ladder and the cycle it lies over.

```wl
With[
  {fib = InfraFiberedSubstrate["MoebiusLadderCover", "Small"]},
  GraphicsRow[{InfraTotalGraph[fib], InfraBaseGraph[fib]}]]
```

The base of the grid tangent bundle is the grid it was built on.

```wl
With[
  {fib = InfraFiberedSubstrate["GridTangentBundle", "Small"]},
  {InfraBaseGraph[fib], IsomorphicGraphQ[InfraBaseGraph[fib], First @ fib]}]
```
