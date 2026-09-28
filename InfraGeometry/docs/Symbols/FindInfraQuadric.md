---
Template: Symbol
Name: FindInfraQuadric
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraQuadric
---

## Usage

`FindInfraQuadric[graph, {p1, ..., pk}, c]` returns InfraObject[{ v : sum_i d(p_i, v) <= c }], the solid ellipsoid interior with foci p_i.

`FindInfraQuadric[graph, foci, {cMin, cMax}]` returns the band { v : cMin <= sum_i d(p_i, v) <= cMax }.

`FindInfraQuadric[graph, foci, c, weights]` uses the weighted signed-distance sum sum_i w_i d(p_i, v); weights {1, -1} give a hyperboloid (one branch via scalar c, two-sided via symmetric band {-c, c}).

## Details & Options

Foci accept bare vertices or InfraPoint wrappers (multi-realisation reduced to first).
