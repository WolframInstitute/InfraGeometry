---
Template: Symbol
Name: InfraLine
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraLine
Keywords: [line, inextensible shortest path, atoms, inert head]
SeeAlso: [FindInfraLine, InfraLineQ, InfraMeasurement, FindInfraRepresentative, InfraSegment, InfraRay]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraLine]()[*p*, *q*]</code> is the line through *p* and *q*: every inextensible shortest path through *p* and then *q*. It is inert; [InfraMeasurement]() and [FindInfraRepresentative]() evaluate it on a graph.

<code>[InfraLine]()[*p*, *q*]</code> inside an [InfraScene]() is the line construction token; [FindInfraLine]() is the search.

## Details & Options

Definition: a line is an inextensible shortest path, one that no neighbour of either end prolongs.

Its graph — <code>[InfraMeasurement]()[*g*, *line*, "Graph"]</code> — is a `List` of DAGs, one per pair of ends (*a*, *b*) that is compatible, *d(a, b) = d(a, p) + d(p, q) + d(q, b)*, and maximal, no neighbour of *a* or *b* lengthening *d(a, b)*. The DAG for (*a*, *b*) is the union of the intervals *I(a, p)*, *I(p, q)* and *I(q, b)*. Its chains are exactly the lines with those ends, and every line is a chain of exactly one DAG, so `"Faithful"` is `True`.

The list is not optional. The union of the DAGs can carry chains that are not shortest paths: through the edge 1–2 of the 6-cycle there are three DAGs and three lines, while their union would add a fourth path that is not a shortest path.

The DAGs are alternatives, so the counts add across them. The family can be astronomical while the list stays small.

With *p* = *q*, <code>[InfraLine]()[*p*, *p*]</code> is every maximal shortest path through *p*, once per orientation.

## Basic Examples

The line through the centre and a vertex two steps away, on the square, hexagonal and triangular tilings. It runs both ways, out to the rim.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {p = InfraCenter[g]},
    {q = (SeedRandom[1]; RandomInfraPoint[g, p, 2])},
    {line = InfraLine[p, q]},
    InfraSubstrateHighlight[g, {line -> $InfraLineColor, Directive[$InfraPointColor], p, q}]],
  {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]
```

The number of DAGs carrying the lines, the number of lines and their length, beside the picture.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {p = InfraCenter[g]},
  {q = (SeedRandom[1]; RandomInfraPoint[g, p, 2])},
  {line = InfraLine[p, q]},
  {InfraSubstrateHighlight[g, {line -> $InfraLineColor, Directive[$InfraPointColor], p, q}],
   Length @ InfraMeasurement[g, line, "Graph"], InfraMeasurement[g, line, "Cardinality"],
   InfraMeasurement[g, line, "Length"]}]
```

Three of the lines, each drawn as a walk.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {p = InfraCenter[g]},
  {q = (SeedRandom[1]; RandomInfraPoint[g, p, 2])},
  {members = FindInfraRepresentative[g, InfraLine[p, q], 3]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[member], Directive[$InfraPointColor], p, q}], {member, members}]]
```

The lines through an edge at the centre, and the first DAG of their list on its own. Each DAG carries the lines between one pair of ends.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {p = InfraCenter[g]},
  {q = First @ AdjacencyList[g, p]},
  {line = InfraLine[p, q]},
  GraphicsRow[{
    InfraSubstrateHighlight[g, {line -> $InfraLineColor, Directive[$InfraPointColor], p, q}],
    InfraSubstrateHighlight[g, {First @ InfraMeasurement[g, line, "Graph"] -> $InfraLineColor, Directive[$InfraPointColor], p, q}]}]]
```

## Properties and Relations

The anchors lie on every line, so their density is the cardinality. The vertex density, drawn alone, is heaviest at the two anchors.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {p = InfraCenter[g]},
  {q = (SeedRandom[1]; RandomInfraPoint[g, p, 2])},
  {density = InfraMeasurement[g, InfraLine[p, q], "VertexDensity"]},
  {InfraSubstrateHighlight[g, {density}],
   {density[p], density[q]} === ConstantArray[InfraMeasurement[g, InfraLine[p, q], "Cardinality"], 2]}]
```

Every member satisfies [InfraLineQ]().

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {p = InfraCenter[g]},
  {q = (SeedRandom[1]; RandomInfraPoint[g, p, 2])},
  {members = FindInfraRepresentative[g, InfraLine[p, q], All]},
  {InfraSubstrateHighlight[g, {members -> $InfraLineColor, Directive[$InfraPointColor], p, q}],
   InfraLineQ[g, members]}]
```
