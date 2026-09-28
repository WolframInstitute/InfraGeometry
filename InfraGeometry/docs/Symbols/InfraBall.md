---
Template: Symbol
Name: InfraBall
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraBall
Keywords: [ball, disk, neighbourhood, scene token, construction]
SeeAlso: [FindInfraBall, InfraShell, InfraScene, FindInfraScene, InfraBallQ, BallVolumes]
RelatedGuides: [RiemannianGeometryGuide]
---

## Usage

<code>[InfraBall]()[*x*, *r*]</code> inside an [InfraScene]() is the closed ball of radius *r* about the object *x*.

## Details & Options

Definition: the closed ball of radius *r* about *c* is *B_r(c) = {v : d(c, v) ≤ r}*.

`InfraBall` is a scene token. It names the ball in a construction `x == InfraBall[y, r]`, where *y* is an object of the scene, and [FindInfraScene]() solves it: each branch binds *x* to the ball about the vertex *y* stands for, a sorted vertex list. The ball is unique, so the token adds no branches.

A ball itself is a sorted vertex list, and [FindInfraBall]() computes it. Outside a scene the head is inert, and nothing reads it: [InfraMeasurement]() and [InfraVertexList]() take the Euclidean heads, not this one.

Balls are the probe of the volume measurements. [BallVolumes]() counts them at every radius without building them.

## Basic Examples

A ball of radius 2 about the centre of a grid and the shell of radius 2 about a point two steps away. They meet in three vertices, one per branch.

```wl
ClearAll[pA, pB, ballA, shellB, meet];
With[
  {g = GridGraph[{9, 9}]},
  {constr = InfraScene[{pA, pB, ballA, shellB, meet},
     {pA == InfraPoint[41], pB == InfraPoint[43],
      ballA == InfraBall[pA, 2], shellB == InfraShell[pB, 2],
      meet == InfraIntersection[ballA, shellB]}]},
  With[{solved = FindInfraScene[constr, g]},
    InfraHighlightGraph[g,
      Join[{InfraSceneInstance[First @ solved, ballA] -> $InfraBallColor,
            InfraSceneInstance[First @ solved, shellB] -> $InfraCircleColor,
            Directive[$InfraPointColor]},
        InfraSceneInstance[#, meet] & /@ solved],
      ImageSize -> 250]]]
```

The ball bound in the scene is the one [FindInfraBall]() computes.

```wl
ClearAll[pA, ballA];
With[
  {g = GridGraph[{9, 9}]},
  {constr = InfraScene[{pA, ballA}, {pA == InfraPoint[41], ballA == InfraBall[pA, 2]}]},
  InfraSceneInstance[First @ FindInfraScene[constr, g], ballA] === FindInfraBall[g, 41, 2]]
```

## Properties and Relations

A ball about a point that is itself a choice gives one ball per choice: here one for each of the eight vertices at distance 2 from the centre.

```wl
ClearAll[pA, pB, ballB];
With[
  {g = GridGraph[{9, 9}]},
  {constr = InfraScene[{pA, pB, ballB}, {pA == InfraPoint[41], pB == InfraPoint[pA, 2], ballB == InfraBall[pB, 1]}]},
  Length /@ (InfraSceneInstance[#, ballB] & /@ FindInfraScene[constr, g])]
```
