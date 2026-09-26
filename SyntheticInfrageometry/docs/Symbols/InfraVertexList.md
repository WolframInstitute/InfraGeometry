---
Template: Symbol
Name: InfraVertexList
Context: WolframInstitute`SyntheticInfrageometry`
ContextPath: [WolframInstitute`Infrageometry`]
Paclet: WolframInstitute/SyntheticInfrageometry
URI: WolframInstitute/SyntheticInfrageometry/ref/InfraVertexList
Keywords: [segment, ray, line, circle, arc, inert head, member, enumeration, random]
SeeAlso: [InfraMeasurement, InfraMemberQ, FindInfraSegment, FindInfraRay, FindInfraLine, FindInfraCircle, FindInfraArc]
RelatedGuides: [EuclideanGeometryGuide]
---

## Usage

<code>[InfraVertexList]()[*graph*, *obj*]</code> gives one member of the Euclidean head *obj* as a vertex list.

<code>[InfraVertexList]()[*graph*, *obj*, *n* | UpTo[*n*] | All]</code> gives a `List` of *n*, at most *n*, or every member.

## Details & Options

A member is a source-to-sink chain of the head's graph — [InfraMeasurement]()`[graph, obj, "Graph"]` — read off in lexicographic order; for a circle it is the chain's cyclic closure. A closed count under a non-negative integer *n* that exceeds the number of members gives `$Failed`, matching every `Find*` count contract.

Two modifiers, given after the count:

- `"RandomChoice"` walks the graph choosing the next arrow *v* -> *w* with probability proportional to the backward count at *w*, so every member of the family is drawn with probability `1 / Cardinality`; `SeedRandom` in front reproduces the draw.
- `"Pruning" -> q` discards a random fraction *q* of the candidates at each step of an otherwise exhaustive enumeration.

`InfraVertexList[graph, obj]` (no count) is the same as `InfraVertexList[graph, obj, Automatic]`, the first member in canonical order.

## Basic Examples

One geodesic, then every geodesic, of a segment on a grid.

```wl
With[
  {g = GridGraph[{5, 5}]},
  {seg = InfraSegment[7, 19]},
  InfraVertexList[g, seg]
]
```

```wl
With[
  {g = GridGraph[{5, 5}]},
  {seg = InfraSegment[7, 19]},
  Length @ InfraVertexList[g, seg, All]
]
```

A uniformly random geodesic, reproducible by seed.

```wl
With[
  {g = GridGraph[{5, 5}]},
  {seg = InfraSegment[7, 19]},
  SeedRandom[1];
  InfraVertexList[g, seg, 1, "RandomChoice"]
]
```
