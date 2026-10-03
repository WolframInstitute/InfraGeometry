---
Template: Symbol
Name: InfraTangentBundle
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraTangentBundle
SeeAlso: [InfraDisplacementBundle, InfraCotangentBundle, InfraRays, InfraBundleMorphism, InfraTotalGraph]
RelatedGuides: [InfraAnalysis, InfraFiberBundles]
---

## Usage

`InfraTangentBundle[g, r]` is the tangent bundle of g at scale r: the total vertices are the rays of length r, projected to their first vertex, two rays adjacent iff at every position their vertices are equal or adjacent.

## Basic Examples

The total graph over a grid: each fiber is a small cluster of rays around its base vertex.

```wl
With[
  {g = GridGraph[{4, 4}]},
  {total = InfraTotalGraph @ InfraTangentBundle[g, 2]},
  {VertexCount @ total, EdgeCount @ total}]
```
