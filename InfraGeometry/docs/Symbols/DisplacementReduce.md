---
Template: Symbol
Name: DisplacementReduce
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/DisplacementReduce
Keywords: [displacement, reduce, metric centre, eccentricity, tie, multivalued]
SeeAlso: [DisplacementSingleValuedQ, DisplacementSum, DisplacementScale, DisplacementPlot, GraphCenter]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[DisplacementReduce]()[*g*, *d*]</code> contracts each value of the displacement *d* to its metric centre, repeated until nothing changes.

## Details & Options

For a set *S* of vertices let *c(S)* be the vertices of *S* of least eccentricity within *S*, those minimizing *max {d(x, y) : y ∈ S}*. The reduced value at *v* is the fixed point of *S ↦ c(S)* starting from *D(v)*.

Each reduced value is a subset of the original one, so no step becomes longer. A single vertex stays.

A set whose vertices are all equally central stays as it is: a tie the metric does not break. Any two vertices are such a tie, and so is the circle of radius 2 on the square grid.

The values of a displacement are sets where the metric does not decide: half a step, the midpoints of [DisplacementSum](), the outward neighbours of [PolarDisplacements](). The reduction keeps what the metric decides.

## Basic Examples

A step from the centre to a vertex at distance 3 and its neighbours, in blue, contracts to that vertex, in red, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {t = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1]},
    {blurred = <|c -> Prepend[AdjacencyList[g, t], t]|>},
    DisplacementPlot[g, {blurred, DisplacementReduce[g, blurred]}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

Three vertices on a circle reduce to the middle one. Two outward radial steps from the vertex 56 of the grid:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {radial = First @ PolarDisplacements[g, First @ GraphCenter[g]]},
  {twoSteps = KeyTake[DisplacementCompose[radial, radial], {56}]},
  DisplacementPlot[g, {twoSteps, DisplacementReduce[g, twoSteps]},
    PlotLabel -> {twoSteps[56], DisplacementReduce[g, twoSteps][56]}]]
```

## Scope

Ties stay. Half a step is its two ends, and two outward radial steps from the centre of the grid reach the 8 vertices of the circle of radius 2, all equally central:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {half = DisplacementScale[g, <|c -> {First @ AdjacencyList[g, c]}|>, 1/2]},
  {radial = First @ PolarDisplacements[g, c]},
  {twoSteps = KeyTake[DisplacementCompose[radial, radial], {c}]},
  {DisplacementReduce[g, half] === half, DisplacementReduce[g, twoSteps] === twoSteps, Length[twoSteps[c]]}]
```

## Properties and Relations

Each reduced value is a subset of the original one. The numbers of values of the outward radial displacement of the mesh, with their counts, before and after:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {radial = First @ PolarDisplacements[g, First @ GraphCenter[g]]},
  {reduced = DisplacementReduce[g, radial]},
  {AllTrue[VertexList[g], SubsetQ[radial[#], reduced[#]] &],
   KeySort @ Counts[Length /@ radial], KeySort @ Counts[Length /@ reduced]}]
```
