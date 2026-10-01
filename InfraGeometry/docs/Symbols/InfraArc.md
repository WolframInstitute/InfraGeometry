---
Template: Symbol
Name: InfraArc
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraArc
Keywords: [arc, circle, band, minor arc, inert head]
SeeAlso: [FindInfraArc, InfraCircle, InfraSegment, InfraMeasurement, InfraVertexList, Undetermined]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraArc]()[*c*, {*p*, *q*}]</code> is the arc around *c* from *p* to *q*: the minor arcs of the circle through *p* and *q*. It is inert; [InfraMeasurement]() and [InfraVertexList]() evaluate it on a graph.

<code>[InfraArc]()[*c*, {*p1*, …, *pk*}]</code> is the polyline of the minor arcs from each point to the next.

## Details & Options

Definition: with *r* = *d(c, p)*, the band *W* is the shell { *v* : *d(c, v)* = *r* }, widened by `"RadiusDelta"`. A minor arc from *p* to *q* is a shortest path from *p* to *q* of the subgraph induced on *W*.

Option `"RadiusDelta" -> {deltaIn, deltaOut}` widens the band to *r* − *deltaIn* ≤ *d(c, v)* ≤ *r* + *deltaOut*. A scalar `"RadiusDelta" -> delta` means `{0, delta}`, outward only. The default is `0`.

Its graph — <code>[InfraMeasurement]()[*g*, *arc*, "Graph"]</code> — is the interval of shortest paths of the band from *p* to *q*, with arrows of rising band distance from *p*. It is the same object [InfraSegment]() is on the whole graph. Its chains are those shortest paths, all of one length.

That they are exactly the minor arcs needs the winding functional on the substrate, and *p* and *q* on a common circle. Nothing here certifies either, so `"Faithful"` is [Undetermined]().

The arc is empty when *q* leaves the band or the band disconnects *p* from *q*.

A polyline arc reads each piece on the band of the circle through its own first point. Its members concatenate one arc per piece, so its `"Cardinality"` is the product over the pieces.

## Basic Examples

An arc of the circle of radius 3 about the centre, on the band widened one step each way, on the square, hexagonal and triangular tilings. An edge is drawn as strongly as the number of minor arcs through it.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = InfraCenter[g]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, c, 3])},
    {q = (SeedRandom[2]; RandomInfraPoint[g, c, 3])},
    {arc = InfraArc[c, {p, q}, "RadiusDelta" -> {1, 1}]},
    InfraSubstrateHighlight[g, {arc -> $InfraCircleColor, Directive[$InfraPointColor], c, p, q}]],
  {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]
```

The number of minor arcs and their length, beside the picture.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, c, 3])},
  {q = (SeedRandom[2]; RandomInfraPoint[g, c, 3])},
  {arc = InfraArc[c, {p, q}, "RadiusDelta" -> {1, 1}]},
  {InfraSubstrateHighlight[g, {arc -> $InfraCircleColor, Directive[$InfraPointColor], c, p, q}],
   InfraMeasurement[g, arc, "Cardinality"], InfraMeasurement[g, arc, "Length"]}]
```

On the bare distance shell the two points are joined by no arc: a shell of the square tiling has no two adjacent vertices.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, c, 3])},
  {q = (SeedRandom[2]; RandomInfraPoint[g, c, 3])},
  {InfraSubstrateHighlight[g, {FindInfraShell[g, c, 3] -> $InfraShellColor, Directive[$InfraPointColor], c, p, q}],
   InfraMeasurement[g, InfraArc[c, {p, q}], "Cardinality"]}]
```

The members are vertex lists. Three minor arcs, each drawn as a walk.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, c, 3])},
  {q = (SeedRandom[2]; RandomInfraPoint[g, c, 3])},
  {members = InfraVertexList[g, InfraArc[c, {p, q}, "RadiusDelta" -> {1, 1}], UpTo[3]]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[member], Directive[$InfraPointColor], c, p, q}], {member, members}]]
```

The two half-rings between antipodes of the radius-2 hexagon of the triangular tiling.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {ring = FindInfraShell[g, c, 2]},
  {p = First @ ring},
  {q = First @ Select[ring, GraphDistance[Subgraph[g, ring], p, #] == 6 &]},
  {arc = InfraArc[c, {p, q}]},
  {InfraSubstrateHighlight[g, {arc -> $InfraCircleColor, Directive[$InfraPointColor], c, p, q}],
   InfraMeasurement[g, arc, "Cardinality"], InfraMeasurement[g, arc, "Length"]}]
```

## Properties and Relations

[FindInfraArc]() searches the band directly and finds the same arcs.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, c, 3])},
  {q = (SeedRandom[2]; RandomInfraPoint[g, c, 3])},
  {found = FindInfraArc[g, c, {p, q}, All, "RadiusDelta" -> {1, 1}]},
  {InfraSubstrateHighlight[g, {found -> $InfraCircleColor, Directive[$InfraPointColor], c, p, q}],
   Sort @ found === Sort @ InfraVertexList[g, InfraArc[c, {p, q}, "RadiusDelta" -> {1, 1}], All]}]
```

The circle's and the arc's `"Faithful"` are both [Undetermined]().

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, c, 3])},
  {q = (SeedRandom[2]; RandomInfraPoint[g, c, 3])},
  {arc = InfraArc[c, {p, q}, "RadiusDelta" -> {1, 1}]},
  {InfraSubstrateHighlight[g, {arc -> $InfraCircleColor, Directive[$InfraPointColor], c, p, q}],
   InfraMeasurement[g, arc, "Faithful"]}]
```
