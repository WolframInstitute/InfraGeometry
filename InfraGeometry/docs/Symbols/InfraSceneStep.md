---
Template: Symbol
Name: InfraSceneStep
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSceneStep
Keywords: [scene, step, construction, label]
SeeAlso: [InfraScene, RandomInfraSceneInstance, InfraSceneViewer, InfraSceneInstance]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraSceneStep]()[{*hyp1*, *hyp2*, …}]</code> is one construction step of an [InfraScene](): the hypotheses *hyp1*, *hyp2*, … taken together.

<code>[InfraSceneStep]()[{*hyp1*, …}, *label*]</code> is a step with the label *label*.

## Details & Options

The steps of a scene are carried out in the order written. A step can hold several constructions and the assertions on them.

Without [InfraSceneStep](), [InfraScene]() orders the constructions by their dependencies, and its `"DependencyGraph"` is a graph; with it, the order is the one written and the `"DependencyGraph"` is `None`.

<code>[RandomInfraSceneInstance]()[*scene*, *g*, "Steps" -> *k*]</code> stops after the first *k* steps and gives a partial instance. [InfraSceneViewer]() moves through a scene step by step, showing the labels.

## Basic Examples

Two labelled steps: a second point at distance 3 from the centre, then a segment to it:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB, seg},
     {InfraSceneStep[{pA == InfraPoint[a], pB == InfraPoint[], InfraDistance[pA, pB] == 3}, "two points"],
      InfraSceneStep[{seg == InfraSegment[pA, pB]}, "the segment"]}]},
  {inst = RandomInfraSceneInstance[scene, g, RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {InfraWalk[InfraSceneInstance[inst, seg]], InfraSceneInstance[inst, pA], InfraSceneInstance[inst, pB]},
    PlotLabel -> scene["Labels"], ImageSize -> Medium]]
```

After the first step only the points are bound. The 12 vertices of the shell give 12 partial instances; the 28 complete ones add a shortest path to each:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {a = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB, seg},
     {InfraSceneStep[{pA == InfraPoint[a], pB == InfraPoint[], InfraDistance[pA, pB] == 3}, "two points"],
      InfraSceneStep[{seg == InfraSegment[pA, pB]}, "the segment"]}]},
  {RandomInfraSceneInstance[scene, g, "Steps" -> 1, RandomSeeding -> 1],
   Length @ RandomInfraSceneInstance[scene, g, All, "Steps" -> 1], Length @ RandomInfraSceneInstance[scene, g, All]}]
```

## Properties and Relations

Written steps replace the steps read off the dependencies:

```wl
{InfraScene[{pA, pB, seg}, {pA == InfraPoint[45], pB == InfraPoint[48], seg == InfraSegment[pA, pB]}]["Steps"],
 InfraScene[{pA, pB, seg},
   {InfraSceneStep[{pA == InfraPoint[45]}], InfraSceneStep[{pB == InfraPoint[48], seg == InfraSegment[pA, pB]}]}]["Steps"]}
```
