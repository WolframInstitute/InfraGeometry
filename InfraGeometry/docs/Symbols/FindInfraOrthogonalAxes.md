---
Template: Symbol
Name: FindInfraOrthogonalAxes
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraOrthogonalAxes
Keywords: [orthogonal axes, perpendicular lines, frame, projection test, clique, coordinatized dimension, vertex list]
SeeAlso: [FindInfraOrthogonalRays, OrthogonalCoordinates, InfraPerpendicularQ, FindInfraPerpendicular, RandomInfraLine, FindInfraSpanningAxes, InfraFibration, InfraSubstrateHighlight]
RelatedGuides: [Experimental]
---

## Usage

<code>[FindInfraOrthogonalAxes]()[*g*, *c*, *len*]</code> gives one maximal set of mutually perpendicular shortest path lines through the vertex *c*, each a vertex list, the straightest set first.

<code>[FindInfraOrthogonalAxes]()[*g*, *c*, *len*, *n*]</code> gives a `List` of exactly *n* such sets or `{}`; `UpTo[n]` gives up to *n*; `All` gives every one.

## Details & Options

The problem is well posed. Fix a graph *g*, a vertex *c* and a length *len*.

- An **axis** at *c* is a shortest path through *c*, a vertex list whose two halves from *c* have lengths in *len*, maximal there: neither end extends by one step to a longer shortest path through *c* inside *len*. The axes form a finite set, since a shortest path of the range lies in the ball of radius *r* about *c*, *r* the largest half-length; for `All` it is the whole component of *c*.
- Two axes are **perpendicular** when the shortest-path projection of every vertex of each onto the other is *c*: every vertex of one has *c* as its only nearest vertex on the other. On the distance matrix this is `d(v, w) > Max[d(c, v), d(c, w)]` for every vertex *v* of one and *w* of the other, both different from *c*. The test is exact, symmetric and does not depend on the order of the axes.
- Perpendicularity is a symmetric relation on a finite set, so the sets of mutually perpendicular axes are the cliques of a finite graph. The largest number of mutually perpendicular lines through *c* is its clique number, and a maximal set cannot be extended by one more axis. The call returns maximal sets; the largest of them is the largest of `All`. On `GridGraph[{5, ..., 5}]` at its centre the largest set has *d* axes, the dimension.
- A bent shortest path through *c* is an axis too, so the sets of `All` include crosses that turn at *c*. They are ranked after the straight one: a longer axis first, then fewer vertices in the shortest path interval of its ends, which is the axis itself exactly when the shortest path is unique, as the straight lines of a grid are. The count-less call and `n = 1` give the first set in that order.
- *len* is `All`, an integer *k* (both halves of length *k*), `UpTo[k]` (each half between 1 and *k*) or `{min, max}` (each half between *min* and *max*, `max` may be `Infinity`). The halves of an axis need not be equal. Each axis is maximal inside the range, so `All` never returns a sub-line of a line.
- *c* is a vertex, or an association `<| v1 -> w1, ... |>` for a point realised by several vertices: the search is run from each *v* on one ball, a set belongs to one anchor, and the duplicates are dropped.
- The count-less call gives one set, a list of vertex lists; a count gives a list of sets. A vertex without a through-line, a path endpoint or a leaf, has no axis: the call gives `{}`. The rays from such a vertex are [FindInfraOrthogonalRays]().
- One `GraphDistanceMatrix` on the ball of radius 2 *r* about *c* is read; no path is searched per candidate.

| Option | Default | Values |
|---|---|---|
| `Properties` | `Automatic` | the class of admissible next axes |
| `"NextVertexFunction"` | `Identity` | the order the candidates are tried in |
| `"AxisCount"` | `Automatic` | the number of axes in a set |

`Properties -> Automatic` is the exact projection test above. A string or `{string, opts}` names a `Method` of [InfraPerpendicularQ](), checked between the candidate and every axis already chosen; any other value *f* is a predicate on the list of the chosen axes plus the candidate, so `Properties -> (Length[#] <= 1 &)` admits no pair.

