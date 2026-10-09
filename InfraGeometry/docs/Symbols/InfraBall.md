---
Template: Symbol
Name: InfraBall
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraBall
Keywords: [ball, disk, neighbourhood, region, symbolic object, volume, counting measure, Riemannian measure]
SeeAlso: [InfraShell, InfraTube, InfraSphere, RandomInfraRepresentative, InfraMeasurement, InfraInterior, InfraBoundary, InfraBallQ]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraBall]()[*c*, *r*]</code> is the closed ball of radius *r* about *c*: the vertices at distance at most *r*. It is a symbolic object; [InfraMeasurement]() and [RandomInfraRepresentative]() evaluate it on a graph.

<code>[InfraBall]()[*c*, {*r*, *s*}]</code> is the shell: the vertices at distance between *r* and *s*.

<code>[InfraBall]()[*c*, *r*]</code> inside an [InfraScene]() is the ball construction token.

## Details & Options

Definition: the closed ball of radius *r* about *c* is *B_r(c) = {v : d(c, v) ≤ r}*. *c* is a vertex or a vertex list, and then *d(v, C) = min d(v, c)* and the ball is the *r*-neighbourhood of *C*.

The ball is not round. On a lattice it is the unit ball of the path metric scaled by *r*: a square standing on a corner on the square grid, a hexagon on the hexagonal tiling.

Its boundary is not negligible. The vertices at distance exactly *r* are a share of order *1/r* of the ball, so the volume of a ball depends on whether they count. [InfraMeasurement]() gives both:

| Measure | Value |
|---|---|
| `"CountingMeasure"` | *\|B_r(c)\|*, the number of vertices of the ball |
| `"RiemannianMeasure"` | the number of vertices of the ball all of whose neighbours lie in the ball: the count without the boundary |

The Riemannian measure of *B_r(c)* for *r ≥ 1* counts *B_(r−1)(c)* and the vertices at distance *r* that have no neighbour at distance *r + 1*. At *r = 0* it is `0`: the centre has a neighbour outside. On the square and the triangular grids, away from the rim, no vertex at distance *r* lacks a neighbour farther out, so the Riemannian profile over *r* is the counting profile one radius later; on the hexagonal tiling this is measured, not proved. On an irregular mesh the extra vertices appear.

On a lattice both measures are polynomials in *r*. The counting measure is the number of lattice points in the ball of the path metric, a polygon or a polyhedron; the Riemannian measure is the same polynomial at *r − 1*:

| Lattice | Substrate | `"CountingMeasure"` *L(r)* | `"RiemannianMeasure"`, *r ≥ 1* |
|---|---|---|---|
| *Z²* | `"SquareTilingGraph"` | *2r² + 2r + 1* | *2r² − 2r + 1* |
| *Z³* | `"CubicGridGraph"` | *4/3 r³ + 2r² + 8/3 r + 1* | *L(r − 1)* |
| triangular | `"TriangularTilingGraph"` | *3r² + 3r + 1* | *3r² − 3r + 1* |
| hexagonal | `"HexagonalTilingGraph"` | *1 + 3r(r + 1)/2* | *1 + 3r(r − 1)/2*, measured |

On *Z^d* the count is *L_d(r) = Σ_k 2^k C(d, k) C(r, k)*, the sum over *k* from 0 to *d*, with *C* the binomial coefficient: a point of the ball has *k* nonzero coordinates, which take *C(d, k)* positions, *2^k* signs and *C(r, k)* absolute values of sum at most *r*. The substrates are finite patches of the lattices. A count follows the polynomial while the ball stays inside the patch, and the Riemannian count while one more layer does: on the medium cubic grid, to *r = 3* and *r = 2*.

In the continuum the reference is the small-ball expansion of Gray and Vanhecke. On a Riemannian manifold of dimension *n*, with *ω_n* the volume of the Euclidean unit ball and *Scal(c)* the scalar curvature at the centre, *Vol B_r(c) = ω_n r^n (1 − Scal(c) r² / (6(n + 2)) + O(r⁴))*. A lattice ball is not a discrete round ball: the scaled path metric of a lattice converges to a norm whose unit ball is a square on the square grid and a hexagon on the triangular one, and the leading coefficient of *L* is the area of that unit ball. The expansion is the reference on a mesh of a curved surface.

How the number is measured: <code>[InfraMeasurement]()[*g*, [InfraBall]()[*c*, *r*], *measure*]</code> takes the vertices at distance at most *r* from *c*, one row of the distance matrix cut at *r*, and counts them, or counts its [InfraInterior](). The profile is the list over *r = 0, 1, …*, and [LogDifferenceQuotients]() reads the dimension off it. On a lattice the quotients of the counting profile from *r = 0* and of the Riemannian profile from *r = 1* coincide: they are the curve of the Wolfram Physics technical introduction, section 4.5, which approaches the dimension from above.

A radius past the eccentricity gives the whole graph, and then both measures are the number of vertices: the rim of the graph is not a boundary of the ball. A band with *r > s* gives the empty set.

