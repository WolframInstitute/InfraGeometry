---
Template: Symbol
Name: EmbeddingClosest
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/EmbeddingClosest
Keywords: [straightest path, Hausdorff distance, embedding, drawing, digital straight line, selection]
SeeAlso: [FindEmbeddingClosestPath, SelectInfraWalk, RandomInfraSegment, RandomInfraCircle, GraphEmbedding]
---

## Usage

<code>[EmbeddingClosest]()[*g*, *walks*, *curve*]</code> keeps the walks whose drawing is closest to the plane curve *curve*.

<code>[EmbeddingClosest]()[*g*, *walks*, {*p*, *q*}]</code> keeps the walks drawn closest to the straight segment from the vertex *p* to the vertex *q*.

<code>[EmbeddingClosest]()[*g*, *cycles*, {*c*, *r*}]</code> compares the cycles with the circle of radius *r* about the vertex *c*.

<code>[EmbeddingClosest]()[*g*, *ref*]</code> is the operator form.

## Details & Options

A walk is drawn as the polygonal line through the positions of its vertices in [GraphEmbedding]() of *g*: the vertex coordinates when *g* has them, a spring embedding otherwise. Closeness is the Hausdorff distance between that line and the reference. All walks at the least distance are kept.

The walks can be vertex lists or walk graphs; a walk graph comes back as a graph. The curve can be a [Line](), [BSplineCurve](), [BezierCurve]() or a list of points.

The selection uses the drawing, not the graph metric. Shortest paths all have the same length; on the square grid the ones closest to the straight segment are the staircases that stay nearest the diagonal.

For cycles given as vertex lists, the circle form returns every cycle, ordered by the largest deviation *|‖x − c‖ − r|* of a vertex position *x*. Cycle graphs keep only those at the least Hausdorff distance from the circle.

## Basic Examples

The shortest paths from the centre to a point at distance 6, and those drawn closest to the straight segment:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {b = RandomInfraPoint[g, InfraShell[c, 6], RandomSeeding -> 2]},
    {line = Line[AnnotationValue[{g, #}, VertexCoordinates] & /@ {c, b}]},
    {closest = EmbeddingClosest[g, RandomInfraSegment[g, c, b, All], line]},
    InfraSubstrateHighlight[g, {InfraSegment[c, b], InfraWalk /@ closest}, PlotLabel -> Length[closest]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The operator form:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[c, 6], RandomSeeding -> 2]},
  {line = Line[AnnotationValue[{g, #}, VertexCoordinates] & /@ {c, b}]},
  EmbeddingClosest[g, line][RandomInfraSegment[g, c, b, All]] == EmbeddingClosest[g, RandomInfraSegment[g, c, b, All], line]]
```

## Scope

A curved reference, given as a list of points. The shortest path from the centre, at (5, 5), to *b*, at (8, 8), drawn closest to the quarter circle of radius 3 joining them:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[c, 6], RandomSeeding -> 2]},
  {arc = Table[{8, 5} + 3 {Cos[t], Sin[t]}, {t, Pi/2, Pi, Pi/32}]},
  InfraSubstrateHighlight[g, {InfraWalk /@ EmbeddingClosest[g, RandomInfraSegment[g, c, b, All], arc]}, ImageSize -> Medium]]
```

## Possible Issues

The vertices of the substrates are integers, so a pair {*p*, *q*} of vertices also matches the circle form {*c*, *r*}, and that reading wins: all 20 paths come back, ordered. Give the segment as a [Line]() of the two positions instead:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[c, 6], RandomSeeding -> 2]},
  {members = RandomInfraSegment[g, c, b, All], line = Line[AnnotationValue[{g, #}, VertexCoordinates] & /@ {c, b}]},
  {Length @ EmbeddingClosest[g, members, {c, b}], Length @ EmbeddingClosest[g, members, line]}]
```
