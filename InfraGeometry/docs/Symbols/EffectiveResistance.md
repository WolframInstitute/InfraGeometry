---
Template: Symbol
Name: EffectiveResistance
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/EffectiveResistance
Keywords: [effective resistance, resistance distance, Klein-Randic, electrical network, Laplacian pseudoinverse, Foster's theorem, commute time]
SeeAlso: [ResistanceCoordinates, ResistanceQ, OllivierRicciCurvature, GraphEccentricities]
RelatedGuides: [Experimental]
---

## Usage

<code>[EffectiveResistance]()[*g*, *u*, *v*]</code> gives the effective resistance *R(u, v)* between the vertices *u* and *v* of *g*, every edge a unit resistor.

<code>[EffectiveResistance]()[*g*]</code> gives the matrix of the effective resistances of all pairs of vertices, in the order of [VertexList]().

<code>[EffectiveResistance]()[*g*, *vs*]</code> gives the matrix on the vertex list *vs*.

## Details & Options

The effective resistance is *R(u, v) = (eᵤ − eᵥ)ᵀ L⁺ (eᵤ − eᵥ)*, with *L⁺* the pseudoinverse of the Laplacian [KirchhoffMatrix](). It is the voltage between *u* and *v* when a unit current enters at *u* and leaves at *v*.

*R* is a metric, and *R ≤ d*, with equality on a tree. Adding an edge does not increase any resistance.

On a connected graph with *n* vertices the resistances of the edges add up to *n* − 1 (Foster). The expected commute time of the random walk between *u* and *v* is *2|E| R(u, v)*.

Between two components no current flows, and *R* is [Infinity](). The values are machine numbers.

## Basic Examples

The 61 vertices of the ball of radius 5 about the centre of the grid, a square on its corner, and the 61 vertices nearest to the centre in resistance, a round disk:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {ball = Keys @ InfraMeasurement[g, InfraBall[c, 5], "VertexDensity"], r = EffectiveResistance[g][[VertexIndex[g, c]]]},
  {disk = Take[VertexList[g][[Ordering[r]]], Length[ball]]},
  GraphicsRow[{InfraSubstrateHighlight[g, {ball, c}], InfraSubstrateHighlight[g, {disk, c}]}]]
```

The resistance from the centre against the distance. On a tree they are equal; on the grid and the mesh the resistance grows far more slowly, as in the plane, where it grows like the logarithm of the distance:

```wl
ListPlot[
  Table[
    With[{c = First @ GraphCenter[g]}, Transpose[{GraphDistance[g, c], EffectiveResistance[g][[VertexIndex[g, c]]]}]],
    {g, {InfraSubstrate["SquareGridGraph", "Small"], InfraSubstrate["SquareMeshGraph", "Small"], KaryTree[31]}}],
  PlotLegends -> {"SquareGridGraph", "SquareMeshGraph", "KaryTree[31]"}, AxesLabel -> {"d", "R"}]
```

## Scope

The whole matrix. On the 12-cycle, *R(u, v) = k(12 − k)/12* for vertices *k* steps apart, the two arcs carrying the current in parallel:

```wl
With[{r = EffectiveResistance[CycleGraph[12]]},
  {Chop @ First[r], Max @ Abs[r - Table[Abs[i - j] (12 - Abs[i - j]) / 12, {i, 12}, {j, 12}]] < 10^-9}]
```

The matrix on a vertex list: the centre of the grid and its four neighbours. Each edge has resistance close to 1/2, its value on the infinite square lattice:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium"]}, {c = First @ GraphCenter[g]},
  MatrixForm @ EffectiveResistance[g, Prepend[AdjacencyList[g, c], c]]]
```

Two components. Within a component the resistance is finite; between them it is [Infinity]():

```wl
With[{g = GraphUnion[PathGraph[{1, 2, 3}], PathGraph[{4, 5}]]},
  {EffectiveResistance[g, 1, 3], EffectiveResistance[g, 1, 4], MatrixForm @ EffectiveResistance[g, {1, 3, 4}]}]
```

## Properties and Relations

Foster's theorem: the resistances of the edges add up to one less than the number of vertices. The resistance is at most the distance:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small"]}, {r = EffectiveResistance[g]},
    {Total[r[[VertexIndex[g, First[#]], VertexIndex[g, Last[#]]]] & /@ EdgeList[g]], VertexCount[g] - 1,
     Max[r - GraphDistanceMatrix[g]] < 10^-9}],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```
