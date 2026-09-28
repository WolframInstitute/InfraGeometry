---
Template: Symbol
Name: FindInfraEquidistantSet
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraEquidistantSet
---

## Usage

`FindInfraEquidistantSet[graph, {p1, ..., pn}]` returns the equidistant set {v : d(p1, v) == ... == d(pn, v)} as a sorted vertex list, the intersection of the n-1 consecutive perpendicular bisectors.

`FindInfraEquidistantSet[graph, {p1, ..., pn}, {lo, hi}]` thickens each consecutive bisector to the slab lo <= d(p_i, v) - d(p_{i+1}, v) <= hi.
