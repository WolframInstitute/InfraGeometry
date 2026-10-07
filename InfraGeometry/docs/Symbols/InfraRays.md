---
Template: Symbol
Name: InfraRays
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraRays
Keywords: [ray, geodesic spray, shortest path, tangent vector]
SeeAlso: [InfraTangentBundle, InfraCotangentBundle, InfraBundleMorphism, InfraCanonicalOneForm, SprayGraph]
RelatedGuides: [InfraFiberBundles, InfraAnalysis]
---

## Usage

<code>[InfraRays]()[*g*, *p*, *r*]</code> gives the rays of length *r* from *p*: the walks {*p*, *u1*, …, *ur*} with *d*(*p*, *ui*) = *i*.

## Details & Options

- A ray is a shortest path that starts at *p* and moves one step further from *p* at each step.
- The rays of length *r* from *p* are the total vertices of <code>[InfraTangentBundle]()[*g*, *r*]</code> over *p*.

## Basic Examples

The rays of length 2 from an interior vertex of the grid, each in its own colour.

```wl
With[
  {g = First @ InfraFiberedSubstrate["GridTangentBundle", "Small"]},
  InfraSubstrateHighlight[g, InfraWalk /@ InfraRays[g, 6, 2]]]
```

The rays of length 2 from the centre of the triangular tiling.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  InfraSubstrateHighlight[g, InfraWalk /@ InfraRays[g, c, 2]]]
```

## Properties and Relations

The rays from *p* are the fiber of the tangent bundle over *p*.

```wl
With[
  {g = GridGraph[{4, 4}]},
  Sort @ InfraRays[g, 6, 2] === Sort @ VertexList @ InfraFiber[InfraTangentBundle[g, 2], 6]]
```
