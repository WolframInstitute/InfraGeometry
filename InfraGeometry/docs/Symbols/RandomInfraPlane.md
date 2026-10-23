---
Template: Symbol
Name: RandomInfraPlane
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraPlane
Keywords: [plane, bisector, perpendicular bisector, separating set, hyperplane]
SeeAlso: [InfraPlane, InfraPlaneQ, InfraPerpendicularBisector, FindInfraBisectingHyperplane, InfraEquidistantSet]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraPlane]()[*g*, [InfraPlane]()[*p*, *q*]]</code> gives a random plane bisecting *p* and *q* in *g*, as a vertex list.

<code>[RandomInfraPlane]()[*g*, [InfraPlane]()[*p*, *q*, {*lo*, *hi*}]]</code> takes the plane inside the slab of distance differences *lo* to *hi*.

<code>[RandomInfraPlane]()[*g*, *plane*, *n*]</code> gives a list of *n* distinct planes.

<code>[RandomInfraPlane]()[*g*, *p*, *q*]</code>, <code>[RandomInfraPlane]()[*g*, *p*, *q*, {*lo*, *hi*}]</code> and the same with a count *n* give the plane with the points given directly.

## Details & Options

The slab is *B = {v : lo ≤ d(p, v) − d(q, v) ≤ hi}* without *p* and *q*; the default is {0, 0}, the equidistant set. A plane is an inclusion-minimal subset of *B* that separates *p* from *q*: every path from *p* to *q* meets it, and no smaller subset does that.

The slab can be thick. On the square grid the equidistant set of a diagonal pair contains two quadrants, and a plane is a thin wall inside it. For an axis pair the equidistant set is a line, and the plane is that line.

On a bipartite graph *d(p, v) − d(q, v)* has the parity of *d(p, q)*. On the square grid the equidistant set of two points at odd distance is empty, and {−1, 1} is the same slab as {0, 0} at even distance. On the mesh the equidistant set need not separate; the slab {−1, 1} can.

Adjacent points have no plane: no vertex set separates them.

The count *n* can be `n`, `UpTo[n]` or `All`. The draw is uniform over all the planes, and they can be many: a slab {−1, 1} of the mesh has thousands.

A plane need not be connected. A wall is a set *W ⊆ B* that separates *p* from *q*, induces a connected subgraph, and has no proper subset that does both. Under `Properties -> {"Separating", "Connected"}` a draw is a wall found by a greedy search: it starts from a connected separating piece of *B*, chosen at random, and removes one vertex at a time, chosen uniformly among those whose removal leaves a connected separating set, until none can go. It is fast and not uniform over the walls. With a count the walls are distinct, and `All` gives every wall, in time that can be exponential.

Options:

| Option | Default | Values |
|---|---|---|
| [Properties]() | `{"Separating"}` | the planes; `{"Separating", "Connected"}` the walls |
| `"NextVertexFunction"` | `Automatic` | `Automatic` random; `Identity` the first planes in sorted order, or the first wall of the search removing the first removable vertex |
| [RandomSeeding]() | `Automatic` | an integer or a string for a reproducible draw; `Inherited` to draw from the current random state |

## Basic Examples

The slab {−1, 1} of the centre and a vertex at distance 2, with a plane in it, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
    {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
    {slab = Select[VertexList[g], Abs[GraphDistance[g, p, #] - GraphDistance[g, q, #]] <= 1 &]},
    InfraSubstrateHighlight[g, {slab, RandomInfraPlane[g, InfraPlane[p, q, {-1, 1}], RandomSeeding -> 1], p, q}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

For a pair along an axis of the grid the plane is unique, the line of the equidistant vertices. The two ends of that line have one neighbour each and are not needed:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 3]},
  {planes = RandomInfraPlane[g, p, q, All]},
  InfraSubstrateHighlight[g, {Sequence @@ planes, p, q}, PlotLabel -> Length[planes], ImageSize -> Medium]]
```

Two planes of a diagonal pair:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {plane, p, q}], {plane, RandomInfraPlane[g, p, q, 2, RandomSeeding -> 1]}]]
```

## Scope

Three planes in the slab {−1, 1} on the mesh, which has 3885 planes:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {plane, p, q}],
    {plane, RandomInfraPlane[g, p, q, {-1, 1}, 3, RandomSeeding -> 1]}]]
```

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
  Length @ RandomInfraPlane[g, p, q, {-1, 1}, All]]
```

## Options

### Properties

Three walls in the slab {−1, 1} of two points at distance 3 on the grid, each connected:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 3], RandomSeeding -> 1]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {wall, p, q}, PlotLabel -> ConnectedGraphQ[Subgraph[g, wall]]],
    {wall, RandomInfraPlane[g, p, q, {-1, 1}, 3, Properties -> {"Separating", "Connected"}, RandomSeeding -> 1]}]]
```

For a diagonal pair on the grid there are planes but no wall:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
  {Length @ RandomInfraPlane[g, p, q, RandomSeeding -> 1], RandomInfraPlane[g, p, q, All, Properties -> {"Separating", "Connected"}]}]
```

## Properties and Relations

A plane separates *p* from *q*, and no vertex can be removed from it:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
  {plane = RandomInfraPlane[g, p, q, {-1, 1}, RandomSeeding -> 1]},
  {separatesQ = h |-> ! MemberQ[VertexComponent[VertexDelete[g, h], p], q]},
  {separatesQ[plane], NoneTrue[plane, separatesQ[DeleteCases[plane, #]] &], InfraPlaneQ[g, plane, p, q, 1]}]
```

## Possible Issues

On the grid two points at odd distance have no equidistant vertex, and so no plane in the slab {0, 0}:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 3], RandomSeeding -> 1]},
  {RandomInfraPlane[g, p, q], Count[VertexList[g], v_ /; GraphDistance[g, p, v] == GraphDistance[g, q, v]]}]
```

On the mesh the 17 equidistant vertices of these two points do not separate them, and the slab {0, 0} gives no plane:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
  {equidistant = Select[VertexList[g], GraphDistance[g, p, #] == GraphDistance[g, q, #] &]},
  {RandomInfraPlane[g, p, q, RandomSeeding -> 1], Length[equidistant],
   MemberQ[VertexComponent[VertexDelete[g, equidistant], p], q]}]
```
