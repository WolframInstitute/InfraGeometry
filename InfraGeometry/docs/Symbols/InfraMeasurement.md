---
Template: Symbol
Name: InfraMeasurement
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraMeasurement
Keywords: [segment, ray, line, circle, arc, inert head, measurement, occupation, faithful]
SeeAlso: [InfraVertexList, InfraMemberQ, InfraSubgraph, InfraSegment, InfraRay, InfraLine, InfraCircle, InfraArc, Undetermined]
RelatedGuides: [EuclideanInfrageometry]
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

A segment from the centre to a vertex four steps away, drawn by its densities, beside its number of shortest paths and their length.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 4])},
  {seg = InfraSegment[a, b]},
  {InfraSubstrateHighlight[g, {seg, Directive[$InfraPointColor], a, b}],
   InfraMeasurement[g, seg, "Cardinality"], InfraMeasurement[g, seg, "Length"]}]
```

The graph of the same segment: its source-to-sink chains are the shortest paths.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 4])},
  InfraMeasurement[g, InfraSegment[a, b], "Graph"]]
```

The vertex density drawn alone, and the graph of the segment drawn on the substrate.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 4])},
  {seg = InfraSegment[a, b]},
  GraphicsRow[{
    InfraSubstrateHighlight[g, {InfraMeasurement[g, seg, "VertexDensity"]}],
    InfraSubstrateHighlight[g, {InfraMeasurement[g, seg, "Graph"]}]}]]
```

Every property at once, here named beside the subgraph the segment occupies.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 4])},
  {all = InfraMeasurement[g, InfraSegment[a, b], All]},
  {InfraSubstrateHighlight[g, {all["Subgraph"]}], Keys @ all}]
```

A list of heads is measured head by head.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 4])},
  {heads = {InfraSegment[a, b], InfraCircle[a, "Radius" -> {2, 4}]}},
  {InfraSubstrateHighlight[g, heads], InfraMeasurement[g, heads, "Cardinality"]}]
```

## Properties and Relations

The support is the key set of the vertex density, and its size is the `"Volume"`.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 4])},
  {seg = InfraSegment[a, b]},
  {support = Keys @ InfraMeasurement[g, seg, "VertexDensity"]},
  {InfraSubstrateHighlight[g, {support}], Length @ support === InfraMeasurement[g, seg, "Volume"]}]
```

An intersection of two heads has no members, only a support and a density, the product of the two. The segment and the circles, then their intersection.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 4])},
  {seg = InfraSegment[a, b]},
  {circle = InfraCircle[a, "Radius" -> {2, 4}]},
  {density = InfraMeasurement[g, InfraIntersection[seg, circle], "VertexDensity"]},
  {GraphicsRow[{InfraSubstrateHighlight[g, {seg, circle}], InfraSubstrateHighlight[g, {density}]}], density}]
```
