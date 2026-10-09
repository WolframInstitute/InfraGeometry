---
Template: Symbol
Name: InfraLine
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraLine
Keywords: [line, inextensible shortest path, atoms, germ, inert head]
SeeAlso: [FindInfraLine, InfraLineQ, InfraMeasurement, FindInfraRepresentative, FindInfraGeodesic, InfraSegment, InfraRay]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraLine]()[*p*, *q*]</code> is the line through *p* and *q*: every inextensible shortest path through *p* and then *q*. It is inert; [InfraMeasurement]() and [FindInfraRepresentative]() evaluate it on a graph.

<code>[InfraLine]()[*germ*]</code> is the line through a geodesic germ: every inextensible shortest path that contains the germ as a contiguous stretch. The germ is a vertex, a vertex list, a walk graph or a geodesic DAG.

<code>[InfraLine]()[*p*, *q*]</code> inside an [InfraScene]() is the line construction token; [FindInfraLine]() is the search.

## Details & Options

Definition: a line is an inextensible shortest path, one that no neighbour of either end prolongs.

Its graph — <code>[InfraMeasurement]()[*g*, *line*, "Graph"]</code> — is a `List` of DAGs, one per pair of ends (*a*, *b*) that is compatible, *d(a, b) = d(a, p) + d(p, q) + d(q, b)*, and maximal, no neighbour of *a* or *b* lengthening *d(a, b)*. The DAG for (*a*, *b*) is the union of the intervals *I(a, p)*, *I(p, q)* and *I(q, b)*. Its chains are exactly the lines with those ends, and every line is a chain of exactly one DAG, so `"Faithful"` is `True`.

The list is not optional. The union of the DAGs can carry chains that are not shortest paths: through the edge 1–2 of the 6-cycle there are three DAGs and three lines, while their union would add a fourth path that is not a shortest path.

The DAGs are alternatives, so the counts add across them. The family can be astronomical while the list stays small.

With *p* = *q*, <code>[InfraLine]()[*p*, *p*]</code> is every maximal shortest path through *p*, once per orientation.

The germ form keeps the germ's own edges in the middle. Its DAG for the ends (*a*, *b*) is the union of the intervals *I(a, p)* and *I(q, b)* with the edges of the germ from *p* to *q* in place of *I(p, q)*. For a straight germ these are the DAGs of `InfraLine[p, q]`. For a bent germ there are fewer, since *I(p, q)* is a rectangle and the DAG keeps only the germ. A vertex germ is `InfraLine[p, p]`.

## Basic Examples

The line through the centre and a vertex two steps away, on the square, hexagonal and triangular tilings. It runs both ways, out to the rim.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {p = First @ GraphCenter[g]},
    {q = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[p, 2]])},
    {line = InfraLine[p, q]},
    InfraSubstrateHighlight[g, {line, p, q}]],
  {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]
```

The number of DAGs carrying the lines, the number of lines and their length, beside the picture.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {p = First @ GraphCenter[g]},
  {q = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[p, 2]])},
  {line = InfraLine[p, q]},
  {InfraSubstrateHighlight[g, {line, p, q}],
   Length @ InfraMeasurement[g, line, "Graph"], InfraMeasurement[g, line, "Cardinality"],
   InfraMeasurement[g, line, "Length"]}]
```

Three of the lines, each drawn as a walk.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {p = First @ GraphCenter[g]},
  {q = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[p, 2]])},
  {members = FindInfraRepresentative[g, InfraLine[p, q], 3]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[member], p, q}], {member, members}]]
```

The lines through an edge at the centre, and the first DAG of their list on its own. Each DAG carries the lines between one pair of ends.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {p = First @ GraphCenter[g]},
  {q = First @ AdjacencyList[g, p]},
  {line = InfraLine[p, q]},
  GraphicsRow[{
    InfraSubstrateHighlight[g, {line, p, q}],
    InfraSubstrateHighlight[g, {First @ InfraMeasurement[g, line, "Graph"], p, q}]}]]
```

The line through a geodesic germ, beside the line through its two ends. The ends of a bent germ lie on the lines of the rectangle between them, the germ on those that run along it.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {p = First @ GraphCenter[g]},
  {q = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[p, 2]])},
  {germ = First @ FindInfraSegment[g, p, q, All]},
  {GraphicsRow @ {
    Labeled[InfraSubstrateHighlight[g, {InfraLine[germ], InfraWalk[germ], p, q}], "germ"],
    Labeled[InfraSubstrateHighlight[g, {InfraLine[p, q], p, q}], "ends"]},
   InfraMeasurement[g, InfraLine[germ], "Cardinality"], InfraMeasurement[g, InfraLine[p, q], "Cardinality"]}]
```

## Properties and Relations

The anchors lie on every line, so their density is the cardinality. The vertex density, drawn alone, is heaviest at the two anchors.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {p = First @ GraphCenter[g]},
  {q = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[p, 2]])},
  {density = InfraMeasurement[g, InfraLine[p, q], "VertexDensity"]},
  {InfraSubstrateHighlight[g, {density}],
   {density[p], density[q]} === ConstantArray[InfraMeasurement[g, InfraLine[p, q], "Cardinality"], 2]}]
```

Every member satisfies [InfraLineQ]().

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {p = First @ GraphCenter[g]},
  {q = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[p, 2]])},
  {members = FindInfraRepresentative[g, InfraLine[p, q], All]},
  {InfraSubstrateHighlight[g, {members, p, q}],
   InfraLineQ[g, members]}]
```

The lines through a germ are the lines of [FindInfraLine]() at that germ, and the geodesics that [FindInfraGeodesic]() grows from it on both sides without a budget.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {germ = {a, First @ AdjacencyList[g, a]}},
  {members = FindInfraRepresentative[g, InfraLine[germ], All]},
  {InfraSubstrateHighlight[g, {members, germ}],
   Sort @ members === Sort @ FindInfraLine[g, germ, All],
   Length @ members === InfraMeasurement[g, InfraLine[germ], "Cardinality"]}]
```
