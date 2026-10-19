---
Template: Symbol
Name: RandomInfraSceneInstance
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraSceneInstance
Keywords: [scene, construction, solve, branch, binding, instance]
SeeAlso: [InfraScenePlot, InfraScene, InfraSceneInstance, InfraSceneStep, InfraSubstrateHighlight, InfraSceneViewer]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

`RandomInfraSceneInstance[scene, graph]` draws one admissible [InfraSceneInstance]().

`RandomInfraSceneInstance[scene, graph, n]` gives exactly *n* distinct instances, or `{}` when fewer exist. `UpTo[n]` gives at most *n*. `All` enumerates every instance in construction order when the construction and selection callbacks are deterministic.

`RandomInfraSceneInstance[scene, graph, bindings]` fixes the given `Association` of bindings. A count may precede *bindings*.

## Details & Options

The search extends one binding at a time, checks each assertion as soon as its objects are bound, and backtracks from a dead end. It stops when the requested number of distinct instances has been found. A count-less call with no admissible instance gives `{}`.

The default draw is not uniform over instances. Each visited construction enumerates its candidate family; the search avoids forming the full product of those families.

An object already bound is not constructed again. A partly fixed tuple construction keeps only tuples agreeing with its fixed entries.

| Option | Default | Meaning |
|---|---|---|
| `"NextVertexFunction"` | `Automatic` | random candidate order for bounded counts; `Identity` for `All` |
| `"Steps"` | `All` | how many scene steps to construct |
| `RandomSeeding` | `Automatic` | seed for one local stream covering the complete search |

With deterministic construction callbacks, `"NextVertexFunction" -> Identity` gives deterministic descent, and `All` with the default `"NextVertexFunction" -> Automatic` makes no random draw. Stochastic construction callbacks or explicit stochastic candidate ordering and pruning use the local scene stream.

`RandomSeeding -> Automatic` freshly seeds each call. An integer or string gives a reproducible call; a saved `RandomGeneratorState` restores that state locally. `Inherited` uses a local snapshot of the current generator state. Every setting restores the outer random state afterward, so successive `Inherited` calls can repeat.

The seed applies once to the complete search, including random candidate-selection callbacks and nested geometry samplers. Counts, initial bindings and `"Steps"` retain their existing meanings. A stochastic callback with `All` can prune the search; `All` is exhaustive only for the retained tree.

This follows Wolfram's [RandomInstance](https://reference.wolfram.com/language/ref/RandomInstance.html) and [RandomSeeding](https://reference.wolfram.com/language/ref/RandomSeeding.html) convention. Named geometry samplers instead use ambient `SeedRandom`, like [RandomPoint](https://reference.wolfram.com/language/ref/RandomPoint.html) and [RandomChoice](https://reference.wolfram.com/language/ref/RandomChoice.html). To migrate an externally seeded scene example, supply `RandomSeeding -> seed` directly; use `Inherited` when a local snapshot of an externally seeded stream is intended.

A function such as `(RandomSample[#, UpTo[2]] &)` keeps at most two candidate extensions at each construction. Failure then means failure in the retained tree. `RandomChoice` follows just one route, without backtracking, and is not accepted with `All`.

`"Steps" -> k` returns partial bindings after the first *k* steps. Assertions with unbound objects remain deferred; a partial binding need not have a complete extension. The third integer argument counts instances, not steps.

## Basic Examples

A point, a second point at distance 2 from it, and the segment between them, solved on the square tiling: one instance per choice of the second point and of the shortest path to it. Their segments, summed, cover the ball of radius 2.

```wl
SeedRandom[1];
ClearAll[pA, pB, seg1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB, seg1},
     {pA == InfraPoint[c], pB == InfraPoint[], InfraDistance[pA, pB] == 2, seg1 == InfraSegment[pA, pB]}]},
  {solved = RandomInfraSceneInstance[ scene, g, All ]},
  {InfraSubstrateHighlight[g, {InfraSceneInstance[#, seg1] & /@ solved, c}],
   Length @ solved}]
```

One instance, and its segment drawn.

