---
Template: Symbol
Name: InfraGeodesicQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraGeodesicQ
Keywords: [geodesic, infra-scale, locally shortest, walk, test]
SeeAlso: [RandomInfraGeodesic, InfraGeodesic, InfraWalkQ, InfraSegmentQ, InfraMeasurement]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

<code>[InfraGeodesicQ]()[*g*, *walk*, *s*]</code> gives `True` if *walk* is a geodesic at infra-scale *s* in *g*, and `False` otherwise.

<code>[InfraGeodesicQ]()[*g*, *walk*]</code> tests at scale [Infinity](): whether *walk* is a shortest path.

## Details & Options

A walk *v₀*, …, *vₖ* is a geodesic at infra-scale *s* when every *s* + 1 consecutive vertices form a shortest path: *d(vᵢ₋ₛ, vᵢ) = s* for *i ≥ s*, and *d(v₀, vᵢ) = i* for *i < s*.

It is locally shortest, as a Riemannian geodesic is: the walk is shortest between any two of its vertices fewer than *s* + 1 steps apart, and may be long between its ends.

A geodesic at scale *s* is a geodesic at every smaller scale. At scale 1 the test is [InfraWalkQ](); at scale [Infinity]() it is [InfraSegmentQ](). At scale 2 a walk may not step back, nor cut the corner of a triangle.

*walk* is a vertex list, a walk graph as [RandomInfraGeodesic]() returns, a list of walk graphs, or a directed acyclic graph. A directed acyclic graph passes when every path from a source to a sink passes.

A walk of fewer than two vertices is not a geodesic.

## Basic Examples

Three walks from the centre of the square grid and the scales, among 1 to 4 and [Infinity](), at which each is a geodesic. Round a unit square up to scale 2, round a square of side 2 up to scale 3, a staircase at every scale:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {walks = {{45, 46, 56, 55, 45, 46}, {45, 46, 47, 57, 67, 66, 65, 55, 45}, {45, 46, 56, 57, 67, 68}}},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {InfraWalk[walk], First @ walk},
      PlotLabel -> Select[{1, 2, 3, 4, Infinity}, s |-> InfraGeodesicQ[g, walk, s]]],
    {walk, walks}]]
```

Stepping back is a walk but not a geodesic at scale 2:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, Table[InfraGeodesicQ[g, {45, 46, 45}, s], {s, {1, 2}}]]
```

On the mesh, two steps round the corner of a triangle fail at scale 2: their ends are adjacent:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {x = First @ AdjacencyList[g, c]}, {y = First @ Intersection[AdjacencyList[g, c], AdjacencyList[g, x]]},
  InfraSubstrateHighlight[g, {InfraWalk[{x, c, y}], c}, PlotLabel -> InfraGeodesicQ[g, {x, c, y}, 2],
    ImageSize -> Medium]]
```

## Scope

A list of walk graphs passes when each one does. The geodesics of 5 edges at scale 3 from the centre:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {geodesics = RandomInfraGeodesic[g, c, 3, {5}, All]},
  {Length[geodesics], InfraGeodesicQ[g, geodesics, 3], InfraGeodesicQ[g, geodesics, 4]}]
```

The graph of a segment passes as a whole, since every path from its source to its sink is shortest:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {seg = InfraSegment[a, RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]]},
  InfraSubstrateHighlight[g, {seg, a}, PlotLabel -> InfraGeodesicQ[g, InfraMeasurement[g, seg, "Graph"]],
    ImageSize -> Medium]]
```

## Properties and Relations

At scale 1 the test is [InfraWalkQ]() and at scale [Infinity]() it is [InfraSegmentQ](), on every walk of 4 edges from the centre:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {walks = Map[Last, VertexList /@ RandomInfraGeodesic[g, c, 1, {4}, All], {2}]},
  {Length[walks], AllTrue[walks, w |-> InfraGeodesicQ[g, w, 1] === InfraWalkQ[g, w]],
   AllTrue[walks, w |-> InfraGeodesicQ[g, w, Infinity] === InfraSegmentQ[g, w]]}]
```

## Possible Issues

A single vertex is not a geodesic at any scale:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, InfraGeodesicQ[g, {45}, 1]]
```
