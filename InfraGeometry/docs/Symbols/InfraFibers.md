---
Template: Symbol
Name: InfraFibers
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFibers
Keywords: [fibers, fibration, preimages]
SeeAlso: [InfraFiber, InfraFibration, InfraFibrationAssociation, InfraBaseGraph, InfraFiberBundleQ]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[InfraFibers]()[*fib*]</code> gives an association from each base vertex *p* to the fiber of *fib* over *p*.

## Basic Examples

The fibers of a branched fibration over a grid, each in its own colour: a vertex over one colour class of the grid, an edge over the other.

```wl
With[
  {fib = InfraFiberedSubstrate["BranchedGridFibration", "Small"]},
  {total = InfraTotalGraph[fib]},
  InfraSubstrateHighlight[total, InfraDensity[total, VertexList @ #] & /@ Values @ InfraFibers[fib]]]
```

The sizes of the fibers of the grid displacement bundle, drawn as a density on the base: two neighbours at a corner, four inside.

```wl
With[
  {fib = InfraFiberedSubstrate["GridDisplacementBundle", "Small"]},
  InfraSubstrateHighlight[First @ fib, {VertexCount /@ InfraFibers[fib]}]]
```
