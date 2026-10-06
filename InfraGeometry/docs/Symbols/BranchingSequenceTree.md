---
Template: Symbol
Name: BranchingSequenceTree
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/BranchingSequenceTree
Keywords: [spherically symmetric tree, branching sequence, rooted tree, growth profile, volume growth]
SeeAlso: [BetheGraph, SierpinskiGraph, FindInfraShell, InfraSubstrate]
RelatedGuides: [InfraSubstrates]
---

## Usage

<code>[BranchingSequenceTree]()[*b*]</code> gives the rooted tree in which every vertex at depth *l* has *b*⟦*l* + 1⟧ children.

## Details & Options

The tree is spherically symmetric: all vertices at one depth have the same number of children, so the tree looks the same from every vertex of a shell. It has [Length]()[*b*] + 1 levels, and the shell at depth *k* has *b*₁ *b*₂ ⋯ *b*ₖ vertices, the list [FoldList]()[[Times](), 1, *b*]. The sequence *b* is the growth profile of the balls about the root.

A vertex is a pair {*l*, *p*}, its depth and its position in the shell; the root is {0, 1}. The children of {*l*, *p*} are {*l* + 1, (*p* − 1) *c* + 1}, …, {*l* + 1, *p c*}, *c* = *b*⟦*l* + 1⟧.

A constant sequence gives a complete tree, as [CompleteKaryTree](). [BetheGraph]() fixes the degree of every vertex instead of the number of children.

[Graph]() options are passed on to the graph.

## Basic Examples

The trees of the sequences {2, 2, 2, 2}, {3, 1, 2, 1, 2} and {4, 1, 1, 1}, and their shell sizes.

```wl
With[
  {sequences = {{2, 2, 2, 2}, {3, 1, 2, 1, 2}, {4, 1, 1, 1}}},
  {GraphicsRow[BranchingSequenceTree /@ sequences], FoldList[Times, 1, #] & /@ sequences}]
```

## Scope

The vertices are pairs of depth and position.

```wl
BranchingSequenceTree[{2, 3}, VertexLabels -> Automatic]
```

## Properties and Relations

The shells about the root, each in its colour, have the sizes [FoldList]()[[Times](), 1, *b*].

```wl
With[
  {b = {3, 1, 2, 1, 2}},
  {g = BranchingSequenceTree[b]},
  {shells = Table[FindInfraShell[g, {0, 1}, k], {k, Length[b]}]},
  {InfraSubstrateHighlight[g, shells], Length /@ shells == Rest @ FoldList[Times, 1, b]}]
```

A constant sequence gives the complete tree.

```wl
With[
  {g = BranchingSequenceTree[{2, 2, 2}]},
  {g, IsomorphicGraphQ[g, CompleteKaryTree[4, 2]]}]
```

The substrate `"DilutedTreeGraph"` of [InfraSubstrate]() is the tree in which a vertex has two children at the depths 0, 3, 8 and 15, one less than the squares, and one child elsewhere. Its shell at depth *k* has 2^⌊√*k*⌋ vertices, so its balls grow more slowly than any exponential.

```wl
With[
  {g = InfraSubstrate["DilutedTreeGraph", "Small", "Default"]},
  {g, IsomorphicGraphQ[g, BranchingSequenceTree[Table[If[MemberQ[{1, 4, 9, 16}, level], 2, 1], {level, 16}]]]}]
```
