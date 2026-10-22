---
Template: Symbol
Name: RandomInfraParallel
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraParallel
Keywords: [parallel, parallel postulate, Playfair, Euclid Postulate 5, level set, equidistant]
SeeAlso: [InfraParallelQ, RandomInfraInfiniteLine, InfraInfiniteLine, FindInfraPerpendicular, InfraInfiniteLineQ, FindInfraBisectingHyperplane]
RelatedGuides: [Experimental]
---

## Usage

<code>[RandomInfraParallel]()[*g*, *line*, *p*]</code> gives a random parallel to *line* through the vertex *p*, as a directed path graph.

<code>[RandomInfraParallel]()[*g*, *line*, *p*, *n*]</code> gives a list of *n* parallels.

<code>[RandomInfraParallel]()[*g*, *line*, *p*, All]</code> gives all parallels, as a list of directed acyclic graphs whose source-to-sink paths are the parallels.

## Details & Options

Let *L = {v : d(v, line) = d(p, line)}* be the level set of *p*. A parallel to *line* through *p* is a shortest path *(s, …, p, …, e)* of *g* with all its vertices in *L* that no neighbour of *s* or *e* in *L* prolongs. A parallel need not be a line of *g*: it is inextensible inside *L* only. Its vertices are all at distance *d(p, line)* from the line, but the line need not be at constant distance from it, so [InfraParallelQ](), which asks both, can reject it.

Through a vertex of a row of the square grid there is exactly one parallel to another row, and it is the row. Where the line bends, the level set bends with it, and the parallels are short and can be several. A vertex with no neighbour in *L* has no parallel.

The line can be a vertex list, a walk graph or a list of walk graphs.

The count *n* can be `n`, `UpTo[n]` or `All`. Fewer than *n* parallels give `{}`. A single directed acyclic graph is returned bare by `All`.

| Option | Default | Values |
|---|---|---|
| `"NextVertexFunction"` | `Automatic` | `Identity` takes the parallels in canonical order, `RandomSample` in random order; the class is the same |
| [RandomSeeding]() | `Automatic` | an integer or a string for a reproducible draw; `Inherited` to draw from the current random state |

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Postulate 5 | Two lines falling on a line with interior angles less than two right angles meet on that side. |
| Euclid | Proposition I.31 | To draw through a point a line parallel to a given line. |
| Hilbert | IV (Playfair) | Through a point off a line there is at most one parallel. |

## Basic Examples

A line through the centre, the vertices at distance 2 from it, and a parallel through one of them:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {a = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1]},
    {line = RandomInfraInfiniteLine[g, c, a, RandomSeeding -> 1]},
    {p = RandomInfraPoint[g, InfraShell[line, 2], RandomSeeding -> 1]},
    {par = RandomInfraParallel[g, line, p, RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraShell[line, 2], InfraWalk[line], par, p}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

Playfair on the square grid: through a vertex two rows above the middle row there is one parallel to it, and it is the row:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {vertexAt = AssociationThread[Round @ GraphEmbedding[g], VertexList[g]]},
  {row = vertexAt /@ Table[{x, 5}, {x, 10}], p = vertexAt[{5, 7}]},
  {parallels = RandomInfraParallel[g, row, p, UpTo[10], RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {InfraWalk[row], parallels, p}, PlotLabel -> Length[parallels], ImageSize -> Medium]]
```

## Scope

Through some vertices of the mesh there are several parallels. A count larger than their number gives `{}`:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {a = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1]},
  {line = RandomInfraInfiniteLine[g, c, a, RandomSeeding -> 1]},
  {p = RandomInfraPoint[g, InfraShell[line, 2], RandomSeeding -> 7]},
  {parallels = RandomInfraParallel[g, line, p, UpTo[10], RandomSeeding -> 1]},
  {none = RandomInfraParallel[g, line, p, 4, RandomSeeding -> 1]},
  GraphicsRow[Append[InfraSubstrateHighlight[g, {InfraWalk[line], #, p}] & /@ parallels,
    InfraSubstrateHighlight[g, {InfraWalk[line], p}, PlotLabel -> none]]]]
```

A rim vertex of the grid at distance 2 from the line has no neighbour at that distance, and no parallel:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {a = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1]},
  {line = RandomInfraInfiniteLine[g, c, a, RandomSeeding -> 1]},
  {p = RandomInfraPoint[g, InfraShell[line, 2], RandomSeeding -> 3]},
  InfraSubstrateHighlight[g, {InfraShell[line, 2], InfraWalk[line], p},
    PlotLabel -> RandomInfraParallel[g, line, p, All], ImageSize -> Medium]]
```

## Options

### NextVertexFunction

The class is the same in canonical and in random order:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {a = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1]},
  {line = RandomInfraInfiniteLine[g, c, a, RandomSeeding -> 1]},
  {p = RandomInfraPoint[g, InfraShell[line, 2], RandomSeeding -> 7]},
  SameQ @@ Table[Sort[VertexList /@ RandomInfraParallel[g, line, p, UpTo[100], "NextVertexFunction" -> f]],
    {f, {Identity, RandomSample}}]]
```

## Properties and Relations

A parallel is a shortest path, and every vertex of it is at distance 2 from the line:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {a = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1]},
  {line = RandomInfraInfiniteLine[g, c, a, RandomSeeding -> 1]},
  {p = RandomInfraPoint[g, InfraShell[line, 2], RandomSeeding -> 7]},
  {par = RandomInfraParallel[g, line, p, RandomSeeding -> 1]},
  {InfraSegmentQ[g, par], Union @ Table[Min @ Table[GraphDistance[g, v, w], {w, line}], {v, VertexList[par]}]}]
```

## Possible Issues

[InfraParallelQ]() asks for a constant distance both ways. The line runs on past the ends of its parallel, and its last vertices are farther from it, so the test rejects the pair:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {a = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1]},
  {line = RandomInfraInfiniteLine[g, c, a, RandomSeeding -> 1]},
  {p = RandomInfraPoint[g, InfraShell[line, 2], RandomSeeding -> 7]},
  {par = VertexList @ RandomInfraParallel[g, line, p, RandomSeeding -> 1]},
  {InfraParallelQ[g, par, line], Table[Min @ Table[GraphDistance[g, v, w], {w, par}], {v, line}]}]
```
