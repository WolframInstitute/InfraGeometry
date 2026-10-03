---
Template: Symbol
Name: InfraDisplacementBundle
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraDisplacementBundle
Keywords: [displacement bundle, displacement, pair, scale, Levi-Civita]
SeeAlso: [InfraTangentBundle, InfraBundleMorphism, FindInfraLeviCivitaConnection, InfraParallelTransport, InfraHolonomyAngle, InfraTotalGraph, InfraFiberedSubstrate]
RelatedGuides: [InfraFiberBundles, InfraAnalysis]
---

## Usage

<code>[InfraDisplacementBundle]()[*g*, *r*]</code> is the displacement bundle of *g* at scale *r*: the total vertices are the pairs {*p*, *v*} with *d*(*p*, *v*) = *r*, projected to *p*, two pairs adjacent iff their base points and their endpoints are equal or adjacent.

## Details & Options

- The fiber over *p* is the sphere of radius *r* about *p*, one vertex for each endpoint *v*.
- A section is a displacement: it moves each vertex *p* to a vertex at distance *r*.
- [InfraDisplacementBundle]() is inert. [InfraTotalGraph]() builds its total graph on every call; <code>[InfraFibration]()[*fib*]</code> builds it once.
- The Levi-Civita connection is defined on this bundle: [FindInfraLeviCivitaConnection](), and the list form of [InfraParallelTransport]() and [InfraHolonomyAngle]().

## Basic Examples

The displacement bundle of a grid at scale 1, the fiber over the vertex 6 drawn.

```wl
With[
  {fib = InfraFiberedSubstrate["GridDisplacementBundle", "Small"]},
  {total = InfraTotalGraph[fib]},
  InfraSubstrateHighlight[total, {InfraDensity[total, VertexList @ InfraFiber[fib, 6]]}]]
```

At scale 2 the fiber over 6 is the sphere of radius 2 about 6.

```wl
With[
  {g = GridGraph[{4, 4}]},
  {fib = InfraDisplacementBundle[g, 2]},
  InfraSubstrateHighlight[g, {Last /@ VertexList @ InfraFiber[fib, 6]}]]
```

## Scope

The displacement bundles of the catalogue at scale 1: over the grid, the triangular torus and the sphere mesh.

```wl
GraphicsRow[InfraTotalGraph @ InfraFiberedSubstrate[#, "Small"] & /@ {"GridDisplacementBundle", "TriangularTorusDisplacementBundle", "SphereMeshDisplacementBundle"}]
```

## Properties and Relations

The endpoint map from the tangent bundle is a bundle morphism. At scale 2 on the 4 x 4 grid the tangent bundle has 104 rays and 520 edges, the displacement bundle 68 pairs and 220 edges.

```wl
With[
  {g = GridGraph[{4, 4}]},
  {tangent = InfraTangentBundle[g, 2], displacement = InfraDisplacementBundle[g, 2]},
  {InfraBundleMorphismQ[tangent, displacement, InfraBundleMorphism[tangent, displacement]],
    {VertexCount[#], EdgeCount[#]} & /@ InfraTotalGraph /@ {tangent, displacement}}]
```
