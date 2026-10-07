---
Template: Symbol
Name: DisplacementScale
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/DisplacementScale
Keywords: [displacement, scalar multiple, geodesic continuation, midpoint, reflection, straightest geodesic]
SeeAlso: [DisplacementNegative, DisplacementSum, DisplacementCompose, DisplacementMagnitude, DisplacementPlot]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[DisplacementScale]()[*g*, *d*, *t*]</code> scales the displacement *d* by *t*: each step from *v* to a vertex *w* of *d*(*v*) is carried along the shortest paths of *g* from *v* through *w* to the vertices nearest the distance |*t*| *d*(*v*, *w*), and for *t* < 0 through *v* in the opposite direction.

## Details & Options

Definition: let *a* → *b* be a step of *D*. For *t ≥ 0* the candidates are the vertices on a shortest path from *a* through *b*: the interval, *d(a, x) + d(x, b) = d(a, b)*, and the vertices beyond *b*, *d(a, x) = d(a, b) + d(b, x)*. For *t < 0* they are the vertices beyond *a* on a shortest path from *b*, *d(b, x) = d(b, a) + d(a, x)*. Of the candidates, *tD* keeps those whose distance from *a* is nearest to *|t| d(a, b)*, and of these the straightest. The value of *tD* at *a* is the union over the steps from *a*.

The straightest candidates are those through which the largest fraction of the shortest paths between the two outer vertices of the aligned triple pass: *σ(p, q) σ(q, s) / σ(p, s)* for the triple *p*, *q*, *s* with *q* in the middle, *σ* the number of shortest paths. On the square and triangular tilings this continues a step straight on. On the hexagonal tiling no shortest path goes straight through a vertex, and twice a step has two values.

Ties are kept. Half a step of length 1 is both of its ends, since 0 and 1 are equally near 1/2. Where the straight continuation leaves the graph, at the rim, the step bends to the straightest vertices still reached; where every continuation ends, at the far side of a cycle, it stops there.

*t* = 1 gives *D*, *t* = 0 the identity and *t* = −1 is [DisplacementNegative](). Scaling is not exactly multiplicative: *s(tD)* and *(st)D* can differ where the shortest paths end or fork.

## Basic Examples

A single step from the centre, scaled by 1, 2, 3 and 4, on the square, triangular and hexagonal tilings. On the first two the multiples go straight on; on the hexagonal tiling they fork.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {step = <|First @ GraphCenter[g] -> {First @ AdjacencyList[g, First @ GraphCenter[g]]}|>},
    DisplacementPlot[g, Table[DisplacementScale[g, step, t], {t, 4}]]],
  {name, {"SquareTilingGraph", "TriangularTilingGraph", "HexagonalTilingGraph"}}]
```

The rotation of the 12-cycle by one step and three times it.

```wl
With[
  {g = CycleGraph[12]},
  {rotation = FindKillingDisplacement[g]},
  {tripled = DisplacementScale[g, rotation, 3]},
  {DisplacementPlot[g, {rotation, tripled}], tripled[1]}]
```

## Scope

The step right on the 6 × 6 grid scaled by 2, by −1 and by 1/2. In the interior the doubled step goes two steps right. Next to the right column the straight continuation leaves the grid, and the doubled step turns to the two vertices beyond the last step. The halved step has both ends of the step as its values; the vertex itself is not drawn.

```wl
With[
  {g = GridGraph[{6, 6}]},
  {right = TranslationDisplacement[g, {1, 0}]},
  GraphicsRow[Table[DisplacementPlot[g, DisplacementScale[g, right, t]], {t, {2, -1, 1/2}}]]]
```

On the cycle a third of three times the rotation is the rotation.

```wl
With[
  {g = CycleGraph[12]},
  {rotation = FindKillingDisplacement[g]},
  {third = DisplacementScale[g, DisplacementScale[g, rotation, 3], 1/3]},
  {DisplacementPlot[g, third], third === rotation}]
```

## Properties and Relations

The magnitude grows with the factor while the shortest paths last. On the 12-cycle they end at the opposite vertex, at distance 6, so 7 times the rotation is the map to the opposite vertex, as 6 times is.

```wl
With[
  {g = CycleGraph[12]},
  {rotation = FindKillingDisplacement[g]},
  {DisplacementPlot[g, DisplacementScale[g, rotation, 7]],
   Table[DisplacementMagnitude[g, DisplacementScale[g, rotation, t]], {t, 1, 7}],
   DisplacementScale[g, rotation, 7] === DisplacementScale[g, rotation, 6]}]
```

Scaling by −1 is [DisplacementNegative]().

```wl
With[
  {g = GridGraph[{6, 6}]},
  {right = TranslationDisplacement[g, {1, 0}]},
  {DisplacementPlot[g, DisplacementScale[g, right, -1]], DisplacementScale[g, right, -1] === DisplacementNegative[g, right]}]
```

## Possible Issues

Scaling is not composition. Three times the step right is the step three to the right where the grid allows it, while the composite of three steps right stops at the rim one step at a time.

```wl
With[
  {g = GridGraph[{6, 6}]},
  {right = TranslationDisplacement[g, {1, 0}]},
  {GraphicsRow[{DisplacementPlot[g, DisplacementScale[g, right, 3]], DisplacementPlot[g, DisplacementCompose[right, right, right]]}],
   DisplacementScale[g, right, 3] === DisplacementCompose[right, right, right]}]
```
