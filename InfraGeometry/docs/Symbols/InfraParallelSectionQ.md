---
Template: Symbol
Name: InfraParallelSectionQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraParallelSectionQ
Keywords: [parallel section, connection, parallel transport, horizontal section]
SeeAlso: [InfraSection, InfraSectionQ, InfraContinuousSectionQ, InfraConnection, InfraConnectionQ, InfraParallelTransport, RandomInfraSection]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[InfraParallelSectionQ]()[*fib*, *connection*, [InfraSection]()[*s*]]</code> tests whether transport along every base edge in the domain of *s* carries its first value to its second.

<code>[InfraParallelSectionQ]()[*fib*, *connection*, {*section1*, *section2*, ...}]</code> tests every section in a nonempty collection.

## Details & Options

- The connection must satisfy [InfraConnectionQ](), which requires a perfect matching over each base edge.
- The section must satisfy [InfraSectionQ]().
- Only base edges with both endpoints among the section's keys are checked.
- A parallel section is continuous in the ambient total graph. A continuous section need not be parallel for the chosen connection.
- The empty partial section is parallel. An empty collection returns [False]().
- An invalid or incomplete connection leaves the call unevaluated.
- This predicate reads the specified connection and consumes no random draws.

## Basic Examples

The connection chooses one of the available lifts. A section following another lift remains continuous but is not parallel.

```wl
SeedRandom[7];
With[
  {fib = InfraFibration[Graph[{1, 2, 3, 4}, {UndirectedEdge[1, 3], UndirectedEdge[1, 4], UndirectedEdge[2, 3], UndirectedEdge[2, 4]}],
    <|1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b"|>]},
  {connection = InfraConnection[{UndirectedEdge[1, 3], UndirectedEdge[2, 4]}], section = InfraSection[<|"a" -> 1, "b" -> 4|>]},
  {InfraFiberedGraphHighlight[fib, {connection, section}],
    InfraContinuousSectionQ[fib, section], InfraParallelSectionQ[fib, connection, section]}]
```

A section that follows the matching is parallel.

```wl
SeedRandom[7];
With[
  {fib = InfraFibration[Graph[{1, 2, 3, 4}, {UndirectedEdge[1, 3], UndirectedEdge[1, 4], UndirectedEdge[2, 3], UndirectedEdge[2, 4]}],
    <|1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b"|>]},
  {connection = InfraConnection[{UndirectedEdge[1, 3], UndirectedEdge[2, 4]}], section = InfraSection[<|"a" -> 1, "b" -> 3|>]},
  {InfraFiberedGraphHighlight[fib, {connection, section}], InfraParallelSectionQ[fib, connection, section]}]
```
