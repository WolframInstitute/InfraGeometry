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

The shells of radius 2 about the centre and about a point two steps away, and the vertices where they meet, one per branch.

```wl
ClearAll[pA, pB, shellA, shellB, meet];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, c, 2])},
  {constr = InfraScene[{pA, pB, shellA, shellB, meet},
     {pA == InfraPoint[c], pB == InfraPoint[b],
      shellA == InfraShell[pA, 2], shellB == InfraShell[pB, 2],
      meet == InfraIntersection[shellA, shellB]}]},
  {solved = FindInfraScene[constr, g]},
  {InfraSubstrateHighlight[g,
     Join[{InfraSceneInstance[First @ solved, shellA] -> $InfraShellColor,
           InfraSceneInstance[First @ solved, shellB] -> $InfraCircleColor,
           Directive[$InfraPointColor]},
       InfraSceneInstance[#, meet] & /@ solved]],
   InfraSceneInstance[#, meet] & /@ solved}]
```

The same construction on the square, hexagonal and triangular tilings.

```wl
ClearAll[pA, pB, shellA, shellB, meet];
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = InfraCenter[g]},
    {b = (SeedRandom[1]; RandomInfraPoint[g, c, 2])},
    {constr = InfraScene[{pA, pB, shellA, shellB, meet},
       {pA == InfraPoint[c], pB == InfraPoint[b],
        shellA == InfraShell[pA, 2], shellB == InfraShell[pB, 2],
        meet == InfraIntersection[shellA, shellB]}]},
    {solved = FindInfraScene[constr, g]},
    InfraSubstrateHighlight[g,
      Join[{InfraSceneInstance[First @ solved, shellA] -> $InfraShellColor,
            InfraSceneInstance[First @ solved, shellB] -> $InfraCircleColor,
            Directive[$InfraPointColor]},
        InfraSceneInstance[#, meet] & /@ solved]]],
  {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]
```

## Scope

A band of radii 2 to 3 about the centre: the two shells together.

```wl
ClearAll[pA, shellA];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {constr = InfraScene[{pA, shellA}, {pA == InfraPoint[c], shellA == InfraShell[pA, {2, 3}]}]},
  {band = InfraSceneInstance[First @ FindInfraScene[constr, g], shellA]},
  {InfraSubstrateHighlight[g, {band -> $InfraShellColor, Directive[$InfraPointColor], c}],
   band === Union[FindInfraShell[g, c, 2], FindInfraShell[g, c, 3]]}]
```

## Properties and Relations

The shell bound in the scene is the one [FindInfraShell]() computes.

```wl
ClearAll[pA, shellA];
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {constr = InfraScene[{pA, shellA}, {pA == InfraPoint[c], shellA == InfraShell[pA, 3]}]},
  {shell = InfraSceneInstance[First @ FindInfraScene[constr, g], shellA]},
  {InfraSubstrateHighlight[g, {shell -> $InfraShellColor, Directive[$InfraPointColor], c}],
   shell === FindInfraShell[g, c, 3]}]
```
