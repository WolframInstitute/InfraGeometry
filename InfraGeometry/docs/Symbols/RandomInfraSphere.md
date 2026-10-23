---
Template: Symbol
Name: RandomInfraSphere
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraSphere
Keywords: [sphere, wall, separating set, shell, band, minimal separator, greedy]
SeeAlso: [InfraSphere, InfraShell, RandomInfraCircle, InfraMeasurement, InfraBall]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraSphere]()[*g*, *c*, *r*]</code> gives a random sphere of radius *r* about *c* in *g*, a wall in the shell of radius *r*, as a sorted vertex list.

<code>[RandomInfraSphere]()[*g*, *c*, {*r*, *s*}]</code> gives a random wall in the band of radii *r* to *s*.

<code>[RandomInfraSphere]()[*g*, *c*, *r*, *n*]</code> gives a list of *n* distinct walls.

<code>[RandomInfraSphere]()[*g*, [InfraSphere]()[*c*, *r*]]</code> and <code>[RandomInfraSphere]()[*g*, [InfraSphere]()[*c*, *r*], *n*]</code> are the same with the sphere given as a token.

## Details & Options

In the band *B = {v ≠ c : r ≤ d(c, v) ≤ s}* a wall is a set *W ⊆ B* that separates *c* from the vertices beyond *s*, induces a connected subgraph, and has no proper subset that does both. *W* separates when every path from *c* to a vertex *v* with *d(c, v) > s* meets *W*.

One draw is a greedy search. It starts from a connected piece of *B* that separates, chosen at random, and removes one vertex at a time, chosen uniformly among the vertices whose removal leaves a connected separating set, until no vertex can go. The result is a wall: if a smaller connected separating set lay inside, some vertex outside it could still go. The draw is fast, and it is not uniform over the walls.

With a count *n* the draws are distinct: each further draw runs the same search but avoids the sets all of whose walls were drawn already. `All` gives every wall, sorted; that search can take a time exponential in the size of the band.

On the square grid, which is bipartite, a shell of one radius has no edges, and a sphere of one radius does not exist; a band {*r*, *r* + 1} has walls, closed zigzags between its two shells. When no connected part of the band separates, the result is `{}`.

Options:

| Option | Default | Values |
|---|---|---|
| [Properties]() | `{"Separating", "Connected"}` | the walls; `{"Separating"}` the minimal separating subsets of *B*, a draw uniform over all of them; `{}` the band itself |
| `"NextVertexFunction"` | `Automatic` | `Automatic` removes a random vertex at each step; `Identity` the first removable vertex in vertex order, the same wall at every call; a function of the candidate list gives the vertices to try |
| [RandomSeeding]() | `Automatic` | an integer or a string for a reproducible draw; `Inherited` to draw from the current random state |

## Basic Examples

A sphere in the band {3, 4} about the centre, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    InfraSubstrateHighlight[g, {InfraShell[c, {3, 4}], RandomInfraSphere[g, c, {3, 4}, RandomSeeding -> 1], c}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

On the mesh the shell of radius 3 is a cycle, and the sphere is the whole shell, the vertices of the circle of radius 3:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {sphere = RandomInfraSphere[g, c, 3, RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {sphere, c}, PlotLabel -> {Length[sphere], sphere === Sort @ RandomInfraCircle[g, c, 3]},
    ImageSize -> Medium]]
```

Three walls of the band {3, 4} on the grid, each of 23 vertices:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {sphere, c}, PlotLabel -> Length[sphere]],
    {sphere, RandomInfraSphere[g, c, {3, 4}, 3, RandomSeeding -> 1]}]]
```

## Options

### Properties

On the grid the shell of radius 3 separates but has no edges. Without connectedness the sphere is the whole shell of 12 vertices; with it there is none:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {sphere = RandomInfraSphere[g, c, 3, Properties -> {"Separating"}, RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {sphere, c}, PlotLabel -> {Length[sphere], RandomInfraSphere[g, c, 3]}, ImageSize -> Medium]]
```

### NextVertexFunction

With `Identity` the search is deterministic. In the band {2, 3} on the grid it gives a zigzag of 15 vertices, a path whose two ends are diagonal neighbours:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {wall = RandomInfraSphere[g, c, {2, 3}, "NextVertexFunction" -> Identity]},
  InfraSubstrateHighlight[g, {wall, c}, PlotLabel -> {Length[wall], PathGraphQ[Subgraph[g, wall]]}, ImageSize -> Medium]]
```

## Properties and Relations

Removing a sphere of the band {3, 4} leaves the centre with vertices within distance 3 only:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {sphere = RandomInfraSphere[g, c, {3, 4}, RandomSeeding -> 1]},
  Max[GraphDistance[g, c, #] & /@ VertexComponent[VertexDelete[g, sphere], c]]]
```

Every draw is a member of the family:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  AllTrue[RandomInfraSphere[g, c, {3, 4}, 5, RandomSeeding -> 1], InfraMemberQ[g, InfraSphere[c, {3, 4}], #] &]]
```

The token form gives the same draw:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  RandomInfraSphere[g, InfraSphere[c, {3, 4}], RandomSeeding -> 1] === RandomInfraSphere[g, c, {3, 4}, RandomSeeding -> 1]]
```
