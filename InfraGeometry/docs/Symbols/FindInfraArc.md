---
Template: Symbol
Name: FindInfraArc
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraArc
Keywords: [arc, minor arc, closed arc, circle through a point, band, search]
SeeAlso: [InfraArc, FindInfraRepresentative, FindInfraCircle, FindInfraSegment, InfraMeasurement]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[FindInfraArc]()[*g*, *c*, {*p*, *q*}]</code> gives one minor arc around *c* from *p* to *q* in *g*, as a vertex list.

<code>[FindInfraArc]()[*g*, *c*, {*p1*, …, *pk*}]</code> gives one polyline of minor arcs, from each point to the next.

<code>[FindInfraArc]()[*g*, *c*, {*p*, *p*}]</code> gives one circle around *c* through *p*, as a cyclic vertex list: the closed arc <code>[InfraArc]()[*c*, {*p*, *p*}]</code> read as a search.

<code>[FindInfraArc]()[*g*, *c*, *points*, *n*]</code> gives a `List` of exactly *n* arcs, or `{ }` when there are fewer; `UpTo[n]` gives up to *n*; `All` gives every arc.

## Details & Options

Definition: with *r* = *d(c, p)*, the band *W* is the shell $\{v : d(c,v) = r\}$, widened by `"RadiusDelta"`. A minor arc from *p* to *q* is a shortest path from *p* to *q* in the subgraph induced on *W*. A circle through *p* is a shortest cycle of that subgraph through *p* whose removal leaves *c* in a component reaching no further than the band.

**An arc need not exist.** On a lattice a single distance shell has no two adjacent vertices, so the bare shell joins no two of its points and the result is `{ }`. Widening the band fixes it.

**An arc need not be unique.** Between two points of a band there are in general many shortest paths, and through a point many circles; a trailing count gives them all.

A polyline reads each piece on the band of its own first point and concatenates one arc per piece, so the arcs through an intermediate point are the arcs from *p* to *q* that pass through it.

A list that returns to its first point names a closed arc, not a polyline there and back. The circles are returned as cyclic vertex lists: the edge from the last vertex back to the first is implicit, and the first vertex is not repeated.

The search sweeps the band directly: `FindPath` at the band distance between consecutive points, `FindCycle` length by length for a closed arc. It does not read the graph of [InfraArc](), so it is the check on that graph. It is the clause [FindInfraRepresentative]() uses for that head; to count arcs without enumerating them, use [InfraMeasurement]().

Option `"RadiusDelta" -> {deltaIn, deltaOut}` widens the band to *r* − *deltaIn* ≤ *d(c, v)* ≤ *r* + *deltaOut*. A scalar `"RadiusDelta" -> delta` means `{0, delta}`, outward only. The default is `0`. There is no `Method` and no `Properties`.

## Basic Examples

A minor arc of the circle of radius 3 about the centre, on the band widened one step each way, on the square, hexagonal and triangular tilings.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = InfraCenter[g]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, c, 3])},
    {q = (SeedRandom[2]; RandomInfraPoint[g, c, 3])},
    {oneArc = FindInfraArc[g, c, {p, q}, "RadiusDelta" -> {1, 1}]},
    InfraSubstrateHighlight[g, {InfraWalk[oneArc] -> $InfraCircleColor, Directive[$InfraPointColor], c, p, q}]],
  {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]
```

Every minor arc between the two points of the square tiling, beside their number.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, c, 3])},
  {q = (SeedRandom[2]; RandomInfraPoint[g, c, 3])},
  {allArcs = FindInfraArc[g, c, {p, q}, All, "RadiusDelta" -> {1, 1}]},
  {InfraSubstrateHighlight[g, {Table[InfraWalk[oneArc], {oneArc, allArcs}] -> $InfraCircleColor, Directive[$InfraPointColor], c, p, q}],
   Length @ allArcs}]
```

On the bare shell the two points are joined by no arc: the shell of the square tiling has no two adjacent vertices.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, c, 3])},
  {q = (SeedRandom[2]; RandomInfraPoint[g, c, 3])},
  {InfraSubstrateHighlight[g, {FindInfraShell[g, c, 3] -> $InfraShellColor, Directive[$InfraPointColor], c, p, q}],
   FindInfraArc[g, c, {p, q}, All]}]
```

Through an intermediate point the polyline keeps the arcs that pass through it.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, c, 3])},
  {q = (SeedRandom[2]; RandomInfraPoint[g, c, 3])},
  {allArcs = FindInfraArc[g, c, {p, 12, q}, All, "RadiusDelta" -> {1, 1}]},
  {InfraSubstrateHighlight[g, {Table[InfraWalk[oneArc], {oneArc, allArcs}] -> $InfraCircleColor, Directive[$InfraPointColor], c, p, 12, q}],
   Length @ allArcs}]
```

The circles through a vertex at distance 2 from the centre, in the band of radii 2 to 4, each drawn as its directed cycle.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, c, 2])},
  {allCircles = FindInfraArc[g, c, {p, p}, All, "RadiusDelta" -> 2]},
  {InfraSubstrateHighlight[g, {Table[Graph[DirectedEdge @@@ Partition[oneCircle, 2, 1, 1]], {oneCircle, allCircles}] -> $InfraCircleColor, Directive[$InfraPointColor], c, p}],
   Length @ allCircles}]
```

## Properties and Relations

The search finds exactly the members of the head.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, c, 3])},
  {q = (SeedRandom[2]; RandomInfraPoint[g, c, 3])},
  {arc = InfraArc[c, {p, q}, "RadiusDelta" -> {1, 1}]},
  {InfraSubstrateHighlight[g, {arc -> $InfraCircleColor, Directive[$InfraPointColor], c, p, q}],
   Sort @ FindInfraArc[g, c, {p, q}, All, "RadiusDelta" -> {1, 1}] === Sort @ FindInfraRepresentative[g, arc, All]}]
```

The circles through *p* are as many as the closed arc counts.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, c, 2])},
  {closedArc = InfraArc[c, {p, p}, "RadiusDelta" -> 2]},
  {InfraSubstrateHighlight[g, {closedArc -> $InfraCircleColor, Directive[$InfraPointColor], c, p}],
   Length @ FindInfraArc[g, c, {p, p}, All, "RadiusDelta" -> 2], InfraMeasurement[g, closedArc, "Cardinality"]}]
```
