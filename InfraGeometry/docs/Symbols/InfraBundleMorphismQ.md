---
Template: Symbol
Name: InfraBundleMorphismQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraBundleMorphismQ
Keywords: [bundle morphism, graph homomorphism, fibration map]
SeeAlso: [InfraBundleMorphism, InfraFibration, InfraTangentBundle, InfraDisplacementBundle, InfraCotangentBundle]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[InfraBundleMorphismQ]()[*fib1*, *fib2*, *F*, *f*]</code> tests whether *F* maps the total vertices of *fib1* to total vertices of *fib2* over *f*, and edges to edges or vertices.

<code>[InfraBundleMorphismQ]()[*fib1*, *fib2*, *F*]</code> takes *f* to be [Identity]().

## Details & Options

- *F* covers *f* when the projection of <code>*F*[*x*]</code> is <code>*f*[*p*]</code> for every total vertex *x* over *p*.
- An edge may go to an edge or collapse to a vertex: *F* is a homomorphism of the total graphs with loops added.
- *F* and *f* are functions applied to one vertex. A vertex of a literal catalogue entry is a pair {*p*, *k*}, so *F* takes one argument.

## Basic Examples

The endpoint map from the tangent bundle to the displacement bundle at scale 2 is a bundle morphism. The rays over 6 and their images are drawn.

```wl
With[
  {g = First @ InfraFiberedSubstrate["GridTangentBundle", "Small"]},
  {tangent = InfraTangentBundle[g, 2], displacementBundle = InfraDisplacementBundle[g, 2]},
  {endpoint = ray |-> {First @ ray, Last @ ray}},
  {rays = VertexList @ InfraFiber[tangent, 6]},
  {GraphicsRow[{
      InfraSubstrateHighlight[InfraTotalGraph[tangent], {InfraDensity[InfraTotalGraph[tangent], rays]}],
      InfraSubstrateHighlight[InfraTotalGraph[displacementBundle], {InfraDensity[InfraTotalGraph[displacementBundle], endpoint /@ rays]}]}],
    InfraBundleMorphismQ[tangent, displacementBundle, endpoint]}]
```

Swapping the two sheets is a bundle morphism of the prism and of the Moebius ladder over the identity. Turning the cycle by one step is a bundle morphism of the prism over the turn, but not of the Moebius ladder, whose twist does not move with the turn.

```wl
With[
  {prism = InfraFiberedSubstrate["CycleProductBundle", "Small"], moebius = InfraFiberedSubstrate["MoebiusLadderCover", "Small"]},
  {swap = totalVertex |-> {First @ totalVertex, 3 - Last @ totalVertex}, turn = totalVertex |-> {Mod[First @ totalVertex + 1, 8, 1], Last @ totalVertex}},
  {GraphicsRow[{InfraTotalGraph[prism], InfraTotalGraph[moebius]}],
    InfraBundleMorphismQ[prism, prism, swap], InfraBundleMorphismQ[moebius, moebius, swap],
    InfraBundleMorphismQ[prism, prism, turn, i |-> Mod[i + 1, 8, 1]], InfraBundleMorphismQ[moebius, moebius, turn, i |-> Mod[i + 1, 8, 1]]}]
```

## Properties and Relations

[InfraBundleMorphism]() gives the natural maps between the bundles of one base.

```wl
With[
  {g = GridGraph[{4, 4}]},
  {tangent = InfraTangentBundle[g, 2], cotangent = InfraCotangentBundle[g, 2]},
  InfraBundleMorphismQ[tangent, cotangent, InfraBundleMorphism[tangent, cotangent]]]
```
