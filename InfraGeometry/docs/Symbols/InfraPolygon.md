---
Template: Symbol
Name: InfraPolygon
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraPolygon
---

## Usage

`InfraPolygon[{v1, ..., vn}]` inside InfraScene is the closed geodesic chain through the given corners; `InfraPolygon[pool, n]` is the n-gon search over a pool. FindInfraPolygon is the search.

## Details & Options

A polygon itself is the List of its sides, one directed path graph each, consecutive sides sharing a corner. Its perimeter is the total edge count of the sides.
