---
Template: Symbol
Name: InfraFiber
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFiber
Keywords: [fiber, preimage, fibered graph, vertical edges]
SeeAlso: [InfraFibers, InfraFiberedGraph, InfraProjection, InfraTotalSpace, InfraBaseSpace, InfraDisplacementBundle, InfraTangentBundle]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraFiber]()[*fib*, *p*]</code> gives the fiber of *fib* over the base vertex *p*: the subgraph of the total graph induced on the vertices that project to *p*.

## Details & Options

The fiber is *F(p) = π⁻¹(p)*, with the edges of the total graph between its vertices. These are the vertical edges over *p*.

The fibers over different base vertices are disjoint, and together they hold every vertex of the total graph. [InfraFibers]() gives them all.

The fibers of the constructions:

| Fibered graph | Fiber over *p* |
|---|---|
| <code>[InfraDisplacementBundle]()[*g*, *r*]</code> | the pairs {*p*, *v*} with *d(p, v) = r*, one for each vertex of the sphere of radius *r* about *p* |
| <code>[InfraTangentBundle]()[*g*, *r*]</code> | the rays {*p*, *u₁*, …, *uᵣ*} with *d(p, uᵢ) = i* |

On a base without triangles the fibers of the tangent bundle have no edges.

A *p* that is not a base vertex gives the empty graph.

## Basic Examples

The square grid projected to its columns. The fiber over 5 is the fifth column, a path:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {fib = InfraFiberedGraph[g, AssociationThread[VertexList[g], Round @ GraphEmbedding[g][[All, 1]]]]},
  GraphicsRow[{InfraSubstrateHighlight[g, {InfraFiber[fib, 5]}], InfraFiber[fib, 5]}]]
```

The product of the 4 × 4 grid with a triangle. Every fiber is a triangle:

```wl
With[{fib = InfraFiberedSubstrate["GridProductBundle", "Small"]},
  GraphicsRow[{InfraFiberedGraphHighlight[fib, {InfraFiber[fib, 6]}], InfraFiber[fib, 6]}]]
```

## Scope

The fiber of the displacement bundle over the centre is the circle of radius 3, drawn by the second vertices of its pairs:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    InfraSubstrateHighlight[g, {Last /@ VertexList @ InfraFiber[InfraDisplacementBundle[g, 3], c], c}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The fiber of the tangent bundle of the 4 × 4 grid over 6: ten rays of length 2 and no edges:

```wl
With[{fiber = InfraFiber[InfraFiberedSubstrate["GridTangentBundle", "Small"], 6]},
  {VertexList[fiber], EdgeCount[fiber]}]
```

## Properties and Relations

[InfraFibers]() gives every fiber at once:

```wl
With[{fib = InfraFiberedSubstrate["GridProductBundle", "Small"]},
  InfraFiber[fib, 6] === InfraFibers[fib][6]]
```

## Possible Issues

Base vertices are compared exactly. Projected to unrounded coordinates, the columns are the reals `5.`, not the integer `5`:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {fib = InfraFiberedGraph[g, AssociationThread[VertexList[g], GraphEmbedding[g][[All, 1]]]]},
  {VertexCount @ InfraFiber[fib, 5], VertexCount @ InfraFiber[fib, 5.]}]
```
