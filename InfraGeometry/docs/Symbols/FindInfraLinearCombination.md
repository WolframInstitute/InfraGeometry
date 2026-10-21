---
Template: Symbol
Name: FindInfraLinearCombination
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraLinearCombination
Keywords: [linear combination, vector sum, scaling, parallelogram, midpoint, base point, tangent vector]
SeeAlso: [InfraScalarProduct, InfraComparisonAngle, InfraMidpoint, RandomInfraInfiniteLine, RandomInfraParallel]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

<code>[FindInfraLinearCombination]()[*g*, *o*, {{*λ1*, *u1*}, {*λ2*, *u2*}, …}]</code> gives the vertices that realise *λ₁u₁ + λ₂u₂ + …*, the vertices read as vectors from the base point *o*.

<code>[FindInfraLinearCombination]()[*g*, *o*, *terms*, *n*]</code> gives *n* of them.

## Details & Options

A graph has no vector addition, so a combination is realised by the vertices that satisfy its metric description. There may be several, or none.

A multiple *λu* is realised by the vertices *w* with *d(o, w) = |λ| d(o, u)* in the direction of *u*: for *λ* > 0 *w* lies on a shortest path from *o* to *u* or *u* on one from *o* to *w*; for *λ* < 0, *o* lies on a shortest path from *w* to *u*.

A sum *u + v* is realised by the vertices *w* ≠ *o* with *d(u, w) = d(o, v)* and *d(v, w) = d(o, u)*: the fourth corner of a parallelogram with opposite sides of equal length.

The terms are scaled, then summed from left to right.

The count *n* can be `n`, `UpTo[n]` or `All`, the default. Fewer than *n* realisations give `{}`.

Options:

| Option | Default | Values |
|---|---|---|
| `"ScaleMethod"` | `Automatic` | `"Metric"`, the distance condition above; `"Midpoint"`, repeated midpoints, for *λ* in [0, 1] with a power of 2 as denominator; `"Line"`, the vertex at the scaled position along each line through *o* and *u*; `Automatic` takes `"Metric"` for an integer *λ*, `"Midpoint"` where it applies, `"Line"` otherwise |
| `"SumMethod"` | `"Metric"` | `"Metric"`, the parallelogram condition above; `"Parallel"`, the meeting points of the parallels to *ou* through *v* and to *ov* through *u* |

## Basic Examples

The sum of two vertices at distance 3 from the centre, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {o = First @ GraphCenter[g]},
    {u = RandomInfraPoint[g, InfraShell[o, 3], RandomSeeding -> 1]},
    {v = RandomInfraPoint[g, InfraShell[o, 3], RandomSeeding -> 2]},
    {sum = FindInfraLinearCombination[g, o, {{1, u}, {1, v}}]},
    InfraSubstrateHighlight[g, {InfraSegment[o, u], InfraSegment[o, v], sum, o}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The sum is not unique. On the grid two axis vectors of length 2 from the centre 45, to 65 and to 47, have two sums, one and two diagonal steps away:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {sum = FindInfraLinearCombination[g, 45, {{1, 65}, {1, 47}}]},
  InfraSubstrateHighlight[g, {InfraSegment[45, 65], InfraSegment[45, 47], sum, 45}, ImageSize -> Medium]]
```

Twice a diagonal vector of the grid, and its negative. Each has three realisations, the vertices at distance 4 beyond *u* and at distance 2 behind *o*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {double = FindInfraLinearCombination[g, 45, {{2, 56}}]}, {negative = FindInfraLinearCombination[g, 45, {{-1, 56}}]},
  InfraSubstrateHighlight[g, {double, negative, 56, 45}, ImageSize -> Medium]]
```

## Scope

A difference *u − v*, and the first realisation only:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  Table[FindInfraLinearCombination[g, 45, {{1, 56}, {-1, 54}}, n], {n, {All, UpTo[1]}}]]
```

Half a vector is a midpoint of *o* and *u*. Half the diagonal vector to 67, two steps along each axis:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  InfraSubstrateHighlight[g, {FindInfraLinearCombination[g, 45, {{1/2, 67}}], 67, 45}, ImageSize -> Medium]]
```

## Options

### ScaleMethod

For 3/2 of an axis vector the three methods that apply agree:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  Table[FindInfraLinearCombination[g, 45, {{3/2, 65}}, "ScaleMethod" -> m], {m, {Automatic, "Metric", "Line"}}]]
```

### SumMethod

On the grid the parallels are many, so the parallel sum has many realisations. On a 5 × 5 grid, the sum of the two axis steps from the centre:

```wl
Table[Length @ FindInfraLinearCombination[GridGraph[{5, 5}], 13, {{1, 14}, {1, 18}}, "SumMethod" -> m],
  {m, {"Metric", "Parallel"}}]
```

## Properties and Relations

Every realisation of *u + v* closes a parallelogram: it lies at distance *d(o, v)* from *u* and *d(o, u)* from *v*:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {o = First @ GraphCenter[g]},
  {u = RandomInfraPoint[g, InfraShell[o, 3], RandomSeeding -> 1]},
  {v = RandomInfraPoint[g, InfraShell[o, 4], RandomSeeding -> 3]},
  Table[{GraphDistance[g, u, w], GraphDistance[g, v, w]}, {w, FindInfraLinearCombination[g, o, {{1, u}, {1, v}}]}]]
```
