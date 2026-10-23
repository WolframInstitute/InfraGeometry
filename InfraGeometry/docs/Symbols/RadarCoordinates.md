---
Template: Symbol
Name: RadarCoordinates
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RadarCoordinates
Keywords: [radar coordinates, distance vector, trilateration, resolving set, metric basis, landmarks, coordinatization]
SeeAlso: [ResolvingSetQ, FindResolvingSet, MetricDimension, ResistanceCoordinates, OrthogonalCoordinates]
RelatedGuides: [Experimental]
---

## Usage

<code>[RadarCoordinates]()[*g*, {*b1*, …, *bk*}, *v*]</code> gives the distances *(d(v, b₁), …, d(v, bₖ))* of the vertex *v* from the stations *b1*, …, *bk*.

<code>[RadarCoordinates]()[*g*, {*b1*, …, *bk*}]</code> gives the association of every vertex of *g* with its radar coordinates.

## Details & Options

The radar coordinates of *v* are *(d(v, b₁), …, d(v, bₖ))*. Every vertex gets its own coordinates exactly when the stations form a resolving set, [ResolvingSetQ](); the least number of stations that does is the [MetricDimension]().

A station can be a set of vertices, given as a vertex list, a density or a walk graph. Its coordinate is the distance to the set, *d(v, S) = min d(v, s)* over *s* in *S*, or another function of the distances to its vertices.

The point *v* can be a density; the result is then the list of the coordinates of its vertices.

| Option | Default | Values |
|---|---|---|
| `"AnchorAggregation"` | [Min]() | a function that reduces the distances to the vertices of a set station to one number, such as [Max]() or [Total]() |

## Basic Examples

Three stations at distance 4 from the centre, a vertex at distance 2, and a shortest path from it to each station. Its coordinates are the lengths of the paths:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {stations = RandomInfraPoint[g, InfraShell[c, 4], 3, "PairwiseDistance" -> "Max", RandomSeeding -> 1]},
    {v = RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, Join[InfraWalk[FindShortestPath[g, v, #]] & /@ stations, {stations, v}],
      PlotLabel -> RadarCoordinates[g, stations, v]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

Two corners of one side resolve a grid graph. Drawn at its radar coordinates from them, the grid is itself again, turned by 45 degrees:

```wl
With[{g = GridGraph[{6, 6}]}, {stations = {1, 6}},
  GraphicsRow[{InfraSubstrateHighlight[g, {stations}],
    Graph[VertexList[g], EdgeList[g], VertexCoordinates -> Normal[RadarCoordinates[g, stations]]]}]]
```

## Scope

The rim of the graph as one station. The coordinate is the depth of each vertex, and its level sets are rings about the centre:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {depth = First /@ RadarCoordinates[g, {GraphExteriorBoundary[g]}]},
    InfraSubstrateHighlight[g, Values @ KeySort @ GroupBy[Keys[depth], depth], PlotLabel -> Max[depth]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

A density as the point gives the coordinates of each of its vertices:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {stations = RandomInfraPoint[g, InfraShell[c, 4], 3, "PairwiseDistance" -> "Max", RandomSeeding -> 1]},
  RadarCoordinates[g, stations, InfraMeasurement[g, InfraBall[c, 1], "VertexDensity"]]]
```

## Options

### AnchorAggregation

A station of two vertices 6 apart, read three ways on the square grid. The vertices at [Min]() distance 3 are the outer layer of the union of two balls of radius 3, those at [Max]() distance 4 the outer layer of the intersection of two balls of radius 4, those at [Total]() distance 8 the ellipse with the two vertices as foci:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {foci = RandomInfraPoint[g, InfraShell[c, 3], 2, "PairwiseDistance" -> 6, RandomSeeding -> 1]},
  GraphicsRow @ KeyValueMap[
    {f, level} |-> With[{d = First /@ RadarCoordinates[g, {foci}, "AnchorAggregation" -> f]},
      InfraSubstrateHighlight[g, {Keys @ Select[d, # == level &], foci}, PlotLabel -> f]],
    <|Min -> 3, Max -> 4, Total -> 8|>]]
```

## Properties and Relations

Two opposite corners do not resolve a grid graph. Every vertex lies on a shortest path between them, so its two coordinates add up to 10, and the 6 × 6 grid collapses onto 11 points of a line:

```wl
With[{g = GridGraph[{6, 6}]}, {radar = RadarCoordinates[g, {1, 36}]},
  Graph[VertexList[g], EdgeList[g], VertexCoordinates -> Normal[radar], PlotLabel -> CountDistinct[Values[radar]],
    ImageSize -> Medium]]
```
