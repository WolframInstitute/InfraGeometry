---
Template: Symbol
Name: InfraFiberBundleQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFiberBundleQ
Keywords: [graph bundle, Cartesian graph bundle, isomorphic fibers, covering]
SeeAlso: [InfraFiberedGraph, InfraIsomorphicFibersQ, InfraUniqueEdgeLiftingQ, InfraCoveringQ, InfraFlatConnectionQ, InfraFibers]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraFiberBundleQ]()[*fib*]</code> tests whether *fib* has a common fiber graph and an adjacency-preserving matching over every base edge.

## Details & Options

- The fibers must be mutually isomorphic, including across disconnected base components.
- Every total vertex has exactly one transverse neighbour over each adjacent base vertex. Each resulting fiber bijection preserves vertical adjacency.
- This is the finite Cartesian graph-bundle condition. The inverse image of a base edge is a Cartesian product of that edge with the common fiber, respecting the projection.
- No topology or higher-dimensional cells are supplied by the predicate.
- Twisted coverings with a common sheet count are bundles. Trivial monodromy is a separate question, tested for a selected connection by [InfraFlatConnectionQ]().
- A covering may have different sheet counts on disconnected base components; such a covering is not a bundle with one common fiber.
- A nonempty list is tested by conjunction. An empty list is False; the empty fibered graph is a bundle. Unsupported inputs remain unevaluated.

## Basic Examples

The cycle of length 8 over the square and the cycle of length 6 over the triangle are both twisted double coverings and hence bundles.

```wl
SeedRandom[ 7 ];
With[
  {square = InfraFiberedGraph[CycleGraph[8], i |-> Mod[i, 4, 1]]},
  {triangle = InfraFiberedGraph[CycleGraph[6], i |-> Mod[i, 3, 1]]},
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
