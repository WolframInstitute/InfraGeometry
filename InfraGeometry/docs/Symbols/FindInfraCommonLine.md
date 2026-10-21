---
Template: Symbol
Name: FindInfraCommonLine
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraCommonLine
Keywords: [line, collinear, common line, line through points, Hilbert I.1]
SeeAlso: [FindInfraCommonPoint, RandomInfraInfiniteLine, InfraInfiniteLine, InfraInfiniteLineQ, LineCount]
---

## Usage

<code>[FindInfraCommonLine]()[*g*, {*v1*, *v2*, …}]</code> gives the lines of *g* that contain every vertex *vi*.

<code>[FindInfraCommonLine]()[*g*, {*v1*, *v2*, …}, *n*]</code> gives *n* of them.

## Details & Options

A line is a maximal shortest path, as in [InfraInfiniteLine](): a shortest path that no neighbour of either end prolongs. The result is the set of lines *l* with *{v₁, …, vₖ} ⊆ l*, each a directed path graph.

A line and its reversal are the same line, and each appears once.

An entry can be a vertex, a vertex list, a density or a walk graph. Their vertices are pooled.

In the plane two points lie on one line. On a graph they lie on many: on the square grid the lines through two points are the monotone staircases from rim to rim that pass through both. A further point cuts the family down, and points that are not collinear give `{}`.

The count *n* can be `n`, `UpTo[n]` or `All`, the default. Fewer than *n* lines give `{}`.

Corresponding notion in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Hilbert | I.1, I.2 | Two distinct points determine one and only one line. Here they determine a family. |
| Euclid | Postulate 2 | To produce a finite straight line continuously in a straight line. |

## Basic Examples

One line through the centre and a point at distance 3. The label is the number of such lines:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {b = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {FindInfraCommonLine[g, {c, b}, 1], c, b},
      PlotLabel -> Length @ FindInfraCommonLine[g, {c, b}]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

A third point cuts the family. On the mesh the three points are not collinear:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small"]}, {c = First @ GraphCenter[g]},
    {a = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 2], b = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1]},
    Length /@ {FindInfraCommonLine[g, {c, b}], FindInfraCommonLine[g, {a, c, b}]}],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Properties and Relations

The lines through two points are the lines [RandomInfraInfiniteLine]() draws through them:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1]},
  {Length @ FindInfraCommonLine[g, {c, b}], Length @ RandomInfraInfiniteLine[g, c, b, All]}]
```

## Possible Issues

A single line comes back as a graph, not as a list of one graph. A count gives the list:

```wl
{FindInfraCommonLine[PathGraph[Range[6]], {2, 4}], FindInfraCommonLine[PathGraph[Range[6]], {2, 4}, 1]}
```
