---
Template: Symbol
Name: InfraSectionQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSectionQ
Keywords: [section, partial section, fibration, projection]
SeeAlso: [InfraSection, InfraContinuousSectionQ, InfraParallelSectionQ, RandomInfraSection, InfraProjection]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraSectionQ]()[*fib*, [InfraSection]()[*s*]]</code> tests whether every value of the association *s* lies over its key.

<code>[InfraSectionQ]()[*fib*, {*section1*, *section2*, ...}]</code> tests whether every section in a nonempty collection satisfies this condition.

## Details & Options

- The keys of *s* specify its domain. They need not cover the whole reconstructed base.
- The right-inverse condition is `projection[s[p]] == p` on that domain, with literal association keys.
- `InfraSection[<||>]` is a valid empty partial section.
- An empty collection returns [False](). It is distinct from one empty section.
- Undecided predicates in a collection remain as a conjunction. Malformed objects and unsupported fibered data remain unevaluated.

## Basic Examples

A section picks one vertex in each selected fiber.

```wl
SeedRandom[7];
With[
  {fib = InfraFiberedGraph[Graph[{1, 2, 3, 4}, {UndirectedEdge[1, 3], UndirectedEdge[2, 4]}],
    <|1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b"|>]},
  {section = RandomInfraSection[fib]},
  {InfraFiberedGraphHighlight[fib, section], InfraSectionQ[fib, section]}]
```

The projection distinguishes a valid partial section from a value in the wrong fiber.

```wl
SeedRandom[7];
With[
  {fib = InfraFiberedGraph[PathGraph[{1, 2}], Identity]},
  InfraSectionQ[fib, #] & /@ {InfraSection[<|1 -> 1|>], InfraSection[<|1 -> 2|>], InfraSection[<||>]}]
```
