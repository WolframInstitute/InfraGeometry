---
Template: Symbol
Name: FindInfraWalk
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraWalk
Keywords: [walk, germ, simple path, stopping condition, next vertex, class of walks]
SeeAlso: [FindInfraGeodesic, FindInfraSegment, FindInfraLine, FindInfraRepresentative, InfraWalk, InfraWalkQ, WalkSingularities]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[FindInfraWalk]()[*g*, *germ*, *kspec*]</code> gives one walk grown from *germ* in the class cut by `Properties`, until a stopping condition fires or the budget *kspec* is spent.

<code>[FindInfraWalk]()[*g*, *germ*, *kspec*, *n*]</code> gives a `List` of exactly *n* walks or `$Failed`; `UpTo[n]` gives up to *n*; `All` gives every one.

## Details & Options

The germ is the seed of the walk: a vertex, a vertex list, a walk graph, or a list of germs. A vertex is the one-vertex germ, so `FindInfraWalk[g, p, ...]` and `FindInfraWalk[g, {p}, ...]` are the same call. A germ is read as a vertex first, so on a substrate labelled by lists the vertex `{1, 1}` is one point, not the walk of its entries. A walk graph is read as its vertex sequence; a list of germs gives the walks grown from each.

*kspec* is the budget in edges added on each growing side: `UpTo[k]` (at most *k*), `{k}` (exactly *k*), `{lo, hi}`, or `Infinity`. A bare integer is no *kspec*. `Infinity` is legal only when a rule of the class bounds it, as the default `"Simple"` does.

A walk is a graph: a directed path graph on the pairs `{i, v}`, the position and the vertex. `Last /@ VertexList[w]` is its vertex sequence. The count-less call returns one walk graph, or `{}` when there is none. The first walk is the first branch of the descent, a witness, not a shortest path.

The class is cut by `Properties`, each rule read on the window of the last `"InfraScale"` vertices with the candidate:

| Option | Default | Values |
|---|---|---|
| `Properties` | `{"Simple"}` | `"Simple"` (no repeated vertex), `"Immersed"` (no backtrack), `"Generic"` (no cusp, self-tangency or triple point), `"Exclude" -> species`, `"Minimizing"`, or a predicate on the window; `{}` is every walk |
| `"InfraScale"` | `Infinity` | how many vertices back a rule sees |
| `"Direction"` | `Automatic` | `"Forward"`, `"Backward"` or `"BothSides"` |
| `"StoppingCondition"` | `None` | *n* (stop at the *n*-th return to a visited vertex), a predicate on the walk so far, or `{spec, "Delay" -> k}` |
| `"NextVertexFunction"` | `Identity` | a function of the candidate windows -- the window with one admissible candidate appended -- giving the ones to pursue, in the order to try: `Identity` the canonical order, `RandomSample` a random order, `RandomChoice` the random walk, `MinimalBy[f]` the candidates least by `f[window]`, `RandomSample[#, UpTo[n]] &` a pruning to *n* branches per node |

The default `"Direction"` is `"Forward"` on a one-vertex germ and `"BothSides"` on a longer one. With a stopping condition it is `"Forward"` for every germ, since the condition needs one tip, and an explicit `"BothSides"` with a condition leaves the call unevaluated. In a list of germs the default is read per germ.

A walk stops when a stopping condition fires, the budget is spent, or no admissible step remains.

An endpoint is a stopping condition. `"StoppingCondition" -> (Last[#] === q &)` stops each walk at its first arrival at *q*; the result is every maximal walk of the class, and the ones that end at *q* are the walks from the germ to *q*. A shortest path between two points is [FindInfraSegment](); the walk family has no two-point form. In the classes `{}` and `{"Immersed"}` a walk can pass *q* before it ends there; those walks are reached with an exact budget `{k}` and the same selection, without the condition.

[FindInfraGeodesic]() is this call at `"InfraScale" -> s` with `"Minimizing"` added to the rules.

## Basic Examples

All simple walks of 3 edges from the centre of the square tiling, from a vertex germ.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {walks = FindInfraWalk[g, a, {3}, All]},
  {InfraSubstrateHighlight[g, {walks, Directive[$InfraPointColor], a}], Length @ walks}]
```

One walk of exactly 5 edges, beside its vertex sequence.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {walk = FindInfraWalk[g, a, {5}]},
  {InfraSubstrateHighlight[g, {walk, Directive[$InfraPointColor], a}], Last /@ VertexList[walk]}]
```

A germ of two vertices grows on both sides: the walks of at most 2 edges added at each end.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {germ = {a, First @ AdjacencyList[g, a]}},
  {walks = FindInfraWalk[g, germ, UpTo[2], All]},
  {InfraSubstrateHighlight[g, {walks, Directive[$InfraPointColor], germ}], Length @ walks}]
```

The same germ grown forward only.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {germ = {a, First @ AdjacencyList[g, a]}},
  {walks = FindInfraWalk[g, germ, UpTo[2], All, "Direction" -> "Forward"]},
  {InfraSubstrateHighlight[g, {walks, Directive[$InfraPointColor], germ}], Length @ walks}]
```

## Options

### Properties

The class widens from the simple walks to every walk of at most 4 edges.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  GraphicsRow @ Table[
    With[{walks = FindInfraWalk[g, a, UpTo[4], All, Properties -> rules]},
      Labeled[InfraSubstrateHighlight[g, {walks, Directive[$InfraPointColor], a}], Row[{rules, ": ", Length @ walks}]]],
    {rules, {{"Simple"}, {"Immersed"}, {}}}]]
```

### StoppingCondition

A predicate on the walk so far stops each walk at its first arrival at *b*; the walks that end there are the walks from the centre to *b*.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 3])},
  {grown = FindInfraWalk[g, a, UpTo[5], All, "StoppingCondition" -> (Last[#] === b &)]},
  {arrived = Select[grown, Last @ Last @ VertexList @ # === b &]},
  {InfraSubstrateHighlight[g, {arrived, Directive[$InfraPointColor], a, b}], Length /@ {grown, arrived}}]
```

### NextVertexFunction

Under `RandomChoice` the walk is a random one, one uniform admissible step at a time. Three walks of 12 edges from the centre, one per seed.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {(SeedRandom[seed]; FindInfraWalk[g, a, {12}, "NextVertexFunction" -> RandomChoice]), Directive[$InfraPointColor], a}],
    {seed, 3}]]
```

## Properties and Relations

A vertex and the one-vertex list are the same germ.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {FindInfraWalk[g, a, UpTo[3], All] === FindInfraWalk[g, {a}, UpTo[3], All]}]
```

With the geodesic rule `"Minimizing"` at scale `Infinity` the walks are shortest paths, so the walks to *b* are the members of the segment.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 3])},
  {walks = Select[
    FindInfraWalk[g, a, Infinity, All, Properties -> {"Minimizing"}, "StoppingCondition" -> (Last[#] === b &)],
    Last @ Last @ VertexList @ # === b &]},
  {InfraSubstrateHighlight[g, {walks, Directive[$InfraPointColor], a, b}],
   Sort[Last /@ VertexList[#] & /@ walks] === Sort @ FindInfraSegment[g, a, b, All]}]
```

## Possible Issues

A call with `Infinity` and no rule that bounds the class is refused, since a stopping condition may never fire; so is a bare integer as *kspec*. Both calls stay unevaluated, which `MatchQ` tests.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {MatchQ[FindInfraWalk[g, a, Infinity, Properties -> {}], _FindInfraWalk], MatchQ[FindInfraWalk[g, a, 3, All], _FindInfraWalk]}]
```
