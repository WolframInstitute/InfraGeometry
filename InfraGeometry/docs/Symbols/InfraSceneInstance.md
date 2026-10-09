---
Template: Symbol
Name: InfraSceneInstance
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSceneInstance
Keywords: [scene, instance, binding, solution]
SeeAlso: [FindInfraScene, InfraScene, InfraSubstrateHighlight, InfraSceneViewer]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraSceneInstance]()[*bindings*]</code> is one solved branch of a scene: the `Association` *bindings* of its objects to their values.

<code>[InfraSceneInstance]()[*inst*, *x*]</code> reads the value of the object *x* out of the instance *inst*, and <code>[InfraSceneInstance]()[*inst*, {*x1*, *x2*, …}]</code> the values of several.

## Details & Options

[FindInfraScene]() returns a `List` of instances, one per branch. An instance is a symbolic representation of a solved branch: it stores the bindings for later retrieval.

A value is what the construction of the object realised on the graph: a vertex for a point or an intersection, a vertex list for a segment, a ray or a line, a cyclic vertex list for a circle. So an instance's objects are drawn by [InfraSubstrateHighlight]() directly, a circle once it is closed into a walk.

An object the instance does not bind reads as `Missing["KeyAbsent", x]`. The second argument also reads a bare `Association` of bindings.

## Basic Examples

One instance of Euclid I.1 on a grid: the two circles and the vertex where they meet, read out of the instance and drawn.

```wl
ClearAll[pA, pB, circleA, circleB, meet];
With[
  {g = GridGraph[{13, 13}]},
  {scene = InfraScene[{pA, pB, circleA, circleB, meet},
     {pA == InfraPoint[83], pB == InfraPoint[87],
      circleA == InfraCircle[pA, {4, 5}], circleB == InfraCircle[pB, {4, 5}],
      meet == InfraIntersection[circleA, circleB]}]},
  With[{first = First @ FindInfraScene[scene, g]},
    {InfraSubstrateHighlight[g,
       {InfraWalk[Append[#, First @ #]] & @ InfraSceneInstance[first, circleA],
        InfraWalk[Append[#, First @ #]] & @ InfraSceneInstance[first, circleB],
        InfraSceneInstance[first, pA], InfraSceneInstance[first, pB],
        InfraSceneInstance[first, meet]},
       "ThicknessRange" -> 4, ImageSize -> 250],
     InfraSceneInstance[first, {pA, pB, meet}]}]]
```

An instance holds an `Association`.

```wl
ClearAll[pA, pB, seg1];
With[
  {scene = InfraScene[{pA, pB, seg1},
     {pA == InfraPoint[41], pB == InfraPoint[], InfraDistance[pA, pB] == 2, seg1 == InfraSegment[pA, pB]}]},
  First @ FindInfraScene[scene, GridGraph[{9, 9}]]]
```

## Properties and Relations

The values of one object across all the instances. Here the second point takes each of its eight positions, the diagonal ones twice, once per geodesic.

```wl
ClearAll[pA, pB, seg1];
With[
  {scene = InfraScene[{pA, pB, seg1},
     {pA == InfraPoint[41], pB == InfraPoint[], InfraDistance[pA, pB] == 2, seg1 == InfraSegment[pA, pB]}]},
  Counts[InfraSceneInstance[#, pB] & /@ FindInfraScene[scene, GridGraph[{9, 9}]]]]
```

The accessor reads a bare `Association` the same way.

```wl
ClearAll[pA, pB];
InfraSceneInstance[<|pA -> 41, pB -> 61|>, {pA, pB}]
```
