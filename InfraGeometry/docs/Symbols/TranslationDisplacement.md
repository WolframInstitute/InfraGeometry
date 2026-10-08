---
Template: Symbol
Name: TranslationDisplacement
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/TranslationDisplacement
Keywords: [displacement, translation, embedding, coordinates, nearest vertex, lattice]
SeeAlso: [PolarDisplacements, GradientDisplacement, DisplacementSum, DisplacementCompose, DisplacementPlot]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[TranslationDisplacement]()[*g*, *u*]</code> translates by the vector *u* of the embedding of *g*: each vertex moves to the vertices whose coordinates are nearest to its own coordinates plus *u*.

## Details & Options

Definition: with *x(v)* the coordinates of *v* given by [GraphEmbedding](), *T_u(v) = { w : |x(w) − (x(v) + u)| is least }*. Ties are kept, up to rounding: every vertex whose distance is within *10^-6* of the least one is a value.

The translation reads coordinates, not the graph metric: a substrate is translated in its lattice with `"KeepCoordinates"` -> `True`, and in a computed layout without it. A vector of the lattice of a tiling moves every inner vertex onto a vertex; at the rim the translated position falls outside the patch, and the vertex moves to the nearest vertices of the rim, so the translation of a patch is not a bijection. A vector that is not in the lattice lands between vertices, where several can be nearest. The tolerance *10^-6* is absolute, which suits coordinates at unit edge length.

## Basic Examples

The translation by one step on the discretized plane, the square tiling and the hexagonal tiling. On the hexagonal tiling the step is a vector of the lattice, two edges long.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[First[pair], "Small", "KeepCoordinates" -> True]},
    DisplacementPlot[g, TranslationDisplacement[g, Last[pair]]]],
  {pair, {{"SquareMeshGraph", {0.1, 0}}, {"SquareTilingGraph", {1, 1}}, {"HexagonalTilingGraph", {3/2, Sqrt[3]/2}}}}]
```

On the 6 × 6 grid the translations by {1, 0} and {0, 1} are the steps right and up, clamped at the rim.

```wl
With[
  {g = GridGraph[{6, 6}]},
  {right = TranslationDisplacement[g, {1, 0}], up = TranslationDisplacement[g, {0, 1}]},
  {DisplacementPlot[g, {right, up}], right[1], up[1], right[36]}]
```

## Scope

Half a step of the square tiling lands halfway between a vertex and its neighbour, and the translation keeps both.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {half = TranslationDisplacement[g, {1/2, 1/2}]},
  {DisplacementPlot[g, half], half[First @ GraphCenter[g]]}]
```

The translation of the hexagonal tiling by one edge, {1, 0}, sends each inner vertex onto a vertex or to the centre of a hexagon, at distance 1 from its six corners. The six corners tie, up to rounding, and the translation keeps all of them. The counts of the numbers of values:

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {translation = TranslationDisplacement[g, {1, 0}]},
  {DisplacementPlot[g, translation], Normal @ KeySort @ Counts[Length /@ Values[translation]]}]
```

## Properties and Relations

Translations of the 6 × 6 grid compose to the translation by the sum of the vectors.

```wl
With[
  {g = GridGraph[{6, 6}]},
  {composite = DisplacementCompose[TranslationDisplacement[g, {1, 0}], TranslationDisplacement[g, {0, 1}]]},
  {DisplacementPlot[g, composite], composite === TranslationDisplacement[g, {1, 1}]}]
```

The translation of a patch is not a bijection: nothing arrives at the trailing rim, and several vertices arrive at the leading rim.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {translation = TranslationDisplacement[g, {3/2, Sqrt[3]/2}]},
  {DisplacementPlot[g, translation], DisplacementSingleValuedQ[translation], DisplacementBijectionQ[translation], Count[Values[DisplacementInverse[translation]], {}]}]
```

## Possible Issues

The tolerance for a tie is the absolute *10^-6*. On coordinates of that size every vertex is within it, and the translation by zero, which should leave every vertex fixed, keeps many. The number of values at the centre of the hexagonal tiling, at unit edge length and scaled by *10^-7*:

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {small = Graph[g, VertexCoordinates -> 10^-7 GraphEmbedding[g]]},
  {center = First @ GraphCenter[g]},
  Length /@ {TranslationDisplacement[g, {0, 0}][center], TranslationDisplacement[small, {0, 0}][center]}]
```
