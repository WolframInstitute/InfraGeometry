---
Template: Symbol
Name: FindInfraShell
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraShell
Keywords: [shell, sphere, level surface, volume growth, dimension]
SeeAlso: [InfraShell, FindInfraBall, ShellAreas, FindInfraCircle, InfraShellQ, SeparatesQ]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

<code>[FindInfraShell]()[*g*, *c*, *r*]</code> gives the metric shell $\{v : d(c,v) = r\}$ around *c* as a sorted vertex list. *r* may be a band `{rmin, rmax}`.

<code>[FindInfraShell]()[*g*, *c*, *r*, *n*]</code> gives a `List` of exactly *n* vertex sets or `$Failed`; `UpTo[n]` gives up to *n*; `All` gives all of them. Under the default `Properties -> {}` the level set is the one vertex set.

## Details & Options

The shell of radius *r* about *c* is $\{v : d(c,v) = r\}$ — the sphere of the graph metric, as a vertex **set**.

It is the discrete analogue of a sphere, not of a circle: it is codimension-1 as a set, but on a lattice its vertices are pairwise non-adjacent, so it carries no cycle. The cyclic object is [FindInfraCircle](), which needs a thickened band for exactly that reason.

The shell is the substrate of the volume-growth invariants. Its cardinality as a function of *r* is the surface-area profile, which [ShellAreas]() counts at every radius at once, and on a flat lattice it grows **linearly**, which is the statement that the dimension is 2. The slope is a property of the tiling: 4 per step on the square grid, 3 on the hexagonal.

Option `Properties` takes `{}` (default; the whole level set as one vertex set), `{"Separating"}` (inclusion-minimal subsets separating the centre from beyond), or `{"Separating", "Connected"}`. Option `Method` takes `Automatic` (default), `"Exhaustive"`, `{"Exhaustive", "Pruning" -> spec}`, `"Greedy"` or `"RandomGreedy"`, and is read only when `Properties` names a class to search: `Automatic` resolves by the count — `All` to `"Exhaustive"`; a bounded or absent count to `"Greedy"`, the lazy peel, so the count-less call is one minimal subset, deterministic — and the class is the same under every value. `"RandomGreedy"` peels in random order, seeded by an ambient `SeedRandom`; `"Pruning"` caps the removable vertices tried per layer, and the result is then minimal among the survivors.

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
    {c = InfraCenter[g]},
    InfraSubstrateHighlight[g, Table[FindInfraShell[g, c, r], {r, 1, 5}]]],
  {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]
```

Shell size against radius. On the three lattices the growth is linear, the intrinsic statement that these substrates are two-dimensional; the slope belongs to the tiling: 4 on the square, 3 on the hexagonal, 6 on the triangular.

```wl
With[
  {names = {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}},
  ListLinePlot[
    Table[With[{g = InfraSubstrate[name, "Medium"]}, Table[Length @ FindInfraShell[g, InfraCenter[g], r], {r, 0, 6}]], {name, names}],
    DataRange -> {0, 6}, PlotMarkers -> Automatic, PlotLegends -> names, AxesLabel -> {"r", "|S_r|"}]]
```

A band of radii 2 to 4 about the centre, as one vertex set.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  InfraSubstrateHighlight[g, {FindInfraShell[g, c, {2, 4}] -> $InfraShellColor, Directive[$InfraPointColor], c}]]
```

## Properties and Relations

The ball is the union of the shells up to its radius, so the volumes are the partial sums of the areas.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Medium"]},
  {c = InfraCenter[g]},
  {areas = Table[Length @ FindInfraShell[g, c, r], {r, 0, 5}]},
  {volumes = Table[Length @ FindInfraBall[g, c, r], {r, 0, 5}]},
  {ListLinePlot[{Accumulate @ areas, volumes}, DataRange -> {0, 5}, PlotMarkers -> {Automatic, Medium},
     PlotLegends -> {"partial sums of |S_r|", "|B_r|"}, AxesLabel -> {"r", None}],
   Accumulate[areas] === volumes}]
```

The shell sizes are the shell-area profile of [ShellAreas]().

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Medium"]},
  {c = InfraCenter[g]},
  {areas = Table[Length @ FindInfraShell[g, c, r], {r, 0, 5}]},
  {ListPlot[areas, DataRange -> {0, 5}, AxesLabel -> {"r", "A(r)"}], areas === ShellAreas[g, c, {0, 5}]}]
```
