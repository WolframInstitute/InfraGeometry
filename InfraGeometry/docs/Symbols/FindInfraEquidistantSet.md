---
Template: Symbol
Name: FindInfraEquidistantSet
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraEquidistantSet
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

`FindInfraEquidistantSet[graph, {p1, ..., pn}]` returns the equidistant set {v : d(p1, v) == ... == d(pn, v)} as a sorted vertex list, the intersection of the n-1 consecutive perpendicular bisectors.

`FindInfraEquidistantSet[graph, {p1, ..., pn}, {lo, hi}]` thickens each consecutive bisector to the slab lo <= d(p_i, v) - d(p_{i+1}, v) <= hi.


## Details & Options

The set $\{v : d(p_1,v) = \dots = d(p_n,v)\}$ is the intersection of the $n-1$ consecutive perpendicular bisectors $\{v : d(p_i,v) = d(p_{i+1},v)\}$. For two points it is their bisector, for three points it is where the circumcentre would be.

On a bipartite substrate the set of two points at odd distance is empty, since $d(p_1,v) + d(v,p_2)$ has the parity of $d(p_1,p_2)$ and cannot be twice an integer.

The slab form $\{v : \mathrm{lo} \le d(p_i,v) - d(p_{i+1},v) \le \mathrm{hi}\}$ thickens each bisector by the tolerance, so a thin bisector stays visible at small scale.

## Basic Examples

The bisector of two vertices at distance 8, on the irregular mesh, the square grid and the hexagonal tiling.

```wl
Row[Table[
   With[
     {g = InfraSubstrate[name, "Large", "KeepCoordinates" -> True]},
     {c = First @ GraphCenter[g]},
     {a = First @ Sort @ Select[VertexList[g], GraphDistance[g, c, #] == 4 &]},
     {b = First @ Sort @ Select[VertexList[g], GraphDistance[g, c, #] == 4 && GraphDistance[g, a, #] == 8 &]},
     {set = FindInfraEquidistantSet[g, {a, b}]},
     Labeled[
       InfraSubstrateHighlight[g,
         {set, {a, b}},
         "PointSizeRange" -> 17,
         VertexShapeFunction -> ({AbsolutePointSize[2.2], Point[#]} &),
         ImageSize -> 250],
       Text[name <> ": " <> ToString[Length @ set] <> " vertices"]]],
   {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]]
```

Three points cut the bisector of the first two down to the vertices that are also equidistant from the third.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Large", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {a = First @ Sort @ Select[VertexList[g], GraphDistance[g, c, #] == 4 &]},
  {b = First @ Sort @ Select[VertexList[g], GraphDistance[g, c, #] == 4 && GraphDistance[g, a, #] == 8 &]},
  {two = FindInfraEquidistantSet[g, {a, b}]},
  {three = FindInfraEquidistantSet[g, {a, b, c}]},
  InfraSubstrateHighlight[g,
    {two, three, {a, b, c}},
    "PointSizeRange" -> 17,
    VertexShapeFunction -> ({AbsolutePointSize[2.2], Point[#]} &),
    ImageSize -> 300]]
```

## Properties and Relations

Every midpoint of two vertices is equidistant from them, so [InfraMeasurement]() with `"Midpoint"` lands inside the bisector.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Large", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {a = First @ Sort @ Select[VertexList[g], GraphDistance[g, c, #] == 4 &]},
  {b = First @ Sort @ Select[VertexList[g], GraphDistance[g, c, #] == 4 && GraphDistance[g, a, #] == 8 &]},
  SubsetQ[FindInfraEquidistantSet[g, {a, b}], Keys @ InfraMeasurement[g, InfraSegment[a, b], "Midpoint"]]]
```
