---
Template: Symbol
Name: InfraConnectionQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraConnectionQ
Keywords: [connection, lift, horizontal edge]
SeeAlso: [InfraConnection, InfraFlatConnectionQ, RandomInfraConnection, FindInfraLeviCivitaConnection, InfraFibrationQ]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[InfraConnectionQ]()[*fib*, [InfraConnection]()[*edges*]]</code> tests whether *edges* are horizontal total edges giving exactly one lift wherever the total graph has one.

## Details & Options

- Every edge must be an edge of the total graph between two different fibers.
- At every total vertex *x* over *p*, the edges at *x* must lie over every base neighbour of *p* that the total graph reaches from *x*, each exactly once.

## Basic Examples

The horizontal edges of the prism are a connection. Without one of them they are not: its two endpoints, drawn, lose a lift.

```wl
With[
  {fib = InfraFiberedSubstrate["CycleProductBundle", "Small"]},
  {total = InfraTotalGraph[fib]},
  {horizontal = Select[EdgeList[total], First @ First @ # =!= First @ Last @ # &]},
  {InfraSubstrateHighlight[total, {InfraDensity[total, List @@ First @ horizontal]}],
    InfraConnectionQ[fib, InfraConnection[horizontal]], InfraConnectionQ[fib, InfraConnection[Rest @ horizontal]]}]
```

## Possible Issues

[RandomInfraConnection]() chooses a maximum matching over each base edge. Where it is not perfect, the result is not a connection.

```wl
With[
  {fib = InfraFiberedSubstrate["GridDisplacementBundle", "Small"]},
  InfraConnectionQ[fib, (SeedRandom[1]; RandomInfraConnection[fib])]]
```
