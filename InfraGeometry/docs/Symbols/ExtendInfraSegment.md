---
Template: Symbol
Name: ExtendInfraSegment
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/ExtendInfraSegment
Keywords: [segment extension, geodesic extension, pool, distance matrix, Tarski A4, segment construction]
SeeAlso: [FindInfraSegment, InfraSegment, FindInfraLine, GeodesicExtensionGraph, InfraPoint, TarskiSegmentConstructionQ]
RelatedGuides: [Experimental]
---

## Usage

<code>[ExtendInfraSegment]()[*g*, *seg*, *kspec*]</code> gives one geodesic containing *seg*, extended past its ends by at most *kspec* edges on each side and inextensible within that budget, as a directed path graph.

<code>[ExtendInfraSegment]()[*g*, *seg*, *kspec*, *n*]</code> gives a `List` of exactly *n* extensions or `$Failed`; `UpTo[n]` gives up to *n*; `All` gives the whole class as a pool of DAGs.

<code>[ExtendInfraSegment]()[*g*, *a*, *b*, *c*, *d*]</code> gives the vertices *x* with *b* between *a* and *x* and *d(b, x) = d(c, d)* — Tarski's segment construction, axiom A4 — as a vertex list.

## Details & Options

The seed *seg* is a geodesic vertex list, or a geodesic DAG such as <code>[InfraMeasurement]()[*g*, [InfraSegment]()[*p1*, *p2*], "Graph"]</code>. A DAG extends **as one object**: the whole bundle from *p1* to *p2* gets the same ends.

Everything is read off the distance matrix. With the seed running from *p1* to *p2*, a pair of ends (*s*, *e*) is **admissible** when *d(s, e) = d(s, p1) + d(p1, p2) + d(p2, e)* — the concatenation is a geodesic whichever geodesics are used, so the condition reads only the ends — when the larger of *d(p1, s)* and *d(p2, e)* passes *kspec*, and when each free side is either at the budget or inextensible. The candidate ends are the vertices of the two extension graphs <code>[GeodesicExtensionGraph]()[*g*, {*p2*, *p1*}]</code> and <code>[GeodesicExtensionGraph]()[*g*, {*p1*, *p2*}]</code>, cut at the budget.

| *kspec* | Extension per side |
|---|---|
| *k* | at most *k* edges |
| {*k*} | exactly *k* edges |
| {*lo*, *hi*} | between *lo* and *hi* edges |
| `Infinity` (default) | unbounded — the lines through the seed |
| 0 | none — the seed itself |

`All` returns the **pool**: a `List` of DAGs, one per admissible pair of ends, whose source-to-sink paths are exactly the extensions with those ends. A single admissible pair gives the one DAG, not a list. A bounded count streams extensions off the admissible pairs, each a directed path graph.

With the budget `Infinity` the extensions are the lines through the seed, the family of <code>[InfraLine]()[*p1*, *p2*]</code>, which [InfraMeasurement]() counts without enumerating.

| Option | Values | Meaning |
|---|---|---|
| `Method` | `Automatic` (default), `"Exhaustive"`, `{"Exhaustive", "Pruning" -> spec}`, `"Greedy"`, `"RandomGreedy"` | `Automatic` resolves by the count: `All` to `"Exhaustive"`, the pool; a bounded or absent count to `"Greedy"`, which takes the admissible pairs and the branches of each DAG in candidate order, so the count-less call is deterministic. `"RandomGreedy"` takes them in random order, seeded by an ambient `SeedRandom`. The class is the same under every value; `"Pruning"` is accepted and inert, the pool having no frontier to cap. |
| `"Direction"` | `"BothSides"` (default), `"Forward"`, `"Backward"` | which ends may move: `"Forward"` keeps *p1* and extends past *p2* only, `"Backward"` the reverse. |
| `Properties` | `{}` | only the empty list; a rule on the extension is a local law and lives on [ExtendInfraGeodesic](). |

The five-argument form is Tarski's axiom A4: from *a* through *b*, lay off a segment congruent to *cd*. It returns every vertex *x* at distance *d(c, d)* beyond *b* on a geodesic from *a*; a trailing count *n*, `UpTo[n]` or `All` bounds the list.

## Basic Examples

One step per side beyond an interior edge of the grid: seven extensions, one DAG each.

```wl
Length @ ExtendInfraSegment[GridGraph[{4, 4}], {6, 7}, 1, All]
```

A budget of 0 is the seed itself.

```wl
ExtendInfraSegment[GridGraph[{4, 4}], {6, 7}, 0, All]
```

The count-less call is one extension, the same one every time.

```wl
ExtendInfraSegment[GridGraph[{4, 4}], {6, 7}, 2]
```

Tarski's segment construction on a path: from 2 through 3, lay off a segment as long as 5–7.

```wl
ExtendInfraSegment[PathGraph[Range[7]], 2, 3, 5, 7]
```

## Scope

On the 6-cycle a budget of 1 buys one extension of the edge 1–2, a budget of 2 the three lines through it.

```wl
{ExtendInfraSegment[CycleGraph[6], {1, 2}, 1, All],
 ExtendInfraSegment[CycleGraph[6], {1, 2}, 2, All]}
```

A bounded count gives path graphs.

```wl
ExtendInfraSegment[GridGraph[{4, 4}], {6, 7}, 2, 2]
```

## Options

### "Direction"

`"Forward"` keeps the first vertex of the seed fixed.

```wl
ExtendInfraSegment[GridGraph[{4, 4}], {6, 7}, 1, All, "Direction" -> "Forward"]
```

## Properties and Relations

With no budget the pool carries the lines through the seed: two DAGs for the twelve lines through the edge.

```wl
With[
  {g = GridGraph[{4, 4}]},
  {Length @ ExtendInfraSegment[g, {6, 7}, Infinity, All], Length @ FindInfraLine[g, {6, 7}, All],
   InfraMeasurement[g, InfraLine[6, 7], "Cardinality"]}]
```

Exactly one step per side gives the same seven as at most one, since every one-step extension is inextensible within the budget.

```wl
With[
  {g = GridGraph[{4, 4}]},
  ExtendInfraSegment[g, {6, 7}, {1}, All] === ExtendInfraSegment[g, {6, 7}, 1, All]]
```