```wl
SeedRandom[1];
ClearAll[pA, pB, seg1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB, seg1},
     {pA == InfraPoint[c], pB == InfraPoint[], InfraDistance[pA, pB] == 2, seg1 == InfraSegment[pA, pB]}]},
  {instance = RandomInfraSceneInstance[scene, g, RandomSeeding -> 1]},
  {InfraSubstrateHighlight[g, {InfraSceneInstance[instance, seg1], c}], instance}]
```

## Scope

The steps are read off the dependencies: the two points first, then the segment. Solving the first step gives the choices of the second point, with no segment yet: the shell of radius 2.

```wl
SeedRandom[1];
ClearAll[pA, pB, seg1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB, seg1},
     {pA == InfraPoint[c], pB == InfraPoint[], InfraDistance[pA, pB] == 2, seg1 == InfraSegment[pA, pB]}]},
  {points = InfraSceneInstance[#, pB] & /@ RandomInfraSceneInstance[ scene, g, All, "Steps" -> 1 ]},
  {InfraSubstrateHighlight[g, {points, c}], scene["Steps"], Length @ points}]
```

Fixing the second point in advance leaves only the segment to choose: one instance per shortest path.

```wl
SeedRandom[1];
ClearAll[pA, pB, seg1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[c, 2]])},
  {scene = InfraScene[{pA, pB, seg1},
     {pA == InfraPoint[c], pB == InfraPoint[], InfraDistance[pA, pB] == 2, seg1 == InfraSegment[pA, pB]}]},
  {segments = InfraSceneInstance[#, seg1] & /@ RandomInfraSceneInstance[ scene, g, All, <|pB -> b|> ]},
  {InfraSubstrateHighlight[g, {segments, c, b}], Length @ segments}]
```

## Options

### NextVertexFunction

Keep at most two extensions at each construction, reproducibly.

```wl
SeedRandom[1];
ClearAll[pA, pB, seg1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB, seg1},
     {pA == InfraPoint[c], pB == InfraPoint[], InfraDistance[pA, pB] == 2, seg1 == InfraSegment[pA, pB]}]},
  {segments = InfraSceneInstance[#, seg1] & /@ RandomInfraSceneInstance[ scene, g, All,
      "NextVertexFunction" -> (RandomSample[#, UpTo[2]] &), RandomSeeding -> 1 ]},
  {InfraSubstrateHighlight[g, {segments, c}], Length @ segments}]
```

### RandomSeeding

Repeat a complete scene search with an explicit seed.

```wl
ClearAll[p, q];
With[
  {g = GridGraph[{3, 3}]},
  {scene = InfraScene[{p, q}, {p == InfraPoint[], q == InfraPoint[], InfraDistance[p, q] == 2}]},
  {instance = RandomInfraSceneInstance[scene, g, RandomSeeding -> 123]},
  {InfraSubstrateHighlight[g, {InfraSceneInstance[instance, {p, q}]}],
   instance === RandomInfraSceneInstance[scene, g, RandomSeeding -> 123]}]
```

An inherited seed snapshots the ambient state without advancing it; repeated calls can return the same instance.

```wl
SeedRandom[123];
ClearAll[p];
With[
  {g = GridGraph[{3, 3}]},
  {scene = InfraScene[{p}, {p == InfraPoint[]}]},
  {instance = RandomInfraSceneInstance[scene, g, RandomSeeding -> Inherited]},
  instance === RandomInfraSceneInstance[scene, g, RandomSeeding -> Inherited]]
```

## Properties and Relations

The instances are the choices made: as many as the points at distance 2, weighted by their shortest paths.

```wl
SeedRandom[1];
ClearAll[pA, pB, seg1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB, seg1},
     {pA == InfraPoint[c], pB == InfraPoint[], InfraDistance[pA, pB] == 2, seg1 == InfraSegment[pA, pB]}]},
  {InfraSubstrateHighlight[g, {Keys @ InfraMeasurement[ g, InfraShell[ c, 2 ], "VertexDensity" ], c}],
   Length @ RandomInfraSceneInstance[ scene, g, All ] === Total @ Table[InfraMeasurement[g, InfraSegment[c, through], "Cardinality"], {through, Keys @ InfraMeasurement[ g, InfraShell[ c, 2 ], "VertexDensity" ]}]}]
```
