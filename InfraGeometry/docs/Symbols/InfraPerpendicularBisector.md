---
Template: Symbol
Name: InfraPerpendicularBisector
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraPerpendicularBisector
Keywords: [synthetic geometry, graph, construction]
SeeAlso: [RandomInfraPerpendicularBisector, InfraMeasurement, InfraMemberQ, InfraDistance]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraPerpendicularBisector]()[*p*, *q*]</code> is the point family at equal finite distance from *p* and *q*.

## Details & Options

The graph must be finite, simple, undirected and unweighted, with valid vertex anchors.
Unsupported arguments and properties stay unevaluated.
The head is inert until a graph-aware reader or named sampler evaluates it.

One representative is one raw vertex label, including a List-valued label.
The complete family has distinct vertices in graph vertex order and unit vertex density.
Supported measurements are "VertexDensity", "Cardinality", "CountingMeasure", "Subgraph" and "RiemannianMeasure".
The last measure uses the existing interior-support law.
"Graph", "EdgeDensity", "Length", "Area" and "Volume" are unsupported for these point families.

Equal anchors give their connected component; disconnected anchors give an empty family.
This is an equidistant locus. It need not separate the anchors or be a line, and it does not assert an angle. InfraPlane retains its separating-family meaning.

## Basic Examples

Draw the complete support.

```wl
SeedRandom[ 71 ]; With[ { graph = CompleteGraph[ 3 ] },
  InfraSubstrateHighlight[ graph, { InfraPerpendicularBisector[ 1, 2 ] } ] ]
```

Read every candidate without sampling.

```wl
SeedRandom[ 71 ]; With[ { graph = CompleteGraph[ 3 ] },
  RandomInfraPerpendicularBisector[ graph, InfraPerpendicularBisector[ 1, 2 ], All ] ]
```
