---
Template: Symbol
Name: InfraStep
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraStep
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

`InfraStep[{hyp1, hyp2, ...}]` groups hypotheses into a manual construction step.

`InfraStep[{hyps...}, label]` adds a label.

## Basic Examples

Two labelled steps: two points three steps apart, then the segment between them. The segments of every branch are drawn summed.

```wl
ClearAll[pA, pB, seg1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {scene = InfraScene[{pA, pB, seg1},
     {InfraStep[{pA == InfraPoint[c], pB == InfraPoint[pA, 3]}, "two points"],
      InfraStep[{seg1 == InfraSegment[pA, pB]}, "the segment"]}]},
  {solved = FindInfraScene[scene, g]},
  {InfraSubstrateHighlight[g, {InfraSceneInstance[#, seg1] & /@ solved, c}],
   scene["Labels"]}]
```
