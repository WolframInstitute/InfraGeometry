---
Template: Symbol
Name: DisplacementNegative
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/DisplacementNegative
Keywords: [displacement, negative, reflection, opposite step, metric]
SeeAlso: [DisplacementScale, DisplacementInverse, DisplacementBracket, DisplacementCommutator, DisplacementPlot]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[DisplacementNegative]()[*g*, *d*]</code> is the metric negative of the displacement *d*: each step is reflected through its base vertex.

## Details & Options

For a step *a* → *b* the candidates are the vertices *x* that continue a shortest path from *b* through *a*, *d(b, x) = d(b, a) + d(a, x)*. The negative *−D(a)* keeps those with *d(a, x)* nearest to *d(a, b)*, and of these the straightest. It is <code>[DisplacementScale]()[*g*, *d*, −1]</code>, where the straightest candidates are defined.

In the plane the negative of the flow of *X* for time *r* is the flow of *−X*. On a graph the reflected step can have several values, or none beyond the base vertex: then the vertex stays.

The negative is not the inverse. [DisplacementInverse]() reverses the relation and needs no metric; the negative needs no injectivity. On a cycle the two agree for a rotation.

## Basic Examples

The step right in blue and its negative in red, on the square grid and on the square mesh:

```wl
GraphicsRow @ KeyValueMap[
  {name, s} |-> With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {t = TranslationDisplacement[g, {s, 0}]},
    DisplacementPlot[g, {t, DisplacementNegative[g, t]}]],
  <|"SquareGridGraph" -> 1, "SquareMeshGraph" -> 1/8|>]
```

The vertices where the negative of the step right is the step left. On the grid that is 50 of 96, away from the rim; on the mesh 26 of 102:

```wl
GraphicsRow @ KeyValueMap[
  {name, s} |-> With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {negative = DisplacementNegative[g, TranslationDisplacement[g, {s, 0}]]},
    {left = TranslationDisplacement[g, {-s, 0}]},
    {agree = Select[VertexList[g], negative[#] === left[#] &]},
    InfraSubstrateHighlight[g, {agree}, PlotLabel -> Length[agree]]],
  <|"SquareGridGraph" -> 1, "SquareMeshGraph" -> 1/8|>]
```

## Scope

The vertex 85 of the grid steps right to a pendant vertex. Every way on from a pendant vertex is equally straight, so the negative has three values:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {right = TranslationDisplacement[g, {1, 0}]},
  {negative = DisplacementNegative[g, right]},
  DisplacementPlot[g, {KeyTake[right, {85}], KeyTake[negative, {85}]}, PlotLabel -> negative[85]]]
```

## Properties and Relations

The negative is the scale by −1:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {t = TranslationDisplacement[g, {1/8, 0}]},
  DisplacementNegative[g, t] === DisplacementScale[g, t, -1]]
```

On a 12-cycle the negative of a rotation is its inverse:

```wl
With[{g = CycleGraph[12]}, {rotation = FindKillingDisplacement[g]},
  DisplacementNegative[g, rotation] === DisplacementInverse[rotation]]
```

The negative of the negative is the displacement only away from the rim. The 52 vertices of the grid where it differs from the step right:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {right = TranslationDisplacement[g, {1, 0}]},
  {twice = DisplacementNegative[g, DisplacementNegative[g, right]]},
  {differ = Select[VertexList[g], twice[#] =!= right[#] &]},
  InfraSubstrateHighlight[g, {differ}, PlotLabel -> Length[differ], ImageSize -> Medium]]
```
