---
Template: Symbol
Name: InfraHalfLine
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraHalfLine
Keywords: [ray, half-line, direction, pencil, symbolic object]
SeeAlso: [RayGraph, RandomInfraHalfLine, InfraHalfLineQ, InfraMeasurement, RandomInfraHalfLine, InfraInfiniteLine, InfraSegment]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraHalfLine]()[*p*, *q*]</code> is the ray from *p* through *q*: every shortest path from *p* through *q* that cannot be prolonged past its last vertex. It is a symbolic object; [InfraMeasurement]() and [RandomInfraHalfLine]() evaluate it on a graph.

<code>[InfraHalfLine]()[*p*, *p*]</code> is the pencil at *p*: every ray from *p*.

<code>[InfraHalfLine]()[*p*, *q*]</code> inside an [InfraScene]() is the ray construction token; [RandomInfraHalfLine]() is the search.

## Details & Options

Its graph — <code>[InfraMeasurement]()[*g*, *ray*, "Graph"]</code> — is one DAG with source *p*: the interval of shortest paths from *p* to *q* glued at *q* to the DAG of the extensions beyond *q*: the vertices *e* with *d(p, e) = d(p, q) + d(q, e)*, and the edges that lengthen the distance from *p* by one. Its sinks are exactly the inextensible ends, so its source-to-sink chains are exactly the rays, and `"Faithful"` is `True`.

Rays to different sinks differ in length, so `"Length"` is a `List` of the lengths present.

Every member begins at *p*. A member is a vertex list; [RandomInfraHalfLine]() reads one, several or all of them.

## Basic Examples

The ray from the centre through a vertex two steps away, on the square, hexagonal and triangular tilings. Past that vertex it spreads until it reaches the rim, where no step leads farther away.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {o = First @ GraphCenter[g]},
    {through = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[o, 2]])},
    {ray = InfraHalfLine[o, through]},
    InfraSubstrateHighlight[g, {ray, o, through}]],
  {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]
```

The number of rays and their length, beside the picture.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {o = First @ GraphCenter[g]},
  {through = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[o, 2]])},
  {ray = InfraHalfLine[o, through]},
  {InfraSubstrateHighlight[g, {ray, o, through}],
   InfraMeasurement[g, ray, "Cardinality"], InfraMeasurement[g, ray, "Length"]}]
```

The members are vertex lists. Three rays, each drawn as a walk.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {o = First @ GraphCenter[g]},
  {through = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[o, 2]])},
  {members = RandomInfraHalfLine[ g, InfraHalfLine[o, through], 3 ]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[member], o, through}], {member, members}]]
```

The pencil at the centre: every ray from it at once.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {o = First @ GraphCenter[g]},
  {pencil = InfraHalfLine[o, o]},
  {InfraSubstrateHighlight[g, {pencil, o}],
   InfraMeasurement[g, pencil, "Cardinality"]}]
```

## Properties and Relations

The origin lies on every ray, so its density is the cardinality. The vertex density, drawn alone, is heaviest at the origin.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {o = First @ GraphCenter[g]},
  {through = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[o, 2]])},
  {density = InfraMeasurement[g, InfraHalfLine[o, through], "VertexDensity"]},
  {InfraSubstrateHighlight[g, {density}],
   density[o] === InfraMeasurement[g, InfraHalfLine[o, through], "Cardinality"]}]
```

Every member satisfies [InfraHalfLineQ]().

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {o = First @ GraphCenter[g]},
  {through = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[o, 2]])},
  {members = RandomInfraHalfLine[ g, InfraHalfLine[o, through], All ]},
  {InfraSubstrateHighlight[g, {members, o, through}],
   InfraHalfLineQ[g, members]}]
```
