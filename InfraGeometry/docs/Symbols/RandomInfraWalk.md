---
Template: Symbol
Name: RandomInfraWalk
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraWalk
Keywords: [walk, germ, self-avoiding walk, simple path, straightness, defect, window, energy, Boltzmann weight, random walk, stopping condition]
SeeAlso: [RandomInfraGeodesic, RandomInfraSegment, RandomInfraInfiniteLine, InfraWalk, InfraWalkQ, InfraGeodesicQ, WalkSingularities]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraWalk]()[*g*, *germ*, *k*]</code> gives a random walk grown from *germ* in *g* by at most the budget *k* of edges, each step under the [Properties]().

<code>[RandomInfraWalk]()[*g*, *germ*, *k*, *n*]</code> gives a list of *n* distinct walks.

<code>[RandomInfraWalk]()[*g*, *germ*]</code> grows the walk with no budget, until no admissible step remains or the stopping condition fires.

## Details & Options

The germ is a vertex, a vertex list or a walk graph; a list of germs gives the walks grown from each. A walk is returned as a directed path graph on the pairs {*i*, *v*}; `Last /@ VertexList[w]` is its vertex sequence.

The budget *k* counts the edges added on each growing side: `UpTo[k]`, `{k}` (exactly *k*), `{kmin, kmax}` or `Infinity`. `Infinity` needs the bare `"Simple"`, which bounds the walks.

Each step chooses the next vertex among the neighbours of the last one, the candidates. A property reads the *window* of a candidate *v*: the last *r* vertices of the walk followed by *v*, so a window of scale *r* has *r* edges; *r* = `Infinity`, the default, is the whole walk.

| Property | Effect |
|---|---|
| `"Simple"` | no vertex twice; `{"Simple", r}` no vertex twice within the window, `{"Simple", r, p}` a repeat weighed *p* instead of forbidden |
| `"Straightness" -> β` | each step prefers the straightest continuation: a candidate is weighed `Exp[-β Δ]`, Δ its excess defect, below |
| `"Straightness" -> {β, r}` | the same on the window of scale *r* |
| *f* `-> β`, *f* `-> {β, r}` | the energy `f[window]` ≥ 0 in place of the defect; `Infinity` forbids the window, and a predicate reads `True` as 0 and `False` as `Infinity` |

*β* is a non-negative number or `Infinity`. The properties act in the order given.

**The defect.** For a window *w* = (*w*₁, …, *w*ₘ) the piece from *wᵢ* to the end has *m* − *i* edges, and its defect

  *Dᵢ*(*w*) = (*m* − *i*) − *d*(*wᵢ*, *wₘ*)

is the number of edges it wastes against a shortest path: 0 exactly when that piece is a shortest path. The defect of the window is the sum over its vertices,

  *D*(*w*) = *D*₁(*w*) + *D*₂(*w*) + ⋯ + *D*ₘ₋₁(*w*),

0 exactly when the window is a shortest path, and positive for a bend at any scale up to *r*.

**The excess defect.** Appending a candidate *v* to the window changes the term of each earlier vertex *wᵢ* by 0 when *v* is farther from *wᵢ* than the last vertex is, by 1 when it is as far, and by 2 when it is nearer. The excess defect of *v* is its defect against the best candidate *u* of the step,

  Δ(*v*) = *D*(*w* + *v*) − min_*u* *D*(*w* + *u*),

so Δ counts, against the best candidate, the earlier vertices of the window that the step does not move away from. The step draws *v* with probability `Exp[-β Δ(v)]` divided by the sum of `Exp[-β Δ(u)]` over the candidates: a Boltzmann weight at inverse temperature *β*.

| *β* | The walk |
|---|---|
| 0 | the plain random walk: every candidate weighs alike |
| 1 | wanders, with a preference for going on |
| 5 | nearly straight |
| `Infinity` | always a candidate of Δ = 0; straightness never ends the walk, since some candidate always has Δ = 0 |

A walk is a shortest path at scale *r* (`InfraGeodesicQ[g, walk, r]`) exactly when every step moves away from all the earlier vertices of its window, that is when *D*(*w* + *v*) = 0 at every step; at *β* = `Infinity` the walk takes such a step whenever one exists.

Under `"Direction" -> "BothSides"` the window of a step is the joined walk: a step at both ends draws the new first vertex on the whole walk, then the new last vertex on the whole walk with that new first vertex, so the two halves are straight as one walk.

The defect sees shortest paths, not Euclidean straightness. On the square grid every monotone staircase is a shortest path, so at *β* = `Infinity` the walk is a random staircase, not a straight line; a walk straight in the Euclidean sense needs a substrate whose shortest paths are straight, such as the square mesh.

Options:

| Option | Default | Values |
|---|---|---|
| [Properties]() | `{}` | the list of properties; `{}` allows every walk |
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

A candidate whose weight is below `$MachineEpsilon` times the number of candidates, relative to the best, is never drawn; `RandomSample` tries it after the others. Under `All` a finite *β* changes the order of the walks, not the class. A walk also stops when the budget is spent or no candidate is left.

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

From the random walk to a straight one: 9 edges from the centre of the square mesh at *β* = 0, 1, 5 and `Infinity`:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  GraphicsRow[Table[
    InfraSubstrateHighlight[g, {RandomInfraWalk[g, c, {9}, Properties -> {"Simple", "Straightness" -> b}, RandomSeeding -> 2], c},
      PlotLabel -> b],
    {b, {0, 1, 5, Infinity}}], ImageSize -> Large]]
