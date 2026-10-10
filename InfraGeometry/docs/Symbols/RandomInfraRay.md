---
Template: Symbol
Name: RandomInfraRay
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraRay
Keywords: [ray, half-line, direction, pencil, Euclid Postulate 2]
SeeAlso: [InfraRay, InfraRayQ, RandomInfraRepresentative, RandomInfraLine, RandomInfraSegment]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraRay]()[*g*, *O*, *v*]</code> gives one ray from *O* through *v* in *g* — a shortest path from *O* containing *v* that cannot be prolonged past its last vertex — as a vertex list.

<code>[RandomInfraRay]()[*g*, *O*, *v*, *n*]</code> gives a `List` of exactly *n* rays or `{}`; `UpTo[n]` gives up to *n*; `All` gives every ray.

## Details & Options

The default draw is random. Seed with `SeedRandom` to reproduce it. Give `"NextVertexFunction" -> Identity` for deterministic descent. `All` with `Automatic` keeps the full enumeration without drawing.

A ray from *O* through *v* is a shortest path *O … v … e* with *d(O, e) = d(O, v) + d(v, e)* such that no neighbour of *e* lies one step farther from *O*. The first vertex is the origin, which is what makes it a ray rather than a line: inextensibility is required at the far end only. [InfraRayQ]() is the predicate.

Rays are how direction is expressed without a vector space. There is no tangent space on a graph, so "the direction from *O* towards *v*" is not a vector but the *family* of rays from *O* containing *v* — and like every other family here it is large. The rays leaving a vertex, the pencil, are the graph's stand-in for the sphere of directions: `RandomInfraRay[g, o, o, All]` lists them and `InfraMeasurement[g, InfraRay[o, o], "Cardinality"]` counts them.

The search runs on the substrate directly: a shortest path from *O* to *v*, prolonged one outward step at a time until no neighbour prolongs it. It does not read the graph of <code>[InfraRay]()[*O*, *v*]</code>, so it is the check on that graph, and it returns exactly the shapes [RandomInfraRepresentative]() gives for that head. To count the rays without enumerating them, use [InfraMeasurement]().

<code>[RandomInfraRay]()[*g*, *O*, *O*, All]</code> is every ray from *O* — the pencil.

The count-less call is one random ray. There is no `Method` and no `Properties`.

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Postulate 2 | To produce a finite straight-line continuously; the ray is the one-sided production. |
| Hilbert | Group II, order | Rays are defined from betweenness on a line. |
| Tarski | A4, segment construction | Laying off a segment from a point in a given direction. |
| Birkhoff | Ruler postulate | A half-open coordinate interval on a line. |

## Basic Examples

How many rays leave the centre of each substrate through a vertex at distance 5, counted on the head without enumerating a ray.

```wl
Association @ Table[
   name -> With[
     {g = InfraSubstrate[name, "Medium", "KeepCoordinates" -> True]},
     {a = First @ GraphCenter[g]},
     {b = First @ Sort @ Select[VertexList[g], GraphDistance[g, a, #] == 5 &]},
     InfraMeasurement[g, InfraRay[a, b], "Cardinality"]],
   {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]
```

Three rays from the centre of each substrate. Each starts at the origin and runs to the edge of the patch.

```wl
SeedRandom[1];
Row[Table[
   With[
     {g = InfraSubstrate[name, "Medium", "KeepCoordinates" -> True]},
     {a = First @ GraphCenter[g]},
     {b = First @ Sort @ Select[VertexList[g], GraphDistance[g, a, #] == 5 &]},
     Labeled[
       InfraSubstrateHighlight[g,
         {RandomInfraRay[g, a, b, UpTo[3]], {a}},
         "PointSizeRange" -> 15,
         VertexShapeFunction -> ({AbsolutePointSize[2.2], Point[#]} &),
         ImageSize -> 250],
       Text[name]]],
   {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]]
```

## Scope

Five rays leave vertex 6 of the grid through its neighbour 7; two stop at the corner 4 after three steps, three reach the corner 16 after four.

```wl
SeedRandom[1];
RandomInfraRay[GridGraph[{4, 4}], 6, 7, All]
```

The count-less call is one random ray.

```wl
SeedRandom[1];
RandomInfraRay[GridGraph[{4, 4}], 6, 7]
```

Both shortest paths from 1 to its antipode on the 6-cycle are rays: nothing lies farther from 1 than 4.

```wl
SeedRandom[1];
RandomInfraRay[CycleGraph[6], 1, 4, All]
```

## Properties and Relations

Every ray satisfies [InfraRayQ]().

```wl
SeedRandom[1];
InfraRayQ[GridGraph[{4, 4}], RandomInfraRay[GridGraph[{4, 4}], 6, 7, All]]
```

Every ray begins at its origin, and the distance from the origin grows by one at each step.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = First @ Sort @ Select[VertexList[g], GraphDistance[g, a, #] == 5 &]},
  {ray = RandomInfraRay[g, a, b]},
  {First[ray] === a, GraphDistance[g, a, #] & /@ ray === Range[0, Length[ray] - 1]}]
```

With the origin as its own direction the rays are the pencil, counted by the cardinality of the head.

```wl
SeedRandom[1];
Length @ RandomInfraRay[CycleGraph[6], 1, 1, All] === InfraMeasurement[CycleGraph[6], InfraRay[1, 1], "Cardinality"]
```

The search agrees with the graph of the head.

```wl
SeedRandom[1];
With[
  {g = GridGraph[{4, 4}]},
  Sort @ RandomInfraRay[g, 6, 7, All] === Sort @ RandomInfraRepresentative[g, InfraRay[6, 7], All]]
```
