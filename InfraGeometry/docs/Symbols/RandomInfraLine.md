---
Template: Symbol
Name: RandomInfraLine
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraLine
Keywords: [line, inextensible shortest path, Euclid Postulate 2, parallel postulate]
SeeAlso: [InfraLine, InfraLineQ, RandomInfraRepresentative, RandomInfraGeodesic, RandomInfraSegment, RandomInfraRay, RandomInfraParallel, LineCount]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraLine]()[*g*, *a*, *b*]</code> gives one line through *a* and *b* in *g* — an inextensible shortest path containing both — as a vertex list.

<code>[RandomInfraLine]()[*g*, *seq*]</code> gives one line containing the shortest-path vertex list *seq* as a contiguous subsequence.

<code>[RandomInfraLine]()[*g*, *a*, *b*, *n*]</code> gives a `List` of exactly *n* lines or `{}`; `UpTo[n]` gives up to *n*; `All` gives every line.

## Details & Options

The default draw is random. Seed with `SeedRandom` to reproduce it. Give `"NextVertexFunction" -> Identity` for deterministic descent. `All` with `Automatic` keeps the full enumeration without drawing.

A line is an **inextensible shortest path**: a shortest path that no neighbour of either endpoint prolongs. [InfraLineQ]() is the predicate, and every line returned satisfies it.

That is the intrinsic reading of Euclid's second postulate — produce a finite straight line continuously — and it is where the analogy with the plane breaks hardest. In the plane two points determine one line. On a lattice they determine an enormous family: below, two vertices at distance 5 on a 313-vertex square-tiling patch lie on 5 242 880 lines, against 6144 on the hexagonal tiling and 1386 on the irregular mesh.

The search runs on the substrate directly: a shortest path from *a* to *b*, prolonged one shortest-path step at a time, every prolongation at the back and then every prolongation at the front, kept when neither end can be prolonged. It does not read the graph of <code>[InfraLine]()[*a*, *b*]</code>, so it is the check on that graph, and it returns exactly the shapes [RandomInfraRepresentative]() gives for that head.

The search enumerates. To count lines, use <code>[InfraMeasurement]()[*g*, [InfraLine]()[*a*, *b*], "Cardinality"]</code>, which reads the count off the head's graph without enumerating a line.

The count-less call is one random line. There is no `Method` and no `Properties`.

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Postulate 2 | To produce a finite straight-line continuously in a straight-line. |
| Euclid | Postulate 5 | The parallel postulate, which quantifies over lines and so is a statement about this family. |
| Hilbert | I.1, I.2 | Two distinct points determine one and only one line. |
| Tarski | (derived) | Lines are not primitive; collinearity is defined from betweenness. |
| Birkhoff | Ruler postulate | A line is a set of points in bijection with the reals. |

## Basic Examples

How many lines pass through two vertices at distance 5. Uniqueness does not merely fail — on the square tiling the family is enormous, and the head counts it without enumerating a single line.

```wl
Association @ Table[
   name -> With[
     {g = InfraSubstrate[name, "Medium", "KeepCoordinates" -> True]},
     {a = First @ GraphCenter[g]},
     {b = First @ Sort @ Select[VertexList[g], GraphDistance[g, a, #] == 5 &]},
     InfraMeasurement[g, InfraLine[a, b], "Cardinality"]],
   {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]
```

Three of them on each substrate.

```wl
SeedRandom[1];
Row[Table[
   With[
     {g = InfraSubstrate[name, "Medium", "KeepCoordinates" -> True]},
     {a = First @ GraphCenter[g]},
     {b = First @ Sort @ Select[VertexList[g], GraphDistance[g, a, #] == 5 &]},
     Labeled[
       InfraSubstrateHighlight[g,
         {RandomInfraLine[g, a, b, UpTo[3]], {a, b}},
         "PointSizeRange" -> 15,
         VertexShapeFunction -> ({AbsolutePointSize[2.2], Point[#]} &),
         ImageSize -> 250],
       Text[name]]],
   {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]]
```

## Scope

Through an edge of the 6-cycle there are three lines, not four: the ends 5 and 4 are each admissible on their own side, but the pair is not.

```wl
SeedRandom[1];
RandomInfraLine[CycleGraph[6], 1, 2, All]
```

The count-less call is one line; a bounded count gives a list, and a strict count that cannot be met is `{}`.

```wl
SeedRandom[1];
{RandomInfraLine[CycleGraph[6], 1, 2], RandomInfraLine[CycleGraph[6], 1, 2, 2], RandomInfraLine[CycleGraph[6], 1, 2, 5]}
```

A given shortest path prolongs to the lines containing it.

```wl
SeedRandom[1];
RandomInfraLine[GridGraph[{4, 4}], {1, 2, 6}, All]
```

## Properties and Relations

Every line satisfies [InfraLineQ]().

```wl
SeedRandom[1];
InfraLineQ[GridGraph[{4, 4}], RandomInfraLine[GridGraph[{4, 4}], 6, 7, All]]
```

The search agrees with the graph of the head.

```wl
SeedRandom[1];
With[
  {g = GridGraph[{4, 4}]},
  Sort @ RandomInfraLine[g, 6, 7, All] === Sort @ RandomInfraRepresentative[g, InfraLine[6, 7], All]]
```

A line through an edge is that edge extended with no budget.

```wl
SeedRandom[1];
With[
  {g = GridGraph[{4, 4}]},
  {Length @ RandomInfraLine[g, {6, 7}, All], InfraMeasurement[g, InfraLine[6, 7], "Cardinality"]}]
```
