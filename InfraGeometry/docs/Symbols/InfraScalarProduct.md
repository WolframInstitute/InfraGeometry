---
Template: Symbol
Name: InfraScalarProduct
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraScalarProduct
Keywords: [scalar product, inner product, polarization, comparison angle, base point, tangent vector]
SeeAlso: [InfraComparisonAngle, FindInfraLinearCombination, InfraMetricTensor]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

<code>[InfraScalarProduct]()[*g*, *o*, *u*, *v*]</code> gives the scalar product *⟨u, v⟩ₒ* of the vertices *u* and *v* seen from the base point *o*.

## Details & Options

The vertices are read as vectors from *o*. The default is the polar form *⟨u, v⟩ₒ = (d(o, u)² + d(o, v)² − d(u, v)²) / 2*, equal to *d(o, u) d(o, v) cos θ* with *θ* the [InfraComparisonAngle]() at *o*.

It is symmetric, and *⟨u, u⟩ₒ = d(o, u)²*. It is not bilinear: a graph has no addition of vertices, and its triangles need not be flat.

On the square grid the distance is ℓ¹. Two vertices at distance *a* and *b* on the two axes give *−ab*, the value of two opposite vectors, not 0.

`Method` chooses the construction:

| Option | Default | Values |
|---|---|---|
| [Method]() | `"Alexandrov"` | `"Alexandrov"`, the polar form; `{"Alexandrov", "Curvature" -> k}`, *d(o, u) d(o, v) cos θ* with *θ* the comparison angle in the model plane of curvature *k*; `"Parallelogram"`, the polarization *(‖u + v‖² − ‖u − v‖²)/4* over the realisations of *u + v* and *u − v* by [FindInfraLinearCombination]() |

The `"Parallelogram"` value is a list when the realisations give several values.

## Basic Examples

The vertices of the circle of radius 3 about the centre with a positive scalar product with a fixed vertex *u* of it, and those with a negative one:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {o = First @ GraphCenter[g]},
    {u = RandomInfraPoint[g, InfraShell[o, 3], RandomSeeding -> 1]},
    {circle = Keys @ InfraMeasurement[g, InfraShell[o, 3], "VertexDensity"]},
    InfraSubstrateHighlight[g, {Select[circle, InfraScalarProduct[g, o, u, #] > 0 &],
      Select[circle, InfraScalarProduct[g, o, u, #] < 0 &], u, o}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

On the grid two axis vectors of length 2 have the same scalar product, −4, whether they are perpendicular or opposite. From the centre 45, the vertex 65 lies 2 steps along one axis, 47 2 steps along the other, and 25 2 steps the opposite way from 65:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, Table[InfraScalarProduct[g, 45, 65, v], {v, {47, 25}}]]
```

The scalar product of a vertex with itself is the square of its distance:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {o = First @ GraphCenter[g]},
  {u = RandomInfraPoint[g, InfraShell[o, 4], RandomSeeding -> 1]},
  InfraScalarProduct[g, o, u, u]]
```

## Options

### Method

The polar form and the polarization of the realised parallelogram for two perpendicular axis vectors of the grid. The polarization takes several values, one of them 0:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  Table[InfraScalarProduct[g, 45, 65, 47, Method -> m], {m, {"Alexandrov", "Parallelogram"}}]]
```

On the sphere mesh, the comparison angle in a positively curved model plane is larger, so the scalar product is smaller:

```wl
With[{g = InfraSubstrate["SphereMeshGraph", "Medium", "KeepCoordinates" -> True]}, {o = First @ GraphCenter[g]},
  {u = RandomInfraPoint[g, InfraShell[o, 3], RandomSeeding -> 1]},
  {v = RandomInfraPoint[g, InfraShell[o, 3], RandomSeeding -> 3]},
  Table[N @ InfraScalarProduct[g, o, u, v, Method -> {"Alexandrov", "Curvature" -> k}], {k, {0, 0.2}}]]
```

## Properties and Relations

The polar form is *d(o, u) d(o, v) cos θ*, with *θ* the comparison angle:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {o = First @ GraphCenter[g]},
  {u = RandomInfraPoint[g, InfraShell[o, 3], RandomSeeding -> 1]},
  {v = RandomInfraPoint[g, InfraShell[o, 4], RandomSeeding -> 2]},
  InfraScalarProduct[g, o, u, v] == 3 * 4 * Cos[InfraComparisonAngle[g, {u, o, v}]]]
```
