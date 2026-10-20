---
Template: Symbol
Name: RandomInfraEllipse
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraEllipse
---

## Usage

`RandomInfraEllipse[graph, {p1, p2}, c]` draws one directed cycle graph for a shortest separating cycle in the level-surface subgraph { v : cMin <= d(p1,v) + d(p2,v) <= cMax } (c scalar or {cMin, cMax}).

`RandomInfraEllipse[graph, {p1, p2}, c, n]` returns exactly n realisations or {}; UpTo[n] returns up to n; All returns all.

## Details & Options

`RandomInfraEllipse[g, {p, q}, c, count]` uses the direct form.

The default draw is random. Give `"NextVertexFunction" -> Identity` for deterministic descent. `All` with `Automatic` keeps the full enumeration without drawing. `RandomSeeding -> Automatic` (default) seeds each call afresh, independently of `SeedRandom`; an integer or string gives a reproducible draw, and `Inherited` a local snapshot of the current state. The outer random state is restored afterward, as with [RandomInstance](https://reference.wolfram.com/language/ref/RandomInstance.html).

Options:

| Option | Values |
|---|---|
| `Properties` | default {"Separating", "Shortest"} |
| `RandomSeeding` | `Automatic` (default), an integer or string, `Inherited` |

## Basic Examples

A cycle whose vertices have constant distance sum from antipodal foci. The separating condition is omitted because the level surface fills this substrate.

```wl
SeedRandom[1];
RandomInfraEllipse[CycleGraph[6], {1, 4}, 3, Properties -> {}, RandomSeeding -> 1]
```

The same cycle with deterministic candidate order.

```wl
SeedRandom[1];
RandomInfraEllipse[CycleGraph[6], {1, 4}, 3, Properties -> {}, "NextVertexFunction" -> Identity, RandomSeeding -> 1]
```

## Options

### RandomSeeding

A fixed seed reproduces the draw, whatever state `SeedRandom` has set:

```wl
Table[SeedRandom[k]; VertexList @ RandomInfraEllipse[GridGraph[{5, 5}], {12, 14}, {4, 6}, RandomSeeding -> 7], {k, 2}]
```
