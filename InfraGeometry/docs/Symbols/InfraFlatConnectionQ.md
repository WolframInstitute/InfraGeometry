---
Template: Symbol
Name: InfraFlatConnectionQ
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFlatConnectionQ
Keywords: [trivial global monodromy, flat connection, horizontal leaves]
SeeAlso: [InfraConnection, InfraConnectionQ, InfraHolonomy, InfraParallelTransport, InfraFiberBundleQ]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraFlatConnectionQ]()[*fib*, *connection*]</code> tests whether a complete connection has trivial global monodromy.

<code>[InfraFlatConnectionQ]()[*fib*, {*connection1*, *connection2*, ...}]</code> tests every member of a nonempty collection.

## Details & Options

- The existing name retains its global-monodromy meaning: transport around every closed base walk must be the identity.
- Equivalently, the projection is injective on every connected component of the connection graph.
- The test includes every disconnected base component and first requires [InfraConnectionQ]().
- A graph supplies no faces, so this predicate is not a curvature test relative to a face system.
- Every complete connection over a forest has trivial monodromy.
- An empty collection returns False. The unique empty connection on a base without edges has trivial monodromy.

## Basic Examples

Two separate cycles give trivial monodromy. One cycle covering the base twice exchanges the sheets.

```wl
SeedRandom[ 1 ];
With[
  { totals = {
      Graph[ Range[ 8 ], Join[ EdgeList @ CycleGraph[ 4 ], EdgeList @ IndexGraph[ CycleGraph[ 4 ], 5 ] ] ],
      CycleGraph[ 8 ]
    } },
  { fibrations = InfraFiberedGraph[ #, vertex |-> Mod[ vertex, 4, 1 ] ] & /@ totals,
    connections = InfraConnection[ EdgeList @ # ] & /@ totals },
  { GraphicsRow @ MapThread[ InfraFiberedGraphHighlight, { fibrations, connections } ],
    MapThread[ InfraFlatConnectionQ, { fibrations, connections } ] }
]
```

## Properties and Relations

All complete connections on this path base have trivial global monodromy.

```wl
SeedRandom[ 1 ];
With[
  { fib = RandomInfraFiberedGraph[
      PathGraph[ Range[ 3 ] ], "VerticalVertexCount" -> { 2 }, "VerticalEdgeCount" -> { 0 },
      Properties -> { "IsomorphicFibers" }, "HorizontalEdgeCount" -> All, RandomSeeding -> 1] },
  { connections = RandomInfraConnection[ fib, All ] },
  { Length @ connections, InfraFlatConnectionQ[ fib, connections ] }
]
```
