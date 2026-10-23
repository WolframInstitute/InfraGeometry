---
Template: Symbol
Name: BallIntersectionFiltrationValue
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/BallIntersectionFiltrationValue
Keywords: [filtration value, birth radius, ball intersection complex, Cech complex, Vietoris-Rips complex, miniball]
SeeAlso: [BallIntersectionComplex, BallIntersectionFiltration, MiniballRadius, CechComplex]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[BallIntersectionFiltrationValue]()[*data*, *σ*, *k*]</code> gives the least radius at which the positions *σ* form a simplex of the order-*k* ball intersection complex of *data*.

<code>[BallIntersectionFiltrationValue]()[*data*, *σ*]</code> takes *k* = [Infinity](): the birth radius in the Čech complex.

## Details & Options

Let *ρ(τ)* be the least radius at which the balls about the points of *τ* have a common point. Then *fₖ(σ) = ρ(σ)* when *σ* has at most *k* elements, and otherwise *fₖ(σ)* is the largest *ρ(τ)* over the subsets *τ* of *σ* with *k* elements.

The set *σ* is a simplex of <code>[BallIntersectionComplex]()[*data*, *r*, *k*]</code> exactly when *fₖ(σ) ≤ r*. The value grows with *σ* and with *k*, up to *ρ(σ)*.

For Euclidean points *ρ* is [MiniballRadius](). With `"Metric" -> g` the data are vertices of the graph *g*, and *ρ(τ)* is the least *r* for which some vertex of *g* lies within *r* of every point of *τ*. With a distance matrix or a function that vertex must be a point of *data*.

For *k* = 2 the value of a pair at distance *d* is *d/2* for Euclidean points and *⌈d/2⌉* for a graph.

| Option | Default | Values |
|---|---|---|
| `"Metric"` | [Automatic]() | [Automatic]() for Euclidean points; a graph *g*; a distance matrix of *data*; a distance function |

## Basic Examples

The four corners of a square of the grid, at orders 2, 3, 4 and [Infinity](). With the graph metric the balls meet in pairs and three at a time from radius 1, all four only from radius 2. The disks about the same points in the plane meet all four as soon as the two diagonals do, at *√2/2*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {corners = First /@ First @ FindCycle[{g, First @ GraphCenter[g]}, {4}]},
  {xy = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  InfraSubstrateHighlight[g, {corners}, ImageSize -> Medium,
    PlotLabel -> {Table[BallIntersectionFiltrationValue[corners, Range[4], k, "Metric" -> g], {k, {2, 3, 4, Infinity}}],
      Table[BallIntersectionFiltrationValue[Lookup[xy, corners], Range[4], k], {k, {2, 3, 4, Infinity}}]}]]
```

The equilateral triangle of side 1. At order 2 it is born at radius 1/2, when the disks touch in pairs; in the Čech complex at radius *1/√3*, when all three meet at the centre:

```wl
With[{points = N @ CirclePoints[1 / Sqrt[3], 3]},
  GraphicsRow @ Table[
    With[{s = BallIntersectionFiltrationValue[points, {1, 2, 3}, k]},
      Graphics[{{StandardBlue, Opacity[0.15], Disk[#, s] & /@ points}, Point[points]}, PlotLabel -> s]],
    {k, {2, Infinity}}]]
```

## Options

### Metric

Two vertices of the grid at distance 2. Their balls first meet at radius 1 in the graph, at a vertex between them. The disks about the same points in the plane meet at half their Euclidean distance, here *√2/2*. With the distance matrix of the two alone the common point must be one of them, and the radius is 2:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {pair = {c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1]}},
  {xy = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {BallIntersectionFiltrationValue[pair, {1, 2}, 2, "Metric" -> g],
   BallIntersectionFiltrationValue[Lookup[xy, pair], {1, 2}, 2],
   BallIntersectionFiltrationValue[pair, {1, 2}, 2, "Metric" -> {{0, 2}, {2, 0}}]}]
```

## Properties and Relations

The order-2 complex at radius *r* is the set of all subsets whose value is at most *r*. The vertices within distance 2 of the centre of the grid, at radius 1:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {data = Keys @ InfraMeasurement[g, InfraBall[First @ GraphCenter[g], 2], "VertexDensity"]},
  BallIntersectionComplex[data, 1, 2, "Metric" -> g] ===
    Select[Subsets[Range @ Length[data], {1, 5}], BallIntersectionFiltrationValue[data, #, 2, "Metric" -> g] <= 1 &]]
```

The value of a pair is half its distance, rounded up, with the graph metric:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Table[With[{v = RandomInfraPoint[g, InfraShell[c, d], RandomSeeding -> 1]},
    {d, BallIntersectionFiltrationValue[{c, v}, {1, 2}, 2, "Metric" -> g]}], {d, 1, 6}]]
```
