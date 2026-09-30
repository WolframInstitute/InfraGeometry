---
Template: Symbol
Name: InfraSubstrate
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSubstrate
Keywords: [substrate, example graph, surface graph, tiling, mesh, roster]
SeeAlso: [TessellationGraph, TorusTessellation, InfraCenter, FindInfraShell, InfraSubstrateHighlight, FindInfraPoint]
RelatedGuides: [EuclideanGeometryGuide]
---

## Usage

<code>[InfraSubstrate]()[*name*, *size*]</code> is the example graph *name* at *size* `"Small"`, `"Medium"` or `"Large"`.

<code>[InfraSubstrate]()[*name*]</code> is the `"Medium"` size.

<code>[InfraSubstrate]()[*name*, *size*, *style*]</code> draws it in the named backdrop style; `"Default"` draws it with no style.

<code>[InfraSubstrate]()[]</code> gives the roster, the names grouped by what they model. <code>[InfraSubstrate]()[All]</code> gives the flat list of names.

## Details & Options

A substrate is the graph a construction runs on. Every figure in this documentation is drawn on one, so an example starts with one line and no setup code.

The roster has five classes:

| Class | What it models | Names |
|---|---|---|
| `"OpenManifold"` | a patch of the plane or of space, with the rim removed | `"SquareMeshGraph"`, `"CubeMeshGraph"`, `"TriangularTilingGraph"`, `"SquareTilingGraph"`, `"HexagonalTilingGraph"`, `"HyperbolicTilingGraph"`, `"SquareGridGraph"`, `"CubicGridGraph"` |
| `"ClosedManifold"` | a compact surface | `"SphereMeshGraph"`, the three tori `"SquareTorusGraph"`, `"TriangularTorusGraph"`, `"HexagonalTorusGraph"`, three uniform-length ellipsoids, `"BuckyballGraph"` |
| `"Fractal"` | a self-similar set | `"SierpinskiTriangleGraph"`, `"MengerCarpetGraph"`, `"MengerSpongeGraph"` |
| `"Exotic"` | no manifold and no scaling law | `"BinaryTreeGraph"`, `"DilutedTreeGraph"`, `"CompleteGraph"` |
| `"WolframModel"` | a Wolfram-model universe | `"wm6655"`, `"wm8619"`, `"wm1811"` |

The three tilings of the plane are cut from the infinite tiling as graph-distance balls. The three tori are [TorusTessellation]() graphs placed on a torus of revolution.

A Wolfram-model universe is named `"wm"` followed by its number in the Registry of Notable Universes. Any of the 947 entries resolves, through `ResourceFunction["WolframModelData"]`, so this needs the network.

*size* may also be a raw value: the cell measure of a mesh, the radius of a tiling, the dimensions of a grid, the generation count of a Wolfram model or a fractal.

A substrate is **bare combinatorics** by default. A stored embedding is discarded, and a spring layout of the substrate's own dimension places the vertices. `"KeepCoordinates" -> True` draws the substrate where it lives. Every figure on a patch of the plane sets it.

A patch has a rim, and the rim is not geometry. Anchor a construction at the centre, [InfraCenter](), and keep it well inside the patch, or the figure shows boundary effects.

A substrate built by a random construction — a uniform-length ellipsoid, or any substrate with `"Inflate"` — is seeded from outside. `SeedRandom` in front of the call gives the same graph again.

Options:

| Option | Default | Values |
|---|---|---|
| `"KeepCoordinates"` | `False` | `True` draws the substrate in its own embedding |
| `"Inflate"` | `None` | a number of extra vertices over every vertex, a range `{min, max}`, or an option list for `InflateGraph` |

`Graph` options are passed on to the graph. The backdrop style is the substrate style of the size: gray edges and small gray vertices, lighter as the substrate grows.

## Basic Examples

The shell of radius 4 about the centre, on the discretized plane, the square tiling and the hexagonal tiling. The same definition gives three different shapes.

```wl
Row[Table[
   With[
     {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
     {c = InfraCenter[g]},
     Labeled[InfraSubstrateHighlight[g, {FindInfraShell[g, c, 4], c}, ImageSize -> 200], name]],
   {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]]
```

The number of substrates in each class.

```wl
Normal[Length /@ InfraSubstrate[]]
```

The three sizes of the square tiling.

```wl
Table[VertexCount @ InfraSubstrate["SquareTilingGraph", size], {size, {"Small", "Medium", "Large"}}]
```

A raw size: the square tiling cut at radius 5.

```wl
VertexCount @ InfraSubstrate["SquareTilingGraph", 5]
```

## Options

### KeepCoordinates

By default the discretized square is laid out by springs. With `"KeepCoordinates" -> True` it is drawn in the unit square it was cut from.

```wl
Row[{
  InfraSubstrate["SquareMeshGraph", "Small", ImageSize -> 200],
  InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True, ImageSize -> 200]}]
```

## Properties and Relations

The square torus substrate is the [TorusTessellation]() graph, placed in space.

```wl
Sort @ EdgeList @ InfraSubstrate["SquareTorusGraph", "Small"] ===
  Sort @ EdgeList @ TorusTessellation[{10, 10}, "Square"]
```
