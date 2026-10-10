---
Template: Symbol
Name: RandomInfraCircle
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraCircle
SeeAlso: [InfraCircle, InfraMeasurement, RandomInfraSegment]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraCircle]()[*g*, [InfraCircle]()[c, r]]</code> samples a cyclic vertex sequence on graph *g*.

<code>[RandomInfraCircle]()[*g*, [InfraCircle]()[c, r], *count*]</code> requests `count` representatives. `All` enumerates the full pool; `UpTo[n]` returns at most *n*.

## Details & Options

`RandomInfraCircle[g, c, r, count]` uses the direct form.

The sampler has the same token geometry as [InfraCircle](). An omitted or `Automatic` count returns one representative. An integer count requests exactly that many distinct representatives and returns `{}` when too few exist.

`"NextVertexFunction" -> Identity` selects deterministically. Default `All` does not advance random state. Seed an ordinary draw with `SeedRandom`.

See [Named construction samplers](../Tutorials/NamedConstructionSamplers.md) for bare overloads, carrier differences and compatibility spellings.
