---
Template: Symbol
Name: FindInfraScene
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraScene
Keywords: [scene, construction, solve, branch, binding, instance]
SeeAlso: [InfraScene, InfraSceneInstance, InfraStep, InfraSubstrateHighlight, InfraSceneViewer]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[FindInfraScene]()[*scene*, *graph*]</code> solves the [InfraScene]() *scene* on *graph* and gives a `List` of [InfraSceneInstance]() objects, one per admissible branch.

<code>[FindInfraScene]()[*scene*, *graph*, *k*]</code> solves the first *k* steps only.

<code>[FindInfraScene]()[*scene*, *graph*, *bindings*]</code> starts from the `Association` *bindings* of objects to values fixed in advance, and <code>[FindInfraScene]()[*scene*, *graph*, *k*, *bindings*]</code> does both.

## Details & Options

The steps are solved in order. At each step every branch is extended by every realisation of each construction of the step: a vertex for a point or an intersection, a vertex list for a segment, a ray, a line or a circle. So the number of branches is the product of the numbers of choices made along the way.

An object bound in *bindings* is not constructed again, and the objects that depend on it read its fixed value.

The assertions are checked last, on the finished branches. An assertion whose objects are not all bound, as after a partial solve, is not checked. A branch whose construction has no realisation stops, so a construction that stalls gives `{}`.

*k* counts steps, not solutions.

Option `"PruneProbability" -> q` drops each branch with probability *q* after every step, keeping at least one. The default is `0`, exhaustive. The draw is random, so put `SeedRandom` in front.

## Basic Examples

A point, a second point at distance 2 from it, and the segment between them, solved on the square tiling: one instance per choice of the second point and of the shortest path to it. Their segments, summed, cover the ball of radius 2.

```wl
ClearAll[pA, pB, seg1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB, seg1},
     {pA == InfraPoint[c], pB == InfraPoint[], InfraDistance[pA, pB] == 2, seg1 == InfraSegment[pA, pB]}]},
  {solved = FindInfraScene[scene, g]},
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
  {instance = First @ FindInfraScene[scene, g]},
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
  {points = InfraSceneInstance[#, pB] & /@ FindInfraScene[scene, g, 1]},
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
  {segments = InfraSceneInstance[#, seg1] & /@ FindInfraScene[scene, g, <|pB -> b|>]},
  {InfraSubstrateHighlight[g, {segments, c, b}], Length @ segments}]
```

## Options

### PruneProbability

Half of the branches dropped at every step, reproducibly.

```wl
ClearAll[pA, pB, seg1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB, seg1},
     {pA == InfraPoint[c], pB == InfraPoint[], InfraDistance[pA, pB] == 2, seg1 == InfraSegment[pA, pB]}]},
  {segments = (SeedRandom[1]; InfraSceneInstance[#, seg1] & /@ FindInfraScene[scene, g, "PruneProbability" -> 0.5])},
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
   Length @ FindInfraScene[scene, g] === Total @ Table[InfraMeasurement[g, InfraSegment[c, through], "Cardinality"], {through, FindInfraShell[g, c, 2]}]}]
```
