---
Template: Symbol
Name: RandomInfraDeformation
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraDeformation
Keywords: [deformation, uniform sampling, simple path, distinct paths, random seed, enumeration]
SeeAlso: [InfraDeformation, FindInfraDeformation, InfraMeasurement, InfraMemberQ, RandomInfraWalk]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[RandomInfraDeformation]()[*g*, *family*]</code> gives one uniformly sampled vertex-list path from the [InfraDeformation]() family on *g*.

<code>[RandomInfraDeformation]()[*g*, *family*, *n*]</code> gives *n* distinct paths; *n* can be `UpTo[n]` or `All`.

## Details & Options

Every member is a simple path with the reference's ordered endpoints, within its tube and excess-length bounds. Sampling a member does not certify homotopy to the reference; use [FindInfraDeformation]() for a move certificate.

Without a count the result is one vertex list, or `{}` when the family is empty. An integer count gives exactly that many distinct members, or `{}` if fewer exist. `UpTo[n]` gives as many as available up to *n*. `All` enumerates every member in a deterministic order.

| Option | Default | Meaning |
|---|---|---|
| `"NextVertexFunction"` | `Automatic` | uniformly sample distinct members; `Identity` takes members in deterministic order |
| [RandomSeeding]() | `Automatic` | an integer or string for reproducibility; `Inherited` uses the ambient random state |

Uniformity is over complete paths. The sampler counts suffix paths in the family graph, samples distinct integer ranks uniformly without replacement, and decodes the selected ranks. It does not choose each next substrate vertex uniformly.

Exact counting precedes sampling; construction is bounded by the family's `"MaxStates"` option. If that construction is inconclusive, the sampling call remains unevaluated. A larger count does not relax the family constraints.

`All` may have exponentially many results. Use <code>[InfraMeasurement]()[*g*, *family*, "Cardinality"]</code> when only the count is needed.

## Basic Examples

Sample two distinct simple paths between two vertices of a complete graph:

```wl
SeedRandom[1];
With[{g = CompleteGraph[4]},
  RandomInfraDeformation[g, InfraDeformation[{1, 2}, UpTo[2]], 2, RandomSeeding -> 1]]
```

Enumerate the edge and the longer route around a square:

```wl
SeedRandom[1];
With[{g = CycleGraph[4]},
  RandomInfraDeformation[g, InfraDeformation[{1, 2}, UpTo[2]], All, RandomSeeding -> 1]]
```

## Options

### NextVertexFunction

Take the first two members in deterministic order:

```wl
SeedRandom[1];
With[{g = CompleteGraph[4]},
  RandomInfraDeformation[g, InfraDeformation[{1, 2}, UpTo[2]], 2,
    "NextVertexFunction" -> Identity, RandomSeeding -> 1]]
```

## Properties and Relations

Every sampled path is a member of the specified family:

```wl
SeedRandom[1];
With[{g = CompleteGraph[4]}, {family = InfraDeformation[{1, 2}, UpTo[2]]},
  AllTrue[RandomInfraDeformation[g, family, 3, RandomSeeding -> 1], InfraMemberQ[g, family, #] &]]
```