The head holds the centre and the radius and computes nothing. A ball has one member, the vertex set, so [RandomInfraRepresentative]() gives it as a sorted vertex list and `"Faithful"` is `True`. [InfraMeasurement]() also reads `"VertexDensity"`, `"EdgeDensity"`, `"Cardinality"` and `"Subgraph"`; a ball has no `"Graph"` and no `"Length"`.

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Postulate 3 | To draw a circle with any center and radius; the ball is the region the circle bounds. |
| Tarski | Betweenness and equidistance | The points *x* with *cx ≡ cy* for some *y* between *c* and a point at distance *r*. |

## Basic Examples

The ball of radius 3 about the centre of the discretized plane, the square grid and the hexagonal tiling. The Riemannian measure counts the inner vertices, in green; the counting measure adds the boundary, in blue.

```wl
Row[Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {ball = InfraBall[First @ GraphCenter[g], 3]},
    {support = RandomInfraRepresentative[g, ball]},
    Labeled[
      InfraSubstrateHighlight[g, {InfraInterior[g, support] -> StandardGreen, InfraBoundary[g, support] -> StandardBlue}],
      InfraMeasurement[g, ball, {"CountingMeasure", "RiemannianMeasure"}]]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]]
```

The two measures against the radius on the square grid. The counting measure is *2 r^2 + 2 r + 1*, the Riemannian measure *2 r^2 − 2 r + 1*: the same curve one radius later.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium"]},
  {c = First @ GraphCenter[g]},
  ListLinePlot[
    Table[InfraMeasurement[g, InfraBall[c, r], measure], {measure, {"CountingMeasure", "RiemannianMeasure"}}, {r, 0, 8}],
    DataRange -> {0, 8}, PlotMarkers -> Automatic, PlotLegends -> {"CountingMeasure", "RiemannianMeasure"}, AxesLabel -> {"r", None}]]
```

## Scope

A ball about a vertex list is the neighbourhood of the list: here of a shortest path.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[c, 4]])},
  {core = RandomInfraRepresentative[g, InfraSegment[c, p]]},
  InfraSubstrateHighlight[g, {InfraBall[core, 1], core}]]
```

Past the eccentricity the ball is the whole graph, and the Riemannian measure counts every vertex: the rim of the graph is not a boundary of the ball.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small"]},
  {InfraMeasurement[g, InfraBall[First @ GraphCenter[g], 20], {"CountingMeasure", "RiemannianMeasure"}], VertexCount[g]}]
```

## Properties and Relations

The two measures of the balls about the centres of the square, the triangular and the hexagonal tiling, left to right, as points, against the lattice counts *L(r)* and *L(r − 1)*, as curves. At *r = 0* the Riemannian measure is 0.

```wl
GraphicsRow[MapThread[
  {substrate, ballCount} |-> Show[
    Plot[Evaluate[{ballCount, ConditionalExpression[ballCount /. r -> r - 1, r >= 1]}], {r, 0, 6}],
    ListPlot[
      Table[InfraMeasurement[substrate, InfraBall[First @ GraphCenter[substrate], r], measure], {measure, {"CountingMeasure", "RiemannianMeasure"}}, {r, 0, 6}],
      DataRange -> {0, 6}, PlotMarkers -> Automatic]],
  {InfraSubstrate[#, "Medium"] & /@ {"SquareTilingGraph", "TriangularTilingGraph", "HexagonalTilingGraph"},
   {2 r^2 + 2 r + 1, 3 r^2 + 3 r + 1, 1 + 3 r (r + 1)/2}}]]
```

The ball is the union of the shells up to its radius, so its counting measure is the running total of the shell areas.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Medium"]},
  {c = First @ GraphCenter[g]},
  {volumes = Table[InfraMeasurement[g, InfraBall[c, r], "CountingMeasure"], {r, 0, 5}]},
  {areas = Table[InfraMeasurement[g, InfraShell[c, r], "CountingMeasure"], {r, 0, 5}]},
  {volumes, Accumulate[areas]}]
```

The Riemannian measure of a ball is at least the counting measure of the ball one radius smaller. On the discretized plane it is more: the ball of radius 5 is drawn with the shell of radius 6 around it, and two vertices of the shell, drawn as points, have no neighbour at distance 7, so they lie inside the ball of radius 6.

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Medium", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {inner = InfraInterior[g, RandomInfraRepresentative[g, InfraBall[c, 6]]]},
  {smaller = RandomInfraRepresentative[g, InfraBall[c, 5]]},
  {InfraSubstrateHighlight[g, {smaller, InfraShell[c, 6], Complement[inner, smaller]}],
   InfraMeasurement[g, InfraBall[c, 6], "RiemannianMeasure"], InfraMeasurement[g, InfraBall[c, 5], "CountingMeasure"]}]
```

Inside a scene the token names the ball about a point, and [FindInfraScene]() binds it to the same vertex set.

```wl
ClearAll[pA, ballA];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {constr = InfraScene[{pA, ballA}, {pA == InfraPoint[c], ballA == InfraBall[pA, 2]}]},
  {ball = InfraSceneInstance[First @ FindInfraScene[constr, g], ballA]},
  {InfraSubstrateHighlight[g, {ball, c}],
   ball === RandomInfraRepresentative[g, InfraBall[c, 2]]}]
```
