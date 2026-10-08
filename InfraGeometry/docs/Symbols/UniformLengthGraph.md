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

The region is taken as given, by its [RegionDimension](): a curve, a surface or a solid. A [BoundaryMeshRegion]() is the solid it bounds; its surface is the [RegionBoundary]() of it, as in <code>[RegionBoundary]() @ [BoundaryDiscretizeRegion]() @ [Ellipsoid]()[…]</code>.

The number of spheres follows from *h* and the measure *C* of the region: *C*/*h* on a closed curve, *C*/*h* + 1 on an open curve, 2*C*/(√3 *h*²) on a surface, the count of a hexagonal packing, and *C* (1.12/*h*)³ in a solid, rounded, and at least 1.

On a curve the centres lie at equal arclength along a fine discretization of the curve, *C*/*n* apart, the length nearest to *h* that divides the curve evenly. A closed curve gives a cycle, an open curve a path.

On a surface or in a solid the centres start at random points of the region and are relaxed: each pair closer than *h* is pushed apart to *h*, and every centre is moved to the nearest point of the region, until no centre moves farther than [Tolerance]() or for at most [MaxIterations]() steps.

Two centres are joined when their distance lies within `"ContactTolerance"` × *h* of *h*. Every edge has a length between (1 − *t*) *h* and (1 + *t*) *h*, *t* the tolerance.

The vertices are 1, …, *n*. The centres are dropped and the graph is laid out by springs, unless `"KeepCoordinates"` -> [True]() keeps them as the vertex coordinates.

The start is drawn with [RandomPoint](), so [SeedRandom]() fixes the graph. `"InitialPoints"` gives the start instead, and then the number of spheres is the number of points. A curve has no random start.

| Option | Default | |
|---|---|---|
| `"ContactTolerance"` | 0.25 | the relative band about *h* in which two centres are joined |
| `"InitialPoints"` | [Automatic]() | the starting centres on a surface or in a solid |
| `"KeepCoordinates"` | [False]() | [True]() keeps the centres as the vertex coordinates |
| [MaxIterations]() | 200 | the largest number of relaxation steps |
| [Tolerance]() | 10.^-6 | the largest move at which the relaxation stops |

## Basic Examples

Spheres of diameter 0.25 packed in a disk, on a sphere and in a ball, and the shortest and the longest edge over 0.25.

```wl
With[
  {packings = Table[SeedRandom[1]; UniformLengthGraph[region, 0.25, "KeepCoordinates" -> True], {region, {Disk[], Sphere[], Ball[]}}]},
  {GraphicsRow[packings], Table[MinMax[EuclideanDistance @@ GraphEmbedding[packing][[List @@ #]] & /@ EdgeList[packing]] / 0.25, {packing, packings}]}]
```

On a curve the centres lie at equal arclength: a circle gives a cycle and a zigzag a path, with edges of one length close to 0.2.

```wl
With[
  {graphs = Table[UniformLengthGraph[curve, 0.2, "KeepCoordinates" -> True], {curve, {Circle[], Line[{{0, 0}, {1, 1}, {2, 0}, {3, 1}}]}}]},
  {GraphicsRow[graphs], Table[MinMax[EuclideanDistance @@ GraphEmbedding[g][[List @@ #]] & /@ EdgeList[g]], {g, graphs}]}]
```

## Scope

A surface given by an equation is passed discretized: the surface of a prolate ellipsoid. Most centres have six neighbours, at the waist and at the tips alike.

```wl
With[
  {g = (SeedRandom[1]; UniformLengthGraph[RegionBoundary @ BoundaryDiscretizeRegion @ Ellipsoid[{0, 0, 0}, {5, 1, 1}], 0.44, "KeepCoordinates" -> True])},
  {g, Normal @ KeySort @ Counts[VertexDegree[g]]}]
```

A solid: spheres of diameter 0.2 in a cube.

```wl
With[
  {g = (SeedRandom[1]; UniformLengthGraph[Cuboid[], 0.2, "KeepCoordinates" -> True])},
  {g, Normal @ KeySort @ Counts[VertexDegree[g]]}]
```

A curve in space: a helix gives a path.

```wl
With[
  {g = UniformLengthGraph[ParametricRegion[{Cos[t], Sin[t], t / 5}, {{t, 0, 4 Pi}}], 0.3, "KeepCoordinates" -> True]},
  {g, PathGraphQ[g]}]
```

## Options

### ContactTolerance

A wider band joins more centres: the tolerance 0.1, 0.25 and 0.4 on the disk, and the number of edges.

```wl
With[
  {packings = Table[SeedRandom[1]; UniformLengthGraph[Disk[], 0.15, "KeepCoordinates" -> True, "ContactTolerance" -> tolerance], {tolerance, {0.1, 0.25, 0.4}}]},
  {GraphicsRow[packings], EdgeCount /@ packings}]
```

### InitialPoints

Four, six and twelve random points on a sphere, relaxed at the edge length of the tetrahedron, the octahedron and the icosahedron inscribed in it, touch as these solids.

```wl
With[
  {lengths = {Sqrt[8 / 3], Sqrt[2], 4 / Sqrt[10 + 2 Sqrt[5]]}},
  {packings = (SeedRandom[1]; MapThread[UniformLengthGraph[Sphere[], #1, "InitialPoints" -> RandomPoint[Sphere[], #2], "KeepCoordinates" -> True] &, {lengths, {4, 6, 12}}])},
  {GraphicsRow[packings], MapThread[IsomorphicGraphQ[#1, TessellationGraph[{3, #2}]] &, {packings, {3, 4, 5}}]}]
```

### KeepCoordinates

By default the centres are dropped and the graph is laid out by springs.

```wl
GraphicsRow @ Table[SeedRandom[1]; UniformLengthGraph[Sphere[], 0.3, "KeepCoordinates" -> keep], {keep, {False, True}}]
```

### MaxIterations

Fewer steps leave the spheres overlapping: the closest pair of centres over *h* after 1, 10 and 200 steps on the disk.

```wl
Table[
  With[
    {g = (SeedRandom[1]; UniformLengthGraph[Disk[], 0.15, "KeepCoordinates" -> True, MaxIterations -> steps])},
    Min[DeleteCases[Flatten @ DistanceMatrix @ GraphEmbedding[g], 0.]] / 0.15],
  {steps, {1, 10, 200}}]
```

## Properties and Relations

The number of vertices follows from *h*: on the unit sphere it is 8π/(√3 *h*²), rounded.

```wl
Table[{h, SeedRandom[1]; VertexCount @ UniformLengthGraph[Sphere[], h], Round[8 Pi / (Sqrt[3] h ^ 2)]}, {h, {0.5, 0.3, 0.2}}]
```

The graph distance times *h* approximates the distance in the region: from the northernmost to the southernmost centre of the unit sphere, against π.

```wl
With[
  {g = (SeedRandom[1]; UniformLengthGraph[Sphere[], 0.2, "KeepCoordinates" -> True])},
  {heights = GraphEmbedding[g][[All, 3]]},
  {0.2 GraphDistance[g, First @ Ordering[heights, -1], First @ Ordering[heights, 1]], N[Pi]}]
```

## Possible Issues

A corner of a curve shortens the chord across it. At a right angle the chord can fall outside the contact tolerance, and the path breaks there.

```wl
With[
  {g = UniformLengthGraph[Line[{{0, 0}, {1, 0}, {1, 1}}], 0.3, "KeepCoordinates" -> True]},
  {g, ConnectedGraphQ[g]}]
```
