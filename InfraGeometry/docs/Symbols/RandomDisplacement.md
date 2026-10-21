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

<code>[RandomDisplacement]()[*g*, *r*]</code> gives a random 1-continuous single-valued displacement of *g* of magnitude at most *r*.

<code>[RandomDisplacement]()[*g*]</code> takes *r* = 1.

## Details & Options

The result *D* has one value at each vertex, every step has length at most *r*, *d(v, D(v)) ≤ r*, and *D* is 1-continuous: the values at the ends of every edge are at most one step apart ([ContinuousDisplacementQ]()). It is the discrete counterpart of the flow of a random smooth vector field.

The steps are not all of length *r*. So the result is in general not a section of <code>[InfraDisplacementBundle]()[*g*, *r*]</code>, whose sections move every vertex by exactly *r*; [RandomInfraSection]() draws those.

A random choice that is not 1-continuous is repaired a bounded number of times. When the repair fails, the call stays unevaluated.

Options:

| Option | Default | Values |
|---|---|---|
| [RandomSeeding]() | `Automatic` | an integer or a string for a reproducible draw; `Inherited` to draw from the current random state |

With the default every call draws afresh, and [SeedRandom]() does not fix the result.

## Basic Examples

A random displacement of magnitude at most 2 on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    DisplacementPlot[g, RandomDisplacement[g, 2, RandomSeeding -> 1]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The bounds 1, 2 and 3 on the grid, each with its magnitude:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  GraphicsRow @ Table[
    With[{d = RandomDisplacement[g, r, RandomSeeding -> 1]},
      DisplacementPlot[g, d, PlotLabel -> DisplacementMagnitude[g, d]]],
    {r, 3}]]
```

## Options

### RandomSeeding

A fixed seed gives the same draw whatever [SeedRandom]() has set:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  SameQ @@ Table[SeedRandom[k]; RandomDisplacement[g, 2, RandomSeeding -> 7], {k, 3}]]
```

## Properties and Relations

The result is single-valued, of magnitude at most *r*, and 1-continuous:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {d = RandomDisplacement[g, 2, RandomSeeding -> 1]},
  {DisplacementSingleValuedQ[d], DisplacementMagnitude[g, d], ContinuousDisplacementQ[g, d]}]
```

The step lengths at *r* = 2, with their counts. On the mesh 24 vertices stay:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {d = RandomDisplacement[g, 2, RandomSeeding -> 1]},
    KeySort @ Counts @ KeyValueMap[GraphDistance[g, #1, First[#2]] &, d]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Possible Issues

The repair can fail, and the call then stays unevaluated. On the hexagonal tiling at *r* = 3, six of the seeds 1 to 10 fail:

```wl
With[{g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  Table[Head @ RandomDisplacement[g, 3, RandomSeeding -> seed], {seed, 10}]]
```
