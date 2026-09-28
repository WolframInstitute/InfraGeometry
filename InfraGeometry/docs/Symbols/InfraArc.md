---
Template: Symbol
Name: InfraArc
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraArc
Keywords: [arc, circle, band, minor arc, inert head]
SeeAlso: [FindInfraArc, InfraCircle, InfraSegment, InfraMeasurement, InfraVertexList, Undetermined]
RelatedGuides: [EuclideanGeometryGuide]
---

## Usage

<code>[InfraArc]()[*c*, {*p*, *q*}]</code> is the arc around *c* from *p* to *q*: the minor arcs of the circle through *p* and *q*. It is inert; [InfraMeasurement]() and [InfraVertexList]() evaluate it on a graph.

<code>[InfraArc]()[*c*, {*p1*, …, *pk*}]</code> is the polyline of the minor arcs from each point to the next.

## Details & Options

Definition: with *r* = *d(c, p)*, the band *W* is the shell { *v* : *d(c, v)* = *r* }, widened by `"RadiusDelta"`. A minor arc from *p* to *q* is a geodesic from *p* to *q* of the subgraph induced on *W*.

Option `"RadiusDelta" -> {deltaIn, deltaOut}` widens the band to *r* − *deltaIn* ≤ *d(c, v)* ≤ *r* + *deltaOut*. A scalar `"RadiusDelta" -> delta` means `{0, delta}`, outward only. The default is `0`.

Its graph — <code>[InfraMeasurement]()[*g*, *arc*, "Graph"]</code> — is the geodesic interval of the band from *p* to *q*, with arrows of rising band distance from *p*. It is the same object [InfraSegment]() is on the whole graph. Its chains are those geodesics, all of one length.

That they are exactly the minor arcs needs the winding functional on the substrate, and *p* and *q* on a common circle. Nothing here certifies either, so `"Faithful"` is [Undetermined]().

The arc is empty when *q* leaves the band or the band disconnects *p* from *q*.

A polyline arc reads each piece on the band of the circle through its own first point. Its members concatenate one arc per piece, so its `"Cardinality"` is the product over the pieces.

## Basic Examples

A quarter of the circle of radius 3 about the centre of a grid, on the band widened one step each way: eight minor arcs, each of length 6, drawn as strongly as the number of arcs through each edge.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {arc = InfraArc[41, {14, 44}, "RadiusDelta" -> {1, 1}]},
  {InfraHighlightGraph[g, {arc -> $InfraCircleColor, Directive[$InfraPointColor], 41, 14, 44}, ImageSize -> 250],
   InfraMeasurement[g, arc, {"Cardinality", "Length"}]}]
```

On the bare distance shell the two points are joined by no arc: a shell of a lattice has no two adjacent vertices.

```wl
InfraMeasurement[GridGraph[{9, 9}], InfraArc[41, {14, 44}], "Cardinality"]
```

Two vertices at distance 2 from the centre of a 5 × 5 grid, on opposite sides. With the band widened one step, two minor arcs join them, one each way round.

```wl
With[
  {g = GridGraph[{5, 5}]},
  {arc = InfraArc[13, {7, 19}, "RadiusDelta" -> 1]},
  {InfraMeasurement[g, arc, "Cardinality"], InfraMeasurement[g, arc, "Length"]}
]
```

```wl
InfraVertexList[GridGraph[{5, 5}], InfraArc[13, {7, 19}, "RadiusDelta" -> 1], All]
```

The two half-rings between antipodes of the radius-2 hexagon on a triangular patch, drawn with the centre.

```wl
With[
  {g = TessellationNeighborhoodGraph[{3, 6}, 5]},
  {c = First @ GraphCenter[g]},
  {ring = Select[VertexList[g], GraphDistance[g, c, #] == 2 &]},
  {p = First @ ring},
  {q = First @ Select[ring, GraphDistance[Subgraph[g, ring], p, #] == 6 &]},
  {arc = InfraArc[c, {p, q}]},
  {InfraMeasurement[g, arc, "Cardinality"], InfraMeasurement[g, arc, "Length"],
   InfraHighlightGraph[g, {InfraVertexList[g, arc, All] -> $InfraCircleColor, {c} -> $InfraPointColor}]}
]
```

## Properties and Relations

[FindInfraArc]() searches the band directly and finds the same arcs.

```wl
With[
  {g = GridGraph[{5, 5}]},
  Sort @ InfraVertexList[g, InfraArc[13, {7, 19}, "RadiusDelta" -> 1], All] ===
    Sort @ FindInfraArc[g, 13, {7, 19}, All, "RadiusDelta" -> 1]
]
```

The circle's and the arc's `"Faithful"` are both [Undetermined]().

```wl
InfraMeasurement[GridGraph[{5, 5}], InfraArc[13, {7, 19}, "RadiusDelta" -> 1], "Faithful"]
```
