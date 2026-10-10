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

The default draw is random. Seed with `SeedRandom` to reproduce it. Give `"NextVertexFunction" -> Identity` for deterministic descent. `All` with `Automatic` keeps the full enumeration without drawing.

Options:

| Option | Values |
|---|---|
| `Properties` | default {"Separating", "Shortest"} |

## Basic Examples

A cycle whose vertices have constant distance sum from antipodal foci. The separating condition is omitted because the level surface fills this substrate.

```wl
SeedRandom[1];
RandomInfraEllipse[CycleGraph[6], {1, 4}, 3, Properties -> {}]
```

The same cycle with deterministic candidate order.

```wl
SeedRandom[1];
RandomInfraEllipse[CycleGraph[6], {1, 4}, 3, Properties -> {}, "NextVertexFunction" -> Identity]
```
