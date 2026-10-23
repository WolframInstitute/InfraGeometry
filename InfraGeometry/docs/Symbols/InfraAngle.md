---
Template: Symbol
Name: InfraAngle
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraAngle
Keywords: [angle, arc, arclength, length]
SeeAlso: [InfraArc, InfraMeasurement, InfraComparisonAngle, InfraPerpendicularQ]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraAngle]()[*g*, {*q1*, *p*, *q2*}]</code> gives the angle at *p* between *q1* and *q2*: the length of the arc around *p* from *q1* to *q2*.

## Details & Options

The angle is *∠(q₁, p, q₂) = length of* <code>[InfraArc]()[*p*, {*q1*, *q2*}]</code>, the number of edges of a shortest path from *q₁* to *q₂* in the band of the circle about *p* through *q₁*. All arcs of the band have that length.

The angle is a length in edges. It is not divided by the radius, and it is not in radians.

On the square grid with the band {*r*, *r* + 1}, *r = d(p, q₁)*, the angle is the ℓ¹ length of the arc of the circle *|x| + |y| = r*: a right angle is *2r*, a straight angle *4r*, the full turn, *q₂ = q₁*, is *8r*.

When no arc joins *q₁* to *q₂* the result is `{}`. On a bipartite graph this is always so for the bare shell.

| Option | Default | Values |
|---|---|---|
| `"RadiusDelta"` | `0` | *δ* for the band {*r*, *r* + *δ*}; {*δᵢₙ*, *δₒᵤₜ*} for {*r* − *δᵢₙ*, *r* + *δₒᵤₜ*} |

## Basic Examples

The angle at the centre between two farthest points of the circle of radius 3, on the square grid and on the square mesh, with the arc that measures it:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
    {qq = RandomInfraPoint[g, InfraShell[p, 3], 2, "PairwiseDistance" -> "Max", RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraArc[p, qq, "RadiusDelta" -> 1], p, qq},
      PlotLabel -> InfraAngle[g, {First[qq], p, Last[qq]}, "RadiusDelta" -> 1]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The angle is the length of the arc:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {qq = RandomInfraPoint[g, InfraShell[p, 3], 2, "PairwiseDistance" -> "Max", RandomSeeding -> 1]},
  InfraAngle[g, {First[qq], p, Last[qq]}, "RadiusDelta" -> 1] == InfraMeasurement[g, InfraArc[p, qq, "RadiusDelta" -> 1], "Length"]]
```

## Scope

Right, straight and full angles on the square grid, for the radii 2 to 6. They are *2r*, *4r* and *8r*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {pos = AssociationThread[VertexList[g], Round @ GraphEmbedding[g]]}, {at = AssociationThread[Values[pos], Keys[pos]]},
  Table[InfraAngle[g, {at[pos[p] + {r, 0}], p, at[pos[p] + q]}, "RadiusDelta" -> 1], {q, {{0, r}, {-r, 0}, {r, 0}}}, {r, 2, 6}]]
```

## Options

### RadiusDelta

On the grid the bare shell joins nothing, so the default band gives `{}`:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {qq = RandomInfraPoint[g, InfraShell[p, 3], 2, "PairwiseDistance" -> "Max", RandomSeeding -> 1]},
  Table[InfraAngle[g, {First[qq], p, Last[qq]}, "RadiusDelta" -> delta], {delta, {0, 1, {1, 1}}}]]
```

## Possible Issues

The angle grows with the radius. The right angle on the grid at the radii 2 to 6, divided by the radius, is the constant 2:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {pos = AssociationThread[VertexList[g], Round @ GraphEmbedding[g]]}, {at = AssociationThread[Values[pos], Keys[pos]]},
  Table[InfraAngle[g, {at[pos[p] + {r, 0}], p, at[pos[p] + {0, r}]}, "RadiusDelta" -> 1] / r, {r, 2, 6}]]
```
