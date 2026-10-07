---
Template: Symbol
Name: FindInfraShell
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraShell
Keywords: [shell, sphere, level surface, volume growth, dimension]
SeeAlso: [InfraShell, InfraBall, FindInfraSphere, InfraMeasurement, InfraCircle, InfraShellQ]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

<code>[FindInfraShell]()[*g*, *c*, *r*]</code> gives the metric shell $\{v : d(c,v) = r\}$ around *c* as a sorted vertex list. *r* may be a band `{rmin, rmax}`, and *c* a vertex list, with the set distance.


## Details & Options

The shell of radius *r* about *c* is $\{v : d(c,v) = r\}$ — the sphere of the graph metric, as a vertex **set**.

It is the discrete analogue of a sphere, not of a circle: it is codimension-1 as a set, but on a lattice its vertices are pairwise non-adjacent, so it carries no cycle. The cyclic object is [InfraCircle](), which needs a thickened band for exactly that reason.

The shell is the substrate of the volume-growth invariants. Its cardinality as a function of *r* is the surface-area profile, which [InfraMeasurement]() reads as the `"CountingMeasure"` of [InfraShell]() at every radius, and on a flat lattice it grows **linearly**, which is the statement that the dimension is 2. The slope is a property of the tiling: 4 per step on the square grid, 3 on the hexagonal.

It is the level set of the inert head [InfraShell](), as a function. The connected subsets of a shell that separate the centre from the outside are [FindInfraSphere]().

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Postulate 3 | To draw a circle with any center and radius; the shell is its locus of points. |
| Tarski | Equidistance | The set equidistant from a centre, from the four-place congruence relation. |
| Hilbert | (defined) | Not primitive; defined through segment congruence. |

## Basic Examples

The shells of radius 1 to 5 about the centre of the square, hexagonal and triangular tilings: nested rings, one colour each, the spheres of the polyhedral norm each tiling carries.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = First @ GraphCenter[g]},
    InfraSubstrateHighlight[g, Table[FindInfraShell[g, c, r], {r, 1, 5}]]],
  {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]
```

Shell size against radius. On the three lattices the growth is linear, the intrinsic statement that these substrates are two-dimensional; the slope belongs to the tiling: 4 on the square, 3 on the hexagonal, 6 on the triangular.

```wl
With[
  {names = {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}},
  ListLinePlot[
    Table[With[{g = InfraSubstrate[name, "Medium"]}, Table[Length @ FindInfraShell[g, First @ GraphCenter[g], r], {r, 0, 6}]], {name, names}],
    DataRange -> {0, 6}, PlotMarkers -> Automatic, PlotLegends -> names, AxesLabel -> {"r", "|S_r|"}]]
```

A band of radii 2 to 4 about the centre, as one vertex set.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  InfraSubstrateHighlight[g, {FindInfraShell[g, c, {2, 4}], c}]]
```

## Properties and Relations

The ball is the union of the shells up to its radius, so the volumes are the partial sums of the areas.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Medium"]},
  {c = First @ GraphCenter[g]},
  {areas = Table[Length @ FindInfraShell[g, c, r], {r, 0, 5}]},
  {volumes = Table[Length @ FindInfraRepresentative[g, InfraBall[c, r]], {r, 0, 5}]},
  {ListLinePlot[{Accumulate @ areas, volumes}, DataRange -> {0, 5}, PlotMarkers -> {Automatic, Medium},
     PlotLegends -> {"partial sums of |S_r|", "|B_r|"}, AxesLabel -> {"r", None}],
   Accumulate[areas] === volumes}]
```

The shell sizes are the `"CountingMeasure"` of [InfraShell]().

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Medium"]},
  {c = First @ GraphCenter[g]},
  {areas = Table[Length @ FindInfraShell[g, c, r], {r, 0, 5}]},
  {ListPlot[areas, DataRange -> {0, 5}, AxesLabel -> {"r", "A(r)"}], areas === Table[InfraMeasurement[g, InfraShell[c, r], "CountingMeasure"], {r, 0, 5}]}]
```
