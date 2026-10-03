---
Template: Symbol
Name: InfraFibration
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFibration
Keywords: [fibration, fibered graph, total graph, projection, base graph]
SeeAlso: [InfraTotalGraph, InfraFibrationAssociation, InfraBaseGraph, InfraFiber, InfraFibrationQ, InfraFiberBundleQ, InfraFiberedSubstrate, InfraTangentBundle, InfraDisplacementBundle]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[InfraFibration]()[*total*, *proj*]</code> is the fibration of the graph *total* with the projection *proj*, an association or a function on the vertices of *total*.

<code>[InfraFibration]()[*fib*]</code> gives the construction *fib*, such as <code>[InfraTangentBundle]()[*g*, *r*]</code>, as a literal [InfraFibration](), computing its total graph once.

## Details & Options

- A fibration is a graph *total*, the total graph, with a map *proj* from its vertices to the vertices of a base graph. The fiber over a base vertex *p* is the subgraph of *total* on the vertices that *proj* sends to *p*.
- The base graph is not stored. [InfraBaseGraph]() reconstructs it from the projection: two base vertices are adjacent iff some total edge projects onto them.
- [InfraFibration]() is inert. It holds the graph and the projection, and every function of the Infra Fiber Bundles guide reads them through [InfraTotalGraph]() and [InfraFibrationAssociation]().
- The constructions [InfraTangentBundle](), [InfraCotangentBundle]() and [InfraDisplacementBundle]() are fibrations as well. They recompute their total graph on every call; <code>[InfraFibration]()[*fib*]</code> computes it once.
- [InfraFibration]() does not check the edge lifting property. That is [InfraFibrationQ]().

## Basic Examples

The cycle of length 8 over the square, the vertex *i* over *i* mod 4. The fiber over 1 is drawn.

```wl
With[
  {fib = InfraFibration[CycleGraph[8], i |-> Mod[i, 4, 1]]},
  {total = InfraTotalGraph[fib]},
  InfraSubstrateHighlight[total, {InfraDensity[total, VertexList @ InfraFiber[fib, 1]]}]]
```

A literal fibration from the catalogue, the Moebius ladder over a cycle, each fiber in its own colour.

```wl
With[
  {fib = InfraFiberedSubstrate["MoebiusLadderCover", "Small"]},
  {total = InfraTotalGraph[fib]},
  InfraSubstrateHighlight[total, InfraDensity[total, VertexList @ #] & /@ Values @ InfraFibers[fib]]]
```

## Scope

The projection may be an association instead of a function. Both give the same base.

```wl
With[
  {byFunction = InfraFibration[CycleGraph[8], i |-> Mod[i, 4, 1]]},
  {byAssociation = InfraFibration[CycleGraph[8], AssociationThread[Range[8], Mod[Range[8], 4, 1]]]},
  {InfraBaseGraph[byAssociation], IsomorphicGraphQ[InfraBaseGraph[byFunction], InfraBaseGraph[byAssociation]]}]
```

A construction converted to a literal fibration keeps its total graph.

```wl
With[
  {bundle = InfraFiberedSubstrate["GridDisplacementBundle", "Small"]},
  {fib = InfraFibration[bundle]},
  {InfraTotalGraph[fib], Head[fib], InfraTotalGraph[fib] === InfraTotalGraph[bundle]}]
```
