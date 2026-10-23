---
Template: Symbol
Name: InfraRegularPolygonQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraRegularPolygonQ
Keywords: [regular polygon, equilateral, square, diagonal, test]
SeeAlso: [InfraRegularPolygon, RandomInfraRegularPolygon, InfraSegment, InfraDistance]
---

## Usage

<code>[InfraRegularPolygonQ]()[*g*, {*v1*, …, *vn*}, {*a1*, …, *am*}]</code> gives `True` if the corners *v1*, …, *vn*, taken cyclically, form a regular *n*-gon whose *k*-th diagonals have length *ak*.

## Details & Options

The corners must be distinct, *n ≥ 3*, and *d(vᵢ, vᵢ₊ₖ)*, indices mod *n*, must be the same for every *i* and satisfy the *k*-th entry:

| Entry | The *k*-th diagonals |
|---|---|
| an integer *a* | all of length *a* |
| {*lo*, *hi*} | all of one length between *lo* and *hi* |
| [Automatic]() | all of one length |

At most ⌊*n*/2⌋ entries are allowed; with more the test gives `False`.

The polygon is a corner list, open or closed, the list of sides that [RandomInfraRegularPolygon]() returns, or a list of such lists, which passes when each one does.

In an [InfraScene](), `InfraRegularPolygonQ[x, {a1, …}]` is the assertion that *x* is such a polygon.

## Basic Examples

The diamond, the axis square and a rectangle on the grid, with every shortest path between consecutive corners. The first two are regular, with diagonals 2 and 4; the rectangle is not:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {InfraSegment @@ Append[corners, First @ corners], corners},
      PlotLabel -> InfraRegularPolygonQ[g, corners, {Automatic, Automatic}]],
    {corners, {{35, 46, 55, 44}, {45, 47, 67, 65}, {45, 47, 57, 55}}}]]
```

A tuple fixes the diagonals. The axis square has side 2 and diagonal 4:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  Table[InfraRegularPolygonQ[g, {45, 47, 67, 65}, as], {as, {{2, 4}, {2, 2}, {{1, 3}, Automatic}}}]]
```

## Scope

The sides returned by [RandomInfraRegularPolygon]() pass:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  InfraRegularPolygonQ[g, RandomInfraRegularPolygon[g, {4}, 3, 5, "From" -> 45, RandomSeeding -> 5], {4}]]
```

## Possible Issues

More entries than ⌊*n*/2⌋ give `False`, even when the distances fit:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, InfraRegularPolygonQ[g, {35, 46, 55, 44}, {2, 2, 2}]]
```
