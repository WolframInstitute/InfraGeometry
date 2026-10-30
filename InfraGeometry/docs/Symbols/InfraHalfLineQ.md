---
Template: Symbol
Name: InfraHalfLineQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraHalfLineQ
Keywords: [ray, half-line, shortest path, inextensible, predicate]
SeeAlso: [InfraHalfLine, RandomInfraHalfLine, InfraSegmentQ, InfraInfiniteLineQ]
RelatedGuides: [Experimental]
---

## Usage

<code>[InfraHalfLineQ]()[*g*, *ray*]</code> tests whether the vertex list *ray* is a ray in *g*: a shortest path from its first vertex that cannot be prolonged past its last.

<code>[InfraHalfLineQ]()[*g*, {*ray₁*, *ray₂*, …}]</code> tests every ray of a list.

## Details & Options

A ray *v₀, …, vₖ* is a shortest path, *k = d(v₀, vₖ)*, such that no neighbour of *vₖ* lies at distance *k* + 1 from *v₀*.

Only the far end must be inextensible. The origin is an end by choice, so a ray can start anywhere. A line ([InfraInfiniteLineQ]()) is inextensible at both ends, and is a ray from either end.

A list of fewer than two vertices is not a ray. A walk graph, such as a directed path graph, is read as its walks.

## Basic Examples

A ray from the centre through a vertex at distance 2. Without its last vertex it can be prolonged, and read backwards it ends at the centre, which can be prolonged too:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {ray = RandomInfraHalfLine[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {ray, c},
      PlotLabel -> {InfraHalfLineQ[g, ray], InfraHalfLineQ[g, Most @ ray], InfraHalfLineQ[g, Reverse @ ray]}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Scope

A list of rays is tested as a whole. All 140 rays from the centre of the grid through a vertex at distance 2:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {rays = RandomInfraHalfLine[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], All]},
  {Length[rays], InfraHalfLineQ[g, rays]}]
```

## Properties and Relations

A line is a ray from either end; a ray need not be a line:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1]},
  {line = RandomInfraInfiniteLine[g, c, q, RandomSeeding -> 1], ray = RandomInfraHalfLine[g, c, q, RandomSeeding -> 1]},
  {InfraHalfLineQ[g, line], InfraHalfLineQ[g, Reverse @ line], InfraInfiniteLineQ[g, ray]}]
```

## Possible Issues

A single vertex is not a ray, and a walk round a cycle is not a shortest path:

```wl
{InfraHalfLineQ[PathGraph[Range[5]], {5}], InfraHalfLineQ[CycleGraph[6], {1, 2, 3, 4, 5, 6}]}
```
