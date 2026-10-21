---
Template: Symbol
Name: InfraDisplacementBundle
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraDisplacementBundle
Keywords: [displacement bundle, displacement, pair, sphere, scale, Levi-Civita]
SeeAlso: [InfraTangentBundle, InfraBundleMorphism, FindInfraLeviCivitaConnection, InfraParallelTransport, InfraHolonomyAngle, InfraTotalSpace, InfraFiberedSubstrate]
RelatedGuides: [InfraFiberBundles, InfraAnalysis]
RelatedTutorials: [ExperimentalInfraBundles]
---

## Usage

<code>[InfraDisplacementBundle]()[*g*, *r*]</code> is the displacement bundle of the graph *g* at scale *r*: its total vertices are the pairs {*p*, *v*} with *d(p, v) = r*, projected to *p*.

## Details & Options

The total vertices are *{(p, v) : d(p, v) = r}*. Two pairs *(p, v)* and *(q, w)* are adjacent iff *p = q* or *p ~ q*, and *v = w* or *v ~ w*, and the pairs differ.

The fiber over *p* is the sphere *Sᵣ(p)*: one total vertex for each direction *p → v* at distance *r*. Two directions at *p* are adjacent iff their endpoints are. On a triangle-free graph such as the square grid the fiber at scale 1 has no edges.

At scale 1 the total vertices are the oriented edges of *g*, 2 |*E*| of them.

A section is a displacement: it moves each vertex *p* to a vertex at distance *r*. It is continuous, [InfraContinuousSectionQ](), iff neighbouring vertices move to equal or neighbouring vertices.

The bundle is a fibration on the substrates, but not a fiber bundle: the spheres differ in size where *g* is not homogeneous, and a pair has several lifts over a base edge.

[InfraDisplacementBundle]() is a symbolic object. [InfraTotalSpace](), [InfraProjection](), [InfraFiber]() and the structural tests read it directly; <code>[InfraFiberedGraph]()[*fib*]</code> gives it as a literal fibered graph.

The Levi-Civita connection lives on this bundle: [FindInfraLeviCivitaConnection](), [InfraParallelTransport](), [InfraHolonomyAngle](), [InfraCovariantDerivative]().

## Basic Examples

The fiber over the centre at scale 3 is the sphere of radius 3, drawn by the endpoints of its pairs:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    InfraSubstrateHighlight[g, {Last /@ VertexList @ InfraFiber[InfraDisplacementBundle[g, 3], c], c}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The total graph at scale 1 over the 6 × 6 grid, every fiber drawn around its base vertex. The fiber over the centre, four directions, is marked:

```wl
With[{g = InfraSubstrate["SquareGridGraph", {6, 6}, "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {xy = AssociationThread[VertexList[g], GraphEmbedding[g]], fib = InfraDisplacementBundle[g, 1]},
  InfraFiberedGraphHighlight[fib, {InfraFiber[fib, c]}, "BaseVertexCoordinates" -> xy, ImageSize -> Medium]]
```

At scale 1 there is one total vertex for each oriented edge of the substrate:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small"]},
    {VertexCount @ InfraTotalSpace @ InfraDisplacementBundle[g, 1], 2 EdgeCount[g]}],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Scope

The fiber over the centre has no edges on the grid. On the mesh, a triangulation, its seven directions form a cycle:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small"]}, {fib = InfraDisplacementBundle[g, 1]},
    InfraFiber[fib, First @ GraphCenter[g]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Properties and Relations

The displacement bundle of the grid is a fibration but not a fiber bundle. The fibers have 4 vertices inside and 1 at the rim:

```wl
With[{fib = InfraDisplacementBundle[InfraSubstrate["SquareGridGraph", "Small"], 1]},
  {InfraFibrationQ[fib], InfraFiberBundleQ[fib], Counts[VertexCount /@ Values @ InfraFibers[fib]]}]
```

On the square torus all fibers have 4 vertices, and still the bundle is not a fiber bundle: a pair has several lifts over a base edge.

```wl
With[{fib = InfraDisplacementBundle[InfraSubstrate["SquareTorusGraph", "Small"], 1]},
  {InfraEqualFiberSizesQ[fib], InfraUniqueEdgeLiftingQ[fib], InfraFiberBundleQ[fib]}]
```

The endpoint map from the tangent bundle, a ray to its first and last vertex, is a bundle morphism:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {tangent = InfraTangentBundle[g, 2], displacement = InfraDisplacementBundle[g, 2]},
  InfraBundleMorphismQ[tangent, displacement, InfraBundleMorphism[tangent, displacement]]]
```
