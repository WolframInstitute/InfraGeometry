---
Template: Symbol
Name: ResistanceQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/ResistanceQ
Keywords: [resistance distance, negative type, Schoenberg, squared Euclidean distance, Gram matrix, Klein-Randic]
SeeAlso: [EffectiveResistance, ResistanceCoordinates]
RelatedGuides: [Experimental]
---

## Usage

<code>[ResistanceQ]()[*r*]</code> tests whether the numeric matrix *r* is the effective resistance matrix of a connected graph with nonnegative conductances.

## Details & Options

Let *P = I − J/n*, with *J* the matrix of ones, and *B = −P r P/2*. The symmetric matrix *r* with zero diagonal is a resistance matrix exactly when *B* is positive semidefinite of rank *n − 1* and *L = B⁺* has no positive entry off the diagonal. Then *L* is the Laplacian of the graph and *−Lᵢⱼ* the conductance between *i* and *j*. So a resistance matrix determines its graph.

The rank condition says that *r* is of negative type: *rᵢⱼ = ‖xᵢ − xⱼ‖²* for points *xᵢ* of a Euclidean space (Schoenberg), the points being the [ResistanceCoordinates](). Negative type alone is not enough: the distance matrix of a cycle is of negative type and not a resistance matrix.

Each test has the tolerance 10⁻⁹: an asymmetry or a diagonal entry up to 10⁻⁹ counts as 0, as in a computed resistance matrix. A matrix with an [Infinity]() entry gives [False]().

On a tree the distance matrix is the resistance matrix.

## Basic Examples

The resistance matrix of the square mesh passes, its distance matrix does not:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]},
  GraphicsRow @ Table[ArrayPlot[m, PlotLabel -> ResistanceQ[m]],
    {m, {EffectiveResistance[g], GraphDistanceMatrix[g]}}]]
```

On a tree the distances are the resistances, and the distance matrix passes:

```wl
With[{g = KaryTree[15]},
  {ResistanceQ[GraphDistanceMatrix[g]], Max @ Abs[EffectiveResistance[g] - GraphDistanceMatrix[g]] < 10^-9}]
```

## Scope

The distance matrices of the cycles of length 4 and more fail; their resistance matrices pass:

```wl
{Table[ResistanceQ[GraphDistanceMatrix[CycleGraph[n]]], {n, 3, 8}],
 Table[ResistanceQ[EffectiveResistance[CycleGraph[n]]], {n, 3, 8}]}
```

The matrix *L* that the distance matrix of the 5-cycle determines gives each edge the conductance 8/5 and each chord the negative conductance −2/5:

```wl
With[{r = GraphDistanceMatrix[CycleGraph[5]]}, {p = IdentityMatrix[5] - 1/5},
  MatrixForm @ PseudoInverse[-p . r . p/2]]
```

The computed resistance matrix of the square grid is symmetric only up to rounding, and passes:

```wl
With[{r = EffectiveResistance[InfraSubstrate["SquareGridGraph", "Small"]]}, {Max @ Abs[r - Transpose[r]], ResistanceQ[r]}]
```

## Properties and Relations

A resistance matrix determines its graph: the matrix *L* recovered from the resistances of the mesh is its [KirchhoffMatrix]():

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {r = EffectiveResistance[g], n = VertexCount[g]},
  {p = IdentityMatrix[n] - 1/n}, {laplacian = PseudoInverse[-p . r . p/2]},
  Max @ Abs[laplacian - KirchhoffMatrix[g]] < 10^-9]
```

## Possible Issues

The squared distances of three points on a line are of negative type, but they break the triangle inequality, which resistances obey:

```wl
ResistanceQ[{{0, 1, 4}, {1, 0, 1}, {4, 1, 0}}]
```

A matrix with an infinite entry gives [False](). Between the components of a graph the resistance is [Infinity]():

```wl
ResistanceQ @ EffectiveResistance[GraphUnion[PathGraph[{1, 2, 3}], PathGraph[{4, 5}]]]
```
