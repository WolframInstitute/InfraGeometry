---
Template: Symbol
Name: RandomDisplacement
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomDisplacement
Keywords: [displacement, random, vector field, continuous section, flow]
SeeAlso: [ContinuousDisplacementQ, DisplacementMagnitude, DisplacementPlot, RandomInfraSection, InfraDisplacementBundle]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[RandomDisplacement]()[*g*, *r*]</code> gives a random single-valued displacement of magnitude at most *r*, built to be 1-continuous.

<code>[RandomDisplacement]()[*g*]</code> takes *r* = 1.

## Details & Options

Construction: the vertices are visited in breadth-first order from the first vertex of *g*. Each takes a random vertex of its ball of radius *r* that lies within one step of the targets already given to its neighbours, or, when there is none, a vertex of the ball that brings it closest to them. Then the vertices of every edge whose targets are more than one step apart are given new targets, closest to their neighbours' targets and to themselves, up to 50 times; the whole construction is tried up to 5 times.

The result is single-valued and has magnitude at most *r*. It is 1-continuous ([ContinuousDisplacementQ]()). When the repair leaves a discontinuity after the 5 attempts, which happens at larger *r*, the call stays unevaluated.

The construction draws with [RandomChoice](), so [SeedRandom]() fixes the result.

## Basic Examples

Random displacements of magnitude at most 2 on the discretized plane, the square tiling and the hexagonal tiling: coherent flows with sinks.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {field = (SeedRandom[1]; RandomDisplacement[g, 2])},
    DisplacementPlot[g, field]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]
```

## Scope

The magnitude bound 1, 2 and 3 on the square tiling.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {fields = Table[SeedRandom[1]; RandomDisplacement[g, r], {r, 3}]},
  {GraphicsRow[DisplacementPlot[g, #] & /@ fields], DisplacementMagnitude[g, #] & /@ fields}]
```

## Properties and Relations

A random displacement is single-valued, has magnitude at most *r*, and here is 1-continuous.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {field = (SeedRandom[1]; RandomDisplacement[g, 2])},
  {DisplacementPlot[g, field], DisplacementSingleValuedQ[field], DisplacementMagnitude[g, field], ContinuousDisplacementQ[g, field]}]
```

The steps have length at most *r*, not exactly *r*. At *r* = 2 most steps have length 2 and some have length 1, so the displacement is not a section of <code>[InfraDisplacementBundle]()[*g*, 2]</code>, whose sections move every vertex by exactly 2; [RandomInfraSection]() draws such a section, continuous or not. The counts of the step lengths:

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {field = (SeedRandom[1]; RandomDisplacement[g, 2])},
  {DisplacementPlot[g, field], Normal @ KeySort @ Counts[KeyValueMap[GraphDistance[g, #1, First[#2]] &, field]]}]
```

## Possible Issues

The construction can fail, and then the call stays unevaluated. At magnitude 3 on the hexagonal tiling the repair does not always remove every discontinuity: of the seeds 1 to 10, four give a displacement and six leave the call unevaluated.

```wl
Table[
  With[
    {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
    SeedRandom[seed]; Head @ RandomDisplacement[g, 3]],
  {seed, 10}]
```
