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

<code>[RelativeEccentricity]()[*g*]</code> gives the list of the relative eccentricities *(e(v) − r)/(D − r)* of the vertices *v* of *g*, in the order of [VertexList]().

<code>[RelativeEccentricity]()[*m*]</code> gives the relative eccentricities of the points of the distance matrix *m*.

## Details & Options

With *e(v)* the eccentricity of *v*, [GraphEccentricities](), *r* the radius and *D* the diameter, the relative eccentricity is *t(v) = (e(v) − r)/(D − r)*. It is 0 exactly on the [GraphCenter]() and 1 exactly on the [GraphPeriphery]().

The eccentricity is an integer, so *t* takes at most *D − r + 1* values: 0, 1/(*D − r*), …, 1.

On the square grid *e(v) = r + d(v, C)*, with *C* the centre, so *t(v) = d(v, C)/(D − r)* and the level sets of *t* are the rings about the centre.

When *D = r*, as on a vertex-transitive graph, and on a disconnected graph, every value is 0.

## Basic Examples

The relative eccentricity on the square grid and on the square mesh, blue at 0 and red at 1, and the number of its values:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {t = RelativeEccentricity[g]},
    InfraSubstrateHighlight[g, MapThread[#1 -> Blend[{StandardBlue, StandardRed}, #2] &, {VertexList[g], t}],
      PlotLabel -> CountDistinct[t]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The vertices of relative eccentricity at least 3/4, the outer part of each graph:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    InfraSubstrateHighlight[g, {Pick[VertexList[g], Thread[RelativeEccentricity[g] >= 3/4]]}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Scope

A distance matrix gives the same values as its graph:

```wl
With[{g = PathGraph[Range[5]]}, {RelativeEccentricity[g], RelativeEccentricity[GraphDistanceMatrix[g]]}]
```

## Properties and Relations

The zeros are the centre, the ones the periphery, and the values are the eccentricities rescaled to the interval from 0 to 1:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {t = RelativeEccentricity[g]},
  {Pick[VertexList[g], t, 0] === GraphCenter[g], Sort @ Pick[VertexList[g], t, 1] === Sort @ GraphPeriphery[g],
   t == Rescale[GraphEccentricities[g]]}]
```

On the square grid the relative eccentricity is the distance to the centre divided by *D − r*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {ctr = GraphCenter[g]},
  {r = GraphRadius[g], d = GraphDiameter[g]}, {depth = Table[Min[GraphDistance[g, v, #] & /@ ctr], {v, VertexList[g]}]},
  {RelativeEccentricity[g] == depth/(d - r), {r, d}}]
```

## Possible Issues

On a vertex-transitive graph every vertex is both centre and periphery, and the value is 0, not 1:

```wl
{RelativeEccentricity[CycleGraph[8]], GraphPeriphery[CycleGraph[8]]}
```

On a disconnected graph every value is 0:

```wl
RelativeEccentricity[GraphUnion[PathGraph[{1, 2, 3}], PathGraph[{4, 5}]]]
```
