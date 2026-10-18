---
Template: Symbol
Name: InfraFiberedGraphQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFiberedGraphQ
Keywords: [fibered graph, supported domain, predicate]
SeeAlso: [InfraFiberedGraph, InfraProjection, InfraFibrationQ, InfraEqualFiberSizesQ, InfraUniqueEdgeLiftingQ]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraFiberedGraphQ]()[*fib*]</code> recognizes a supported fibered graph.

## Details & Options

- A supported object has a finite simple undirected unweighted untagged total graph and a projection defined on exactly its vertices.
- Both the canonical [InfraFiberedGraph]() head and the legacy [InfraFibration]() head are accepted.
- The predicate imposes no restriction on fiber cardinalities, vertical edges or edge lifting.
- A valid empty literal graph with empty projection gives True.
- Malformed projections, unsupported graph domains and unrecognized inputs remain unevaluated. An unevaluated result is not False.
- A nonempty list is tested by conjunction. An empty list gives False; it denotes no supplied objects.
- Supported Experimental models have explicit category methods that materialize the construction once and apply the predicate to the resulting literal object. Manual materialization with [InfraFiberedGraph]() is optional.

## Basic Examples

A valid fibered graph need not satisfy edge lifting.

```wl
SeedRandom[ 7 ];
With[ { fib = InfraFiberedGraph[ Graph[ Range[ 4 ], { UndirectedEdge[ 1, 3 ] } ], <| 1 -> "p", 2 -> "p", 3 -> "q", 4 -> "q" |> ] },
  { InfraFiberedGraphHighlight[ fib ], InfraFiberedGraphQ[ fib ], InfraFibrationQ[ fib ] } ]
```
