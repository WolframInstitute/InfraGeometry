---
Template: Symbol
Name: InfraComparisonAngle
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraComparisonAngle
Keywords: [angle, Alexandrov, comparison triangle, curvature, experimental]
SeeAlso: [InfraAngle, InfraScalarProduct, InfraPerpendicularQ]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

`InfraComparisonAngle[g, {q1, p, q2}]` gives the angle at `p` of the Euclidean triangle with the same three graph distances.

`InfraComparisonAngle[g, {q1, p, q2}, "Curvature" -> k]` uses the model plane of constant curvature `k`.

## Details & Options

This is an experimental Riemannian comparison observable. It uses only the three side lengths. It does not assert that the graph has a tangent angle or satisfies a curvature bound.

Write `a = d(q1, q2)`, `b = d(p, q1)` and `c = d(p, q2)`. At `k = 0` the result is `ArcCos[(b^2 + c^2 - a^2)/(2 b c)]`, in radians. Positive curvature uses the spherical law of cosines and negative curvature the hyperbolic law of cosines. The model comparison triangle must exist and both arms must have positive length.

The option `"Curvature"` defaults to `0`. These are the formulas formerly selected by `InfraAngle[..., Method -> "Alexandrov"]`.

## Basic Examples

The unit equilateral comparison triangle has angle Pi/3.

```wl
InfraComparisonAngle[CompleteGraph[3], {2, 1, 3}]
```

A geodesic through its middle vertex has flat comparison angle Pi.

```wl
InfraComparisonAngle[PathGraph[Range[3]], {1, 2, 3}]
```
