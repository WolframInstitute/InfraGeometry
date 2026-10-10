---
Template: Symbol
Name: RandomInfraWalk
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraWalk
Keywords: [walk, germ, simple path, window, energy, weight, random walk, stopping condition, next vertex, class of walks]
SeeAlso: [RandomInfraGeodesic, RandomInfraSegment, RandomInfraInfiniteLine, RandomInfraWalk, InfraWalk, InfraWalkQ, WalkSingularities]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraWalk]()[*g*, *germ*, *kspec*]</code> gives one walk grown from *germ* one step at a time under the rules of `Properties`, until a stopping condition fires or the budget *kspec* is spent.

<code>[RandomInfraWalk]()[*g*, *germ*, *kspec*, *n*]</code> gives a `List` of exactly *n* walks or `{}`; `UpTo[n]` gives up to *n*; `All` gives every one.

## Details & Options

The default draw is random. Seed with `SeedRandom` to reproduce it. Give `"NextVertexFunction" -> Identity` for deterministic descent. `All` with `Automatic` keeps the full enumeration without drawing.

The germ is the seed of the walk: a vertex, a vertex list, a walk graph, or a list of germs. A vertex is the one-vertex germ, so `RandomInfraWalk[g, p, ...]` and `RandomInfraWalk[g, {p}, ...]` are the same call. A germ is read as a vertex first, so on a substrate labelled by lists the vertex `{1, 1}` is one point, not the walk of its entries. A walk graph is read as its vertex sequence; a list of germs gives the walks grown from each.

*kspec* is the budget in edges added on each growing side: `UpTo[k]` (at most *k*), `{k}` (exactly *k*), `{lo, hi}`, or `Infinity`. A bare integer is no *kspec*. `Infinity` is legal only under a hard rule that bounds the class: a bare `"Simple"` or a bare `"Shortest"`.

A walk is a graph: a directed path graph on the pairs `{i, v}`, the position and the vertex. `Last /@ VertexList[w]` is its vertex sequence. The count-less call returns one walk graph, or `{}` when there is none.

A step reads a **window**: the last *r* vertices of the growing side with the candidate appended, *r* + 1 vertices and *r* edges; *r* = `Infinity` is the whole side. A rule is an **energy** on the window, a non-negative number that is `0` exactly when the rule holds:

| Rule | Energy of the window |
|---|---|
| `"Simple"` | the number of earlier occurrences of the candidate; at *r* = 2 a backtrack, a cusp |
| `"Shortest"` | the defect: the edges of the window minus the distance between its ends |
| `"Stretched"` | the defect minus the least defect among the step's candidates |
| *f* | `f[window]`, a non-negative number; `True` and `False` read as `0` and `1`, so a predicate is a rule |

`Properties` is a list of rules, each written `rule`, `{rule, r}` or `{rule, r, p}`. A bare rule has *r* = `Infinity`, a pair has *p* = `0`. The weight *p* says how much a violation costs:

| *p* | Reading |
|---|---|
| `0` | hard: a candidate of positive energy is dropped |
| `0 < p <= 1` | soft: a candidate keeps the weight *p*^energy; *p* = `Exp[-beta]` is the Boltzmann weight at inverse temperature *beta*; at *p* = `1` every candidate weighs alike |

The hard rules cut the class; the soft rules put a distribution on it, the weight of a candidate being the product over the soft rules. The rules act in the order written, so `"Stretched"` compares the candidates the hard rules before it left. As soft rules `"Stretched"` and `"Shortest"` weigh alike: their energies differ by a constant on each step.

| Option | Default | Values |
|---|---|---|
| `Properties` | `{}` | the rules; `{}` is every walk |
| `"NextVertexFunction"` | `Automatic` | the order the surviving candidates are tried in |
| `"Direction"` | `"Forward"` | `"Forward"`, `"Backward"` or `"BothSides"` |
| `"StoppingCondition"` | `None` | a predicate on the walk so far |

`"NextVertexFunction"` turns the surviving candidates and their weights into the order they are tried:

| Value | Order |
|---|---|
| `Automatic` | random by the weights for bounded counts; canonical for `All` |
| `Identity` | canonical, the weights ignored |
| `RandomSample` | random by the weights, uniform without a soft rule |
| `RandomChoice` | one candidate drawn by the weights: the random walk, which never backtracks |
| *f*, `{f, r}` | `f` of the candidate windows, whole or of scale *r*, giving the ones to pursue in order; the weights ignored |

Every order works with every rule. `Identity` and a function do not see the weights, so under them a soft rule changes nothing. `RandomSample` is a permutation, so `All` is the whole class whatever the weights. Under `RandomChoice` the count *n* is *n* independent runs from the germ, and the runs that met *kspec* are returned; a pruning to *m* branches per step is `RandomSample[#, UpTo[m]] &`.

