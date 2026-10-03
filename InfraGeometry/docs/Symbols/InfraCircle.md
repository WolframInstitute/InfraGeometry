---
Template: Symbol
Name: InfraCircle
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraCircle
Keywords: [circle, radius, band, separating cycle, necklace, seam, inert head]
SeeAlso: [InfraArc, InfraMeasurement, FindInfraRepresentative, Undetermined, InfraShell, FindInfraShell]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraCircle]()[*c*, *r*]</code> is the family of circles around *c* at radius *r*. It is inert; [InfraMeasurement]() and [FindInfraRepresentative]() evaluate it on a graph.

<code>[InfraCircle]()[*c*, {*r*, *s*}]</code> is the family in the band *r* ≤ *d(c, v)* ≤ *s*; a scalar *r* means `{r, r}`.

The same expression inside an [InfraScene]() is the circle construction token.

## Details & Options

Definition: a circle of the band *W* around *c* is a shortest cycle of the subgraph induced on *W* whose removal leaves *c* in a component that reaches no further than the band.

The second argument is always a radius or a band, never a point, so a vertex label that is an integer or a pair cannot be mistaken for one. There are no options.

Euclid's third postulate describes a circle with any centre and distance: the circle is named by its radius. The circle through a point *p* is drawn by a compass opened to *p*, an arc that closes: it is the closed arc <code>[InfraArc]()[*c*, {*p*, *p*}]</code>, the circles of the band of *p* that pass through *p*.

**A circle need not exist.** On a lattice a single distance shell has no two adjacent vertices, so it spans no cycle and the family is empty. This is what a sphere of one-vertex thickness is on a lattice, not a defect of the definition.

Widening the radius to a band fixes it, and **the band thickness that suffices tracks the girth of the tiling**. On the square tiling, girth 4, the band `{r, r + 1}` already carries a circle. On the hexagonal tiling, girth 6, it does not: the band has to reach `{r, r + 2}`. On the triangular tiling, girth 3, a single shell carries a circle; on an irregular mesh it usually does, its vertices being adjacent by accident of the mesh.

Its graph — <code>[InfraMeasurement]()[*g*, *circle*, "Graph"]</code> — is a `List` of necklaces, cut from the band along a radial seam: a shortest path from *c* to just outside the band. A necklace is a DAG with one source *s1* and one sink *u*. It is the cycle family **opened** at its closing arrow *u* -> *s1*, which is left out, so the DAG is acyclic.

A member is the open chain *s1* … *u*, read cyclically: a cyclic vertex list whose first vertex is not repeated. Its `"Length"` counts the closing edge too, so a circle of *k* vertices has length *k*.

**The search.** <code>[FindInfraRepresentative]()[*g*, *circle*, *n*]</code> sweeps the band directly: for *k* = 3, 4, … it takes every cycle of length *k* of the band (`FindCycle`) and keeps those whose removal leaves *c* in a component reaching no further than the band; the first *k* with a survivor gives the members. It does not read the necklaces, so it is the check on them, and it still answers where no seam cuts the band open, or where nothing lies beyond the band and separation is vacuous. Each length is enumerated in full before the filter, so the sweep is fast on a band one or two vertices thick and does not finish in reasonable time on a wide one, such as `{3, 6}` on the square tiling.

Every member separates. That the necklaces carry every circle exactly once needs two hypotheses on the substrate — the winding functional and the one-run hypothesis — which nothing here certifies. So `"Faithful"` is [Undetermined]().

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Postulate 3 | To draw a circle with any center and radius. |
| Hilbert | (not primitive) | Circles are defined from congruence, not postulated. |
| Tarski | Equidistance | The locus of points equidistant from a centre, from the four-place congruence relation. |
| Birkhoff | Ruler postulate | The locus at fixed ruler distance from a point. |

## Basic Examples

The circles of the band `{2, 4}` about the centre, on the square, hexagonal and triangular tilings. An edge is drawn as strongly as the number of circles through it.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = InfraCenter[g]},
    {circle = InfraCircle[c, {2, 4}]},
    InfraSubstrateHighlight[g, {circle -> $InfraCircleColor, Directive[$InfraPointColor], c}]],
  {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]
```

The band `{2, 4}` on the square tiling: the number of circles, their length and the number of necklaces carrying them, beside the picture.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {circle = InfraCircle[c, {2, 4}]},
  {InfraSubstrateHighlight[g, {circle -> $InfraCircleColor, Directive[$InfraPointColor], c}],
   InfraMeasurement[g, circle, "Cardinality"], InfraMeasurement[g, circle, "Length"],
   Length @ InfraMeasurement[g, circle, "Graph"]}]
```

At a single radius the circle exists on the irregular mesh and not on the two lattices: their shell has no two adjacent vertices. Each picture shows the shell and the circles found in it, labelled by their number.

