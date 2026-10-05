---
Template: Symbol
Name: DisplacementIsomorphismQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/DisplacementIsomorphismQ
Keywords: [displacement, automorphism, isometry, Killing field, symmetry]
SeeAlso: [DisplacementBijectionQ, ContinuousDisplacementQ, FindKillingDisplacement, KillingDisplacementMagnitude, DisplacementCommutator]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[DisplacementIsomorphismQ]()[*g*, *d*]</code> gives [True]() when the displacement *d* is an automorphism of *g*, a discrete Killing displacement, and [False]() otherwise.

## Details & Options

Definition: *D* is an automorphism when it is a bijection ([DisplacementBijectionQ]()) and the images of the ends of every edge of *g* are joined by an edge. On a finite graph such a bijection also maps non-edges to non-edges, so it is an isometry of the graph metric: the discrete counterpart of the flow of a Killing field.

A bijection that is 1-continuous ([ContinuousDisplacementQ]()) is an automorphism. It does not increase any distance, and it permutes the pairs of vertices, so the total of all distances stays the same; hence every distance stays the same.

The automorphisms of *g* form a group: composites, inverses and commutators of automorphisms are automorphisms. [FindKillingDisplacement]() gives those of least magnitude.

## Basic Examples

The least symmetry of the square, the triangular and the hexagonal tilings is an automorphism.

```wl
With[
  {graphs = InfraSubstrate[#, "Small", "KeepCoordinates" -> True] & /@ {"SquareTilingGraph", "TriangularTilingGraph", "HexagonalTilingGraph"}},
  {GraphicsRow[DisplacementPlot[#, FindKillingDisplacement[#]] & /@ graphs], DisplacementIsomorphismQ[#, FindKillingDisplacement[#]] & /@ graphs}]
```

Exchanging the two ends of one edge of the 12-cycle is a bijection of magnitude 1, but not an automorphism: it sends the edge from 12 to 1 to the vertices 12 and 2, two steps apart.

```wl
With[
  {g = CycleGraph[12]},
  {swap = Join[AssociationMap[List, VertexList[g]], <|1 -> {2}, 2 -> {1}|>]},
  {DisplacementPlot[g, swap], DisplacementBijectionQ[swap], DisplacementIsomorphismQ[g, swap]}]
```

## Properties and Relations

A translation of a finite patch is not an automorphism: at the rim it is not a bijection.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {translation = TranslationDisplacement[g, {3/2, Sqrt[3]/2}]},
  {DisplacementPlot[g, translation], DisplacementBijectionQ[translation], DisplacementIsomorphismQ[g, translation]}]
```

The commutator of two automorphisms is an automorphism. On the 12-cycle the rotation and a reflection give the rotation by two steps.

```wl
With[
  {g = CycleGraph[12]},
  {rotation = FindKillingDisplacement[g], reflection = AssociationMap[{Mod[2 - #, 12, 1]} &, VertexList[g]]},
  {loop = DisplacementCommutator[g, rotation, reflection]},
  {DisplacementPlot[g, loop], DisplacementIsomorphismQ[g, #] & /@ {rotation, reflection, loop}}]
```

The 1-continuous bijections of the hexagon are its 12 automorphisms.

```wl
With[
  {g = CycleGraph[6]},
  {bijections = AssociationThread[Range[6], List /@ #] & /@ Permutations[Range[6]]},
  {automorphisms = Select[bijections, DisplacementIsomorphismQ[g, #] &]},
  {GraphicsGrid[Partition[DisplacementPlot[g, #] & /@ automorphisms, 6]], Length[automorphisms], automorphisms === Select[bijections, ContinuousDisplacementQ[g, #] &]}]
```
