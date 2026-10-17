---
Template: Symbol
Name: FindInfraSection
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraSection
Keywords: [continuous section, compatibility, global section]
SeeAlso: [RandomInfraSection, InfraSection, InfraContinuousSectionQ, InfraParallelSectionQ]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[FindInfraSection]()[*fib*, *n*]</code> gives *n* continuous sections over the whole reconstructed base, in deterministic order.

<code>[FindInfraSection]()[*fib*, [UpTo]()[*n*]]</code> gives at most *n*, and <code>[FindInfraSection]()[*fib*, [All]()]</code> gives every continuous section.

## Details & Options

- This is a compatibility spelling of `RandomInfraSection[fib, count, Properties -> {"Continuous"}, "NextVertexFunction" -> Identity]`.
- New code uses [RandomInfraSection]() with the explicit property and candidate-order options.
- The count is required. An exact nonnegative count returns `{}` on shortage. Every successful counted result is a list of distinct [InfraSection]() objects.
- The operation consumes no random draws.
- Partial-domain sampling and seed extension are provided by [RandomInfraSection]().
- [All]() can be exponential in the number of base vertices.

## Basic Examples

The old and current call forms give the same two sheets of this product covering.

```wl
SeedRandom[7];
With[
  {fib = InfraFibration[GraphProduct[CycleGraph[4], Graph[{1, 2}, {}], "Cartesian"], First]},
  {sections = FindInfraSection[fib, All]},
  {GraphicsRow[InfraFiberedGraphHighlight[fib, #] & /@ sections],
    sections === RandomInfraSection[fib, All, Properties -> {"Continuous"}, "NextVertexFunction" -> Identity]}]
```

The connected double covering has no global continuous section.

```wl
SeedRandom[7];
With[
  {fib = InfraFibration[CycleGraph[8], i |-> Mod[i, 4, 1]]},
  {InfraFiberedGraphHighlight[fib], FindInfraSection[fib, All]}]
```
