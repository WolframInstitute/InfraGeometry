---
Template: Symbol
Name: InfraMidpoint
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraMidpoint
Keywords: [synthetic geometry, graph, construction]
SeeAlso: [RandomInfraMidpoint, InfraMeasurement, InfraMemberQ, InfraDistance]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraMidpoint]()[*p*, *q*]</code> is the exact midpoint point family between *p* and *q*.

## Details & Options

The graph must be finite, simple, undirected and unweighted, with valid vertex anchors.
Unsupported arguments and properties stay unevaluated.
The head is inert until a graph-aware reader or named sampler evaluates it.

One representative is one raw vertex label, including a List-valued label.
The complete family has distinct vertices in graph vertex order and unit vertex density.
Supported measurements are "VertexDensity", "Cardinality", "CountingMeasure", "Subgraph" and "RiemannianMeasure".
The last measure uses the existing interior-support law.
"Graph", "EdgeDensity", "Length", "Area" and "Volume" are unsupported for these point families.

A vertex belongs exactly when both endpoint distances equal half the finite endpoint distance. Odd distance and disconnected endpoints give an empty family; equal anchors give one point.
This differs from the segment "Midpoint" measurement, which retains middle-layer construction density and can contain two layers.

## Basic Examples

Draw the complete support.

```wl
SeedRandom[ 71 ]; With[ { graph = CycleGraph[ 4 ] },
  InfraSubstrateHighlight[ graph, { InfraMidpoint[ 1, 3 ] } ] ]
```

Read every candidate without sampling.

```wl
SeedRandom[ 71 ]; With[ { graph = CycleGraph[ 4 ] },
  RandomInfraMidpoint[ graph, InfraMidpoint[ 1, 3 ], All ] ]
```
