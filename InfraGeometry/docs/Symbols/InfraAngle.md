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

`InfraAngle[g, {q1, p, q2}]` gives `InfraMeasurement[g, InfraArc[p, {q1, q2}], "Length"]`.

`InfraAngle[g, {q1, p, q2}, "RadiusDelta" -> delta]` uses the widened arc band.

## Details & Options

This is the length of the arc about `p` from `q1` to `q2`, measured in graph edges. The arc definition and its supported domain are those of [InfraArc](). All shortest arcs of the chosen band have the same length.

The default `"RadiusDelta" -> 0` uses the exact distance shell of `q1`. A scalar delta widens the band outward; `{deltaIn, deltaOut}` widens it in both directions. A thin shell can have no connecting path, especially on a bipartite graph. The result then follows the arc measurement's empty-family behavior.

The value has no radius or circumference normalization. A convention turning it into a dimensionless angle remains unsettled; this function makes no radian claim. A normalization involving a containing circle requires a specified circle family and rules for its possible alternatives.

The former punched-ball detour divided by radius is a different observable. Comparison-triangle angles are now [InfraComparisonAngle]() in the Riemannian branch.

## Basic Examples

An arc of length 6 at radius 3. The result is its edge length.

```wl
With[
  {g = CycleGraph[12]},
  {arc = InfraArc[1, {4, 10}, "RadiusDelta" -> 3]},
  {InfraSubstrateHighlight[g, {arc, 1, 4, 10}],
   InfraAngle[g, {4, 1, 10}, "RadiusDelta" -> 3],
   InfraMeasurement[g, arc, "Length"]}]
```
