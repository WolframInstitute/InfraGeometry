---
Template: Symbol
Name: RandomInfraWalk
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraWalk
Keywords: [walk, germ, self-avoiding walk, simple path, straightness, gain, turning angle, von Mises, window, energy, Boltzmann weight, random walk, stopping condition]
SeeAlso: [RandomInfraGeodesic, RandomInfraSegment, RandomInfraInfiniteLine, InfraWalk, InfraWalkQ, InfraGeodesicQ, WalkSingularities]
RelatedGuides: [EuclideanInfrageometry, RiemannianInfrageometry, InfraTopology]
---

## Usage

<code>[RandomInfraWalk]()[*g*, *germ*, *k*]</code> gives a random walk grown from *germ* in *g* by at most the budget *k* of edges, each step under the [Properties]().

<code>[RandomInfraWalk]()[*g*, *germ*, *k*, *n*]</code> gives a list of *n* distinct walks.

<code>[RandomInfraWalk]()[*g*, *germ*]</code> grows the walk with no budget, until no admissible step remains or the stopping condition fires.

## Details & Options

The germ is a vertex, a vertex list or a walk graph; a list of germs gives the walks grown from each. A walk is returned as a directed path graph on the pairs {*i*, *v*}; `Last /@ VertexList[w]` is its vertex sequence.

The budget *k* counts the edges added on each growing side: `UpTo[k]`, `{k}` (exactly *k*), `{kmin, kmax}` or `Infinity`. `Infinity` needs `"Simple"` or `"Geodesic"` on the whole walk, which bound the walks.

Each step chooses the next vertex among the neighbours of the last one, the candidates. A property is a name, bare or with its sub-options, `{"name", "Window" -> r, …}`. It reads the *window* of a candidate *v*: the last *r* vertices of the walk followed by *v*, so a window of scale *r* has *r* edges; *r* = `Infinity`, the default, is the whole walk.

| Property | Effect |
|---|---|
| `"Simple"` | no vertex twice in the window |
| `"Geodesic"` | every window a shortest path, the walks of [RandomInfraGeodesic]() |
| `{"Geodesic", "Straightness" -> β}` | each step prefers the straightest continuation: a candidate is weighed `Exp[-β Δ]`, Δ its excess energy, below |
| *f* | the energy `f[window]` ≥ 0: a candidate is weighed `Exp[-Δ]`, the scale inside *f*; `Infinity` forbids the window, and a predicate reads `True` as 0 and `False` as `Infinity`, so it is a constraint |

| Sub-option | Default | Values |
|---|---|---|
| `"Window"` | `Infinity` | a positive integer *r*, the window of scale *r* |
| `"Straightness"` | `Infinity` | on `"Geodesic"`, a non-negative number *β*; `Infinity` is the shortest path |

The properties act in the order given.

**The gain.** Let (*w*₀, …, *w*ₜ) be the window before the step, its tip *w*ₜ the last vertex of the walk. A candidate *v* changes the distance to each earlier vertex *wᵢ* by its *gain*

  *gᵢ*(*v*) = *d*(*wᵢ*, *v*) − *d*(*wᵢ*, *wₜ*) ∈ {−1, 0, 1}:

1 when *v* moves away from *wᵢ*, 0 when it keeps the distance, −1 when it comes back. The *mean gain*

  *g*(*v*) = (*g*₀(*v*) + *g*₁(*v*) + ⋯ + *g*ₜ₋₁(*v*)) / *t*

lies between −1 and 1, and is 1 exactly when *v* moves away from every earlier vertex of the window. The tip itself is left out: its gain is always 1.

**The energy and the weight.** The energy of `"Geodesic"` is *E*(*v*) = 1 − *g*(*v*), between 0 and 2, and 0 while the window is the tip alone. The excess energy of *v* is its energy against the best candidate *u* of the step,

  Δ(*v*) = *E*(*v*) − min_*u* *E*(*u*),

and the step draws *v* with probability `Exp[-β Δ(v)]` divided by the sum of `Exp[-β Δ(u)]` over the candidates: a Boltzmann weight at inverse temperature *β*. Only differences of energies matter, so ranking by the mean gain is ranking by the total distance *d*(*w*₀, *v*) + ⋯ + *d*(*w*ₜ₋₁, *v*) to the window, and the exponential is the only weight with this property. The mean, not the sum, keeps the cost of a turn independent of the length of the window.

