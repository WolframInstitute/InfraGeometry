---
Template: Symbol
Name: RandomInfraInfiniteLine
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraInfiniteLine
Keywords: [line, inextensible shortest path, Euclid Postulate 2, parallel postulate]
SeeAlso: [InfraInfiniteLine, InfraInfiniteLineQ, BeamGraph, RandomInfraHalfLine, RandomInfraSegment, LineCount]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraInfiniteLine]()[*g*, *p*, *q*]</code> gives a random line through *p* and *q* in *g*, as a vertex list.

<code>[RandomInfraInfiniteLine]()[*g*, *path*]</code> gives a random line that contains the shortest path *path*.

<code>[RandomInfraInfiniteLine]()[*g*, *p*, *q*, *n*]</code> and <code>[RandomInfraInfiniteLine]()[*g*, *path*, *n*]</code> give lists of *n* distinct lines.

<code>[RandomInfraInfiniteLine]()[*g*, *path*, UpTo[*k*], *n*]</code> and <code>[RandomInfraInfiniteLine]()[*g*, *p*, *q*, UpTo[*k*], *n*]</code> add at most *k* vertices on each side.

<code>[RandomInfraInfiniteLine]()[*g*, [InfraInfiniteLine]()[*p*, *q*]]</code> gives a member of the line, every line with the same probability; a count *n* gives *n* distinct members.

## Details & Options

A line is an inextensible shortest path: a shortest path *a = v₀, …, vₖ = b*, *k = d(a, b)*, such that no neighbour of *a* or of *b* lies farther from the other end. The predicate is [InfraInfiniteLineQ]().

A line need not reach the rim: on the mesh it can end at an inner vertex none of whose neighbours is farther from the other end. A line through *p* and *q* passes *p* before *q*.

A shortest path has no unique line through it: <code>[RandomInfraInfiniteLine]()[*g*, *path*, All]</code> is a family. Its ends are admissible only as a pair: an end that is admissible on its own side can fail together with the other end, so the family is smaller than the product of the two extension sets.

In the plane two points lie on one line. On a graph they lie on many: two vertices at distance 2 lie on 9800 lines of the small square grid and on 210 of the small square mesh.

The lines through *p* and *q* are the lines through the shortest paths from *p* to *q*, each line through exactly one of them.

A line through a shortest path grows on both sides in turn, the shorter side first. A side that cannot continue stays stopped, and the other side continues alone.

With `UpTo[k]` before the count, each side stops after *k* added vertices; a side ends earlier only where the stretch cannot continue. Without it there is no limit. A token with `UpTo[k]` is grown from its shortest paths, not drawn uniformly from its lines.

The count *n* can be `n`, `UpTo[n]` or `All`. A count above the number of lines gives `{}`.

Options:

| Option | Default | Values |
|---|---|---|
| `"NextVertexFunction"` | `Automatic` | `Automatic` random; `Identity` the first lines in vertex order |
| [RandomSeeding]() | `Automatic` | an integer or a string for a reproducible draw; `Inherited` to draw from the current random state |

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Postulate 2 | To produce a finite straight line continuously in a straight line. |
| Euclid | Postulate 5 | The parallel postulate quantifies over lines. |
| Hilbert | I.1, I.2 | Two points determine one and only one line. Here they determine a family. |
| Tarski | (derived) | Lines are not primitive; collinearity is defined from betweenness. |
| Birkhoff | Ruler postulate | A line is in bijection with the reals; here every line is a finite path. |

## Basic Examples

A random line through the centre and a vertex at distance 2, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
    {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraWalk[RandomInfraInfiniteLine[g, p, q, RandomSeeding -> 1]], p, q}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The number of lines through the two points, on the grid and on the mesh:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small"]}, {p = First @ GraphCenter[g]},
    {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
    InfraMeasurement[g, InfraInfiniteLine[p, q], "Cardinality"]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

Three lines through the same two points of the mesh:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[line], p, q}],
    {line, RandomInfraInfiniteLine[g, InfraInfiniteLine[p, q], 3, RandomSeeding -> 1]}]]
```

## Scope

A line through a given shortest path contains it:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {path = RandomInfraSegment[g, p, RandomInfraPoint[g, InfraShell[p, 3], RandomSeeding -> 1], RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {InfraWalk[RandomInfraInfiniteLine[g, path, RandomSeeding -> 1]], path}, ImageSize -> Medium]]
```

At most two vertices on each side of the shortest path:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {path = RandomInfraSegment[g, p, RandomInfraPoint[g, InfraShell[p, 3], RandomSeeding -> 1], RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {InfraWalk[RandomInfraInfiniteLine[g, path, UpTo[2], Automatic, RandomSeeding -> 1]], path}, ImageSize -> Medium]]
```

On the 12-cycle the line through the edge 1, 2 grows three vertices back and two forward; with `UpTo[1]` one on each side:

```wl
{RandomInfraInfiniteLine[CycleGraph[12], {1, 2}], RandomInfraInfiniteLine[CycleGraph[12], {1, 2}, UpTo[1], All]}
```

## Properties and Relations

Every line satisfies [InfraInfiniteLineQ]():

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
  InfraInfiniteLineQ[g, RandomInfraInfiniteLine[g, p, q, All]]]
```

The lines through *p* and *q* split by the shortest path from *p* to *q* they contain. On the mesh there are two such paths:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
  {Length @ RandomInfraInfiniteLine[g, #, All] & /@ RandomInfraSegment[g, p, q, All],
   Length @ RandomInfraInfiniteLine[g, p, q, All]}]
```

## Possible Issues

On the 4-cycle the edge 1, 2 extends to 4, 1, 2 and to 1, 2, 3, but not to 4, 1, 2, 3: two lines through one shortest path, and neither contains the other:

```wl
RandomInfraInfiniteLine[CycleGraph[4], {1, 2}, All]
```

On the hexagon three lines pass through the edge from 1 to 2, not four. The line can end at 5 on one side and at 4 on the other, but not at both: 5, 6, 1, 2, 3, 4 is not a shortest path:

```wl
RandomInfraInfiniteLine[CycleGraph[6], {1, 2}, All]
```
