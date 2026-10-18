---
Template: Symbol
Name: InfraHolonomy
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraHolonomy
Keywords: [holonomy, monodromy, permutation, connection, loop]
SeeAlso: [InfraConnection, InfraHorizontalLift, InfraParallelTransport, InfraFlatConnectionQ, InfraHolonomyAngle]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraHolonomy]()[*fib*, *connection*, *loop*]</code> gives the permutation induced by transport around a closed base walk, as [Cycles]().

## Details & Options

- The connection must be complete and the loop must be a nonempty valid base walk whose first and last vertices agree.
- Permutation positions refer to <code>[VertexList]()[[InfraFiber]()[*fib*, [First]()[*loop*]]]</code>, in that order.
- A one-vertex loop is the identity permutation, <code>[Cycles]()[{}]</code>.
- The result is monodromy of the chosen connection. A graph alone supplies no faces on which to define curvature.
- The reader consumes no random draws. Unsupported loops and connections remain unevaluated.

## Basic Examples

One circuit exchanges the sheets; retracing one edge has identity holonomy.

```wl
SeedRandom[ 1 ];
With[
  { total = CycleGraph[ 8 ] },
  { fib = InfraFiberedGraph[ total, vertex |-> Mod[ vertex, 4, 1 ] ],
    connection = InfraConnection[ EdgeList @ total ] },
  { InfraFiberedGraphHighlight[ fib, connection ],
    InfraHolonomy[ fib, connection, { 1, 2, 3, 4, 1 } ],
    InfraHolonomy[ fib, connection, { 1, 2, 1 } ],
    InfraHolonomy[ fib, connection, { 1 } ] }
]
```

## Properties and Relations

The index convention is visible when the fiber vertices have a deliberately chosen order.

```wl
SeedRandom[ 1 ];
With[
  { total = Graph[ { 1, 7, 4, 2, 3, 5, 6, 8, 9 }, EdgeList @ CycleGraph[ 9 ] ] },
  { fib = InfraFiberedGraph[ total, vertex |-> Mod[ vertex, 3, 1 ] ],
    connection = InfraConnection[ EdgeList @ total ] },
  { VertexList @ InfraFiber[ fib, 1 ],
    InfraParallelTransport[ fib, connection, { 1, 2, 3, 1 } ],
    PermutationList[ InfraHolonomy[ fib, connection, { 1, 2, 3, 1 } ], 3 ] }
]
```

## Possible Issues

Identity holonomy on one loop does not establish trivial monodromy on an arbitrary base. [InfraFlatConnectionQ]() checks every component of the connection graph.
