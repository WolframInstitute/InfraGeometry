---
Template: Symbol
Name: FindInfraBisectingHyperplane
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraBisectingHyperplane
Keywords: [perpendicular bisector, hyperplane, bisector, slab, separating set, Euclid I.10]
SeeAlso: [InfraPerpendicularBisector, InfraPlane, InfraMeasurement, FindInfraEquidistantSet]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[FindInfraBisectingHyperplane]()[*g*, *p1*, *p2*]</code> gives the bisector of *p1* and *p2*: the sorted list of the vertices equidistant from both.

<code>[FindInfraBisectingHyperplane]()[*g*, *p1*, *p2*, {*lo*, *hi*}]</code> gives the slab of the vertices *v* with *lo ≤ d(p₁, v) − d(p₂, v) ≤ hi*.

<code>[FindInfraBisectingHyperplane]()[*g*, *p1*, *p2*, …, *n*]</code> gives a list of *n* vertex sets of the class named by [Properties]().

## Details & Options

The bisector is *H(p₁, p₂) = {v : d(p₁, v) = d(p₂, v)}*. In the plane it is the perpendicular bisector, a line; here it is a vertex set.

On a bipartite graph, such as the square grid, *d(p₁, v) − d(p₂, v)* has the parity of *d(p₁, p₂)*. So the bisector is empty when *d(p₁, p₂)* is odd, and the slab {−1, 1} is then the vertices at difference ±1. On the mesh the bisector at odd distance is usually not empty.

The bisector need not separate *p₁* from *p₂*. On the grid it does; on the mesh a path can step across it from a vertex nearer *p₁* to a vertex nearer *p₂*.

The count *n* can be `n`, `UpTo[n]` or `All`. With the default `Properties -> {}` the class has one set, the bisector or the slab itself.

In the slab *B* without *p₁* and *p₂*, a wall is a set *W ⊆ B* that separates *p₁* from *p₂*, induces a connected subgraph, and has no proper subset that does both. A connected minimal separator is a wall. On the square grid the minimal separators of a diagonal pair are staircases whose vertices meet only at corners, and that bisector has no wall. The walls are found by a greedy search: from a connected separating piece of *B*, vertices are removed one at a time while the set stays connected and separating. With a count the walls are distinct; `All` searches all of them, in time that can be exponential.

| Option | Default | Values |
|---|---|---|
| [Properties]() | `{}` | `{}`: the bisector or slab; `{"Separating"}`: its inclusion-minimal subsets that separate *p₁* from *p₂*; `{"Separating", "Connected"}`: its walls |
| `"NextVertexFunction"` | `Identity` | for the separators a function applied to the class in sorted order, `Identity` keeping it, `RandomSample` shuffling it; for the walls a function of the removable vertices at each step, `Identity` taking the first, `RandomSample` a random one |

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Propositions I.10, I.11 | To bisect a segment, and to draw a perpendicular at a point of it. |
| Hilbert | Group III | The locus equidistant from two points, from segment congruence. |
| Tarski | Equidistance | The points *v* with *vp₁* congruent to *vp₂*. |

## Basic Examples

The bisector of the centre and a vertex at distance 4, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
    {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {FindInfraBisectingHyperplane[g, a, b], {a, b}}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

At distance 5 the grid has no bisector; the mesh has one:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
    {b = RandomInfraPoint[g, InfraShell[a, 5], RandomSeeding -> 1]},
    FindInfraBisectingHyperplane[g, a, b]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The slab {−1, 1} at distance 5 on the grid, the two layers on either side of the missing bisector:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 5], RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {FindInfraBisectingHyperplane[g, a, b, {-1, 1}], {a, b}}, ImageSize -> Medium]]
```

## Options

### Properties

On the grid 8 of the 10 vertices of the bisector already separate the two points:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
  {wall = First @ FindInfraBisectingHyperplane[g, a, b, All, Properties -> {"Separating"}]},
  InfraSubstrateHighlight[g, {FindInfraBisectingHyperplane[g, a, b], wall, {a, b}},
    PlotLabel -> {Length @ FindInfraBisectingHyperplane[g, a, b], Length[wall]}, ImageSize -> Medium]]
```

Three walls in the slab {−1, 1} at distance 5, the first three the search meets:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 5], RandomSeeding -> 1]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {wall, {a, b}}],
    {wall, FindInfraBisectingHyperplane[g, a, b, {-1, 1}, UpTo[3], Properties -> {"Separating", "Connected"}]}]]
```

## Properties and Relations

Every vertex of the bisector is equidistant from the two points:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
  AllTrue[FindInfraBisectingHyperplane[g, a, b], GraphDistance[g, a, #] == GraphDistance[g, b, #] &]]
```

On the mesh the bisector does not separate: after its removal *a* and *b* are still connected, so no subset of it separates them:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
  {bisector = FindInfraBisectingHyperplane[g, a, b]},
  {MemberQ[ConnectedComponents[VertexDelete[g, bisector]], _?(SubsetQ[#, {a, b}] &)],
   FindInfraBisectingHyperplane[g, a, b, All, Properties -> {"Separating"}]}]
```

On the grid the centre and its diagonal neighbour have 1369 minimal separators in the bisector, none of them connected, and no wall:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {separators = FindInfraBisectingHyperplane[g, 45, 56, All, Properties -> {"Separating"}]},
  {Length[separators], Count[separators, s_ /; ConnectedGraphQ[Subgraph[g, s]]],
   FindInfraBisectingHyperplane[g, 45, 56, All, Properties -> {"Separating", "Connected"}]}]
```

## Possible Issues

A count larger than the class gives `{}`. Under the default `Properties -> {}` there is one set:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
  {FindInfraBisectingHyperplane[g, a, b, 2], Length @ FindInfraBisectingHyperplane[g, a, b, UpTo[2]]}]
```
