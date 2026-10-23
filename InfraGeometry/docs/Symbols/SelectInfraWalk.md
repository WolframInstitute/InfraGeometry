---
Template: Symbol
Name: SelectInfraWalk
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/SelectInfraWalk
Keywords: [walk, path space, Hausdorff distance, central path, selection, segment members]
SeeAlso: [InfraSegment, RandomInfraSegment, RandomInfraWalk, InfraMeasurement, IntervalGraph]
---

## Usage

<code>[SelectInfraWalk]()[*g*, *walks*]</code> gives a list of one walk drawn from *walks*, read as points of a metric space.

<code>[SelectInfraWalk]()[*g*, *walks*, *n*]</code> gives *n* walks; *n* can be `UpTo[n]` or `All`.

<code>[SelectInfraWalk]()[*g*, *n*]</code> is the operator form.

## Details & Options

The distance between two walks is the Hausdorff distance of their vertex sets in *g* by default. `"From"` says which walks are eligible, `"Distance"` how far apart the chosen ones must be.

*walks* is a list of vertex lists or walk graphs, a list of cycle graphs, read as closed walks, or one directed acyclic graph, such as the graph of a segment, read as its paths from source to sink. The result has the same form: vertex lists, walk graphs or path graphs.

| `"From"` | Eligible walks |
|---|---|
| `All` | every walk |
| `"Center"`, `"Periphery"` | those of least, greatest largest distance to the others |
| `"MinLength"`, `"MaxLength"` | the shortest, the longest |
| `"MostVisited"` | those through the most-used vertices and edges, the counts summed |
| `"Bottleneck"` | those whose least-used vertex or edge is used most |
| *w* `->` *d*, *w* `->` {*dMin*, *dMax*}, *w* `->` `"Max"` | those at distance *d*, within the range, or farthest from the walk *w* |
| {`"Min"`, *f*}, {`"Max"`, *f*} | those minimising, maximising *f* |

| Option | Default | Values |
|---|---|---|
| `"From"` | `All` | the table above |
| `"Distance"` | `None` | *d*: pairwise at distance at least *d*; {*dMin*, *dMax*}; `"Max"`: as far apart as possible |
| `"Metric"` | `"Hausdorff"` | `"Frechet"`: the largest distance between vertices at the same position; `"MeanFrechet"`: the mean |
| `"Cyclic"` | `False` | `True` compares closed walks up to rotation |
| `"MaxCliques"` | `All` | the number of candidate tuples searched under `"Distance"` |
| [RandomSeeding]() | `Automatic` | an integer or a string for a reproducible draw; `Inherited` to draw from the current random state |

With `All` the result is every eligible walk. With a smaller count the walks are drawn at random from them.

## Basic Examples

The central members of a segment: the shortest paths closest to all the others, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
    {seg = InfraSegment[a, RandomInfraPoint[g, InfraShell[a, 6], RandomSeeding -> 2]]},
    {central = SelectInfraWalk[g, InfraMeasurement[g, seg, "Graph"], All, "From" -> "Center"]},
    InfraSubstrateHighlight[g, {seg, central}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The central, peripheral and most-visited members of a segment on the grid. The most-visited ones keep to the diagonal:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {seg = InfraMeasurement[g, InfraSegment[45, 78], "Graph"]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {SelectInfraWalk[g, seg, All, "From" -> f]}, PlotLabel -> f],
    {f, {"Center", "Periphery", "MostVisited"}}]]
```

## Scope

Vertex lists give vertex lists. The longest walks:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  SelectInfraWalk[g, {{45, 46}, {45, 46, 47}, {45, 55, 65}}, All, "From" -> "MaxLength"]]
```

The operator form:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  SelectInfraWalk[g, All, "From" -> "MaxLength"][{{45, 46}, {45, 46, 47}, {45, 55, 65}}]]
```

## Options

### Metric

The members of a segment farthest from one of its two outer paths. In the Hausdorff distance there are five; at the same positions only the other outer path:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {seg = InfraMeasurement[g, InfraSegment[45, 78], "Graph"]}, {outer = {45, 55, 65, 75, 76, 77, 78}},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g,
      {InfraWalk[outer], SelectInfraWalk[g, seg, All, "From" -> outer -> "Max", "Metric" -> m]}, PlotLabel -> m],
    {m, {"Hausdorff", "Frechet"}}]]
```

### RandomSeeding

With a finite count and several eligible walks the draw is random. Twenty draws of one central member give several walks; with a seed they give one:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {seg = InfraMeasurement[g, InfraSegment[45, 78], "Graph"]},
  {Length @ Union @ Table[VertexList /@ SelectInfraWalk[g, seg, "From" -> "Center"], {20}],
   Length @ Union @ Table[VertexList /@ SelectInfraWalk[g, seg, "From" -> "Center", RandomSeeding -> 1], {20}]}]
```
