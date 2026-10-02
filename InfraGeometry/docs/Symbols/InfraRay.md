---
Template: Symbol
Name: InfraRay
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraRay
Keywords: [ray, half-line, direction, pencil, inert head]
SeeAlso: [FindInfraRay, InfraRayQ, InfraMeasurement, FindInfraRepresentative, PencilDirections, InfraLine, InfraSegment]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraRay]()[*p*, *q*]</code> is the ray from *p* through *q*: every shortest path from *p* through *q* that cannot be prolonged past its last vertex. It is inert; [InfraMeasurement]() and [FindInfraRepresentative]() evaluate it on a graph.

<code>[InfraRay]()[*p*, *p*]</code> is the pencil at *p*: every ray from *p*.

<code>[InfraRay]()[*p*, *q*]</code> inside an [InfraScene]() is the ray construction token; [FindInfraRay]() is the search.

## Details & Options

Its graph — <code>[InfraMeasurement]()[*g*, *ray*, "Graph"]</code> — is one DAG with source *p*: the interval of shortest paths from *p* to *q* glued at *q* to <code>[GeodesicExtensionGraph]()[*g*, {*p*, *q*}]</code>. Its sinks are exactly the inextensible ends, so its source-to-sink chains are exactly the rays, and `"Faithful"` is `True`.

Rays to different sinks differ in length, so `"Length"` is a `List` of the lengths present.

Every member begins at *p*. A member is a vertex list; [FindInfraRepresentative]() reads one, several or all of them.

## Basic Examples

The ray from the centre through a vertex two steps away, on the square, hexagonal and triangular tilings. Past that vertex it spreads until it reaches the rim, where no step leads farther away.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {o = InfraCenter[g]},
    {through = (SeedRandom[1]; RandomInfraPoint[g, o, 2])},
    {ray = InfraRay[o, through]},
    InfraSubstrateHighlight[g, {ray -> $InfraRayColor, Directive[$InfraPointColor], o, through}]],
  {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]
```

The number of rays and their length, beside the picture.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {o = InfraCenter[g]},
  {through = (SeedRandom[1]; RandomInfraPoint[g, o, 2])},
  {ray = InfraRay[o, through]},
  {InfraSubstrateHighlight[g, {ray -> $InfraRayColor, Directive[$InfraPointColor], o, through}],
   InfraMeasurement[g, ray, "Cardinality"], InfraMeasurement[g, ray, "Length"]}]
```

The members are vertex lists. Three rays, each drawn as a walk.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {o = InfraCenter[g]},
  {through = (SeedRandom[1]; RandomInfraPoint[g, o, 2])},
  {members = FindInfraRepresentative[g, InfraRay[o, through], 3]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[member], Directive[$InfraPointColor], o, through}], {member, members}]]
```

The pencil at the centre: every ray from it at once.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {o = InfraCenter[g]},
  {pencil = InfraRay[o, o]},
  {InfraSubstrateHighlight[g, {pencil -> $InfraRayColor, Directive[$InfraPointColor], o}],
   InfraMeasurement[g, pencil, "Cardinality"]}]
```

## Properties and Relations

The origin lies on every ray, so its density is the cardinality. The vertex density, drawn alone, is heaviest at the origin.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {o = InfraCenter[g]},
  {through = (SeedRandom[1]; RandomInfraPoint[g, o, 2])},
  {density = InfraMeasurement[g, InfraRay[o, through], "VertexDensity"]},
  {InfraSubstrateHighlight[g, {density}],
   density[o] === InfraMeasurement[g, InfraRay[o, through], "Cardinality"]}]
```

Every member satisfies [InfraRayQ]().

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {o = InfraCenter[g]},
  {through = (SeedRandom[1]; RandomInfraPoint[g, o, 2])},
  {members = FindInfraRepresentative[g, InfraRay[o, through], All]},
  {InfraSubstrateHighlight[g, {members -> $InfraRayColor, Directive[$InfraPointColor], o, through}],
   InfraRayQ[g, members]}]
```
