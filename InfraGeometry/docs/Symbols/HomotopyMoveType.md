---
Template: Symbol
Name: HomotopyMoveType
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/HomotopyMoveType
Keywords: [homotopy move, contraction, extension, lateral move, elementary move]
SeeAlso: [HomotopyMoveTypes, FindInfraHomotopy, FindInfraHomotopyRepresentativeHomotopy, HomotopicQ]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[HomotopyMoveType]()[*w1*, *w2*]</code> gives `"Contract"`, `"Extend"` or `"Lateral"` as the walk *w2* is shorter than, longer than or as long as the walk *w1*.

## Details & Options

The type compares the numbers of vertices of the two walks: `"Contract"` when *w2* has fewer, `"Extend"` when it has more, `"Lateral"` when they have the same number.

It is meant for one elementary move of a homotopy chain. Deleting a repeated vertex or a backtrack contracts, inserting one extends. A face move replaces an arc of *a* edges of a filled *k*-cycle by the other *k − a*: it is lateral exactly when *k = 2a*, so on a triangle it never is, and on a square of the grid swapping two sides is.

The walks can be vertex lists or walk graphs. Only the lengths are compared; nothing checks that *w2* is one move away from *w1*.

## Basic Examples

The three types:

```wl
{HomotopyMoveType[{1, 2, 3}, {1, 3}], HomotopyMoveType[{1, 3}, {1, 2, 3}], HomotopyMoveType[{1, 2, 3}, {1, 4, 3}]}
```

The move across a filled square of the grid swaps two sides of equal length, a lateral move:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {members = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], All]},
  HomotopyMoveType @@ FindInfraHomotopy[g, First @ members, Last @ members, "NullHomotopicCycles" -> 4]]
```

## Properties and Relations

On the mesh a move across a triangle changes the length. The two shortest paths around a pair of triangles are joined by an extension and a contraction:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {members = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], All]},
  {chain = FindInfraHomotopy[g, First @ members, Last @ members]},
  {HomotopyMoveType[chain[[1]], chain[[2]]], HomotopyMoveType[chain[[2]], chain[[3]]]}]
```
