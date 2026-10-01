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

A point, a second point two steps from it, and the segment between them, solved on a grid: eight choices of the second point and one or two geodesics to each, twelve instances in all. Their segments, summed, cover the ball of radius 2.

```wl
ClearAll[pA, pB, seg1];
With[
  {g = GridGraph[{9, 9}]},
  {scene = InfraScene[{pA, pB, seg1},
     {pA == InfraPoint[41], pB == InfraPoint[pA, 2], seg1 == InfraSegment[pA, pB]}]},
  With[{solved = FindInfraScene[scene, g]},
    {InfraSubstrateHighlight[g, {InfraSceneInstance[#, seg1] & /@ solved, Directive[$InfraPointColor], 41}, ImageSize -> 250],
     Length @ solved}]]
```

One instance.

```wl
ClearAll[pA, pB, seg1];
With[
  {scene = InfraScene[{pA, pB, seg1},
     {pA == InfraPoint[41], pB == InfraPoint[pA, 2], seg1 == InfraSegment[pA, pB]}]},
  First @ FindInfraScene[scene, GridGraph[{9, 9}]]]
```

## Scope

The steps are read off the dependencies, one object each here. Solving the first two gives the eight choices of the second point, with no segment yet.

```wl
ClearAll[pA, pB, seg1];
With[
  {scene = InfraScene[{pA, pB, seg1},
     {pA == InfraPoint[41], pB == InfraPoint[pA, 2], seg1 == InfraSegment[pA, pB]}]},
  {scene["Steps"], Length @ FindInfraScene[scene, GridGraph[{9, 9}], 2]}]
```

Fixing the second point in advance leaves only the segment to choose: the six geodesics from 41 to 61.

```wl
ClearAll[pA, pB, seg1];
With[
  {scene = InfraScene[{pA, pB, seg1},
     {pA == InfraPoint[41], pB == InfraPoint[pA, 2], seg1 == InfraSegment[pA, pB]}]},
  InfraSceneInstance[#, seg1] & /@ FindInfraScene[scene, GridGraph[{9, 9}], <|pB -> 61|>]]
```

## Options

### PruneProbability

Half of the branches dropped at every step, reproducibly.

```wl
ClearAll[pA, pB, seg1];
With[
  {scene = InfraScene[{pA, pB, seg1},
     {pA == InfraPoint[41], pB == InfraPoint[pA, 2], seg1 == InfraSegment[pA, pB]}]},
  SeedRandom[1];
  InfraSceneInstance[#, seg1] & /@ FindInfraScene[scene, GridGraph[{9, 9}], "PruneProbability" -> 0.5]]
```

## Properties and Relations

The instances are the choices made: as many as the points at distance 2 weighted by their geodesics.

```wl
With[
  {g = GridGraph[{9, 9}]},
  Total[InfraMeasurement[g, InfraSegment[41, #], "Cardinality"] & /@ FindInfraShell[g, 41, 2]]]
```
