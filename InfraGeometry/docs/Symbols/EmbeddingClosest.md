---
Template: Symbol
Name: EmbeddingClosest
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/EmbeddingClosest
Keywords: [straightest path, Hausdorff distance, embedding, drawing, digital straight line, digital circle, selection]
SeeAlso: [FindEmbeddingClosestPath, SelectInfraWalk, RandomInfraSegment, RandomInfraCircle, GraphEmbedding]
---

## Usage

<code>[EmbeddingClosest]()[*g*, *walks*, *curve*]</code> keeps the walks whose drawing is closest to the plane curve *curve*.

<code>[EmbeddingClosest]()[*g*, *walks*, {*p*, *q*}]</code> keeps the walks drawn closest to the straight segment from the vertex *p* to the vertex *q*.

<code>[EmbeddingClosest]()[*g*, *ref*]</code> is the operator form.

## Details & Options

A walk is drawn as the polygonal line through the positions of its vertices in [GraphEmbedding]() of *g*: the vertex coordinates when *g* has them, a spring embedding otherwise. Closeness is the Hausdorff distance between that line and the reference. All walks at the least distance are kept.

The walks can be vertex lists or walk graphs; a walk graph comes back as a graph. A cycle graph is drawn closed; a vertex list is drawn as given, so a closed walk lists its first vertex again at the end.

The curve can be a [Line](), [BSplineCurve](), [BezierCurve](), [Circle]() or a list of points, in the coordinates of the embedding.

The selection uses the drawing, not the graph metric. Shortest paths all have the same length; on the square grid the ones closest to the straight segment are the staircases that stay nearest the diagonal.

## Basic Examples

The shortest paths from the centre to a point at distance 6, and those drawn closest to the straight segment:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {b = RandomInfraPoint[g, InfraShell[c, 6], RandomSeeding -> 2]},
    {closest = EmbeddingClosest[g, RandomInfraSegment[g, c, b, All], {c, b}]},
    InfraSubstrateHighlight[g, {InfraSegment[c, b], InfraWalk /@ closest}, PlotLabel -> Length[closest]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The operator form:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[c, 6], RandomSeeding -> 2]},
  EmbeddingClosest[g, {c, b}][RandomInfraSegment[g, c, b, All]] == EmbeddingClosest[g, RandomInfraSegment[g, c, b, All], {c, b}]]
```

## Scope

A curved reference, given as a list of points. The shortest path from the centre, at (5, 5), to *b*, at (8, 8), drawn closest to the quarter circle of radius 3 joining them:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[c, 6], RandomSeeding -> 2]},
  {arc = Table[{8, 5} + 3 {Cos[t], Sin[t]}, {t, Pi/2, Pi, Pi/32}]},
  InfraSubstrateHighlight[g, {InfraWalk /@ EmbeddingClosest[g, RandomInfraSegment[g, c, b, All], arc]}, ImageSize -> Medium]]
```

A [Circle](). Of the 16 cycles in the band 2 ≤ *d*(*c*, *v*) ≤ 4 about the centre, the ones drawn closest to the circle of radius 3:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {cycles = RandomInfraCircle[g, InfraCircle[c, {2, 4}], All]},
  {closest = EmbeddingClosest[g, Append[#, First[#]] & /@ cycles, Circle[{5, 5}, 3]]},
  InfraSubstrateHighlight[g, {InfraWalk /@ closest, c}, PlotLabel -> Length[closest], ImageSize -> Medium]]
```

## Possible Issues

A pair {*c*, *r*} is not a circle. When *r* is a vertex it is the segment from *c* to the vertex *r*; otherwise the call stays unevaluated. A circle is a [Circle]() in the coordinates of the embedding:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {cycles = Append[#, First[#]] & /@ RandomInfraCircle[g, InfraCircle[c, {2, 4}], All]},
  {Head @ EmbeddingClosest[g, cycles, {c, 3.}],
   EmbeddingClosest[g, cycles, {c, 3}] ==
     EmbeddingClosest[g, cycles, Line[AnnotationValue[{g, #}, VertexCoordinates] & /@ {c, 3}]]}]
```
