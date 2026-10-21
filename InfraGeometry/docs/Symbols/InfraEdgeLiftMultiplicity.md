---
Template: Symbol
Name: InfraEdgeLiftMultiplicity
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraEdgeLiftMultiplicity
Keywords: [edge lift, lift multiplicity, transverse neighbours, fibration, covering]
SeeAlso: [InfraFibrationQ, InfraAtMostOneEdgeLiftQ, InfraUniqueEdgeLiftingQ, InfraCoveringQ, InfraProjection, InfraFibers]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraEdgeLiftMultiplicity]()[*fib*]</code> gives, for each total vertex *x*, the association from each base neighbour *q* of *π(x)* to the number of neighbours of *x* over *q*.

## Details & Options

The multiplicity is *m(x, q) = |N(x) ∩ F(q)|*, for every *q* adjacent to *π(x)* in the base. It counts the lifts at *x* of the base edge *π(x) q*.

Zero counts are kept: a zero is a base edge with no lift at *x*. Vertical neighbours are not counted. A vertex over an isolated base vertex has an empty association.

The lifting conditions read off the multiplicities:

| All multiplicities | Predicate |
|---|---|
| at least 1 | [InfraFibrationQ]() |
| at most 1 | [InfraAtMostOneEdgeLiftQ]() |
| exactly 1 | [InfraUniqueEdgeLiftingQ]() |

When adjacent fibers are joined completely, *m(x, q)* is the size of the fiber over *q*.

## Basic Examples

The square grid projected to its columns. The vertices on the top and bottom rim have no neighbour in the next columns; drawn is the number of zero multiplicities at each vertex:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {fib = InfraFiberedGraph[g, AssociationThread[VertexList[g], Round @ GraphEmbedding[g][[All, 1]]]]},
  InfraSubstrateHighlight[g, {Count[#, 0] & /@ InfraEdgeLiftMultiplicity[fib]}, ImageSize -> Medium]]
```

Every other multiplicity is 1:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {fib = InfraFiberedGraph[g, AssociationThread[VertexList[g], Round @ GraphEmbedding[g][[All, 1]]]]},
  Counts @ Catenate[Values /@ Values @ InfraEdgeLiftMultiplicity[fib]]]
```

Two fibers joined by one edge. The vertices 2 and 4 have zero lifts:

```wl
InfraEdgeLiftMultiplicity @ InfraFiberedGraph[Graph[Range[4], {1 <-> 3}],
  <|1 -> "p", 2 -> "p", 3 -> "q", 4 -> "q"|>]
```

## Scope

In the displacement bundle of the square grid, the step from the centre to its upper neighbour has one lift backwards, two sideways and four forwards:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {m = InfraEdgeLiftMultiplicity[InfraDisplacementBundle[g, 1]][{c, c + 1}]},
  InfraSubstrateHighlight[g, {InfraWalk[{c, c + 1}], m}, PlotLabel -> m, ImageSize -> Medium]]
```

## Properties and Relations

The branched fibration joins adjacent fibers completely, so a multiplicity is the size of the neighbouring fiber, 1 or 2. All are positive, so it is a fibration:

```wl
With[{fib = InfraFiberedSubstrate["BranchedGridFibration", "Small"]}, {m = InfraEdgeLiftMultiplicity[fib]},
  {m[{1, 1}], m[{2, 1}], InfraFibrationQ[fib], InfraUniqueEdgeLiftingQ[fib]}]
```
