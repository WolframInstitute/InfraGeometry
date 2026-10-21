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

<code>[InfraRays]()[*g*, *p*, *r*]</code> gives the rays of length *r* from *p*: the walks {*p*, *u₁*, …, *uᵣ*} with *d(p, uᵢ) = i*.

## Details & Options

A ray moves one step further from *p* at every step. So a ray of length *r* is a shortest path from *p* to a vertex of the sphere *Sᵣ(p) = {v : d(p, v) = r}*, and every such shortest path is a ray.

The number of rays ending at *v* is the number of shortest paths from *p* to *v*. On the square grid, away from the rim, there are *4(2ʳ − 1)* rays of length *r ≥ 1*.

The rays of length 0 are {{*p*}}. The first *s* + 1 vertices of a ray of length *r* form a ray of length *s*.

The rays of length *r* from *p* are the fiber over *p* of <code>[InfraTangentBundle]()[*g*, *r*]</code>: the tangent vectors at *p* at scale *r*.

## Basic Examples

The rays of length 3 from the centre, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    InfraSubstrateHighlight[g, Append[InfraWalk /@ InfraRays[g, c, 3], c]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The number of rays against the length on the square grid, *4(2ʳ − 1)*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {Table[Length @ InfraRays[g, c, r], {r, 1, 7}], Table[4 (2^r - 1), {r, 1, 7}]}]
```

## Properties and Relations

The rays end on the sphere of radius *r*, and the number of rays ending at a vertex is the number of shortest paths to it. Drawn as the size of the vertex:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    InfraSubstrateHighlight[g, {Counts[Last /@ InfraRays[g, c, 4]], c}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {ends = Counts[Last /@ InfraRays[g, c, 4]]},
  KeySort[ends] === KeySort @ AssociationMap[InfraMeasurement[g, InfraSegment[c, #], "Cardinality"] &, Keys[ends]]]
```

The rays from *p* are the fiber of the tangent bundle over *p*:

```wl
With[{g = GridGraph[{4, 4}]},
  Sort @ InfraRays[g, 6, 2] === Sort @ VertexList @ InfraFiber[InfraTangentBundle[g, 2], 6]]
```
