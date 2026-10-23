---
Template: Symbol
Name: UniformLengthGraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/UniformLengthGraph
Keywords: [uniform length, edge length, hard spheres, packing, contact graph, discretization, mesh, arclength, Tammes problem]
SeeAlso: [UniformLengthEmbedding, InfraSubstrate, TessellationGraph]
RelatedGuides: [InfraSubstrates]
---

## Usage

<code>[UniformLengthGraph]()[*region*, *h*]</code> gives the contact graph of a packing of *region* by spheres of diameter *h*: two centres are joined when their distance is *h* up to the contact tolerance.

## Details & Options

The vertices are the centres *x₁*, …, *xₙ* in the region, and *xᵢxⱼ* is an edge when *|‖xᵢ − xⱼ‖ − h| ≤ t h*, with *t* the contact tolerance. Every edge has a length between *(1 − t)h* and *(1 + t)h*, so the graph distance times *h* approximates the distance in the region.

The region is taken by its [RegionDimension](): a curve, a surface or a solid. A surface given by an equation is passed as <code>[RegionBoundary]() @ [BoundaryDiscretizeRegion]()[…]</code>.

The number of centres follows from *h* and the measure *C* of the region:

| Region | Centres | Placement |
|---|---|---|
| closed curve | *C/h*, rounded | equal arclength; the graph is a cycle |
| open curve | *C/h + 1* | equal arclength; the graph is a path |
| surface | *2C/(√3 h²)*, the hexagonal packing | random start, relaxed |
| solid | *C(1.12/h)³* | random start, relaxed |

The relaxation pushes every pair closer than *h* apart to *h* and moves each centre to the nearest point of the region, until no centre moves more than [Tolerance]() or for [MaxIterations]() steps. The random start uses the current random state, so [SeedRandom]() or [BlockRandom]() fixes the graph.

| Option | Default | Values |
|---|---|---|
| `"ContactTolerance"` | 0.25 | the relative band *t* about *h* |
| `"InitialPoints"` | [Automatic]() | the starting centres on a surface or in a solid; their number is then *n* |
| `"KeepCoordinates"` | [False]() | [True]() keeps the centres as vertex coordinates; otherwise a spring layout |
| [MaxIterations]() | 200 | the largest number of relaxation steps |
| [Tolerance]() | 10⁻⁶ | the largest move at which the relaxation stops |

## Basic Examples

The unit sphere packed by spheres of diameter 0.5, 0.3 and 0.2, labelled with the number of centres, *8π/(√3 h²)* rounded:

```wl
GraphicsRow @ Table[
  With[{g = BlockRandom[UniformLengthGraph[Sphere[], h, "KeepCoordinates" -> True], RandomSeeding -> 1]},
    Graph[g, PlotLabel -> {VertexCount[g], Round[8 Pi/(Sqrt[3] h^2)]}]],
  {h, {0.5, 0.3, 0.2}}]
```

A disk, a sphere and a ball at *h* = 0.25, labelled with the shortest and the longest edge over *h*:

```wl
GraphicsRow @ Table[
  With[{g = BlockRandom[UniformLengthGraph[region, 0.25, "KeepCoordinates" -> True], RandomSeeding -> 1]},
    Graph[g, PlotLabel -> Round[MinMax[EuclideanDistance @@ GraphEmbedding[g][[List @@ #]] & /@ EdgeList[g]]/0.25, 0.01]]],
  {region, {Disk[], Sphere[], Ball[]}}]
```

On a curve the centres lie at equal arclength. A circle gives a cycle, a zigzag a path:

```wl
GraphicsRow @ Table[UniformLengthGraph[curve, 0.2, "KeepCoordinates" -> True], {curve, {Circle[], Line[{{0, 0}, {1, 1}, {2, 0}, {3, 1}}]}}]
```

## Scope

The surface of a prolate ellipsoid. Most centres have six neighbours, at the waist and at the tips alike:

```wl
With[{g = BlockRandom[UniformLengthGraph[RegionBoundary @ BoundaryDiscretizeRegion @ Ellipsoid[{0, 0, 0}, {5, 1, 1}], 0.44,
      "KeepCoordinates" -> True], RandomSeeding -> 1]},
  Graph[g, PlotLabel -> KeySort @ Counts[VertexDegree[g]], ImageSize -> Medium]]
```

## Options

### ContactTolerance

A wider band joins more centres. The disk at the tolerances 0.1, 0.25 and 0.4, labelled with the number of edges:

```wl
GraphicsRow @ Table[
  With[{g = BlockRandom[UniformLengthGraph[Disk[], 0.15, "KeepCoordinates" -> True, "ContactTolerance" -> t], RandomSeeding -> 1]},
    Graph[g, PlotLabel -> EdgeCount[g]]],
  {t, {0.1, 0.25, 0.4}}]
```

### InitialPoints

Four, six and twelve points on the sphere, relaxed at the edge lengths of the inscribed tetrahedron, octahedron and icosahedron, touch as these solids:

```wl
With[{lengths = {Sqrt[8/3], Sqrt[2], 4/Sqrt[10 + 2 Sqrt[5]]}},
  {packings = BlockRandom[
    MapThread[UniformLengthGraph[Sphere[], #1, "InitialPoints" -> RandomPoint[Sphere[], #2], "KeepCoordinates" -> True] &,
      {lengths, {4, 6, 12}}], RandomSeeding -> 1]},
  GraphicsRow @ MapThread[Graph[#1, PlotLabel -> IsomorphicGraphQ[#1, TessellationGraph[{3, #2}]]] &, {packings, {3, 4, 5}}]]
```

## Properties and Relations

The graph distance times *h* approximates the distance in the region: from the northernmost to the southernmost centre of the unit sphere, against π:

```wl
With[{g = BlockRandom[UniformLengthGraph[Sphere[], 0.2, "KeepCoordinates" -> True], RandomSeeding -> 1]}, {z = GraphEmbedding[g][[All, 3]]},
  {0.2 GraphDistance[g, First @ Ordering[z, -1], First @ Ordering[z, 1]], N[Pi]}]
```

## Possible Issues

A corner of a curve shortens the chord across it. At a right angle the chord falls below *(1 − t)h* and the path breaks there:

```wl
With[{g = UniformLengthGraph[Line[{{0, 0}, {1, 0}, {1, 1}}], 0.3, "KeepCoordinates" -> True]},
  Graph[g, PlotLabel -> ConnectedGraphQ[g], ImageSize -> Medium]]
```
