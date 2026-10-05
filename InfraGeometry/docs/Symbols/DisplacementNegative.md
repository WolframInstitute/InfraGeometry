---
Template: Symbol
Name: DisplacementNegative
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/DisplacementNegative
Keywords: [displacement, negative, reflection, point reflection, metric negative]
SeeAlso: [DisplacementScale, DisplacementInverse, DisplacementBracket, DisplacementCommutator, DisplacementPlot]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[DisplacementNegative]()[*g*, *d*]</code> is the metric negative of the displacement *d*: each step from *v* to a vertex *w* of *d*(*v*) is reflected through *v*.

## Details & Options

Definition: *−D* = <code>[DisplacementScale]()[*g*, *d*, -1]</code>. For a step *a* → *b* the candidates are the vertices beyond *a* on a shortest path from *b*, *d(b, x) = d(b, a) + d(a, x)*; *−D(a)* keeps those at the distance from *a* nearest to *d(a, b)*, and of these the straightest, as in [DisplacementScale]().

The negative is not the inverse. [DisplacementInverse]() reverses the relation and needs no metric; the negative reflects each step through its base vertex and needs no injectivity. For a rotation of a cycle the two agree.

Where no shortest path from *b* continues straight beyond *a*, at the rim, the reflected step takes the straightest of the vertices that are still on such a path. On a grid these are the neighbours of *a* beside the step.

## Basic Examples

The negative of the translation by one step on the discretized plane, the square tiling and the hexagonal tiling. On the two tilings it is the translation in the opposite direction, except at the rim. On the discretized plane, whose shortest paths are irregular, the reflected steps point backwards only roughly.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[First[pair], "Small", "KeepCoordinates" -> True]},
    DisplacementPlot[g, DisplacementNegative[g, TranslationDisplacement[g, Last[pair]]]]],
  {pair, {{"SquareMeshGraph", {0.1, 0}}, {"SquareTilingGraph", {1, 1}}, {"HexagonalTilingGraph", {1.5, Sqrt[3]/2}}}}]
```

On the 6 × 6 grid the negative of the step right is the step left. In the left column no shortest path from the right neighbour continues straight, and the reflected step goes to the vertical neighbours.

```wl
With[
  {g = GridGraph[{6, 6}]},
  {right = TranslationDisplacement[g, {1, 0}]},
  DisplacementPlot[g, {right, DisplacementNegative[g, right]}]]
```

## Properties and Relations

On the 12-cycle the negative of the rotation is the inverse rotation.

```wl
With[
  {g = CycleGraph[12]},
  {rotation = FindKillingDisplacement[g]},
  {DisplacementPlot[g, {rotation, DisplacementNegative[g, rotation]}], DisplacementNegative[g, rotation] === DisplacementInverse[rotation]}]
```

On the grid they differ in the left column: the inverse of the step right has no value there, the negative turns sideways.

```wl
With[
  {g = GridGraph[{6, 6}]},
  {right = TranslationDisplacement[g, {1, 0}]},
  {GraphicsRow[{DisplacementPlot[g, DisplacementNegative[g, right]], DisplacementPlot[g, DisplacementInverse[right]]}],
   Keys @ Select[DisplacementInverse[right], # === {} &]}]
```

The negative of the negative is the displacement itself, except in the left column, where the first negative turned sideways. The corners come back.

```wl
With[
  {g = GridGraph[{6, 6}]},
  {right = TranslationDisplacement[g, {1, 0}]},
  {twice = DisplacementNegative[g, DisplacementNegative[g, right]]},
  {DisplacementPlot[g, twice], Select[Keys[right], twice[#] =!= right[#] &]}]
```
