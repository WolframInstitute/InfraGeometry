---
Template: Symbol
Name: InfraCircle
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraCircle
Keywords: [circle, radius, band, separating cycle, unrolled band, atom, necklace, seam, symbolic object]
SeeAlso: [InfraArc, InfraMeasurement, RandomInfraRepresentative, Undetermined, InfraShell, FindInfraShell]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraCircle]()[*c*, *r*]</code> is the family of circles around *c* at radius *r*. It is a symbolic object; [InfraMeasurement]() and [RandomInfraRepresentative]() evaluate it on a graph.

<code>[InfraCircle]()[*c*, {*r*, *s*}]</code> is the family in the band *r* ≤ *d(c, v)* ≤ *s*; a scalar *r* means `{r, r}`.

The same expression inside an [InfraScene]() is the circle construction token.

## Details & Options

Definition: a circle of the band *W* around *c* is a shortest cycle of the subgraph induced on *W* whose removal leaves *c* in a component that reaches no further than the band.

The second argument is always a radius or a band, never a point, so a vertex label that is an integer or a pair cannot be mistaken for one. There are no options.

Euclid's third postulate describes a circle with any centre and distance: the circle is named by its radius. The circle through a point *p* is drawn by a compass opened to *p*, an arc that closes: it is the closed arc <code>[InfraArc]()[*c*, {*p*, *p*}]</code>, the circles of the band of *p* that pass through *p*.

**A circle need not exist.** On a lattice a single distance shell has no two adjacent vertices, so it spans no cycle and the family is empty. This is what a sphere of one-vertex thickness is on a lattice, not a defect of the definition.

Widening the radius to a band fixes it, and **the band thickness that suffices tracks the girth of the tiling**. On the square tiling, girth 4, the band `{r, r + 1}` already carries a circle. On the hexagonal tiling, girth 6, it does not: the band has to reach `{r, r + 2}`. On the triangular tiling, girth 3, a single shell carries a circle; on an irregular mesh it usually does, its vertices being adjacent by accident of the mesh.

Its graph — <code>[InfraMeasurement]()[*g*, *circle*, "Graph"]</code> — is a `List` of **atoms** of the unrolled band. The band is cut along a radial seam, the band part of a shortest path from *c* to the nearest vertex outside the band, and unrolled: the circles through a seam vertex *x* are the shortest paths of the cyclic cover of the band from *x* to a second copy of *x*. An atom is the DAG of those paths for one seam vertex, with the earlier seam vertices removed, so every circle lies in exactly one atom, at its first seam vertex. Only the atoms of least length are kept: an atom at a seam vertex that no shortest circle meets carries longer closed walks only. The atom is projected to the vertices of the graph, and its sink is kept as the separate vertex `{x, 3/2}`, a copy of its source *x*. So the atom is acyclic, its chains from *x* to `{x, 3/2}` are the circles read as closed walks, and its `"Cardinality"` and `"Length"` are the chain count and the length of the circle.

The two sides of the seam are told apart by separation alone: two neighbours of a seam vertex lie on the same side iff the cycle through them and the cut band does not separate. No coordinates enter, and a circle may meet the seam any number of times.

The atoms need the cut band to be connected and the two sides to occur on the seam. Where the cut band is disconnected, or the seam has one side only, the graph is a `List` of **necklaces** instead, cut from the band along the same seam: a DAG with one source *s1* and one sink, a copy `{s1, 3/2}` of its source, again the cycle family opened at its closing arrow. A necklace needs the circle to meet the seam in one run, so it can miss a circle.

A member is a chain of the graph read as a cyclic vertex list: the copy of the source is dropped and the first vertex is not repeated. The `"Length"` of a circle of *k* vertices is *k*.

**The search.** <code>[RandomInfraRepresentative]()[*g*, *circle*, *n*]</code> sweeps the band directly: for *k* = 3, 4, … it takes every cycle of length *k* of the band (`FindCycle`) and keeps those whose removal leaves *c* in a component reaching no further than the band; the first *k* with a survivor gives the members. It does not read the graph, so it is the check on it, and it still answers where nothing lies beyond the band and separation is vacuous. Each length is enumerated in full before the filter, so the sweep is fast on a band one or two vertices thick and does not finish in reasonable time on a wide one, such as `{3, 6}` on the square tiling.

Every member separates. That the atoms carry every circle exactly once needs the winding functional, an invariant of the substrate that is nonzero exactly on the separating cycles, and a connected cut band; nothing here certifies the first. So `"Faithful"` is [Undetermined](), except that it is `False` where the cut band is connected and the seam has one side only: there the winding functional or the annulus is witnessed to fail.

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Postulate 3 | To draw a circle with any center and radius. |
| Hilbert | (not primitive) | Circles are defined from congruence, not postulated. |
| Tarski | Equidistance | The locus of points equidistant from a centre, from the four-place congruence relation. |
| Birkhoff | Ruler postulate | The locus at fixed ruler distance from a point. |

## Basic Examples

The circles of the band `{2, 4}` about the centre, on the square, hexagonal and triangular tilings. An edge is drawn as strongly as the number of circles through it.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = First @ GraphCenter[g]},
    {circle = InfraCircle[c, {2, 4}]},
    InfraSubstrateHighlight[g, {circle, c}]],
  {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]
