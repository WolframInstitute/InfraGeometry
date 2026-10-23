---
Template: Symbol
Name: InfraMeasurement
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraMeasurement
Keywords: [measurement, density, occupation, cardinality, length, faithful, counting measure, Riemannian measure, volume]
SeeAlso: [InfraMemberQ, InfraSegment, InfraBall, InfraShell, InfraTube, InfraInterior, InfraBoundary, InfraSubstrateHighlight]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraMeasurement]()[*g*, *obj*, *prop*]</code> gives the property *prop* of the object *obj* on the graph *g*.

<code>[InfraMeasurement]()[*g*, *obj*, {*prop1*, *prop2*, …}]</code> gives an [Association]() of several properties; `All` in place of the list gives every property *obj* has.

<code>[InfraMeasurement]()[*g*, {*obj1*, *obj2*, …}, *prop*]</code> gives the property of each object.

<code>[InfraMeasurement]()[*g*, {*v1*, *v2*, …}, *prop*]</code> gives the property of the vertex set {*v1*, *v2*, …}.

## Details & Options

An object is a family or a region. A family — [InfraSegment](), [InfraHalfLine](), [InfraInfiniteLine](), [InfraCircle](), [InfraArc]() — has many members, walks on *g*. A region — [InfraBall](), [InfraShell](), [InfraTube](), [InfraCylinder](), [InfraCone]() — has one member, its vertex set.

The support *A* is the set of vertices the members pass through; *occ(v)* is the number of members through *v*.

| Property | Value |
|---|---|
| `"Graph"` | a directed acyclic graph whose source-to-sink paths are the members, or a list of them |
| `"Cardinality"` | the number of members |
| `"Length"` | the length of the members, or the list of lengths when they differ |
| `"VertexDensity"` | `<\|v -> occ(v), …\|>` over the support |
| `"EdgeDensity"` | the number of members through each directed edge |
| `"Subgraph"` | the subgraph of *g* induced on the support |
| `"Faithful"` | `True` when the paths of `"Graph"` are exactly the members |
| `"Midpoint"` | on a segment, the number of members through each central vertex |
| `"CountingMeasure"` | *\|A\|* |
| `"RiemannianMeasure"` | *\|A°\|*, with *A° = {v ∈ A : every neighbour of v lies in A}* |

A region has no `"Graph"` and no `"Length"`; its density is 1 on the support. The density of an [InfraIntersection]() is the product of the densities of its parts, that of an [InfraUnion]() the sum.

*A°* is the [InfraInterior]() of *A*. On a manifold the boundary of a region has measure zero; on a graph it does not, and for a ball of radius *r* the two measures differ by a share of order *1/r*. The rim of a finite graph is not a boundary.

For the *s*-neighbourhood *Tₛ(X)* of a vertex set *X* and *s ≥ 1*, *Tₛ(X)° = Tₛ₋₁(X) ∪ {w : d(w, X) = s, no neighbour of w at distance s + 1}*: the Riemannian measure of a ball or tube is the counting measure one step thinner, plus the dead ends of the outer layer.

On the square grid, away from the rim, with a segment whose interval is an (*a* + 1) × (*b* + 1) rectangle:

| Region | `"CountingMeasure"` | `"RiemannianMeasure"` |
|---|---|---|
| ball of radius *r* | *2r² + 2r + 1* | *2r² − 2r + 1* for *r ≥ 1* |
| shell of radius *r ≥ 1* | *4r* | 0 |
| tube of radius *s* about the segment | *(a + 1)(b + 1) + 2s(a + b + 2) + 2s(s − 1)* | the count at *s − 1*, for *s ≥ 1* |

A vertex, an association of masses and a walk graph also have a `"VertexDensity"`, and so do the tokens [InfraWalk](), its number of visits to each vertex, and [InfraPoint](), 1 on the vertices it can be. A list of vertex lists or walk graphs has the sum of their densities.

A list of vertices is one vertex set for every property: its density counts repeated vertices, and its `"CountingMeasure"`, `"RiemannianMeasure"` and `"Subgraph"` are those of the set, as for a density. Any other list is measured object by object.

The members of <code>[InfraGeodesic]()[*germ*, *s*]</code> at a finite scale *s* are listed to read its `"Cardinality"`, `"Length"` and densities; its `"Graph"` is a window graph, not a graph of the members. At scale [Infinity]() the family is <code>[InfraInfiniteLine]()[*germ*]</code> and is read as such.

## Basic Examples

