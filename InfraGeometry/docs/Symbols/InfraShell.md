---
Template: Symbol
Name: InfraShell
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraShell
Keywords: [shell, sphere, level set, scene token, construction]
SeeAlso: [FindInfraShell, InfraBall, InfraScene, FindInfraScene, InfraShellQ, ShellAreas]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

<code>[InfraShell]()[*x*, *r*]</code> inside an [InfraScene]() is the shell of radius *r* about the object *x*.

<code>[InfraShell]()[*x*, {*rmin*, *rmax*}]</code> is the band of radii from *rmin* to *rmax*.

<code>[InfraShell]()[*x*, *r*, *opts*]</code> passes the options of [FindInfraShell]() on.

## Details & Options

Definition: the shell of radius *r* about *c* is *S_r(c) = {v : d(c, v) = r}*, a level set of the distance from *c*; the band is *{v : rmin ≤ d(c, v) ≤ rmax}*.

`InfraShell` is a scene token. It names the shell in a construction `x == InfraShell[y, r]`, where *y* is an object of the scene, and [FindInfraScene]() solves it: each branch binds *x* to one realisation, a sorted vertex list. Without `Properties` the realisation is the whole level set, so the token adds no branches. With `Properties -> {"Separating"}` the realisations are the minimal subsets of the shell that separate *y* from the outside, one branch each.

A shell itself is a sorted vertex list, and [FindInfraShell]() computes it. Outside a scene the head is inert.

The shell is the sphere of the graph metric and the probe of the shell-area measurement. [ShellAreas]() counts shells at every radius without building them.

## Basic Examples

The shells of radius 2 about two points two steps apart on a grid, and the two vertices where they meet, one per branch.

```wl
ClearAll[pA, pB, shellA, shellB, meet];
With[
  {g = GridGraph[{9, 9}]},
  {constr = InfraScene[{pA, pB, shellA, shellB, meet},
     {pA == InfraPoint[41], pB == InfraPoint[43],
      shellA == InfraShell[pA, 2], shellB == InfraShell[pB, 2],
      meet == InfraIntersection[shellA, shellB]}]},
  With[{solved = FindInfraScene[constr, g]},
    InfraSubstrateHighlight[g,
      Join[{InfraSceneInstance[First @ solved, shellA] -> $InfraShellColor,
            InfraSceneInstance[First @ solved, shellB] -> $InfraCircleColor,
            Directive[$InfraPointColor]},
        InfraSceneInstance[#, meet] & /@ solved],
      ImageSize -> 250]]]
```

The meeting vertices.

```wl
ClearAll[pA, pB, shellA, shellB, meet];
With[
  {g = GridGraph[{9, 9}]},
  {constr = InfraScene[{pA, pB, shellA, shellB, meet},
     {pA == InfraPoint[41], pB == InfraPoint[43],
      shellA == InfraShell[pA, 2], shellB == InfraShell[pB, 2],
      meet == InfraIntersection[shellA, shellB]}]},
  InfraSceneInstance[#, meet] & /@ FindInfraScene[constr, g]]
```

## Scope

A band of radii 2 to 3 about the centre: the two shells together.

```wl
ClearAll[pA, shellA];
With[
  {g = GridGraph[{9, 9}]},
  {constr = InfraScene[{pA, shellA}, {pA == InfraPoint[41], shellA == InfraShell[pA, {2, 3}]}]},
  InfraSceneInstance[First @ FindInfraScene[constr, g], shellA] === Union[FindInfraShell[g, 41, 2], FindInfraShell[g, 41, 3]]]
```

## Properties and Relations

The shell bound in the scene is the one [FindInfraShell]() computes.

```wl
ClearAll[pA, shellA];
With[
  {g = GridGraph[{9, 9}]},
  {constr = InfraScene[{pA, shellA}, {pA == InfraPoint[41], shellA == InfraShell[pA, 3]}]},
  InfraSceneInstance[First @ FindInfraScene[constr, g], shellA] === FindInfraShell[g, 41, 3]]
```
