---
Template: Symbol
Name: InfraBundleMorphismQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraBundleMorphismQ
Keywords: [bundle morphism, graph homomorphism, fibration map, symmetry]
SeeAlso: [InfraBundleMorphism, InfraFiberedGraph, InfraTangentBundle, InfraDisplacementBundle, InfraCotangentBundle]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraBundleMorphismQ]()[*fib1*, *fib2*, *F*, *f*]</code> gives [True]() if *F* is a bundle morphism from *fib1* to *fib2* over the base map *f*: it sends the fiber over *p* into the fiber over *f*(*p*), and every total edge to an edge or a vertex.

<code>[InfraBundleMorphismQ]()[*fib1*, *fib2*, *F*]</code> takes *f* to be [Identity]().

## Details & Options

*F* is a bundle morphism over *f* when *π₂(F(x)) = f(π₁(x))* for every total vertex *x* of *fib1*, and for every total edge *{x, y}* either *F(x) = F(y)* or *{F(x), F(y)}* is a total edge of *fib2*. So *F* is a graph homomorphism of the total graphs with loops added, and it covers *f*.

*F* and *f* are functions of one vertex, or associations. The total vertices of the bundles are lists, so *F* takes the list as its one argument.

The natural maps of [InfraBundleMorphism]() are bundle morphisms over the identity. A symmetry *σ* of the base acts on the displacement bundle by *{p, v} ↦ {σ(p), σ(v)}*, a bundle morphism over *σ*.

## Basic Examples

The endpoint map, a ray to the pair of its first and last vertex, from the tangent to the displacement bundle at scale 2:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small"]},
    InfraBundleMorphismQ[InfraTangentBundle[g, 2], InfraDisplacementBundle[g, 2],
      ray |-> {First @ ray, Last @ ray}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The prism and the Möbius ladder over the cycle of length 8. Exchanging the two vertices of every fiber is a bundle morphism of both. Turning the cycle by one step is a bundle morphism of the prism over the turn, but not of the Möbius ladder, whose twist stays in place:

```wl
With[{swap = x |-> {First @ x, 3 - Last @ x}, turn = x |-> {Mod[First @ x + 1, 8, 1], Last @ x}},
  {fibers = InfraFiberedSubstrate[#, "Small"] & /@ {"CycleProductBundle", "MoebiusLadderCover"}},
  GraphicsRow @ Table[
    InfraFiberedGraphHighlight[fib,
      PlotLabel -> {InfraBundleMorphismQ[fib, fib, swap], InfraBundleMorphismQ[fib, fib, turn, i |-> Mod[i + 1, 8, 1]]}],
    {fib, fibers}]]
```

## Scope

The reflection *σ* of the square grid in its diagonal, lifted to the displacement bundle, is a bundle morphism over *σ*, not over the identity:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {xy = AssociationThread[VertexList[g], Round @ GraphEmbedding[g]]},
  {at = AssociationThread[Values[xy], Keys[xy]], fib = InfraDisplacementBundle[g, 1]},
  {flip = AssociationThread[Keys[xy], Lookup[at, Reverse /@ Values[xy]]]},
  {InfraBundleMorphismQ[fib, fib, pair |-> flip /@ pair, flip], InfraBundleMorphismQ[fib, fib, pair |-> flip /@ pair]}]
```

## Properties and Relations

The natural maps of [InfraBundleMorphism]() pass the test. The reversal from the tangent to the cotangent bundle on the mesh:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]},
  {tangent = InfraTangentBundle[g, 2], cotangent = InfraCotangentBundle[g, 2]},
  InfraBundleMorphismQ[tangent, cotangent, InfraBundleMorphism[tangent, cotangent]]]
```

## Possible Issues

The first step of a ray of length 2 is a pair at distance 1. The map lands in the displacement bundle at scale 1, not at scale 2:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {tangent = InfraTangentBundle[g, 2]},
  Table[InfraBundleMorphismQ[tangent, InfraDisplacementBundle[g, r], ray |-> {First @ ray, ray[[2]]}],
    {r, {2, 1}}]]
```
