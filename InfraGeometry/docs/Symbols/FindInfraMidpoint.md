---
Template: Symbol
Name: FindInfraMidpoint
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraMidpoint
Keywords: [midpoint, geodesic, bisection, effective point, Euclid I.10]
SeeAlso: [FindInfraSegment, InfraPoint, InfraDensity, FindInfraReflection, BetweennessQ]
RelatedGuides: [EuclideanGeometryGuide]
---

## Usage

<code>[FindInfraMidpoint]()[*g*, *a*, *b*]</code> gives the midpoint vertices of *a* and *b* in the graph *g*, unioned over every geodesic between them.

<code>[FindInfraMidpoint]()[*g*, {*walk1*, …}]</code> uses the supplied walks — vertex lists or walk graphs — instead of all geodesics.

## Details & Options

A midpoint of *a* and *b* is a vertex *m* with $d(a,m) = d(m,b) = d(a,b)/2$.

On a graph the midpoint is a **set**, not a point. Distinct geodesics from *a* to *b* put their centre at different vertices, and every one of them is returned.

At odd $d(a,b)$ no vertex lies at half the distance. The two central vertices of each geodesic are returned instead.

The result is the density `<|v -> m|>` of candidates, *m* counting the geodesics centred at *v*; dividing by `Total` gives the fraction centred at each vertex.

Option `Method` takes `"Metric"` (default), which reads the graph distance, or `"Embedding"`, which ranks candidates by an embedding of the geodesic bundle.

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Proposition I.10 | To cut a given finite straight-line in half. |
| Hilbert | Group III, congruence | The midpoint of a segment exists and is unique, by segment congruence. |
| Tarski | A4 with A2 | The point between *a* and *b* equidistant from both, from segment construction and congruence transitivity. |
| Birkhoff | Ruler postulate | The point at ruler coordinate $(a+b)/2$. |

## Basic Examples

The midpoint of two vertices at distance 6, on the discretized plane, the square grid and the hexagonal tiling. The count differs with the substrate: two midpoints on the irregular mesh, three on the square grid, two on the hexagonal tiling.

```wl
Row[Table[
   With[
     {g = InfraSubstrate[name, "Large", "KeepCoordinates" -> True]},
     {a = First @ GraphCenter[g]},
     {b = First @ Sort @ Select[VertexList[g], GraphDistance[g, a, #] == 6 &]},
     {m = FindInfraMidpoint[g, a, b]},
     Labeled[
       InfraHighlightGraph[g,
         {FindInfraSegment[g, a, b, All] -> $InfraSegmentColor,
          {a, b} -> $InfraPointColor,
          Keys[m] -> $InfraCircleColor},
         "PointSizeRange" -> 17,
         VertexShapeFunction -> ({AbsolutePointSize[2.2], Point[#]} &),
         ImageSize -> 250],
       Text[name <> ": " <> ToString[Length @ m] <> " midpoints"]]],
   {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]]
```

On the square grid the geodesics between the two vertices are centred on three different vertices. Dividing the density by its total gives the fraction of them that chooses each.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Large", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = First @ Sort @ Select[VertexList[g], GraphDistance[g, a, #] == 6 &]},
  {m = FindInfraMidpoint[g, a, b]},
  Normal[m / Total[m]]]
```

At odd distance no vertex sits halfway, and the central pair of each geodesic is returned instead.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Large", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = First @ Sort @ Select[VertexList[g], GraphDistance[g, a, #] == 5 &]},
  {GraphDistance[g, a, b], Keys @ FindInfraMidpoint[g, a, b]}]
```

## Properties and Relations

The midpoint lies between its endpoints, so [BetweennessQ]() holds for every candidate.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Large", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = First @ Sort @ Select[VertexList[g], GraphDistance[g, a, #] == 6 &]},
  AllTrue[Keys @ FindInfraMidpoint[g, a, b], BetweennessQ[g, a, #, b] &]]
```
