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
- This is the project's lift-existence convention. It does not impose the unique incoming-edge lifting used by some standard graph-fibration definitions.
- [InfraFiberBundleQ]() additionally requires a common fiber graph and unique transverse matchings preserving fiber adjacency.
- A nonempty list is tested by conjunction. An empty result list is False and does not establish existence.

## Basic Examples

The double cover of a cycle is a fibration. Deleting one total edge breaks it: its two endpoints, drawn, lose their lift of a base edge.

```wl
SeedRandom[ 7 ];
With[
  {fib = InfraFiberedSubstrate["CycleDoubleCover", "Small"]},
  {total = InfraTotalGraph[fib]},
  {cut = First @ EdgeList[total]},
  {broken = InfraFibration[EdgeDelete[total, cut], InfraFibrationAssociation[fib]]},
  {InfraSubstrateHighlight[InfraTotalGraph[broken], {InfraDensity[total, List @@ cut]}], InfraFibrationQ[fib], InfraFibrationQ[broken]}]
```

Every entry of the catalogue is a fibration.

```wl
SeedRandom[ 7 ];
AllTrue[InfraFiberedSubstrate[All], InfraFibrationQ @ InfraFiberedSubstrate[#, "Small"] &]
```

## Properties and Relations

A branched fibration has fibers of different sizes and is still a fibration.

```wl
SeedRandom[ 7 ];
With[
  {fib = InfraFiberedSubstrate["BranchedCycleFibration", "Small"]},
  {InfraTotalGraph[fib], InfraFibrationQ[fib], InfraFiberBundleQ[fib]}]
```
