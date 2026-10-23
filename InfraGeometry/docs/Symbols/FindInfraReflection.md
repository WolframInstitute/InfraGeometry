---
Template: Symbol
Name: FindInfraReflection
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraReflection
Keywords: [reflection, point reflection, central symmetry, betweenness, Tarski, antipode]
SeeAlso: [InfraMidpoint, RandomInfraMidpoint, InfraShell, MetricInterval, RandomInfraInfiniteLine]
---

## Usage

<code>[FindInfraReflection]()[*g*, *x*, *a*]</code> gives the reflections of the point *x* through the point *a*.

<code>[FindInfraReflection]()[*g*, *x*, *a*, *n*]</code> gives *n* of them.

## Details & Options

A reflection of *x* through *a* is a vertex *x′* with *d(a, x′) = d(a, x)* and *a* between *x* and *x′*. Together the two conditions say *d(a, x′) = r* and *d(x, x′) = 2r*, with *r = d(a, x)*.

In the plane the reflection is unique. On a graph there can be many, or none when the graph ends before distance *2r* from *x*.

On the square grid, away from the rim, the reflections are the vertices of the circle *Sᵣ(a)* in the closed quadrant opposite *x*: *r + 1* vertices when *x − a* is off the axes, *2r + 1* when it is on an axis.

*x* and *a* can be vertices or regions. Regions give the reflections of every pair, pooled.

The count *n* can be `n`, `UpTo[n]` or `All`, the default. Fewer than *n* reflections give `{}`.

Corresponding notion in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Tarski | Segment construction | For any *x*, *a* and *b*, *c* there is *x′* with *a* between *x* and *x′* and *ax′ ≡ bc*; here *bc = ax*. |

## Basic Examples

The reflections of a point at distance 3 from the centre, drawn on the circle of radius 3. On the grid they fill the opposite quadrant:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {x = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1]},
    {xs = FindInfraReflection[g, x, c]},
    InfraSubstrateHighlight[g, {InfraShell[c, 3], x, xs, c}, PlotLabel -> Length[xs]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The number of reflections of each point of the circle of radius 3 on the grid, *r + 1 = 4* off the axes and *2r + 1 = 7* on them:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {shell = Keys @ InfraMeasurement[g, InfraShell[c, 3], "VertexDensity"]},
  InfraSubstrateHighlight[g, {AssociationMap[x |-> Length @ FindInfraReflection[g, x, c], shell], c},
    PlotLabel -> Counts[Length @ FindInfraReflection[g, #, c] & /@ shell], ImageSize -> Medium]]
```

## Properties and Relations

Every reflection is at distance *r* from *a* and *2r* from *x*:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {x = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1]},
  {GraphDistance[g, c, #], GraphDistance[g, x, #]} & /@ FindInfraReflection[g, x, c]]
```

## Possible Issues

Past the rim there is no reflection. The centre reflected through a point at distance 5 would lie at distance 10, beyond the eccentricity 9:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  FindInfraReflection[g, c, RandomInfraPoint[g, InfraShell[c, 5], RandomSeeding -> 1]]]
```
