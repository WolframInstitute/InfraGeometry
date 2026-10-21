---
Template: Symbol
Name: InfraSceneViewer
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSceneViewer
Keywords: [viewer, interactive, construction, step, branch]
SeeAlso: [InfraScene, InfraScenePlot, InfraSceneMultiway, InfraBranchialGraph, RandomInfraSceneInstance, InfraSceneStep, InfraSubstrateHighlight]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraSceneViewer]()[*scene*, *g*]</code> is an interactive view of the construction *scene* on the graph *g*, one step at a time.

<code>[InfraSceneViewer]()[*scene*, *g*, *init*]</code> starts from the bindings in the association *init*.

<code>[InfraSceneViewer]()[*data*]</code> browses the result *data* of [InfraSceneMultiway]().

## Details & Options

A construction is a sequence, not a picture. The viewer solves the scene step by step and draws the objects bound so far with [InfraSubstrateHighlight]().

| Control | Does |
|---|---|
| step arrows, step menu | move between the steps of the scene |
| eye | hide or show the object of the current step |
| Branch / Diffuse | show one realisation, or all of them overlaid |
| branch arrows | page through the realisations of the current step |
| Fixed | keep the current branch for the later steps |

Diffuse draws every realisation at once, the more often a vertex is used the stronger; Branch follows one construction to the end. Without Fixed every step is solved over all branches of the earlier ones, and their number multiplies.

<code>[InfraSceneViewer]()[*data*]</code> reads the saved states and events and samples nothing. It shows the bindings of a state, the events into it and its neighbours in the [InfraBranchialGraph]().

| Option | Default |
|---|---|
| `"OpacityRange"`, `"ThicknessRange"`, `"PointSizeRange"` | those of [InfraSubstrateHighlight]() |
| [ImageSize]() | 500 |

[InfraScenePlot]() draws one instance as a static figure.

## Basic Examples

Euclid I.1 on the square mesh, step by step:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 3], RandomSeeding -> 2]},
  {scene = InfraScene[{pA, pB, cA, cB, meet},
     {InfraSceneStep[{pA == InfraPoint[a], pB == InfraPoint[b]}, "two points"],
      InfraSceneStep[{cA == InfraCircle[pA, 3]}, "circle about A"], InfraSceneStep[{cB == InfraCircle[pB, 3]}, "circle about B"],
      InfraSceneStep[{meet == InfraPoint[InfraIntersection[cA, cB]]}, "where they meet"]}]},
  InfraSceneViewer[scene, g]]
```

The states of a multiway exploration, browsed:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
  {scene = InfraScene[{pA, pB, seg}, {pA == InfraPoint[a], pB == InfraPoint[b], seg == InfraSegment[pA, pB]}]},
  InfraSceneViewer[InfraSceneMultiway[scene, g]]]
```
