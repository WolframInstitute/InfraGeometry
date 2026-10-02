---
Template: Symbol
Name: FindBallHull
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindBallHull
---

## Usage

`FindBallHull[graph, S]` returns the ball hull of S as a sorted vertex list: the intersection of all closed balls containing S, the smallest ball-convex (Mazur) superset.

## Details & Options

S is any Infra* object, a list of them, or a bare vertex list.


The hull of a set already contained in a ball of radius $r$ is contained in that ball; the hull of three vertices of a shell is smaller than the ball they lie on.

## Basic Examples

The ball hull of three vertices of the shell of radius 5, on the irregular mesh, the square grid and the hexagonal tiling, inside the ball they lie on.

```wl
Row[Table[
   With[
     {g = InfraSubstrate[name, "Large", "KeepCoordinates" -> True]},
     {c = First @ GraphCenter[g]},
     {shell = FindInfraShell[g, c, 5]},
     {s = shell[[ {1, Round[Length[shell] / 3], Round[2 Length[shell] / 3]} ]]},
     {hull = FindBallHull[g, s]},
     Labeled[
       InfraSubstrateHighlight[g,
         {FindInfraRepresentative[g, InfraBall[c, 5]] -> $InfraBallColor, hull -> $InfraCircleColor, s -> $InfraPointColor},
         "PointSizeRange" -> 17,
         VertexShapeFunction -> ({AbsolutePointSize[2.2], Point[#]} &),
         ImageSize -> 250],
       Text[name <> ": " <> ToString[Length @ hull] <> " of " <> ToString[Length @ FindInfraRepresentative[g, InfraBall[c, 5]]] <> " vertices"]]],
   {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]]
```

## Properties and Relations

The hull contains the set, and it is ball-convex: it is its own hull.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Large", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {shell = FindInfraShell[g, c, 5]},
  {s = shell[[ {1, Round[Length[shell] / 3], Round[2 Length[shell] / 3]} ]]},
  {hull = FindBallHull[g, s]},
  {SubsetQ[hull, s], BallHullQ[g, hull]}]
```
