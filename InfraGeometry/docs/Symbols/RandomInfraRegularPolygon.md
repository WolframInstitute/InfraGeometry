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

`RandomInfraRegularPolygon[g, As, n, count]` uses the direct form. The bare form returns ordered directed Graph legs; the token form returns their concatenated ordered vertex sequence.

The default draw is random. Give `"NextVertexFunction" -> Identity` for deterministic descent. `All` with `Automatic` keeps the full enumeration without drawing. `RandomSeeding -> Automatic` (default) seeds each call afresh, independently of `SeedRandom`; an integer or string gives a reproducible draw, and `Inherited` a local snapshot of the current state. The outer random state is restored afterward, as with [RandomInstance](https://reference.wolfram.com/language/ref/RandomInstance.html).

Options:

| Option | Values |
|---|---|
| `Properties` | {} |
| `"NextVertexFunction"` | Automatic (default), Identity, RandomSample, any function on the candidate cycles |
| `"From"` | All (default), v, v -> r |
| `RandomSeeding` | `Automatic` (default), an integer or string, `Inherited` |

## Basic Examples

A regular hexagon on the six-cycle has consecutive distances 1, second-diagonal distances 2 and opposite distances 3.

```wl
SeedRandom[1];
RandomInfraRegularPolygon[CycleGraph[6], {1, 2, 3}, 6, RandomSeeding -> 1]
```

Deterministic candidate order gives the same first polygon on each call.

```wl
SeedRandom[1];
RandomInfraRegularPolygon[CycleGraph[6], {1, 2, 3}, 6, "NextVertexFunction" -> Identity, RandomSeeding -> 1]
```

## Options

### RandomSeeding

A fixed seed reproduces the draw, whatever state `SeedRandom` has set:

```wl
Table[SeedRandom[k]; VertexList /@ RandomInfraRegularPolygon[GridGraph[{5, 5}], {2}, 4, RandomSeeding -> 7], {k, 2}]
```
