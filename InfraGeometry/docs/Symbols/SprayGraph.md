---
Template: Symbol
Name: SprayGraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/SprayGraph
Keywords: [spray of shortest paths, exponential map, breadth-first search, shortest-path DAG, shortest paths]
SeeAlso: [InfraMeasurement, RandomInfraGeodesic, FindInfraShell, InfraBall]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[SprayGraph]()[*g*, *c*]</code> gives the directed acyclic graph of all shortest paths from *c*: an edge *u → v* for every edge of *g* with *d(c, v) = d(c, u) + 1*.

<code>[SprayGraph]()[*g*, {*c1*, *c2*, …}]</code> measures the distance from the nearest of the sources.

<code>[SprayGraph]()[*g*, {{*u1*, *v1*}, {*u2*, *v2*}, …}]</code> gives the union of shortest paths between the listed pairs.

## Details & Options

Definition: the spray at *c* orients every edge of *g* that joins two consecutive shells about *c* outward, from the shell of radius *r* to that of radius *r* + 1. Edges inside one shell are dropped.

Its directed paths starting at *c* are exactly the shortest paths from *c*, each once, and the paths from *c* to a sink are the maximal ones — the shortest paths that cannot be continued away from *c*. It is the graph analogue of the exponential map at *c*: every direction the observer can walk in without turning back towards *c*, with the branching left in.

With several sources the distance is to the nearest source, so the spray grows out of the whole set.

The pair form picks shortest paths between each pair and takes the union of their path graphs. It enumerates, unlike the other two forms.

Options:

| Option | Default | Values |
|---|---|---|
| `"AxisLength"` | `All` | a depth *k*: keep only the vertices within distance *k* of the sources |
| `"PathThickness"` | `0` | pair form only: `0` keeps one shortest path per pair, `Infinity` all of them, *t* those within Hausdorff distance *t* of the first |
| `"Directed"` | `True` | `False` keeps the same edges undirected |

The spray keeps the embedding of *g*, so it is drawn in place.

## Basic Examples

The spray at the centre, drawn on the substrate by the maximal shortest paths through each edge, and the spray itself cut at depth 3.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  GraphicsRow[{
    InfraSubstrateHighlight[g, {SprayGraph[g, c], c}],
    SprayGraph[g, c, "AxisLength" -> 3]}]]
```

The spray from the centre covers the patch, and its sinks are the vertices of the rim where no step leads farther away.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {sprayDag = SprayGraph[g, c]},
  {sinks = Select[VertexList[sprayDag], VertexOutDegree[sprayDag, #] == 0 &]},
  {InfraSubstrateHighlight[g, {sprayDag, sinks}], VertexCount[sprayDag], EdgeCount[sprayDag], Length @ sinks}]
```

The maximal shortest paths from the centre to one sink, each a path of the spray.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {sprayDag = SprayGraph[g, c]},
  {sink = First @ Select[VertexList[sprayDag], VertexOutDegree[sprayDag, #] == 0 &]},
  {paths = FindPath[sprayDag, c, sink, Infinity, All]},
  {InfraSubstrateHighlight[g, {paths, c, sink}], Length @ paths}]
```

## Options

### PathThickness

One shortest path between the pair, every shortest path, or those within distance 1 of the first.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[a, 4]])},
  {sprays = Table[SprayGraph[g, {{a, b}}, "PathThickness" -> t], {t, {0, 1, Infinity}}]},
  {GraphicsRow @ Table[InfraSubstrateHighlight[g, {spray, a, b}], {spray, sprays}],
   EdgeCount /@ sprays}]
```

## Properties and Relations

A layer of the spray is a shell: the vertices at depth *r* are [FindInfraShell]()`[g, c, r]`, and their number is the shell area.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {sprayDag = SprayGraph[g, c, "AxisLength" -> 3]},
  {InfraSubstrateHighlight[g, {sprayDag, FindInfraShell[g, c, 3]}],
   Sort @ Complement[VertexList[sprayDag], RandomInfraBall[ g, InfraBall[c, 2] ]] === FindInfraShell[g, c, 3],
   VertexCount[sprayDag] === InfraMeasurement[g, InfraBall[c, 3], "CountingMeasure"]}]
```

The shortest paths from *c* to *v* are the paths of the spray from *c* to *v*; the `"Graph"` of [InfraMeasurement]()`[g, InfraSegment[c, v], "Graph"]` holds the same family.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {through = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[c, 4]])},
  {InfraSubstrateHighlight[g, {InfraMeasurement[g, InfraSegment[c, through], "Graph"], c, through}],
   Sort @ FindPath[SprayGraph[g, c], c, through, Infinity, All] === Sort @ FindPath[InfraMeasurement[g, InfraSegment[c, through], "Graph"], c, through, Infinity, All]}]
```
