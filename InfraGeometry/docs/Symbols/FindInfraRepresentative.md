---
Template: Symbol
Name: FindInfraRepresentative
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraRepresentative
Keywords: [segment, ray, line, circle, arc, shell, plane, polygon, inert head, member, representative, enumeration, random]
SeeAlso: [InfraMeasurement, InfraMemberQ, FindInfraSegment, FindInfraRay, FindInfraLine, FindInfraCircle, FindInfraArc]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[FindInfraRepresentative]()[*graph*, *head*]</code> gives one member of the inert *head* as a vertex list.

<code>[FindInfraRepresentative]()[*graph*, *head*, *n* | UpTo[*n*] | All]</code> gives a `List` of *n*, at most *n*, or every member.

## Details & Options

The head names the notion; this function finds its members. Where the head has a faithful graph theorem, a member is read off it; otherwise the head's own search runs at its defaults.

- `InfraSegment[p, q]`, `InfraRay[p, q]`, `InfraLine[p, q]` and `InfraArc[c, {p, q}]`: a member is a source-to-sink chain of <code>[InfraMeasurement]()[*graph*, *head*, "Graph"]</code>, read off in lexicographic order. A polyline `InfraSegment[p1, ..., pk]` and a multi-point arc concatenate the members of their pieces.
- `InfraCircle[c, p]` and `InfraCircle[c, "Radius" -> r]`: a member is a circle found by the sweep, <code>[FindInfraCircle]()</code> at its defaults, as a cyclic vertex list whose first vertex is not repeated. The necklace graph stays what `InfraMeasurement` measures.
- The scene tokens `InfraShell`, `InfraBall`, `InfraPlane`, `InfraPolygon`, `InfraTriangle`, `InfraPolyline`, `InfraRevolution`, `InfraWalk`, `InfraPoint` and `InfraLine[path]`: a member is a result of the token's search at its defaults. A set head such as `InfraBall[c, r]` has one member, its sorted vertex list.

A closed count under a non-negative integer *n* that exceeds the number of members gives `{ }`.

Two modifiers, given after the count:

- `"RandomChoice"` gives random members. On a graph it walks the chains choosing the next arrow *v* -> *w* with probability proportional to the backward count at *w*, so every member is drawn with probability `1 / Cardinality`; on a search with a method ladder it is `Method -> "RandomGreedy"`; otherwise it draws from the search's members. `SeedRandom` in front reproduces the draw.
- `"Pruning" -> q`, under `All`, discards a random fraction *q* of the candidates at each step of an otherwise exhaustive enumeration; on a search with a method ladder it is `Method -> {"Exhaustive", "Pruning" -> q}`.

The specialised searches (`FindInfraSegment`, `FindInfraCircle`, `FindInfraShell`, `FindInfraWalk`, ...) keep their own parameters; this function takes none of them.

`FindInfraRepresentative[graph, head]` (no count) is the same as `FindInfraRepresentative[graph, head, Automatic]`, the first member in canonical order.

## Basic Examples

A uniformly random shortest path of a segment, drawn over the whole family. `SeedRandom` in front fixes the draw.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 4])},
  {seg = InfraSegment[a, b]},
  {pick = (SeedRandom[3]; First @ FindInfraRepresentative[g, seg, 1, "RandomChoice"])},
  {InfraSubstrateHighlight[g, {seg, InfraWalk[pick]}], pick}]
```

One member of a segment is one shortest path.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 4])},
  {member = FindInfraRepresentative[g, InfraSegment[a, b]]},
  {InfraSubstrateHighlight[g, {InfraWalk[member], Directive[$InfraPointColor], a, b}], member}]
```

Every member at once, and their number.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 4])},
  {members = FindInfraRepresentative[g, InfraSegment[a, b], All]},
  {GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[member], Directive[$InfraPointColor], a, b}], {member, members}],
   Length @ members}]
```

A closed count that cannot be met is `{ }`; `UpTo` takes what there is.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 4])},
  {seg = InfraSegment[a, b]},
  {InfraSubstrateHighlight[g, {FindInfraRepresentative[g, seg, UpTo[20]]}],
   FindInfraRepresentative[g, seg, 20], Length @ FindInfraRepresentative[g, seg, UpTo[20]]}]
```

A member of a circle is a circle of the sweep, as a cyclic vertex list: the closing edge is implicit, and drawn as a walk it is added back.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {closedWalk = FindInfraRepresentative[g, InfraCircle[c, "Radius" -> {2, 4}]]},
  {InfraSubstrateHighlight[g, {InfraWalk[Append[closedWalk, First @ closedWalk]] -> $InfraCircleColor, Directive[$InfraPointColor], c}], closedWalk}]
```

A scene token is read by its search: one shell around the centre.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {shell = FindInfraRepresentative[g, InfraShell[c, 3]]},
  InfraSubstrateHighlight[g, {shell, Directive[$InfraPointColor], c}]]
```

## Properties and Relations

Every member is a member, and there are as many as the head counts.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 4])},
  {seg = InfraSegment[a, b]},
  {members = FindInfraRepresentative[g, seg, All]},
  {InfraSubstrateHighlight[g, {members}],
   AllTrue[members, InfraMemberQ[g, seg, #] &], Length @ members === InfraMeasurement[g, seg, "Cardinality"]}]
```
