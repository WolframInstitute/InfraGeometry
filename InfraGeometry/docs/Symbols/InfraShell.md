---
Template: Symbol
Name: InfraShell
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraShell
Keywords: [shell, sphere, level set, region, symbolic object, area, counting measure, Riemannian measure]
SeeAlso: [FindInfraShell, InfraBall, InfraSphere, InfraMeasurement, FindInfraRepresentative, InfraInterior, InfraBoundary, InfraShellQ]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

<code>[InfraShell]()[*c*, {*r*, *s*}]</code> is the shell about *c*: the vertices at distance between *r* and *s*. It is a symbolic object; [InfraMeasurement]() and [FindInfraRepresentative]() evaluate it on a graph.

<code>[InfraShell]()[*c*, *r*]</code> is the band {*r*, *r*}: the vertices at distance exactly *r*.

<code>[InfraShell]()[*c*, *r*]</code> inside an [InfraScene]() is the shell construction token.

## Details & Options

Definition: the shell of radius *r* about *c* is *S_r(c) = {v : d(c, v) = r}*, a level set of the distance from *c*; the band is *{v : r ≤ d(c, v) ≤ s}*. *c* is a vertex or a vertex list, and then *d(v, C) = min d(v, c)*.

The shell is not a curve. On the square grid no two of its vertices are adjacent. The connected subsets of it that separate the centre from the outside are the family [InfraSphere](), which may be empty.

A shell is all boundary. [InfraMeasurement]() gives two measures, and they part completely on it:

| Measure | Value |
|---|---|
| `"CountingMeasure"` | *\|S_r(c)\|*, the shell area *A(r)* |
| `"RiemannianMeasure"` | `0` for a single shell: every vertex of it has a neighbour at distance *r − 1*, and the neighbours of the centre lie at distance 1 |

The shell area at *r = 1* is the degree of the centre. Over *r* on a lattice it is the coordination sequence of crystallography, the difference of consecutive ball counts, *A(r) = L(r) − L(r − 1)* for *r ≥ 1*, with *L* the lattice count of [InfraBall](), and *A(0) = 1*:

| Lattice | Substrate | `"CountingMeasure"` *A(r)*, *r ≥ 1* |
|---|---|---|
| *Z*, the path | — | *2* |
| *Z²* | `"SquareTilingGraph"` | *4r* |
| *Z³* | `"CubicGridGraph"` | *4r² + 2* |
| triangular | `"TriangularTilingGraph"` | *6r* |
| hexagonal | `"HexagonalTilingGraph"` | *3r* |

Past the eccentricity the shell is empty. The substrates are finite patches, and a shell follows the table while it stays inside the patch: on the medium cubic grid, to *r = 3*.

In the continuum the reference is the area of the geodesic sphere. On a Riemannian manifold of dimension *n*, with *ω_n* the volume of the Euclidean unit ball and *Scal(c)* the scalar curvature at the centre, *Vol ∂B_r(c) = n ω_n r^(n−1) (1 − Scal(c) r² / (6n) + O(r⁴))*, the derivative in *r* of the ball's expansion. On a lattice the shell is the boundary of a polygon, not of a round ball, as on [InfraBall]().

The Riemannian measure of a band *{r, s}* with *r ≥ 1* drops its two rims: it counts the band *{r + 1, s − 1}* and the vertices at distance *s* that have no neighbour at distance *s + 1*. On the square and the triangular grids, away from the rim, there are none, and it is the counting measure of the band *{r + 1, s − 1}*; on the hexagonal tiling this is measured.

How the number is measured: <code>[InfraMeasurement]()[*g*, [InfraShell]()[*c*, *r*], "CountingMeasure"]</code> counts the vertices at distance exactly *r* from *c*, one row of the distance matrix at the value *r*. The profile over *r* is the derivative of the ball profile, and its [LogDifferenceQuotients]() tend to one less than the dimension.

