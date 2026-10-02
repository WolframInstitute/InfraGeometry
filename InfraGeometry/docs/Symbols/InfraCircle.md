---
Template: Symbol
Name: InfraCircle
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraCircle
Keywords: [circle, band, separating cycle, necklace, seam, inert head]
SeeAlso: [FindInfraCircle, InfraArc, InfraMeasurement, FindInfraRepresentative, Undetermined, InfraShell]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraCircle]()[*c*, *p*]</code> is the circle around *c* through *p*. It is inert; [InfraMeasurement]() and [FindInfraRepresentative]() evaluate it on a graph.

<code>[InfraCircle]()[*c*, "Radius" -> *r*]</code> is the family of circles around *c* at radius *r*, and <code>[InfraCircle]()[*c*, "Radius" -> {*r*, *s*}]</code> the family in the band *r* ≤ *d(c, v)* ≤ *s*.

<code>[InfraCircle]()[*c*, *r*]</code> inside an [InfraScene]() is the circle construction token by radius; [FindInfraCircle]() is the search.

## Details & Options

Definition: a circle of the band *W* around *c* is a shortest cycle of the subgraph induced on *W* whose removal leaves *c* in a component that reaches no further than the band.

The point form takes the band at *d(c, p)* and keeps the circles through *p*. Option `"RadiusDelta" -> {deltaIn, deltaOut}` widens it to *d(c, p)* − *deltaIn* ≤ *d(c, v)* ≤ *d(c, p)* + *deltaOut*. A scalar `"RadiusDelta" -> delta` means `{0, delta}`, outward only. The default is `0`.

**A circle need not exist.** On a lattice a single distance shell has no two adjacent vertices, so it spans no cycle and the family is empty. Widening the radius to a band fixes it.

Its graph — <code>[InfraMeasurement]()[*g*, *circle*, "Graph"]</code> — is a `List` of necklaces, cut from the band along a radial seam: a shortest path from *c* to just outside the band. A necklace is a DAG with one source *s1* and one sink *u*. It is the cycle family **opened** at its closing arrow *u* -> *s1*, which is left out, so the DAG is acyclic.

A member is the open chain *s1* … *u*, read cyclically: a cyclic vertex list whose first vertex is not repeated. Its `"Length"` counts the closing edge too, so a circle of *k* vertices has length *k*.

Every member separates. That the necklaces carry every circle exactly once needs two hypotheses on the substrate — the winding functional and the one-run hypothesis — which nothing here certifies. So `"Faithful"` is [Undetermined]().

Inside an [InfraScene](), the token `InfraCircle[c, r]` still reads *r* as a radius, unlike the head, where a bare second argument is always a point. This is an open inconsistency.

## Basic Examples

The circles of the band `{2, 4}` about the centre, on the square, hexagonal and triangular tilings. An edge is drawn as strongly as the number of circles through it.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = InfraCenter[g]},
    {circle = InfraCircle[c, "Radius" -> {2, 4}]},
    InfraSubstrateHighlight[g, {circle -> $InfraCircleColor, Directive[$InfraPointColor], c}]],
  {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]
```

The band `{2, 4}` on the square tiling: the number of circles, their length and the number of necklaces carrying them, beside the picture.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {circle = InfraCircle[c, "Radius" -> {2, 4}]},
  {InfraSubstrateHighlight[g, {circle -> $InfraCircleColor, Directive[$InfraPointColor], c}],
   InfraMeasurement[g, circle, "Cardinality"], InfraMeasurement[g, circle, "Length"],
   Length @ InfraMeasurement[g, circle, "Graph"]}]
```

At a single radius the square tiling has no circle: the shell has no two adjacent vertices.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {InfraSubstrateHighlight[g, {FindInfraShell[g, c, 4] -> $InfraShellColor, Directive[$InfraPointColor], c}],
   InfraMeasurement[g, InfraCircle[c, "Radius" -> 4], "Cardinality"]}]
```

A member is a cyclic vertex list. Drawn as a walk, it closes back on its first vertex.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {closedWalk = FindInfraRepresentative[g, InfraCircle[c, "Radius" -> {2, 4}]]},
  InfraSubstrateHighlight[g, {InfraWalk[Append[closedWalk, First @ closedWalk]] -> $InfraCircleColor, Directive[$InfraPointColor], c}]]
```

The point form: the circles through a vertex at distance 4, with the band widened one step outward.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, c, 4])},
  {circle = InfraCircle[c, p, "RadiusDelta" -> 1]},
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
  {closedWalk = FindInfraRepresentative[g, InfraCircle[c, "Radius" -> {2, 4}]]},
  {InfraSubstrateHighlight[g, {band -> $InfraShellColor, InfraWalk[Append[closedWalk, First @ closedWalk]] -> $InfraCircleColor}],
   SubsetQ[band, closedWalk], AllTrue[Partition[closedWalk, 2, 1, 1], EdgeQ[g, UndirectedEdge @@ #] &]}]
```

[FindInfraCircle]() searches the band directly and finds as many circles.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {circle = InfraCircle[c, "Radius" -> {2, 4}]},
  {InfraSubstrateHighlight[g, {circle -> $InfraCircleColor, Directive[$InfraPointColor], c}],
   InfraMeasurement[g, circle, "Cardinality"], Length @ FindInfraCircle[g, c, "Radius" -> {2, 4}, All]}]
```

A necklace is acyclic: it is the circles opened at their closing arrow, from its one source to its one sink.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {necklace = First @ InfraMeasurement[g, InfraCircle[c, "Radius" -> {2, 4}], "Graph"]},
  {InfraSubstrateHighlight[g, {necklace -> $InfraCircleColor, Directive[$InfraPointColor], c}, "Arrowheads" -> True],
   AcyclicGraphQ[necklace], Select[VertexList[necklace], VertexInDegree[necklace, #] == 0 &],
   Select[VertexList[necklace], VertexOutDegree[necklace, #] == 0 &]}]
```
