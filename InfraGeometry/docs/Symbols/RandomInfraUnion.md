---
Template: Symbol
Name: RandomInfraUnion
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraUnion
SeeAlso: [InfraUnion, InfraMeasurement, RandomInfraSegment]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraUnion]()[*g*, [InfraUnion]()[obj1, obj2]]</code> samples one point from the union of complete operand supports on graph *g*.

<code>[RandomInfraUnion]()[*g*, [InfraUnion]()[obj1, obj2], *count*]</code> requests `count` representatives. `All` enumerates the full pool; `UpTo[n]` returns at most *n*.

## Details & Options

`RandomInfraUnion[g, {obj1, obj2}, count]` uses the direct operand-list form.

The sampler has the same token geometry as [InfraUnion](). An omitted or `Automatic` count returns one representative. An integer count requests exactly that many distinct representatives and returns `{}` when too few exist.

`"NextVertexFunction" -> Identity` selects deterministically. Default `All` does not advance random state. Seed an ordinary draw with `SeedRandom`.

See [Named construction samplers](../Tutorials/NamedConstructionSamplers.md) for bare overloads, carrier differences and compatibility spellings.
