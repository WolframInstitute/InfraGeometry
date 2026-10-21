---
Template: Symbol
Name: TopologicalClosure
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/TopologicalClosure
Keywords: [closure, ball topology, finite topology, down-set, specialization preorder, ball hull]
SeeAlso: [BallTopology, TopologicalInterior, TopologicalBoundary, TopologicalNeighborhood, InfraBallHull]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[TopologicalClosure]()[*topo*, *s*]</code> gives the closure of the vertex list *s* in the topology of the digraph *topo*: the vertices from which a directed path leads into *s*.

## Details & Options

The digraph *topo* is read as the preorder *q ≤ p* when *q = p* or a directed path leads from *q* to *p*. The closure of a vertex is its down-set *cl(p) = {q : q ≤ p}*, and the closure of a set is the union of the closures of its vertices.

In <code>[BallTopology]()[*g*, *r*]</code> the closure of a vertex is *cl(p) = {q : Bᵣ(p) ⊆ Bᵣ(q)}*, the intersection of the balls of radius *r* that contain *p*. It is the ball hull <code>[InfraBallHull]()[{*p*}, {*r*}]</code>.

The closure contains *s*. The closure of the closure is the closure, and the closure of a union is the union of the closures. A set is closed when it is its own closure.

On a patch of the grid a vertex far from the rim is closed.

The result is a sorted vertex list.

## Basic Examples

The closure of a vertex of least degree on the rim, at radius 3, on the square grid and on the square mesh. The closure is drawn with the vertex on top:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {v = First @ MinimalBy[VertexList[g], VertexDegree[g, #] &]},
    InfraSubstrateHighlight[g, {TopologicalClosure[BallTopology[g, 3], {v}], v}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The closure of that vertex of the grid grows with the radius, here from 1 to 4:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {v = First @ MinimalBy[VertexList[g], VertexDegree[g, #] &]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {TopologicalClosure[BallTopology[g, r], {v}], v}, PlotLabel -> r],
    {r, 1, 4}]]
```

## Scope

The closure of a set. The vertices of degree 1 on the grid are not closed at radius 2; their closure takes in the two rings next to them:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {ends = Select[VertexList[g], VertexDegree[g, #] == 1 &]},
  InfraSubstrateHighlight[g, {TopologicalClosure[BallTopology[g, 2], ends], ends}, ImageSize -> Medium]]
```

## Properties and Relations

The closure of a vertex in the ball topology is its ball hull at the same radius:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {v = First @ MinimalBy[VertexList[g], VertexDegree[g, #] &]},
  Table[TopologicalClosure[BallTopology[g, r], {v}] === Keys @ InfraMeasurement[g, InfraBallHull[{v}, {r}], "VertexDensity"],
    {r, 1, 5}]]
```

The closure is a closure operator: it contains the set, and the closure of the closure is the closure:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {topo = BallTopology[g, 2]},
  {s = Keys @ InfraMeasurement[g, InfraShell[First @ GraphCenter[g], 5], "VertexDensity"]},
  {cl = TopologicalClosure[topo, s]},
  {SubsetQ[cl, s], TopologicalClosure[topo, cl] === cl, Length[s], Length[cl]}]
```

Away from the rim every vertex is closed. The centre of the grid is its own closure at every radius up to 4:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Table[TopologicalClosure[BallTopology[g, r], {c}], {r, 1, 4}]]
```