`"Direction"` says where the walk grows: `"Forward"` after the last vertex of the germ, `"Backward"` before the first, `"BothSides"` at both ends. Under `"BothSides"` each outer step grows both ends, the front only or the back only, the hard `"Simple"` and `"Shortest"` are checked again on the window holding both new ends, and the budget is the edges added on the longer side.

`"StoppingCondition"` is a predicate on the whole walk so far, its vertex sequence, read after every step and on the germ once it has an edge. It can test both tips, and when it fires the walk stops on both sides. A walk also stops when the budget is spent or no admissible step remains.

An endpoint is a stopping condition. `"StoppingCondition" -> (Last[#] === q &)` stops each walk at its first arrival at *q*; the walks that end at *q* are the walks from the germ to *q*. A shortest path between two points is [RandomInfraSegment](); the walk family has no two-point form.

[RandomInfraGeodesic]() is this call with `{"Shortest", s}` first among the rules.

## Basic Examples

Three walks of 9 edges from the centre of a mesh, the soft straightness at window 5 with weights 1, 0.3 and 0.01: from the random walk to a nearly straight one.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareMeshGraph", "Medium", "KeepCoordinates" -> True]},
  {c = (SeedRandom[2]; RandomInfraPoint[g, GraphCenter[g]])},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {(SeedRandom[5]; RandomInfraWalk[g, c, UpTo[9], Properties -> {{"Shortest", 5, p}}]), c}, "Arrowheads" -> True],
    {p, {1, 0.3, 0.01}}]]
```

All simple walks of 3 edges from the centre of the square tiling.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {walks = RandomInfraWalk[g, a, {3}, All, Properties -> {"Simple"}]},
  {InfraSubstrateHighlight[g, {walks, a}], Length @ walks}]
```

One simple walk of exactly 5 edges, beside its vertex sequence.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {walk = RandomInfraWalk[g, a, {5}, Properties -> {"Simple"}]},
  {InfraSubstrateHighlight[g, {walk, a}, "Arrowheads" -> True], Last /@ VertexList[walk]}]
```

A germ of two vertices grows forward: the simple walks that add at most 2 edges after its last vertex.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {germ = {a, First @ AdjacencyList[g, a]}},
  {walks = RandomInfraWalk[g, germ, UpTo[2], All, Properties -> {"Simple"}]},
  {InfraSubstrateHighlight[g, {walks, germ}], Length @ walks}]
```

## Options

### Properties

The class widens from the simple walks to the walks without a cusp, `{"Simple", 2}`, and to every walk of at most 4 edges.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  GraphicsRow @ Table[
    With[{walks = RandomInfraWalk[g, a, UpTo[4], All, Properties -> rules]},
      Labeled[InfraSubstrateHighlight[g, {walks, a}], Row[{rules, ": ", Length @ walks}]]],
    {rules, {{"Simple"}, {{"Simple", 2}}, {}}}]]
```

A soft `"Simple"`: the walk of 30 edges that rarely returns to a vertex it has visited, at weights 0.01, 0.1 and 1, with the number of returns.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  GraphicsRow @ Table[
    With[
      {walk = (SeedRandom[4];
        RandomInfraWalk[g, a, {30}, Properties -> {{"Simple", Infinity, p}}])},
      Labeled[InfraSubstrateHighlight[g, {walk, a}, "Arrowheads" -> True],
        Row[{p, ": ", 31 - Length @ DeleteDuplicates[Last /@ VertexList @ walk]}]]],
    {p, {0.01, 0.1, 1}}]]
```

A window: `{"Simple", 3}` forbids a return within 3 steps only, so the walk may close round a hexagon; `"Simple"` may not.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  GraphicsRow @ Table[
    With[
      {loops = Select[RandomInfraWalk[g, a, {6}, All, Properties -> {rule}], Last @ Last @ VertexList @ # === a &]},
      Labeled[InfraSubstrateHighlight[g, {loops, a}], Row[{rule, ": ", Length @ loops}]]],
    {rule, {"Simple", {"Simple", 3}}}]]
```

A function is a rule: the energy `GraphDistance[g, Last @ w, q]` at window 1 and weight 0.3 pulls the walk toward *q*.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {q = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[a, 6]])},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g,
      {(SeedRandom[seed]; RandomInfraWalk[g, a, {12}, Properties -> {{w |-> GraphDistance[g, Last @ w, q], 1, 0.3}}]), a, q},
      "Arrowheads" -> True],
    {seed, 3}]]
```

`{"Stretched", 2}` keeps at each step the candidates farthest from the vertex two steps back: on the triangular tiling the three of the six neighbours that neither step back nor cut a triangle.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {walks = RandomInfraWalk[g, a, {4}, All, Properties -> {{"Stretched", 2}}]},
  {InfraSubstrateHighlight[g, {walks, a}], Length @ walks}]
