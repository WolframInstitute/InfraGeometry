---
Template: Symbol
Name: InfraGeometricTest
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraGeometricTest
Keywords: [synthetic geometry, graph, construction]
SeeAlso: [InfraGeometricAssertion, InfraMemberQ, InfraDistance, InfraScene]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraGeometricTest]()[*graph*, *assertion*]</code> evaluates a supported [InfraGeometricAssertion]().

## Details & Options

The graph must be finite, simple, undirected and unweighted.
"Distinct" tests pairwise distinct valid vertex labels; empty and singleton Lists pass.
"Member" tests membership in nonzero supported vertex density.
"EqualDistance" compares two finite ambient graph distances; two infinite distances are not an equality witness.
Decided failure returns False. Unknown properties, unsupported forms and unbound arguments stay unevaluated.
Labels are compared literally. No Euclidean theorem catalog is implied.

## Basic Examples

Compare two finite distances.

```wl
SeedRandom[ 71 ]; With[ { graph = CycleGraph[ 4 ] },
  InfraGeometricTest[ graph, InfraGeometricAssertion[ { { 1, 2 }, { 3, 4 } }, "EqualDistance" ] ] ]
```

Test exact-family support membership.

```wl
SeedRandom[ 71 ]; With[ { graph = CycleGraph[ 4 ] },
  InfraGeometricTest[ graph, InfraGeometricAssertion[ { 2, InfraMidpoint[ 1, 3 ] }, "Member" ] ] ]
```
