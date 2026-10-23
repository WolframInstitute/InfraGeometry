---
Template: Symbol
Name: InfraPlane
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraPlane
Keywords: [plane, hyperplane, bisector, perpendicular bisector, separator, symbolic object]
SeeAlso: [RandomInfraPlane, InfraPlaneQ, FindInfraBisectingHyperplane, InfraPerpendicularBisector, InfraScene]
---

## Usage

<code>[InfraPlane]()[*p*, *q*]</code> is the bisecting plane of *p* and *q*: the family of the minimal vertex sets equidistant from *p* and *q* that separate them.

<code>[InfraPlane]()[*p*, *q*, {*lo*, *hi*}]</code> takes the vertices *v* with *lo ≤ d(p, v) − d(q, v) ≤ hi* in place of the equidistant ones.

## Details & Options

A member of <code>[InfraPlane]()[*p*, *q*]</code> is a vertex set *H* in the bisector *{v : d(p, v) = d(q, v)}* such that every path from *p* to *q* meets *H*, and no smaller subset of *H* does.

In space the perpendicular bisector of two points is a hyperplane and cuts space into two half-spaces. On a graph the bisector can be thick, empty or not separating, so the plane is a thin separating part of it, and need not be unique.

| Case | Bisector | Plane |
|---|---|---|
| square grid, *p* and *q* on one axis at even distance | the line between them | that line without its two rim vertices |
| square grid, *p* and *q* diagonal neighbours | two opposite quadrants | many, of different shapes |
| square grid, odd distance | empty | none; the window {−1, 1} gives one |
| square mesh | need not separate | can be none; the window {−1, 1} gives one |
| *p* and *q* adjacent | | none: nothing separates them |

A plane need not be connected. In the bisector *B* without *p* and *q*, a wall is a set *W ⊆ B* that separates *p* from *q*, induces a connected subgraph, and has no proper subset that does both; a connected plane is a wall. [RandomInfraPlane]() with `Properties -> {"Separating", "Connected"}` draws walls instead of planes, by a greedy search.

[InfraPlane]() is a symbolic object: [RandomInfraPlane]() draws members, [InfraPlaneQ]() tests a vertex set, and in an [InfraScene]() <code>[InfraPlane]()[*p*, *q*]</code> is a construction whose realisations are the members. The whole bisector is [FindInfraBisectingHyperplane]() or [InfraPerpendicularBisector]().

## Basic Examples

A plane between the centre and a vertex at distance 4. On the mesh the bisector does not separate, so the window is {−1, 1}:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[First @ spec, "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
    {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {RandomInfraPlane[g, InfraPlane[a, b, Last @ spec], RandomSeeding -> 1], a, b}]],
  {spec, {{"SquareGridGraph", {0, 0}}, {"SquareMeshGraph", {-1, 1}}}}]
```

Two points on one axis of the grid. The bisector is the line between them; the plane, drawn over it, leaves out its two rim vertices, which have one neighbour each:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {bisector = FindInfraBisectingHyperplane[g, 45, 47], planes = RandomInfraPlane[g, InfraPlane[45, 47], All]},
  InfraSubstrateHighlight[g, {bisector, planes, 45, 47}, ImageSize -> Medium]]
```

In a scene the plane is a construction:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {scene = InfraScene[{pA, pB, h}, {pA == InfraPoint[45], pB == InfraPoint[47], h == InfraPlane[pA, pB]}]},
  RandomInfraSceneInstance[scene, g, All]]
```

## Scope

The plane need not be unique. Three planes between 45 and its diagonal neighbour 56:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {RandomInfraPlane[g, InfraPlane[45, 56], RandomSeeding -> s], 45, 56}], {s, 3}]]
```

There are 1369 of them, of 8, 9 or 10 vertices:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, Counts[Length /@ RandomInfraPlane[g, InfraPlane[45, 56], All]]]
```

## Properties and Relations

For an axis pair the plane is connected and is the only wall; for the diagonal pair no plane is connected, and there is no wall:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {walls = Properties -> {"Separating", "Connected"}},
  {RandomInfraPlane[g, InfraPlane[45, 47], All] === RandomInfraPlane[g, InfraPlane[45, 47], All, walls],
   RandomInfraPlane[g, InfraPlane[45, 56], All, walls]}]
```

A wall and a plane in the slab {−1, 1} on the mesh:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {RandomInfraPlane[g, InfraPlane[a, b, {-1, 1}], props, RandomSeeding -> 1], a, b}],
    {props, {Properties -> {"Separating", "Connected"}, Properties -> {"Separating"}}}]]
```

## Possible Issues

At odd distance on the grid no vertex is equidistant, and there is no plane; the window {−1, 1} gives one:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {RandomInfraPlane[g, InfraPlane[45, 48], RandomSeeding -> 1],
   RandomInfraPlane[g, InfraPlane[45, 48, {-1, 1}], RandomSeeding -> 1]}]
```

Adjacent vertices have no plane, whatever the window:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, RandomInfraPlane[g, InfraPlane[45, 46, {-1, 1}], All]]
```
