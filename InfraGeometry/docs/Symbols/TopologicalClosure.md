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

Definition: *topo* is read as the preorder *q ≤ p* when *q = p* or a directed path leads from *q* to *p*. The closure of a vertex is its down-set, and the closure of a set is the union of the closures of its vertices.

For <code>[BallTopology]()[*g*, *r*]</code> the closure of a vertex *p* is *cl(p) = {q : B_r(p) ⊆ B_r(q)}*, the vertices whose ball contains the ball at *p*. It is the intersection of the balls of radius *r* that contain *p*, so it equals the ball hull <code>[InfraBallHull]()[{*p*}, {*r*}]</code>.

The closure contains *s*, the closure of the closure is the closure, and the closure of a union is the union of the closures. A set is closed when it equals its closure.

The result is a sorted vertex list.

## Basic Examples

The closure of a vertex of least degree on the rim, at radius 3, on the discretized plane, the square tiling and the hexagonal tiling. The vertex is blue; the rest of its closure, the vertices whose ball contains its ball, is red.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {corner = First @ MinimalBy[VertexList[g], VertexDegree[g, #] &]},
    {closure = TopologicalClosure[BallTopology[g, 3], {corner}]},
    InfraSubstrateHighlight[g, {Complement[closure, {corner}] -> StandardRed, corner -> StandardBlue}]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]
```

The closure of a corner of the square tiling grows with the radius, here from 1 to 4.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {corner = First @ Select[VertexList[g], VertexDegree[g, #] == 1 &]},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {Complement[TopologicalClosure[BallTopology[g, r], {corner}], {corner}] -> StandardRed, corner -> StandardBlue}],
    {r, 1, 4}]]
```

On a binary tree the closure of a leaf climbs its branch: radii 1, 2 and 3.

```wl
With[
  {g = KaryTree[31]},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {Complement[TopologicalClosure[BallTopology[g, r], {31}], {31}] -> StandardRed, 31 -> StandardBlue}],
    {r, 1, 3}]]
```

## Properties and Relations

The ring outside a ball about the centre is not closed: its closure adds the vertices of the ball whose ball contains the ball of a ring vertex. The closure of the closure is the closure.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {topo = BallTopology[g, 2]},
  {ring = Complement[VertexList[g], FindInfraRepresentative[g, InfraBall[First @ GraphCenter[g], 6]]]},
  {closure = TopologicalClosure[topo, ring]},
  {InfraSubstrateHighlight[g, {ring -> StandardBlue, Complement[closure, ring] -> StandardRed}],
   SubsetQ[closure, ring], TopologicalClosure[topo, closure] == closure}]
```

The closure of a vertex in the ball topology is its ball hull at the same radius.

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {corner = First @ MinimalBy[VertexList[g], VertexDegree[g, #] &]},
  {closure = TopologicalClosure[BallTopology[g, 3], {corner}]},
  {InfraSubstrateHighlight[g, {Complement[closure, {corner}] -> StandardRed, corner -> StandardBlue}],
   closure == FindInfraRepresentative[g, InfraBallHull[{corner}, {3}]]}]
```
