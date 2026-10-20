---
Template: Symbol
Name: InfraBall
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraBall
Keywords: [ball, disk, neighbourhood, region, symbolic object, volume, counting measure, Riemannian measure]
SeeAlso: [InfraShell, InfraTube, InfraSphere, InfraMeasurement, InfraInterior, InfraBoundary, InfraBallQ]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraBall]()[*c*, *r*]</code> is the closed ball of radius *r* about the vertex *c*: the vertices at distance at most *r* from *c*.

<code>[InfraBall]()[*c*, {*r*, *s*}]</code> is the band of the vertices at distance between *r* and *s* from *c*.

## Details & Options

The ball is *Bᵣ(c) = {v : d(c, v) ≤ r}*, with *d* the graph distance.

The centre can be a vertex list *C*. Then *d(v, C) = min d(v, c)* over *c* in *C*, and the ball is the *r*-neighbourhood of *C*.

[InfraBall]() is a symbolic object: [InfraMeasurement]() evaluates it on a graph and [InfraSubstrateHighlight]() draws it.

A ball is not round. On the square grid it is a square standing on a corner, the unit ball of the ℓ¹ norm scaled by *r*.

The boundary of a ball is not small: on the square grid the vertices at distance exactly *r* are a share of about *2/r* of the ball. So a ball has two volumes:

| Measure | Value |
|---|---|
| `"CountingMeasure"` | the number of vertices of the ball |
| `"RiemannianMeasure"` | the number of vertices of its [InfraInterior](), those all of whose neighbours lie in the ball |

On the square grid, away from the rim, the counting measure is *2r² + 2r + 1* and the Riemannian measure is *2r² − 2r + 1* for *r ≥ 1*, the same polynomial at *r − 1*. On *Zᵈ* the counting measure is *Σₖ 2ᵏ C(d, k) C(r, k)*, the sum over *k = 0, …, d*.

A radius past the eccentricity of *c* gives the whole graph. The rim of the graph is not a boundary of the ball, so both measures are then the number of vertices.

In an [InfraScene](), <code>[InfraBall]()[*p*, *r*]</code> is the ball about the point *p*.

Corresponding notion in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Postulate 3 | To describe a circle with any centre and distance; the ball is the region the circle bounds. |

## Basic Examples

The ball of radius 3 about the centre, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    InfraSubstrateHighlight[g, {InfraBall[c, 3], c}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The interior of the ball drawn over it. The Riemannian measure counts the interior, the counting measure the whole ball:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {ball = InfraBall[First @ GraphCenter[g], 3]},
    InfraSubstrateHighlight[g, {ball, InfraInterior[g, ball]},
      PlotLabel -> InfraMeasurement[g, ball, {"CountingMeasure", "RiemannianMeasure"}]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The two measures against the radius on the square grid, *2r² + 2r + 1* and *2r² − 2r + 1*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  ListLinePlot[Table[InfraMeasurement[g, InfraBall[c, r], m], {m, {"CountingMeasure", "RiemannianMeasure"}}, {r, 0, 7}],
    DataRange -> {0, 7}, PlotMarkers -> Automatic, PlotLegends -> {"CountingMeasure", "RiemannianMeasure"}]]
```

## Scope

A ball about a vertex list is its neighbourhood. The ball of radius 1 about a shortest path:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {path = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 5], RandomSeeding -> 1], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraBall[path, 1], InfraWalk[path]}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

A radius band gives the vertices at distance 2 to 4:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    InfraSubstrateHighlight[g, {InfraBall[c, {2, 4}], c}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Properties and Relations

The ball is the union of the shells about its centre, so its counting measure is the running total of the shell sizes:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {volumes = Table[InfraMeasurement[g, InfraBall[c, r], "CountingMeasure"], {r, 0, 4}]},
  {areas = Table[InfraMeasurement[g, InfraShell[c, r], "CountingMeasure"], {r, 0, 4}]},
  InfraSubstrateHighlight[g, Table[InfraShell[c, r], {r, 0, 4}], PlotLabel -> {volumes, Accumulate[areas]}, ImageSize -> Medium]]
```

The interior of the ball of radius 6 contains the ball of radius 5. On the mesh it contains more: two vertices at distance 6, drawn as points, have no neighbour at distance 7. So the Riemannian measure of the larger ball exceeds the counting measure of the smaller one by 2:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {extra = Complement[InfraInterior[g, InfraBall[c, 6]], Keys @ InfraMeasurement[g, InfraBall[c, 5], "VertexDensity"]]},
  InfraSubstrateHighlight[g, {InfraBall[c, 5], InfraShell[c, 6], extra},
    PlotLabel -> {InfraMeasurement[g, InfraBall[c, 6], "RiemannianMeasure"], InfraMeasurement[g, InfraBall[c, 5], "CountingMeasure"]},
    ImageSize -> Medium]]
```

## Possible Issues

Past the eccentricity the ball is the whole graph. Both measures are the number of vertices: the rim of the graph is not a boundary of the ball.

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {InfraMeasurement[g, InfraBall[c, 20], {"CountingMeasure", "RiemannianMeasure"}], VertexCount[g]}]
```
