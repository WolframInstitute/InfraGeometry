---
Template: Symbol
Name: InfraSceneInstance
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSceneInstance
Keywords: [scene, instance, binding, solution, branch]
SeeAlso: [RandomInfraSceneInstance, InfraScene, InfraScenePlot, InfraSubstrateHighlight, InfraSceneViewer]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraSceneInstance]()[*bindings*]</code> is an instance of a scene: the association *bindings* of each object to its value on a graph.

<code>[InfraSceneInstance]()[*inst*, *x*]</code> gives the value of the object *x* in the instance *inst*.

<code>[InfraSceneInstance]()[*inst*, {*x1*, *x2*, …}]</code> gives the values of several objects.

## Details & Options

An instance is one branch of an [InfraScene](): a choice of one realisation for each construction, with every assertion true. [RandomInfraSceneInstance]() draws instances, one by default, a list with a count or `All`.

A value is what the construction realised on the graph:

| Construction | Value |
|---|---|
| a point, a midpoint, an intersection point | a vertex |
| a segment, a half-line, a line | a vertex list, in order |
| a circle | a cyclic vertex list, its first vertex not repeated |
| a region | a vertex list |

An object the instance does not bind gives `Missing["KeyAbsent", x]`. With `"Steps" -> k` an instance is partial, binding only the objects of the first *k* steps. A bare association of bindings is read the same way.

## Basic Examples

One instance of Euclid I.1 and the values of its points:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium"]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 3], RandomSeeding -> 2]},
  {scene = InfraScene[{pA, pB, cA, cB, meet}, {pA == InfraPoint[a], pB == InfraPoint[b],
     cA == InfraCircle[pA, {3, 4}], cB == InfraCircle[pB, {3, 4}], meet == InfraPoint[InfraIntersection[cA, cB]]}]},
  InfraSceneInstance[RandomInfraSceneInstance[scene, g, RandomSeeding -> 1], {pA, pB, meet}]]
```

The values of one instance, drawn. A circle is closed by repeating its first vertex:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 3], RandomSeeding -> 2]},
  {scene = InfraScene[{pA, pB, cA, cB, meet}, {pA == InfraPoint[a], pB == InfraPoint[b],
     cA == InfraCircle[pA, 3], cB == InfraCircle[pB, 3], meet == InfraPoint[InfraIntersection[cA, cB]]}]},
  {inst = RandomInfraSceneInstance[scene, g, RandomSeeding -> 1]},
  InfraSubstrateHighlight[g,
    Join[InfraWalk[Append[#, First @ #]] & /@ InfraSceneInstance[inst, {cA, cB}], InfraSceneInstance[inst, {pA, pB, meet}]],
    ImageSize -> Medium]]
```

## Scope

An instance holds an association:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {a = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB, seg}, {pA == InfraPoint[a], pB == InfraPoint[], InfraDistance[pA, pB] == 2, seg == InfraSegment[pA, pB]}]},
  RandomInfraSceneInstance[scene, g, RandomSeeding -> 1]]
```

A bare association is read the same way:

```wl
InfraSceneInstance[<|pA -> 45, pB -> 47|>, {pA, pB}]
```

## Properties and Relations

The values of one object across all instances. A vertex two steps along an axis is reached by one shortest path, a diagonal vertex by two, so the diagonal vertices occur twice:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB, seg}, {pA == InfraPoint[a], pB == InfraPoint[], InfraDistance[pA, pB] == 2, seg == InfraSegment[pA, pB]}]},
  {counts = Counts[InfraSceneInstance[#, pB] & /@ RandomInfraSceneInstance[scene, g, All]]},
  InfraSubstrateHighlight[g, {counts, a}, PlotLabel -> Sort @ Values[counts], ImageSize -> Medium]]
```

## Possible Issues

An object the instance does not bind is missing. A partial instance after the first step has no segment:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {a = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB, seg}, {InfraSceneStep[{pA == InfraPoint[a], pB == InfraPoint[], InfraDistance[pA, pB] == 2}],
     InfraSceneStep[{seg == InfraSegment[pA, pB]}]}]},
  InfraSceneInstance[RandomInfraSceneInstance[scene, g, "Steps" -> 1, RandomSeeding -> 1], {pB, seg}]]
```