`"NextVertexFunction" -> f` turns the ranked candidates into the order they are tried in. `Identity` keeps the ranking; `RandomSample` and any permutation change the order but not the class, so `All` is the same set of sets; `RandomChoice` draws one candidate, so the count-less call is a random maximal set; `(RandomSample[#, UpTo[k]] &)` prunes to *k* candidates per node and so returns some of the maximal sets.

`"AxisCount" -> k` keeps the sets of exactly *k* axes, `UpTo[k]` the sets of *k* axes or fewer if maximal, `All` every clique of any size, `Automatic` the maximal ones.

## Basic Examples

The straight cross through the centre of the square tiling, two axes of 4 steps on each side.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {axes = FindInfraOrthogonalAxes[g, c, 4]},
  {InfraSubstrateHighlight[g, Append[axes, {c}]], axes}]
```

The same call on the cubic grid gives three axes, and on the 4-dimensional grid four: the dimension.

```wl
Length @ FindInfraOrthogonalAxes[GridGraph[Table[5, #]], Ceiling[5^# / 2], 2] & /@ {2, 3, 4}
```

The first three of the maximal sets at scale 2 on the 9 x 9 grid: the straight cross, then two crosses that turn at the centre.

```wl
With[
  {g = GridGraph[{9, 9}]},
  GraphicsRow[InfraSubstrateHighlight[g, Append[#, {41}]] & /@ FindInfraOrthogonalAxes[g, 41, 2, 3]]]
```

## Scope

A length is an integer, `UpTo[k]`, `{min, max}` or `All`. On a bounded grid `All` reaches the walls, and a straight line through the centre extends by a turn, so only corner-to-corner shortest paths are maximal.

```wl
With[
  {g = GridGraph[{9, 9}]},
  GraphicsRow @ Table[
    Labeled[InfraSubstrateHighlight[g, Append[FindInfraOrthogonalAxes[g, 41, len], {41}]], len],
    {len, {2, 4, All}}]]
```

Halves of different lengths: at least 2 and at most 4 steps on each side of the centre.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {axes = FindInfraOrthogonalAxes[g, c, {2, 4}]},
  InfraSubstrateHighlight[g, Append[axes, {c}]]]
```

A point realised by two vertices: the centre is an association, and each axis passes through one of them.

```wl
With[
  {g = GridGraph[{6, 6}]},
  {sets = FindInfraOrthogonalAxes[g, <|14 -> 1, 23 -> 1|>, 2, All]},
  {GraphicsRow[InfraSubstrateHighlight[g, Append[#, {14, 23}]] & /@ Take[sets, 3]], Length @ sets}]
```

A vertex of a path has an axis only when it is interior; the endpoint has none, and its rays are [FindInfraOrthogonalRays]().

```wl
{FindInfraOrthogonalAxes[PathGraph[Range[5]], 3, All], FindInfraOrthogonalAxes[PathGraph[Range[5]], 1, All]}
```

## Options

### Properties

The exact test is the default. The `"Projection"` method of [InfraPerpendicularQ]() is a relaxation: two lines meeting only at *c* pass it, so the straight cross takes four bent axes along (right), where the exact test keeps the cross alone (left).

```wl
With[
  {g = GridGraph[{5, 5}]},
  {sets = {FindInfraOrthogonalAxes[g, 13, 2], FindInfraOrthogonalAxes[g, 13, 2, Properties -> "Projection"]}},
  GraphicsRow[InfraSubstrateHighlight[g, Append[#, {13}]] & /@ sets]]
```

A predicate on the chosen axes plus the candidate: here at most one axis, so every set is a single axis, and the number of sets is the number of maximal axes.

```wl
With[
  {sets = FindInfraOrthogonalAxes[GridGraph[{5, 5}], 13, 2, All, Properties -> (Length[#] <= 1 &)]},
  {Length @ sets, Union[Length /@ sets]}]
```

### NextVertexFunction

`RandomChoice` draws the candidates at random, so the count-less call is a random maximal set. Three draws at scale 2 on the 9 x 9 grid.

```wl
With[
  {g = GridGraph[{9, 9}]},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g,
      Append[(SeedRandom[seed]; FindInfraOrthogonalAxes[g, 41, 2, "NextVertexFunction" -> RandomChoice]), {41}]],
    {seed, 3}]]
```

A pruning to one candidate per node returns some maximal sets, a sample of `All`.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {all = FindInfraOrthogonalAxes[g, 41, 2, All]},
  {sample = (SeedRandom[1]; FindInfraOrthogonalAxes[g, 41, 2, All, "NextVertexFunction" -> (RandomSample[#, UpTo[1]] &)])},
  {Length @ all, Length @ sample, SubsetQ[all, sample]}]
```

### AxisCount

The sets of exactly one axis: every single axis of scale 2 that is maximal, the bent ones included, 30 on the 5 x 5 grid at its centre.

```wl
With[
  {g = GridGraph[{5, 5}]},
  {single = FindInfraOrthogonalAxes[g, 13, 2, All, "AxisCount" -> 1]},
  {GraphicsRow[InfraSubstrateHighlight[g, Append[#, {13}]] & /@ Take[single, 3]], Length @ single}]
```

## Properties and Relations

Two axes of a set are perpendicular by the exact test, and the set is maximal: no axis of the range can be added to it.

```wl
With[
  {g = GridGraph[{9, 9}], c = 41},
  {sets = FindInfraOrthogonalAxes[g, c, 2, All]},
  {perpendicular = ({a, b} |-> And @@ Flatten @ Table[
      GraphDistance[g, v, w] > Max[GraphDistance[g, c, v], GraphDistance[g, c, w]],
      {v, DeleteCases[a, c]}, {w, DeleteCases[b, c]}])},
  {AllTrue[sets, set |-> AllTrue[Subsets[set, {2}], perpendicular @@ # &]], Max[Length /@ sets]}]
```

[OrthogonalCoordinates]() reads the axes as coordinate lines. On the straight cross of the 9 x 9 grid the coordinates are a bijection onto the grid `{-4, ..., 4}^2`, so [InfraFibration]() of the grid over them has the grid as its base.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {axes = FindInfraOrthogonalAxes[g, 41, 4]},
  {fib = InfraFibration[g, OrthogonalCoordinates[g, 41, axes]]},
  {GraphicsRow[{InfraSubstrateHighlight[g, Append[axes, {41}]], InfraBaseGraph[fib]}], VertexCount @ InfraBaseGraph[fib]}]
```

An axis splits at *c* into two rays: the straight cross of the 9 x 9 grid is two axes, and the same frame is four rays.

```wl
With[
  {g = GridGraph[{9, 9}]},
  Length /@ {FindInfraOrthogonalAxes[g, 41, 3], FindInfraOrthogonalRays[g, 41, 3]}]
```

## Possible Issues

The number of candidates grows like the shortest paths from *c*, not like the vertices. `FindInfraOrthogonalAxes[GridGraph[{30, 30}], 465, 10]` takes about two minutes, where the coordinates of the same grid take a fraction of a second: take a short length, or `UpTo[1]` sets, and fix the scale by the question.

A bent axis is maximal on its own. The strict test requires that *c* be the only nearest vertex, so a bent axis has no perpendicular partner, and `All` lists it as a set of one axis, ranked after the straight cross.

The projection test does not tell a right angle from a straight angle: on the grid `d((2, 0), (0, 2)) = 4 = d((2, 0), (-2, 0))`. The axes of a set are therefore lines, not rays; the rays of a frame are read through their opposites, see [FindInfraOrthogonalRays]().
