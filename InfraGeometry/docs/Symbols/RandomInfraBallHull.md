---
Template: Symbol
Name: RandomInfraBallHull
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraBallHull
SeeAlso: [InfraBallHull, InfraMeasurement, RandomInfraSegment]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraBallHull]()[*g*, [InfraBallHull]()[seeds, band]]</code> samples a sorted vertex set on graph *g*.

<code>[RandomInfraBallHull]()[*g*, [InfraBallHull]()[seeds, band], *count*]</code> requests `count` representatives. `All` enumerates the full pool; `UpTo[n]` returns at most *n*.

## Details & Options

`RandomInfraBallHull[g, seeds, band, count]` uses the direct form. With the band omitted, the direct form is singular; use `InfraBallHull[seeds]` when supplying a count without a band.

The sampler has the same token geometry as [InfraBallHull](). An omitted or `Automatic` count returns one representative. An integer count requests exactly that many distinct representatives and returns `{}` when too few exist.

`"NextVertexFunction" -> Identity` selects deterministically. Default `All` does not advance random state. Seed an ordinary draw with `SeedRandom`.

See [Named construction samplers](../Tutorials/NamedConstructionSamplers.md) for bare overloads, carrier differences and compatibility spellings.
