---
Template: Symbol
Name: InfraEqualFiberSizesQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraEqualFiberSizesQ
Keywords: [fiber size, cardinality, equal fibers, predicate]
SeeAlso: [InfraFibers, InfraIsomorphicFibersQ, InfraUniqueEdgeLiftingQ, InfraCoveringQ, InfraFiberBundleQ, InfraFiberedGraphQ]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraEqualFiberSizesQ]()[*fib*]</code> gives `True` if all fibers of *fib* have the same number of vertices.

## Details & Options

The condition is *|F(p)| = |F(q)|* for all base vertices *p*, *q*, also when they lie in different components of the base.

Only sizes are compared. Fibers of equal size can have different edges; [InfraIsomorphicFibersQ]() compares the fibers as graphs.

Unique edge lifting matches the fibers over the two ends of every base edge, so it gives equal sizes on each connected component of the base, not across components.

For <code>[InfraDisplacementBundle]()[*g*, *r*]</code> the fiber over *p* is the sphere of radius *r* about *p*. The sizes are equal when all spheres of radius *r* have the same size, as on the square torus; on the square grid they are not.

The empty fibered graph has equal fiber sizes. A list of objects gives `True` when every member does; the empty list gives `False`.

## Basic Examples

The fiber sizes of the displacement bundle at *r* = 3, drawn on the base. They vary on the square grid and are all 12 on the square torus:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {fib = InfraDisplacementBundle[g, 3]},
    InfraSubstrateHighlight[g, {VertexCount /@ InfraFibers[fib]}, PlotLabel -> InfraEqualFiberSizesQ[fib]]],
  {name, {"SquareGridGraph", "SquareTorusGraph"}}]
```

Two fibers of three vertices, one with an edge and one without. The sizes are equal, the fibers are not isomorphic:

```wl
With[{fib = InfraFiberedGraph[Graph[Range[6], {1 <-> 2, 3 <-> 4}],
    <|1 -> "p", 2 -> "p", 3 -> "p", 4 -> "q", 5 -> "q", 6 -> "q"|>]},
  InfraFiberedGraphHighlight[fib, PlotLabel -> {InfraEqualFiberSizesQ[fib], InfraIsomorphicFibersQ[fib]},
    ImageSize -> Medium]]
```

## Scope

The entries of the catalogue with equal fiber sizes: the products, the coverings, and the tangent and displacement bundles of the homogeneous bases:

```wl
Select[InfraFiberedSubstrate[All], InfraEqualFiberSizesQ @ InfraFiberedSubstrate[#, "Small"] &]
```

## Properties and Relations

A covering with two sheets over the square and one sheet over the triangle. Each component has equal sizes, the whole does not:

```wl
With[{fib = InfraFiberedGraph[GraphDisjointUnion[CycleGraph[8], CycleGraph[3]],
    v |-> If[v <= 8, Mod[v, 4, 1], v]]},
  {VertexCount /@ InfraFibers[fib], InfraCoveringQ[fib], InfraEqualFiberSizesQ[fib]}]
```
