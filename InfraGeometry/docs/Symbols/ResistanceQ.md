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

<code>[ResistanceQ]()[*r*]</code> tests whether the symmetric matrix *r* with zero diagonal is of negative type, a condition every resistance distance matrix meets.

## Details & Options

Definition: [ResistanceQ]() gives [True]() when *r* is a square symmetric matrix with zero diagonal and the matrix *B*ᵢⱼ = (*r*₁ⱼ + *r*ᵢ₁ − *r*ᵢⱼ)/2, *i*, *j* ≥ 2, is positive semidefinite, its eigenvalues at least −10⁻⁹. Anything else gives [False]().

By a theorem of Schoenberg, *B* is positive semidefinite exactly when *r* is of negative type: *r*ᵢⱼ = ‖*x*ᵢ − *x*ⱼ‖² for some points *x*ᵢ of a Euclidean space. Every resistance matrix is of negative type, the points being its [ResistanceCoordinates](), so a matrix that fails is no resistance matrix.

The converse fails. A matrix *r* is the resistance matrix of a connected graph with nonnegative conductances exactly when, in addition, the matrix *L* = (−*P* *r* *P*/2)⁺, with *P* = *I* − *J*/*n* and *J* the matrix of ones, has rank *n* − 1 and no positive entry off the diagonal. *L* is then the Laplacian of that graph, and −*L*ᵢⱼ the conductance between *i* and *j*. [ResistanceQ]() does not test this.

## Basic Examples

The resistance matrices of the square, hexagonal and triangular tilings pass.

```wl
With[
  {graphs = InfraSubstrate[#, "Small", "KeepCoordinates" -> True] & /@ {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}},
  {GraphicsRow[graphs], ResistanceQ[EffectiveResistance[#]] & /@ graphs}]
```

On a tree the distances are the resistances, and the distance matrix passes. The distance matrices of the complete bipartite graph *K*₂,₃ and of the discretized plane are not of negative type, so they are no resistance matrices.

```wl
With[
  {graphs = {KaryTree[15], CompleteGraph[{2, 3}], InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}},
  {GraphicsRow[graphs], ResistanceQ[GraphDistanceMatrix[#]] & /@ graphs}]
```

## Properties and Relations

A resistance matrix determines its graph: the Laplacian recovered from it is [KirchhoffMatrix](), and the conductances it gives are the edges of the graph.

```wl
With[
  {g = PetersenGraph[]},
  {resistances = EffectiveResistance[g]},
  {laplacian = PseudoInverse[-(IdentityMatrix[10] - 1/10) . resistances . (IdentityMatrix[10] - 1/10)/2]},
  {AdjacencyGraph[Round[DiagonalMatrix[Diagonal[laplacian]] - laplacian]], ResistanceQ[resistances], Round[laplacian] === Normal[KirchhoffMatrix[g]]}]
```

## Possible Issues

Negative type is not enough. The distance matrix of the 5-cycle passes, but no graph with nonnegative conductances has it as its resistance matrix: the Laplacian it determines gives each of the five chords of the pentagon the conductance −2/5.

```wl
With[
  {hops = GraphDistanceMatrix[CycleGraph[5]]},
  {laplacian = PseudoInverse[-(IdentityMatrix[5] - 1/5) . hops . (IdentityMatrix[5] - 1/5)/2]},
  {MatrixPlot[DiagonalMatrix[Diagonal[laplacian]] - laplacian], ResistanceQ[hops], Union[Flatten[DiagonalMatrix[Diagonal[laplacian]] - laplacian]]}]
```

The distance matrix of the square tiling passes too, though the Laplacian it determines has 4276 positive entries off the diagonal.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {hops = N[GraphDistanceMatrix[g]]},
  {laplacian = PseudoInverse[-(IdentityMatrix[113] - 1/113) . hops . (IdentityMatrix[113] - 1/113)/2]},
  {MatrixPlot[DiagonalMatrix[Diagonal[laplacian]] - laplacian], ResistanceQ[hops], Count[Flatten[laplacian - DiagonalMatrix[Diagonal[laplacian]]], _?(# > 10^-9 &)]}]
```
