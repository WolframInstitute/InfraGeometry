---
Template: Symbol
Name: FindInfraHomotopyRepresentative
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraHomotopyRepresentative
Keywords: [homotopy class, shortest representative, reduced walk, geodesic in a homotopy class, fundamental group]
SeeAlso: [FindInfraHomotopyRepresentativeHomotopy, FindInfraHomotopy, HomotopicQ, NullHomotopicQ]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[FindInfraHomotopyRepresentative]()[*g*, *walk*]</code> gives certified shortest walks homotopic to *walk*, as walk graphs.

<code>[FindInfraHomotopyRepresentative]()[*g*, *walk*, *n*]</code> gives *n* of them.

## Details & Options

The homotopy class of a walk is the set of walks reached from it by the elementary moves of [HomotopicQ](). An open walk keeps its endpoints, a closed walk its base point. A result is returned only when minimal length is certified. Exact reduction in the face-free relation, a constant free path, or attainment of the metric lower bound can supply such a certificate.

There can be several shortest representatives, and a hole can prevent a walk from shrinking.

Face search obeys `"MaxLength"`, `"MaxMoves"` and `"MaxStates"`; exact reduction and free-endpoint constructions can bypass these search budgets. A minimum in a bounded search is not automatically a minimum of the full homotopy class: reaching a shorter walk may require a longer intermediate walk. Without a certificate the call remains unevaluated.

The count *n* can be `n`, `UpTo[n]` or `All`, the default. The options are those of [HomotopicQ](), including `Method -> Automatic` and `"MaxStates" -> 1000`. `All` returns a result only when completeness of the shortest-representative family is certified; otherwise the call remains unevaluated. `UpTo[n]` can return found certified minima without claiming the family is complete.

An exact integer count requires that many certified shortest representatives. A proved shortage gives `{}`; an unresolved shortage leaves the call unevaluated.

## Basic Examples

A triangle shortcut gives the unique shortest representative:

```wl
With[{g = CycleGraph[3]},
  Map[Last, VertexList /@ FindInfraHomotopyRepresentative[g, {1, 2, 3}], {2}]]
```

A square loop stays nontrivial when only triangles are filled. Declaring the square a face lets it contract:

```wl
With[{g = CycleGraph[4]},
  Table[Map[Last, VertexList /@ FindInfraHomotopyRepresentative[g, {1, 2, 3, 4, 1},
    "NullHomotopicCycles" -> k, "MaxLength" -> 5], {2}], {k, {3, 4}}]]
```

## Scope

With the square filled, its two shortest routes are both representatives. The search certifies the complete family:

```wl
With[{g = CycleGraph[4]},
  Map[Last, VertexList /@ FindInfraHomotopyRepresentative[g, {1, 2, 3}, All,
    "NullHomotopicCycles" -> 4, "MaxLength" -> 3], {2}]]
```

A backtrack reduces without any face relation:

```wl
With[{g = PathGraph[Range[3]]},
  Map[Last, VertexList /@ FindInfraHomotopyRepresentative[g, {1, 2, 3, 2}], {2}]]
```

## Properties and Relations

The last walk of a reduction chain is a shortest representative:

```wl
With[{g = CycleGraph[3]}, {walk = {1, 2, 3}},
  MemberQ[FindInfraHomotopyRepresentative[g, walk],
    Last @ FindInfraHomotopyRepresentativeHomotopy[g, walk]]]
```
