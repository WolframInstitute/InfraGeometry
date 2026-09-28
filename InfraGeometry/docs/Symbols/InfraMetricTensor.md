---
Template: Symbol
Name: InfraMetricTensor
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraMetricTensor
Keywords: [metric tensor, Gram matrix, projection, interval, cosine, tangent space, Euclid II.12]
SeeAlso: [InfraScalarProduct, InfraAngle, MetricInterval, FindClosestInfraPoint, FindInfraShell, OrthogonalCoordinates]
RelatedGuides: [EuclideanGeometryGuide]
---

## Usage

<code>[InfraMetricTensor]()[*g*, *p*]</code> gives the matrix over all pairs of vertices *v*, *w* of *d(p,u) / d(p,v)*, where *u* is the vertex of the interval *I(p,w)* closest to *v*. Rows and columns follow `VertexList[g]`.

<code>[InfraMetricTensor]()[*g*, *p*, *r*]</code> gives the same matrix restricted to the shell <code>[FindInfraShell]()[*g*, *p*, *r*]</code>, in the order of that shell.

## Details & Options

Definition: the interval is *I(p,w) = {u : d(p,u) + d(u,w) = d(p,w)}*, the vertices on some geodesic from *p* to *w*. The foot of *v* on it is a vertex *u* of the interval at least distance from *v*. The entry is the distance of the foot from the base, over the distance of *v* from the base:

*T[v, w] = d(p,u) / d(p,v)*

Rows are *v*, the projected vertex; columns are *w*, the end of the interval.

In the plane, the nearest point of the segment *[p,w]* to *v* lies at distance *clamp(|v| cos θ, 0, |w|)* from *p*, where θ is the angle at *p*. So *T = clamp(cos θ, 0, |w|/|v|)*, and on a circle about *p* it is *max(0, cos θ)*: the Gram matrix of the unit directions, with every angle of 90° or more read as 0. This is Euclid's projection of Book II, Propositions 12 and 13.

The row of *p* is 0, the column of *p* is 0, and the diagonal off *p* is 1. Every entry satisfies *0 ≤ T[v,w] ≤ d(p,w)/d(p,v)*. The matrix is not symmetric in general; on a shell it is symmetric on the square grid.

On the square grid the interval is a box and the foot is the coordinate clamp, unique. Then *T[v,w] = (d(p,v) + d(p,w) − d(v,w)) / (2 d(p,v))*, the Gromov product of *v* and *w* at *p* over *d(p,v)*. On a shell of radius *r* this is *1 − d(v,w)/(2r)* at every radius. The tensor is scale-invariant on the grid, so it does not approach the cosine as the radius grows: two diagonal directions at a right angle read 1/2, where the plane reads 0.

On a periodic tiling the rescaled path metric tends to a polyhedral norm, not the Euclidean one, and the tensor tends to the projection tensor of that norm. It approaches *max(0, cos θ)* only on substrates whose large-scale metric is round, such as a fine isotropic mesh.

The foot need not be unique. Where the large-scale norm has flat faces, as on the triangular tiling, *d(v, ·)* is constant along whole stretches of the interval, and many vertices tie. Option `"SelectCoordinate"` says which index *d(p,u)* of the tied feet is kept:

| Value | Entry |
|---|---|
| `Min` (default) | the smallest index |
| `Max` | the largest index |
| `Mean`, `Median` | the mean or median, a rational |
| `All` | the list of tied indices |
| *f* | *f* applied to that list |

The graph is assumed connected. The whole distance matrix is computed once and serves every row.

## Basic Examples

The tensor on a shell of radius 8 against the cosine of the angle between the two directions, on the discretized plane, the square grid and the hexagonal tiling. The gray curve is the plane's value *max(0, cos θ)*.

```wl
Row[Table[
  With[
    {g = InfraSubstrate[name, "Large", "KeepCoordinates" -> True]},
    {p = First @ GraphCenter[g]},
    {shell = FindInfraShell[g, p, 8]},
    {dirs = Normalize[AnnotationValue[{g, #}, VertexCoordinates] - AnnotationValue[{g, p}, VertexCoordinates]] & /@ shell},
    Show[
      ListPlot[Transpose[{Flatten[dirs . Transpose[dirs]], Flatten @ InfraMetricTensor[g, p, 8]}],
        PlotRange -> {{-1, 1}, {0, 1}}],
      Plot[Max[0, x], {x, -1, 1}, PlotStyle -> Gray],
      ImageSize -> 200, PlotLabel -> name]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}], Spacer[10]]
```

Along a path, based at an end, the entry is *min(d(p,v), d(p,w)) / d(p,v)*.

```wl
MatrixForm @ InfraMetricTensor[PathGraph[Range[5]], 1]
```

The shell form is the submatrix of the full one on the shell.

```wl
With[
  {g = GridGraph[{7, 7}]},
  {shell = FindInfraShell[g, 25, 2]},
  InfraMetricTensor[g, 25, 2] == InfraMetricTensor[g, 25][[shell, shell]]]
```

## Options

On the hexagon, the interval from 1 to 5 is 1, 6, 5, and its vertices 1 and 5 are both at distance 2 from 3. The four rules read that tie differently.

```wl
Table[sel -> InfraMetricTensor[CycleGraph[6], 1, "SelectCoordinate" -> sel][[3, 5]], {sel, {Min, Max, Mean, All}}]
```

On the triangular tiling the ties are the rule rather than the exception: the smallest and the largest foot differ in about two thirds of the entries of a shell.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Medium"]},
  {p = First @ GraphCenter[g]},
  {gap = InfraMetricTensor[g, p, 4, "SelectCoordinate" -> Max] - InfraMetricTensor[g, p, 4]},
  N @ Count[Flatten @ gap, _?Positive]/Length[Flatten @ gap]]
```

## Properties and Relations

The entry is the foot of *v* on the interval to *w*, read off the explicit construction.

```wl
With[
  {g = GridGraph[{7, 7}]},
  {feet = FindClosestInfraPoint[g, MetricInterval[g, 25, 40], 12]},
  {Min[GraphDistance[g, 25, #] & /@ feet]/GraphDistance[g, 25, 12], InfraMetricTensor[g, 25][[12, 40]]}]
```

On a shell of the square grid the tensor is one minus the distance over twice the radius, at every radius.

```wl
Table[
  With[
    {g = GridGraph[{2 r + 1, 2 r + 1}], p = 2 r^2 + 2 r + 1},
    {shell = FindInfraShell[g, p, r]},
    InfraMetricTensor[g, p, r] == 1 - GraphDistanceMatrix[g][[shell, shell]]/(2 r)],
  {r, 2, 6}]
```

The comparison cosine of [InfraScalarProduct]() reads −1 for two orthogonal neighbours on the grid, the same as for two opposite ones. The tensor reads 0 for both, which is right for the orthogonal pair.

```wl
With[
  {g = GridGraph[{5, 5}]},
  {InfraScalarProduct[g, 13, 12, 8], InfraMetricTensor[g, 13, 1]}]
```
