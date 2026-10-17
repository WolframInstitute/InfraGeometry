---
Template: Symbol
Name: RandomInfraSection
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraSection
Keywords: [section, partial section, section extension, continuous section, sampling]
SeeAlso: [InfraSection, InfraSectionQ, InfraContinuousSectionQ, InfraParallelSectionQ, RandomInfraFibration, RandomInfraConnection, InfraFiberedGraphHighlight]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[RandomInfraSection]()[*fib*]</code> gives one [InfraSection]() over the whole reconstructed base of *fib*.

<code>[RandomInfraSection]()[*fib*, *domain*]</code> gives a section over the list of base vertices *domain*.

<code>[RandomInfraSection]()[*fib*, *partial*]</code> extends the [InfraSection]() *partial* over the whole base, preserving every prescribed binding.

<code>[RandomInfraSection]()[*fib*, *specification*, *count*]</code> requests several sections; *specification* may be omitted.

## Details & Options

- The default `Properties -> {}` selects set-theoretic sections on every call form.
- `Properties -> {"Continuous"}` requires adjacency preservation on the induced base subgraph of the target domain.
- A seed must be a valid partial section. A valid discontinuous seed has no continuous extension, but still has set-theoretic extensions.
- A domain is a list of literal base vertices. A seed is wrapped in [InfraSection](), so these call forms are distinct.
- An omitted count or [Automatic]() returns one section directly, or `{}` if none is found.
- A nonnegative integer *n* returns exactly *n* distinct sections, or `{}` on shortage. [UpTo]()[*n*] returns at most *n*. [All]() returns the complete finite class.
- `"NextVertexFunction" -> Automatic` uses random candidate order for bounded searches. [SeedRandom]() controls the ambient random stream.
- `"NextVertexFunction" -> Identity` is deterministic. [All]() with default ordering is also deterministic and consumes no sampler random draws.
- [RandomSample]() randomizes candidate order with backtracking. [RandomChoice]() pursues one route without backtracking and is unsupported with [All]().
- A callback receives the candidate total vertices of the next fiber. It may return one literal candidate or a duplicate-free list of candidates in the desired order. Returning a subset prunes the search.
- A list that is itself a candidate vertex is interpreted as that single vertex. Otherwise a returned list specifies the candidate order.
- Bounded requests stop after enough sections are found. Randomized search order does not imply uniform sampling over continuous sections or extensions.
- `{}` denotes no result. The unique section over an empty domain is `InfraSection[<||>]`.
- Unsupported options, data and callback results leave the call unevaluated.

| Option | Default | Meaning |
|---|---|---|
| [Properties]() | `{}` | Set-theoretic sections, or `{"Continuous"}` for adjacency-preserving sections. |
| `"NextVertexFunction"` | [Automatic]() | Candidate order or selection at each fiber. |

## Basic Examples

Choose values in two fibers and extend them continuously across the whole cycle.

```wl
SeedRandom[7];
With[
  {fib = RandomInfraFibration[CycleGraph[6], "VerticalVertices" -> 3,
    "VerticalEdges" -> 0, "HorizontalEdgesDensity" -> All]},
  {partial = RandomInfraSection[fib, {1, 3}]},
  {section = RandomInfraSection[fib, partial, Properties -> {"Continuous"}]},
  InfraFiberedGraphHighlight[fib, {partial, section}]]
```

The product covering has two continuous sections, one on each sheet.

```wl
SeedRandom[7];
With[
  {fib = InfraFibration[GraphProduct[CycleGraph[4], Graph[{1, 2}, {}], "Cartesian"], First]},
  {sections = RandomInfraSection[fib, All, Properties -> {"Continuous"}]},
  GraphicsRow[InfraFiberedGraphHighlight[fib, #] & /@ sections]]
```

## Scope

A domain restricts the target. A seed fixes values and extends across all base components.

```wl
SeedRandom[7];
With[
  {fib = InfraFibration[Graph[{1, 2, 3, 4}, {UndirectedEdge[1, 3], UndirectedEdge[2, 4]}],
    <|1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b"|>]},
  {partial = RandomInfraSection[fib, {"a"}, "NextVertexFunction" -> Identity]},
  {partial, RandomInfraSection[fib, partial, Properties -> {"Continuous"}, "NextVertexFunction" -> Identity]}]
```

## Possible Issues

A continuous partial section can fail to extend. Values on opposite sheets at the ends of this path cannot be joined by a continuous section.

```wl
SeedRandom[7];
With[
  {fib = InfraFibration[GraphProduct[PathGraph[{1, 2, 3}], Graph[{1, 2}, {}], "Cartesian"], First]},
  {partial = InfraSection[<|1 -> {1, 1}, 3 -> {3, 2}|>]},
  {InfraContinuousSectionQ[fib, partial], RandomInfraSection[fib, partial, Properties -> {"Continuous"}]}]
```

A pruning callback may miss existing solutions. An empty result then concerns the retained search tree.
