---
Template: Symbol
Name: RelativeEccentricity
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RelativeEccentricity
Keywords: [relative eccentricity, eccentricity, radius, diameter, graph center, periphery, depth]
SeeAlso: [GraphEccentricities, CenterGraph, GraphCenter]
RelatedGuides: [Experimental]
---

## Usage

<code>[RelativeEccentricity]()[*g*]</code> gives (*e*(*v*) − *r*)/(*D* − *r*) for every vertex *v* of *g*, in the order of [VertexList](): 0 on the centre and 1 on the periphery.

<code>[RelativeEccentricity]()[*m*]</code> gives the same numbers for the points of the distance matrix *m*.

## Details & Options

Definition: with *e*(*v*) the eccentricity of *v*, [GraphEccentricities](), *r* the radius and *D* the diameter of *g*, the relative eccentricity is *t*(*v*) = (*e*(*v*) − *r*)/(*D* − *r*). It runs from 0 exactly on the [GraphCenter]() to 1 exactly on the [GraphPeriphery]().

On a graph the eccentricity is an integer, so *t* takes at most *D* − *r* + 1 values, 0, 1/(*D* − *r*), …, 1. The sets {*t* ≤ *q*} are nested, and each holds the centre.

When *D* = *r*, as on a vertex-transitive graph, and on a graph with several components, every value is 0.

## Basic Examples

The relative eccentricity on the square, hexagonal and triangular tilings, blue at 0 and red at 1, and the number of its values. On a tiling it is the distance from the centre divided by the radius.

```wl
With[
  {panels = Table[
     With[
       {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
       {depths = RelativeEccentricity[g]},
       {InfraSubstrateHighlight[g, MapThread[#1 -> Blend[{StandardBlue, StandardRed}, #2] &, {VertexList[g], depths}]], CountDistinct[depths]}],
     {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]},
  {GraphicsRow[First /@ panels], Last /@ panels}]
```

The vertices with relative eccentricity at least 3/4, the outer rings of each tiling.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    InfraSubstrateHighlight[g, {AssociationThread[Pick[VertexList[g], Thread[RelativeEccentricity[g] >= 3/4]], 1]}]],
  {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]
```

## Scope

The level sets follow the shape of the graph: on a 16 × 6 grid they are bands across it, rising from its middle toward both ends, and on the irregular discretized plane they are rings about its middle.

```wl
GraphicsRow @ Table[
  InfraSubstrateHighlight[g, MapThread[#1 -> Blend[{StandardBlue, StandardRed}, #2] &, {VertexList[g], RelativeEccentricity[g]}]],
  {g, {GridGraph[{16, 6}], InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}}]
```

## Properties and Relations

The relative eccentricity is the eccentricity rescaled to the interval from 0 to 1. Its zeros are the [GraphCenter]() and its ones the [GraphPeriphery]().

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {depths = RelativeEccentricity[g]},
  {InfraSubstrateHighlight[g, {Pick[VertexList[g], depths, 0] -> StandardBlue, Pick[VertexList[g], depths, 1] -> StandardRed}],
   depths == Rescale[GraphEccentricities[g]], Pick[VertexList[g], depths, 0] === GraphCenter[g], Sort[Pick[VertexList[g], depths, 1]] === Sort[GraphPeriphery[g]]}]
```

## Possible Issues

On a vertex-transitive graph every vertex is both centre and periphery, and the relative eccentricity is 0 everywhere, not 1 on the periphery.

```wl
With[
  {g = CycleGraph[8]},
  {g, RelativeEccentricity[g], GraphPeriphery[g]}]
```
