---
Template: Symbol
Name: RandomInfraWalk
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraWalk
Keywords: [walk, germ, self-avoiding walk, simple path, window, energy, weight, random walk, stopping condition]
SeeAlso: [RandomInfraGeodesic, RandomInfraSegment, RandomInfraInfiniteLine, InfraWalk, InfraWalkQ, WalkSingularities]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraWalk]()[*g*, *germ*, *k*]</code> gives a random walk grown from *germ* in *g* by at most the budget *k* of edges, each step under the rules of [Properties]().

<code>[RandomInfraWalk]()[*g*, *germ*, *k*, *n*]</code> gives a list of *n* distinct walks.

<code>[RandomInfraWalk]()[*g*, *germ*]</code> grows the walk with no budget, until no admissible step remains or the stopping condition fires.

## Details & Options

The germ is a vertex, a vertex list or a walk graph; a list of germs gives the walks grown from each. A walk is returned as a directed path graph on the pairs {*i*, *v*}; `Last /@ VertexList[w]` is its vertex sequence.

The budget *k* counts the edges added on each growing side: `UpTo[k]`, `{k}` (exactly *k*), `{kmin, kmax}` or `Infinity`. `Infinity` needs a hard `"Simple"` or `"Shortest"` with no window, which bounds the walks.

A step looks at a window: the last *r* vertices of the growing side with the candidate appended; *r* = `Infinity` is the whole side. A rule is an energy *E* ≥ 0 on the window, *E* = 0 exactly when the rule holds:

| Rule | Energy *E* of the window |
|---|---|
| `"Simple"` | the number of earlier occurrences of the candidate; at *r* = 2 a step back |
| `"Shortest"` | the defect: the number of edges of the window minus the distance of its ends |
| `"Stretched"` | the defect minus the least defect among the candidates of the step |
| *f* | `f[window]`; `True` and `False` read as 0 and 1 |

A rule is written `rule`, `{rule, r}` or `{rule, r, p}`, with *r* = `Infinity` and *p* = 0 when omitted. The weight *p* sets how much a violation costs:

| *p* | Effect |
|---|---|
| `0` | hard: a candidate with *E* > 0 is dropped |
| 0 < *p* ≤ 1 | soft: a candidate keeps the weight *pᴱ*; *p* = *e*^(−β) is the Boltzmann weight at inverse temperature β |

Hard rules cut the class of walks, soft rules put a distribution on it. The rules act in the order given.

The hard `"Simple"` gives the self-avoiding walks; on the square grid there are 4, 12, 36, 100, 284 of 1 to 5 edges from a vertex. The hard `"Shortest"` with no window gives shortest paths.

Options:

| Option | Default | Values |
|---|---|---|
| [Properties]() | `{}` | the list of rules; `{}` allows every walk |
| `"NextVertexFunction"` | `Automatic` | the order the candidates are tried in, below |
| `"Direction"` | `"Forward"` | `"Forward"` after the last vertex of the germ, `"Backward"` before the first, `"BothSides"` at both ends |
| `"StoppingCondition"` | `None` | a predicate on the vertex sequence so far; the walk stops when it gives `True` |
| [RandomSeeding]() | `Automatic` | an integer or a string for a reproducible draw; `Inherited` to draw from the current random state |

| `"NextVertexFunction"` | Order of the candidates |
|---|---|
| `Automatic` | random by the weights; fixed for `All` |
| `Identity` | fixed, the weights ignored |
| `RandomSample` | random by the weights |
| `RandomChoice` | one candidate drawn by the weights, no backtracking: the random walk; a count *n* is *n* independent runs |
| *f*, {*f*, *r*} | *f* of the candidate windows, whole or of scale *r*, gives the candidates to pursue; the weights ignored |

Under `All` a soft rule changes the order of the walks, not the class. A walk also stops when the budget is spent or no candidate is left.

## Basic Examples

A self-avoiding walk of 8 edges from the centre, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    InfraSubstrateHighlight[g, {RandomInfraWalk[g, c, {8}, Properties -> {"Simple"}, RandomSeeding -> 1], c}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The number of self-avoiding walks of 1 to 5 edges on the grid:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium"]}, {c = First @ GraphCenter[g]},
  Table[Length @ RandomInfraWalk[g, c, {k}, All, Properties -> {"Simple"}], {k, 5}]]
