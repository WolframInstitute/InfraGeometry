---
Template: Symbol
Name: BranchingSequenceTree
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/BranchingSequenceTree
Keywords: [spherically symmetric tree, branching sequence, rooted tree, growth profile, volume growth]
SeeAlso: [BetheGraph, SierpinskiGraph, InfraShell, InfraSubstrate, CompleteKaryTree]
RelatedGuides: [InfraSubstrates]
---

## Usage

<code>[BranchingSequenceTree]()[{*b₁*, …, *bₙ*}]</code> gives the spherically symmetric rooted tree in which every vertex at depth *l* has *bₗ₊₁* children.

## Details & Options

The shell at depth *k* has *|Sₖ| = b₁ b₂ ⋯ bₖ* vertices, so the shell sizes are [FoldList]()[[Times](), 1, *b*]. The tree has *n* + 1 levels.

All vertices of a shell look alike: the sequence *b* is the growth profile of the balls about the root, and any profile can be realized.

A vertex is a pair {*l*, *p*}, its depth and its position in the shell; the root is {0, 1}. The children of {*l*, *p*} are {*l* + 1, (*p* − 1)*c* + 1}, …, {*l* + 1, *p c*}, with *c* = *bₗ₊₁*.

A constant sequence {*k*, …, *k*} gives the complete *k*-ary tree, and {*z*, *z* − 1, …, *z* − 1} the [BetheGraph]() of coordination number *z*. [Graph]() options are passed on.

## Basic Examples

The trees of three sequences, labelled with their shell sizes:

```wl
GraphicsRow @ Table[Graph[BranchingSequenceTree[b], PlotLabel -> FoldList[Times, 1, b]],
  {b, {{2, 2, 2, 2}, {3, 1, 2, 1, 2}, {4, 1, 1, 1}}}]
```

The shells about the root, each in its colour:

```wl
With[{g = BranchingSequenceTree[{3, 1, 2, 1, 2}]}, {shells = Table[InfraShell[{0, 1}, k], {k, 5}]},
  InfraSubstrateHighlight[g, shells, PlotLabel -> InfraMeasurement[g, shells, "CountingMeasure"], ImageSize -> Medium]]
```

## Scope

The vertices are pairs of depth and position:

```wl
BranchingSequenceTree[{2, 3}, VertexLabels -> Automatic]
```

## Properties and Relations

A constant sequence gives the complete tree, and {3, 2, 2, 2} the Bethe lattice with four shells:

```wl
{IsomorphicGraphQ[BranchingSequenceTree[{2, 2, 2}], CompleteKaryTree[4, 2]],
 IsomorphicGraphQ[BranchingSequenceTree[{3, 2, 2, 2}], BetheGraph[4, 3]]}
```

The substrate `"DilutedTreeGraph"` branches in two at the depths 0, 3, 8 and 15 and nowhere else. Its shell at depth *k* has *2ᵐ* vertices, *m = ⌊√k⌋*, so its balls grow faster than any polynomial and slower than any exponential:

```wl
With[{b = Table[If[IntegerQ @ Sqrt[l], 2, 1], {l, 16}]},
  {IsomorphicGraphQ[InfraSubstrate["DilutedTreeGraph", "Small", "Default"], BranchingSequenceTree[b]],
   Rest @ FoldList[Times, 1, b] == Table[2^Floor[Sqrt[k]], {k, 16}]}]
```
