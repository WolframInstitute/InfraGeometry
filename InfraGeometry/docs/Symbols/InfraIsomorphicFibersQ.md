---
Template: Symbol
Name: InfraIsomorphicFibersQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraIsomorphicFibersQ
Keywords: [isomorphic fibers, common fiber graph, predicate]
SeeAlso: [InfraEqualFiberSizesQ, InfraFiberBundleQ, InfraFibers, RandomInfraFiberedGraph]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraIsomorphicFibersQ]()[*fib*]</code> gives [True]() if the fibers of *fib* are mutually isomorphic graphs, and [False]() otherwise.

<code>[InfraIsomorphicFibersQ]()[{*fib₁*, *fib₂*, …}]</code> gives [True]() if every *fibᵢ* has isomorphic fibers.

## Details & Options

The condition is *Fₚ ≅ F_q* for all base vertices *p*, *q*, where *Fₚ* is the subgraph of the total graph induced on *π⁻¹(p)*. Every pair of fibers is compared, also over different connected components of the base.

The condition concerns the vertical edges only. It says nothing about the transverse edges: a fibered graph with isomorphic fibers need not be a fibration.

It is weaker than [InfraFiberBundleQ](), which also asks for one transverse neighbour over every base edge and for matchings that preserve the fiber edges. It is stronger than [InfraEqualFiberSizesQ]().

The empty fibered graph has isomorphic fibers. An empty list gives [False]().

## Basic Examples

Fibers of three vertices over the 3 × 3 grid: copies of one random graph, and independent random graphs:

```wl
GraphicsRow @ Table[
  With[{fib = RandomInfraFiberedGraph[GridGraph[{3, 3}], Properties -> props,
      "VerticalVertexCount" -> {3}, "VerticalEdgeCount" -> {1, 3}, "HorizontalEdgeCount" -> {1}, RandomSeeding -> 1]},
    InfraFiberedGraphHighlight[fib, PlotLabel -> InfraIsomorphicFibersQ[fib]]],
  {props, {{"IsomorphicFibers"}, {}}}]
```

Equal fiber sizes do not make the fibers isomorphic. The fibers below all have 3 vertices but different numbers of edges:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{3, 3}], "VerticalVertexCount" -> {3}, "VerticalEdgeCount" -> {0, 3},
    RandomSeeding -> 1]},
  {InfraEqualFiberSizesQ[fib], InfraIsomorphicFibersQ[fib], Values[EdgeCount /@ InfraFibers[fib]]}]
```

## Properties and Relations

Isomorphic fibers with one transverse edge over each base edge do not form a fibration, nor a fiber bundle:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{3, 3}], Properties -> {"IsomorphicFibers"},
    "VerticalVertexCount" -> {3}, "VerticalEdgeCount" -> {2}, "HorizontalEdgeCount" -> {1}, RandomSeeding -> 1]},
  {InfraIsomorphicFibersQ[fib], InfraFibrationQ[fib], InfraFiberBundleQ[fib]}]
```

The tangent bundle of a cycle has isomorphic fibers, that of a grid does not:

```wl
InfraIsomorphicFibersQ[InfraTangentBundle[#, 2]] & /@ {CycleGraph[8], GridGraph[{4, 4}]}
```
