---
Template: Symbol
Name: InfraTotalGraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraTotalGraph
Keywords: [total graph, fibration, bundle]
SeeAlso: [InfraFibration, InfraFibrationAssociation, InfraBaseGraph, InfraFiber, InfraTangentBundle, InfraDisplacementBundle, InfraFiberedSubstrate]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[InfraTotalGraph]()[*fib*]</code> gives the total graph of the fibration *fib*.

## Details & Options

- [InfraTotalGraph]() is one of the two primitives of a fibration; the other is [InfraFibrationAssociation](). Every other function of the Infra Fiber Bundles guide is written over these two.
- For a literal <code>[InfraFibration]()[*total*, *proj*]</code> it is *total*. For a construction it is computed: the rays of [InfraTangentBundle](), the reversed rays of [InfraCotangentBundle](), the pairs of [InfraDisplacementBundle]().
- The total graph of a construction carries vertex coordinates: each total vertex is drawn near its base point, displaced towards the rest of its ray or pair.

## Basic Examples

Three fibrations over the same grid: a product with a triangle, the tangent bundle at scale 2 and the displacement bundle at scale 1.

```wl
GraphicsRow[InfraTotalGraph /@ {
  InfraFiberedSubstrate["GridProductBundle", "Small"],
  InfraFiberedSubstrate["GridTangentBundle", "Small"],
  InfraFiberedSubstrate["GridDisplacementBundle", "Small"]}]
```

The rays of the tangent bundle over the base vertex 6, drawn around their base point.

```wl
With[
  {total = InfraTotalGraph @ InfraFiberedSubstrate["GridTangentBundle", "Small"]},
  InfraSubstrateHighlight[total, {InfraDensity[total, Select[VertexList @ total, First @ # == 6 &]]}]]
```

## Properties and Relations

The base graph is reconstructed from the total graph and the projection.

```wl
With[
  {fib = InfraFiberedSubstrate["MoebiusLadderCover", "Small"]},
  GraphicsRow[{InfraTotalGraph[fib], InfraBaseGraph[fib]}]]
```
