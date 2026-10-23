---
Template: Symbol
Name: InfraFibrationAssociation
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFibrationAssociation
Keywords: [projection, older name, InfraProjection]
SeeAlso: [InfraProjection, InfraFiberedGraph, InfraTotalSpace, InfraBaseSpace]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraFibrationAssociation]()[*fib*]</code> is the older name of <code>[InfraProjection]()[*fib*]</code>: the projection of *fib* as an association from each total vertex to its base vertex.

## Details & Options

Use [InfraProjection]() in new code. Both names accept the same fibered graphs and give the same association. A function projection is evaluated at every vertex.

## Basic Examples

The projection of the cycle of length 8 onto the cycle of length 4:

```wl
InfraFibrationAssociation @ InfraFiberedGraph[CycleGraph[8], v |-> Mod[v, 4, 1]]
```

## Properties and Relations

It is [InfraProjection]():

```wl
With[{fib = InfraFiberedSubstrate["GridProductBundle", "Small"]},
  InfraFibrationAssociation[fib] === InfraProjection[fib]]
```