```

### NextVertexFunction

Under `RandomChoice` the walk is a random one, one admissible step at a time, and the count is the number of independent runs. Three simple walks of 12 edges from the centre in one call.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {walks = (SeedRandom[1]; RandomInfraWalk[g, a, {12}, 3, Properties -> {"Simple"}, "NextVertexFunction" -> RandomChoice])},
  GraphicsRow[InfraSubstrateHighlight[g, {#, a}, "Arrowheads" -> True] & /@ walks]]
```

### Direction

The simple walks of at most 2 edges grown from a two-vertex germ forward, backward and on both sides.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {germ = {a, First @ AdjacencyList[g, a]}},
  GraphicsRow @ Table[
    With[{walks = RandomInfraWalk[g, germ, UpTo[2], All, Properties -> {"Simple"}, "Direction" -> dir]},
      Labeled[InfraSubstrateHighlight[g, {walks, germ}], Row[{dir, ": ", Length @ walks}]]],
    {dir, {"Forward", "Backward", "BothSides"}}]]
```

### StoppingCondition

A predicate on the walk so far stops each walk at its first arrival at *b*; the walks that end there are the simple walks from the centre to *b*.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[a, 3]])},
  {grown = RandomInfraWalk[g, a, UpTo[5], All, Properties -> {"Simple"}, "StoppingCondition" -> (Last[#] === b &)]},
  {arrived = Select[grown, Last @ Last @ VertexList @ # === b &]},
  {InfraSubstrateHighlight[g, {arrived, a, b}], Length /@ {grown, arrived}}]
```

Under `"BothSides"` the predicate reads both tips: the shortest paths through an edge of the grid stop when the back reaches 22 or the front reaches 28, whichever comes first.

```wl
SeedRandom[1];
With[
  {g = GridGraph[{7, 7}]},
  {walks = RandomInfraWalk[g, {24, 25}, Infinity, All, Properties -> {"Shortest"}, "Direction" -> "BothSides",
    "StoppingCondition" -> (First[#] === 22 || Last[#] === 28 &)]},
  {stopped = Select[walks, MatchQ[Last /@ VertexList @ #, {22, __} | {__, 28}] &]},
  {InfraSubstrateHighlight[g, {stopped, {24, 25}, 22, 28}], Length /@ {walks, stopped}}]
```

## Properties and Relations

A vertex and the one-vertex list are the same germ.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {RandomInfraWalk[g, a, UpTo[3], All] === RandomInfraWalk[g, {a}, UpTo[3], All]}]
```

With the hard `"Shortest"` at scale `Infinity` the walks are shortest paths, so the walks to *b* are the members of the segment.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[a, 3]])},
  {walks = Select[
    RandomInfraWalk[g, a, Infinity, All, Properties -> {"Shortest"}, "StoppingCondition" -> (Last[#] === b &)],
    Last @ Last @ VertexList @ # === b &]},
  {InfraSubstrateHighlight[g, {walks, a, b}],
   Sort[Last /@ VertexList[#] & /@ walks] === Sort @ RandomInfraSegment[g, a, b, All]}]
```

A soft rule changes the order, not the class: under `All` the weighted walks are the walks of the hard rules.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {Sort @ RandomInfraWalk[g, a, {4}, All, Properties -> {"Simple", {"Shortest", 3, 0.3}}] ===
    Sort @ RandomInfraWalk[g, a, {4}, All, Properties -> {"Simple"}]}]
```

The soft `"Stretched"` weighs as the soft `"Shortest"`: under one seed the two draw the same walk.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {SameQ @@ Table[Last /@ VertexList @ (SeedRandom[1]; RandomInfraWalk[g, a, {6}, Properties -> {{rule, 3, 0.3}}]), {rule, {"Stretched", "Shortest"}}]}]
```

The cusps, self-tangencies and triple points of a walk are read by [WalkSingularities](); a class free of one of them is a predicate on it.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {walks = Select[RandomInfraWalk[g, a, {6}, All, Properties -> {{"Simple", 2}}],
    WalkSingularities[Last /@ VertexList @ #]["SelfTangencies"] =!= {} &]},
  {InfraSubstrateHighlight[g, {Take[walks, UpTo[3]], a}], Length @ walks}]
```

## Possible Issues

A call with `Infinity` and no hard rule that bounds the class is refused, since a stopping condition may never fire; so is a bare integer as *kspec*. Both calls stay unevaluated, which `MatchQ` tests.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {MatchQ[RandomInfraWalk[g, a, Infinity, Properties -> {}], _RandomInfraWalk], MatchQ[RandomInfraWalk[g, a, 3, All], _RandomInfraWalk]}]
```

Under `Identity` the weights are ignored, so a soft rule changes nothing: the walk is the canonical walk of the hard rules.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {RandomInfraWalk[g, a, {4}, Properties -> {"Simple", {"Shortest", 3, 0.01}}, "NextVertexFunction" -> Identity] ===
    RandomInfraWalk[g, a, {4}, Properties -> {"Simple"}]}]
```
