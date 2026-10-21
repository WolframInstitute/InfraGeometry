---
Template: Symbol
Name: InfraSubstrate
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSubstrate
Keywords: [substrate, example graph, grid, mesh, tiling, torus, sphere, roster]
SeeAlso: [TorusTessellation, GraphCenter, InfraShell, InfraBall, InfraSubstrateHighlight, RandomInfraPoint]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraSubstrate]()[*name*, *size*]</code> is the example graph *name* at the size `"Small"`, `"Medium"` or `"Large"`.

<code>[InfraSubstrate]()[*name*]</code> is the `"Medium"` size.

<code>[InfraSubstrate]()[]</code> gives the names grouped by what they model; <code>[InfraSubstrate]()[All]</code> gives the list of names.

## Details & Options

A substrate is a graph a construction runs on, a discrete stand-in for a space.

| Class | Models | Names |
|---|---|---|
| `"OpenManifold"` | a patch of the plane or of space | `"SquareGridGraph"`, `"SquareMeshGraph"`, `"CubicGridGraph"`, `"CubeMeshGraph"`, `"SquareTilingGraph"`, `"TriangularTilingGraph"`, `"HexagonalTilingGraph"`, `"HyperbolicTilingGraph"` |
| `"ClosedManifold"` | a compact surface | `"SphereMeshGraph"`, `"SquareTorusGraph"`, `"TriangularTorusGraph"`, `"HexagonalTorusGraph"`, `"UniformLengthSphereGraph"`, `"UniformLengthProlateEllipsoidGraph"`, `"UniformLengthTriaxialEllipsoidGraph"`, `"BuckyballGraph"` |
| `"Fractal"` | a self-similar set | `"SierpinskiTriangleGraph"`, `"MengerCarpetGraph"`, `"MengerSpongeGraph"` |
| `"Exotic"` | no manifold | `"BinaryTreeGraph"`, `"DilutedTreeGraph"`, `"CompleteGraph"` |
| `"WolframModel"` | a Wolfram model universe | `"wm6655"`, `"wm8619"`, `"wm1811"` |

The two main substrates of the plane:

| Name | Small | Medium | Large |
|---|---|---|---|
| `"SquareGridGraph"` | 96 vertices, centre eccentricity 9 | 285, eccentricity 15 | 1020 |
| `"SquareMeshGraph"` | 102 vertices, centre eccentricity 6 | 294, eccentricity 10 | 989 |

The square grid of side *n* is [GridGraph]()[{*n*, *n*}] without its corners and without the edges along its border, so every rim vertex has one neighbour; Small is *n* = 10, Medium *n* = 17. Its vertex coordinates are integers and its distance is the ℓ¹ distance. The square mesh is an irregular triangulation of the unit square.

A patch has a rim, and the rim is not geometry. Anchor a construction at the centre, `First @ GraphCenter[g]`, and keep it inside. A closed surface, such as `"SphereMeshGraph"` or a torus, has no rim.

*size* can also be a raw value: the dimensions of a grid, the cell measure of a mesh, the radius of a tiling, a generation count. A Wolfram model universe `"wm"` followed by its number in the Registry of Notable Universes needs the network.

A substrate built by a random construction is seeded with [SeedRandom]() in front of the call.

| Option | Default | Values |
|---|---|---|
| `"KeepCoordinates"` | `False` | `True` draws the substrate in its own embedding instead of a spring layout |
| `"Inflate"` | `None` | *k* new vertices over every vertex, as in `InflateGraph` |

## Basic Examples

The square grid and the square mesh at size `"Small"`, with the shell of radius 4 about the centre:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    InfraSubstrateHighlight[g, {InfraShell[c, 4], c}, PlotLabel -> VertexCount[g]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The roster:

```wl
InfraSubstrate[]
```

The number of vertices at the three sizes:

```wl
Table[VertexCount @ InfraSubstrate[name, size], {name, {"SquareGridGraph", "SquareMeshGraph"}}, {size, {"Small", "Medium", "Large"}}]
```

## Scope

Substrates without a rim: the sphere mesh and the square torus, with the ball of radius 2 about a vertex:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ VertexList[g]},
    InfraSubstrateHighlight[g, {InfraBall[c, 2], c}]],
  {name, {"SphereMeshGraph", "SquareTorusGraph"}}]
```

A substrate of space, the cubic grid, with a ball about its centre:

```wl
With[{g = InfraSubstrate["CubicGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  InfraSubstrateHighlight[g, {InfraBall[c, 2], c}, ImageSize -> Medium]]
```

The tilings of the plane:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    InfraSubstrateHighlight[g, {InfraShell[c, 3], c}]],
  {name, {"TriangularTilingGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]
```

A raw size: the square grid of side 5, 25 vertices less the four corners:

```wl
VertexCount @ InfraSubstrate["SquareGridGraph", {5, 5}]
```

## Options

### KeepCoordinates

By default the mesh is laid out by springs; with `"KeepCoordinates" -> True` it is drawn in the unit square it was cut from:

```wl
GraphicsRow[{InfraSubstrate["SquareMeshGraph", "Small"], InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}]
```

## Properties and Relations

The square grid is a grid graph without its corners and its border edges:

```wl
With[{h = GridGraph[{10, 10}]}, {border = Select[VertexList[h], VertexDegree[h, #] < 4 &]},
  IsomorphicGraphQ[InfraSubstrate["SquareGridGraph", "Small"],
    VertexDelete[EdgeDelete[h, Select[EdgeList[h], SubsetQ[border, List @@ #] &]], {1, 10, 91, 100}]]]
```

The square torus is the [TorusTessellation]() graph:

```wl
Sort @ EdgeList @ InfraSubstrate["SquareTorusGraph", "Small"] === Sort @ EdgeList @ TorusTessellation[{10, 10}, "Square"]
```

## Possible Issues

The rim cuts large balls. On the small grid the ball about the centre has *2r² + 2r + 1* vertices only up to radius 4:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Table[InfraMeasurement[g, InfraBall[c, r], "CountingMeasure"] - (2 r^2 + 2 r + 1), {r, 0, 7}]]
```
