---
Template: Symbol
Name: InfraSphere
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSphere
Keywords: [sphere, separating set, minimal, region, inert head, family]
SeeAlso: [FindInfraSphere, InfraShell, InfraBall, InfraMeasurement, FindInfraRepresentative, SeparatesQ]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraSphere]()[*c*, {*r*, *s*}]</code> is the sphere about *c*: the family of inclusion-minimal connected subsets of the shell [InfraShell]()[*c*, {*r*, *s*}] that separate the side of *c* from the far side. It is inert; [InfraMeasurement]() and [FindInfraRepresentative]() evaluate it on a graph.

<code>[InfraSphere]()[*c*, *r*]</code> is the band {*r*, *r*}.

## Details & Options

Definition: a sphere of the shell *S* is a subset *T ⊆ S* such that the induced subgraph on *T* is connected, deleting *T* leaves the component of *c* within the mean radius and every other vertex beyond it, and no proper subset of *T* does.

The shell is a set of points. The sphere is the family of its connected separating subsets, and it is searched, not read off a graph: no polynomial-size faithful graph of the family is known. [FindInfraSphere]() is the search.

[FindInfraRepresentative]() gives members: a count, `"RandomChoice"` and `"Pruning" -> q` are translated to the `Method` of [FindInfraSphere](). Without a count it gives one member, a sorted vertex list.

[InfraMeasurement]() reads the family through the exhaustive search, so it is expensive: `"VertexDensity"` is the sum of the indicators of the members, `"EdgeDensity"` the sum of their induced edge sets, `"Cardinality"` their number, and the volumes the support of the density. `"Faithful"` is `Undetermined`. A sphere has no `"Graph"`.

When the shell wraps around, as on a torus, and does not separate, the family is empty.

## Basic Examples

The four minimal connected separators in the band 1 to 2 about the centre of a 5 by 5 grid.

```wl
FindInfraRepresentative[GridGraph[{5, 5}], InfraSphere[13, {1, 2}], All]
```

One separating subset of the shell of radius 4 on the square, hexagonal and triangular tilings.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = InfraCenter[g]},
    InfraSubstrateHighlight[g, {InfraShell[c, 4], FindInfraRepresentative[g, InfraSphere[c, 4]], Directive[$InfraPointColor], c}]],
  {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]
```

## Properties and Relations

Measuring the family: the number of members, and the volume of their union.

```wl
InfraMeasurement[GridGraph[{5, 5}], InfraSphere[13, {1, 2}], {"Cardinality", "Faithful", "Volume"}]
```

A member is connected and is contained in the shell.

```wl
With[
  {g = GridGraph[{7, 7}]},
  {members = FindInfraRepresentative[g, InfraSphere[25, {2, 3}], All]},
  {ConnectedGraphQ @ Subgraph[g, #] & /@ members, AllTrue[members, SubsetQ[FindInfraShell[g, 25, {2, 3}], #] &]}]
```
