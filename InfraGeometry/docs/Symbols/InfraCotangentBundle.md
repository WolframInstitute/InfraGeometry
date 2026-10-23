---
Template: Symbol
Name: InfraCotangentBundle
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraCotangentBundle
Keywords: [cotangent bundle, covector, reversed ray, scale]
SeeAlso: [InfraTangentBundle, InfraRays, InfraBundleMorphism, InfraCanonicalOneForm, InfraTotalSpace]
RelatedGuides: [InfraFiberBundles, InfraAnalysis]
RelatedTutorials: [ExperimentalInfraBundles]
---

## Usage

<code>[InfraCotangentBundle]()[*g*, *r*]</code> is the cotangent bundle of the graph *g* at scale *r*: its total vertices are the rays of length *r* arriving at a vertex, projected to their last vertex.

## Details & Options

A ray of length *r* from *p* is a walk *(p, u₁, …, uᵣ)* with *d(p, uᵢ) = i*, as [InfraRays]() gives. A covector at *p* is the reversed walk *(uᵣ, …, u₁, p)*, a ray arriving at *p*.

Two covectors are adjacent iff at every position their vertices are equal or adjacent, the rule of [InfraTangentBundle]().

As a graph the total space is the total space of [InfraTangentBundle]() with every ray reversed. Only the projection differs: to the last vertex instead of the first.

The fiber over *p* has as many vertices as the tangent fiber over *p*: the number of shortest paths from *p* to the sphere *Sᵣ(p)*. On the square grid away from the rim that is 4 (2ʳ − 1).

[InfraCotangentBundle]() is a symbolic object, read by [InfraTotalSpace](), [InfraProjection](), [InfraFiber]() and the structural tests.

## Basic Examples

The covectors at the centre at scale 2, the rays of length 2 arriving there:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {rays = VertexList @ InfraFiber[InfraCotangentBundle[g, 2], c]},
    InfraSubstrateHighlight[g, Append[InfraWalk /@ rays, c], PlotLabel -> Length[rays]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The covectors at the centre are the reversed rays leaving it:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Sort[Reverse /@ VertexList @ InfraFiber[InfraCotangentBundle[g, 2], c]] === Sort @ InfraRays[g, c, 2]]
```

## Scope

The fiber sizes at the centre for the scales 1 to 4 on the grid, 4 (2ʳ − 1):

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Table[VertexCount @ InfraFiber[InfraCotangentBundle[g, r], c], {r, 4}]]
```

## Properties and Relations

The reversal of rays is a bundle morphism both ways between the tangent and the cotangent bundle:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {tangent = InfraTangentBundle[g, 2], cotangent = InfraCotangentBundle[g, 2]},
  {InfraBundleMorphismQ[tangent, cotangent, Reverse], InfraBundleMorphismQ[cotangent, tangent, Reverse]}]
```

The two total graphs differ only by the reversal of their vertices:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]},
  {tangent = InfraTotalSpace @ InfraTangentBundle[g, 2], cotangent = InfraTotalSpace @ InfraCotangentBundle[g, 2]},
  {Sort[Reverse /@ VertexList[tangent]] === Sort @ VertexList[cotangent],
    Sort[Sort /@ Map[Reverse, EdgeList[tangent], {2}]] === Sort[Sort /@ EdgeList[cotangent]]}]
```
