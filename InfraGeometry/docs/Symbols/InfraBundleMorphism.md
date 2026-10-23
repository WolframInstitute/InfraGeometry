---
Template: Symbol
Name: InfraBundleMorphism
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraBundleMorphism
Keywords: [bundle morphism, endpoint map, truncation, reversal, natural map]
SeeAlso: [InfraBundleMorphismQ, InfraTangentBundle, InfraCotangentBundle, InfraDisplacementBundle, InfraRays]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [ExperimentalInfraBundles]
---

## Usage

<code>[InfraBundleMorphism]()[*fib1*, *fib2*]</code> gives the natural map from the total vertices of *fib1* to those of *fib2*, a bundle morphism over the identity of the base.

## Details & Options

The natural maps between the bundles of one graph *g*:

| From | To | Map |
|---|---|---|
| <code>[InfraTangentBundle]()[*g*, *r*]</code> | <code>[InfraDisplacementBundle]()[*g*, *r*]</code> | a ray (*p*, …, *uᵣ*) to the pair {*p*, *uᵣ*} |
| <code>[InfraTangentBundle]()[*g*, *r*]</code> | <code>[InfraTangentBundle]()[*g*, *s*]</code>, 0 < *s* < *r* | a ray to its first *s* steps |
| <code>[InfraTangentBundle]()[*g*, *r*]</code> | <code>[InfraCotangentBundle]()[*g*, *r*]</code> | the reversal of a ray |
| <code>[InfraCotangentBundle]()[*g*, *r*]</code> | <code>[InfraTangentBundle]()[*g*, *r*]</code> | the reversal of a ray |

The result is a function on total vertices. Each map keeps the base point and sends adjacent rays to adjacent or equal total vertices, so it passes [InfraBundleMorphismQ]().

The endpoint map is not injective: the rays from *p* to a vertex *v* at distance *r* are the shortest paths from *p* to *v*, and all go to {*p*, *v*}. The reversal is a bijection.

Both bundles must be built on the same graph, with the same vertices and edges. Any other pair of bundles leaves the call unevaluated.

## Basic Examples

The rays of length 2 at the centre sent to their endpoints. The size of a vertex is the number of rays that end there, the number of shortest paths from the centre:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {tangent = InfraTangentBundle[g, 2], displacement = InfraDisplacementBundle[g, 2]},
    {endpoint = InfraBundleMorphism[tangent, displacement]},
    InfraSubstrateHighlight[g, {Counts[Last /@ endpoint /@ VertexList @ InfraFiber[tangent, c]], c}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The three maps applied to one ray from the centre of the grid:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {tangent = InfraTangentBundle[g, 2], ray = First @ InfraRays[g, c, 2]},
  {ray, Table[InfraBundleMorphism[tangent, fib][ray],
    {fib, {InfraDisplacementBundle[g, 2], InfraTangentBundle[g, 1], InfraCotangentBundle[g, 2]}}]}]
```

## Scope

The truncation to scale 1 sends the 12 rays of length 2 at the centre of the grid to the 4 steps from it, 3 rays to each:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {tangent = InfraTangentBundle[g, 2]}, {truncate = InfraBundleMorphism[tangent, InfraTangentBundle[g, 1]]},
  {counts = Counts[Last /@ truncate /@ VertexList @ InfraFiber[tangent, c]]},
  InfraSubstrateHighlight[g, {counts, c}, PlotLabel -> counts, ImageSize -> Medium]]
```

## Properties and Relations

The three maps out of the tangent bundle are bundle morphisms:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {tangent = InfraTangentBundle[g, 2]},
  Table[InfraBundleMorphismQ[tangent, fib, InfraBundleMorphism[tangent, fib]],
    {fib, {InfraDisplacementBundle[g, 2], InfraTangentBundle[g, 1], InfraCotangentBundle[g, 2]}}]]
```

## Possible Issues

There is no natural map back from the displacement bundle, and none between bundles of different graphs:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"], h = InfraSubstrate["SquareMeshGraph", "Small"]},
  Head /@ {InfraBundleMorphism[InfraDisplacementBundle[g, 2], InfraTangentBundle[g, 2]],
    InfraBundleMorphism[InfraTangentBundle[g, 2], InfraDisplacementBundle[h, 2]]}]
```
