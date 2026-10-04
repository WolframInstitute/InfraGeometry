---
Template: Symbol
Name: FindInfraTriangle
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraTriangle
Keywords: [triangle, corners, geodesic sides, product class, Euclid I.22]
SeeAlso: [InfraTriangle, FindInfraPolygon, CompleteInfraEquilateralTriangle, FindInfraSegment, InfraTriangleQ, ComparisonTriangle]
RelatedGuides: [Experimental]
---

## Usage

<code>[FindInfraTriangle]()[*g*, {*a*, *b*, *c*}]</code> gives one triangle with corners *a*, *b*, *c* in *g* — a geodesic on each side — as the `List` of its three sides, one directed path graph each.

<code>[FindInfraTriangle]()[*g*, {*a*, *b*, *c*}, *n*]</code> gives a `List` of exactly *n* triangles or `$Failed`; `UpTo[n]` gives up to *n*; `All` gives the whole class.

## Details & Options

A triangle with corners *a*, *b*, *c* is three geodesics, *a … b*, *b … c* and *c … a*. It is the three-corner case of [FindInfraPolygon]() and shares its engine, options and defaults: corners are vertices, each triangle is the `List` of its three sides, one directed path graph each, and its perimeter is the total edge count of the sides.

The class is the product of the three geodesic classes, so the count multiplies. Below, the triangle on the centre of each substrate and two vertices at distance 4 from it and from each other has 18 members on the irregular mesh, 36 on the square tiling and 8 on the hexagonal — all of perimeter 12.

Nothing in the definition keeps the sides apart. On the 3×3 grid with corners 1, 3, 9 the side from 9 to 1 may retrace the two others, and the class admits it, since each side is a geodesic on its own.

`All` forms the product. A bounded count never does: it streams that many geodesics per side and reads the first members of their product, so the count-less call — one triangle, the first geodesic of every side — is cheap and deterministic, and a strict count is exact.

| Option | Values | Meaning |
|---|---|---|
| `"NextVertexFunction"` | `Identity` (default), `RandomSample`, any function | forwarded to the side geodesics: a bounded or absent count takes each side's geodesics in the order the function gives, `Identity` the canonical order, `RandomSample` a random order, seeded by an ambient `SeedRandom`. The class is the same under every value. |

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Definition 19 | A trilateral figure is one contained by three straight lines. |
| Euclid | Proposition I.22 | To construct a triangle out of three straight lines equal to three given straight lines. |
| Hilbert | (defined) | A triangle is three points not on a line together with the segments joining them. |

## Basic Examples

How many triangles have the centre of each substrate and two vertices at distance 4 from it and from each other as corners.

```wl
Association @ Table[
   name -> With[
     {g = InfraSubstrate[name, "Medium", "KeepCoordinates" -> True]},
     {c = First @ GraphCenter[g]},
     {b = First @ Sort @ Select[VertexList[g], GraphDistance[g, c, #] == 4 &]},
     {d = Last @ Sort @ Select[VertexList[g], GraphDistance[g, c, #] == 4 && GraphDistance[g, b, #] == 4 &]},
     Length @ FindInfraTriangle[g, {c, b, d}, All]],
   {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]
```

All of them at once, drawn diffusely: a side lying on many triangles is drawn more strongly than one lying on few.

```wl
Row[Table[
   With[
     {g = InfraSubstrate[name, "Medium", "KeepCoordinates" -> True]},
     {c = First @ GraphCenter[g]},
     {b = First @ Sort @ Select[VertexList[g], GraphDistance[g, c, #] == 4 &]},
     {d = Last @ Sort @ Select[VertexList[g], GraphDistance[g, c, #] == 4 && GraphDistance[g, b, #] == 4 &]},
     Labeled[
       InfraSubstrateHighlight[g,
         {FindInfraTriangle[g, {c, b, d}, All] -> $InfraSegmentColor,
          {c, b, d} -> $InfraPointColor},
         "PointSizeRange" -> 15,
         VertexShapeFunction -> ({AbsolutePointSize[2.2], Point[#]} &),
         ImageSize -> 250],
       Text[name]]],
   {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]]
```

## Scope

On the 3×3 grid the corners 1, 3, 9 carry six triangles. The count-less call is one of them — its third side retraces the other two — and a strict count of seven is `$Failed`.

```wl
With[
  {g = GridGraph[{3, 3}]},
  {FindInfraTriangle[g, {1, 3, 9}],
   Length @ FindInfraTriangle[g, {1, 3, 9}, All],
   FindInfraTriangle[g, {1, 3, 9}, 7]}]
```

## Options

### NextVertexFunction

The class is the same under every next-vertex function; only the order in which triangles come off it differs, and `RandomSample` draws the witness in random order, so the seed goes in front.

```wl
SeedRandom[1]; With[
  {g = GridGraph[{3, 3}]},
  {SameQ @@ (Sort @ FindInfraTriangle[g, {1, 3, 9}, All, "NextVertexFunction" -> #] & /@
      {Identity, RandomSample}),
   FindInfraTriangle[g, {1, 3, 9}, "NextVertexFunction" -> RandomSample]}]
```

## Properties and Relations

Every triangle satisfies [InfraTriangleQ](), and the class is the polygon class on the same three corners.

```wl
With[
  {g = GridGraph[{3, 3}]},
  {InfraTriangleQ[g, FindInfraTriangle[g, {1, 3, 9}, All]],
   FindInfraTriangle[g, {1, 3, 9}, All] === FindInfraPolygon[g, {1, 3, 9}, All]}]
```

The perimeter is the sum of the three corner distances.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {b = First @ Sort @ Select[VertexList[g], GraphDistance[g, c, #] == 4 &]},
  {d = Last @ Sort @ Select[VertexList[g], GraphDistance[g, c, #] == 4 && GraphDistance[g, b, #] == 4 &]},
  Total[EdgeCount /@ FindInfraTriangle[g, {c, b, d}]] === GraphDistance[g, c, b] + GraphDistance[g, b, d] + GraphDistance[g, d, c]]
```
