---
Template: Symbol
Name: InfraSceneViewer
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSceneViewer
Keywords: [viewer, interactive, construction, step, branch]
SeeAlso: [InfraScene, InfraScenePlot, RandomInfraSceneInstance, InfraSceneStep, InfraSubstrateHighlight]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraSceneViewer]()[*scene*, *g*]</code> is an interactive view of the construction *scene* on the graph *g*, one step at a time.

<code>[InfraSceneViewer]()[*scene*, *g*, *init*]</code> starts from the bindings in the association *init*.

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
