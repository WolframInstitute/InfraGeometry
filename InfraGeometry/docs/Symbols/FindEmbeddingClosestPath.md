---
Template: Symbol
Name: FindEmbeddingClosestPath
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindEmbeddingClosestPath
Keywords: [snap, digitize, curve, rasterize, walk, embedding, nearest vertex]
SeeAlso: [EmbeddingClosest, InfraGenericQ, WalkSingularities, InfraWalk, GraphEmbedding]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[FindEmbeddingClosestPath]()[*g*, *curve*]</code> gives a walk of *g* that follows the plane curve *curve* in the drawing of *g*.

## Details & Options

The curve is sampled at points *x₁, x₂, …*. Each point goes to its nearest vertex in [GraphEmbedding]() of *g*, repeats in a row are dropped, and each vertex is joined to the next by a shortest path. The result is the walk through all of them, as a directed path graph.

The curve can be a [Line](), a [BSplineCurve](), a [BezierCurve](), a [Circle]() or a list of points, in the coordinates of the embedding. A spline is sampled at *max(64, 4n)* parameter values, with *n* control points, and a circle at 257 points. A line or a point list is used as given, so it should be sampled finely.

The walk can have singularities the curve does not: a strand snapped twice to the same edge is a self-tangency, and a crossing need not be a double point.

Unlike [EmbeddingClosest](), which selects among given walks, this constructs one walk.

## Basic Examples

A circle of radius 3.5 snapped to the grid, and of radius 0.35 to the mesh, whose coordinates fill the unit square:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {o = Mean @ GraphEmbedding[g], r = 0.35 Max[GraphEmbedding[g]]},
    InfraSubstrateHighlight[g, {FindEmbeddingClosestPath[g, Circle[o, r]]}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

A loop snapped to the mesh. It crosses itself once, at a double point:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {loop = Line[Table[{0.5, 0.5} + {0.25 (t^2 - 1.2), 0.2 t (t^2 - 1.2)}, {t, -1.7, 1.7, 0.05}]]},
  {w = FindEmbeddingClosestPath[g, loop]},
  InfraSubstrateHighlight[g, {w}, PlotLabel -> WalkSingularities[w]["SelfIntersections"], ImageSize -> Medium]]
```

## Scope

A Bézier curve on the grid:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  InfraSubstrateHighlight[g, {FindEmbeddingClosestPath[g, BezierCurve[{{2, 2}, {2, 9}, {9, 2}, {9, 9}}]]}, ImageSize -> Medium]]
```

## Possible Issues

A closed curve gives an open walk graph that starts and ends at the same vertex. The circle's walk has 29 vertices, the first equal to the last:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {circle = Line[Table[{5.5, 5.5} + 3.5 {Cos[t], Sin[t]}, {t, 0, 2 Pi, Pi/40}]]},
  {w = Last /@ SortBy[VertexList @ FindEmbeddingClosestPath[g, circle], First]},
  {Length[w], First[w] == Last[w]}]
```

A figure eight on the grid. At the crossing the two strands snap onto a common edge, a self-tangency, and at the rim the walk backtracks into a pendant vertex, a cusp. The curve has neither:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {eight = Line[Table[{5.5, 5.5} + {4 Sin[t], 3.5 Sin[t] Cos[t]}, {t, 0, 2 Pi, Pi/40}]]},
  {w = FindEmbeddingClosestPath[g, eight]},
  InfraSubstrateHighlight[g, {w}, PlotLabel -> Length /@ KeyDrop[WalkSingularities[w], "SelfIntersections"], ImageSize -> Medium]]
```
