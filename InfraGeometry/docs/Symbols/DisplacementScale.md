---
Template: Symbol
Name: DisplacementScale
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/DisplacementScale
Keywords: [displacement, scaling, scalar multiple, geodesic continuation, straightness]
SeeAlso: [DisplacementNegative, DisplacementSum, DisplacementCompose, DisplacementMagnitude, DisplacementReduce, DisplacementPlot]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[DisplacementScale]()[*g*, *d*, *t*]</code> is the displacement *d* scaled by *t*: each step is carried along the shortest paths of *g* to *|t|* times its length, through its base vertex for *t* < 0.

## Details & Options

Let *a* → *b* be a step of *D*. For *t ≥ 0* the candidates are the vertices *x* on a shortest path from *a* through *b*, *d(a, x) + d(x, b) = d(a, b)* or *d(a, x) = d(a, b) + d(b, x)*. For *t < 0* they are the vertices on a shortest path from *b* through *a*, *d(b, x) = d(b, a) + d(a, x)*.

Of the candidates, *tD(a)* keeps those with *d(a, x)* nearest to *|t| d(a, b)*, and of these the straightest. The straightest *x* carries the largest share of shortest paths through the middle vertex of the triple, *σ(p, q) σ(q, s) / σ(p, s)* for the triple *p, q, s* with *q* in the middle, *σ* the number of shortest paths. On the square grid this continues a step straight on.

Ties are kept, so a scaled step can have several values. Half a step of length 1 is both of its ends.

*t* = 1 gives *D*, *t* = 0 the identity and *t* = −1 is [DisplacementNegative]().

In the plane *s(tX) = (st)X*. On a graph scaling is not exactly multiplicative, and *tD* is not the *t*-fold composite of *D*.

## Basic Examples

One step from the centre scaled by 1, 2, 3 and 4, on the square grid and on the square mesh. On the grid the multiples go straight on; on the mesh they fork:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    DisplacementPlot[g, Table[DisplacementScale[g, <|c -> {First @ AdjacencyList[g, c]}|>, t], {t, 4}]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The step right of the grid scaled by 2 and by −1:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {right = TranslationDisplacement[g, {1, 0}]},
  GraphicsRow @ Table[DisplacementPlot[g, DisplacementScale[g, right, t], PlotLabel -> t], {t, {2, -1}}]]
```

## Scope

Half a step is both of its ends:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  DisplacementScale[g, <|c -> {First @ AdjacencyList[g, c]}|>, 1/2]]
```

The scales 0 and 1 are the identity and the displacement:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {t = TranslationDisplacement[g, {1/8, 0}]},
  {DisplacementScale[g, t, 0] === AssociationMap[List, VertexList[g]], DisplacementScale[g, t, 1] === t}]
```

## Properties and Relations

A step of length 1 scaled by *t* lands at distance *t*. On the mesh, the distances of the values from the centre:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  Table[GraphDistance[g, c, #] & /@ DisplacementScale[g, <|c -> {First @ AdjacencyList[g, c]}|>, t][c], {t, 0, 4}]]
```

## Possible Issues

Scaling is not composition. At the vertex 75 of the grid three times the step right, in blue, bends to the two pendant vertices at distance 3; three steps right, in red, stop at the pendant vertex at distance 2:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {right = TranslationDisplacement[g, {1, 0}]},
  {tripled = DisplacementScale[g, right, 3], composite = DisplacementCompose[right, right, right]},
  DisplacementPlot[g, {KeyTake[tripled, {75}], KeyTake[composite, {75}]}, PlotLabel -> {tripled[75], composite[75]}]]
```

Scaling is not exactly multiplicative. On the mesh twice the double of a step is not four times the step:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {step = <|c -> {First @ AdjacencyList[g, c]}|>},
  {DisplacementScale[g, DisplacementScale[g, step, 2], 2][c], DisplacementScale[g, step, 4][c]}]
```
