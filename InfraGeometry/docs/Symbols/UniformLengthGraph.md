---
Template: Symbol
Name: UniformLengthGraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/UniformLengthGraph
Keywords: [uniform length, hard spheres, packing, contact graph, discretization, mesh, Tammes problem]
SeeAlso: [UniformLengthEmbedding, InfraSubstrate, TessellationGraph]
RelatedGuides: [InfraSubstrates]
---

## Usage

<code>[UniformLengthGraph]()[*region*, *n*]</code> gives the contact graph of *n* equal hard spheres packed in *region*: two centres are joined when their spheres touch.

## Details & Options

Construction: *n* centres are seeded in *region*, on a sphere or the surface of an ellipsoid along a Fibonacci spiral, elsewhere at random. Then they are relaxed: each pair closer than 2*r* is pushed apart to 2*r*, and the centres are projected back to *region*, until no centre moves or for at most `"MaxIterations"` steps. Two centres are joined when their distance is 2*r* up to `"ContactTolerance"` × 2*r*.

A solid region is filled and a surface is meshed. The edges have one length, 2*r*, up to the tolerance, so the graph distance times 2*r* approximates the distance in *region*.

The radius spaces the spheres to cover the content *C* of *region*: on a surface 2*r* = √(2*C*/(*n*√3)), the spacing of a hexagonal packing, and in a solid 2*r* = 1.12 (*C*/*n*)^(1/3). `"Overpack"` multiplies *r*, and `"Radius"` gives *r* outright.

The vertices are 1, …, *n*. The packing is dropped and the graph is laid out by springs, unless `"KeepCoordinates"` -> [True]() stores it as the vertex coordinates.

A random seed is drawn with [RandomPoint](), so [SeedRandom]() fixes the graph; on a sphere or an ellipsoid surface the graph is the same every time.

| Option | Default | |
|---|---|---|
| [Method]() | `"IterativeProjection"` | the relaxation above, or `"ConstrainedPacking"`, a minimization with one constraint per pair of centres |
| `"Radius"` | [Automatic]() | the sphere radius *r* |
| `"Overpack"` | 1. | a factor on the automatic radius |
| `"ContactTolerance"` | 0.25 | the relative band about 2*r* in which two centres touch |
| `"MaxIterations"` | 200 | the number of relaxation steps |
| `"Tolerance"` | 10.^-6 | the largest move at which the relaxation stops |
| `"ProjectionStep"` | 1. | the fraction of the way back to *region* taken at each step |
| `"KeepCoordinates"` | [False]() | [True]() keeps the packing as the vertex coordinates |

`"ConstrainedPacking"` is slow beyond a dozen spheres.

## Basic Examples

150 spheres packed in a disk, on a sphere and in a ball, and the shortest and the longest edge of each.

```wl
With[
  {packings = Table[SeedRandom[1]; UniformLengthGraph[region, 150, "KeepCoordinates" -> True], {region, {Disk[], Sphere[], Ball[]}}]},
  {GraphicsRow[packings], Table[MinMax[EuclideanDistance @@ GraphEmbedding[packing][[List @@ #]] & /@ EdgeList[packing]], {packing, packings}]}]
```

Four, six and twelve spheres on a sphere touch as the tetrahedron, the octahedron and the icosahedron.

```wl
With[
  {packings = Table[UniformLengthGraph[Sphere[], n, "KeepCoordinates" -> True], {n, {4, 6, 12}}]},
  {GraphicsRow[packings], MapThread[IsomorphicGraphQ[#1, TessellationGraph[{3, #2}]] &, {packings, {3, 4, 5}}]}]
```

## Scope

A surface: 200 spheres on an ellipsoid. Most centres have six neighbours.

```wl
With[
  {g = UniformLengthGraph[RegionBoundary[Ellipsoid[{0, 0, 0}, {2, 1, 1}]], 200, "KeepCoordinates" -> True]},
  {g, Normal @ KeySort @ Counts[VertexDegree[g]]}]
```

A solid: 150 spheres in a cube.

```wl
With[
  {g = (SeedRandom[1]; UniformLengthGraph[Cuboid[], 150, "KeepCoordinates" -> True])},
  {g, Normal @ KeySort @ Counts[VertexDegree[g]]}]
```

## Options

### KeepCoordinates

By default the packing is dropped and the graph is laid out by springs.

```wl
GraphicsRow @ Table[UniformLengthGraph[Sphere[], 100, "KeepCoordinates" -> keep], {keep, {False, True}}]
```

### ContactTolerance

A wider band joins more centres: the tolerance 0.1, 0.25 and 0.4 on the disk, and the number of edges.

```wl
With[
  {packings = Table[SeedRandom[1]; UniformLengthGraph[Disk[], 150, "KeepCoordinates" -> True, "ContactTolerance" -> tolerance], {tolerance, {0.1, 0.25, 0.4}}]},
  {GraphicsRow[packings], EdgeCount /@ packings}]
```

### Radius

Spheres too small to touch give no edge.

```wl
With[
  {g = UniformLengthGraph[Sphere[], 150, "KeepCoordinates" -> True, "Radius" -> 0.1]},
  {g, EdgeCount[g]}]
```

## Properties and Relations

The uniform-length ellipsoids of [InfraSubstrate]() are these graphs on the region bounded by a discretized ellipsoid, with 100, 300 or 1000 spheres.

```wl
With[
  {g = (SeedRandom[1]; UniformLengthGraph[BoundaryDiscretizeRegion @ Ellipsoid[{0, 0, 0}, {5, 1, 1}], 100, "KeepCoordinates" -> True])},
  {substrate = (SeedRandom[1]; InfraSubstrate["UniformLengthProlateEllipsoidGraph", "Small", "Default", "KeepCoordinates" -> True])},
  {g, Sort[EdgeList[g]] === Sort[EdgeList[substrate]]}]
```

## Possible Issues

The edges have length 2*r* only up to the contact tolerance, and the relaxation leaves small overlaps. On the disk of 150 spheres 2*r* is about 0.156; the edge lengths:

```wl
With[
  {g = (SeedRandom[1]; UniformLengthGraph[Disk[], 150, "KeepCoordinates" -> True])},
  Histogram[EuclideanDistance @@ GraphEmbedding[g][[List @@ #]] & /@ EdgeList[g], AxesLabel -> {"length", "edges"}]]
```

A boundary mesh region is a solid. [BoundaryDiscretizeRegion]() of a ball bounds the solid ball, so the spheres fill it rather than mesh its surface; the distances of the centres from the origin, for the mesh and for [Sphere]():

```wl
With[
  {solid = (SeedRandom[1]; UniformLengthGraph[BoundaryDiscretizeRegion[Ball[]], 100, "KeepCoordinates" -> True])},
  {surface = UniformLengthGraph[Sphere[], 100, "KeepCoordinates" -> True]},
  {GraphicsRow[{solid, surface}], MinMax[Norm /@ GraphEmbedding[solid]], MinMax[Norm /@ GraphEmbedding[surface]]}]
```

On a curve the relaxation does not finish: some neighbours stay apart, and the contact graph of 150 spheres on a circle falls apart into paths.

```wl
With[
  {g = (SeedRandom[1]; UniformLengthGraph[Circle[], 150, "KeepCoordinates" -> True])},
  {g, ConnectedGraphQ[g], Normal @ KeySort @ Counts[VertexDegree[g]]}]
```
