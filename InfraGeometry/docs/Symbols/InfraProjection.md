---
Template: Symbol
Name: InfraProjection
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraProjection
Keywords: [projection, association, literal vertex, fibered graph]
SeeAlso: [InfraFiberedGraph, InfraTotalSpace, InfraBaseSpace, InfraFibers]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraProjection]()[*fib*]</code> gives the projection *π* of the fibered graph *fib*, as an association from the total vertices to the base vertices.

## Details & Options

The projection is a map *π : V(E) → V(B)* from the total graph *E* to the base *B*. The fiber over *p* is the subgraph of *E* on *π⁻¹(p)*, and the base has the values of *π* as its vertices.

In <code>[InfraFiberedGraph]()[*E*, *π*]</code>, *π* is an association whose keys are exactly the vertices of *E*, or a function applied to each vertex.

The tangent and displacement bundles project a ray or a pair to its first vertex, the cotangent bundle a reversed ray to its last vertex.

Total vertices are often lists. Read one with <code>[Lookup]()[*π*, [Key]()[*v*]]</code>.


## Basic Examples

The projection of a double covering of the 4 × 4 grid sends the vertex {*p*, *k*} on sheet *k* to *p*:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}],
    Properties -> {"Covering"}, "VerticalVertexCount" -> {2}, RandomSeeding -> 1]},
  Take[InfraProjection[fib], 6]]
```

The fibers are the preimages of base vertices. The preimages of the vertices 6 and 10:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}], "VerticalVertexCount" -> {1, 3}, "VerticalEdgeCount" -> 2,
    RandomSeeding -> 6]}, {proj = InfraProjection[fib]},
  InfraFiberedGraphHighlight[fib, {Keys @ Select[proj, EqualTo[6]], Keys @ Select[proj, EqualTo[10]]},
    ImageSize -> Medium]]
```

## Scope

A tangent vector projects to its first vertex, a cotangent vector to its last. The ray {6, 7, 8} and its reverse both lie over 6:

```wl
With[{g = GridGraph[{4, 4}]},
  {Lookup[InfraProjection[InfraTangentBundle[g, 2]], Key[{6, 7, 8}]],
   Lookup[InfraProjection[InfraCotangentBundle[g, 2]], Key[{8, 7, 6}]]}]
```

## Properties and Relations

The counts of the projection values are the fiber sizes:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}], "VerticalVertexCount" -> {1, 3}, RandomSeeding -> 1]},
  KeySort[Counts[Values[InfraProjection[fib]]]] === KeySort[VertexCount /@ InfraFibers[fib]]]
```

## Possible Issues

A list in [Lookup]() is a list of keys. A list-valued vertex needs [Key]():

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}],
    Properties -> {"Covering"}, "VerticalVertexCount" -> {2}, RandomSeeding -> 1]},
  {Lookup[InfraProjection[fib], {6, 1}], Lookup[InfraProjection[fib], Key[{6, 1}]]}]
```
