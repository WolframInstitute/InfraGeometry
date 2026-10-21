---
Template: Symbol
Name: InfraCanonicalOneForm
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraCanonicalOneForm
Keywords: [canonical one-form, tautological one-form, polar form, pairing, covector]
SeeAlso: [InfraRays, InfraTangentBundle, InfraCotangentBundle, InfraDisplacementBundle]
RelatedGuides: [InfraFiberBundles, InfraAnalysis]
---

## Usage

<code>[InfraCanonicalOneForm]()[*g*, {*x*, …, *v*}, {*y*, …}]</code> gives the canonical 1-form of the graph *g* at the vector *x* → *v* on the step to *y*: the polar form *(d(x, v)² + d(x, y)² − d(v, y)²) / 2*.

## Details & Options

The value is *θ = ⟨v, y⟩ₓ = (d(x, v)² + d(x, y)² − d(v, y)²) / 2*, the polar form of the path metric at *x*. In the plane it is the dot product of the vectors *x → v* and *x → y*.

Only the first and last vertex of the vector and the first vertex of the target are read. A ray of [InfraRays]() and a pair of [InfraDisplacementBundle]() with the same ends give the same value.

For a vector of length *r* and a step, *d(x, y) = 1*, the distance *d(v, y)* is *r − 1*, *r* or *r + 1*, so the value is *r*, *1/2* or *−r*. On a bipartite graph such as the square grid only *±r* occur: *r* when *y* lies on a shortest path from *x* to *v*, *−r* otherwise. In the plane a step at right angles to the vector gives 0; on the grid it gives *−r*.

The step to *x* itself gives 0, and the first step of the ray gives *r*.

## Basic Examples

A vector of length 2 at the centre, and the steps from the centre that pair with it positively and negatively. The label lists the values:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {ray = First @ InfraRays[g, c, 2]},
    {values = AssociationMap[y |-> InfraCanonicalOneForm[g, ray, {y}], AdjacencyList[g, c]]},
    InfraSubstrateHighlight[g, {InfraWalk[ray], Keys @ Select[values, Positive], Keys @ Select[values, Negative]},
      PlotLabel -> Sort @ Values[values]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

On the grid every ray of length *r* at the centre pairs with every step to *r* or *−r*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Table[Union @ Flatten @ Table[InfraCanonicalOneForm[g, ray, {y}], {ray, InfraRays[g, c, r]}, {y, AdjacencyList[g, c]}],
    {r, 4}]]
```

On the mesh, a triangulation, the value 1/2 occurs too:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Table[Union @ Flatten @ Table[InfraCanonicalOneForm[g, ray, {y}], {ray, InfraRays[g, c, r]}, {y, AdjacencyList[g, c]}],
    {r, 3}]]
```

## Properties and Relations

The value *r* on the grid marks the steps toward *v*, those with *d(y, v) = r − 1*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Table[Union @ Flatten @ Table[(InfraCanonicalOneForm[g, ray, {y}] == r) == (GraphDistance[g, y, Last @ ray] == r - 1),
      {ray, InfraRays[g, c, r]}, {y, AdjacencyList[g, c]}],
    {r, 4}]]
```

Every ray of length *r* paired with its own first step gives *r*, and the step to *x* itself gives 0:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Table[Union[{InfraCanonicalOneForm[g, #, Rest @ #], InfraCanonicalOneForm[g, #, {c}]} & /@ InfraRays[g, c, r]],
    {r, 4}]]
```

A ray and the pair of its ends give the same value:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Union @ Flatten @ Table[
    InfraCanonicalOneForm[g, ray, {y}] == InfraCanonicalOneForm[g, {First @ ray, Last @ ray}, {y}],
    {ray, InfraRays[g, c, 3]}, {y, AdjacencyList[g, c]}]]
```
