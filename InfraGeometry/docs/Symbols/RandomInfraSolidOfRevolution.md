---
Template: Symbol
Name: RandomInfraSolidOfRevolution
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraSolidOfRevolution
SeeAlso: [InfraSolidOfRevolution, InfraMeasurement, RandomInfraSegment]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraSolidOfRevolution]()[*g*, [InfraSolidOfRevolution]()[axis, profile]]</code> samples a sorted vertex set on graph *g*.

<code>[RandomInfraSolidOfRevolution]()[*g*, [InfraSolidOfRevolution]()[axis, profile], *count*]</code> requests `count` representatives. `All` enumerates the full pool; `UpTo[n]` returns at most *n*.

## Details & Options

`RandomInfraSolidOfRevolution[g, axis, profile, count]` uses the direct form. `Method` is a bare geometry option; use a rule inside the token for token geometry.

The sampler has the same token geometry as [InfraSolidOfRevolution](). An omitted or `Automatic` count returns one representative. An integer count requests exactly that many distinct representatives and returns `{}` when too few exist.

`"NextVertexFunction" -> Identity` selects deterministically. Default `All` does not advance random state. Seed an ordinary draw with `SeedRandom`.

See [Named construction samplers](../Tutorials/NamedConstructionSamplers.md) for bare overloads, carrier differences and compatibility spellings.
