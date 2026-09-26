---
Template: Symbol
Name: FindInfraCircle
Context: WolframInstitute`SyntheticInfrageometry`
ContextPath: [WolframInstitute`Infrageometry`]
Paclet: WolframInstitute/SyntheticInfrageometry
URI: WolframInstitute/SyntheticInfrageometry/ref/FindInfraCircle
Keywords: [circle, band, separating cycle, girth, Euclid Postulate 3]
SeeAlso: [InfraCircle, InfraVertexList, FindInfraShell, FindInfraBall, InfraCircleQ, FindInfraArc]
RelatedGuides: [EuclideanGeometryGuide]
---

## Usage

<code>[FindInfraCircle]()[*g*, *c*, *p*]</code> gives one circle around *c* through the point *p* in *g*, as a cyclic vertex list.

<code>[FindInfraCircle]()[*g*, *c*, "Radius" -> *r*]</code> gives one circle around *c* at radius *r*; `"Radius" -> {r, s}` takes the band *r* ≤ *d(c, v)* ≤ *s*.

<code>[FindInfraCircle]()[*g*, *c*, *spec*, *n*]</code> gives a `List` of exactly *n* circles or `$Failed`; `UpTo[n]` gives up to *n*; `All` gives every circle.

## Details & Options

The band around *c* is $\{v : r \le d(c,v) \le s\}$. A circle is a shortest cycle of the subgraph induced on the band whose removal leaves *c* in a component reaching no further than the band. The point form takes the band at *d(c, p)* and keeps the circles through *p*.

A circle is returned as a cyclic vertex list: the edge from the last vertex back to the first is implicit, and the first vertex is not repeated.

**A circle need not exist.** On a lattice a single distance shell contains no two adjacent vertices, so it spans no cycle at all and the result is empty. This is not a defect of the definition — it is what a sphere of one-vertex thickness is on a lattice.

Thickening the radius to a band fixes it, and **the band thickness that suffices tracks the girth of the tiling**. On the square grid, girth 4, a two-thick band `{r, r+1}` already carries a cycle. On the hexagonal tiling, girth 6, it does not: `{r, r+1}` is still empty and the band has to reach `{r, r+2}`. On an irregular mesh a single shell usually works, since its vertices are adjacent by accident of the triangulation.

The search sweeps the band directly, length by length with `FindCycle`. It does not read the necklaces of <code>[InfraCircle]()[*c*, …]</code>, so it is the check on them, and it still answers where no seam cuts the band open, or where nothing lies beyond the band and separation is vacuous. It returns exactly the shapes [InfraVertexList]() gives for that head. To count circles without enumerating them, use [InfraMeasurement]().

Option `"RadiusDelta" -> {deltaIn, deltaOut}` widens the band of the point form to *d(c, p)* − *deltaIn* ≤ *d(c, v)* ≤ *d(c, p)* + *deltaOut*. A scalar `"RadiusDelta" -> delta` means `{0, delta}`, outward only. The default is `0`. There is no `Method` and no `Properties`.

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Postulate 3 | To draw a circle with any center and radius. |
| Hilbert | (not primitive) | Circles are defined from congruence, not postulated. |
| Tarski | Equidistance | The locus of points equidistant from a centre, from the four-place congruence relation. |
| Birkhoff | Ruler postulate | The locus at fixed ruler distance from a point. |

## Basic Examples

At a single radius the circle exists on the irregular mesh and is empty on both lattices — the shell has no two adjacent vertices to make a cycle from.

```wl
Association @ Table[
   name -> With[
     {g = InfraSubstrate[name, "Medium", "KeepCoordinates" -> True]},
     {c = First @ GraphCenter[g]},
     Length @ FindInfraCircle[g, c, "Radius" -> 4, All]],
   {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]
```

Thickening the radius to a band produces a genuine circle, and the thickness needed follows the girth: `{4, 5}` suffices on the square grid, while the hexagonal tiling needs `{4, 6}`.

```wl
Association @ Table[
   band -> With[
     {g = InfraSubstrate["HexagonalTilingGraph", "Medium", "KeepCoordinates" -> True]},
     {c = First @ GraphCenter[g]},
     Length @ FindInfraCircle[g, c, "Radius" -> band, All]],
   {band, {4, {4, 5}, {4, 6}}}]
```

A circle around the centre of each lattice, at the band each one needs, drawn as its directed cycle.

```wl
Row[Table[
   With[
     {g = InfraSubstrate[First[spec], "Medium", "Gray", "KeepCoordinates" -> True]},
     {c = First @ GraphCenter[g]},
     {circle = FindInfraCircle[g, c, "Radius" -> Last[spec]]},
     Labeled[
       InfraSceneHighlight[g,
         {Graph[DirectedEdge @@@ Partition[circle, 2, 1, 1]] -> $InfraCircleColor, {c} -> $InfraPointColor},
         "PointSizeRange" -> 15,
         VertexShapeFunction -> ({AbsolutePointSize[2.2], Point[#]} &),
         ImageSize -> 250],
       Text[First[spec] <> ", band " <> ToString[Last[spec]]]]],
   {spec, {{"SquareTilingGraph", {4, 5}}, {"HexagonalTilingGraph", {4, 6}}}}]]
```

## Scope

Sixteen circles lie in the band `{2, 4}` around the centre of a 9 × 9 grid. A bounded count gives a list, and a strict count that cannot be met is `$Failed`.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {Length @ FindInfraCircle[g, 41, "Radius" -> {2, 4}, All],
   Length @ FindInfraCircle[g, 41, "Radius" -> {2, 4}, 3],
   FindInfraCircle[g, 41, "Radius" -> {2, 4}, 20]}]
```

The count-less call is one circle, the same every time.

```wl
FindInfraCircle[GridGraph[{9, 9}], 41, "Radius" -> {2, 4}]
```

The point form: a circle through a vertex at distance 2 from the centre of a 5 × 5 grid, the band widened one step outward.

```wl
FindInfraCircle[GridGraph[{5, 5}], 13, 7, "RadiusDelta" -> 1]
```

## Properties and Relations

A circle lies in its band, and its last vertex is adjacent to its first.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {circle = FindInfraCircle[g, 41, "Radius" -> {2, 4}]},
  {SubsetQ[FindInfraShell[g, 41, {2, 4}], circle], EdgeQ[g, UndirectedEdge[Last @ circle, First @ circle]]}]
```

The search finds as many circles as the head counts.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {Length @ FindInfraCircle[g, 41, "Radius" -> {2, 4}, All],
   InfraMeasurement[g, InfraCircle[41, "Radius" -> {2, 4}], "Cardinality"]}]
```
