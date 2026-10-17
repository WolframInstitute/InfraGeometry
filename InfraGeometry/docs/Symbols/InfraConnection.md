---
Template: Symbol
Name: InfraConnection
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraConnection
Keywords: [connection, perfect matching, horizontal edge, inert object]
SeeAlso: [InfraConnectionQ, RandomInfraConnection, InfraHorizontalLift, InfraParallelTransport, InfraHolonomy, InfraFlatConnectionQ]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[InfraConnection]()[*edges*]</code> is an inert description of horizontal edges chosen for transport in a fibered graph.

## Details & Options

- The head carries no graph. Readers receive the fibered graph as a separate argument.
- A complete connection chooses a perfect matching between the whole fibers over each base edge. It contains no vertical edges.
- [InfraConnectionQ]() checks this condition, including total vertices with no available transverse edge.
- The order and orientation of the undirected edges do not affect the connection. Repeated edges are not a matching.
- <code>[Graph]()[[VertexList]()[[InfraTotalGraph]()[*fib*]], *edges*]</code> gives its graph. Its connected components are the horizontal leaves.
- Connections are supported on finite simple undirected unweighted total graphs.

## Basic Examples

A double covering of a square has one horizontal leaf. A circuit around the square exchanges its two sheets.

```wl
SeedRandom[ 1 ];
With[
  { total = CycleGraph[ 8 ] },
  { fib = InfraFibration[ total, vertex |-> Mod[ vertex, 4, 1 ] ] },
  { connection = InfraConnection[ EdgeList @ total ] },
  { InfraFiberedGraphHighlight[ fib, connection ],
    InfraConnectionQ[ fib, connection ],
    InfraHolonomy[ fib, connection, { 1, 2, 3, 4, 1 } ] }
]
```

## Properties and Relations

An isolated base vertex needs no horizontal edges. The empty edge set can therefore be a complete connection.

```wl
SeedRandom[ 1 ];
With[
  { fib = InfraFibration[ Graph[ { 1, 2 }, { } ], <| 1 -> "p", 2 -> "p" |> ] },
  { InfraConnectionQ[ fib, InfraConnection[ { } ] ],
    InfraParallelTransport[ fib, InfraConnection[ { } ], { "p" } ] }
]
```
