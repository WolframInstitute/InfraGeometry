---
Template: Symbol
Name: RandomInfraRegularPolygon
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraRegularPolygon
---

## Usage

`RandomInfraRegularPolygon[graph, As, n]` draws one polygon as a list of directed path graphs joining a length-n cyclic vertex sequence whose k-diagonal distances satisfy As[[k]] (slot grammar: Integer exact, {lo, hi} constant in range, Automatic any constant; Length[As] <= Floor[n/2]); count / UpTo[count] / All controls multiplicity.

## Details & Options

The default draw is random. Seed with `SeedRandom` to reproduce it. Give `"NextVertexFunction" -> Identity` for deterministic descent. `All` with `Automatic` keeps the full enumeration without drawing.

Options:

| Option | Values |
|---|---|
| `Properties` | {} |
| `"NextVertexFunction"` | Automatic (default), Identity, RandomSample, any function on the candidate cycles |
| `"From"` | All (default), v, v -> r |

## Basic Examples

A regular hexagon on the six-cycle has consecutive distances 1, second-diagonal distances 2 and opposite distances 3.

```wl
SeedRandom[1];
RandomInfraRegularPolygon[CycleGraph[6], {1, 2, 3}, 6]
```

Deterministic candidate order gives the same first polygon on each call.

```wl
SeedRandom[1];
RandomInfraRegularPolygon[CycleGraph[6], {1, 2, 3}, 6, "NextVertexFunction" -> Identity]
```
