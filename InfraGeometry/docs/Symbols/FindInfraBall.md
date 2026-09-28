---
Template: Symbol
Name: FindInfraBall
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraBall
Keywords: [ball, disk, volume growth, dimension, neighborhood]
SeeAlso: [InfraBall, FindInfraShell, BallVolumes, InfraBallQ, FindBallHull, FindInfraCircle]
RelatedGuides: [RiemannianGeometryGuide]
---

## Usage

<code>[FindInfraBall]()[*g*, *c*, *r*]</code> gives the closed metric ball $B_r(c) = \{v : d(c,v) \le r\}$ as a sorted vertex list.

## Details & Options

The ball of radius *r* about *c* is $\{v : d(c,v) \le r\}$ — the solid disk of the graph metric, where [FindInfraShell]() is its boundary sphere.

On a flat lattice the volume is an exact polynomial in *r*, and it is the polynomial of the corresponding norm rather than of the Euclidean disk. The square grid gives $2r^2 + 2r + 1$, the $\ell^1$ ball; the hexagonal tiling gives $1 + 3r(r+1)/2$. Both are quadratic, which is the intrinsic statement that the substrate is two-dimensional; the coefficient is what distinguishes the tilings.

That quadratic growth is what the dimension estimators read: [BallVolumes]() counts the balls at every radius at once, and [LogDifferenceQuotients]() and [DimensionCurvatureFit]() read the exponent. The log-difference quotient of the volume sequence converges to 2 on either lattice, and the anisotropy of the ball — square rather than round — is a genuine feature of the substrate, not an artefact.

A vertex list or a density as the centre gives the closed *r*-neighbourhood of the whole anchor: one vertex set, not one ball per centre.

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Postulate 3 | To draw a circle with any center and radius; the ball is the region it bounds. |
| Tarski | A11, continuity | The continuity axiom is stated over the interiors this bounds. |
| Birkhoff | Ruler postulate | The set within a fixed ruler distance of a point. |

## Basic Examples

The ball of radius 4 on each substrate. It is a diamond on the square grid, not a disk: the metric is $\ell^1$ and the ball shows it.

```wl
Row[Table[
   With[
     {g = InfraSubstrate[name, "Medium", "KeepCoordinates" -> True]},
     {c = First @ GraphCenter[g]},
     Labeled[
       InfraHighlightGraph[g,
         {FindInfraBall[g, c, 4] -> $InfraBallColor, {c} -> $InfraPointColor},
         "PointSizeRange" -> 15,
         VertexShapeFunction -> ({AbsolutePointSize[2.2], Point[#]} &),
         ImageSize -> 250],
       Text[name <> ": " <> ToString[Length @ FindInfraBall[g, c, 4]] <> " vertices"]]],
   {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]]
```

Ball volume against radius. Both lattices give exact polynomials, and the square grid's is the $\ell^1$ ball $2r^2+2r+1$.

```wl
Association @ Table[
   name -> With[
     {g = InfraSubstrate[name, "Medium", "KeepCoordinates" -> True]},
     {c = First @ GraphCenter[g]},
     Table[Length @ FindInfraBall[g, c, r], {r, 0, 5}]],
   {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]
```

The square grid's volumes agree with $2r^2+2r+1$ exactly.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  Table[Length @ FindInfraBall[g, c, r], {r, 0, 5}] === Table[2 r^2 + 2 r + 1, {r, 0, 5}]]
```

## Properties and Relations

The ball's size at every radius is the ball-volume profile, which [BallVolumes]() counts without building the balls.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  Table[Length @ FindInfraBall[g, c, r], {r, 0, 5}] === BallVolumes[g, c, {0, 5}]]
```
