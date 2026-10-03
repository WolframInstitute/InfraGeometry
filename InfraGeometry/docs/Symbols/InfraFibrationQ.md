---
Template: Symbol
Name: InfraFibrationQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFibrationQ
Keywords: [edge lifting, fibration, path lifting]
SeeAlso: [InfraFibration, InfraFiberBundleQ, InfraBaseGraph, InfraFiber, InfraFiberedSubstrate]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[InfraFibrationQ]()[*fib*]</code> tests the edge lifting property: every total vertex over *p* has a neighbour over every base neighbour of *p*.

## Details & Options

- The base is the reconstructed [InfraBaseGraph]().
- [InfraFiberBundleQ]() asks more: isomorphic fibers and local triviality.

## Basic Examples

The double cover of a cycle is a fibration. Deleting one total edge breaks it: its two endpoints, drawn, lose their lift of a base edge.

```wl
With[
  {fib = InfraFiberedSubstrate["CycleDoubleCover", "Small"]},
  {total = InfraTotalGraph[fib]},
  {cut = First @ EdgeList[total]},
  {broken = InfraFibration[EdgeDelete[total, cut], InfraFibrationAssociation[fib]]},
  {InfraSubstrateHighlight[InfraTotalGraph[broken], {InfraDensity[total, List @@ cut]}], InfraFibrationQ[fib], InfraFibrationQ[broken]}]
```

Every entry of the catalogue is a fibration.

```wl
AllTrue[InfraFiberedSubstrate[All], InfraFibrationQ @ InfraFiberedSubstrate[#, "Small"] &]
```

## Properties and Relations

A branched fibration has fibers of different sizes and is still a fibration.

```wl
With[
  {fib = InfraFiberedSubstrate["BranchedCycleFibration", "Small"]},
  {InfraTotalGraph[fib], InfraFibrationQ[fib], InfraFiberBundleQ[fib]}]
```
