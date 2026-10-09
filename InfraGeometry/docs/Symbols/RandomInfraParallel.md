---
Template: Symbol
Name: RandomInfraParallel
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraParallel
Keywords: [parallel, parallel postulate, Playfair, Euclid Postulate 5, level set, pool]
SeeAlso: [InfraParallelQ, RandomInfraLine, InfraLine, FindInfraPerpendicular, InfraLineQ, FindInfraBisectingHyperplane]
RelatedGuides: [Experimental]
---

## Usage

<code>[RandomInfraParallel]()[*g*, *line*, *p*]</code> gives one parallel to *line* through *p* in *g* — a geodesic through *p* that stays at the distance *d(p, line)* from *line* and cannot be prolonged at that distance — as a directed path graph.

<code>[RandomInfraParallel]()[*g*, *line*, *p*, *n*]</code> gives a `List` of exactly *n* parallels or `$Failed`; `UpTo[n]` gives up to *n*; `All` gives the whole class as a pool of DAGs.

## Details & Options

Write *L* for the level set $\{v : d(v, line) = d(p, line)\}$. A parallel to *line* through *p* is a geodesic *s … p … e* of *g* — so *d(s, e) = d(s, p) + d(p, e)* — with every vertex in *L*, such that no neighbour of *s* or *e* in *L* prolongs it. This reads Euclid's fifth postulate intrinsically: constant distance is what a metric can say about parallelism without a notion of direction. Inextensibility is measured inside *L*, not in *g*, so a parallel need not be a line of *g*.

*line* is a vertex sequence, a walk graph, or a list of walk graphs, which spreads over its walks. Each parallel appears once, oriented so that *s* precedes *e* in canonical order.

On the square grid the classical picture survives: through a vertex of a parallel row there is exactly one parallel to a row, and it is the row. Off a line that bends, the level set bends with it, and a geodesic inside it soon has to leave — the parallels are then few and short. Below, through a vertex at distance 2 from a line through the centre, the square tiling has one parallel of 10 edges beside a line of 24, the irregular mesh two, of 4 and 5 edges, the hexagonal tiling a single edge. A vertex with no neighbour in its level set has no parallel at all: the class is empty, not the one-vertex walk.

[InfraParallelQ]() asks a different question, and the two do not match. The predicate tests that two vertex sets are disjoint and at constant distance, and does not require either to be a geodesic. So it accepts pairs this function never returns — concentric shells, for instance, are parallel by that test — while every parallel returned here passes it.

The class is carried by a **pool**: one geodesic DAG per admissible pair of ends (*s*, *e*), the *s → p* and *p → e* intervals cut down to *L* and glued at *p*. `All` returns the pool itself — a `List` of DAGs, a single atom giving the one DAG. A bounded count streams parallels off the atoms as directed path graphs, and the count-less call is one parallel, deterministic.

| Option | Values | Meaning |
|---|---|---|
| `"NextVertexFunction"` | `Identity` (default), `RandomSample`, any function | a bounded or absent count takes the end pairs and the branches of each DAG in the order the function gives: `Identity` the canonical order, `RandomSample` a random order, seeded by an ambient `SeedRandom`. The class is the same under every value. |
| `Properties` | `{}` | only the empty list; a rule on the parallel is a local law and lives on `RandomInfraGeodesic`. |

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Postulate 5 | The parallel postulate: two lines cut by a transversal making internal angles less than two right angles meet on that side. |
| Euclid | Proposition I.31 | To draw a line through a given point parallel to a given line. |
| Hilbert | Group IV | Playfair's axiom: through a point not on a line there is exactly one parallel. |
| Tarski | A10, Euclid's axiom | The Euclidean axiom, stated with betweenness and equidistance. |

## Basic Examples

A line through the centre of each substrate and a vertex at distance 4, and the parallels to it through a vertex at distance 2 off the line: one edge count per parallel.

```wl
Association @ Table[
   name -> With[
     {g = InfraSubstrate[name, "Medium", "KeepCoordinates" -> True]},
     {c = First @ GraphCenter[g]},
     {far = First @ Sort @ Select[VertexList[g], GraphDistance[g, c, #] == 4 &]},
     {line = RandomInfraLine[g, c, far]},
     {p = First @ Sort @ Select[VertexList[g], GraphDistance[g, c, #] == 2 && ! MemberQ[line, #] &]},
     EdgeCount /@ RandomInfraParallel[g, line, p, UpTo[10]]],
   {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]
```

The line and its one parallel on the square tiling.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {far = First @ Sort @ Select[VertexList[g], GraphDistance[g, c, #] == 4 &]},
  {line = RandomInfraLine[g, c, far]},
  {p = First @ Sort @ Select[VertexList[g], GraphDistance[g, c, #] == 2 && ! MemberQ[line, #] &]},
  InfraSubstrateHighlight[g,
    {line,
     RandomInfraParallel[g, line, p],
     {c, p}},
    "PointSizeRange" -> 15,
    VertexShapeFunction -> ({AbsolutePointSize[2.2], Point[#]} &),
    ImageSize -> 340]]
```

## Scope

Playfair's axiom on the grid: through a vertex of the third row there is exactly one parallel to the first row, and it is the row.

```wl
RandomInfraParallel[GridGraph[{5, 5}], Range[5], 13, All]
```

The level set at distance 1 from a diagonal is eight isolated vertices, so through any of them there is no parallel.

```wl
RandomInfraParallel[GridGraph[{5, 5}], {1, 7, 13, 19, 25}, 8, All]
```

A strict count that cannot be met is `$Failed`; the line may be given as a walk graph.

```wl
{RandomInfraParallel[GridGraph[{5, 5}], Range[5], 13, 2],
 RandomInfraParallel[GridGraph[{5, 5}], PathGraph[Range[5], DirectedEdges -> True], 13]}
```

## Options

### NextVertexFunction

The class is the same under every next-vertex function; only the order in which parallels come off the pool differs.

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Medium", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {far = First @ Sort @ Select[VertexList[g], GraphDistance[g, c, #] == 4 &]},
  {line = RandomInfraLine[g, c, far]},
  {p = First @ Sort @ Select[VertexList[g], GraphDistance[g, c, #] == 2 && ! MemberQ[line, #] &]},
  SameQ @@ (Sort[VertexList /@ RandomInfraParallel[g, line, p, UpTo[100], "NextVertexFunction" -> #]] & /@
     {Identity, RandomSample})]
```

## Properties and Relations

Every parallel is a geodesic, and [InfraParallelQ]() accepts it — as it accepts two concentric shells, which no geodesic could be.

```wl
With[
  {g = GridGraph[{5, 5}]},
  {row = RandomInfraParallel[g, Range[5], 13]},
  {InfraSegmentQ[g, row], InfraParallelQ[g, Range[5], row],
   InfraParallelQ[g, FindInfraShell[g, 13, 1], FindInfraShell[g, 13, 2]]}]
```

Parallelism runs both ways: the first row is the parallel to the third row through a vertex of the first.

```wl
RandomInfraParallel[GridGraph[{5, 5}], Range[11, 15], 3, All]
```
