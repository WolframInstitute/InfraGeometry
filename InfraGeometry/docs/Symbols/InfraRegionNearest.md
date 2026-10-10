---
Template: Symbol
Name: InfraRegionNearest
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraRegionNearest
Keywords: [synthetic geometry, graph, construction]
SeeAlso: [RandomInfraRegionNearest, InfraMeasurement, InfraMemberQ, InfraDistance]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraRegionNearest]()[*object*, *p*]</code> is the point family of all nearest support vertices to *p*.

## Details & Options

The graph must be finite, simple, undirected and unweighted, with valid vertex anchors.
Unsupported arguments and properties stay unevaluated.
The head is inert until a graph-aware reader or named sampler evaluates it.

One representative is one raw vertex label, including a List-valued label.
The complete family has distinct vertices in graph vertex order and unit vertex density.
Supported measurements are "VertexDensity", "Cardinality", "CountingMeasure", "Subgraph" and "RiemannianMeasure".
The last measure uses the existing interior-support law.
"Graph", "EdgeDensity", "Length", "Area" and "Volume" are unsupported for these point families.

The support is the nonzero supported vertex density of the object, or a supported raw vertex, vertex List, density Association or Graph carrier.
Every finite-distance minimizer is retained. Empty or unreachable support gives an empty family. Unsupported support stays unevaluated. If *p* is in the support, it is the unique nearest point.

## Basic Examples

Draw the complete support.

```wl
SeedRandom[ 71 ]; With[ { graph = PathGraph[ Range[ 3 ] ] },
  InfraSubstrateHighlight[ graph, { InfraRegionNearest[ { 1, 3 }, 2 ] } ] ]
```

Read every candidate without sampling.

```wl
SeedRandom[ 71 ]; With[ { graph = PathGraph[ Range[ 3 ] ] },
  RandomInfraRegionNearest[ graph, InfraRegionNearest[ { 1, 3 }, 2 ], All ] ]
```
