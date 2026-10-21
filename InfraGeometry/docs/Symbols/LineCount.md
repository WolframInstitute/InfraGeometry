---
Template: Symbol
Name: LineCount
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/LineCount
Keywords: [line, count, inextensible shortest path]
SeeAlso: [RandomInfraInfiniteLine, InfraInfiniteLineQ, UniversalLineQ]
RelatedGuides: [Experimental]
---

## Usage

<code>[LineCount]()[*g*]</code> gives the number of lines of *g*: the shortest paths that cannot be prolonged at either end, a line and its reverse counted once.

## Details & Options

A line is a shortest path *(v₀, …, vₖ)* such that no neighbour *w* of *vₖ* has *d(v₀, w) = k + 1*, and likewise at *v₀*. The lines are the members of <code>[RandomInfraInfiniteLine]()[*g*, *u*, *v*, All]</code> over all pairs *u*, *v*.

Closed forms:

| Graph | Lines |
|---|---|
| path | 1 |
| tree with *ℓ* leaves | *C(ℓ, 2)*, one between each two leaves |
| cycle *Cₙ*, *n ≥ 3* | *n* |
| complete graph *Kₙ* | *C(n, 2)*, the edges |
| grid graph *m × n*, *m, n ≥ 2* | *2 C(m + n − 2, m − 1)*, the shortest paths between opposite corners |
| hypercube of dimension *d* | *2ᵈ⁻¹ d!*, the shortest paths between antipodal vertices |

On a grid graph a row or a column is not a line: it can be prolonged at a turn. The number of lines grows exponentially with the size of a lattice, so [LineCount]() is for small graphs.

## Basic Examples

On the 4 × 4 grid graph a side can be prolonged around the corner, so it is not a line; the prolonged walk, from corner to opposite corner, is:

```wl
With[{g = GridGraph[{4, 4}]}, {side = {1, 2, 3, 4}, line = {1, 2, 3, 4, 8, 12, 16}},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {InfraWalk[w]}, PlotLabel -> InfraInfiniteLineQ[g, w]], {w, {side, line}}]]
```

The number of lines of the *m* × *n* grid graph is *2 C(m + n − 2, m − 1)*:

```wl
Table[{LineCount[GridGraph[{m, n}]], 2 Binomial[m + n - 2, m - 1]}, {m, 2, 4}, {n, 2, 5}]
```

## Scope

A tree has one line between each two leaves:

```wl
With[{t = TreeGraph[Table[Floor[k/2] <-> k, {k, 2, 15}]]},
  InfraSubstrateHighlight[t, {Pick[VertexList[t], VertexDegree[t], 1]},
    PlotLabel -> {LineCount[t], Binomial[Count[VertexDegree[t], 1], 2]}, ImageSize -> Medium]]
```

Cycles have *n* lines and complete graphs *C(n, 2)*:

```wl
{Table[LineCount[CycleGraph[n]], {n, 3, 10}], Table[LineCount[CompleteGraph[n]], {n, 2, 7}]}
```

## Properties and Relations

On the hypercube every line joins two antipodal vertices, and there are *2ᵈ⁻¹ d!* of them:

```wl
Table[{LineCount[HypercubeGraph[d]], 2^(d - 1) d!}, {d, 1, 4}]
```
