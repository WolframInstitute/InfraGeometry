---
Template: Symbol
Name: InfraVertexList
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraVertexList
Keywords: [segment, ray, line, circle, arc, inert head, member, enumeration, random]
SeeAlso: [InfraMeasurement, InfraMemberQ, FindInfraSegment, FindInfraRay, FindInfraLine, FindInfraCircle, FindInfraArc]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraVertexList]()[*graph*, *obj*]</code> gives one member of the Euclidean head *obj* as a vertex list.

<code>[InfraVertexList]()[*graph*, *obj*, *n* | UpTo[*n*] | All]</code> gives a `List` of *n*, at most *n*, or every member.

## Details & Options

A member is a source-to-sink chain of the head's graph — <code>[InfraMeasurement]()[*graph*, *obj*, "Graph"]</code> — read off in lexicographic order. A circle's graph is a `List` of necklaces, each opened at its closing arrow *u* -> *s1*, so each is an acyclic DAG with one source and one sink; a circle's member is the open chain *s1* … *u*, a cyclic vertex list whose first vertex is not repeated. A closed count under a non-negative integer *n* that exceeds the number of members gives `$Failed`, matching every `Find*` count contract.

Two modifiers, given after the count:

- `"RandomChoice"` walks the graph choosing the next arrow *v* -> *w* with probability proportional to the backward count at *w*, so every member of the family is drawn with probability `1 / Cardinality`; `SeedRandom` in front reproduces the draw.
- `"Pruning" -> q` discards a random fraction *q* of the candidates at each step of an otherwise exhaustive enumeration.

`InfraVertexList[graph, obj]` (no count) is the same as `InfraVertexList[graph, obj, Automatic]`, the first member in canonical order.

## Basic Examples

A uniformly random shortest path of a segment, drawn over the whole family. `SeedRandom` in front fixes the draw.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 4])},
  {seg = InfraSegment[a, b]},
  {pick = (SeedRandom[3]; First @ InfraVertexList[g, seg, 1, "RandomChoice"])},
  {InfraSubstrateHighlight[g, {seg, InfraWalk[pick]}], pick}]
```

One member of a segment is one shortest path.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 4])},
  {member = InfraVertexList[g, InfraSegment[a, b]]},
  {InfraSubstrateHighlight[g, {InfraWalk[member], Directive[$InfraPointColor], a, b}], member}]
```

Every member at once, and their number.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 4])},
  {members = InfraVertexList[g, InfraSegment[a, b], All]},
  {GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[member], Directive[$InfraPointColor], a, b}], {member, members}],
   Length @ members}]
```

A closed count that cannot be met is `$Failed`; `UpTo` takes what there is.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 4])},
  {seg = InfraSegment[a, b]},
  {InfraSubstrateHighlight[g, {InfraVertexList[g, seg, UpTo[20]]}],
   InfraVertexList[g, seg, 20], Length @ InfraVertexList[g, seg, UpTo[20]]}]
```

A member of a circle is a cyclic vertex list: the closing edge is implicit, and drawn as a walk it is added back.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {closedWalk = InfraVertexList[g, InfraCircle[c, "Radius" -> {2, 4}]]},
  {InfraSubstrateHighlight[g, {InfraWalk[Append[closedWalk, First @ closedWalk]] -> $InfraCircleColor, Directive[$InfraPointColor], c}], closedWalk}]
```

## Properties and Relations

Every member is a member, and there are as many as the head counts.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 4])},
  {seg = InfraSegment[a, b]},
  {members = InfraVertexList[g, seg, All]},
  {InfraSubstrateHighlight[g, {members}],
   AllTrue[members, InfraMemberQ[g, seg, #] &], Length @ members === InfraMeasurement[g, seg, "Cardinality"]}]
```