```

The band `{2, 4}` on the square tiling: the number of circles, their length and the number of atoms carrying them, beside the picture.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {circle = InfraCircle[c, {2, 4}]},
  {InfraSubstrateHighlight[g, {circle, c}],
   InfraMeasurement[g, circle, "Cardinality"], InfraMeasurement[g, circle, "Length"],
   Length @ InfraMeasurement[g, circle, "Graph"]}]
```

At a single radius the circle exists on the irregular mesh and not on the two lattices: their shell has no two adjacent vertices. Each picture shows the shell and the circles found in it, labelled by their number.

```wl
SeedRandom[1];
Row @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = First @ GraphCenter[g]},
    {circles = RandomInfraRepresentative[g, InfraCircle[c, 4], All]},
    Labeled[
      InfraSubstrateHighlight[g,
        {FindInfraShell[g, c, 4],
         Table[Graph[DirectedEdge @@@ Partition[oneCircle, 2, 1, 1]], {oneCircle, circles}]}],
      Length @ circles]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]
```

The thickness needed follows the girth: on the hexagonal tiling the band `{4, 5}` is still empty, and `{4, 6}` carries the circles.

```wl
SeedRandom[1];
Row @ Table[
  With[
    {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
    {c = First @ GraphCenter[g]},
    {circles = RandomInfraRepresentative[g, InfraCircle[c, band], All]},
    Labeled[
      InfraSubstrateHighlight[g,
        {FindInfraShell[g, c, band],
         Table[Graph[DirectedEdge @@@ Partition[oneCircle, 2, 1, 1]], {oneCircle, circles}]}],
      Length @ circles]],
  {band, {4, {4, 5}, {4, 6}}}]
```

One circle about the centre of each lattice, at the band each one needs, drawn as its directed cycle.

```wl
SeedRandom[1];
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[First @ spec, "Small", "KeepCoordinates" -> True]},
    {c = First @ GraphCenter[g]},
    {oneCircle = RandomInfraRepresentative[g, InfraCircle[c, Last @ spec]]},
    InfraSubstrateHighlight[g, {Graph[DirectedEdge @@@ Partition[oneCircle, 2, 1, 1]], c},
      "Arrowheads" -> True]],
  {spec, {{"SquareTilingGraph", {4, 5}}, {"HexagonalTilingGraph", {4, 6}}, {"TriangularTilingGraph", 4}}}]
```

A member is a cyclic vertex list. Drawn as a walk, it closes back on its first vertex.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {closedWalk = RandomInfraRepresentative[g, InfraCircle[c, {2, 4}]]},
  InfraSubstrateHighlight[g, {InfraWalk[Append[closedWalk, First @ closedWalk]], c}]]
```

The circles of the band `{4, 5}` that pass through a vertex at distance 4 are the closed arc through it, [InfraArc]().

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[c, 4]])},
  {circle = InfraArc[c, {p, p}, "RadiusDelta" -> 1]},
  {InfraSubstrateHighlight[g, {circle, c, p}],
   InfraMeasurement[g, circle, "Cardinality"], InfraMeasurement[g, circle, "Length"]}]
```

## Scope

Every circle of the band `{2, 4}` on the square tiling, drawn at once. A bounded count gives a list, and a strict count that cannot be met gives `{ }`.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {circle = InfraCircle[c, {2, 4}]},
  {circles = RandomInfraRepresentative[g, circle, All]},
  {InfraSubstrateHighlight[g, {Table[Graph[DirectedEdge @@@ Partition[oneCircle, 2, 1, 1]], {oneCircle, circles}]}],
   Length @ circles, Length @ RandomInfraRepresentative[g, circle, 3], RandomInfraRepresentative[g, circle, 20]}]
```

## Properties and Relations

A circle lies in its band, and consecutive vertices are adjacent, the last and the first too.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {band = FindInfraShell[g, c, {2, 4}]},
  {closedWalk = RandomInfraRepresentative[g, InfraCircle[c, {2, 4}]]},
  {InfraSubstrateHighlight[g, {band, InfraWalk[Append[closedWalk, First @ closedWalk]]}],
   SubsetQ[band, closedWalk], AllTrue[Partition[closedWalk, 2, 1, 1], EdgeQ[g, UndirectedEdge @@ #] &]}]
```

The search sweeps the band directly and finds as many circles as the atoms carry.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {circle = InfraCircle[c, {2, 4}]},
  {InfraSubstrateHighlight[g, {circle, c}],
   InfraMeasurement[g, circle, "Cardinality"], Length @ RandomInfraRepresentative[g, circle, All]}]
```

An atom is acyclic: its chains run from the seam vertex *x* to the copy `{x, 3/2}` of it, the circles through *x* opened at *x*.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {atom = First @ InfraMeasurement[g, InfraCircle[c, {2, 4}], "Graph"]},
  {InfraSubstrateHighlight[g, {atom, c}, "Arrowheads" -> True],
   AcyclicGraphQ[atom], Select[VertexList[atom], VertexInDegree[atom, #] == 0 &],
   Select[VertexList[atom], VertexOutDegree[atom, #] == 0 &]}]
```
