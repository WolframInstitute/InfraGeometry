---
Template: Symbol
Name: InfraSceneStep
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSceneStep
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

`InfraSceneStep[{hyp1, hyp2, ...}]` groups hypotheses into a manual construction step.

`InfraSceneStep[{hyps...}, label]` adds a label.

## Basic Examples

Two labelled steps: two points three steps apart, then the segment between them. The segments of every branch are drawn summed.

```wl
SeedRandom[1];
ClearAll[pA, pB, seg1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB, seg1},
     {InfraSceneStep[{pA == InfraPoint[c], pB == InfraPoint[], InfraDistance[pA, pB] == 3}, "two points"],
      InfraSceneStep[{seg1 == InfraSegment[pA, pB]}, "the segment"]}]},
  {solved = RandomInfraSceneInstance[ scene, g, All ]},
  {InfraSubstrateHighlight[g, {InfraSceneInstance[#, seg1] & /@ solved, c}],
   scene["Labels"]}]
```
