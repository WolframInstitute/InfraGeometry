---
Template: Symbol
Name: RandomInfraQuadric
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraQuadric
SeeAlso: [InfraQuadric, InfraMeasurement, RandomInfraSegment]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraQuadric]()[*g*, [InfraQuadric]()[foci, c]]</code> samples a sorted vertex set on graph *g*.

<code>[RandomInfraQuadric]()[*g*, [InfraQuadric]()[foci, c], *count*]</code> requests `count` representatives. `All` enumerates the full pool; `UpTo[n]` returns at most *n*.

## Details & Options

`RandomInfraQuadric[g, foci, c, count]` uses the direct form.

The sampler has the same token geometry as [InfraQuadric](). An omitted or `Automatic` count returns one representative. An integer count requests exactly that many distinct representatives and returns `{}` when too few exist.

`"NextVertexFunction" -> Identity` selects deterministically. Default `All` does not advance random state. Seed an ordinary draw with `SeedRandom`.

See [Named construction samplers](../Tutorials/NamedConstructionSamplers.md) for bare overloads, carrier differences and compatibility spellings.
