---
Template: Symbol
Name: InfraFiberBundleQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFiberBundleQ
Keywords: [fiber bundle, local triviality, isomorphic fibers, covering]
SeeAlso: [InfraFibrationQ, InfraFibration, InfraFibers, InfraFlatConnectionQ, InfraFiberedSubstrate]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[InfraFiberBundleQ]()[*fib*]</code> tests whether *fib* is a fiber bundle: isomorphic fibers, exactly one lift of each base edge at each vertex, trivial over every ball of radius 1.

## Details & Options

- With exactly one lift of every base edge, the horizontal edges over a ball form a covering of the ball. The bundle is trivial over the ball iff each component of this covering projects injectively.
- The ball is the closed ball of radius 1 of the reconstructed [InfraBaseGraph]().

## Basic Examples

The cycle of length 8 over the square and the cycle of length 6 over the triangle, each vertex *i* over *i* mod *n*. Over the square every ball of radius 1 is a path, and the cover is trivial over it. Over the triangle the ball is the whole triangle, and the cover is not trivial over it.

```wl
With[
  {square = InfraFibration[CycleGraph[8], i |-> Mod[i, 4, 1]]},
  {triangle = InfraFibration[CycleGraph[6], i |-> Mod[i, 3, 1]]},
  {InfraTotalGraph[square], InfraFiberBundleQ[square], InfraTotalGraph[triangle], InfraFiberBundleQ[triangle]}]
```

The trivial and covering entries of the catalogue are fiber bundles, the branched ones are not.

```wl
Table[
  name -> InfraFiberBundleQ @ InfraFiberedSubstrate[name, "Small"],
  {name, Join @@ Lookup[InfraFiberedSubstrate[], {"Trivial", "Covering", "NonBundle"}]}]
```

## Possible Issues

The tangent and displacement entries of the catalogue are fibrations, but not fiber bundles in this sense. Over the grid the fibers have different sizes, drawn here as a density on the base.

```wl
With[
  {fib = InfraFiberedSubstrate["GridDisplacementBundle", "Small"]},
  {InfraSubstrateHighlight[First @ fib, {VertexCount /@ InfraFibers[fib]}], InfraFibrationQ[fib], InfraFiberBundleQ[fib]}]
```
