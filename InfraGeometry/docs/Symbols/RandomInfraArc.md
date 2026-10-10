---
Template: Symbol
Name: RandomInfraArc
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraArc
SeeAlso: [InfraArc, InfraMeasurement, RandomInfraSegment]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraArc]()[*g*, [InfraArc]()[c, {p, q}]]</code> samples an ordered vertex sequence on graph *g*.

<code>[RandomInfraArc]()[*g*, [InfraArc]()[c, {p, q}], *count*]</code> requests `count` representatives. `All` enumerates the full pool; `UpTo[n]` returns at most *n*.

## Details & Options

`RandomInfraArc[g, c, {p, q}, count]` uses the direct form.

The sampler has the same token geometry as [InfraArc](). An omitted or `Automatic` count returns one representative. An integer count requests exactly that many distinct representatives and returns `{}` when too few exist.

`"NextVertexFunction" -> Identity` selects deterministically. Default `All` does not advance random state. Seed an ordinary draw with `SeedRandom`.

See [Named construction samplers](../Tutorials/NamedConstructionSamplers.md) for bare overloads, carrier differences and compatibility spellings.