```

A soft straightness, the rule `"Shortest"` on a window of 5 vertices with weight 1, 0.3 and 0.01: from the random walk to a nearly straight one:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {RandomInfraWalk[g, c, {9}, Properties -> {{"Shortest", 5, p}}, RandomSeeding -> 5], c},
      PlotLabel -> p],
    {p, {1, 0.3, 0.01}}]]
```

## Options

### Properties

The walks of 4 edges on the grid: self-avoiding, without a step back, and all of them, *100*, *4 · 3³ = 108* and *4⁴ = 256*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium"]}, {c = First @ GraphCenter[g]},
  Table[rules -> Length @ RandomInfraWalk[g, c, {4}, All, Properties -> rules], {rules, {{"Simple"}, {{"Simple", 2}}, {}}}]]
```

A function is a rule. The energy *d(v, q)* of the new vertex, at window 1 and weight 0.3, pulls a self-avoiding walk toward *q*, here at distance 5; the walk stops there. The labels are the lengths:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[c, 5], RandomSeeding -> 1]},
  GraphicsRow @ Table[
    With[{walk = RandomInfraWalk[g, c, UpTo[20], Properties -> {"Simple", {w |-> GraphDistance[g, Last[w], q], 1, 0.3}},
        "StoppingCondition" -> (Last[#] === q &), RandomSeeding -> seed]},
      InfraSubstrateHighlight[g, {walk, c, q}, PlotLabel -> EdgeCount[walk]]],
    {seed, 3}]]
```

### NextVertexFunction

`RandomChoice` gives the random walk, one candidate at a time. Three independent self-avoiding runs of 12 edges:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {walks = RandomInfraWalk[g, c, {12}, 3, Properties -> {"Simple"}, "NextVertexFunction" -> RandomChoice,
    RandomSeeding -> 1]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {walk, c}], {walk, walks}]]
```

### Direction

The self-avoiding walks that add at most 2 edges to a germ of one edge, forward, backward and at both ends:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {germ = {c, First @ AdjacencyList[g, c]}},
  GraphicsRow @ Table[
    With[{walks = RandomInfraWalk[g, germ, UpTo[2], All, Properties -> {"Simple"}, "Direction" -> dir]},
      InfraSubstrateHighlight[g, {walks, germ}, PlotLabel -> Length[walks]]],
    {dir, {"Forward", "Backward", "BothSides"}}]]
```

### StoppingCondition

Stopping at the first arrival at *b*. The walks that end there are the self-avoiding walks of at most 5 edges from the centre to *b*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1]},
  {walks = RandomInfraWalk[g, c, UpTo[5], All, Properties -> {"Simple"}, "StoppingCondition" -> (Last[#] === b &)]},
  {arrived = Select[walks, Last @ Last @ VertexList @ # === b &]},
  InfraSubstrateHighlight[g, {arrived, c, b}, PlotLabel -> Length[arrived], ImageSize -> Medium]]
```

## Properties and Relations

With the hard `"Shortest"` and a stop at *b*, the walks to *b* are the shortest paths, the members of the segment:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 3]},
  {walks = RandomInfraWalk[g, c, Infinity, All, Properties -> {"Shortest"}, "StoppingCondition" -> (Last[#] === b &)]},
  Sort[Select[Last /@ VertexList[#] & /@ walks, Last[#] === b &]] === Sort @ RandomInfraSegment[g, c, b, All]]
```

Under `All` a soft rule does not change the class:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Sort @ RandomInfraWalk[g, c, {4}, All, Properties -> {"Simple", {"Shortest", 3, 0.3}}] ===
    Sort @ RandomInfraWalk[g, c, {4}, All, Properties -> {"Simple"}]]
```

## Possible Issues

The budget `Infinity` without a hard `"Simple"` or `"Shortest"`, and a bare integer as budget, leave the call unevaluated:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {Head @ RandomInfraWalk[g, c, Infinity, Properties -> {{"Simple", 2}}], Head @ RandomInfraWalk[g, c, 3]}]
```
