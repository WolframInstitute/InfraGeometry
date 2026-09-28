---
Template: Symbol
Name: InfraCircle
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraCircle
Keywords: [circle, band, separating cycle, necklace, seam, inert head]
SeeAlso: [FindInfraCircle, InfraArc, InfraMeasurement, InfraVertexList, Undetermined, InfraShell]
RelatedGuides: [EuclideanGeometryGuide]
---

## Usage

<code>[InfraCircle]()[*c*, *p*]</code> is the circle around *c* through *p*. It is inert; [InfraMeasurement]() and [InfraVertexList]() evaluate it on a graph.

<code>[InfraCircle]()[*c*, "Radius" -> *r*]</code> is the family of circles around *c* at radius *r*, and <code>[InfraCircle]()[*c*, "Radius" -> {*r*, *s*}]</code> the family in the band *r* ≤ *d(c, v)* ≤ *s*.

<code>[InfraCircle]()[*c*, *r*]</code> inside an [InfraScene]() is the circle construction token by radius; [FindInfraCircle]() is the search.

## Details & Options

Definition: a circle of the band *W* around *c* is a shortest cycle of the subgraph induced on *W* whose removal leaves *c* in a component that reaches no further than the band.

The point form takes the band at *d(c, p)* and keeps the circles through *p*. Option `"RadiusDelta" -> {deltaIn, deltaOut}` widens it to *d(c, p)* − *deltaIn* ≤ *d(c, v)* ≤ *d(c, p)* + *deltaOut*. A scalar `"RadiusDelta" -> delta` means `{0, delta}`, outward only. The default is `0`.

**A circle need not exist.** On a lattice a single distance shell has no two adjacent vertices, so it spans no cycle and the family is empty. Widening the radius to a band fixes it.

Its graph — <code>[InfraMeasurement]()[*g*, *circle*, "Graph"]</code> — is a `List` of necklaces, cut from the band along a radial seam: a geodesic from *c* to just outside the band. A necklace is a DAG with one source *s1* and one sink *u*. It is the cycle family **opened** at its closing arrow *u* -> *s1*, which is left out, so the DAG is acyclic.

A member is the open chain *s1* … *u*, read cyclically: a cyclic vertex list whose first vertex is not repeated. Its `"Length"` counts the closing edge too, so a circle of *k* vertices has length *k*.

Every member separates. That the necklaces carry every circle exactly once needs two hypotheses on the substrate — the winding functional and the one-run hypothesis — which nothing here certifies. So `"Faithful"` is [Undetermined]().

Inside an [InfraScene](), the token `InfraCircle[c, r]` still reads *r* as a radius, unlike the head, where a bare second argument is always a point. This is an open inconsistency.

## Basic Examples

The band `{4, 5}` around the centre of a square grid: the number of circles, their length, and the number of necklaces carrying them.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {circle = InfraCircle[c, "Radius" -> {4, 5}]},
  {InfraMeasurement[g, circle, "Cardinality"], InfraMeasurement[g, circle, "Length"],
   Length @ InfraMeasurement[g, circle, "Graph"]}
]
```

At a single radius the lattice has no circle.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  InfraMeasurement[g, InfraCircle[c, "Radius" -> 4], "Cardinality"]
]
```

A member is a cyclic vertex list.

```wl
InfraVertexList[GridGraph[{5, 5}], InfraCircle[13, "Radius" -> {1, 2}]]
```

The point form: the circles through a vertex at distance 4, with the band widened one step outward.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {p = First @ Sort @ Select[VertexList[g], GraphDistance[g, c, #] == 4 &]},
  InfraMeasurement[g, InfraCircle[c, p, "RadiusDelta" -> 1], {"Cardinality", "Length"}]
]
```

## Properties and Relations

A circle lies in its band, and consecutive vertices are adjacent, the last and the first too.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {cyc = InfraVertexList[g, InfraCircle[41, "Radius" -> {2, 4}]]},
  {SubsetQ[FindInfraShell[g, 41, {2, 4}], cyc],
   AllTrue[Partition[cyc, 2, 1, 1], EdgeQ[g, UndirectedEdge @@ #] &]}
]
```

[FindInfraCircle]() searches the band directly and finds as many circles.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {InfraMeasurement[g, InfraCircle[41, "Radius" -> {2, 4}], "Cardinality"],
   Length @ FindInfraCircle[g, 41, "Radius" -> {2, 4}, All]}
]
```

The necklace is acyclic, and its closing arrow runs from its sink back to its source.

```wl
With[
  {neck = First @ InfraMeasurement[GridGraph[{5, 5}], InfraCircle[13, "Radius" -> {1, 2}], "Graph"]},
  {AcyclicGraphQ[neck], Select[VertexList[neck], VertexInDegree[neck, #] == 0 &],
   Select[VertexList[neck], VertexOutDegree[neck, #] == 0 &]}
]
```
