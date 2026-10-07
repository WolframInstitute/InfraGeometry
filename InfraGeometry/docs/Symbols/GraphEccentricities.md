---
Template: Symbol
Name: GraphEccentricities
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/GraphEccentricities
Keywords: [eccentricity, radius, diameter, graph center, periphery, distance matrix]
SeeAlso: [RelativeEccentricity, GraphCenter, CenterGraph, EffectiveResistance]
RelatedGuides: [Experimental]
---

## Usage

<code>[GraphEccentricities]()[*g*]</code> gives the eccentricities of the vertices of *g*, in the order of [VertexList]().

<code>[GraphEccentricities]()[*m*]</code> gives the eccentricities of the points of the distance matrix *m*, the largest entry of each row.

## Details & Options

Definition: the eccentricity of a vertex *v* is *e*(*v*) = max *d*(*v*, *w*) over the vertices *w*, the distance to a farthest vertex. The least eccentricity is the radius of *g*, [GraphRadius](), reached on the [GraphCenter](); the largest is the diameter, [GraphDiameter](), reached on the [GraphPeriphery]().

It is [VertexEccentricity]() at every vertex at once, read off one [GraphDistanceMatrix](). Any other distance matrix may be given instead, such as the [EffectiveResistance]() matrix.

Along an edge the eccentricity changes by at most 1. On a graph with several components every eccentricity is [Infinity]().

## Basic Examples

The level sets of the eccentricity on the square, hexagonal and triangular tilings, each in its own colour, and the least and the largest value, the radius and the diameter.

```wl
With[
  {panels = Table[
     With[
       {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
       {eccentricities = AssociationThread[VertexList[g], GraphEccentricities[g]]},
       {InfraSubstrateHighlight[g, AssociationThread[#, 1] & /@ Values[KeySort @ GroupBy[Keys[eccentricities], eccentricities]]], MinMax[eccentricities]}],
     {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]},
  {GraphicsRow[First /@ panels], Last /@ panels}]
```

On the three tilings the eccentricity is the radius plus the distance from the centre: the farthest vertex lies across the centre, on the rim.

```wl
ListPlot[
  Table[
    With[
      {g = InfraSubstrate[name, "Small"]},
      Transpose[{GraphDistance[g, First @ GraphCenter[g], #] & /@ VertexList[g], GraphEccentricities[g]}]],
    {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}],
  PlotLegends -> {"square", "hexagonal", "triangular"}, AxesLabel -> {"d(c, v)", "e(v)"}]
```

## Scope

A distance matrix: the eccentricities of the square tiling under the effective resistance, blue at the least and red at the largest. The rim is far in resistance too, and the corners, each held by one edge, are farthest.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {eccentricities = GraphEccentricities[EffectiveResistance[g]]},
  {InfraSubstrateHighlight[g, MapThread[#1 -> Blend[{StandardBlue, StandardRed}, #2] &, {VertexList[g], Rescale[eccentricities]}]], MinMax[eccentricities]}]
```

## Properties and Relations

The centre, red, has the least eccentricity, the radius, and the periphery, blue, the largest, the diameter. The values agree with [VertexEccentricity]().

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {eccentricities = GraphEccentricities[g]},
  {InfraSubstrateHighlight[g, {GraphCenter[g] -> StandardRed, GraphPeriphery[g] -> StandardBlue}],
   MinMax[eccentricities] == {GraphRadius[g], GraphDiameter[g]}, eccentricities === (VertexEccentricity[g, #] & /@ VertexList[g])}]
```

## Possible Issues

On a graph with several components every eccentricity is [Infinity](); the eccentricity within a component is not given.

```wl
With[
  {g = GraphUnion[CycleGraph[5], PathGraph[{6, 7, 8}]]},
  {g, GraphEccentricities[g]}]
```
