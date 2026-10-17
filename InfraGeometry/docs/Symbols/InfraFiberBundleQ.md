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

<code>[InfraFiberBundleQ]()[*fib*]</code> tests whether *fib* has a common fiber graph and an adjacency-preserving matching over every base edge.

## Details & Options

- The fibers must be mutually isomorphic, including across disconnected base components.
- Every total vertex has exactly one transverse neighbour over each adjacent base vertex. Each resulting fiber bijection preserves vertical adjacency.
- Twisted coverings are bundles. Trivial monodromy is a separate question, tested for a selected connection by [InfraFlatConnectionQ]().
- A nonempty list is tested by conjunction. An empty list is False; the empty fibered graph is a bundle.

## Basic Examples

The cycle of length 8 over the square and the cycle of length 6 over the triangle are both twisted double coverings and hence bundles.

```wl
SeedRandom[ 7 ];
With[
  {square = InfraFibration[CycleGraph[8], i |-> Mod[i, 4, 1]]},
  {triangle = InfraFibration[CycleGraph[6], i |-> Mod[i, 3, 1]]},
  {InfraFiberedGraphHighlight[square], InfraFiberBundleQ[square], InfraFiberedGraphHighlight[triangle], InfraFiberBundleQ[triangle]}]
```

The trivial and covering entries of the catalogue are fiber bundles, the branched ones are not.

```wl
SeedRandom[ 7 ];
Table[
  name -> InfraFiberBundleQ @ InfraFiberedSubstrate[name, "Small"],
  {name, Join @@ Lookup[InfraFiberedSubstrate[], {"Trivial", "Covering", "NonBundle"}]}]
```

## Possible Issues

The tangent and displacement entries of the catalogue are fibrations, but not fiber bundles in this sense. Over the grid the fibers have different sizes, drawn here as a density on the base.

```wl
SeedRandom[ 7 ];
With[
  {fib = InfraFiberedSubstrate["GridDisplacementBundle", "Small"]},
  {InfraSubstrateHighlight[First @ fib, {VertexCount /@ InfraFibers[fib]}], InfraFibrationQ[fib], InfraFiberBundleQ[fib]}]
```
