---
Template: Symbol
Name: InfraMeasurement
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraMeasurement
Keywords: [segment, ray, line, circle, arc, ball, shell, tube, inert head, measurement, occupation, faithful, counting measure, Riemannian measure, volume]
SeeAlso: [FindInfraRepresentative, InfraMemberQ, InfraSubgraph, InfraSegment, InfraBall, InfraShell, InfraTube, InfraInterior, InfraBoundary, Undetermined]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraMeasurement]()[*graph*, *obj*, *property*]</code> measures an inert head on *graph*: a Euclidean head — [InfraSegment](), [InfraRay](), [InfraLine](), [InfraCircle](), [InfraArc]() — or a region — [InfraBall](), [InfraShell](), [InfraTube](), [InfraCylinder](), [InfraCone](), [InfraSphere]().

<code>[InfraMeasurement]()[*graph*, *obj*, {*property1*, ...}]</code> gives an `Association` of several properties; `All` in place of the list gives every property the object has.

<code>[InfraMeasurement]()[*graph*, {*obj1*, ...}, *property*]</code> measures each object in the list.

## Details & Options

Definition: <code>[InfraMeasurement]()[*graph*, *obj*, *property*]</code> is the value of *property* of the object *obj* on *graph*. The support of *obj* is the set *A* of vertices its members pass through, `Keys @ InfraMeasurement[graph, obj, "VertexDensity"]`. The two measures of *obj* are measures of *A*:

| Measure | Value |
|---|---|
| `"CountingMeasure"` | *\|A\|*, the number of vertices of the support |
| `"RiemannianMeasure"` | *\|A°\|*, where *A° = {v ∈ A : every neighbour of v lies in A}*: the count without the boundary |

Their difference is the number of vertices of *A* with a neighbour outside *A*, the [InfraBoundary]() of *A*; *A°* is its [InfraInterior](). In the limit of a manifold the boundary of a region has measure zero and the two agree. On a graph they do not: the boundary of a ball of radius *r* holds a share of order *1/r* of its vertices. On the square, triangular and hexagonal lattices, away from the rim, the Riemannian measure of a ball of radius *r* is the counting measure of the ball of radius *r − 1*, the convention of the Wolfram Physics technical introduction. The rim of a finite graph is not a boundary: a region that fills the graph has both measures equal to the number of vertices.

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
| `"CountingMeasure"` | the number of vertices of the support |
| `"RiemannianMeasure"` | the number of vertices of the support all of whose neighbours lie in the support |

A region — a ball, shell, tube, cylinder or cone — has one member, its vertex set, and every vertex of the support has density 1. It has no `"Graph"` and no `"Length"`. A sphere is a family, searched rather than read off a graph; its `"Faithful"` is [Undetermined]().

[InfraIntersection]() and [InfraUnion]() are heads on heads: neither is a family of walks, so neither has a `"Graph"`, `"Cardinality"`, `"Length"`, `"EdgeDensity"` or `"Faithful"`, and their `All` lists only the density, the subgraph and the two measures. The intersection's `"VertexDensity"` is the product of the two objects' densities on their common vertices, the union's the sum.

A circle takes a radius `r` or a band `{r, s}`, a scalar `r` meaning `{r, r}`. The circle through a point is the closed arc <code>[InfraArc]()[*c*, {*p*, *p*}]</code>, which widens the band of *p* with `"RadiusDelta" -> delta | {deltaIn, deltaOut}` (default `0`). A scalar *delta* means `{0, delta}`, outward only.

On a polyline <code>[InfraSegment]()[*p1*, …, *pk*]</code> the densities are not member counts: they are the sums of the piece densities. On the 5 × 5 grid, <code>[InfraSegment]()[1, 13, 25]</code> has 36 members, while its density at the centre 13 is 12.

## Basic Examples

A segment from the centre to a vertex four steps away on the discretized plane, the square grid and the hexagonal tiling, drawn by its densities, beside its number of shortest paths, their length and its two measures.

```wl
Row[Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {a = InfraCenter[g]},
    {b = (SeedRandom[1]; RandomInfraPoint[g, a, 4])},
    {seg = InfraSegment[a, b]},
    Labeled[
      InfraSubstrateHighlight[g, {seg, Directive[$InfraPointColor], a, b}],
      InfraMeasurement[g, seg, {"Cardinality", "Length", "CountingMeasure", "RiemannianMeasure"}]]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]]
```

The two measures of five regions about one centre and one shortest path on the square grid: a ball, a band of two radii, a tube, a cylinder and a cone. Each is drawn with its inner vertices in green and its boundary in blue; the counting measure counts both, the Riemannian measure the green ones.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {seg = InfraSegment[c, (SeedRandom[1]; RandomInfraPoint[g, c, 4])]},
  {axis = FindInfraRepresentative[g, seg]},
  {regions = {InfraBall[c, 3], InfraShell[c, {2, 3}], InfraTube[seg, 1], InfraCylinder[axis, 1], InfraCone[axis, 1]}},
  {supports = FindInfraRepresentative[g, #] & /@ regions},
  {Row[InfraSubstrateHighlight[g, {InfraInterior[g, #] -> $InfraBallColor, InfraBoundary[g, #] -> $InfraCircleColor}] & /@ supports],
   InfraMeasurement[g, regions, "CountingMeasure"], InfraMeasurement[g, regions, "RiemannianMeasure"]}]
```

The graph of the segment: its source-to-sink chains are the shortest paths.

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

## Scope

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
  {heads = {InfraSegment[a, b], InfraCircle[a, {2, 4}]}},
  {InfraSubstrateHighlight[g, heads], InfraMeasurement[g, heads, "Cardinality"]}]
```

## Properties and Relations

The support is the key set of the vertex density. The counting measure is its size, the Riemannian measure the size of its interior.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {ball = InfraBall[InfraCenter[g], 4]},
  {support = Keys @ InfraMeasurement[g, ball, "VertexDensity"]},
  {{Length @ support, Length @ InfraInterior[g, support]}, InfraMeasurement[g, ball, {"CountingMeasure", "RiemannianMeasure"}]}]
```

On the square grid and the hexagonal tiling the Riemannian measure of the ball of radius *r* is the counting measure of the ball of radius *r − 1*, and their difference is 0. On the discretized plane it is not: a vertex at distance *r* with no neighbour at distance *r + 1* is inside the ball.

```wl
With[
  {names = {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}},
  ListLinePlot[
    Table[
      With[
        {g = InfraSubstrate[name, "Medium"]},
        {c = InfraCenter[g]},
        Table[InfraMeasurement[g, InfraBall[c, r], "RiemannianMeasure"] - InfraMeasurement[g, InfraBall[c, r - 1], "CountingMeasure"], {r, 1, 7}]],
      {name, names}],
    DataRange -> {1, 7}, PlotRange -> All, PlotMarkers -> Automatic, PlotLegends -> names, AxesLabel -> {"r", None}]]
```

A segment between opposite corners of a grid fills it, and the rim of the grid is not a boundary: both measures are 25.

```wl
InfraMeasurement[GridGraph[{5, 5}], InfraSegment[1, 25], {"Cardinality", "CountingMeasure", "RiemannianMeasure"}]
```

An intersection of two heads has no members, only a support and a density, the product of the two. The segment and the circles, then their intersection.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 4])},
  {seg = InfraSegment[a, b]},
  {circle = InfraCircle[a, {2, 4}]},
  {density = InfraMeasurement[g, InfraIntersection[seg, circle], "VertexDensity"]},
  {GraphicsRow[{InfraSubstrateHighlight[g, {seg, circle}], InfraSubstrateHighlight[g, {density}]}], density}]
```
