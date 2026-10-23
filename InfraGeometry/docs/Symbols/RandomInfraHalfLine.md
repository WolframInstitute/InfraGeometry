---
Template: Symbol
Name: RandomInfraHalfLine
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraHalfLine
Keywords: [ray, half-line, direction, pencil, Euclid Postulate 2]
SeeAlso: [InfraHalfLine, InfraHalfLineQ, RayGraph, RandomInfraInfiniteLine, RandomInfraSegment]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraHalfLine]()[*g*, *p*, *q*]</code> gives a random ray from *p* through *q* in *g*, as a vertex list.

<code>[RandomInfraHalfLine]()[*g*, *p*, *q*, *n*]</code> gives a list of *n* distinct rays from *p* through *q*.

<code>[RandomInfraHalfLine]()[*g*, [InfraHalfLine]()[*p*, *q*]]</code> gives a member of the half-line, every ray with the same probability.

<code>[RandomInfraHalfLine]()[*g*, [InfraHalfLine]()[*p*, *q*], *n*]</code> gives a list of *n* distinct members.

## Details & Options

A ray from *p* through *q* is a shortest path *p = v₀, …, q, …, vₖ = e* with *d(p, e) = k* that no edge prolongs: no neighbour of *e* is farther from *p* than *e*. The predicate is [InfraHalfLineQ]().

The rays of a direction end at different distances. On a finite substrate they end on the rim.

<code>[RandomInfraHalfLine]()[*g*, *p*, *p*, All]</code> is the pencil at *p*: all maximal shortest paths from *p*, the graph analogue of the sphere of directions.

With vertex arguments the ray is a random shortest path to *q*, prolonged one random outward step at a time. This draw is not uniform over the rays. The [InfraHalfLine]() form draws uniformly.

The count *n* can be `n`, `UpTo[n]` or `All`. A count above the number of rays gives `{}`.

Options:

| Option | Default | Values |
|---|---|---|
| `"NextVertexFunction"` | `Automatic` | `Automatic` random; `Identity` the first rays in vertex order |
| [RandomSeeding]() | `Automatic` | an integer or a string for a reproducible draw; `Inherited` to draw from the current random state |

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Postulate 2 | To produce a finite straight line continuously; the ray is the one-sided production. |
| Hilbert | Group II | Rays are defined from betweenness on a line. |
| Tarski | A4, segment construction | A segment can be laid off from a point in a given direction. |
| Birkhoff | Ruler postulate | A ray is a half-open coordinate interval on a line. |

## Basic Examples

A random ray from the centre through a vertex at distance 2, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
    {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraWalk[RandomInfraHalfLine[g, p, q, RandomSeeding -> 1]], p, q}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

Three rays of the same direction. They end at different distances from *p*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[ray], p, q}, PlotLabel -> Length[ray] - 1],
    {ray, RandomInfraHalfLine[g, InfraHalfLine[p, q], 3, RandomSeeding -> 2]}]]
```

`All` gives every ray. There are 140 on the grid, the cardinality of the half-line:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
  {Length @ RandomInfraHalfLine[g, p, q, All], InfraMeasurement[g, InfraHalfLine[p, q], "Cardinality"]}]
```

## Scope

The pencil at the centre of the mesh: the ends of all its rays, and their number:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {rays = RandomInfraHalfLine[g, p, p, All]},
  InfraSubstrateHighlight[g, {Union[Last /@ rays], p}, PlotLabel -> Length[rays], ImageSize -> Medium]]
```

## Options

### NextVertexFunction

`Identity` gives the rays in a fixed order:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
  RandomInfraHalfLine[g, p, q, 2, "NextVertexFunction" -> Identity]]
```

## Properties and Relations

Every ray satisfies [InfraHalfLineQ](), and the distance from *p* grows by one at each step:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 2]}, {rays = RandomInfraHalfLine[g, p, q, All]},
  {InfraHalfLineQ[g, rays], AllTrue[rays, GraphDistance[g, p, #] & /@ # == Range[0, Length[#] - 1] &]}]
```

The rays are the paths of the [RayGraph]() from *p* to a sink:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 2]}, {dag = RayGraph[g, p, q]},
  Sort @ RandomInfraHalfLine[g, p, q, All] ===
    Sort @ Catenate[FindPath[dag, p, #, Infinity, All] & /@ Select[VertexList[dag], VertexOutDegree[dag, #] == 0 &]]]
```

## Possible Issues

The vertex form is not a uniform draw. The frequencies of the 12 rays in 1200 draws, with vertex arguments and with the [InfraHalfLine]() token:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 2]}, {rays = RandomInfraHalfLine[g, p, q, All]},
  ListPlot[{Lookup[Counts @ Table[RandomInfraHalfLine[g, p, q, RandomSeeding -> k], {k, 1200}], rays, 0],
    Lookup[Counts @ Table[RandomInfraHalfLine[g, InfraHalfLine[p, q], RandomSeeding -> k], {k, 1200}], rays, 0]},
    Filling -> Axis, PlotRange -> {0, All}, PlotLegends -> {"vertices", "InfraHalfLine"}]]
```
