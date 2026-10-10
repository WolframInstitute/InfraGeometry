---
Template: Symbol
Name: RandomInfraRepresentative
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraRepresentative
Keywords: [segment, ray, line, circle, arc, shell, plane, polygon, symbolic object, member, representative, enumeration, random]
SeeAlso: [InfraMeasurement, InfraMemberQ, RandomInfraSegment, RandomInfraRay, RandomInfraLine, RandomInfraGeodesic, RandomInfraWalk, InfraCircle, InfraArc]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraRepresentative]()[*graph*, *head*]</code> gives one member of the symbolic object *head* as a vertex list.

<code>[RandomInfraRepresentative]()[*graph*, *head*, *n* | UpTo[*n*] | All]</code> gives a `List` of *n*, at most *n*, or every member.

## Details & Options

The draw is random: seed with `SeedRandom`. For a deterministic draw give `"NextVertexFunction" -> Identity`. Formerly `FindInfra...` (default deterministic); `FindInfraMidpoint` is now the `"Midpoint"` reader of `InfraMeasurement`.

The head names the notion; this function finds its members. Where the head has a faithful graph theorem, a member is read off it; otherwise the head's own search runs at its defaults.

- `InfraSegment[p, q]`, `InfraRay[p, q]`, `InfraLine[p, q]`, `InfraLine[germ]` and `InfraArc[c, {p, q}]`: a member is a source-to-sink chain of <code>[InfraMeasurement]()[*graph*, *head*, "Graph"]</code>, read off in lexicographic order. A polyline `InfraSegment[p1, ..., pk]` and a multi-point arc concatenate the members of their pieces.
- `InfraCircle[c, r | {r, s}]`: a member is a circle found by sweeping the band, length by length with `FindCycle` (see [InfraCircle]()), as a cyclic vertex list whose first vertex is not repeated. The atoms stay what `InfraMeasurement` measures; the sweep is the check on them.
- `InfraArc[c, {p, p}]`, the closed arc: the same sweep, not the atom of its graph, keeping the circles through *p*, and through every point of `InfraArc[c, {p, q, ..., p}]` (see [InfraArc]()).
- `InfraGeodesic[germ, s]`, the geodesics at infra-scale *s* through the germ: a member is an inextensible simple geodesic, the result of [RandomInfraGeodesic]()`[g, germ, s, Infinity, n, Properties -> {"Simple"}, "Direction" -> "BothSides"]`. The germ is a vertex list; a one-vertex list is grown on both sides, so it gives every geodesic through the vertex.
- The scene tokens `InfraShell`, `InfraBall`, `InfraPlane`, `InfraPolygon`, `InfraWalk` and `InfraPoint`: a member is a result of the token's search at its defaults. A set head such as `InfraBall[c, r]` has one member, its sorted vertex list.

The walk searches ([RandomInfraWalk]() and [RandomInfraGeodesic]()) take a germ, a budget and options of their own; the head `InfraGeodesic` fixes them to the inextensible simple class.

A closed count under a non-negative integer *n* that exceeds the number of members gives `{ }`.

Two modifiers, given after the count:

- `"RandomChoice"` gives random members. On a graph it walks the chains choosing the next arrow *v* -> *w* with probability proportional to the backward count at *w*, so every member is drawn with probability `1 / Cardinality`; on a search it is `"NextVertexFunction" -> RandomSample`; otherwise it draws from the search's members. `SeedRandom` in front reproduces the draw.
- `"Pruning" -> q`, under `All`, discards a random fraction *q* of the candidates at each step of an otherwise exhaustive enumeration; on a search it is the next-vertex function `RandomSample[#, UpTo[q]] &` for an integer *q*, keeping a fraction *q* of the candidates per node for *q* < 1.

The specialised searches (`RandomInfraSegment`, `RandomInfraSphere`, `FindInfraShell`, `RandomInfraWalk`, `RandomInfraGeodesic`, ...) keep their own parameters; this function takes none of them.

`RandomInfraRepresentative[graph, head]` (no count) is the same as `RandomInfraRepresentative[graph, head, Automatic]`, the first member in canonical order.

## Basic Examples

A uniformly random shortest path of a segment, drawn over the whole family. `SeedRandom` in front fixes the draw.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[a, 4]])},
  {seg = InfraSegment[a, b]},
  {pick = (SeedRandom[3]; First @ RandomInfraRepresentative[g, seg, 1, "RandomChoice"])},
  {InfraSubstrateHighlight[g, {seg, InfraWalk[pick]}], pick}]
```

One member of a segment is one shortest path.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[a, 4]])},
  {path = RandomInfraRepresentative[g, InfraSegment[a, b]]},
  {InfraSubstrateHighlight[g, {InfraWalk[path], a, b}], path}]
```

Every member at once, and their number.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[a, 4]])},
  {members = RandomInfraRepresentative[g, InfraSegment[a, b], All]},
  {GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[member], a, b}], {member, members}],
   Length @ members}]
```

A closed count that cannot be met is `{ }`; `UpTo` takes what there is.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[a, 4]])},
  {seg = InfraSegment[a, b]},
  {InfraSubstrateHighlight[g, {RandomInfraRepresentative[g, seg, UpTo[20]]}],
   RandomInfraRepresentative[g, seg, 20], Length @ RandomInfraRepresentative[g, seg, UpTo[20]]}]
```

A member of a circle is a circle of the sweep, as a cyclic vertex list: the closing edge is implicit, and drawn as a walk it is added back.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {closedWalk = RandomInfraRepresentative[g, InfraCircle[c, {2, 4}]]},
  {InfraSubstrateHighlight[g, {InfraWalk[Append[closedWalk, First @ closedWalk]], c}], closedWalk}]
```

A scene token is read by its search: one shell around the centre.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {shell = RandomInfraRepresentative[g, InfraShell[c, 3]]},
  InfraSubstrateHighlight[g, {shell, c}]]
```

Four inextensible shortest paths through an edge at the centre, the members of a geodesic head.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {germ = {a, First @ AdjacencyList[g, a]}},
  {members = RandomInfraRepresentative[g, InfraGeodesic[germ, Infinity], 4]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[member], a}], {member, members}]]
```

## Properties and Relations

Every member is a member, and there are as many as the head counts.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[a, 4]])},
  {seg = InfraSegment[a, b]},
  {members = RandomInfraRepresentative[g, seg, All]},
  {InfraSubstrateHighlight[g, {members}],
   AllTrue[members, InfraMemberQ[g, seg, #] &], Length @ members === InfraMeasurement[g, seg, "Cardinality"]}]
```
