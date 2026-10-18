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

<code>[InfraBundleMorphism]()[*fib1*, *fib2*]</code> gives the natural bundle morphism from *fib1* to *fib2* over the identity.

## Details & Options

- This is a particular Experimental construction in the Infra Fiber Bundles category. Its existing call forms remain available.


The natural maps between the bundles of one base graph *g*:

| From | To | Map |
|---|---|---|
| <code>[InfraTangentBundle]()[*g*, *r*]</code> | <code>[InfraDisplacementBundle]()[*g*, *r*]</code> | a ray to the pair of its first and last vertex |
| <code>[InfraTangentBundle]()[*g*, *r*]</code> | <code>[InfraTangentBundle]()[*g*, *s*]</code>, 0 < *s* < *r* | a ray to its first *s* steps |
| <code>[InfraTangentBundle]()[*g*, *r*]</code> | <code>[InfraCotangentBundle]()[*g*, *r*]</code> | the reversal of a ray |
| <code>[InfraCotangentBundle]()[*g*, *r*]</code> | <code>[InfraTangentBundle]()[*g*, *r*]</code> | the reversal of a ray |

- For any other pair of bundles the call stays unevaluated.
- [InfraBundleMorphismQ]() checks that a map is a bundle morphism.

## Basic Examples

The rays over the vertex 6 of the grid tangent bundle at scale 2, their truncations at scale 1 and their endpoint pairs in the displacement bundle at scale 2.

```wl
SeedRandom[ 7 ];
With[
  {g = First @ InfraFiberedSubstrate["GridTangentBundle", "Small"]},
  {tangent = InfraTangentBundle[g, 2], tangent1 = InfraTangentBundle[g, 1], displacementBundle = InfraDisplacementBundle[g, 2]},
  {truncate = InfraBundleMorphism[tangent, tangent1], endpoint = InfraBundleMorphism[tangent, displacementBundle]},
  {rays = VertexList @ InfraFiber[tangent, 6]},
  GraphicsRow[{
    InfraSubstrateHighlight[InfraTotalSpace[tangent], {InfraDensity[InfraTotalSpace[tangent], rays]}],
    InfraSubstrateHighlight[InfraTotalSpace[tangent1], {InfraDensity[InfraTotalSpace[tangent1], truncate /@ rays]}],
    InfraSubstrateHighlight[InfraTotalSpace[displacementBundle], {InfraDensity[InfraTotalSpace[displacementBundle], endpoint /@ rays]}]}]]
```

## Scope

The three maps out of the tangent bundle are bundle morphisms.

```wl
SeedRandom[ 7 ];
With[
  {g = GridGraph[{4, 4}]},
  {tangent = InfraTangentBundle[g, 2]},
  InfraBundleMorphismQ[tangent, #, InfraBundleMorphism[tangent, #]] & /@
    {InfraDisplacementBundle[g, 2], InfraTangentBundle[g, 1], InfraCotangentBundle[g, 2]}]
```

## Possible Issues

Sending a ray to its first step instead of its endpoint does not land in the displacement bundle at the same scale.

```wl
SeedRandom[ 7 ];
With[
  {g = GridGraph[{4, 4}]},
  InfraBundleMorphismQ[InfraTangentBundle[g, 2], InfraDisplacementBundle[g, 2], ray |-> {First @ ray, ray[[2]]}]]
```
