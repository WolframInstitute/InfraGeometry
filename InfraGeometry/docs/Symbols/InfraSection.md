---
Template: Symbol
Name: InfraSection
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSection
Keywords: [section, partial section, inert map, projection]
SeeAlso: [InfraSectionQ, InfraContinuousSectionQ, InfraParallelSectionQ, RandomInfraSection, InfraFiberedGraph, InfraFiberedGraphHighlight]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraSection]()[*s*]</code> describes a section by an association from base vertices to total vertices; it carries no graph.

## Details & Options

- The head is inert. [InfraSectionQ]() checks the right-inverse condition in a specified fibered graph.
- The keys of *s* give its domain, which may be a subset of the reconstructed base.
- [InfraContinuousSectionQ]() checks adjacency preservation. [InfraParallelSectionQ]() checks compatibility with a chosen complete connection.
- `InfraSection[<||>]` is the empty partial section.
- [RandomInfraSection]() constructs sections on a domain or extends a prescribed section without changing its values.
- `Properties -> {"Continuous"}` selects the continuous class explicitly in every sampler call form.
- Vertices and association keys are literal expressions, including list-valued labels.

## Basic Examples

A partial section chooses values in two fibers.

```wl
SeedRandom[7];
With[
  {fib = RandomInfraFiberedGraph[CycleGraph[6], "VerticalVertexCount" -> { 3 },
    "VerticalEdgeCount" -> { 0 }, "HorizontalEdgeCount" -> All, RandomSeeding -> 7]},
  {partial = RandomInfraSection[fib, {1, 3}, RandomSeeding -> 7]},
  InfraFiberedGraphHighlight[fib, partial]]
```

The same inert section is read in the context of its fibered graph.

```wl
SeedRandom[7];
With[
  {fib = InfraFiberedGraph[Graph[{1, 2, 3, 4}, {UndirectedEdge[1, 3], UndirectedEdge[2, 4]}],
    <|1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b"|>]},
  {section = InfraSection[<|"a" -> 1, "b" -> 3|>]},
  {InfraFiberedGraphHighlight[fib, section], InfraSectionQ[fib, section], InfraContinuousSectionQ[fib, section]}]
```
