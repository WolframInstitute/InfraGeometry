---
Template: Symbol
Name: InfraFibers
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFibers
Keywords: [fibers, preimages, fiber sizes, fibered graph]
SeeAlso: [InfraFiber, InfraFiberedGraph, InfraProjection, InfraBaseSpace, InfraEqualFiberSizesQ, InfraFiberBundleQ]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraFibers]()[*fib*]</code> gives the association <|*p* -> *F(p)*, …|> of the fibers of *fib* over every base vertex *p*.

## Details & Options

The fiber *F(p)* is the subgraph of the total graph induced on *π⁻¹(p)*, as given by [InfraFiber]().

The fibers partition the vertices of the total graph, so their sizes add up to its vertex count.

`VertexCount /@ InfraFibers[fib]` is the fiber size as a function on the base. All sizes are equal exactly when [InfraEqualFiberSizesQ]() is `True`.

For <code>[InfraDisplacementBundle]()[*g*, *r*]</code> the fiber over *p* has one vertex for each vertex at distance *r* from *p*. On the square grid, away from the rim, that is *4r*.

## Basic Examples

The fiber sizes of the displacement bundle at *r* = 3, drawn on the base. On the grid they are 12 away from the rim:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    InfraSubstrateHighlight[g, {VertexCount /@ InfraFibers[InfraDisplacementBundle[g, 3]]}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

A branched fibration over the 4 × 4 grid, each fiber in its own colour: one vertex over one colour class of the grid, an edge over the other:

```wl
With[{fib = InfraFiberedSubstrate["BranchedGridFibration", "Small"]},
  InfraFiberedGraphHighlight[fib, Values @ InfraFibers[fib], ImageSize -> Medium]]
```

## Scope

The fiber sizes of the branched fibration form a checkerboard on the base:

```wl
With[{fib = InfraFiberedSubstrate["BranchedGridFibration", "Small"]},
  InfraSubstrateHighlight[GridGraph[{4, 4}], {VertexCount /@ InfraFibers[fib]}, ImageSize -> Medium]]
```

## Properties and Relations

The sizes of the fibers add up to the number of vertices of the total graph:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {fib = InfraDisplacementBundle[g, 3]},
  {Total[VertexCount /@ InfraFibers[fib]], VertexCount @ InfraTotalSpace[fib]}]
```

The keys are the vertices of the base:

```wl
With[{fib = InfraFiberedSubstrate["BranchedGridFibration", "Small"]},
  Sort @ Keys @ InfraFibers[fib] === Sort @ VertexList @ InfraBaseSpace[fib]]
```
