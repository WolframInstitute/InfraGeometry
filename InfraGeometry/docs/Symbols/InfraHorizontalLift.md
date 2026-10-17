---
Template: Symbol
Name: InfraHorizontalLift
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraHorizontalLift
Keywords: [horizontal lift, path lifting, connection, walk]
SeeAlso: [InfraConnection, InfraConnectionQ, InfraParallelTransport, InfraHolonomy, InfraWalk, FindInfraHorizontalLift]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[InfraHorizontalLift]()[*fib*, *connection*, *start*, *walk*]</code> gives the unique horizontal lift of a base walk starting at the total vertex *start*.

## Details & Options

- The result is one ordered list of total vertices. Its projection is exactly *walk*, including repeated visits.
- The connection must satisfy [InfraConnectionQ](). The starting vertex must lie over the first vertex of the walk.
- The walk is a nonempty list of base vertices with every consecutive pair joined by a base edge. A one-vertex walk has zero length and lifts to {*start*}.
- The reader is determined and consumes no random draws. It has no count or sampling option.
- Invalid or ambiguous connections and unsupported walks or starting vertices remain unevaluated.
- [FindInfraHorizontalLift]() retains the legacy counted list form for migration.

## Basic Examples

A loop in the base of this double covering lifts from one sheet to the other.

```wl
SeedRandom[ 1 ];
With[
  { total = CycleGraph[ 8 ] },
  { fib = InfraFibration[ total, vertex |-> Mod[ vertex, 4, 1 ] ],
    connection = InfraConnection[ EdgeList @ total ] },
  { loop = { 1, 2, 3, 4, 1 } },
  { lift = InfraHorizontalLift[ fib, connection, 1, loop ] },
  { InfraFiberedGraphHighlight[ fib, { connection, InfraWalk[ lift ] } ],
    lift, Lookup[ InfraFibrationAssociation[ fib ], Key /@ lift ] }
]
```

## Properties and Relations

Retracing an edge retraces its lift. A zero-length walk stays at its starting vertex.

```wl
SeedRandom[ 1 ];
With[
  { total = CycleGraph[ 8 ] },
  { fib = InfraFibration[ total, vertex |-> Mod[ vertex, 4, 1 ] ],
    connection = InfraConnection[ EdgeList @ total ] },
  { InfraHorizontalLift[ fib, connection, 1, { 1, 2, 1, 2 } ],
    InfraHorizontalLift[ fib, connection, 1, { 1 } ] }
]
```

## Possible Issues

The starting vertex must lie over the first base vertex. An unsupported call stays unevaluated.

```wl
SeedRandom[ 1 ];
With[
  { total = CycleGraph[ 8 ] },
  { fib = InfraFibration[ total, vertex |-> Mod[ vertex, 4, 1 ] ],
    connection = InfraConnection[ EdgeList @ total ] },
  Head @ InfraHorizontalLift[ fib, connection, 2, { 1, 2 } ]
]
```