```wl
Row @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = InfraCenter[g]},
    {circles = FindInfraRepresentative[g, InfraCircle[c, 4], All]},
    Labeled[
      InfraSubstrateHighlight[g,
        {FindInfraShell[g, c, 4] -> $InfraShellColor,
         Table[Graph[DirectedEdge @@@ Partition[oneCircle, 2, 1, 1]], {oneCircle, circles}] -> $InfraCircleColor}],
      Length @ circles]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]
```

The thickness needed follows the girth: on the hexagonal tiling the band `{4, 5}` is still empty, and `{4, 6}` carries the circles.

```wl
Row @ Table[
  With[
    {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
    {c = InfraCenter[g]},
    {circles = FindInfraRepresentative[g, InfraCircle[c, band], All]},
    Labeled[
      InfraSubstrateHighlight[g,
        {FindInfraShell[g, c, band] -> $InfraShellColor,
         Table[Graph[DirectedEdge @@@ Partition[oneCircle, 2, 1, 1]], {oneCircle, circles}] -> $InfraCircleColor}],
      Length @ circles]],
  {band, {4, {4, 5}, {4, 6}}}]
```

One circle about the centre of each lattice, at the band each one needs, drawn as its directed cycle.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[First @ spec, "Small", "KeepCoordinates" -> True]},
    {c = InfraCenter[g]},
    {oneCircle = FindInfraRepresentative[g, InfraCircle[c, Last @ spec]]},
    InfraSubstrateHighlight[g, {Graph[DirectedEdge @@@ Partition[oneCircle, 2, 1, 1]] -> $InfraCircleColor, Directive[$InfraPointColor], c},
      "Arrowheads" -> True]],
  {spec, {{"SquareTilingGraph", {4, 5}}, {"HexagonalTilingGraph", {4, 6}}, {"TriangularTilingGraph", 4}}}]
```

A member is a cyclic vertex list. Drawn as a walk, it closes back on its first vertex.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {closedWalk = FindInfraRepresentative[g, InfraCircle[c, {2, 4}]]},
  InfraSubstrateHighlight[g, {InfraWalk[Append[closedWalk, First @ closedWalk]] -> $InfraCircleColor, Directive[$InfraPointColor], c}]]
```

The circles of the band `{4, 5}` that pass through a vertex at distance 4 are the closed arc through it, [InfraArc]().

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, c, 4])},
  {circle = InfraArc[c, {p, p}, "RadiusDelta" -> 1]},
  {InfraSubstrateHighlight[g, {circle -> $InfraCircleColor, Directive[$InfraPointColor], c, p}],
   InfraMeasurement[g, circle, "Cardinality"], InfraMeasurement[g, circle, "Length"]}]
```

## Scope

Every circle of the band `{2, 4}` on the square tiling, drawn at once. A bounded count gives a list, and a strict count that cannot be met gives `{ }`.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {circle = InfraCircle[c, {2, 4}]},
  {circles = FindInfraRepresentative[g, circle, All]},
  {InfraSubstrateHighlight[g, {Table[Graph[DirectedEdge @@@ Partition[oneCircle, 2, 1, 1]], {oneCircle, circles}] -> $InfraCircleColor}],
   Length @ circles, Length @ FindInfraRepresentative[g, circle, 3], FindInfraRepresentative[g, circle, 20]}]
```

## Properties and Relations

A circle lies in its band, and consecutive vertices are adjacent, the last and the first too.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {band = FindInfraShell[g, c, {2, 4}]},
  {closedWalk = FindInfraRepresentative[g, InfraCircle[c, {2, 4}]]},
  {InfraSubstrateHighlight[g, {band -> $InfraShellColor, InfraWalk[Append[closedWalk, First @ closedWalk]] -> $InfraCircleColor}],
   SubsetQ[band, closedWalk], AllTrue[Partition[closedWalk, 2, 1, 1], EdgeQ[g, UndirectedEdge @@ #] &]}]
```

The search sweeps the band directly and finds as many circles as the necklaces carry.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {circle = InfraCircle[c, {2, 4}]},
  {InfraSubstrateHighlight[g, {circle -> $InfraCircleColor, Directive[$InfraPointColor], c}],
   InfraMeasurement[g, circle, "Cardinality"], Length @ FindInfraRepresentative[g, circle, All]}]
```

A necklace is acyclic: it is the circles opened at their closing arrow, from its one source to its one sink.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {necklace = First @ InfraMeasurement[g, InfraCircle[c, {2, 4}], "Graph"]},
  {InfraSubstrateHighlight[g, {necklace -> $InfraCircleColor, Directive[$InfraPointColor], c}, "Arrowheads" -> True],
   AcyclicGraphQ[necklace], Select[VertexList[necklace], VertexInDegree[necklace, #] == 0 &],
   Select[VertexList[necklace], VertexOutDegree[necklace, #] == 0 &]}]
```
