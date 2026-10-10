---
Template: Symbol
Name: InfraEllipse
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraEllipse
---

## Usage

`InfraEllipse[{p, q}, band]` is an inert family of shortest separating cycles in a distance-sum level band.

## Details & Options

[RandomInfraEllipse]() evaluates the family on a graph.
A scalar band fixes one distance sum; a two-element band gives lower and upper bounds.
One representative is a directed cycle Graph. This head does not wrap a List of realized cycles.
Properties follow the existing ellipse sampler.

## Basic Examples

An antipodal distance-sum cycle, without the separating requirement.

```wl
SeedRandom[ 71 ]; RandomInfraEllipse[ CycleGraph[ 4 ], InfraEllipse[ { 1, 3 }, 2, Properties -> { } ], All ]
```
