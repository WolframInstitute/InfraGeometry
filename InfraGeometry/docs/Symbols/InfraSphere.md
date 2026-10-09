---
Template: Symbol
Name: InfraSphere
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSphere
Keywords: [sphere, separating set, minimal, region, symbolic object, family, counting measure, Riemannian measure]
SeeAlso: [FindInfraSphere, InfraShell, InfraBall, InfraMeasurement, FindInfraRepresentative]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraSphere]()[*c*, {*r*, *s*}]</code> is the sphere about *c*: the family of inclusion-minimal connected subsets of the shell [InfraShell]()[*c*, {*r*, *s*}] that separate the side of *c* from the far side. It is a symbolic object; [InfraMeasurement]() and [FindInfraRepresentative]() evaluate it on a graph.

<code>[InfraSphere]()[*c*, *r*]</code> is the band {*r*, *r*}.

## Details & Options

Definition: a sphere of the shell *S* is a subset *T ⊆ S* such that the induced subgraph on *T* is connected, deleting *T* leaves the component of *c* within the mean radius and every other vertex beyond it, and no proper subset of *T* does.

The family may be empty. On a bipartite graph, such as the square grid and the hexagonal tiling, no two vertices at the same distance from *c* are adjacent, so a shell of one radius has no connected subset of more than one vertex and carries no sphere. A band of two radii carries spheres on the square grid. When the shell wraps around, as on a torus, and does not separate, the family is empty as well.

The family may have many members. The shell is a set of points; the sphere is the family of its connected separating subsets, and it is searched, not read off a graph: no polynomial-size faithful graph of the family is known. [FindInfraSphere]() is the search.

[InfraMeasurement]() reads the family through the exhaustive search, so it is expensive. `"VertexDensity"` is the sum of the indicators of the members, `"EdgeDensity"` the sum of their induced edge sets, `"Cardinality"` their number. The two measures are read on the support of the density, the union of the members:

| Measure | Value |
|---|---|
| `"CountingMeasure"` | the number of vertices in some member |
| `"RiemannianMeasure"` | the number of vertices of the support all of whose neighbours lie in it; `0` for a sphere of one radius *r ≥ 1*, since every vertex of it has a neighbour at distance *r − 1* |

`"Faithful"` is `Undetermined`. A sphere has no `"Graph"`.

The Riemannian measure of a sphere instance in a band *{r, r + 1}*, *r ≥ 1*, is `0` too, whenever every vertex at distance *r + 1* has a neighbour at distance *r + 2*: each vertex of the instance then has a neighbour outside the band.

No count is known. The family has no closed formula for its number of members, and one instance none for its size: the size of one instance bounds the size of no other. The reference is the shell it lies in, whose count [InfraShell]() gives on a lattice. In the continuum a sphere instance stands for the geodesic sphere, of area *n ω_n r^(n−1) (1 − Scal(c) r² / (6n) + O(r⁴))*.

How the number is measured: one instance *T*, <code>[FindInfraRepresentative]()[*g*, [InfraSphere]()[*c*, {*r*, *r* + 1}]]</code>, found greedily, is a vertex list, and <code>[InfraMeasurement]()[*g*, [InfraTube]()[*T*, 0], *measure*]</code> measures it as a region. The profile is the list of the instance sizes over *r*, a profile of instances, not of the family.

[FindInfraRepresentative]() gives members: a count, `"RandomChoice"` and `"Pruning" -> q` are translated to the `"NextVertexFunction"` of [FindInfraSphere](). Without a count it gives one member, a sorted vertex list.

## Basic Examples

The shell of radius 3, and the sphere in it, on the discretized plane, the square grid and the hexagonal tiling, labelled with the number of members and the two measures. The shell of the mesh is a connected ring and is its own sphere; the two lattices are bipartite, and the family is empty.

```wl
Row[Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = First @ GraphCenter[g]},
    {family = InfraSphere[c, 3]},
    Labeled[
      InfraSubstrateHighlight[g, {InfraShell[c, 3], FindInfraRepresentative[g, family], c}],
      InfraMeasurement[g, family, {"Cardinality", "CountingMeasure", "RiemannianMeasure"}]]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]]
```

The four minimal connected separators in the band 1 to 2 about the centre of a 5 by 5 grid, each drawn on its own.

```wl
With[
  {g = GridGraph[{5, 5}]},
  {members = FindInfraRepresentative[g, InfraSphere[13, {1, 2}], All]},
  Row[InfraSubstrateHighlight[g, {#, 13}] & /@ members]]
```

## Properties and Relations

Measuring the family of the 5 by 5 grid: four members, eight vertices in their union, none of them inside.

```wl
InfraMeasurement[GridGraph[{5, 5}], InfraSphere[13, {1, 2}], {"Cardinality", "Faithful", "CountingMeasure", "RiemannianMeasure"}]
```

The size of one instance per band *{r, r + 1}* about the centre of the square grid, as points, against the count of the band, as a curve.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium"]},
  {c = First @ GraphCenter[g]},
  ListPlot[{
    Table[Length[FindInfraRepresentative[g, InfraSphere[c, {r, r + 1}]]], {r, 1, 6}],
    Table[InfraMeasurement[g, InfraShell[c, {r, r + 1}], "CountingMeasure"], {r, 1, 6}]},
    DataRange -> {1, 6}, Joined -> {False, True}, PlotMarkers -> Automatic, AxesLabel -> {"r", None}]]
```

A member is connected and is contained in the shell.

```wl
With[
  {g = GridGraph[{7, 7}]},
  {members = FindInfraRepresentative[g, InfraSphere[25, {2, 3}], All]},
  {ConnectedGraphQ @ Subgraph[g, #] & /@ members, AllTrue[members, SubsetQ[FindInfraShell[g, 25, {2, 3}], #] &]}]
```
