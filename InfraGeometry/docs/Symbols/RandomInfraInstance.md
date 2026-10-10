---
Template: Symbol
Name: RandomInfraInstance
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraInstance
Keywords: [scene, construction, solve, branch, binding, instance]
SeeAlso: [InfraScene, InfraSceneInstance, InfraStep, InfraSubstrateHighlight, InfraSceneViewer]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

`RandomInfraInstance[scene, graph]` draws one admissible [InfraSceneInstance]().

`RandomInfraInstance[scene, graph, n]` gives exactly *n* distinct instances, or `{}` when fewer exist. `UpTo[n]` gives at most *n*. `All` enumerates every instance in deterministic construction order.

`RandomInfraInstance[scene, graph, bindings]` fixes the given `Association` of bindings. A count may precede *bindings*.

## Details & Options

The search extends one binding at a time, checks each assertion as soon as its objects are bound, and backtracks from a dead end. It stops when the requested number of distinct instances has been found. A count-less call with no admissible instance gives `{}`.

The default draw is not uniform over instances. Each visited construction enumerates its candidate family; the search avoids forming the full product of those families.

An object already bound is not constructed again. A partly fixed tuple construction keeps only tuples agreeing with its fixed entries.

| Option | Default | Meaning |
|---|---|---|
| `"NextVertexFunction"` | `Automatic` | random candidate order for bounded counts; `Identity` for `All` |
| `"Steps"` | `All` | how many scene steps to construct |

`"NextVertexFunction" -> Identity` gives deterministic descent. Ambient `SeedRandom` controls random draws. `All` with `Automatic` makes no draw.

A function such as `(RandomSample[#, UpTo[2]] &)` keeps at most two candidate extensions at each construction. Failure then means failure in the retained tree. `RandomChoice` follows just one route, without backtracking, and is not accepted with `All`.

`"Steps" -> k` returns partial bindings after the first *k* steps. Assertions with unbound objects remain deferred; a partial binding need not have a complete extension. The third integer argument counts instances, not steps.

## Basic Examples

A point, a second point at distance 2 from it, and the segment between them, solved on the square tiling: one instance per choice of the second point and of the shortest path to it. Their segments, summed, cover the ball of radius 2.

```wl
ClearAll[pA, pB, seg1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB, seg1},
     {pA == InfraPoint[c], pB == InfraPoint[], InfraDistance[pA, pB] == 2, seg1 == InfraSegment[pA, pB]}]},
  {solved = RandomInfraInstance[ scene, g, All ]},
  {InfraSubstrateHighlight[g, {InfraSceneInstance[#, seg1] & /@ solved, c}],
   Length @ solved}]
```

One instance, and its segment drawn.

```wl
ClearAll[pA, pB, seg1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB, seg1},
     {pA == InfraPoint[c], pB == InfraPoint[], InfraDistance[pA, pB] == 2, seg1 == InfraSegment[pA, pB]}]},
  {instance = (SeedRandom[1]; RandomInfraInstance[scene, g])},
  {InfraSubstrateHighlight[g, {InfraSceneInstance[instance, seg1], c}], instance}]
```

## Scope

The steps are read off the dependencies: the two points first, then the segment. Solving the first step gives the choices of the second point, with no segment yet: the shell of radius 2.

```wl
ClearAll[pA, pB, seg1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB, seg1},
     {pA == InfraPoint[c], pB == InfraPoint[], InfraDistance[pA, pB] == 2, seg1 == InfraSegment[pA, pB]}]},
  {points = InfraSceneInstance[#, pB] & /@ RandomInfraInstance[ scene, g, All, "Steps" -> 1 ]},
  {InfraSubstrateHighlight[g, {points, c}], scene["Steps"], Length @ points}]
```

Fixing the second point in advance leaves only the segment to choose: one instance per shortest path.

```wl
ClearAll[pA, pB, seg1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[c, 2]])},
  {scene = InfraScene[{pA, pB, seg1},
     {pA == InfraPoint[c], pB == InfraPoint[], InfraDistance[pA, pB] == 2, seg1 == InfraSegment[pA, pB]}]},
  {segments = InfraSceneInstance[#, seg1] & /@ RandomInfraInstance[ scene, g, All, <|pB -> b|> ]},
  {InfraSubstrateHighlight[g, {segments, c, b}], Length @ segments}]
```

## Options

### NextVertexFunction

Keep at most two extensions at each construction, reproducibly.

```wl
ClearAll[pA, pB, seg1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB, seg1},
     {pA == InfraPoint[c], pB == InfraPoint[], InfraDistance[pA, pB] == 2, seg1 == InfraSegment[pA, pB]}]},
  {segments = (SeedRandom[1]; InfraSceneInstance[#, seg1] & /@ RandomInfraInstance[ scene, g, All, "NextVertexFunction" -> (RandomSample[#, UpTo[2]] &) ])},
  {InfraSubstrateHighlight[g, {segments, c}], Length @ segments}]
```

## Properties and Relations

The instances are the choices made: as many as the points at distance 2, weighted by their shortest paths.

```wl
ClearAll[pA, pB, seg1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB, seg1},
     {pA == InfraPoint[c], pB == InfraPoint[], InfraDistance[pA, pB] == 2, seg1 == InfraSegment[pA, pB]}]},
  {InfraSubstrateHighlight[g, {FindInfraShell[g, c, 2], c}],
   Length @ RandomInfraInstance[ scene, g, All ] === Total @ Table[InfraMeasurement[g, InfraSegment[c, through], "Cardinality"], {through, FindInfraShell[g, c, 2]}]}]
```
