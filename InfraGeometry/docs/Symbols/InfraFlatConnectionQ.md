---
Template: Symbol
Name: InfraFlatConnectionQ
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFlatConnectionQ
Keywords: [compatibility, flat connection, trivial monodromy, holonomy]
SeeAlso: [InfraTrivialMonodromyQ, InfraConnectionQ, InfraHolonomy]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraFlatConnectionQ]()[*fib*, *conn*]</code> is the compatibility spelling of <code>[InfraTrivialMonodromyQ]()[*fib*, *conn*]</code>.

## Details & Options

The predicate tests identity holonomy around every closed base walk.
It retains its existing behavior, including complete-connection validation and collection handling.
The name does not denote a separate test for zero curvature on specified faces.

Use [InfraTrivialMonodromyQ]() in new code.

## Basic Examples

The two spellings give the same result on a connected double covering of a square.

```wl
With[ { fib = InfraFiberedGraph[ CycleGraph[ 8 ], vertex |-> Mod[ vertex, 4, 1 ] ] },
  { connection = InfraConnection[ EdgeList @ InfraTotalSpace[ fib ] ] },
  { InfraFlatConnectionQ[ fib, connection ], InfraTrivialMonodromyQ[ fib, connection ] } ]
```
