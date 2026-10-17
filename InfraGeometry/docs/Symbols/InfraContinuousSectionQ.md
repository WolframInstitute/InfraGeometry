---
Template: Symbol
Name: InfraContinuousSectionQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraContinuousSectionQ
Keywords: [continuous section, partial section, adjacency preservation]
SeeAlso: [InfraSection, InfraSectionQ, InfraParallelSectionQ, RandomInfraSection, InfraFiberedGraphHighlight]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[InfraContinuousSectionQ]()[*fib*, [InfraSection]()[*s*]]</code> tests whether *s* is a section mapping every base edge between its keys to a total edge.

<code>[InfraContinuousSectionQ]()[*fib*, {*section1*, *section2*, ...}]</code> tests every section in a nonempty collection.

## Details & Options

- Only base edges with both endpoints in the section's domain are checked.
- The right-inverse condition checked by [InfraSectionQ]() is also required.
- An empty partial section is continuous. An empty collection returns [False]().
- Continuity concerns the total graph. [InfraParallelSectionQ]() imposes the additional condition specified by a chosen complete connection.
- [RandomInfraSection]() with `Properties -> {"Continuous"}` constructs sections of this class.

## Basic Examples

The two sheets of a product covering are continuous sections.

```wl
SeedRandom[7];
With[
  {fib = InfraFibration[GraphProduct[CycleGraph[4], Graph[{1, 2}, {}], "Cartesian"], First]},
  {sections = RandomInfraSection[fib, All, Properties -> {"Continuous"}]},
  {GraphicsRow[InfraFiberedGraphHighlight[fib, #] & /@ sections], InfraContinuousSectionQ[fib, sections]}]
```

Switching sheets across a base edge breaks continuity.

```wl
SeedRandom[7];
With[
  {fib = InfraFibration[Graph[{1, 2, 3, 4}, {UndirectedEdge[1, 3], UndirectedEdge[2, 4]}],
    <|1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b"|>]},
  {section = InfraSection[<|"a" -> 1, "b" -> 4|>]},
  {InfraFiberedGraphHighlight[fib, section], InfraSectionQ[fib, section], InfraContinuousSectionQ[fib, section]}]
```

## Possible Issues

Continuity on a partial domain does not imply that a continuous global extension exists. [RandomInfraSection]() returns `{}` when the requested extension class is empty.
