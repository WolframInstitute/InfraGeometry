---
Template: Symbol
Name: InfraLine
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraLine
Keywords: [line, inextensible shortest path, germ, legacy, symbolic object]
SeeAlso: [InfraInfiniteLine, RandomInfraLine, RandomInfraInfiniteLine, InfraLineQ, InfraMeasurement, InfraRay]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraLine]()[*p*, *q*]</code> is the line through *p* and *q*, the same as <code>[InfraInfiniteLine]()[*p*, *q*]</code>.

<code>[InfraLine]()[*germ*]</code> is the line through the shortest path *germ*, the same as <code>[InfraInfiniteLine]()[*germ*]</code>.

## Details & Options

[InfraLine]() is the older name of [InfraInfiniteLine](). New code uses [InfraInfiniteLine]().

A line is an inextensible shortest path: a shortest path that no neighbour of either end prolongs. <code>[InfraLine]()[*p*, *q*]</code> is the family of all lines through *p* and then *q*.

[InfraMeasurement](), [InfraMemberQ](), [InfraSubstrateHighlight]() and [RandomInfraInfiniteLine]() read <code>[InfraLine]()[…]</code> as <code>[InfraInfiniteLine]()[…]</code>. [RandomInfraLine]() and [InfraLineQ]() are the older names of [RandomInfraInfiniteLine]() and [InfraInfiniteLineQ]().

## Basic Examples

The line through the centre and a vertex at distance 2, on the square grid and on the square mesh. On the grid two points lie on thousands of lines:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
    {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]}, {line = InfraLine[p, q]},
    InfraSubstrateHighlight[g, {line, p, q}, PlotLabel -> InfraMeasurement[g, line, "Cardinality"]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

Three of the lines, each drawn as a walk:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
  {lines = RandomInfraLine[g, InfraLine[p, q], 3, RandomSeeding -> 1]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[line], p, q}], {line, lines}]]
```

## Properties and Relations

[InfraLine]() and [InfraInfiniteLine]() have the same measurements:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
  {props = {"Cardinality", "Length", "CountingMeasure"}},
  InfraMeasurement[g, InfraLine[p, q], props] === InfraMeasurement[g, InfraInfiniteLine[p, q], props]]
```
