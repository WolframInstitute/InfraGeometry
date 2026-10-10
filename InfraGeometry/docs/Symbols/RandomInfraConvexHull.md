---
Template: Symbol
Name: RandomInfraConvexHull
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraConvexHull
SeeAlso: [InfraConvexHull, InfraMeasurement, RandomInfraSegment]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraConvexHull]()[*g*, [InfraConvexHull]()[seeds, rounds]]</code> samples a sorted vertex set on graph *g*.

<code>[RandomInfraConvexHull]()[*g*, [InfraConvexHull]()[seeds, rounds], *count*]</code> requests `count` representatives. `All` enumerates the full pool; `UpTo[n]` returns at most *n*.

## Details & Options

`RandomInfraConvexHull[g, seeds, rounds, count]` uses the direct form. With rounds omitted, the direct form is singular; use `InfraConvexHull[seeds]` when supplying a count without rounds.

The sampler has the same token geometry as [InfraConvexHull](). An omitted or `Automatic` count returns one representative. An integer count requests exactly that many distinct representatives and returns `{}` when too few exist.

`"NextVertexFunction" -> Identity` selects deterministically. Default `All` does not advance random state. Seed an ordinary draw with `SeedRandom`.

See [Named construction samplers](../Tutorials/NamedConstructionSamplers.md) for bare overloads, carrier differences and compatibility spellings.
