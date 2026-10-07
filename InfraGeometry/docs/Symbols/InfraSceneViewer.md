---
Template: Symbol
Name: InfraSceneViewer
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSceneViewer
Keywords: [viewer, interactive, construction, step, branch]
SeeAlso: [InfraScene, FindInfraScene, InfraSubstrateHighlight, InfraSceneInstance, InfraStep]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraSceneViewer]()[*scene*, *graph*]</code> is an interactive view of an [InfraScene]() on a graph, stepped one construction step at a time.

<code>[InfraSceneViewer]()[*scene*, *graph*, *bindings*]</code> starts from an association of pre-fixed bindings.

## Details & Options

Definition: the viewer solves the scene one step at a time and draws the objects bound so far, through [InfraSubstrateHighlight]().

It exists because a construction is a sequence, not a picture. Reading Euclid I.10 as a single figure hides the order; stepping it shows which object each later one depends on.

Controls, in two rows.

| Control | Does |
|---|---|
| step arrows, label menu | move between construction steps |
| eye | hide or show the current step's object |
| Branch / Diffuse | show one realisation, or all of them overlaid |
| branch arrows | page through realisations of the current step |
| Fixed | lock the current branch as the starting point for later steps |

Branch and Diffuse are the two ways to look at a family. Diffuse draws every realisation at once, with intensity following multiplicity, which is the right view for seeing where an object is concentrated. Branch picks one, which is the right view for following a single construction through to the end.

Fixed matters on long constructions. Without it, each step re-solves against every branch of the previous ones and the instance count multiplies. Fixing a branch collapses that.

The rendering options `"OpacityRange"`, `"ThicknessRange"`, `"PointSizeRange"` and `ImageSize` are passed through to [InfraSubstrateHighlight]().

For a static figure, solve the steps yourself with [FindInfraScene]() and lay them out as a grid. That is what the last example does.

## Basic Examples

Build a scene and open the viewer on it. The slider steps through the construction.

```wl
ClearAll[a, b, cA, cB, u];
With[
  {g = InfraSubstrate["SquareMeshGraph", "Medium", "KeepCoordinates" -> True]},
  {p1 = First @ GraphCenter[g]},
  {p2 = (SeedRandom[1]; FindInfraPoint[g, InfraShell[p1, 4]])},
  {scene = InfraScene[{a, b, cA, cB, u},
     {InfraStep[{a == InfraPoint[p1]}, "point a"],
      InfraStep[{b == InfraPoint[p2]}, "point b"],
      InfraStep[{cA == InfraCircle[a, 4]}, "circle around a"],
      InfraStep[{cB == InfraCircle[b, 4]}, "circle around b"],
      InfraStep[{u == InfraIntersection[cA, cB]}, "they meet"]}]},
  InfraSceneViewer[scene, g]]
```

The first steps as stills: the two points, then the circle about the first. This is what the viewer shows as you step, drawn without the interface.

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Medium", "KeepCoordinates" -> True]},
  {p1 = First @ GraphCenter[g]},
  {p2 = (SeedRandom[1]; FindInfraPoint[g, InfraShell[p1, 4]])},
  {circles = FindInfraRepresentative[g, InfraCircle[p1, 4], All]},
  Row[{
    Labeled[InfraSubstrateHighlight[g, {{p1, p2}}], "points a and b"],
    Labeled[
      InfraSubstrateHighlight[g,
        {Table[Graph[DirectedEdge @@@ Partition[circle, 2, 1, 1]], {circle, circles}],
         {p1, p2}}],
      "circle around a"]}]]
```
