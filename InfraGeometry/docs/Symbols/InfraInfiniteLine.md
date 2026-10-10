---
Template: Symbol
Name: InfraInfiniteLine
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraInfiniteLine
Keywords: [line, inextensible shortest path, atoms, germ, symbolic object]
SeeAlso: [BeamGraph, RandomInfraInfiniteLine, InfraInfiniteLineQ, InfraMeasurement, RandomInfraInfiniteLine, RandomInfraGeodesic, InfraSegment, InfraHalfLine]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraInfiniteLine]()[*p*, *q*]</code> is the line through *p* and *q*: every inextensible shortest path through *p* and then *q*. It is a symbolic object; [InfraMeasurement]() and [RandomInfraInfiniteLine]() evaluate it on a graph.

<code>[InfraInfiniteLine]()[*germ*]</code> is the line through a shortest-path germ: every inextensible shortest path that contains the germ as a contiguous stretch. The germ is a vertex, a vertex list, a walk graph or a shortest-path DAG.

<code>[InfraInfiniteLine]()[*p*, *q*]</code> inside an [InfraScene]() is the line construction token; [RandomInfraInfiniteLine]() is the search.

## Details & Options

Definition: a line is an inextensible shortest path, one that no neighbour of either end prolongs.

Its graph — <code>[InfraMeasurement]()[*g*, *line*, "Graph"]</code> — is a `List` of DAGs, one per pair of ends (*a*, *b*) that is compatible, *d(a, b) = d(a, p) + d(p, q) + d(q, b)*, and maximal, no neighbour of *a* or *b* lengthening *d(a, b)*. The DAG for (*a*, *b*) is the union of the intervals *I(a, p)*, *I(p, q)* and *I(q, b)*. Its chains are exactly the lines with those ends, and every line is a chain of exactly one DAG, so `"Faithful"` is `True`.

The list is not optional. The union of the DAGs can carry chains that are not shortest paths: through the edge 1–2 of the 6-cycle there are three DAGs and three lines, while their union would add a fourth path that is not a shortest path.

The DAGs are alternatives, so the counts add across them. The family can be astronomical while the list stays small.

With *p* = *q*, <code>[InfraInfiniteLine]()[*p*, *p*]</code> is every maximal shortest path through *p*, once per orientation.

The germ form keeps the germ's own edges in the middle. Its DAG for the ends (*a*, *b*) is the union of the intervals *I(a, p)* and *I(q, b)* with the edges of the germ from *p* to *q* in place of *I(p, q)*. For a straight germ these are the DAGs of `InfraInfiniteLine[p, q]`. For a bent germ there are fewer, since *I(p, q)* is a rectangle and the DAG keeps only the germ. A vertex germ is `InfraInfiniteLine[p, p]`.

## Basic Examples

The line through the centre and a vertex two steps away, on the square, hexagonal and triangular tilings. It runs both ways, out to the rim.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {p = First @ GraphCenter[g]},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[p, 2]])},
    {line = InfraInfiniteLine[p, q]},
    InfraSubstrateHighlight[g, {line, p, q}]],
  {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]
```

The number of DAGs carrying the lines, the number of lines and their length, beside the picture.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {p = First @ GraphCenter[g]},
  {q = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[p, 2]])},
  {line = InfraInfiniteLine[p, q]},
  {InfraSubstrateHighlight[g, {line, p, q}],
   Length @ InfraMeasurement[g, line, "Graph"], InfraMeasurement[g, line, "Cardinality"],
   InfraMeasurement[g, line, "Length"]}]
```

Three of the lines, each drawn as a walk.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {p = First @ GraphCenter[g]},
  {q = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[p, 2]])},
  {members = RandomInfraInfiniteLine[ g, InfraInfiniteLine[p, q], 3 ]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[member], p, q}], {member, members}]]
```

The lines through an edge at the centre, and the first DAG of their list on its own. Each DAG carries the lines between one pair of ends.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {p = First @ GraphCenter[g]},
  {q = First @ AdjacencyList[g, p]},
  {line = InfraInfiniteLine[p, q]},
  GraphicsRow[{
    InfraSubstrateHighlight[g, {line, p, q}],
    InfraSubstrateHighlight[g, {First @ InfraMeasurement[g, line, "Graph"], p, q}]}]]
```

The line through a shortest-path germ, beside the line through its two ends. The ends of a bent germ lie on the lines of the rectangle between them, the germ on those that run along it.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {p = First @ GraphCenter[g]},
  {q = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[p, 2]])},
  {germ = First @ RandomInfraSegment[g, p, q, All]},
  {GraphicsRow @ {
    Labeled[InfraSubstrateHighlight[g, {InfraInfiniteLine[germ], InfraWalk[germ], p, q}], "germ"],
    Labeled[InfraSubstrateHighlight[g, {InfraInfiniteLine[p, q], p, q}], "ends"]},
   InfraMeasurement[g, InfraInfiniteLine[germ], "Cardinality"], InfraMeasurement[g, InfraInfiniteLine[p, q], "Cardinality"]}]
```

## Properties and Relations

The anchors lie on every line, so their density is the cardinality. The vertex density, drawn alone, is heaviest at the two anchors.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {p = First @ GraphCenter[g]},
  {q = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[p, 2]])},
  {density = InfraMeasurement[g, InfraInfiniteLine[p, q], "VertexDensity"]},
  {InfraSubstrateHighlight[g, {density}],
   {density[p], density[q]} === ConstantArray[InfraMeasurement[g, InfraInfiniteLine[p, q], "Cardinality"], 2]}]
```

Every member satisfies [InfraInfiniteLineQ]().

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {p = First @ GraphCenter[g]},
  {q = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[p, 2]])},
  {members = RandomInfraInfiniteLine[ g, InfraInfiniteLine[p, q], All ]},
  {InfraSubstrateHighlight[g, {members, p, q}],
   InfraInfiniteLineQ[g, members]}]
```

The lines through a germ are the lines of [RandomInfraInfiniteLine]() at that germ, and the geodesics that [RandomInfraGeodesic]() grows from it on both sides without a budget.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {germ = {a, First @ AdjacencyList[g, a]}},
  {members = RandomInfraInfiniteLine[ g, InfraInfiniteLine[germ], All ]},
  {InfraSubstrateHighlight[g, {members, germ}],
   Sort @ members === Sort @ RandomInfraInfiniteLine[g, germ, All],
   Length @ members === InfraMeasurement[g, InfraInfiniteLine[germ], "Cardinality"]}]
```
