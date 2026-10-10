---
Template: Symbol
Name: FindInfraPerpendicular
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraPerpendicular
Keywords: [perpendicular, Euclid I.12, foot, right angle, radius]
SeeAlso: [InfraPerpendicularQ, RandomInfraParallel, RandomInfraLine, FindClosestInfraPoint, InfraAngle]
RelatedGuides: [Experimental]
---

## Usage

<code>[FindInfraPerpendicular]()[*g*, *line*, *point*]</code> gives the lines through *point* perpendicular to *line*, as a `List` of directed path graphs.

A count *n* gives exactly *n* or `$Failed`; `UpTo[n]` up to *n*; `All` all of them.

## Details & Options

Definition, with the default `Method -> "Metric"`: this is Euclid I.12. Take an isosceles base on the line, find its midpoint — the foot — and return the maximal lines through the foot and the point.

Two consequences follow from that construction.

It returns nothing when *point* lies **on** *line*. The construction needs a foot distinct from the point, and there is none. Erecting a perpendicular at a point of the line is Euclid I.11, a different proposition.

The count is very large. On an 81-vertex square patch, a point off a line admits 6381 perpendiculars. This is the same combinatorial explosion as [RandomInfraLine](), and it has the same cause: a maximal shortest path on a lattice has many admissible continuations.

Option `"Radius"` is the lever that makes it usable. `"Radius" -> r` localises both the candidate enumeration and the test to the *r*-neighbourhood of the point. On that same patch the count falls to 110 at radius 3 and 26 at radius 2. Perpendicularity is a local notion, so localising it is not a compromise.

Option `Method` also takes the `Q`-side families — `"Projection"`, `"Coordinate"`, `"Arclength"`, `"Alexandrov"` — which enumerate maximal shortest paths through the point and filter them with [InfraPerpendicularQ](). Sub-options belong inside the method spec and are passed through.

The result need not satisfy [InfraPerpendicularQ]() under its default settings. The default `"Metric"` construction is Euclid's, while the predicate tests a projection condition, and on a lattice the two do not coincide. See that page for which equality setting reconciles them.

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Proposition I.12 | To draw a perpendicular to a given line from a point not on it. |
| Euclid | Postulate 4 | All right angles are equal to one another. |
| Hilbert | Group III | Right angles come from angle congruence. |
| Tarski | (derived) | Perpendicularity is defined from equidistance. |

## Basic Examples

A point on the line yields nothing. That is Euclid I.11, not I.12.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {far = SelectFirst[VertexList[g], GraphDistance[g, c, #] == 4 &]},
  {line = RandomInfraLine[g, c, far]},
  Length @ FindInfraPerpendicular[g, line, c, All]]
```

Off the line, the family is large, and `"Radius"` controls it.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {far = SelectFirst[VertexList[g], GraphDistance[g, c, #] == 4 &]},
  {line = RandomInfraLine[g, c, far]},
  {p = SelectFirst[VertexList[g], GraphDistance[g, c, #] == 2 && ! MemberQ[line, #] &]},
  Association @ Table[
    r -> Length @ FindInfraPerpendicular[g, line, p, All, "Radius" -> r], {r, {2, 3}}]]
```

Three perpendiculars through a point, drawn with the line they cross.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {far = SelectFirst[VertexList[g], GraphDistance[g, c, #] == 4 &]},
  {line = RandomInfraLine[g, c, far]},
  {p = SelectFirst[VertexList[g], GraphDistance[g, c, #] == 2 && ! MemberQ[line, #] &]},
  InfraSubstrateHighlight[g,
    {line,
     FindInfraPerpendicular[g, line, p, UpTo[3], "Radius" -> 3],
     {p}},
    "PointSizeRange" -> 16,
    VertexShapeFunction -> ({AbsolutePointSize[3], Point[#]} &),
    ImageSize -> 340]]
```
