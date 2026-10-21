---
Template: Symbol
Name: InfraScenePlot
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraScenePlot
Keywords: [scene, plot, instance, figure, segment, family]
SeeAlso: [InfraScene, InfraSceneInstance, RandomInfraSceneInstance, InfraSubstrateHighlight, InfraSceneViewer]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraScenePlot]()[*scene*, *g*, *inst*]</code> draws the objects of *scene* bound in the instance *inst* on the graph *g*.

<code>[InfraScenePlot]()[*scene*, *g*, *inst*, {*obj1*, *obj2*, …}]</code> draws the listed objects, their names read from *inst*.

## Details & Options

The objects are drawn with [InfraSubstrateHighlight](), in declaration order, the *i*-th in the *i*-th palette colour. Objects the instance does not bind are left out.

A name draws its saved value: a point as a vertex, a segment, half-line or line as its walk, a region as its vertex set. A token in the list draws the whole family at the saved values: <code>[InfraSegment]()[*pA*, *pB*]</code> draws every shortest path between the saved points, not the one the instance chose.

The list is read as by [InfraSubstrateHighlight](): a [Directive]() styles the objects after it, and `obj -> style` or <code>[Style]()[*obj*, …]</code> styles one object. [InfraScenePlot]() takes the options of [InfraSubstrateHighlight]() and of [Graph]().

[InfraScenePlot]() does not solve the scene; [RandomInfraSceneInstance]() does. [InfraSceneViewer]() steps through it interactively.

## Basic Examples

A point at distance 5 from the centre and a segment to it, drawn in the order the objects are declared:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
    {scene = InfraScene[{seg, pA, pB},
       {pA == InfraPoint[a], pB == InfraPoint[], InfraDistance[pA, pB] == 5, seg == InfraSegment[pA, pB]}]},
    InfraScenePlot[scene, g, RandomInfraSceneInstance[scene, g, RandomSeeding -> 1]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The saved segment, one shortest path, against the token at the saved points, all of them:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB, seg},
     {pA == InfraPoint[a], pB == InfraPoint[], InfraDistance[pA, pB] == 5, seg == InfraSegment[pA, pB]}]},
  {inst = RandomInfraSceneInstance[scene, g, RandomSeeding -> 1]},
  GraphicsRow[{InfraScenePlot[scene, g, inst, {seg, pA, pB}],
    InfraScenePlot[scene, g, inst, {InfraSegment[pA, pB], pA, pB}]}]]
```

## Scope

A partial instance draws what it binds. After the first step there are only the points:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB, seg},
     {InfraSceneStep[{pA == InfraPoint[a], pB == InfraPoint[], InfraDistance[pA, pB] == 5}],
      InfraSceneStep[{seg == InfraSegment[pA, pB]}]}]},
  InfraScenePlot[scene, g, RandomInfraSceneInstance[scene, g, "Steps" -> 1, RandomSeeding -> 1], ImageSize -> Medium]]
```

A saved region is drawn as its vertex set:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, disk}, {pA == InfraPoint[a], disk == InfraBall[pA, 3]}]},
  InfraScenePlot[scene, g, RandomInfraSceneInstance[scene, g, RandomSeeding -> 1], {disk, pA}, ImageSize -> Medium]]
```

## Options

Colours by [Directive]() and by rule, and a plot label:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB, seg},
     {pA == InfraPoint[a], pB == InfraPoint[], InfraDistance[pA, pB] == 5, seg == InfraSegment[pA, pB]}]},
  InfraScenePlot[scene, g, RandomInfraSceneInstance[scene, g, RandomSeeding -> 1],
    {Directive[StandardGray], InfraSegment[pA, pB], pA -> StandardRed, pB -> StandardBlue},
    PlotLabel -> "all shortest paths", ImageSize -> Medium]]
```

## Possible Issues

A saved circle is drawn without its closing edge. Close it by hand with [InfraSubstrateHighlight]():

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, cA}, {pA == InfraPoint[a], cA == InfraCircle[pA, {3, 4}]}]},
  {inst = RandomInfraSceneInstance[scene, g, RandomSeeding -> 1]},
  GraphicsRow[{InfraScenePlot[scene, g, inst, {cA, pA}],
    InfraSubstrateHighlight[g, {InfraWalk[Append[InfraSceneInstance[inst, cA], First @ InfraSceneInstance[inst, cA]]], a}]}]]
```
