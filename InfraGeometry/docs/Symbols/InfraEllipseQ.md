---
Template: Symbol
Name: InfraEllipseQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraEllipseQ
Keywords: [ellipse, foci, distance sum, cycle, test, predicate]
SeeAlso: [InfraEllipse, RandomInfraEllipse, InfraCircleQ, InfraQuadric, InfraBallQ]
---

## Usage

<code>[InfraEllipseQ]()[*g*, *cycle*]</code> gives `True` if the closed walk *cycle* is an ellipse of *g*, and `False` otherwise.

## Details & Options

An ellipse here is a cycle whose vertex set is a level set *{v : d(p, v) + d(q, v) = s}* for two distinct vertices *p*, *q* and a sum *s*: the vertices are distinct, each is adjacent to the next and the last to the first, and together they are the whole level set.

The cycle can be a vertex list, with or without the first vertex repeated at the end, or a cycle graph. A list of cycle graphs gives `True` when every one is an ellipse.

Every pair of distinct vertices is tried as foci. Equal foci are not tried, so a circle is not an ellipse in this sense.

The cycles that [RandomInfraEllipse]() draws on a band of several sums are not ellipses in this sense.

## Basic Examples

The cycle graph with six vertices is an ellipse: for antipodal foci every vertex has distance sum 3. It is not a circle:

```wl
{InfraEllipseQ[CycleGraph[6], Range[6]], InfraCircleQ[CycleGraph[6], Range[6]]}
```

An ellipse on the band of sums 6 to 8 spans two or three levels, so it is not a level set:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {q = RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1]},
    {e = RandomInfraEllipse[g, InfraEllipse[{c, q}, {6, 8}], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {e, c, q},
      PlotLabel -> {InfraEllipseQ[g, e], Union[GraphDistance[g, c, #] + GraphDistance[g, q, #] & /@ VertexList[e]]}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Scope

A cycle graph and its closed vertex list give the same answer:

```wl
{InfraEllipseQ[CycleGraph[6], CycleGraph[6]], InfraEllipseQ[CycleGraph[6], Append[Range[6], 1]]}
```

## Properties and Relations

A circle is not an ellipse in this sense, its foci being equal:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {cycle = First @ RandomInfraCircle[g, InfraCircle[c, 2], All]},
  {InfraCircleQ[g, cycle], InfraEllipseQ[g, cycle]}]
```
