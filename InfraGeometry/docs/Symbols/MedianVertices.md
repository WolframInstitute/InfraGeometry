---
Template: Symbol
Name: MedianVertices
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/MedianVertices
Keywords: [median, geometric median, Fermat point, median graph, distance sum, centre]
SeeAlso: [MetricInterval, InfraMidpoint, GraphCenter, InfraSegment, RandomInfraPoint]
---

## Usage

<code>[MedianVertices]()[*g*, {*v1*, …, *vk*}]</code> gives the vertices of *g* whose distances to *v1*, …, *vk* have the least sum.

## Details & Options

A median of *v₁*, …, *vₖ* is a vertex *w* minimising *Σᵢ d(w, vᵢ)*. It is the graph analogue of the geometric median; for three points in the plane it is the Fermat point.

On the square grid the distance is the ℓ¹ distance, and a median is a coordinatewise median of the points. Three points have exactly one median, the vertex where the three intervals *I(vᵢ, vⱼ)* meet. An even number of points can have a rectangle of medians.

A graph in which every three vertices have exactly one median is a median graph. On the square mesh three points can have several medians, and the three intervals need not meet.

## Basic Examples

The medians of three random points, on the square grid and on the square mesh, with the segments between the points:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {pts = RandomInfraPoint[g, 3, RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraSegment @@@ Subsets[pts, {2}], pts, MedianVertices[g, pts]}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

On the grid the median of three points is where their intervals meet; on the mesh the intervals have no common vertex:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small"]}, {pts = RandomInfraPoint[g, 3, RandomSeeding -> 1]},
    {MedianVertices[g, pts], Intersection @@ (MetricInterval[g, ##] & @@@ Subsets[pts, {2}])}],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Scope

Four points on the grid have a rectangle of medians:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {pts = RandomInfraPoint[g, 4, RandomSeeding -> 4]},
  InfraSubstrateHighlight[g, {pts, AssociationThread[MedianVertices[g, pts], 1]}, ImageSize -> Medium]]
```

## Properties and Relations

The number of medians of three random points, for ten draws. One on the grid, a median graph; often more on the mesh:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small"]},
    Table[Length @ MedianVertices[g, RandomInfraPoint[g, 3, RandomSeeding -> s]], {s, 10}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```
