---
Template: Symbol
Name: InfraConnectionQ
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraConnectionQ
Keywords: [complete connection, perfect matching, lift, predicate]
SeeAlso: [InfraConnection, RandomInfraConnection, InfraHorizontalLift, InfraFlatConnectionQ, InfraParallelSectionQ]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraConnectionQ]()[*fib*, *connection*]</code> tests whether *connection* gives a perfect matching between the whole fibers over every base edge.

<code>[InfraConnectionQ]()[*fib*, {*connection1*, *connection2*, ...}]</code> tests every member of a nonempty collection.

## Details & Options

- Every chosen edge must be a transverse edge of the total graph.
- Every total vertex over a base vertex must have exactly one chosen neighbour over each adjacent base vertex.
- The condition includes fiber vertices without any available lift. Saturating only the vertices that have available lifts is insufficient.
- An empty collection returns False; it does not establish existence. The object <code>[InfraConnection]()[{}]</code> is distinct and can be valid when the base has no edges.
- An unsupported fibered graph or undecided member remains unevaluated.

## Basic Examples

Removing one edge from a complete matching leaves two fiber vertices without a lift.

```wl
SeedRandom[ 1 ];
With[
  { fib = InfraFiberedGraph[
      Graph[ Range[ 4 ], UndirectedEdge @@@ Tuples[ { { 1, 2 }, { 3, 4 } } ] ],
      <| 1 -> "p", 2 -> "p", 3 -> "q", 4 -> "q" |>
    ] },
  { connection = RandomInfraConnection[ fib, "NextVertexFunction" -> Identity, RandomSeeding -> 1 ] },
  { InfraFiberedGraphHighlight[ fib, connection ],
    InfraConnectionQ[ fib, connection ],
    InfraConnectionQ[ fib, InfraConnection[ Rest @ First @ connection ] ],
    InfraConnectionQ[ fib, RandomInfraConnection[ fib, All ] ] }
]
```

## Possible Issues

A single available edge does not connect the whole two-vertex fibers. No complete connection exists.

```wl
SeedRandom[ 1 ];
With[
  { fib = InfraFiberedGraph[
      Graph[ Range[ 4 ], { UndirectedEdge[ 1, 3 ] } ],
      <| 1 -> "p", 2 -> "p", 3 -> "q", 4 -> "q" |>
    ] },
  { InfraFiberedGraphHighlight[ fib ],
    InfraConnectionQ[ fib, InfraConnection[ { UndirectedEdge[ 1, 3 ] } ] ],
    RandomInfraConnection[ fib, RandomSeeding -> 1 ] }
]
```