The head holds the centre and the band and computes nothing. A shell has one member, the vertex set, so [FindInfraRepresentative]() gives it as a sorted vertex list. [InfraMeasurement]() also reads `"VertexDensity"`, `"EdgeDensity"`, `"Cardinality"`, `"Faithful"` and `"Subgraph"`. [FindInfraShell]() is the level set as a function.

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Postulate 3 | To draw a circle with any center and radius; the shell is its locus of points. |
| Tarski | Equidistance | The set equidistant from a centre, from the four-place congruence relation. |
| Hilbert | (defined) | Not primitive; defined through segment congruence. |

## Basic Examples

The band of radii 2 to 4 about the centre of the discretized plane, the square grid and the hexagonal tiling. The Riemannian measure keeps the middle shell, in green; the two rims, in blue, are boundary.

```wl
Row[Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {band = InfraShell[First @ GraphCenter[g], {2, 4}]},
    {support = FindInfraRepresentative[g, band]},
    Labeled[
      InfraSubstrateHighlight[g, {InfraInterior[g, support] -> StandardGreen, InfraBoundary[g, support] -> StandardBlue}],
      InfraMeasurement[g, band, {"CountingMeasure", "RiemannianMeasure"}]]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]]
```

The shell area against the radius on the same three substrates: *4 r* on the square grid, *3 r* on the hexagonal tiling, and no formula on the mesh.

```wl
With[
  {names = {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}},
  ListLinePlot[
    Table[
      With[{g = InfraSubstrate[name, "Medium"]}, Table[InfraMeasurement[g, InfraShell[First @ GraphCenter[g], r], "CountingMeasure"], {r, 1, 7}]],
      {name, names}],
    DataRange -> {1, 7}, PlotMarkers -> Automatic, PlotLegends -> names, AxesLabel -> {"r", "A(r)"}]]
```

## Scope

Single shells of radius 2 to 5, one colour each. Each is all boundary, so its Riemannian measure is 0.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {shells = Table[InfraShell[First @ GraphCenter[g], r], {r, 2, 5}]},
  {InfraSubstrateHighlight[g, shells], InfraMeasurement[g, shells, "CountingMeasure"], InfraMeasurement[g, shells, "RiemannianMeasure"]}]
```

The shell about two vertices at once.

```wl
FindInfraRepresentative[PathGraph[Range[7]], InfraShell[{1, 7}, 1]]
```

## Properties and Relations

The shell area of the triangular tiling and of the large cubic grid, as points, against *6r* and *4r² + 2*, as curves.

```wl
GraphicsRow[MapThread[
  {substrate, maxRadius, shellArea} |-> Show[
    Plot[shellArea, {r, 1, maxRadius}],
    ListPlot[
      Table[InfraMeasurement[substrate, InfraShell[First @ GraphCenter[substrate], r], "CountingMeasure"], {r, 1, maxRadius}],
      DataRange -> {1, maxRadius}, PlotMarkers -> Automatic]],
  {{InfraSubstrate["TriangularTilingGraph", "Medium"], InfraSubstrate["CubicGridGraph", "Large"]}, {6, 4}, {6 r, 4 r^2 + 2}}]]
```

Inside a scene the token names the shell about a point, and [FindInfraScene]() binds it to the same vertex set. Two shells meet in a few vertices, one per branch.

```wl
ClearAll[pA, pB, shellA, shellB, meet];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[c, 2]])},
  {constr = InfraScene[{pA, pB, shellA, shellB, meet},
     {pA == InfraPoint[c], pB == InfraPoint[b],
      shellA == InfraShell[pA, 2], shellB == InfraShell[pB, 2],
      meet == InfraIntersection[shellA, shellB]}]},
  {solved = FindInfraScene[constr, g]},
  InfraSubstrateHighlight[g,
    Join[{InfraSceneInstance[First @ solved, shellA],
          InfraSceneInstance[First @ solved, shellB]},
      InfraSceneInstance[#, meet] & /@ solved]]]
```
