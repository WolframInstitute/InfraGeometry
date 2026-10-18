---
Template: Symbol
Name: FindInfraHorizontalLift
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraHorizontalLift
Keywords: [legacy horizontal lift, counted compatibility form]
SeeAlso: [InfraHorizontalLift, InfraConnection, InfraParallelTransport, InfraHolonomy]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[FindInfraHorizontalLift]()[*fib*, *connection*, *start*, *walk*, *count*]</code> is the legacy counted-list form of [InfraHorizontalLift]().

## Details & Options

- New code uses <code>[InfraHorizontalLift]()[*fib*, *connection*, *start*, *walk*]</code>, which returns the unique vertex sequence directly.
- The connection must be complete, and the walk and starting vertex must be valid for that reader.
- Count 1, UpTo[*n*] with positive *n*, and All return a singleton list containing the unique lift. Count 0 and UpTo[0] return {}. An exact count above one returns {} on shortage.
- The shim is deterministic and delegates to [InfraHorizontalLift](). It does not search partial or ambiguous connections.
- Unsupported arguments remain unevaluated.

## Basic Examples

The legacy singleton list contains the same sequence returned directly by the canonical reader.

```wl
SeedRandom[ 1 ];
With[
  { total = CycleGraph[ 8 ] },
  { fib = InfraFiberedGraph[ total, vertex |-> Mod[ vertex, 4, 1 ] ],
    connection = InfraConnection[ EdgeList @ total ] },
  { loop = { 1, 2, 3, 4, 1 } },
  { InfraHorizontalLift[ fib, connection, 1, loop ],
    FindInfraHorizontalLift[ fib, connection, 1, loop, 1 ],
    FindInfraHorizontalLift[ fib, connection, 1, loop, 2 ] }
]
```
