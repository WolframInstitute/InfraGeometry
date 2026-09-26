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

A Euclidean head is inert: it holds its points and options and computes nothing on its own. `InfraMeasurement` is what evaluates it, reading every property off the head's **graph** — a directed graph whose source-to-sink chains (or, for a closed head, whose directed cycles) are exactly the head's members — by one forward and one backward sweep of a dynamic-programming count, never by enumeration.

The properties:

| Property | Value |
|---|---|
| `"Graph"` | the object's own graph: one `Graph`, or a `List` of them for a family of alternatives (a line's atoms, a circle's necklaces) or for the pieces of a polyline |
| `"Cardinality"` | the number of members |
| `"Length"` | the common length of the members, or a `List` of lengths when they differ |
| `"VertexDensity"` | `<\|v -> occ(v)\|>`, the number of members through *v* |
| `"EdgeDensity"` | `<\|v \[DirectedEdge] w -> occ(v -> w)\|>` |
| `"Subgraph"` | the induced subgraph of the support, same as [InfraSubgraph]() |
| `"Faithful"` | `True` on a segment, ray or line; [Undetermined]() on a circle or an arc, whose graph is proved faithful only under a hypothesis this paclet does not certify |
| `"Volume"`, `"BoundaryVolume"`, `"InteriorVolume"`, `"HalfBoundaryVolume"` | the size of the support and its boundary counts |

The support of every object — what `"Subgraph"` and the four volumes read — is `Keys @ InfraMeasurement[graph, obj, "VertexDensity"]`.

[InfraIntersection]() and [InfraUnion]() are heads on heads: neither is a family of walks, so neither has a `"Graph"`, `"Cardinality"`, `"Length"`, `"EdgeDensity"` or `"Faithful"`, and their `All` lists only the density, the subgraph and the four volumes. The intersection's `"VertexDensity"` is the product of the two objects' densities on their common vertices, the union's the sum.

A circle or a circle band takes `"Radius" -> r | {r, s}` in place of a point, or widens the circle through a point with `"RadiusDelta" -> delta | {deltaIn, deltaOut}` (default `0`).

## Basic Examples

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
