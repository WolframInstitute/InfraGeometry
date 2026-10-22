---
Template: Symbol
Name: RandomInfraSegment
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraSegment
Keywords: [segment, shortest path, random shortest path, Euclid Postulate 1]
SeeAlso: [InfraSegment, IntervalGraph, RandomInfraInfiniteLine, InfraMeasurement, UniqueInfraSegmentQ, MetricInterval]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraSegment]()[*g*, *p*, *q*]</code> gives a random shortest path from *p* to *q* in *g*, as a vertex list.

<code>[RandomInfraSegment]()[*g*, *p*, *q*, *n*]</code> gives a list of *n* distinct shortest paths from *p* to *q*.

<code>[RandomInfraSegment]()[*g*, [InfraSegment]()[*p1*, …, *pk*]]</code> gives a random member of the segment or polyline: a shortest path from each point to the next, joined.

<code>[RandomInfraSegment]()[*g*, [InfraSegment]()[*p1*, …, *pk*], *n*]</code> gives a list of *n* distinct members.

## Details & Options

A shortest path from *p* to *q* is a walk *p = v₀, v₁, …, vₖ = q* with *k = d(p, q)*. In the plane the segment is unique; on a graph there are usually many, and each is drawn with the same probability.

The count *n* can be `n`, `UpTo[n]` or `All`. A count above the number of shortest paths gives `{}`; `UpTo[n]` gives what there is.

Options:

| Option | Default | Values |
|---|---|---|
| `"NextVertexFunction"` | `Automatic` | `Automatic`: every shortest path equally likely; `RandomChoice`: each step uniform among the next vertices; `Identity`: the first paths in vertex order |
| [RandomSeeding]() | `Automatic` | an integer or a string for a reproducible draw; `Inherited` to draw from the current random state |

`RandomChoice` is a greedy walk, not a uniform draw: a path that passes vertices with few onward choices is more likely.

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Postulate 1 | To draw a straight line from any point to any point. |
| Hilbert | I.1, I.2 | Two points determine one and only one line. Here there are many shortest paths. |
| Tarski | A4, segment construction | A point can be laid off at a given distance along a segment. |
| Birkhoff | Ruler postulate | A segment is a closed coordinate interval; here every shortest path is one. |

## Basic Examples

A random shortest path from the centre to a vertex at distance 5, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
    {b = RandomInfraPoint[g, InfraShell[a, 5], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraWalk[RandomInfraSegment[g, a, b, RandomSeeding -> 1]], a, b}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

`All` gives every shortest path. On the grid there are *C(5, 2) = 10*, as many as the cardinality of the segment:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 5], RandomSeeding -> 1]},
  {Length @ RandomInfraSegment[g, a, b, All], InfraMeasurement[g, InfraSegment[a, b], "Cardinality"]}]
```

Three distinct shortest paths:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 5], RandomSeeding -> 6]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[path], a, b}],
    {path, RandomInfraSegment[g, a, b, 3, RandomSeeding -> 1]}]]
```

## Scope

A member of the polyline from *a* through the centre to *b*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {a = RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 2]},
  {b = RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 4]},
  InfraSubstrateHighlight[g, {InfraWalk[RandomInfraSegment[g, InfraSegment[a, c, b], RandomSeeding -> 1]], a, c, b},
    ImageSize -> Medium]]
```

## Options

### NextVertexFunction

The frequencies of the 10 shortest paths in 1000 draws. `Automatic` draws them uniformly; `RandomChoice` favours some:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 5], RandomSeeding -> 1]}, {paths = RandomInfraSegment[g, a, b, All]},
  ListPlot[
    Table[Lookup[Counts @ Table[RandomInfraSegment[g, a, b, "NextVertexFunction" -> f, RandomSeeding -> k], {k, 1000}],
      paths, 0], {f, {Automatic, RandomChoice}}],
    Filling -> Axis, PlotRange -> {0, All}, PlotLegends -> {"Automatic", "RandomChoice"}]]
```

`Identity` gives the paths in a fixed order:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 5], RandomSeeding -> 1]},
  RandomInfraSegment[g, a, b, 3, "NextVertexFunction" -> Identity]]
```

## Properties and Relations

The shortest paths cover the metric interval of the endpoints:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 5], RandomSeeding -> 6]},
  Union @@ RandomInfraSegment[g, a, b, All] === Sort @ MetricInterval[g, a, b]]
```

## Possible Issues

A count above the number of shortest paths gives `{}`; `UpTo` gives all of them:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 5], RandomSeeding -> 1]},
  {RandomInfraSegment[g, a, b, 11, RandomSeeding -> 1], Length @ RandomInfraSegment[g, a, b, UpTo[11], RandomSeeding -> 1]}]
```

A third vertex after the endpoints is a count, not a corner: <code>[RandomInfraSegment]()[*g*, *a*, *c*, *b*]</code> with an integer *b* is *b* shortest paths from *a* to *c*. The polyline from *a* through *c* to *b* is <code>[RandomInfraSegment]()[*g*, [InfraSegment]()[*a*, *c*, *b*]]</code>. With the vertex 3 as *b*, three paths from 23 to the centre, and one member of the polyline:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {RandomInfraSegment[g, 23, c, 3, RandomSeeding -> 1], RandomInfraSegment[g, InfraSegment[23, c, 3], RandomSeeding -> 1]}]
```
