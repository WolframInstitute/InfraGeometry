---
Template: Symbol
Name: InfraCircle
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraCircle
Keywords: [circle, radius, band, separating cycle, necklace, seam, inert head]
SeeAlso: [FindInfraCircle, InfraArc, InfraMeasurement, FindInfraRepresentative, Undetermined, InfraShell]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraCircle]()[*c*, *r*]</code> is the family of circles around *c* at radius *r*. It is inert; [InfraMeasurement]() and [FindInfraRepresentative]() evaluate it on a graph.

<code>[InfraCircle]()[*c*, {*r*, *s*}]</code> is the family in the band *r* ≤ *d(c, v)* ≤ *s*; a scalar *r* means `{r, r}`.

The same expression inside an [InfraScene]() is the circle construction token; [FindInfraCircle]() is the search.

## Details & Options

Definition: a circle of the band *W* around *c* is a shortest cycle of the subgraph induced on *W* whose removal leaves *c* in a component that reaches no further than the band.

The second argument is always a radius or a band, never a point, so a vertex label that is an integer or a pair cannot be mistaken for one. There are no options.

Euclid's third postulate describes a circle with any centre and distance: the circle is named by its radius. The circle through a point *p* is drawn by a compass opened to *p*, an arc that closes: it is the closed arc <code>[InfraArc]()[*c*, {*p*, *p*}]</code>, the circles of the band of *p* that pass through *p*.

**A circle need not exist.** On a lattice a single distance shell has no two adjacent vertices, so it spans no cycle and the family is empty. Widening the radius to a band fixes it.

Its graph — <code>[InfraMeasurement]()[*g*, *circle*, "Graph"]</code> — is a `List` of necklaces, cut from the band along a radial seam: a shortest path from *c* to just outside the band. A necklace is a DAG with one source *s1* and one sink *u*. It is the cycle family **opened** at its closing arrow *u* -> *s1*, which is left out, so the DAG is acyclic.

A member is the open chain *s1* … *u*, read cyclically: a cyclic vertex list whose first vertex is not repeated. Its `"Length"` counts the closing edge too, so a circle of *k* vertices has length *k*.

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

At a single radius the square tiling has no circle: the shell has no two adjacent vertices. The band `{4, 5}` is the fix.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {InfraSubstrateHighlight[g, {FindInfraShell[g, c, 4] -> $InfraShellColor, Directive[$InfraPointColor], c}],
   InfraMeasurement[g, InfraCircle[c, 4], "Cardinality"]}]
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

[FindInfraCircle]() searches the band directly and finds as many circles.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {circle = InfraCircle[c, {2, 4}]},
  {InfraSubstrateHighlight[g, {circle -> $InfraCircleColor, Directive[$InfraPointColor], c}],
   InfraMeasurement[g, circle, "Cardinality"], Length @ FindInfraCircle[g, c, {2, 4}, All]}]
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
