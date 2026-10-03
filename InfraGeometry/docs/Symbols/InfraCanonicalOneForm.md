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

<code>[InfraCanonicalOneForm]()[*g*, {*x*, …, *v*}, {*y*, …}]</code> gives the canonical 1-form at the vector *x* -> *v* on the step to *y*: the pairing (*d*(*x*, *v*)^2 + *d*(*x*, *y*)^2 - *d*(*v*, *y*)^2)/2.

## Details & Options

- Only the first and last vertices of the vector and the first vertex of the target are read, so a ray of [InfraRays]() and a pair of [InfraDisplacementBundle]() both work as the vector.
- The pairing is the polar form of the path metric at *x*.

## Basic Examples

The vector from 6 two steps up the grid, and its pairing with the four steps from 6.

```wl
With[
  {g = First @ InfraFiberedSubstrate["GridTangentBundle", "Small"]},
  {rayVector = {6, 7, 8}},
  {InfraSubstrateHighlight[g, Join[{InfraWalk[rayVector], Directive[StandardBlue]}, InfraWalk[{6, #}] & /@ AdjacencyList[g, 6]]],
    Normal @ AssociationMap[y |-> InfraCanonicalOneForm[g, rayVector, {y}], AdjacencyList[g, 6]]}]
```

## Properties and Relations

A ray of length *r* from the centre, paired with its own first step, gives *r*, for every ray of length 1 and 2.

```wl
With[
  {g = GridGraph[{5, 5}]},
  Table[Union[InfraCanonicalOneForm[g, #, Rest @ #] & /@ InfraRays[g, 13, r]], {r, 1, 2}]]
```
