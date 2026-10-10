---
Template: Symbol
Name: RandomInfraIntersection
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraIntersection
SeeAlso: [InfraIntersection, InfraMeasurement, RandomInfraSegment]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraIntersection]()[*g*, [InfraIntersection]()[obj1, obj2]]</code> samples one point from the intersection of complete operand supports on graph *g*.

<code>[RandomInfraIntersection]()[*g*, [InfraIntersection]()[obj1, obj2], *count*]</code> requests `count` representatives. `All` enumerates the full pool; `UpTo[n]` returns at most *n*.

## Details & Options

`RandomInfraIntersection[g, {obj1, obj2}, count]` uses the direct operand-list form.

The sampler has the same token geometry as [InfraIntersection](). An omitted or `Automatic` count returns one representative. An integer count requests exactly that many distinct representatives and returns `{}` when too few exist.

`"NextVertexFunction" -> Identity` selects deterministically. Default `All` does not advance random state. Seed an ordinary draw with `SeedRandom`.

See [Named construction samplers](../Tutorials/NamedConstructionSamplers.md) for bare overloads, carrier differences and compatibility spellings.
