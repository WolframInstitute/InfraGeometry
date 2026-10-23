---
Template: Symbol
Name: InfraMetricTensor
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraMetricTensor
Keywords: [metric tensor, Gram matrix, projection, interval, cosine, tangent space, Euclid II.12]
SeeAlso: [InfraScalarProduct, InfraComparisonAngle, MetricInterval, FindClosestInfraPoint, InfraShell, OrthogonalCoordinates]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

<code>[InfraMetricTensor]()[*g*, *p*]</code> gives the matrix *T* over all pairs of vertices *v*, *w* of *g*, with *T[v, w] = d(p, u) / d(p, v)* for *u* the vertex of the interval *I(p, w)* closest to *v*.

<code>[InfraMetricTensor]()[*g*, *p*, *r*]</code> gives the matrix over the vertices of the shell <code>[InfraShell]()[*p*, *r*]</code>.

## Details & Options

The interval is *I(p, w) = {u : d(p, u) + d(u, w) = d(p, w)}*, the vertices on the shortest paths from *p* to *w*. The vertex *u* of *I(p, w)* closest to *v* is the foot of *v*, and *T[v, w]* is the length of the projection of *v* on the direction of *w*, over the length of *v*. Rows are *v*, columns *w*. The rows and columns of the full matrix follow [VertexList](); those of the shell matrix follow the sorted shell.

In the plane the foot of *v* on the segment from *p* to *w* gives *T = max(0, cos θ)* on a circle about *p*, with *θ* the angle at *p*: the Gram matrix of the unit directions, an obtuse angle read as 0. This is Euclid's projection of Book II, Propositions 12 and 13.

The row and the column of *p* are 0; the diagonal elsewhere is 1. In general *0 ≤ T[v, w] ≤ d(p, w)/d(p, v)*, and *T* is not symmetric.

On the square grid the foot is unique, and on a shell of radius *r*, *T[v, w] = 1 − d(v, w)/(2r)* at every radius. So the grid tensor does not approach the cosine: two axis directions read 0, as in the plane, but two diagonal directions at a right angle read 1/2.

The foot need not be unique. `"SelectCoordinate"` says which value *d(p, u)* of the tied feet is used:

| Option | Default | Values |
|---|---|---|
| `"SelectCoordinate"` | [Min]() | [Min](), [Max](), [Mean](), `All` (the list of the tied values), or a function of that list |

## Basic Examples

One row of the tensor on the circle of radius 4: the projection of a fixed vertex on the direction of each vertex of the circle, drawn as the size of the vertex:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
    {circle = Keys @ InfraMeasurement[g, InfraShell[p, 4], "VertexDensity"]},
    {v = RandomInfraPoint[g, InfraShell[p, 4], RandomSeeding -> 1]},
    {row = InfraMetricTensor[g, p, 4][[First @ FirstPosition[circle, v]]]},
    InfraSubstrateHighlight[g, {AssociationThread[circle, row], v, p}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The tensor on the circle of radius 6 against the cosine of the angle at the centre, with the plane's value *max(0, cos θ)*. The entries are multiples of 1/6, and on both substrates some obtuse angles read positive; on the grid the entries are *1 − d(v, w)/12*:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Medium", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
    {circle = Keys @ InfraMeasurement[g, InfraShell[p, 6], "VertexDensity"]},
    {xy = AssociationThread[VertexList[g], GraphEmbedding[g]]},
    {dirs = Normalize[xy[#] - xy[p]] & /@ circle},
    Show[
      ListPlot[Transpose[{Flatten[dirs . Transpose[dirs]], Flatten @ InfraMetricTensor[g, p, 6]}],
        PlotRange -> {{-1, 1}, {0, 1}}],
      Plot[Max[0, x], {x, -1, 1}]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

Along a path, based at an end, *T[v, w] = min(d(p, v), d(p, w)) / d(p, v)*:

```wl
MatrixForm @ InfraMetricTensor[PathGraph[Range[5]], 1]
```

## Scope

The shell matrix is the submatrix of the full one on the shell:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {p = First @ GraphCenter[g]},
  {indices = VertexIndex[g, #] & /@ Keys @ InfraMeasurement[g, InfraShell[p, 2], "VertexDensity"]},
  InfraMetricTensor[g, p, 2] == InfraMetricTensor[g, p][[indices, indices]]]
```

## Options

### SelectCoordinate

On the hexagon the interval from 1 to 5 is 1, 6, 5, and both its ends are 2 away from 3. The rules read that tie differently:

```wl
Table[sel -> InfraMetricTensor[CycleGraph[6], 1, "SelectCoordinate" -> sel][[3, 5]], {sel, {Min, Max, Mean, All}}]
```

## Properties and Relations

On a shell of the square grid the tensor is *1 − d(v, w)/(2r)*, at every radius:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium"]}, {p = First @ GraphCenter[g]},
  Table[With[{circle = Keys @ InfraMeasurement[g, InfraShell[p, r], "VertexDensity"]},
      InfraMetricTensor[g, p, r] == 1 - Outer[GraphDistance[g, #1, #2] &, circle, circle]/(2 r)], {r, 2, 6}]]
```

The entry is the foot of *v* on the interval to *w*. The interval, the feet of *v* on it, and the entry computed from them:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {w = RandomInfraPoint[g, InfraShell[p, 5], RandomSeeding -> 1]},
  {v = RandomInfraPoint[g, InfraShell[p, 4], RandomSeeding -> 2]},
  {interval = MetricInterval[g, p, w]}, {feet = FindClosestInfraPoint[g, interval, v, All]},
  {entry = InfraMetricTensor[g, p][[VertexIndex[g, v], VertexIndex[g, w]]]},
  InfraSubstrateHighlight[g, {interval, feet, v, w, p}, PlotLabel -> {Min[GraphDistance[g, p, #] & /@ feet]/4, entry},
    ImageSize -> Medium]]
```

For two perpendicular neighbours of the centre of the grid the comparison scalar product is −1, the value of two opposite ones. The tensor on the circle of radius 1 reads 0 for them, the plane's value at a right angle:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {Table[InfraScalarProduct[g, 45, 55, v], {v, {46, 35}}], MatrixForm @ InfraMetricTensor[g, 45, 1]}]
```
