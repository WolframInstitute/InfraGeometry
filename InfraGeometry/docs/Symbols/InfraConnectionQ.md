---
Template: Symbol
Name: InfraConnectionQ
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraConnectionQ
Keywords: [connection, perfect matching, lift, predicate]
SeeAlso: [InfraConnection, RandomInfraConnection, InfraHorizontalLift, InfraFlatConnectionQ, FindInfraLeviCivitaConnection]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraConnectionQ]()[*fib*, *conn*]</code> gives [True]() if *conn* is a connection of the fibered graph *fib*: over every base edge its edges match the two fibers one to one.

<code>[InfraConnectionQ]()[*fib*, {*conn1*, *conn2*, …}]</code> gives [True]() if every *connᵢ* is a connection of *fib*.

## Details & Options

<code>[InfraConnection]()[*H*]</code> is a connection of *fib* when every edge of *H* is a total edge between two different fibers, and every total vertex over *p* has exactly one *H*-neighbour over each base neighbour of *p*.

The matching must cover the whole fibers. Matching only the total vertices that have a lift is not enough, and adjacent fibers of different sizes admit no connection.

The empty list gives [False](). <code>[InfraConnection]()[{}]</code> is a connection exactly when the base has no edges.

## Basic Examples

A random connection over the square grid, and the same edges without the two over the base edge 45 – 46 at the centre. Then four total vertices have no lift over that edge:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {xy = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {fib = RandomInfraFiberedGraph[g, "VerticalVertexCount" -> {2}, "HorizontalEdgeCount" -> All, RandomSeeding -> 1]},
  {conn = RandomInfraConnection[fib, RandomSeeding -> 1]},
  GraphicsRow @ Table[
    InfraFiberedGraphHighlight[fib, {h}, "BaseVertexCoordinates" -> xy, PlotLabel -> InfraConnectionQ[fib, h]],
    {h, {conn, InfraConnection @ Select[First @ conn, Sort[First /@ List @@ #] =!= {45, 46} &]}}]]
```

The Levi-Civita connection of the displacement bundle is not a connection on the square grid, where the fibers at the rim have one vertex and the others four. On the square torus, with no rim, it is:

```wl
Table[
  With[{fib = InfraDisplacementBundle[InfraSubstrate[name, "Small"], 1]},
    InfraConnectionQ[fib, FindInfraLeviCivitaConnection[fib]]],
  {name, {"SquareGridGraph", "SquareTorusGraph"}}]
```

## Scope

A list of connections is tested member by member:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {fib = RandomInfraFiberedGraph[g, "VerticalVertexCount" -> {2}, "HorizontalEdgeCount" -> All, RandomSeeding -> 1]},
  {InfraConnectionQ[fib, RandomInfraConnection[fib, 3, RandomSeeding -> 1]], InfraConnectionQ[fib, {}]}]
```

## Possible Issues

Two fibers of two vertices joined by a single edge. The edge is a matching that covers every total vertex with a lift, but not the whole fibers, so it is not a connection, and no connection exists:

```wl
With[{fib = InfraFiberedGraph[Graph[Range[4], {1 <-> 3}], <|1 -> "p", 2 -> "p", 3 -> "q", 4 -> "q"|>]},
  {InfraConnectionQ[fib, InfraConnection[{1 <-> 3}]], RandomInfraConnection[fib, All]}]
```
