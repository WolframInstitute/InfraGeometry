---
Template: Symbol
Name: InfraMeasurement
Context: WolframInstitute`SyntheticInfrageometry`
ContextPath: [WolframInstitute`Infrageometry`]
Paclet: WolframInstitute/SyntheticInfrageometry
URI: WolframInstitute/SyntheticInfrageometry/ref/InfraMeasurement
Keywords: [segment, ray, line, circle, arc, inert head, measurement, occupation, faithful]
SeeAlso: [InfraVertexList, InfraMemberQ, InfraSubgraph, InfraSegment, InfraRay, InfraLine, InfraCircle, InfraArc, Undetermined]
RelatedGuides: [EuclideanGeometryGuide]
---

## Usage

<code>[InfraMeasurement]()[*graph*, *obj*, *property*]</code> measures a Euclidean head — [InfraSegment](), [InfraRay](), [InfraLine](), [InfraCircle](), [InfraArc]() — on *graph*.

<code>[InfraMeasurement]()[*graph*, *obj*, {*property1*, ...}]</code> gives an `Association` of several properties; `All` in place of the list gives every property the object has.

<code>[InfraMeasurement]()[*graph*, {*obj1*, ...}, *property*]</code> measures each object in the list.

## Details & Options

A Euclidean head is inert: it holds its points and options and computes nothing on its own. `InfraMeasurement` is what evaluates it, reading every property off the head's **graph** — an acyclic directed graph whose source-to-sink chains are exactly the head's members — by one forward and one backward sweep of a dynamic-programming count, never by enumeration. A circle's graph is a `List` of necklaces, each **opened** at its closing arrow *u* -> *s1*: an acyclic DAG with one source *s1* and one sink *u*. A circle's member is the open chain *s1* … *u* read cyclically, a cyclic vertex list whose first vertex is not repeated.

The properties:

| Property | Value |
|---|---|
| `"Graph"` | the object's own graph: one `Graph`, or a `List` of them for a family of alternatives (the DAGs of a line or a ray, the necklaces of a circle) or for the pieces of a polyline |
| `"Cardinality"` | the number of members |
| `"Length"` | the common length of the members, or a `List` of lengths when they differ |
| `"VertexDensity"` | `<\|v -> occ(v)\|>`, the number of members through *v*; on a polyline, the sum of the piece densities |
| `"EdgeDensity"` | `<\|v \[DirectedEdge] w -> occ(v -> w)\|>`, the number of members through the arrow; on a polyline, the sum of the piece densities |
| `"Subgraph"` | the induced subgraph of the support, same as [InfraSubgraph]() |
| `"Faithful"` | `True` on a segment, ray or line; [Undetermined]() on a circle or an arc, whose graph is proved faithful only under a hypothesis this paclet does not certify |
| `"Volume"`, `"BoundaryVolume"`, `"InteriorVolume"`, `"HalfBoundaryVolume"` | the size of the support and its boundary counts |

The support of every object — what `"Subgraph"` and the four volumes read — is `Keys @ InfraMeasurement[graph, obj, "VertexDensity"]`.

[InfraIntersection]() and [InfraUnion]() are heads on heads: neither is a family of walks, so neither has a `"Graph"`, `"Cardinality"`, `"Length"`, `"EdgeDensity"` or `"Faithful"`, and their `All` lists only the density, the subgraph and the four volumes. The intersection's `"VertexDensity"` is the product of the two objects' densities on their common vertices, the union's the sum.

A circle or a circle band takes `"Radius" -> r | {r, s}` in place of a point, or widens the circle through a point with `"RadiusDelta" -> delta | {deltaIn, deltaOut}` (default `0`). A scalar *delta* means `{0, delta}`, outward only.

On a polyline <code>[InfraSegment]()[*p1*, …, *pk*]</code> the densities are not member counts: they are the sums of the piece densities. On the 5 × 5 grid, <code>[InfraSegment]()[1, 13, 25]</code> has 36 members, while its density at the centre 13 is 12.

## Basic Examples

The segment between the centre of a grid and a vertex two steps up and two across, drawn by its densities: six geodesics of length 4, and four of them pass the vertex in the middle.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {seg = InfraSegment[41, 61]},
  {InfraHighlightGraph[g, {seg, Directive[$InfraPointColor], 41, 61}, ImageSize -> 250],
   InfraMeasurement[g, seg, {"Cardinality", "Length"}], InfraMeasurement[g, seg, "VertexDensity"][51]}]
```

The graph of the same segment: its source-to-sink chains are the six geodesics.

```wl
InfraMeasurement[GridGraph[{9, 9}], InfraSegment[41, 61], "Graph"]
```

The segment between two vertices of a grid: its cardinality, length, and every property at once.

```wl
With[
  {g = GridGraph[{5, 5}]},
  {seg = InfraSegment[7, 19]},
  InfraMeasurement[g, seg, {"Cardinality", "Length"}]
]
```

```wl
With[
  {g = GridGraph[{5, 5}]},
  {seg = InfraSegment[7, 19]},
  InfraMeasurement[g, seg, All]
]
```

A list of heads is measured head by head.

```wl
InfraMeasurement[GridGraph[{9, 9}], {InfraSegment[41, 61], InfraCircle[41, "Radius" -> {2, 4}]}, "Cardinality"]
```

## Properties and Relations

The support is the key set of the vertex density, and its size is the `"Volume"`.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {seg = InfraSegment[41, 61]},
  Length @ InfraMeasurement[g, seg, "VertexDensity"] === InfraMeasurement[g, seg, "Volume"]]
```

An intersection of two heads has no members, only a support and a density, the product of the two.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {x = InfraIntersection[InfraSegment[41, 61], InfraCircle[41, "Radius" -> {2, 4}]]},
  {Keys @ InfraMeasurement[g, x, All], InfraMeasurement[g, x, "VertexDensity"]}]
```