**The turning angle.** Suppose the path distance is close to a rounding of the Euclidean one, the window is straight, and the window is not aligned with the mesh. Then for a candidate turning by the angle *θ* the mean gain is about cos *θ*: the Euclidean gain against every earlier vertex is cos *θ* up to order 1/*s*, *s* its distance to the tip, and the roundings up and down balance along the window. The weight of a step is then about `Exp[β cos θ]`, the von Mises distribution in the turning angle, and for large *β* about `Exp[-β θ^2/2]`, a Gaussian of variance 1/*β*. So *β* is a bending rigidity: turns of order 1/√*β* are typical. For a window aligned with the mesh the roundings do not balance and the mean gain is a step function of *θ*, not the cosine.

| *β* | The walk |
|---|---|
| 0 | the plain random walk: every candidate weighs alike |
| 2 | wanders, with a preference for going on |
| 8 | bends by about 20° per step |
| 32 | nearly straight |
| `Infinity`, the default | a shortest path: every step has energy 0, and the walk backtracks where no candidate has |

A walk is a shortest path at scale *r* (`InfraGeodesicQ[g, walk, r]`) exactly when every step moves away from all the earlier vertices of its window, that is when *E*(*v*) = 0 at every step: this is `"Geodesic"` with no straightness given. A large finite *β* takes such a step whenever one exists, and otherwise the least bent one.

Under `"Direction" -> "BothSides"` the window of a step is the joined walk: a step at both ends draws the new first vertex on the whole walk, then the new last vertex on the whole walk with that new first vertex, so the two halves are straight as one walk.

The gain sees shortest paths, not Euclidean straightness. On the square grid every monotone staircase is a shortest path, and a turn by 90° has gain 1 like the step straight on, so `"Geodesic"` gives a random staircase, not a straight line; a walk straight in the Euclidean sense needs a substrate whose shortest paths are straight, such as the square mesh.

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

From the random walk to a straight one: 9 edges from the centre of the square mesh at *β* = 0, 2, 8, 32 and `Infinity`:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  GraphicsRow[Table[
    InfraSubstrateHighlight[g, {RandomInfraWalk[g, c, {9}, Properties -> {"Simple", {"Geodesic", "Straightness" -> b}}, RandomSeeding -> 2], c},
      PlotLabel -> b],
    {b, {0, 2, 8, 32, Infinity}}], ImageSize -> Large]]
```

One step: a walk of 6 edges from the centre of the square mesh, its candidates for the next vertex labelled by their excess energy Δ. The candidate of Δ = 0 moves away from every earlier vertex; the other has Δ = 1 and at *β* = 8 is drawn about 3000 times less often, the factor `Exp[8]`:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {walk = Last /@ VertexList @ RandomInfraWalk[g, c, {6}, Properties -> {"Simple", {"Geodesic", "Straightness" -> 8}}, RandomSeeding -> 1]},
  {energy = w |-> If[Length[w] < 3, 0,
     1 - Mean @ Table[GraphDistance[g, w[[i]], Last[w]] - GraphDistance[g, w[[i]], w[[-2]]], {i, Length[w] - 2}]],
   candidates = Complement[AdjacencyList[g, Last[walk]], walk]},
  {excess = # - Min[#] & @ AssociationMap[v |-> energy[Append[walk, v]], candidates]},
  Graph[InfraSubstrateHighlight[g, Join[{InfraWalk[walk], c}, Thread[candidates -> StandardOrange]]],
    VertexLabels -> KeyValueMap[#1 -> Placed[Style[#2, 16, Bold], Above] &, excess], ImageSize -> Medium]]
```

## Options

### Properties

The walks of 4 edges on the grid: self-avoiding, without a step back, and all of them, *100*, *4 · 3³ = 108* and *4⁴ = 256*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium"]}, {c = First @ GraphCenter[g]},
  Table[rules -> Length @ RandomInfraWalk[g, c, {4}, All, Properties -> rules], {rules, {{"Simple"}, {{"Simple", "Window" -> 2}}, {}}}]]
```

A function is an energy. The energy 1.2 *d(v, q)* of the new vertex, at window 1, pulls a self-avoiding walk toward *q*, here at distance 5; the walk stops there. The labels are the lengths:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[c, 5], RandomSeeding -> 1]},
  GraphicsRow @ Table[
    With[{walk = RandomInfraWalk[g, c, UpTo[20], Properties -> {"Simple", {w |-> 1.2 GraphDistance[g, Last[w], q], "Window" -> 1}},
        "StoppingCondition" -> (Last[#] === q &), RandomSeeding -> seed]},
      InfraSubstrateHighlight[g, {walk, c, q}, PlotLabel -> EdgeCount[walk]]],
    {seed, 3}]]
```

A window of scale 3 asks for a shortest path at scale 3 only; the walk is a shortest path at scale 3 and bends at larger scales:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {walk = RandomInfraWalk[g, c, {9}, Properties -> {"Simple", {"Geodesic", "Window" -> 3}}, RandomSeeding -> 1]},
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

At both ends the straightness reads the joined walk: 8 edges on each side of the centre of the square mesh at *β* = 32 make one nearly straight walk of 16 edges; the label is the distance of its ends:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {walk = RandomInfraWalk[g, c, {8}, Properties -> {"Simple", {"Geodesic", "Straightness" -> 32}}, "Direction" -> "BothSides", RandomSeeding -> 2]},
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

The straightness of `"Geodesic"` is the energy 1 − *g*(*v*), one minus the mean gain, written out as a user energy scaled by *β*, walk for walk:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium"]}, {c = First @ GraphCenter[g]},
  {energy = w |-> If[Length[w] < 3, 0,
     1 - Mean @ Table[GraphDistance[g, w[[i]], Last[w]] - GraphDistance[g, w[[i]], w[[-2]]], {i, Length[w] - 2}]]},
  Table[RandomInfraWalk[g, c, {10}, Properties -> {{"Geodesic", "Straightness" -> 2}}, RandomSeeding -> s] ===
    RandomInfraWalk[g, c, {10}, Properties -> {w |-> 2 energy[w]}, RandomSeeding -> s], {s, 5}]]
```

A walk is a shortest path exactly when every step has energy 0. At the large *β* = 1000 on the mesh some walks of 10 edges from the centre are, and some meet a vertex where no candidate has energy 0; the pairs agree. The bare `"Geodesic"` keeps only the first, the walks of [RandomInfraGeodesic]():

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Large"]}, {c = First @ GraphCenter[g]},
  {energy = w |-> If[Length[w] < 3, 0,
     1 - Mean @ Table[GraphDistance[g, w[[i]], Last[w]] - GraphDistance[g, w[[i]], w[[-2]]], {i, Length[w] - 2}]]},
  Table[With[{w = Last /@ VertexList @ RandomInfraWalk[g, c, {10}, Properties -> {"Simple", {"Geodesic", "Straightness" -> 1000}}, RandomSeeding -> s]},
    {AllTrue[Table[energy @ Take[w, k], {k, 2, Length[w]}], # == 0 &], InfraGeodesicQ[g, w]}], {s, 6}]]
```

Under `All` a finite *β* does not change the class:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Sort @ RandomInfraWalk[g, c, {4}, All, Properties -> {"Simple", {"Geodesic", "Window" -> 3, "Straightness" -> 1.2}}] ===
    Sort @ RandomInfraWalk[g, c, {4}, All, Properties -> {"Simple"}]]
```

## Possible Issues

On the square grid every monotone staircase is a shortest path, so the walks of `"Geodesic"` are random staircases:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  GraphicsRow @ Table[
    With[{walk = RandomInfraWalk[g, c, {8}, Properties -> {"Simple", "Geodesic"}, RandomSeeding -> s]},
      InfraSubstrateHighlight[g, {walk, c}, PlotLabel -> InfraGeodesicQ[g, walk]]],
    {s, 3}]]
```

The budget `Infinity` without `"Simple"` or `"Geodesic"` on the whole walk, and a bare integer as budget, leave the call unevaluated:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {Head @ RandomInfraWalk[g, c, Infinity, Properties -> {{"Geodesic", "Straightness" -> 5}}], Head @ RandomInfraWalk[g, c, 3]}]
```

A property outside this grammar leaves the call unevaluated, such as the window written as a second entry:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Head @ RandomInfraWalk[g, c, {6}, Properties -> {{"Simple", 2}}]]
```