A segment from the centre to a vertex at distance 4: its cardinality, length and two measures:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
    {seg = InfraSegment[a, RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]]},
    {props = {"Cardinality", "Length", "CountingMeasure", "RiemannianMeasure"}},
    InfraSubstrateHighlight[g, {seg}, PlotLabel -> Values @ InfraMeasurement[g, seg, props]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

A ball, a band and a tube, each with its interior drawn over it. The counting measure counts the region, the Riemannian measure its interior:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {seg = InfraSegment[c, RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 1]]},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {region, InfraInterior[g, region]},
      PlotLabel -> Values @ InfraMeasurement[g, region, {"CountingMeasure", "RiemannianMeasure"}]],
    {region, {InfraBall[c, 3], InfraShell[c, {2, 3}], InfraTube[seg, 1]}}]]
```

The vertex density and the edge density of a segment:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {seg = InfraSegment[a, RandomInfraPoint[g, InfraShell[a, 5], RandomSeeding -> 1]]},
  GraphicsRow[{InfraSubstrateHighlight[g, {InfraMeasurement[g, seg, "VertexDensity"]}],
    InfraSubstrateHighlight[g, {InfraMeasurement[g, seg, "EdgeDensity"]}]}]]
```

## Scope

`All` gives every property the object has. A segment has a graph and a length, a ball does not:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Keys @ InfraMeasurement[g, #, All] & /@ {InfraSegment[c, 49], InfraBall[c, 3]}]
```

A list of objects is measured object by object. The volume profile of the ball on the square grid, *2r² + 2r + 1*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium"]}, {c = First @ GraphCenter[g]},
  InfraMeasurement[g, Table[InfraBall[c, r], {r, 0, 6}], "CountingMeasure"]]
```

A segment cut by a ball. The density of the intersection is the product of the densities:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {seg = InfraSegment[a, RandomInfraPoint[g, InfraShell[a, 5], RandomSeeding -> 1]]},
  {cut = InfraMeasurement[g, InfraIntersection[seg, InfraBall[a, 2]], "VertexDensity"]},
  GraphicsRow[{InfraSubstrateHighlight[g, {InfraBall[a, 2], seg}], InfraSubstrateHighlight[g, {cut}]}]]
```

Five shortest paths and the sum of their densities:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 6], RandomSeeding -> 1]},
  {walks = RandomInfraSegment[g, a, b, 5, RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {InfraMeasurement[g, walks, "VertexDensity"]}, ImageSize -> Medium]]
```

## Properties and Relations

The tube about a segment on the square grid, against *(a + 1)(b + 1) + 2s(a + b + 2) + 2s(s − 1)* with *a* = 3, *b* = 2:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {xy = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {b = First @ Keys @ Select[xy, # - xy[c] == {3, 2} &]},
  InfraMeasurement[g, Table[InfraTube[InfraSegment[c, b], s], {s, 0, 5}], "CountingMeasure"] ==
    Table[12 + 14 s + 2 s (s - 1), {s, 0, 5}]]
```

The Riemannian measure of the ball of radius *r* minus the counting measure of the ball of radius *r − 1*. It is 0 on the grid; on the mesh the dead ends of the outer layer add to the interior:

```wl
ListLinePlot[
  Table[With[{g = InfraSubstrate[name, "Medium"]}, {c = First @ GraphCenter[g]},
    Table[InfraMeasurement[g, InfraBall[c, r], "RiemannianMeasure"] - InfraMeasurement[g, InfraBall[c, r - 1], "CountingMeasure"],
      {r, 7}]],
    {name, {"SquareGridGraph", "SquareMeshGraph"}}],
  PlotMarkers -> Automatic, PlotLegends -> {"SquareGridGraph", "SquareMeshGraph"}]
```

The two measures are the sizes of the support and of its interior:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {ball = InfraBall[First @ GraphCenter[g], 3]},
  {support = Keys @ InfraMeasurement[g, ball, "VertexDensity"]},
  {Length @ support, Length @ InfraInterior[g, support]} ==
    Values @ InfraMeasurement[g, ball, {"CountingMeasure", "RiemannianMeasure"}]]
```

A vertex list is one set. The ball of radius 2 given as its vertex list has the measures of the ball:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {support = Keys @ InfraMeasurement[g, InfraBall[c, 2], "VertexDensity"]},
  InfraMeasurement[g, support, {"CountingMeasure", "RiemannianMeasure"}] ===
    InfraMeasurement[g, InfraBall[c, 2], {"CountingMeasure", "RiemannianMeasure"}]]
```

## Possible Issues

A shell of the square grid has no two adjacent vertices, so it carries no circle. The band of radii 3 and 4 carries one:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    InfraSubstrateHighlight[g, {InfraShell[c, band], InfraCircle[c, band]},
      PlotLabel -> InfraMeasurement[g, InfraCircle[c, band], "Cardinality"]]],
  {band, {3, {3, 4}}}]
```
