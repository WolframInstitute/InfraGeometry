---
Template: Symbol
Name: FindInfraArc
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraArc
Keywords: [arc, circle, band, search]
SeeAlso: [InfraArc, InfraVertexList, FindInfraCircle, FindInfraSegment]
RelatedGuides: [Experimental]
---

## Usage

<code>[FindInfraArc]()[*graph*, *c*, {*p1*, ..., *pk*}]</code> gives one arc around *c* through the points as a vertex list.

<code>[FindInfraArc]()[*graph*, *c*, {*p1*, ..., *pk*}, *n* | UpTo[*n*] | All]</code> gives a `List` of *n*, at most *n*, or every such arc.

## Details & Options

Searches the band graph directly — `FindPath` at the band distance between consecutive points, folded together at the knots — independently of [InfraArc]()'s own graph, so it is the check on that graph rather than a reader of it. Returns exactly the vertex-list shapes [InfraVertexList]() gives for `InfraArc[c, {p1, ..., pk}]`.

Option `"RadiusDelta" -> delta | {deltaIn, deltaOut}` widens the band about *d*(*c*, *p1*), same as on [InfraArc]() and [InfraCircle](). A scalar *delta* means `{0, delta}`, outward only; the default is `0`. No `Method`, no `Properties`.

## Basic Examples

One of the eight minor arcs of a quarter circle of radius 3 about the centre of a grid, on the band widened one step each way, drawn as a walk.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {found = FindInfraArc[g, 41, {14, 44}, "RadiusDelta" -> {1, 1}]},
  {InfraHighlightGraph[g, {InfraWalk[found] -> $InfraCircleColor, Directive[$InfraPointColor], 41, 14, 44}, ImageSize -> 250],
   found}]
```

A trailing count gives a `List`; all eight are there.

```wl
Length @ FindInfraArc[GridGraph[{9, 9}], 41, {14, 44}, All, "RadiusDelta" -> {1, 1}]
```

Through an intermediate point the arc is a polyline of minor arcs, one per piece.

```wl
FindInfraArc[GridGraph[{9, 9}], 41, {14, 44, 68}, "RadiusDelta" -> 1]
```

One minor arc between two points on the ring at distance 2 from the centre of a grid, then both of them.

```wl
FindInfraArc[GridGraph[{5, 5}], 13, {7, 19}, "RadiusDelta" -> 1]
```

```wl
FindInfraArc[GridGraph[{5, 5}], 13, {7, 19}, All, "RadiusDelta" -> 1]
```
