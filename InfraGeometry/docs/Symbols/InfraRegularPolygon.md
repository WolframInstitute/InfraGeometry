---
Template: Symbol
Name: InfraRegularPolygon
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraRegularPolygon
Keywords: [regular polygon, equilateral triangle, square, diagonal, symbolic object, scene]
SeeAlso: [RandomInfraRegularPolygon, InfraRegularPolygonQ, InfraPolygon, InfraSegment, InfraScene]
---

## Usage

<code>[InfraRegularPolygon]()[{*a1*, …, *am*}, *n*]</code> is the family of the regular *n*-gons whose *k*-th diagonals have length *ak*.

## Details & Options

A member is a cyclic sequence of distinct corners *v₁*, …, *vₙ* with *d(vᵢ, vᵢ₊ₖ)* the same for every *i*, and joined by shortest paths. The *k*-th entry is an integer, a range {*lo*, *hi*} or [Automatic](), as in [RandomInfraRegularPolygon](); at most ⌊*n*/2⌋ entries are given.

[InfraRegularPolygon]() is a symbolic object: [RandomInfraRegularPolygon]() draws members, each as the closed vertex sequence along its sides, and [InfraRegularPolygonQ]() tests corners. In an [InfraScene]() it is a construction whose realisations are the members.

The polygon through given corners *p1*, …, *pn* is the closed polyline <code>[InfraSegment]()[*p1*, …, *pn*, *p1*]</code>.

## Basic Examples

An equilateral triangle of side 4 through the centre of the grid:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {seq = RandomInfraRegularPolygon[g, InfraRegularPolygon[{4}, 3], "From" -> 45, RandomSeeding -> 5]},
  InfraSubstrateHighlight[g, {InfraWalk[Append[seq, First @ seq]], 45}, ImageSize -> Medium]]
```

In a scene: the squares of side 2 on the grid, all 228 of them:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  Length @ RandomInfraSceneInstance[InfraScene[{sq}, {sq == InfraRegularPolygon[{2, Automatic}, 4]}], g, All]]
```
