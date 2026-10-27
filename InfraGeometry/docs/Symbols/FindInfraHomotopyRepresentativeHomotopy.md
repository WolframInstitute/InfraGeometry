---
Template: Symbol
Name: FindInfraHomotopyRepresentativeHomotopy
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraHomotopyRepresentativeHomotopy
Keywords: [homotopy, reduction, shortest representative, chain of moves, contraction]
SeeAlso: [FindInfraHomotopyRepresentative, FindInfraHomotopy, HomotopyMoveTypes, HomotopicQ]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[FindInfraHomotopyRepresentativeHomotopy]()[*g*, *walk*]</code> gives a chain of elementary moves from *walk* to a certified shortest walk homotopic to it, as the list of walk graphs it passes through.

<code>[FindInfraHomotopyRepresentativeHomotopy]()[*g*, *walk*, *n*]</code> gives a list of *n* chains, one for each shortest walk reached.

## Details & Options

The chain consists of moves of [HomotopicQ]() from *walk* to a certified shortest representative from [FindInfraHomotopyRepresentative](). Its first walk is *walk*, its last a representative. The default method does not promise the fewest moves.

Face search obeys `"MaxLength"`, `"MaxMoves"` and `"MaxStates"`; exact reduction and free-endpoint constructions can bypass these search budgets. A bounded search minimum is not a certificate of global minimality. If minimality cannot be certified, the call remains unevaluated.

The count *n* can be `n`, `UpTo[n]` or `All`. Without a count the result is one chain. The options are those of [HomotopicQ](), with `Method -> Automatic` and `"MaxStates" -> 1000`. `All` requires certification that every shortest representative has been found, and returns one chain per representative. It does not enumerate every chain to each representative. An unresolved completeness question leaves the call unevaluated.

An exact integer count requires that many certified shortest representatives. A proved shortage gives `{}`; an unresolved shortage leaves the call unevaluated.

## Basic Examples

The loop around a filled triangle contracts to its base point:

```wl
With[{g = CycleGraph[3]},
  Map[Last, VertexList /@ FindInfraHomotopyRepresentativeHomotopy[g, {1, 2, 3, 1}], {2}]]
```

Read the length-change types of the moves:

```wl
With[{g = CycleGraph[3]},
  HomotopyMoveTypes @ FindInfraHomotopyRepresentativeHomotopy[g, {1, 2, 3, 1}]]
```

## Scope

Filling a square lets its boundary contract:

```wl
With[{g = CycleGraph[4]},
  Map[Last, VertexList /@ FindInfraHomotopyRepresentativeHomotopy[g, {1, 2, 3, 4, 1},
    "NullHomotopicCycles" -> 4, "MaxLength" -> 5], {2}]]
```

## Properties and Relations

A walk that is already shortest gives the chain of that walk alone:

```wl
With[{g = CycleGraph[3]},
  Map[Last, VertexList /@ FindInfraHomotopyRepresentativeHomotopy[g, {1, 2}], {2}]]
```
