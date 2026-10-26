---
Template: Symbol
Name: InfraHolonomy
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraHolonomy
Keywords: [holonomy, monodromy, permutation, connection, loop, parallel transport]
SeeAlso: [InfraConnection, InfraHorizontalLift, InfraParallelTransport, InfraTrivialMonodromyQ, InfraHolonomyAngle, RandomInfraConnection]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraHolonomy]()[*fib*, *conn*, *loop*]</code> gives the permutation of the fiber over the first vertex of *loop* made by transport along *loop* under the connection *conn*, as [Cycles]().

## Details & Options

A complete connection matches the fibers over the two ends of every base edge. Following the matchings along a closed walk *γ* from *p* maps *F(p)* to itself; this permutation is the holonomy *hol(γ)*. [InfraHorizontalLift]() gives the lifted walk from one start.

The positions in [Cycles]() refer to <code>[VertexList]()[[InfraFiber]()[*fib*, *p*]]</code>.

Holonomy respects the operations on loops:

| Loop | Holonomy |
|---|---|
| the constant loop {*p*}, or a walk out and back | the identity |
| *γ* traversed *k* times | *hol(γ)ᵏ* |
| *γ* reversed | *hol(γ)⁻¹* |
| *γ* started at another of its vertices | a conjugate of *hol(γ)* |

All holonomies are the identity exactly when [InfraTrivialMonodromyQ]() is `True`.

*conn* must be a complete connection, as [InfraConnectionQ]() tests, and *loop* a closed walk in the base. On a covering the transverse edges are the only connection.

## Basic Examples

The double cover of the cycle of length 8. Once around, the lift from the first sheet ends on the second:

```wl
With[{fib = InfraFiberedSubstrate["CycleDoubleCover", "Small"]},
  {conn = RandomInfraConnection[fib, RandomSeeding -> 1]},
  {loop = Append[Range[8], 1]},
  InfraFiberedGraphHighlight[fib, {InfraWalk @ InfraHorizontalLift[fib, conn, {1, 1}, loop]},
    PlotLabel -> InfraHolonomy[fib, conn, loop], ImageSize -> Medium]]
```

A covering of the 3 × 3 grid with three sheets, and the lift from {1, 1} around the face 1, 2, 5, 4. The label gives the holonomies of the four faces:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{3, 3}], "VerticalVertexCount" -> {3}, Properties -> {"Covering"},
    RandomSeeding -> 2]},
  {conn = RandomInfraConnection[fib, RandomSeeding -> 1]},
  {faces = {{1, 2, 5, 4, 1}, {2, 3, 6, 5, 2}, {4, 5, 8, 7, 4}, {5, 6, 9, 8, 5}}},
  InfraFiberedGraphHighlight[fib, {InfraWalk @ InfraHorizontalLift[fib, conn, {1, 1}, First @ faces]},
    PlotLabel -> (InfraHolonomy[fib, conn, #] & /@ faces), ImageSize -> Medium]]
```

## Scope

The prism and the Moebius ladder have the same base and fiber. Only the holonomy around the cycle tells them apart:

```wl
Table[
  With[{fib = InfraFiberedSubstrate[name, "Small"]},
    InfraHolonomy[fib, RandomInfraConnection[fib, RandomSeeding -> 1], Append[Range[8], 1]]],
  {name, {"CycleProductBundle", "MoebiusLadderCover"}}]
```

## Properties and Relations

On the double cover: once around exchanges the sheets, twice around and out and back do not:

```wl
With[{fib = InfraFiberedSubstrate["CycleDoubleCover", "Small"]},
  {conn = RandomInfraConnection[fib, RandomSeeding -> 1]},
  InfraHolonomy[fib, conn, #] & /@ {Append[Range[8], 1], Join[Range[8], Range[8], {1}], {1, 2, 1}, {1}}]
```

The positions refer to the vertex list of the fiber. The transport around the face is the same permutation written on vertices:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{3, 3}], "VerticalVertexCount" -> {3}, Properties -> {"Covering"},
    RandomSeeding -> 2]},
  {conn = RandomInfraConnection[fib, RandomSeeding -> 1]},
  {VertexList @ InfraFiber[fib, 1], InfraParallelTransport[fib, conn, {1, 2, 5, 4, 1}],
   InfraHolonomy[fib, conn, {1, 2, 5, 4, 1}]}]
```

## Possible Issues

A walk that does not return to its start is not a loop, and the holonomy stays unevaluated:

```wl
With[{fib = InfraFiberedSubstrate["CycleDoubleCover", "Small"]},
  Head @ InfraHolonomy[fib, RandomInfraConnection[fib, RandomSeeding -> 1], {1, 2, 3}]]
```
