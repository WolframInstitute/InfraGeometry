---
Template: Symbol
Name: InfraGeometricAssertion
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraGeometricAssertion
Keywords: [synthetic geometry, graph, construction]
SeeAlso: [InfraGeometricTest, InfraScene, InfraMemberQ]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraGeometricAssertion]()[*objects*, *property*]</code> is an inert graph-geometric assertion.

## Details & Options

[InfraGeometricTest]() evaluates the assertion with a graph.
The supported properties are "Distinct" on a List of valid vertices, "Member" on {point, object}, and "EqualDistance" on {{p, q}, {r, s}}.
Unknown properties, unsupported objects and unresolved arguments stay unevaluated.
Scenes insert the graph after resolving their bound objects. A pending assertion is not proved.

## Basic Examples

Test an inert assertion on a graph.

```wl
SeedRandom[ 71 ]; With[ { graph = CycleGraph[ 4 ] },
  InfraGeometricTest[ graph, InfraGeometricAssertion[ { 1, 2 }, "Distinct" ] ] ]
```
