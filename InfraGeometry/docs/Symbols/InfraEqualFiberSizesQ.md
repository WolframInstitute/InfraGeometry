---
Template: Symbol
Name: InfraEqualFiberSizesQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraEqualFiberSizesQ
Keywords: [equal fiber sizes, cardinality, predicate]
SeeAlso: [InfraFiberedGraphQ, InfraIsomorphicFibersQ, InfraFibers, InfraUniqueEdgeLiftingQ]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraEqualFiberSizesQ]()[*fib*]</code> tests whether all fibers of *fib* have the same number of vertices.

## Details & Options

- Equality is required across the whole reconstructed base, including different connected components.
- Equal cardinalities do not require isomorphic fiber graphs or a complete connection.
- Isomorphic fibers imply equal sizes. Unique edge lifting implies equal sizes within each connected base component only.
- The empty fibered graph satisfies the condition vacuously.
- A nonempty list is tested by conjunction; an empty list gives False. Unsupported inputs remain unevaluated.

## Basic Examples

These two fibers have three vertices each, but different vertical edge sets.

```wl
SeedRandom[ 7 ];
With[ { fib = InfraFiberedGraph[ Graph[ Range[ 6 ], { UndirectedEdge[ 1, 2 ], UndirectedEdge[ 3, 4 ] } ],
    <| 1 -> "p", 2 -> "p", 3 -> "p", 4 -> "q", 5 -> "q", 6 -> "q" |> ] },
  { InfraFiberedGraphHighlight[ fib ], InfraEqualFiberSizesQ[ fib ], InfraIsomorphicFibersQ[ fib ] } ]
```
