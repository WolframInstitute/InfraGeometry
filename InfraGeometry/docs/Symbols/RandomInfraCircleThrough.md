---
Template: Symbol
Name: RandomInfraCircleThrough
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraCircleThrough
Keywords: [circle, prescribed points, sampling, uniform, DAG]
SeeAlso: [InfraCircleThrough, InfraCircle, RandomInfraCircle, InfraMeasurement]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

`RandomInfraCircleThrough[g, token]` gives one uniformly sampled circle from the family denoted by `token`.

`RandomInfraCircleThrough[g, token, count]` requests a list of distinct circles.

`RandomInfraCircleThrough[g, points, InfraCircle[c, {r, s}], count]` is the direct form.

`RandomInfraCircleThrough[carrier, count]` samples a saved native carrier Graph returned by `InfraMeasurement[g, token, "Graph"]`.

## Details & Options

The token is `InfraCircleThrough[points, InfraCircle[c, {r, s}]]`. Every requested point and the simplicity and separation constraints are imposed before minimizing circumference. All distinct minimum circles survive, with one representative per rotation/reversal class.

Omitted or `Automatic` count returns one cyclic vertex list. An integer returns exactly that many distinct representatives, or `{}` on shortage. `UpTo[n]` returns at most `n`, and `All` enumerates the complete family. A valid empty family gives `{}`.

The option `"NextVertexFunction" -> Identity` chooses the first ranks deterministically. The default `Automatic` samples distinct ranks uniformly without replacement. `All` is deterministic. `RandomSeeding -> Automatic` (default) seeds each call afresh, independently of `SeedRandom`; an integer or string gives a reproducible draw, and `Inherited` a local snapshot of the current state. The outer random state is restored afterward, as with [RandomInstance](https://reference.wolfram.com/language/ref/RandomInstance.html).

Integer suffix counts support rank decoding and sampling without expanding the full family. Saving the native carrier lets repeated samples reuse the compiled graph. `All` expands every member.

## Basic Examples

Choose two of the three minimum circles through four prescribed vertices.

```wl
SeedRandom[1];
With[
  {g = CompleteGraph[5]},
  {circle = InfraCircleThrough[{2, 3, 4, 5}, InfraCircle[1, {1, 1}]]},
  RandomInfraCircleThrough[g, circle, 2, RandomSeeding -> 1]]
```

Reuse the native carrier for repeated sampling.

```wl
SeedRandom[1];
With[
  {g = CompleteGraph[5]},
  {circle = InfraCircleThrough[{2, 3, 4, 5}, InfraCircle[1, {1, 1}]]},
  {carrier = InfraMeasurement[g, circle, "Graph"]},
  {RandomInfraCircleThrough[carrier, RandomSeeding -> 1], RandomInfraCircleThrough[carrier, All]}]
```

## Options

### RandomSeeding

A fixed seed reproduces the draw, whatever state `SeedRandom` has set:

```wl
Table[SeedRandom[k]; RandomInfraCircleThrough[GridGraph[{7, 7}], InfraCircleThrough[{11}, InfraCircle[25, {1, 3}]], RandomSeeding -> 7], {k, 2}]
```
