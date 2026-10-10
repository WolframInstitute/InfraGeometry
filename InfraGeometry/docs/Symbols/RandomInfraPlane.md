---
Template: Symbol
Name: RandomInfraPlane
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraPlane
SeeAlso: [InfraPlane, InfraMeasurement, RandomInfraSegment]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraPlane]()[*g*, [InfraPlane]()[p, q]]</code> samples an inclusion-minimal separating vertex set on graph *g*.

<code>[RandomInfraPlane]()[*g*, [InfraPlane]()[p, q], *count*]</code> requests `count` representatives. `All` enumerates the full pool; `UpTo[n]` returns at most *n*.

## Details & Options

`RandomInfraPlane[g, p, q, count]` uses the direct form. The omitted window is `{0,0}`. Plane sampling fixes `Properties -> {"Separating"}`; legacy rules inside the token are accepted and ignored.

The sampler has the same token geometry as [InfraPlane](). An omitted or `Automatic` count returns one representative. An integer count requests exactly that many distinct representatives and returns `{}` when too few exist.

`"NextVertexFunction" -> Identity` selects deterministically. Default `All` does not advance random state. Seed an ordinary draw with `SeedRandom`.

See [Named construction samplers](../Tutorials/NamedConstructionSamplers.md) for bare overloads, carrier differences and compatibility spellings.
