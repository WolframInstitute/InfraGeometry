---
Template: Symbol
Name: InfraParallelTransport
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraParallelTransport
Keywords: [parallel transport, fiber bijection, connection, walk]
SeeAlso: [InfraConnection, InfraConnectionQ, InfraHorizontalLift, InfraHolonomy, InfraParallelSectionQ, InfraHolonomyAngle, FindInfraLeviCivitaConnection]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraParallelTransport]()[*fib*, *conn*, *walk*]</code> gives the parallel transport along the base walk *walk* for the connection *conn*: the association from each vertex of the first fiber to the end of its horizontal lift.

<code>[InfraParallelTransport]()[[InfraDisplacementBundle]()[*g*, *r*], *walk*]</code> gives the list of Levi-Civita transports along *walk* in the displacement bundle of *g* at scale *r*.

<code>[InfraParallelTransport]()[[InfraDisplacementBundle]()[*g*, *r*], *conn*, *walk*]</code> gives the transport along *walk* for a partial connection *conn* of the displacement bundle, leaving out the directions whose lift is blocked.

## Details & Options

For a walk *γ* from *p* to *q* the transport is the map *τ_γ : Fₚ → F_q* sending *x* to the end of the horizontal lift of *γ* from *x*. For a complete connection it is a bijection.

Transport composes along walks, *τ_{γδ} = τ_δ ∘ τ_γ*; the reversed walk gives the inverse map, and a walk of length 0 the identity. Transports along two walks with the same ends differ iff the loop formed by them has a nontrivial holonomy.

The connection must satisfy [InfraConnectionQ](). Otherwise the call stays unevaluated.

In the displacement bundle at scale *r* the fiber over *p* is the sphere *Sᵣ(p)*. Over each step *p → q*, the Levi-Civita transports are the injections *Sᵣ(p) → Sᵣ(q)* that best preserve the angles between directions, with the directions along a geodesic through *q* sent to their straightest continuation. There are usually several; the result lists every composite along the walk.

Option of the displacement-bundle form:

| Option | Default | Values |
|---|---|---|
| [Method]() | `"Arclength"` | `"Arclength"` compares angles by distances around the punctured ball, `"Alexandrov"` by the polar form *(d(p,u)² + d(p,w)² − d(u,w)²)/2* |

## Basic Examples

A random double covering of the 4 × 4 grid. Transport around the square 6, 7, 11, 10 exchanges the two vertices of the fiber over 6:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}],
    Properties -> {"Covering"}, "VerticalVertexCount" -> {2}, RandomSeeding -> 1]},
  {conn = RandomInfraConnection[fib, RandomSeeding -> 1]}, {loop = {6, 7, 11, 10, 6}},
  InfraFiberedGraphHighlight[fib, InfraWalk[InfraHorizontalLift[fib, conn, #, loop]] & /@ {{6, 1}, {6, 2}},
    PlotLabel -> InfraParallelTransport[fib, conn, loop], ImageSize -> Medium]]
```

So the transports from 6 to 11 along the two sides of the square differ:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}],
    Properties -> {"Covering"}, "VerticalVertexCount" -> {2}, RandomSeeding -> 1]},
  {conn = RandomInfraConnection[fib, RandomSeeding -> 1]},
  {InfraParallelTransport[fib, conn, {6, 7, 11}], InfraParallelTransport[fib, conn, {6, 10, 11}]}]
```

## Scope

The displacement bundle of the 4 × 4 grid at scale 1, its fibers the four directions at a vertex. The Levi-Civita transports over the step from 6 to 7:

```wl
InfraParallelTransport[InfraDisplacementBundle[GridGraph[{4, 4}], 1], {6, 7}]
```

With the Levi-Civita connection of the grid, transport around a square is the identity:

```wl
With[{fib = InfraDisplacementBundle[GridGraph[{4, 4}], 1]},
  InfraParallelTransport[fib, FindInfraLeviCivitaConnection[fib], {6, 7, 11, 10, 6}]]
```

## Options

### Method

The polar form matches more injections over the same step:

```wl
With[{fib = InfraDisplacementBundle[GridGraph[{4, 4}], 1]},
  Length /@ {InfraParallelTransport[fib, {6, 7}], InfraParallelTransport[fib, {6, 7}, Method -> "Alexandrov"]}]
```

## Properties and Relations

The reversed walk gives the inverse map, and a walk of length 0 the identity:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}], "VerticalVertexCount" -> {2}, "HorizontalEdgeCount" -> All,
    RandomSeeding -> 1]}, {conn = RandomInfraConnection[fib, RandomSeeding -> 1]},
  {forward = InfraParallelTransport[fib, conn, {6, 7, 11, 12}],
   backward = InfraParallelTransport[fib, conn, {12, 11, 7, 6}]},
  {Lookup[backward, Key /@ Values[forward]] === Keys[forward], InfraParallelTransport[fib, conn, {6}]}]
```

Transport along a walk is the composite of the transports along its parts:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}], "VerticalVertexCount" -> {2}, "HorizontalEdgeCount" -> All,
    RandomSeeding -> 1]}, {conn = RandomInfraConnection[fib, RandomSeeding -> 1]},
  {first = InfraParallelTransport[fib, conn, {6, 7, 11}],
   second = InfraParallelTransport[fib, conn, {11, 12, 16}]},
  Lookup[second, Key /@ Values[first]] === Values[InfraParallelTransport[fib, conn, {6, 7, 11, 12, 16}]]]
```

## Possible Issues

A partial matching is not a complete connection. The call stays unevaluated:

```wl
With[{fib = InfraFiberedGraph[Graph[Range[4], {UndirectedEdge[1, 3]}],
    <|1 -> "p", 2 -> "p", 3 -> "q", 4 -> "q"|>]},
  Head @ InfraParallelTransport[fib, InfraConnection[{UndirectedEdge[1, 3]}], {"p", "q"}]]
```
