---
Template: Symbol
Name: InfraIntersection
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraIntersection
Keywords: [intersection, common vertices, density, symbolic object, Euclid I.1]
SeeAlso: [InfraUnion, InfraMeasurement, InfraShell, InfraPoint, RandomInfraPoint]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraIntersection]()[*g*, *s1*, *s2*, …]</code> gives the sorted list of the vertices of *g* common to all the vertex sets *sᵢ*.

<code>[InfraIntersection]()[*obj1*, *obj2*]</code> is the intersection of two geometric objects, such as balls, shells and segments.

## Details & Options

The intersection is *S₁ ∩ S₂ ∩ …*. With a graph, each *sᵢ* is a vertex list, a density `<|v -> m, …|>` or a walk graph.

[InfraIntersection]() of two objects is a symbolic object: [InfraMeasurement]() evaluates it on a graph. Its vertex density is the product of the two densities on the common vertices, so on a vertex it counts the pairs of members, one of each object, that pass through it.

| Property | Value |
|---|---|
| `"VertexDensity"` | the product of the two densities on the common vertices |
| `"CountingMeasure"` | the number of common vertices |
| `"RiemannianMeasure"` | the number of common vertices all of whose neighbours are common |
| `"Subgraph"` | the subgraph induced on the common vertices |

It is a vertex set, not a family of paths: it has no `"Graph"`, `"Cardinality"` or `"Length"`.

In an [InfraScene](), <code>[InfraIntersection]()[*c1*, *c2*]</code> is the set of common points of two constructed objects, and <code>[InfraPoint]()[[InfraIntersection]()[*c1*, *c2*]]</code> picks one of them.

Corresponding notion in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Proposition I.1 | The two circles about the ends of a segment, through the other end, meet in the apex of an equilateral triangle. |

## Basic Examples

The circles of radius 4 about the centre *a* and about a point *b* at distance 4 meet in the apexes of the equilateral triangles on *ab*, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
    {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraShell[a, 4], InfraShell[b, 4], InfraIntersection[InfraShell[a, 4], InfraShell[b, 4]], {a, b}}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The common vertices of vertex lists:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, InfraIntersection[g, {44, 45, 46}, {45, 46, 47}, {46, 47}]]
```

## Scope

The segment from *a* to *b* cut by the ball of radius 2 about *b*. The density is the number of shortest paths through each vertex, times 1:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
  {cut = InfraIntersection[InfraSegment[a, b], InfraBall[b, 2]]},
  InfraSubstrateHighlight[g, {InfraMeasurement[g, cut, "VertexDensity"], {a, b}}, PlotLabel -> InfraMeasurement[g, cut, "VertexDensity"],
    ImageSize -> Medium]]
```

A density and a vertex list:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, InfraIntersection[g, {45, 46, 47}, <|46 -> 2, 47 -> 1, 48 -> 3|>]]
```

## Properties and Relations

The density is a product. A segment met with its reverse has the squares of its counts:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
  InfraMeasurement[g, InfraIntersection[InfraSegment[a, b], InfraSegment[b, a]], "VertexDensity"] ===
    (InfraMeasurement[g, InfraSegment[a, b], "VertexDensity"]^2)]
```

The support of the symbolic intersection is the intersection of the supports:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
  Keys @ InfraMeasurement[g, InfraIntersection[InfraShell[a, 4], InfraShell[b, 4]], "VertexDensity"] ===
    InfraIntersection[g, InfraMeasurement[g, InfraShell[a, 4], "VertexDensity"], InfraMeasurement[g, InfraShell[b, 4], "VertexDensity"]]]
```

## Possible Issues

With a graph the arguments are vertex sets. Geometric objects are not read, and the call stays unevaluated:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {a = First @ GraphCenter[g]},
  Head @ InfraIntersection[g, InfraBall[a, 2], InfraBall[a, 1]]]
```
