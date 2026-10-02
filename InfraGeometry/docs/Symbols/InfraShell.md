---
Template: Symbol
Name: InfraShell
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraShell
Keywords: [shell, sphere, level set, region, inert head, area]
SeeAlso: [FindInfraShell, InfraBall, InfraSphere, InfraMeasurement, FindInfraRepresentative, InfraShellQ, ShellAreas]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

<code>[InfraShell]()[*c*, {*r*, *s*}]</code> is the shell about *c*: the vertices at distance between *r* and *s*. It is inert; [InfraMeasurement]() and [FindInfraRepresentative]() evaluate it on a graph.

<code>[InfraShell]()[*c*, *r*]</code> is the band {*r*, *r*}: the vertices at distance exactly *r*.

<code>[InfraShell]()[*c*, *r*]</code> inside an [InfraScene]() is the shell construction token.

## Details & Options

Definition: the shell of radius *r* about *c* is *S_r(c) = {v : d(c, v) = r}*, a level set of the distance from *c*; the band is *{v : r ≤ d(c, v) ≤ s}*. *c* is a vertex or a vertex list, and then *d(v, C) = min d(v, c)*.

The head holds the centre and the band and computes nothing. A shell has one member, the vertex set, so [FindInfraRepresentative]() gives it as a sorted vertex list. It owns the same nine properties as [InfraBall](), `"Volume"` among them; the shell area *A(r)* is the `"Volume"` of the shell.

A shell is a set of points. The connected subsets of it that separate the centre from the outside are the family [InfraSphere]().

[FindInfraShell]() is the level set as a function; [ShellAreas]() counts the shells at every radius without building them.

## Basic Examples

The shells of radius 2 to 5 about the centre of the square, hexagonal and triangular tilings: nested rings, one colour each.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = InfraCenter[g]},
    InfraSubstrateHighlight[g, Table[InfraShell[c, r], {r, 2, 5}]]],
  {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]
```

The shell about two vertices at once.

```wl
FindInfraRepresentative[PathGraph[Range[7]], InfraShell[{1, 7}, 1]]
```

## Scope

A band of radii 2 to 4 is one vertex set.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  InfraSubstrateHighlight[g, {InfraShell[c, {2, 4}] -> $InfraShellColor, Directive[$InfraPointColor], c}]]
```

## Properties and Relations

The shell area is the `"Volume"` of the head. On the square grid it is *4 r*.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium"]},
  {c = InfraCenter[g]},
  Table[InfraMeasurement[g, InfraShell[c, r], "Volume"], {r, 1, 6}] === ShellAreas[g, c, {1, 6}]]
```

Inside a scene the token names the shell about a point, and [FindInfraScene]() binds it to the same vertex set. Two shells meet in a few vertices, one per branch.

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
  InfraSubstrateHighlight[g,
    Join[{InfraSceneInstance[First @ solved, shellA] -> $InfraShellColor,
          InfraSceneInstance[First @ solved, shellB] -> $InfraCircleColor,
          Directive[$InfraPointColor]},
      InfraSceneInstance[#, meet] & /@ solved]]]
```
