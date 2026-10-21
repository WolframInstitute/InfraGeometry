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

<code>[KillingDisplacementMagnitude]()[*g*]</code> gives the least magnitude of an automorphism of *g* other than the identity, and [Infinity]() when *g* has none.

## Details & Options

The value is *min {max_v d(v, σ(v)) : σ ≠ id an automorphism of g}*, with the minimum over the empty set *∞*. It is the magnitude of the displacements [FindKillingDisplacement]() gives.

A small value means a symmetry that moves every vertex a little, as the flow of a Killing field for a short time does. On a torus the translations by one step give 1. A graph with a rim has few symmetries, and a graph without symmetry gives [Infinity]().

The value is at most the diameter of a connected graph with a symmetry.

## Basic Examples

The square grid, the square mesh and the square torus. The least symmetry of the grid exchanges two pendant vertices; the mesh has none; the torus has the translations by one step:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    InfraSubstrateHighlight[g, {}, PlotLabel -> KillingDisplacementMagnitude[g]]],
  {name, {"SquareGridGraph", "SquareMeshGraph", "SquareTorusGraph"}}]
```

## Scope

A cycle has the rotations by one step:

```wl
KillingDisplacementMagnitude /@ {CycleGraph[5], CycleGraph[12]}
```

## Properties and Relations

The value is the magnitude of the least automorphism:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  KillingDisplacementMagnitude[g] == DisplacementMagnitude[g, FindKillingDisplacement[g]]]
```

Without its pendant vertices the grid is an 8 × 8 grid. Its least symmetries move some vertex 7 steps, half its diameter:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {core = VertexDelete[g, Select[VertexList[g], VertexDegree[g, #] == 1 &]]},
  {VertexCount[core], KillingDisplacementMagnitude[core], GraphDiameter[core]}]
```
