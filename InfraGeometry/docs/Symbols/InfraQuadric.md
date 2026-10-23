---
Template: Symbol
Name: InfraQuadric
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraQuadric
Keywords: [quadric, ellipse, ellipsoid, hyperbola, elliptic shell, foci, region, symbolic object]
SeeAlso: [InfraBall, InfraShell, InfraSegment, InfraEllipse, InfraPerpendicularBisector, InfraMeasurement, InfraMemberQ]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraQuadric]()[{*p1*, …, *pk*}, *c*]</code> is the region of the vertices whose distances to the foci *p1*, …, *pk* sum to at most *c*.

<code>[InfraQuadric]()[*foci*, {*lo*, *hi*}]</code> is the band of the vertices whose distance sum lies between *lo* and *hi*.

<code>[InfraQuadric]()[*foci*, *c*, {*w1*, …, *wk*}]</code> uses the weighted sum *Σ wᵢ d(pᵢ, v)*.

## Details & Options

The quadric is *{v : Σᵢ wᵢ d(pᵢ, v) ≤ c}*, and the band *{v : lo ≤ Σᵢ wᵢ d(pᵢ, v) ≤ hi}*. The weights are 1 when omitted.

| Foci | Weights | Region |
|---|---|---|
| one | 1 | the ball; the band {*r*, *r*} is the shell |
| two | 1, 1 | the ellipse; the band {*c*, *c*} is the elliptic shell |
| two | 1, −1 | a branch of a hyperbola; the band {0, 0} is the perpendicular bisector |

The elliptic shell of level *d(p, q)* is the metric interval *I(p, q)*, the support of [InfraSegment]()[*p*, *q*]: the degenerate ellipse.

On the square grid the shapes are those of the ℓ¹ norm. The ellipse is a hexagon, and a branch of the hyperbola with foci on one row is a straight column. The grid is bipartite, so an elliptic shell whose level differs from *d(p, q)* in parity is empty.

A focus can be a vertex or a vertex set; the distance is then the distance to the set.

[InfraQuadric]() is a symbolic object, a region with one member, its vertex set. [InfraMeasurement]() reads its density, 1 on every vertex, and the two measures. A weight list of the wrong length leaves it unevaluated.

## Basic Examples

The ellipse of two foci at distance 4, of level 6, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
    {q = RandomInfraPoint[g, InfraShell[p, 4], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraQuadric[{p, q}, 6], p, q}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The elliptic shells of levels 4, 6 and 8 about two foci on one row of the grid. Level 4 is the interval between them:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {xy = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {p = First @ Keys @ Select[xy, # - xy[c] == {-2, 0} &]}, {q = First @ Keys @ Select[xy, # - xy[c] == {2, 0} &]},
  InfraSubstrateHighlight[g, {InfraQuadric[{p, q}, {8, 8}], InfraQuadric[{p, q}, {6, 6}], InfraQuadric[{p, q}, {4, 4}], p, q},
    ImageSize -> Medium]]
```

## Scope

A branch of the hyperbola, *d(p, v) − d(q, v) = 2*. On the grid, with the foci on one column, it is a straight row; on the mesh it bends:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
    {q = RandomInfraPoint[g, InfraShell[p, 4], RandomSeeding -> 3]},
    InfraSubstrateHighlight[g, {InfraQuadric[{p, q}, {2, 2}, {1, -1}], p, q}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

Three foci pairwise at distance 5, and the regions of levels 13, 11 and 9. No vertex has a distance sum below 9:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {foci = RandomInfraPoint[g, InfraShell[c, 3], 3, "PairwiseDistance" -> "Max", RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {InfraQuadric[foci, 13], InfraQuadric[foci, 11], InfraQuadric[foci, 9], foci}, ImageSize -> Medium]]
```

## Properties and Relations

The elliptic shell of level *d(p, q)* is the interval of the segment:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium"]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 5], RandomSeeding -> 1]},
  Keys @ InfraMeasurement[g, InfraQuadric[{p, q}, {5, 5}], "VertexDensity"] == Keys @ InfraMeasurement[g, InfraSegment[p, q], "VertexDensity"]]
```

One focus gives the ball, and the band {0, 0} with weights 1, −1 the perpendicular bisector:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 4], RandomSeeding -> 1]},
  {Keys @ InfraMeasurement[g, InfraQuadric[{p}, 3], "VertexDensity"] == Keys @ InfraMeasurement[g, InfraBall[p, 3], "VertexDensity"],
   Keys @ InfraMeasurement[g, InfraQuadric[{p, q}, {0, 0}, {1, -1}], "VertexDensity"] ==
     Keys @ InfraMeasurement[g, InfraPerpendicularBisector[p, q], "VertexDensity"]}]
```

## Possible Issues

On the square grid an elliptic shell of the wrong parity is empty. The sizes of the shells of levels 4 to 8 about two foci at distance 4:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 4], RandomSeeding -> 1]},
  Table[InfraMeasurement[g, InfraQuadric[{p, q}, {k, k}], "CountingMeasure"], {k, 4, 8}]]
```
