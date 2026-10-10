---
Template: Symbol
Name: DisplacementReduce
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/DisplacementReduce
Keywords: [displacement, metric centre, eccentricity, tie, multivalued, contraction]
SeeAlso: [DisplacementSingleValuedQ, DisplacementSum, DisplacementScale, DisplacementCompose, GraphCenter]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[DisplacementReduce]()[*g*, *d*]</code> contracts each value of the displacement *d* to its metric centre, the vertices of least eccentricity within the value, repeated until nothing changes.

## Details & Options

Definition: for a set *S* of vertices let *c(S) = { x ∈ S : max_{y ∈ S} d(x, y) is least }*. The reduced value at *v* is the fixed point of *S ↦ c(S)* starting from *D(v)*.

Each reduced value is a subset of the original one, so no step becomes longer. A single vertex stays. A set whose vertices are all equally central, such as any two vertices or all the vertices of a cycle, stays as it is: a tie the metric does not break.

The values of a displacement are sets because the metric does not always decide: half a step, the midpoints of [DisplacementSum](), the continuations of [DisplacementScale]() on the hexagonal tiling. The reduction keeps the part the metric decides.

## Basic Examples

A step from the centre to a ball of radius 1, blue, contracts to the centre of the ball, orange, on the discretized plane, the square tiling and the hexagonal tiling.

```wl
SeedRandom[1];
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = First @ GraphCenter[g]},
    {target = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[c, 3]])},
    {blurred = <|c -> RandomInfraBall[ g, InfraBall[target, 1] ]|>},
    DisplacementPlot[g, {blurred, DisplacementReduce[g, blurred]}]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]
```

The step right of the 6 × 6 grid, its values blurred to the target and its neighbours, comes back under the reduction.

```wl
With[
  {g = GridGraph[{6, 6}]},
  {right = TranslationDisplacement[g, {1, 0}]},
  {blurred = Map[Union[#, AdjacencyList[g, First[#]]] &, right]},
  {GraphicsRow[{DisplacementPlot[g, blurred], DisplacementPlot[g, DisplacementReduce[g, blurred]]}], DisplacementReduce[g, blurred] === right}]
```

## Scope

Three vertices in a row reduce to the middle one; two vertices stay. Two outward steps from the vertex 12 of the square tiling end at three vertices in a row, and one outward step at two.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {radial = First @ PolarDisplacements[g, First @ GraphCenter[g]]},
  {twoSteps = KeyTake[DisplacementCompose[radial, radial], {12}], oneStep = KeyTake[radial, {12}]},
  {DisplacementPlot[g, {twoSteps, DisplacementReduce[g, twoSteps]}], twoSteps[12], DisplacementReduce[g, twoSteps][12], DisplacementReduce[g, oneStep][12]}]
```

## Properties and Relations

A tie survives. The two outward neighbours of a vertex off the axes of the square tiling are equally central, so the outward radial displacement is already reduced.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {radial = First @ PolarDisplacements[g, First @ GraphCenter[g]]},
  {DisplacementPlot[g, radial], DisplacementReduce[g, radial] === radial, DisplacementSingleValuedQ[radial]}]
```

Half a step of the 12-cycle rotation is both ends of the step, a tie of two adjacent vertices.

```wl
With[
  {g = CycleGraph[12]},
  {half = DisplacementScale[g, FindKillingDisplacement[g], 1/2]},
  {DisplacementPlot[g, half], half[1], DisplacementReduce[g, half][1]}]
```
