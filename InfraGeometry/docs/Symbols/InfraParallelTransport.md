---
Template: Symbol
Name: InfraParallelTransport
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraParallelTransport
Keywords: [parallel transport, fiber bijection, connection, walk]
SeeAlso: [InfraConnection, InfraConnectionQ, InfraHorizontalLift, InfraHolonomy, InfraParallelSectionQ, InfraHolonomyAngle, FindInfraLeviCivitaConnection]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[InfraParallelTransport]()[*fib*, *connection*, *walk*]</code> gives the total fiber bijection along a base walk as an association from each starting vertex to the endpoint of its horizontal lift.

<code>[InfraParallelTransport]()[[InfraDisplacementBundle]()[*graph*, *radius*], *walk*]</code> gives the list of metric-selected transports in the Experimental displacement-bundle model.

<code>[InfraParallelTransport]()[[InfraDisplacementBundle]()[*graph*, *radius*], *connection*, *walk*]</code> retains the Experimental model's partial transport, omitting starting directions whose lift is blocked.

## Details & Options

- The general fibered-graph reader requires a valid complete connection and a nonempty base walk. It never drops blocked vertices or chooses between ambiguous lifts.
- Keys follow <code>[VertexList]()[[InfraFiber]()[*fib*, [First]()[*walk*]]]</code>. List-valued and expression-valued vertices are literal association keys.
- A one-vertex walk gives the identity association. Concatenating walks composes their transports; reversing a walk gives the inverse bijection.
- The readers with an explicit connection consume no random draws and take no options. Unsupported input remains unevaluated.
- The Experimental displacement overload with an explicit connection accepts partial matchings. Each surviving lift is unique; ambiguous matchings remain unevaluated. Converting the model to a literal InfraFibration selects the general complete-connection contract.
- The Experimental two-argument displacement form lists every composite of its best angle-matching injections, without duplicates. It is a particular model and may have several results.

Options of the Experimental displacement form:

| Option | Default | Meaning |
|---|---|---|
| [Method]() | `"Arclength"` | `"Arclength"` or `"Alexandrov"` angle comparison. |

## Basic Examples

The two lifts of the base cycle exchange the sheets of a double covering.

```wl
SeedRandom[ 1 ];
With[
  { total = CycleGraph[ 8 ] },
  { fib = InfraFibration[ total, vertex |-> Mod[ vertex, 4, 1 ] ],
    connection = InfraConnection[ EdgeList @ total ] },
  { loop = { 1, 2, 3, 4, 1 } },
  { lifts = InfraHorizontalLift[ fib, connection, #, loop ] & /@ { 1, 5 } },
  { InfraFiberedGraphHighlight[ fib, InfraWalk /@ lifts ],
    InfraParallelTransport[ fib, connection, loop ] }
]
```

## Properties and Relations

The reverse transport is the inverse map. A zero-length walk is the identity.

```wl
SeedRandom[ 1 ];
With[
  { total = CycleGraph[ 8 ] },
  { fib = InfraFibration[ total, vertex |-> Mod[ vertex, 4, 1 ] ],
    connection = InfraConnection[ EdgeList @ total ] },
  { walk = { 1, 2, 3 } },
  { forward = InfraParallelTransport[ fib, connection, walk ],
    backward = InfraParallelTransport[ fib, connection, Reverse @ walk ] },
  { And @@ KeyValueMap[ { source, target } |-> Lookup[ backward, Key @ target ] === source, forward ],
    InfraParallelTransport[ fib, connection, { 1 } ] }
]
```

## Possible Issues

A partial matching is not a complete connection, so it is not accepted by this reader.

```wl
SeedRandom[ 1 ];
With[
  { fib = InfraFibration[
      Graph[ Range[ 4 ], { UndirectedEdge[ 1, 3 ] } ],
      <| 1 -> "p", 2 -> "p", 3 -> "q", 4 -> "q" |>
    ] },
  Head @ InfraParallelTransport[ fib, InfraConnection[ { UndirectedEdge[ 1, 3 ] } ], { "p", "q" } ]
]
```
