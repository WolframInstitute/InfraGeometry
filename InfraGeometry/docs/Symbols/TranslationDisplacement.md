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

<code>[TranslationDisplacement]()[*g*, *u*]</code> is the translation of *g* by the vector *u*: each vertex moves to the vertices whose coordinates are nearest to its own coordinates plus *u*.

## Details & Options

The translation is *Tᵤ(v) = {w : |x(w) − x(v) − u| is least}*, with *x(v)* the coordinates of *v* given by [GraphEmbedding]().

A displacement is an [Association]() *v* -> {*w1*, *w2*, …} from the vertices to sets of vertices: the discrete counterpart of the flow of a vector field for a short time.

The translation reads the coordinates, not the graph metric. A step of length |*u*| in the plane can be a longer or a shorter step in the graph.

Ties are kept, up to an absolute tolerance of 10⁻⁶. A vector that is not in the lattice of the graph lands between vertices, and all the nearest ones are values.

On a finite graph the translation is not a bijection. Near the rim the translated point falls outside the graph and the vertex moves to the nearest vertices of the rim; nothing arrives at the opposite rim.

## Basic Examples

The translation by one step to the right, on the square grid and on the square mesh. On the mesh the step is 1/8, the spacing of its rim:

```wl
GraphicsRow @ KeyValueMap[
  {name, u} |-> With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    DisplacementPlot[g, TranslationDisplacement[g, u]]],
  <|"SquareGridGraph" -> {1, 0}, "SquareMeshGraph" -> {1/8, 0}|>]
```

The steps right and up of the grid, in blue and red:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  DisplacementPlot[g, {TranslationDisplacement[g, {1, 0}], TranslationDisplacement[g, {0, 1}]}]]
```

## Scope

Half a diagonal step lands at the centre of a square. Its four corners are equally near, and the translation keeps all four:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {half = TranslationDisplacement[g, {1/2, 1/2}]},
  DisplacementPlot[g, KeyTake[half, {c}], PlotLabel -> half[c]]]
```

## Properties and Relations

The step lengths in the graph, with their counts. On the grid every vertex of degree 4 moves one step; a pendant vertex of the top or the bottom row moves three, to the next pendant vertex. On the mesh the steps have lengths 0, 1 and 2:

```wl
GraphicsRow @ KeyValueMap[
  {name, u} |-> With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {t = TranslationDisplacement[g, u]},
    {lengths = Flatten @ KeyValueMap[{v, ws} |-> (GraphDistance[g, v, #] & /@ ws), t]},
    DisplacementPlot[g, t, PlotLabel -> KeySort @ Counts[lengths]]],
  <|"SquareGridGraph" -> {1, 0}, "SquareMeshGraph" -> {1/8, 0}|>]
```

The translation is not a bijection. The inverse is empty at the 10 vertices nothing arrives at, all on the left of the grid:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {t = TranslationDisplacement[g, {1, 0}]},
  {empty = Keys @ Select[DisplacementInverse[t], # === {} &]},
  InfraSubstrateHighlight[g, {empty}, PlotLabel -> {DisplacementBijectionQ[t], Length[empty]}, ImageSize -> Medium]]
```

## Possible Issues

The tolerance for a tie is absolute. On coordinates of size 10⁻⁷ every vertex is within it, and the translation by zero keeps every vertex as a value at the centre:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {small = Graph[g, VertexCoordinates -> 10^-7 GraphEmbedding[g]]},
  Length /@ {TranslationDisplacement[g, {0, 0}][c], TranslationDisplacement[small, {0, 0}][c]}]
```
