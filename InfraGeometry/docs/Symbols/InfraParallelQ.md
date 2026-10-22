---
Template: Symbol
Name: InfraParallelQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraParallelQ
Keywords: [parallel, constant distance, level set, Euclid Definition 23]
SeeAlso: [RandomInfraParallel, InfraPerpendicularQ, InfraInfiniteLineQ, InfraShell, RandomInfraInfiniteLine]
RelatedGuides: [Experimental]
---

## Usage

<code>[InfraParallelQ]()[*g*, *l₁*, *l₂*]</code> tests whether the vertex list *l₁* is parallel to *l₂* in *g*: disjoint from it, with every vertex of *l₁* at the same distance from *l₂*.

<code>[InfraParallelQ]()[*g*, *l₁*, *l₂*, *t*]</code> allows that distance to vary by up to *t*.

<code>[InfraParallelQ]()[*m*, *i₁*, *i₂*]</code> reads the distances from the matrix *m*, with *i₁* and *i₂* lists of row indices.

## Details & Options

*l₁* is parallel to *l₂* when they are disjoint and *d(v, l₂)* is the same for every *v* in *l₁*, where *d(v, l₂)* is the least distance from *v* to a vertex of *l₂*.

Disjointness is Euclid's Definition 23: parallels do not meet. So a line is not parallel to itself, and two sets that share one vertex are not parallel.

The test is not symmetric: it measures from *l₁* to *l₂*, and *l₁* lies on a level set of *l₂*. The arguments need not be lines; concentric shells are parallel. Test lines separately with [InfraInfiniteLineQ]().

A set in another component of *g* is at constant distance `Infinity` from *l₂*, so it is parallel to *l₂*; the empty set is parallel to every set, and every set to the empty set.

A walk graph, or a list of them, is read as its walks, and every walk of *l₁* is tested against every walk of *l₂*.

[RandomInfraParallel]() constructs a parallel through a point of a level set of the line, so its parallel is parallel to the line.

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Definition 23 | Parallel lines are those in a plane which do not meet, however far produced. |
| Euclid | Postulate 5 | The parallel postulate. |
| Hilbert | Group IV | Playfair's axiom: one parallel through a point off the line. |
| Tarski | A10 | Euclid's axiom, stated with betweenness and equidistance. |

## Basic Examples

The shells of radius 4 and 2 about the centre are parallel: every vertex of the outer one is at distance 2 from the inner one. Neither is a line:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {outer = Keys @ InfraMeasurement[g, InfraShell[c, 4], "VertexDensity"]},
    {inner = Keys @ InfraMeasurement[g, InfraShell[c, 2], "VertexDensity"]},
    InfraSubstrateHighlight[g, {outer, inner},
      PlotLabel -> {InfraParallelQ[g, outer, inner], InfraInfiniteLineQ[g, outer]}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

A line is not parallel to itself:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {line = RandomInfraInfiniteLine[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], RandomSeeding -> 1]},
  InfraParallelQ[g, line, line]]
```

## Scope

Two rows of the square grid, two apart. Their end vertices on the rim are at distance 3 from the other row, the rest at distance 2. They are parallel up to 1:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {y = AssociationThread[VertexList[g], GraphEmbedding[g][[All, 2]]]},
  {row = Select[VertexList[g], y[#] == y[c] &], other = Select[VertexList[g], y[#] == y[c] + 2 &]},
  InfraSubstrateHighlight[g, {row, other},
    PlotLabel -> {InfraParallelQ[g, row, other], InfraParallelQ[g, row, other, 1]}, ImageSize -> Medium]]
```

A distance matrix and lists of indices:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {outer = Keys @ InfraMeasurement[g, InfraShell[c, 4], "VertexDensity"]},
  {inner = Keys @ InfraMeasurement[g, InfraShell[c, 2], "VertexDensity"]},
  InfraParallelQ[GraphDistanceMatrix[g], VertexIndex[g, #] & /@ outer, VertexIndex[g, #] & /@ inner]]
```

## Properties and Relations

The test is not symmetric. Every vertex of a short piece of a row is at distance 2 from the row two above, but the vertices of that row are at different distances from the piece:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {y = AssociationThread[VertexList[g], GraphEmbedding[g][[All, 2]]]},
  {piece = Take[Select[VertexList[g], y[#] == y[c] &], {4, 6}]}, {other = Select[VertexList[g], y[#] == y[c] + 2 &]},
  InfraSubstrateHighlight[g, {piece, other},
    PlotLabel -> {InfraParallelQ[g, piece, other], InfraParallelQ[g, other, piece]}, ImageSize -> Medium]]
```
