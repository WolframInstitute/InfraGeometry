---
Template: Symbol
Name: InfraIntersectQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraIntersectQ
Keywords: [intersect, meet, incidence, assertion, scene]
SeeAlso: [InfraScene, InfraIntersection, RandomInfraSceneInstance, IntersectingQ]
---

## Usage

<code>[InfraIntersectQ]()[*x*, *y*]</code> is, in an [InfraScene](), the assertion that the objects *x* and *y* share a vertex.

## Details & Options

The assertion holds on a branch when the realisations of *x* and *y* have a common vertex: on vertex lists it is [IntersectingQ](). It waits until *x* and *y* are realised, which is why it is written instead of [IntersectingQ]() itself.

The meeting point is <code>[InfraIntersection]()[*x*, *y*]</code>; the assertion only asks that it is not empty.

## Basic Examples

The points whose shell of radius 2 meets the shell of radius 2 about the centre. On the mesh they are the ball of radius 4; on the grid, which is bipartite, only the points at even distance up to 4, 25 of them:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {scene = InfraScene[{pA, pB, sA, sB},
       {pA == InfraPoint[c], pB == InfraPoint[], sA == InfraShell[pA, 2], sB == InfraShell[pB, 2],
        InfraIntersectQ[sA, sB]}]},
    {ends = InfraSceneInstance[#, pB] & /@ RandomInfraSceneInstance[scene, g, All]},
    InfraSubstrateHighlight[g, {ends, c}, PlotLabel -> Length[ends]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Properties and Relations

On the mesh the points found are the ball of radius 4:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB, sA, sB},
     {pA == InfraPoint[c], pB == InfraPoint[], sA == InfraShell[pA, 2], sB == InfraShell[pB, 2],
      InfraIntersectQ[sA, sB]}]},
  Sort[InfraSceneInstance[#, pB] & /@ RandomInfraSceneInstance[scene, g, All]] ===
    Keys @ InfraMeasurement[g, InfraBall[c, 4], "VertexDensity"]]
```
