---
Template: Symbol
Name: FindInfraCircle
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraCircle
Keywords: [circle, band, separating cycle, girth, Euclid Postulate 3]
SeeAlso: [InfraCircle, FindInfraRepresentative, FindInfraShell, InfraBall, InfraCircleQ, FindInfraArc]
RelatedGuides: [EuclideanInfrageometry]
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

The search sweeps the band directly, length by length with `FindCycle`. It does not read the necklaces of <code>[InfraCircle]()[*c*, …]</code>, so it is the check on them, and it still answers where no seam cuts the band open, or where nothing lies beyond the band and separation is vacuous. It is the clause [FindInfraRepresentative]() uses for that head. To count circles without enumerating them, use [InfraMeasurement]().

Option `"RadiusDelta" -> {deltaIn, deltaOut}` widens the band of the point form to *d(c, p)* − *deltaIn* ≤ *d(c, v)* ≤ *d(c, p)* + *deltaOut*. A scalar `"RadiusDelta" -> delta` means `{0, delta}`, outward only. The default is `0`. There is no `Method` and no `Properties`.

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Postulate 3 | To draw a circle with any center and radius. |
| Hilbert | (not primitive) | Circles are defined from congruence, not postulated. |
| Tarski | Equidistance | The locus of points equidistant from a centre, from the four-place congruence relation. |
| Birkhoff | Ruler postulate | The locus at fixed ruler distance from a point. |

## Basic Examples

A circle about the centre through a vertex two steps away, the band widened one step outward, drawn as a closed walk, beside its length.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, c, 2])},
  {closedWalk = FindInfraCircle[g, c, p, "RadiusDelta" -> 1]},
  {InfraSubstrateHighlight[g, {InfraWalk[Append[closedWalk, First @ closedWalk]] -> $InfraCircleColor, Directive[$InfraPointColor], c, p}],
   Length @ closedWalk}]
```

At a single radius the circle exists on the irregular mesh and is empty on both lattices: the shell has no two adjacent vertices to make a cycle from. Each picture shows the shell and the circles found in it, labelled by their number.

```wl
Row @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = InfraCenter[g]},
    {circles = FindInfraCircle[g, c, "Radius" -> 4, All]},
    Labeled[
      InfraSubstrateHighlight[g,
        {FindInfraShell[g, c, 4] -> $InfraShellColor,
         Table[Graph[DirectedEdge @@@ Partition[circle, 2, 1, 1]], {circle, circles}] -> $InfraCircleColor}],
      Length @ circles]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]
```

Thickening the radius to a band produces a genuine circle, and the thickness needed follows the girth: the hexagonal tiling needs the band `{4, 6}`.

```wl
Row @ Table[
  With[
    {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
    {c = InfraCenter[g]},
    {circles = FindInfraCircle[g, c, "Radius" -> band, All]},
    Labeled[
      InfraSubstrateHighlight[g,
        {FindInfraShell[g, c, band] -> $InfraShellColor,
         Table[Graph[DirectedEdge @@@ Partition[circle, 2, 1, 1]], {circle, circles}] -> $InfraCircleColor}],
      Length @ circles]],
  {band, {4, {4, 5}, {4, 6}}}]
```

A circle around the centre of each lattice, at the band each one needs, drawn as its directed cycle.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[First @ spec, "Small", "KeepCoordinates" -> True]},
    {c = InfraCenter[g]},
    {circle = FindInfraCircle[g, c, "Radius" -> Last @ spec]},
    InfraSubstrateHighlight[g, {Graph[DirectedEdge @@@ Partition[circle, 2, 1, 1]] -> $InfraCircleColor, Directive[$InfraPointColor], c},
      "Arrowheads" -> True]],
  {spec, {{"SquareTilingGraph", {4, 5}}, {"HexagonalTilingGraph", {4, 6}}, {"TriangularTilingGraph", 4}}}]
```

## Scope

The band `{2, 4}` around the centre of the square tiling, every circle in it drawn at once. A bounded count gives a list, and a strict count that cannot be met is `$Failed`.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {circles = FindInfraCircle[g, c, "Radius" -> {2, 4}, All]},
  {InfraSubstrateHighlight[g, {Table[Graph[DirectedEdge @@@ Partition[circle, 2, 1, 1]], {circle, circles}] -> $InfraCircleColor}],
   Length @ circles, Length @ FindInfraCircle[g, c, "Radius" -> {2, 4}, 3], FindInfraCircle[g, c, "Radius" -> {2, 4}, 20]}]
```

The count-less call is one circle, the same every time.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {closedWalk = FindInfraCircle[g, c, "Radius" -> {2, 4}]},
  {InfraSubstrateHighlight[g, {InfraWalk[Append[closedWalk, First @ closedWalk]] -> $InfraCircleColor, Directive[$InfraPointColor], c}],
   closedWalk}]
```

The point form on the triangular tiling: a circle through a vertex at distance 2 from the centre.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, c, 2])},
  {closedWalk = FindInfraCircle[g, c, p]},
  {InfraSubstrateHighlight[g, {InfraWalk[Append[closedWalk, First @ closedWalk]] -> $InfraCircleColor, Directive[$InfraPointColor], c, p}],
   closedWalk}]
```

## Properties and Relations

A circle lies in its band, and its last vertex is adjacent to its first.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {band = FindInfraShell[g, c, {2, 4}]},
  {closedWalk = FindInfraCircle[g, c, "Radius" -> {2, 4}]},
  {InfraSubstrateHighlight[g, {band -> $InfraShellColor, InfraWalk[Append[closedWalk, First @ closedWalk]] -> $InfraCircleColor}],
   SubsetQ[band, closedWalk], EdgeQ[g, UndirectedEdge[Last @ closedWalk, First @ closedWalk]]}]
```

The search finds as many circles as the head counts.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {circle = InfraCircle[c, "Radius" -> {2, 4}]},
  {InfraSubstrateHighlight[g, {circle -> $InfraCircleColor, Directive[$InfraPointColor], c}],
   Length @ FindInfraCircle[g, c, "Radius" -> {2, 4}, All], InfraMeasurement[g, circle, "Cardinality"]}]
```
