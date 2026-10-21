---
Template: Symbol
Name: InfraScene
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraScene
Keywords: [scene, construction, Euclid I.1, hypothesis, assertion, ruler and compass]
SeeAlso: [RandomInfraSceneInstance, InfraSceneInstance, InfraSceneStep, InfraScenePlot, InfraSceneViewer, InfraSceneMultiway, InfraIntersection, InfraDistance]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraScene]()[{*x1*, *x2*, …}, {*hyp1*, *hyp2*, …}]</code> is the construction of the objects *x1*, *x2*, … under the hypotheses *hyp1*, *hyp2*, …, stated before any graph.

<code>[InfraScene]()[{*x1*, …}, {[InfraSceneStep]()[{*hyp1*, …}, *label*], …}]</code> groups the hypotheses into labelled steps.

<code>*scene*["*prop*"]</code> gives the property *prop* of the scene.

## Details & Options

A hypothesis `x == token` with an object on the left is a construction. Every other hypothesis is an assertion.

A token names a construction, with objects in place of points:

| Token | Realisation |
|---|---|
| <code>[InfraPoint]()[*v*]</code>, <code>[InfraPoint]()[]</code> | the vertex *v*; any vertex |
| <code>[InfraSegment]()[*x*, *y*]</code> | a shortest path from *x* to *y* |
| <code>[InfraHalfLine]()[*x*, *y*]</code>, <code>[InfraInfiniteLine]()[*x*, *y*]</code> | a ray, a line |
| <code>[InfraCircle]()[*x*, *r*]</code> | a circle about *x* of radius *r*, or in a band {*r*, *s*} |
| <code>[InfraIntersection]()[*x*, *y*]</code> | the vertices *x* and *y* share |
| <code>[InfraMidpoint]()[*x*, *y*]</code>, <code>[InfraBall]()[*x*, *r*]</code>, … | a central vertex, a region, … |

A construction on a graph rarely has one result. Each realisation of a token is a branch, and the branches multiply from one construction to the next. An instance is one complete branch: [RandomInfraSceneInstance]() draws instances, [InfraSceneInstance]() reads them, [InfraScenePlot]() draws one, [InfraSceneViewer]() steps through them and [InfraSceneMultiway]() lists them all.

An assertion is a condition on objects: a comparison of [InfraDistance]() values, or a test such as `InfraSegmentQ[x]` or `InfraParallelQ[x, y]` written without its graph. A branch survives only if every assertion holds on it. A scene with a test it cannot give the graph stays unevaluated.

The steps are the levels of the dependency graph: first the objects that depend on no other, then those that depend only on them, and so on. With [InfraSceneStep]() they are the steps written, in order.

| Property | Value |
|---|---|
| `"Objects"` | the objects |
| `"Constructions"` | the constructions, `<\|x -> token, …\|>` |
| `"Assertions"` | the assertions |
| `"Steps"` | the objects of each step |
| `"Labels"` | the step labels |
| `"DependencyGraph"` | which object depends on which; `None` for written steps |

The objects are symbols without values.

A construction can stall. Euclid never postulated that the two circles of I.1 meet, and on a graph they need not. A shell of the square grid has no two adjacent vertices, so there is no circle of one radius; a band of two radii carries circles, and there the construction goes through.

## Basic Examples

Euclid I.1: two points at distance 3, a circle about each through the other, and a vertex where they meet. On the grid the circles need a band:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[First @ spec, "Medium", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
    {b = RandomInfraPoint[g, InfraShell[a, 3], RandomSeeding -> 2]},
    {scene = InfraScene[{pA, pB, cA, cB, meet}, {pA == InfraPoint[a], pB == InfraPoint[b],
       cA == InfraCircle[pA, Last @ spec], cB == InfraCircle[pB, Last @ spec], meet == InfraPoint[InfraIntersection[cA, cB]]}]},
    {inst = RandomInfraSceneInstance[scene, g, RandomSeeding -> 1]},
    InfraSubstrateHighlight[g,
      Join[InfraWalk[Append[#, First @ #]] & /@ InfraSceneInstance[inst, {cA, cB}], InfraSceneInstance[inst, {pA, pB, meet}]]]],
  {spec, {{"SquareGridGraph", {3, 4}}, {"SquareMeshGraph", 3}}}]
```

The steps are read off the dependencies, three levels deep. Each circle depends on its centre, the meeting point on both circles:

```wl
With[{scene = InfraScene[{pA, pB, cA, cB, meet}, {pA == InfraPoint[45], pB == InfraPoint[48],
     cA == InfraCircle[pA, {3, 4}], cB == InfraCircle[pB, {3, 4}], meet == InfraPoint[InfraIntersection[cA, cB]]}]},
  {scene["Steps"], EdgeList @ scene["DependencyGraph"]}]
```

## Scope

An assertion selects branches. The second point is any vertex at distance 4 from the first, so there are as many instances as vertices on the shell, 16 on the grid:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB}, {pA == InfraPoint[a], pB == InfraPoint[], InfraDistance[pA, pB] == 4}]},
  {ends = InfraSceneInstance[#, pB] & /@ RandomInfraSceneInstance[scene, g, All]},
  InfraSubstrateHighlight[g, {ends, a}, PlotLabel -> Length[ends], ImageSize -> Medium]]
```

Written steps keep their labels:

```wl
With[{scene = InfraScene[{pA, pB, seg},
     {InfraSceneStep[{pA == InfraPoint[45], pB == InfraPoint[49]}, "two points"], InfraSceneStep[{seg == InfraSegment[pA, pB]}, "the segment"]}]},
  {scene["Steps"], scene["Labels"]}]
```

## Properties and Relations

Every vertex where the circles meet, one per instance. On the grid the circles meet along edges, so there are more meeting vertices than the two of the plane:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[First @ spec, "Medium", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
    {b = RandomInfraPoint[g, InfraShell[a, 3], RandomSeeding -> 2]},
    {scene = InfraScene[{pA, pB, cA, cB, meet}, {pA == InfraPoint[a], pB == InfraPoint[b],
       cA == InfraCircle[pA, Last @ spec], cB == InfraCircle[pB, Last @ spec], meet == InfraPoint[InfraIntersection[cA, cB]]}]},
    {meets = Union[InfraSceneInstance[#, meet] & /@ RandomInfraSceneInstance[scene, g, All]]},
    InfraSubstrateHighlight[g, {InfraShell[a, Last @ spec], InfraShell[b, Last @ spec], meets, {a, b}}, PlotLabel -> Length[meets]]],
  {spec, {{"SquareGridGraph", {3, 4}}, {"SquareMeshGraph", 3}}}]
```

## Possible Issues

At one radius the square grid has no circle, and Euclid I.1 has no instance:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium"]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 3], RandomSeeding -> 2]},
  {scene = InfraScene[{pA, pB, cA, cB, meet}, {pA == InfraPoint[a], pB == InfraPoint[b],
     cA == InfraCircle[pA, 3], cB == InfraCircle[pB, 3], meet == InfraPoint[InfraIntersection[cA, cB]]}]},
  RandomInfraSceneInstance[scene, g, All]]
```
