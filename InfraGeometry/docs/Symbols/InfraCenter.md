---
Template: Symbol
Name: InfraCenter
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraCenter
Keywords: [point, center, eccentricity]
SeeAlso: [RandomInfraPoint, GraphCenter]
RelatedGuides: [Experimental]
---

## Usage

<code>[InfraCenter]()[*graph*]</code> gives a vertex of least eccentricity.

## Details & Options

`InfraCenter[graph]` is `First @ GraphCenter[graph]`: one representative of the built-in graph center, returned as a bare vertex rather than as the `List` `GraphCenter` itself gives, since there may be several vertices of least eccentricity and a construction anchored at "the" center wants one.

## Basic Examples

The center of a square grid, and of a path.

```wl
InfraCenter @ GridGraph[{5, 5}]
```

```wl
InfraCenter @ PathGraph[Range[7]]
```
