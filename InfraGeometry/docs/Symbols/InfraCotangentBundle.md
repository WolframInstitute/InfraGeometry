---
Template: Symbol
Name: InfraCotangentBundle
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraCotangentBundle
Keywords: [cotangent bundle, covector, reversed ray]
SeeAlso: [InfraTangentBundle, InfraRays, InfraBundleMorphism, InfraCanonicalOneForm, InfraTotalGraph]
RelatedGuides: [InfraFiberBundles, InfraAnalysis]
---

## Usage

<code>[InfraCotangentBundle]()[*g*, *r*]</code> is the cotangent bundle of *g* at scale *r*: the total vertices are the reversed rays of length *r*, projected to their last vertex, with the adjacency of [InfraTangentBundle]().

## Details & Options

- A covector at *p* is a ray arriving at *p*, the reversal of a ray leaving *p*.
- The total graph is the tangent total graph with every ray reversed; only the projection differs.

## Basic Examples

The rays arriving at the vertex 6 of the grid, each in its own colour.

```wl
With[
  {g = GridGraph[{4, 4}]},
  InfraSubstrateHighlight[g, InfraWalk /@ VertexList @ InfraFiber[InfraCotangentBundle[g, 2], 6]]]
```

The cotangent bundle of the grid at scale 2, the fiber over 6 drawn.

```wl
With[
  {fib = InfraCotangentBundle[GridGraph[{4, 4}], 2]},
  {total = InfraTotalGraph[fib]},
  InfraSubstrateHighlight[total, {InfraDensity[total, VertexList @ InfraFiber[fib, 6]]}]]
```

## Properties and Relations

The reversal is a bundle morphism from the tangent bundle to the cotangent bundle.

```wl
With[
  {g = GridGraph[{4, 4}]},
  InfraBundleMorphismQ[InfraTangentBundle[g, 2], InfraCotangentBundle[g, 2], Reverse]]
```
