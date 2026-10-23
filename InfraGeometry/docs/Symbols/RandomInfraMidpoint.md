---
Template: Symbol
Name: RandomInfraMidpoint
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraMidpoint
Keywords: [midpoint, segment, interval, middle layer, Euclid I.10]
SeeAlso: [InfraMidpoint, InfraSegment, IntervalGraph, RandomInfraPoint, InfraPerpendicularBisector]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraMidpoint]()[*g*, *p*, *q*]</code> gives a random midpoint of the segment from *p* to *q* in *g*.

<code>[RandomInfraMidpoint]()[*g*, *p*, *q*, *n*]</code> gives a list of *n* distinct midpoints.

<code>[RandomInfraMidpoint]()[*g*, [InfraMidpoint]()[*p*, *q*]]</code> and <code>[RandomInfraMidpoint]()[*g*, [InfraMidpoint]()[*p*, *q*], *n*]</code> are the same with the midpoint given as a token.

## Details & Options

The midpoints are the vertices *v* of the interval *I(p, q)* that minimize *max(d(p, v), d(v, q))*. For *d(p, q) = 2k* they are the vertices with *d(p, v) = d(v, q) = k*. For *d(p, q) = 2k + 1* they are the two middle layers, at distances *k* and *k + 1* from *p*.

A midpoint need not be unique. On the square grid, with *a ≤ b* the axis steps from *p* to *q*, there are *a + 1* midpoints when *a + b* is even and *2(a + 1)* when it is odd.

Equal points give the point itself. Points in different components give `{}`.

The draw is uniform over the midpoints. The count *n* can be `n`, `UpTo[n]` or `All`; `All` gives them in vertex order.

Options:

| Option | Default | Values |
|---|---|---|
| `"NextVertexFunction"` | `Automatic` | `Automatic` random; `Identity` the first midpoints in vertex order |
| [RandomSeeding]() | `Automatic` | an integer or a string for a reproducible draw; `Inherited` to draw from the current random state |

Corresponding notion in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | I.10 | To bisect a given finite straight line. Here the bisection can have several answers. |

## Basic Examples

All midpoints of a segment from the centre to a vertex at distance 4, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
    {q = RandomInfraPoint[g, InfraShell[p, 4], RandomSeeding -> 2]},
    InfraSubstrateHighlight[g, {InfraSegment[p, q], RandomInfraMidpoint[g, p, q, All], p, q}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

On the grid the number of midpoints is *a + 1*, with *a* the smaller axis step. The axis steps and the counts for three segments of length 4:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {xy = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  Table[With[{q = RandomInfraPoint[g, InfraShell[p, 4], RandomSeeding -> k]},
    Round @ Sort[Abs[xy[q] - xy[p]]] -> Length @ RandomInfraMidpoint[g, p, q, All]], {k, 3}]]
```

A random midpoint is at distance 2 from both ends:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 4], RandomSeeding -> 2]}, {m = RandomInfraMidpoint[g, p, q, RandomSeeding -> 1]},
  {GraphDistance[g, p, m], GraphDistance[g, m, q]}]
```

## Scope

At odd distance there are two middle layers. The segment of length 5 with axis steps 2 and 3 has 6 midpoints:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 5], RandomSeeding -> 1]}, {mids = RandomInfraMidpoint[g, InfraMidpoint[p, q], All]},
  InfraSubstrateHighlight[g, {InfraSegment[p, q], mids, p, q}, PlotLabel -> Length[mids], ImageSize -> Medium]]
```

## Properties and Relations

At even distance *2k* the midpoints are the common points of the circles of radius *k* about *p* and *q*:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 4], RandomSeeding -> 3]},
  RandomInfraMidpoint[g, p, q, All] ===
    Sort @ RandomInfraPoint[g, InfraIntersection[InfraShell[p, 2], InfraShell[q, 2]], All]]
```
