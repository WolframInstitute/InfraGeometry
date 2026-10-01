---
Template: Symbol
Name: InfraRay
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraRay
Keywords: [ray, half-line, direction, pencil, inert head]
SeeAlso: [FindInfraRay, InfraRayQ, InfraMeasurement, InfraVertexList, PencilDirections, InfraLine, InfraSegment]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraRay]()[*p*, *q*]</code> is the ray from *p* through *q*: every geodesic from *p* through *q* that cannot be prolonged past its last vertex. It is inert; [InfraMeasurement]() and [InfraVertexList]() evaluate it on a graph.

<code>[InfraRay]()[*p*, *p*]</code> is the pencil at *p*: every ray from *p*.

<code>[InfraRay]()[*p*, *q*]</code> inside an [InfraScene]() is the ray construction token; [FindInfraRay]() is the search.

## Details & Options

Its graph — <code>[InfraMeasurement]()[*g*, *ray*, "Graph"]</code> — is one DAG with source *p*: the geodesic interval from *p* to *q* glued at *q* to <code>[GeodesicExtensionGraph]()[*g*, {*p*, *q*}]</code>. Its sinks are exactly the inextensible ends, so its source-to-sink chains are exactly the rays, and `"Faithful"` is `True`.

Rays to different sinks differ in length, so `"Length"` is a `List` of the lengths present.

Every member begins at *p*. A member is a vertex list; [InfraVertexList]() reads one, several or all of them.

## Basic Examples

The ray from the centre of a grid through a vertex two steps up and two across. Past that vertex it spreads until it reaches the corner, where no step leads farther away: 36 rays.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {ray = InfraRay[41, 61]},
  {InfraSubstrateHighlight[g, {ray, Directive[$InfraPointColor], 41, 61}, ImageSize -> 250],
   InfraMeasurement[g, ray, "Cardinality"]}]
```

Five rays leave 6 through 7 on a 4 × 4 grid. Two stop at the corner 4 after three steps, three reach the corner 16 after four.

```wl
With[
  {g = GridGraph[{4, 4}]},
  {ray = InfraRay[6, 7]},
  {InfraMeasurement[g, ray, "Cardinality"], InfraMeasurement[g, ray, "Length"]}
]
```

```wl
InfraVertexList[GridGraph[{4, 4}], InfraRay[6, 7], All]
```

The pencil at a vertex of the 6-cycle: two rays, both ending at the antipode.

```wl
InfraVertexList[CycleGraph[6], InfraRay[1, 1], All]
```

## Properties and Relations

The origin lies on every ray, so its density is the cardinality.

```wl
With[
  {g = GridGraph[{4, 4}]},
  {ray = InfraRay[6, 7]},
  InfraMeasurement[g, ray, "VertexDensity"][6] === InfraMeasurement[g, ray, "Cardinality"]
]
```

Every member satisfies [InfraRayQ]().

```wl
With[
  {g = GridGraph[{4, 4}]},
  InfraRayQ[g, InfraVertexList[g, InfraRay[6, 7], All]]
]
```
