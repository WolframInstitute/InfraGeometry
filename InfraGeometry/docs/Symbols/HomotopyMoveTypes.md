---
Template: Symbol
Name: HomotopyMoveTypes
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/HomotopyMoveTypes
Keywords: [homotopy chain, move types, contraction, extension, lateral move]
SeeAlso: [HomotopyMoveType, FindInfraHomotopy, FindInfraHomotopyRepresentativeHomotopy]
---

## Usage

<code>[HomotopyMoveTypes]()[{*w1*, *w2*, …, *wk*}]</code> gives the types <code>[HomotopyMoveType]()[*wi*, *wi+1*]</code> of the consecutive moves of a chain.

<code>[HomotopyMoveTypes]()[{*chain1*, *chain2*, …}]</code> gives the types for each chain.

## Details & Options

A chain of *k* walks gives *k − 1* types, each `"Contract"`, `"Extend"` or `"Lateral"`. The walks can be vertex lists or walk graphs; a list of chains of walk graphs is mapped over.

## Basic Examples

The chain between the two shortest paths around a pair of triangles of the mesh goes up and comes down:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {members = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], All]},
  HomotopyMoveTypes @ FindInfraHomotopy[g, First @ members, Last @ members]]
```

A chain of vertex lists:

```wl
HomotopyMoveTypes[{{1, 2, 1, 3}, {1, 3}, {1, 4, 3}, {1, 5, 3}}]
```

## Scope

A list of chains. With the squares of the grid filled, the two shortest paths across a square are joined by one lateral move, either way:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {members = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], All]},
  {a = First @ members, b = Last @ members},
  HomotopyMoveTypes[{FindInfraHomotopy[g, a, b, "NullHomotopicCycles" -> 4], FindInfraHomotopy[g, b, a, "NullHomotopicCycles" -> 4]}]]
```
