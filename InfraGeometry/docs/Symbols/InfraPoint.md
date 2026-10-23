---
Template: Symbol
Name: InfraPoint
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraPoint
Keywords: [point, vertex, scene, region]
SeeAlso: [RandomInfraPoint, InfraScene, RandomInfraSceneInstance, InfraDistance, InfraMeasurement]
RelatedGuides: [Experimental]
---

## Usage

<code>[InfraPoint]()[*v*]</code> is the point at the vertex *v*.

<code>[InfraPoint]()[]</code> is a point to be found: any vertex of the graph.

<code>[InfraPoint]()[*reg*]</code> is a point to be found in the region *reg*.

## Details & Options

A point is a vertex. The label of the vertex is the point; there is no separate point object.

[InfraPoint]() is a symbolic object. In an [InfraScene]() it constructs a point: <code>*p* == [InfraPoint]()[]</code> lets *p* range over every vertex, and the assertions of the scene select the admissible ones. [RandomInfraSceneInstance]() solves the scene on a graph.

As a region of [RandomInfraPoint]() it is the vertex set it names, and its `"VertexDensity"` in [InfraMeasurement]() is 1 on that set:

| Region | Vertices |
|---|---|
| <code>[InfraPoint]()[*v*]</code> | {*v*} |
| <code>[InfraPoint]()[]</code> | every vertex |
| <code>[InfraPoint]()[*reg*]</code> | the vertices of *reg* |

Several candidate points are a vertex list, and a weighted set of points is a density `<|v -> m, …|>`.

## Basic Examples

A point at distance 3 from the centre, solved in a scene. All its instances on the square grid and on the square mesh form the circle of radius 3:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {scene = InfraScene[{pA, pB}, {pA == InfraPoint[c], pB == InfraPoint[], InfraDistance[pA, pB] == 3}]},
    InfraSubstrateHighlight[g, {InfraSceneInstance[#, pB] & /@ RandomInfraSceneInstance[scene, g, All], c}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

A point given by a region. The circle of radius 3 as the region gives the same points as the distance condition:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small"]}, {c = First @ GraphCenter[g]},
    {byDistance = InfraScene[{pA, pB}, {pA == InfraPoint[c], pB == InfraPoint[], InfraDistance[pA, pB] == 3}],
     byRegion = InfraScene[{pA, pB}, {pA == InfraPoint[c], pB == InfraPoint[InfraShell[c, 3]]}]},
    Sort[InfraSceneInstance[#, pB] & /@ RandomInfraSceneInstance[byDistance, g, All]] ===
      Sort[InfraSceneInstance[#, pB] & /@ RandomInfraSceneInstance[byRegion, g, All]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Scope

As a region of [RandomInfraPoint](): one vertex, every vertex, the vertices of a ball:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {RandomInfraPoint[g, InfraPoint[c], All], Length @ RandomInfraPoint[g, InfraPoint[], All],
   Sort @ RandomInfraPoint[g, InfraPoint[InfraBall[c, 1]], All]}]
```

A point of a segment can be any vertex of its interval. The segment from the centre 45 to 67 counts the shortest paths through each vertex; the point weighs every vertex 1:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {seg = InfraSegment[45, 67]},
  GraphicsRow[{InfraSubstrateHighlight[g, {InfraMeasurement[g, seg, "VertexDensity"]}],
    InfraSubstrateHighlight[g, {InfraMeasurement[g, InfraPoint[seg], "VertexDensity"]}]}]]
```

Two points at distance 4 from each other and at distance 4 from the centre. The admissible second points on the mesh, for one first point:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {a = RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 1]},
  {scene = InfraScene[{pA, pB}, {pA == InfraPoint[a], pB == InfraPoint[InfraShell[c, 4]], InfraDistance[pA, pB] == 4}]},
  InfraSubstrateHighlight[g, {InfraShell[c, 4], InfraSceneInstance[#, pB] & /@ RandomInfraSceneInstance[scene, g, All], a, c},
    ImageSize -> Medium]]
```
