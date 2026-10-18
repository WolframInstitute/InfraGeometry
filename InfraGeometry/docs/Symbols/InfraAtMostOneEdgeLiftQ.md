---
Template: Symbol
Name: InfraAtMostOneEdgeLiftQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraAtMostOneEdgeLiftQ
Keywords: [local injectivity, partial matching, edge lifting]
SeeAlso: [InfraFibrationQ, InfraUniqueEdgeLiftingQ, InfraEdgeLiftMultiplicity, InfraCoveringQ]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraAtMostOneEdgeLiftQ]()[*fib*]</code> tests whether each total vertex has at most one neighbour over each adjacent base vertex.

## Details & Options

- Only transverse neighbours are counted. Vertical edges do not affect the condition.
- Over each base edge, the transverse edges form a matching, possibly incomplete.
- In the transverse neighbourhood, the projection is locally injective. This says nothing about injectivity within a fiber.
- [InfraFibrationQ]() adds existence. Together the two conditions are [InfraUniqueEdgeLiftingQ]().
- The empty fibered graph satisfies the condition vacuously.
- A nonempty list is tested by conjunction; an empty list gives False. Unsupported inputs remain unevaluated.

## Basic Examples

One transverse edge is a matching, but leaves two total vertices without a lift.

```wl
SeedRandom[ 7 ];
With[ { fib = InfraFiberedGraph[ Graph[ Range[ 4 ], { UndirectedEdge[ 1, 3 ] } ], <| 1 -> "p", 2 -> "p", 3 -> "q", 4 -> "q" |> ] },
  { InfraFiberedGraphHighlight[ fib ], InfraAtMostOneEdgeLiftQ[ fib ], InfraFibrationQ[ fib ] } ]
```
