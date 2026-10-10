---
Template: Symbol
Name: RandomInfraBall
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraBall
SeeAlso: [InfraBall, InfraMeasurement, RandomInfraSegment]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraBall]()[*g*, [InfraBall]()[c, r]]</code> samples a sorted vertex set on graph *g*.

<code>[RandomInfraBall]()[*g*, [InfraBall]()[c, r], *count*]</code> requests `count` representatives. `All` enumerates the full pool; `UpTo[n]` returns at most *n*.

## Details & Options

`RandomInfraBall[g, c, r, count]` uses the direct form.

The sampler has the same token geometry as [InfraBall](). An omitted or `Automatic` count returns one representative. An integer count requests exactly that many distinct representatives and returns `{}` when too few exist.

`"NextVertexFunction" -> Identity` selects deterministically. Default `All` does not advance random state. Seed an ordinary draw with `SeedRandom`.

See [Named construction samplers](../Tutorials/NamedConstructionSamplers.md) for bare overloads, carrier differences and compatibility spellings.
