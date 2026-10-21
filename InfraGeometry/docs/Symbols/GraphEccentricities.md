---
Template: Symbol
Name: GraphEccentricities
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/GraphEccentricities
Keywords: [eccentricity, radius, diameter, graph center, periphery, distance matrix]
SeeAlso: [RelativeEccentricity, GraphCenter, CenterGraph, EffectiveResistance, VertexEccentricity]
RelatedGuides: [Experimental]
---

## Usage

<code>[GraphEccentricities]()[*g*]</code> gives the eccentricities of the vertices of *g*, in the order of [VertexList]().

<code>[GraphEccentricities]()[*m*]</code> gives the eccentricities of the points of the distance matrix *m*, the largest entry of each row.

## Details & Options

The eccentricity of a vertex *v* is *e(v) = max d(v, w)* over the vertices *w*, the distance to a farthest vertex.

The least eccentricity is the radius of *g*, [GraphRadius](), taken on the [GraphCenter](). The largest is the diameter, [GraphDiameter](), taken on the [GraphPeriphery]().

Along an edge the eccentricity changes by at most 1, and *e(v) ≤ e(c) + d(c, v)* for any vertex *c*.

Any distance matrix can be given, such as the [EffectiveResistance]() matrix. On a graph with several components every eccentricity is [Infinity]().

## Basic Examples

The level sets of the eccentricity, each in its own colour, and the radius and the diameter. On the grid they are squares with sides along the axes, not the diamonds of the balls:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {e = GraphEccentricities[g]},
    {levels = Values @ KeySort @ GroupBy[Transpose[{VertexList[g], e}], Last -> First]},
    InfraSubstrateHighlight[g, levels, PlotLabel -> MinMax[e]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The eccentricity against the distance from the centre. It grows almost as fast as the distance: *e(v) − d(c, v)* is 7, 8 or 9 on the grid and 5 or 6 on the mesh, never more than the radius:

```wl
ListPlot[
  Table[
    With[{g = InfraSubstrate[name, "Small"]},
      Transpose[{GraphDistance[g, First @ GraphCenter[g]], GraphEccentricities[g]}]],
    {name, {"SquareGridGraph", "SquareMeshGraph"}}],
  PlotLegends -> {"SquareGridGraph", "SquareMeshGraph"}, AxesLabel -> {"d(c, v)", "e(v)"}]
```

## Scope

A distance matrix: the eccentricities of the grid in effective resistance. The vertices of least and of largest resistance eccentricity:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {e = GraphEccentricities[EffectiveResistance[g]]},
  InfraSubstrateHighlight[g, {Pick[VertexList[g], e, Min[e]], Pick[VertexList[g], e, Max[e]]},
    PlotLabel -> MinMax[e], ImageSize -> Medium]]
```

## Properties and Relations

The least value is the radius and the largest the diameter, and every value is the [VertexEccentricity]():

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {e = GraphEccentricities[g]},
  InfraSubstrateHighlight[g, {GraphCenter[g], GraphPeriphery[g]},
    PlotLabel -> {MinMax[e] == {GraphRadius[g], GraphDiameter[g]}, e === (VertexEccentricity[g, #] & /@ VertexList[g])},
    ImageSize -> Medium]]
```

## Possible Issues

On a graph with several components every eccentricity is [Infinity](), including the eccentricity within a component:

```wl
GraphEccentricities[GraphUnion[CycleGraph[5], PathGraph[{6, 7, 8}]]]
```
