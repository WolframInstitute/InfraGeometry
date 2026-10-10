---
Template: Symbol
Name: InfraPlane
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraPlane
---

## Usage

`InfraPlane[p, q]` is the inert family of inclusion-minimal separating vertex sets in the zero distance-difference slab.

`InfraPlane[p, q, {lo, hi}]` uses the stated distance-difference window.

## Details & Options

[RandomInfraPlane]() samples the family on a graph, fixing the separating property.
One representative is a vertex set, not a payload wrapper.
The exact finite equidistant locus is [InfraPerpendicularBisector](), which need not separate the anchors.
These constructions can therefore have different empty/nonempty answers.

## Basic Examples

The middle point separates the endpoints.

```wl
SeedRandom[ 71 ]; With[ { graph = PathGraph[ Range[ 3 ] ] },
  RandomInfraPlane[ graph, InfraPlane[ 1, 3 ], All ] ]
```
