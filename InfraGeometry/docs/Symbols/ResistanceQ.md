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

<code>[ResistanceQ]()[*r*]</code> tests whether the numeric matrix *r* is the resistance distance matrix of a connected graph with nonnegative conductances.

## Details & Options

Definition: [ResistanceQ]() gives [True]() when *r* is a square numeric matrix, symmetric with zero diagonal, and the matrix *B* = −*P* *r* *P*/2, with *P* = *I* − *J*/*n* and *J* the matrix of ones, has *n* − 1 eigenvalues above 10⁻⁹, the rest being zero, and its pseudoinverse *L* = *B*⁺ has no entry above 10⁻⁹ off the diagonal. Anything else gives [False](), an [Infinity]() entry included.

*L* is then the Laplacian of the graph, and −*L*ᵢⱼ the conductance between *i* and *j*. The graph is connected because *B* has rank *n* − 1, and its conductances are nonnegative because *L* has no positive entry off the diagonal.

The eigenvalue condition implies that *r* is of negative type: *r*ᵢⱼ = ‖*x*ᵢ − *x*ⱼ‖² for some points *x*ᵢ of a Euclidean space, by a theorem of Schoenberg. Every resistance matrix is of negative type, the points being its [ResistanceCoordinates](). That is necessary and not sufficient: the second condition rejects the distance matrices of the cycles and of the square tiling, which are of negative type.

## Basic Examples

The resistance matrices of the square, hexagonal and triangular tilings pass.

```wl
With[
  {graphs = InfraSubstrate[#, "Small", "KeepCoordinates" -> True] & /@ {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}},
  {GraphicsRow[graphs], ResistanceQ[EffectiveResistance[#]] & /@ graphs}]
```

On a tree the distances are the resistances, and the distance matrix passes. The distance matrices of the complete bipartite graph *K*₂,₃ and of the discretized plane fail.

```wl
With[
  {graphs = {KaryTree[15], CompleteGraph[{2, 3}], InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}},
  {GraphicsRow[graphs], ResistanceQ[GraphDistanceMatrix[#]] & /@ graphs}]
```

## Scope

The distance matrices of the cycles are not resistance matrices, though they are of negative type. The Laplacian that the distance matrix of the 5-cycle determines gives each of the five chords of the pentagon the conductance −2/5, a negative one, and that of the 4-cycle has rank 2 instead of 3. The resistance matrix of the 5-cycle passes.

```wl
With[
  {hops = GraphDistanceMatrix[CycleGraph[5]]},
  {laplacian = PseudoInverse[-(IdentityMatrix[5] - 1/5) . hops . (IdentityMatrix[5] - 1/5)/2]},
  {MatrixPlot[DiagonalMatrix[Diagonal[laplacian]] - laplacian], ResistanceQ /@ {hops, GraphDistanceMatrix[CycleGraph[4]], EffectiveResistance[CycleGraph[5]]}, Union[Flatten[DiagonalMatrix[Diagonal[laplacian]] - laplacian]]}]
```

The distance matrix of the square tiling fails too: the Laplacian it determines has 4276 positive entries off the diagonal. The squared distances of three collinear points break the triangle inequality, which every resistance distance obeys.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {hops = N[GraphDistanceMatrix[g]]},
  {laplacian = PseudoInverse[-(IdentityMatrix[113] - 1/113) . hops . (IdentityMatrix[113] - 1/113)/2]},
  {MatrixPlot[DiagonalMatrix[Diagonal[laplacian]] - laplacian], ResistanceQ[hops], Count[Flatten[laplacian - DiagonalMatrix[Diagonal[laplacian]]], _?(# > 10^-9 &)],
   ResistanceQ[{{0, 1, 4}, {1, 0, 1}, {4, 1, 0}}]}]
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

A matrix with an infinite entry is no resistance matrix of a connected graph. The resistances of a graph with two components are [Infinity]() between them, and [ResistanceQ]() gives [False]() on the matrix.

```wl
With[
  {g = GraphUnion[PathGraph[{1, 2, 3}], PathGraph[{4, 5}]]},
  {g, MatrixPlot[EffectiveResistance[g] /. Infinity -> 3], ResistanceQ[EffectiveResistance[g]]}]
```