```

One step: a walk of 6 edges from the centre of the square mesh, its candidates for the next vertex labelled by their excess defect Δ. The two candidates of Δ = 0 move away from every earlier vertex; at *β* = 1 the one of Δ = 3 is drawn *e*³ ≈ 20 times less often:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {walk = Last /@ VertexList @ RandomInfraWalk[g, c, {6}, Properties -> {"Simple", "Straightness" -> 1}, RandomSeeding -> 1]},
  {defect = w |-> Total @ Table[(Length[w] - i) - GraphDistance[g, w[[i]], Last[w]], {i, Length[w] - 1}],
   candidates = Complement[AdjacencyList[g, Last[walk]], walk]},
  {excess = # - Min[#] & @ AssociationMap[v |-> defect[Append[walk, v]], candidates]},
  Graph[InfraSubstrateHighlight[g, Join[{InfraWalk[walk], c}, Thread[candidates -> StandardOrange]]],
    VertexLabels -> KeyValueMap[#1 -> Placed[Style[#2, 16, Bold], Above] &, excess], ImageSize -> Medium]]
```

## Options

### Properties

The walks of 4 edges on the grid: self-avoiding, without a step back, and all of them, *100*, *4 · 3³ = 108* and *4⁴ = 256*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium"]}, {c = First @ GraphCenter[g]},
  Table[rules -> Length @ RandomInfraWalk[g, c, {4}, All, Properties -> rules], {rules, {{"Simple"}, {{"Simple", 2}}, {}}}]]
```

A function is an energy. The energy *d(v, q)* of the new vertex, at window 1 and *β* = 1.2, pulls a self-avoiding walk toward *q*, here at distance 5; the walk stops there. The labels are the lengths:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[c, 5], RandomSeeding -> 1]},
  GraphicsRow @ Table[
    With[{walk = RandomInfraWalk[g, c, UpTo[20], Properties -> {"Simple", (w |-> GraphDistance[g, Last[w], q]) -> {1.2, 1}},
        "StoppingCondition" -> (Last[#] === q &), RandomSeeding -> seed]},
      InfraSubstrateHighlight[g, {walk, c, q}, PlotLabel -> EdgeCount[walk]]],
    {seed, 3}]]
```

A window of scale 3 asks for straightness at scale 3 only; the walk is a shortest path at scale 3 and bends at larger scales:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {walk = RandomInfraWalk[g, c, {9}, Properties -> {"Simple", "Straightness" -> {Infinity, 3}}, RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {walk, c}, PlotLabel -> {InfraGeodesicQ[g, walk, 3], InfraGeodesicQ[g, walk]}, ImageSize -> Medium]]
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

At both ends the straightness reads the joined walk: 8 edges on each side of the centre of the square mesh at *β* = 5 make one nearly straight walk of 16 edges; the label is the distance of its ends:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {walk = RandomInfraWalk[g, c, {8}, Properties -> {"Simple", "Straightness" -> 5}, "Direction" -> "BothSides", RandomSeeding -> 2]},
  InfraSubstrateHighlight[g, {walk, c}, PlotLabel -> GraphDistance[g, First @ #, Last @ #] & @ (Last /@ VertexList[walk]),
    ImageSize -> Medium]]
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

`"Straightness"` is the summed defect *D* as an energy, walk for walk:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium"]}, {c = First @ GraphCenter[g]},
  {defect = w |-> Total @ Table[(Length[w] - i) - GraphDistance[g, w[[i]], Last[w]], {i, Length[w] - 1}]},
  Table[RandomInfraWalk[g, c, {10}, Properties -> {"Straightness" -> 2}, RandomSeeding -> s] ===
    RandomInfraWalk[g, c, {10}, Properties -> {defect -> 2}, RandomSeeding -> s], {s, 5}]]
```

A walk is a shortest path exactly when every step has defect 0. At *β* = `Infinity` on the mesh some walks of 10 edges from the centre are, and some meet a vertex where no candidate has defect 0; the pairs agree. The exact shortest paths from a germ are [RandomInfraGeodesic]():

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Large"]}, {c = First @ GraphCenter[g]},
  {defect = w |-> Total @ Table[(Length[w] - i) - GraphDistance[g, w[[i]], Last[w]], {i, Length[w] - 1}]},
  Table[With[{w = Last /@ VertexList @ RandomInfraWalk[g, c, {10}, Properties -> {"Simple", "Straightness" -> Infinity}, RandomSeeding -> s]},
    {AllTrue[Table[defect @ Take[w, k], {k, 2, Length[w]}], # == 0 &], InfraGeodesicQ[g, w]}], {s, 6}]]
```

Under `All` a finite *β* does not change the class:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Sort @ RandomInfraWalk[g, c, {4}, All, Properties -> {"Simple", "Straightness" -> {1.2, 3}}] ===
    Sort @ RandomInfraWalk[g, c, {4}, All, Properties -> {"Simple"}]]
```

## Possible Issues

On the square grid every monotone staircase is a shortest path, so the straightest walks at *β* = `Infinity` are random staircases; each of these is a shortest path:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  GraphicsRow @ Table[
    With[{walk = RandomInfraWalk[g, c, {8}, Properties -> {"Simple", "Straightness" -> Infinity}, RandomSeeding -> s]},
      InfraSubstrateHighlight[g, {walk, c}, PlotLabel -> InfraGeodesicQ[g, walk]]],
    {s, 3}]]
```

The budget `Infinity` without the bare `"Simple"`, and a bare integer as budget, leave the call unevaluated:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {Head @ RandomInfraWalk[g, c, Infinity, Properties -> {"Straightness" -> 5}], Head @ RandomInfraWalk[g, c, 3]}]
```

The rules `{"Shortest", r, p}` and `"Stretched"` of earlier versions are refused with the property that replaces them:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Head @ RandomInfraWalk[g, c, {6}, Properties -> {"Simple", {"Shortest", 5, 0.3}}]]
```
