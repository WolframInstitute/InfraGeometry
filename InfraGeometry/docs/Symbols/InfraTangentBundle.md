---
Template: Symbol
Name: InfraTangentBundle
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraTangentBundle
Keywords: [tangent bundle, ray, vector field, scale]
SeeAlso: [InfraRays, InfraCotangentBundle, InfraDisplacementBundle, InfraBundleMorphism, InfraTotalSpace, InfraFiberedSubstrate]
RelatedGuides: [InfraFiberBundles, InfraAnalysis]
RelatedTutorials: [ExperimentalInfraBundles]
---

## Usage

<code>[InfraTangentBundle]()[*g*, *r*]</code> is the tangent bundle of *g* at scale *r*: its total vertices are the rays of length *r*, each over its first vertex, and two rays are adjacent iff at every position their vertices are equal or adjacent.

## Details & Options

A tangent vector at *p* at scale *r* is a ray {*p*, *u₁*, …, *uᵣ*} with *d(p, uᵢ) = i*, as given by [InfraRays](). The fiber over *p* is the set of these rays.

Two rays *x*, *y* are adjacent iff *xᵢ = yᵢ* or *xᵢ ~ yᵢ* for every *i*. This rule makes the truncation to a shorter scale a bundle morphism.

On a triangle-free graph such as the square grid, the fibers have no edges.

The construction is a fibration on the full grid [GridGraph](), but not a fiber bundle: fiber sizes differ between the corners, the rim and the interior, and a ray has several neighbours over a base edge.

At scale 1 a ray is a directed edge, and the total graph is that of <code>[InfraDisplacementBundle]()[*g*, 1]</code>.

The object is symbolic: [InfraTotalSpace](), [InfraProjection]() and the predicates evaluate it, and <code>[InfraFiberedGraph]()[*fib*]</code> builds its total graph once. The scale *r* is a positive integer.

## Basic Examples

The fiber sizes at scale 2, drawn as the size of the vertex, on the square grid and on the square mesh. Away from the rim of the grid every fiber has 12 rays:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    InfraSubstrateHighlight[g, {Counts @ Values @ InfraProjection[InfraTangentBundle[g, 2]]}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The tangent bundle of the 4 × 4 grid at scale 2, the fiber over the vertex 6 drawn:

```wl
With[{fib = InfraTangentBundle[GridGraph[{4, 4}], 2]},
  InfraFiberedGraphHighlight[fib, {InfraFiber[fib, 6]}, ImageSize -> Medium]]
```

## Scope

At scale 1 the tangent and displacement bundles have the same vertices and edges:

```wl
With[{g = GridGraph[{4, 4}]},
  {t = InfraTotalSpace[InfraTangentBundle[g, 1]], d = InfraTotalSpace[InfraDisplacementBundle[g, 1]]},
  {Sort @ VertexList[t] === Sort @ VertexList[d], Sort[Sort /@ EdgeList[t]] === Sort[Sort /@ EdgeList[d]]}]
```

## Properties and Relations

On the 4 × 4 grid the tangent bundle is a fibration, but its fibers differ in size, so it is not a fiber bundle:

```wl
With[{fib = InfraTangentBundle[GridGraph[{4, 4}], 2]},
  {InfraFibrationQ[fib], InfraEqualFiberSizesQ[fib], InfraFiberBundleQ[fib]}]
```

The ray {6, 7, 8} has several neighbours over the base neighbours 2, 7 and 10 of 6:

```wl
InfraEdgeLiftMultiplicity[InfraFiberedGraph @ InfraTangentBundle[GridGraph[{4, 4}], 2]][{6, 7, 8}]
```

A fiber has no edges on the grid. On the triangular tiling two rays at the centre can be adjacent:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small"]}, {c = First @ GraphCenter[g]},
    EdgeCount @ InfraFiber[InfraTangentBundle[g, 2], c]],
  {name, {"SquareGridGraph", "TriangularTilingGraph"}}]
```

The truncation from scale 2 to scale 1 is a bundle morphism:

```wl
With[{g = GridGraph[{4, 4}]}, {t2 = InfraTangentBundle[g, 2], t1 = InfraTangentBundle[g, 1]},
  InfraBundleMorphismQ[t2, t1, InfraBundleMorphism[t2, t1]]]
```

## Possible Issues

[InfraSubstrate]() grids keep the rim vertices as pendants. Near the pendants some rays have no neighbour over a base edge, so the tangent bundle at scale 2 is not a fibration there. On the full grid it is:

```wl
InfraFibrationQ @ InfraTangentBundle[#, 2] & /@ {InfraSubstrate["SquareGridGraph", "Small"], GridGraph[{8, 8}]}
```
