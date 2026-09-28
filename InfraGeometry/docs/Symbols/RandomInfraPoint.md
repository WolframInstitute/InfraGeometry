---
Template: Symbol
Name: RandomInfraPoint
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraPoint
Keywords: [point, random vertex, distance]
SeeAlso: [InfraCenter, FindInfraPoint]
RelatedGuides: [EuclideanGeometryGuide]
---

## Usage

<code>[RandomInfraPoint]()[*graph*]</code> gives a uniformly random vertex of *graph*.

<code>[RandomInfraPoint]()[*graph*, *p*, *d*]</code> gives a uniformly random vertex at graph distance *d* from *p*.

## Details & Options

A point on a graph is a bare vertex, so `RandomInfraPoint` returns one directly rather than a wrapped object. The two-argument form draws uniformly from the metric shell `{v : d(p, v) == d}`; it is `RandomChoice @ FindInfraShell[graph, p, d]`.

`SeedRandom` in front reproduces the draw, as with every random construction in this paclet.

## Basic Examples

A random vertex of a grid, and a random vertex at distance 2 from its center.

```wl
With[
  {g = GridGraph[{5, 5}]},
  SeedRandom[1];
  RandomInfraPoint[g]
]
```

```wl
With[
  {g = GridGraph[{5, 5}]},
  {c = InfraCenter[g]},
  SeedRandom[1];
  RandomInfraPoint[g, c, 2]
]
```
