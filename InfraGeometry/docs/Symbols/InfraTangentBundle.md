---
Template: Symbol
Name: InfraTangentBundle
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraTangentBundle
Keywords: [tangent bundle, ray, vector field, scale]
SeeAlso: [InfraRays, InfraCotangentBundle, InfraDisplacementBundle, InfraBundleMorphism, InfraTotalGraph, InfraFiberedSubstrate]
RelatedGuides: [InfraFiberBundles, InfraAnalysis]
---

## Usage

<code>[InfraTangentBundle]()[*g*, *r*]</code> is the tangent bundle of *g* at scale *r*: the total vertices are the rays of length *r*, projected to their first vertex, two rays adjacent iff at every position their vertices are equal or adjacent.

## Details & Options

- A tangent vector at *p* at scale *r* is a ray of length *r* from *p*, as given by [InfraRays]().
- [InfraTangentBundle]() is inert. [InfraTotalGraph]() builds its total graph on every call; <code>[InfraFibration]()[*fib*]</code> builds it once.
- The scale *r* must be a positive integer.
- At scale 1 a ray is an edge, and the tangent bundle has the same total graph as the displacement bundle at scale 1.

## Basic Examples

The tangent bundle of a grid at scale 2, the rays over the vertex 6 drawn.

```wl
With[
  {fib = InfraFiberedSubstrate["GridTangentBundle", "Small"]},
  {total = InfraTotalGraph[fib]},
  InfraSubstrateHighlight[total, {InfraDensity[total, VertexList @ InfraFiber[fib, 6]]}]]
```

The same rays drawn on the grid.

```wl
With[
  {g = First @ InfraFiberedSubstrate["GridTangentBundle", "Small"]},
  InfraSubstrateHighlight[g, InfraWalk /@ InfraRays[g, 6, 2]]]
```

## Scope

The tangent bundle of the grid at scales 1 and 2.

```wl
With[
  {g = GridGraph[{4, 4}]},
  GraphicsRow[InfraTotalGraph @ InfraTangentBundle[g, #] & /@ {1, 2}]]
```

The tangent bundle of the octahedron at scale 2 from the catalogue.

```wl
InfraTotalGraph @ InfraFiberedSubstrate["OctahedronTangentBundle"]
```

## Properties and Relations

On the grid, a triangle-free graph, a fiber of rays has no edges.

```wl
With[
  {fib = InfraFiberedSubstrate["GridTangentBundle", "Small"]},
  {InfraFiber[fib, 6], EdgeCount @ InfraFiber[fib, 6]}]
```

The truncation to a shorter scale is a bundle morphism.

```wl
With[
  {g = GridGraph[{4, 4}]},
  InfraBundleMorphismQ[InfraTangentBundle[g, 2], InfraTangentBundle[g, 1], ray |-> Take[ray, 2]]]
```
