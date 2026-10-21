---
Template: Symbol
Name: InfraDistance
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraDistance
Keywords: [distance, set distance, graph distance, region, ball, aggregation]
SeeAlso: [InfraBall, InfraShell, InfraSegment, InfraMeasurement, InfraScene, GraphDistance]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

<code>[InfraDistance]()[*g*, *p*, *q*]</code> gives the distance in *g* between *p* and *q*: the least graph distance from a vertex of *p* to a vertex of *q*.

## Details & Options

For vertex sets *P* and *Q* the distance is *d(P, Q) = min d(p, q)* over *p* in *P* and *q* in *Q*. For two vertices it is [GraphDistance]().

*p* and *q* can be vertices, vertex lists, densities `<|v -> m, …|>` (the vertices with *m* ≠ 0), subgraphs, or regions such as [InfraBall](), [InfraShell]() and [InfraSegment](). A list that is itself a vertex of *g* is read as that vertex.

It is not a metric on sets: *d(P, Q)* = 0 whenever *P* and *Q* meet, and the triangle inequality fails.

In any connected graph two balls are at distance *max(0, d(a, b) − r − s)*: a shortest path from *a* to *b* leaves the first ball at step *r* and enters the second *s* steps before *b*.

An empty set, or sets in different components, are at distance [Infinity]().

`"Aggregation"` replaces the minimum by another function of the list of all pair distances:

| Option | Default | Values |
|---|---|---|
| `"Aggregation"` | [Min]() | [Max](), [Mean](), or any function of a list of distances |

In an [InfraScene](), <code>[InfraDistance]()[*p*, *q*]</code> is the distance on the graph the scene is solved on.

## Basic Examples

The distance between a ball of radius 2 about the centre and a ball of radius 1 about a vertex 6 away, on the square grid and on the square mesh. It is 6 − 2 − 1 = 3:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
    {b = RandomInfraPoint[g, InfraShell[a, 6], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraBall[a, 2], InfraBall[b, 1], a, b},
      PlotLabel -> InfraDistance[g, InfraBall[a, 2], InfraBall[b, 1]]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

Between two vertices it is the graph distance:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, RandomSeeding -> 1]},
  {InfraDistance[g, a, b], GraphDistance[g, a, b]}]
```

## Scope

The distance from a vertex to a segment is the distance to its nearest shortest path. Each vertex of the grid sized by its distance to the segment drawn:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {seg = InfraSegment[a, RandomInfraPoint[g, InfraShell[a, 5], RandomSeeding -> 1]]},
  {distances = AssociationMap[v |-> InfraDistance[g, v, seg], VertexList[g]]},
  InfraSubstrateHighlight[g, {distances, seg}, ImageSize -> Medium]]
```

A density counts only the vertices of nonzero weight:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {a = First @ GraphCenter[g]},
  {InfraDistance[g, <|a -> 1, 46 -> 1|>, 47], InfraDistance[g, <|a -> 1, 46 -> 0|>, 47]}]
```

## Options

### Aggregation

The least, the greatest and the mean distance between two shells about the centre of the grid:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {a = First @ GraphCenter[g]},
  Table[InfraDistance[g, InfraShell[a, 2], InfraShell[a, 4], "Aggregation" -> f], {f, {Min, Max, Mean}}]]
```

## Properties and Relations

The distance between balls is *max(0, d(a, b) − r − s)*. On the mesh, for a vertex at distance 8 from the centre and all radii *r*, *s* ≤ 4:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium"]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 8], RandomSeeding -> 1]},
  And @@ Flatten @ Table[InfraDistance[g, InfraBall[a, r], InfraBall[b, s]] == Max[0, 8 - r - s], {r, 0, 4}, {s, 0, 4}]]
```

## Possible Issues

An empty set is at distance [Infinity]() from everything; with `"Aggregation" -> Max` it is at distance −[Infinity]():

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {a = First @ GraphCenter[g]},
  {InfraDistance[g, {}, a], InfraDistance[g, {}, a, "Aggregation" -> Max]}]
```

Vertices in different components are at distance [Infinity]():

```wl
InfraDistance[GraphDisjointUnion[CycleGraph[3], CycleGraph[3]], 1, 4]
```
