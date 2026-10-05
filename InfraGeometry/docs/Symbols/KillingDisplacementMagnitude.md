---
Template: Symbol
Name: KillingDisplacementMagnitude
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/KillingDisplacementMagnitude
Keywords: [displacement, Killing field, automorphism, symmetry, magnitude, asymmetric graph]
SeeAlso: [FindKillingDisplacement, DisplacementMagnitude, DisplacementIsomorphismQ]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[KillingDisplacementMagnitude]()[*g*]</code> gives the least magnitude of an automorphism of *g* other than the identity, and [Infinity]() when *g* has no such automorphism.

## Details & Options

Definition: *min { max_v d(v, σ(v)) : σ an automorphism of g, σ ≠ id }*, the minimum over an empty set being *∞*. It is the magnitude of the displacements [FindKillingDisplacement]() gives.

A small value means a symmetry that moves every vertex little, as a Killing field of small flow time does. On a cycle or a torus, whose translations by one step are automorphisms, it is 1. On a finite patch of a tiling the automorphisms are the symmetries of the patch, which move its rim far, so the value is large: the diameter on the square and the hexagonal tilings. A graph without symmetry gives [Infinity]().

## Basic Examples

The least magnitude of a symmetry on the discretized plane, the square, the triangular and the hexagonal tilings. The discretized plane has no symmetry.

```wl
With[
  {graphs = InfraSubstrate[#, "Small", "KeepCoordinates" -> True] & /@ {"SquareMeshGraph", "SquareTilingGraph", "TriangularTilingGraph", "HexagonalTilingGraph"}},
  {GraphicsRow[graphs], KillingDisplacementMagnitude /@ graphs}]
```

## Scope

A cycle and a torus have the translations by one step.

```wl
With[
  {cycle = CycleGraph[12], torus = InfraSubstrate["SquareTorusGraph", "Small"]},
  {GraphicsRow[{DisplacementPlot[cycle, FindKillingDisplacement[cycle]], DisplacementPlot[torus, FindKillingDisplacement[torus]]}],
   KillingDisplacementMagnitude /@ {cycle, torus}}]
```

## Properties and Relations

The value is the magnitude of the least automorphism, which [FindKillingDisplacement]() gives.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {killing = FindKillingDisplacement[g]},
  {DisplacementPlot[g, killing], KillingDisplacementMagnitude[g] == DisplacementMagnitude[g, killing]}]
```

The value is at most the diameter of a connected graph with a symmetry. On the patches of the square and the hexagonal tilings every symmetry moves some vertex across the patch.

```wl
With[
  {graphs = InfraSubstrate[#, "Small", "KeepCoordinates" -> True] & /@ {"SquareTilingGraph", "HexagonalTilingGraph"}},
  {GraphicsRow[DisplacementPlot[#, FindKillingDisplacement[#]] & /@ graphs], {KillingDisplacementMagnitude[#], GraphDiameter[#]} & /@ graphs}]
```
