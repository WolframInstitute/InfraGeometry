---
Template: Symbol
Name: InfraComparisonAngle
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraComparisonAngle
Keywords: [angle, Alexandrov, comparison triangle, curvature, law of cosines]
SeeAlso: [InfraAngle, InfraScalarProduct, InfraPerpendicularQ]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

<code>[InfraComparisonAngle]()[*g*, {*q1*, *p*, *q2*}]</code> gives the angle at *p* of the Euclidean triangle whose sides are the graph distances between *q1*, *p* and *q2*.

## Details & Options

With *a = d(q1, q2)*, *b = d(p, q1)* and *c = d(p, q2)*, the angle is *θ = arccos((b² + c² − a²) / (2bc))*, in radians.

This is the Alexandrov comparison angle. It uses the three distances only and needs no tangent space.

`"Curvature" -> k` takes the triangle in the model plane of constant curvature *k*: the spherical law of cosines for *k* > 0, the hyperbolic one for *k* < 0. For the same three sides a larger *k* gives a larger angle.

On the square grid the distance is the ℓ¹ distance. Two vertices on the two axes at distance *r* from *p* are *2r* apart, so their comparison angle at *p* is π, not π/2.

Both arms must have positive length. For *k* > 0 the triangle exists only when its perimeter is at most *2π/√k*.

| Option | Default | Values |
|---|---|---|
| `"Curvature"` | 0 | a real number *k* |

## Basic Examples

The comparison angle at the centre between a fixed vertex of the circle of radius 3 and each vertex of that circle, drawn as the size of the vertex:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
    {q = RandomInfraPoint[g, InfraShell[p, 3], RandomSeeding -> 1]},
    {circle = Keys @ InfraMeasurement[g, InfraShell[p, 3], "VertexDensity"]},
    InfraSubstrateHighlight[g, {AssociationMap[v |-> N @ InfraComparisonAngle[g, {q, p, v}], circle], q, p}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

On the grid the angle between the two axes is π. The vertices 2 steps right of and 2 steps above the centre:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  InfraSubstrateHighlight[g, {{65, 47}, 45}, PlotLabel -> InfraComparisonAngle[g, {65, 45, 47}],
    ImageSize -> Medium]]
```

The triangle graph is an equilateral triangle, and a path is straight:

```wl
{InfraComparisonAngle[CompleteGraph[3], {2, 1, 3}], InfraComparisonAngle[PathGraph[Range[3]], {1, 2, 3}]}
```

## Options

### Curvature

The same triangle at the centre of the sphere mesh read in the hyperbolic, the flat and the spherical model plane:

```wl
With[{g = InfraSubstrate["SphereMeshGraph", "Medium", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {q1 = RandomInfraPoint[g, InfraShell[p, 3], RandomSeeding -> 1]},
  {q2 = RandomInfraPoint[g, InfraShell[p, 3], RandomSeeding -> 3]},
  Table[N @ InfraComparisonAngle[g, {q1, p, q2}, "Curvature" -> k], {k, {-0.2, 0, 0.2}}]]
```

## Properties and Relations

The angle and the scalar product carry the same information: *⟨u, v⟩ₚ = d(p, u) d(p, v) cos θ*:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {p = First @ GraphCenter[g]},
  {u = RandomInfraPoint[g, InfraShell[p, 3], RandomSeeding -> 1]},
  {v = RandomInfraPoint[g, InfraShell[p, 4], RandomSeeding -> 2]},
  InfraScalarProduct[g, p, u, v] == 3 * 4 * Cos[InfraComparisonAngle[g, {u, p, v}]]]
```

## Possible Issues

A triangle too large for the spherical model has no comparison triangle, and the angle is complex. Three vertices of the 9-cycle, pairwise 3 apart, at curvature 1:

```wl
N @ InfraComparisonAngle[CycleGraph[9], {4, 1, 7}, "Curvature" -> 1]
```
