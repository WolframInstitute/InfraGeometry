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

The default draw is random; seed with `SeedRandom` to reproduce it. Give `"NextVertexFunction" -> Identity` for the deterministic lexicographic descent.

The head names the notion; this function draws its members. Where the head has a faithful graph theorem, a member is read off its graph; otherwise the head's own search runs at its defaults.

- `InfraSegment[p, q]`, `InfraRay[p, q]`, `InfraLine[p, q]`, `InfraLine[germ]` and `InfraArc[c, {p, q}]`: a member is a source-to-sink chain of <code>[InfraMeasurement]()[*graph*, *head*, "Graph"]</code>. `Identity` gives the lexicographic descent. A polyline `InfraSegment[p1, ..., pk]` and a multi-point arc concatenate the members of their pieces.
- `InfraCircle[c, r | {r, s}]`: a member is a circle found by sweeping the band, length by length with `FindCycle` (see [InfraCircle]()), as a cyclic vertex list whose first vertex is not repeated. The atoms stay what `InfraMeasurement` measures; the sweep is the check on them.
- `InfraArc[c, {p, p}]`, the closed arc: the same sweep, not the atom of its graph, keeping the circles through *p*, and through every point of `InfraArc[c, {p, q, ..., p}]` (see [InfraArc]()).
- `InfraGeodesic[germ, s]`, the geodesics at infra-scale *s* through the germ: a member is an inextensible simple geodesic, the result of [RandomInfraGeodesic]()`[g, germ, s, Infinity, n, Properties -> {"Simple"}, "Direction" -> "BothSides"]`. The germ is a vertex list; a one-vertex list is grown on both sides, so it gives every geodesic through the vertex.
- The scene tokens `InfraShell`, `InfraBall`, `InfraPlane`, `InfraPolygon`, `InfraWalk` and `InfraPoint`: a member is a result of the token's search at its defaults. A set head such as `InfraBall[c, r]` has one member, its sorted vertex list.

The walk searches ([RandomInfraWalk]() and [RandomInfraGeodesic]()) take a germ, a budget and options of their own; the head `InfraGeodesic` fixes them to the inextensible simple class.

A closed count under a non-negative integer *n* that exceeds the number of members gives `{ }`.

The `"NextVertexFunction"` option controls the descent. `Automatic` draws a uniformly random member from a graph; `Identity` follows the first candidate at each step. A custom function receives the candidate list at each step. `RandomSample[#, UpTo[q]] &` limits the candidates tried at each step to at most *q*. `RandomChoice` draws one candidate at each step and cannot be used with `All`.

The former sampler names are:

| Earlier | Now |
|---|---|
| `FindInfraRepresentative` | `RandomInfraRepresentative` |
| `FindInfraSegment` | `RandomInfraSegment` |
| `FindInfraRay` | `RandomInfraRay` |
| `FindInfraLine` | `RandomInfraLine` |
| `FindInfraParallel` | `RandomInfraParallel` |
| `FindInfraSphere` | `RandomInfraSphere` |
| `FindInfraEllipse` | `RandomInfraEllipse` |
| `FindInfraRegularPolygon` | `RandomInfraRegularPolygon` |
| `FindInfraWalk` | `RandomInfraWalk` |
| `FindInfraGeodesic` | `RandomInfraGeodesic` |

`FindInfraMidpoint` is replaced by <code>[InfraMeasurement]()[*graph*, [InfraSegment]()[*p*, *q*], "Midpoint"]</code>. `FindInfraGoldenSection` is no longer part of the paclet.

The specialised searches (`RandomInfraSegment`, `RandomInfraSphere`, `FindInfraShell`, `RandomInfraWalk`, `RandomInfraGeodesic`, ...) keep their own parameters; this function takes none of them.

`RandomInfraRepresentative[graph, head]` (no count) draws one random member. Use `RandomInfraRepresentative[graph, head, All]` for the full enumeration.

## Basic Examples

A uniformly random shortest path of a segment, drawn over the whole family. `SeedRandom` in front fixes the draw.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[a, 4]])},
  {seg = InfraSegment[a, b]},
  {pick = (SeedRandom[3]; First @ RandomInfraRepresentative[g, seg, 1])},
  {InfraSubstrateHighlight[g, {seg, InfraWalk[pick]}], pick}]
```

One member of a segment is one shortest path.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[a, 4]])},
  {geodesic = RandomInfraRepresentative[g, InfraSegment[a, b]]},
  {InfraSubstrateHighlight[g, {InfraWalk[geodesic], a, b}], geodesic}]
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
