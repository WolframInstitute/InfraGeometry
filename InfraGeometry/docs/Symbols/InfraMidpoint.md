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

<code>[InfraMidpoint]()[*p*, *q*]</code> is the center of the oriented segment graph from *p* to *q*.

## Details & Options

The graph must be finite, simple, undirected and unweighted, with valid vertex anchors.
Unsupported arguments and properties stay unevaluated.
The head is inert until a graph-aware reader or named sampler evaluates it.

One representative is one raw vertex label, including a List-valued label.
The complete family has distinct central vertices in graph vertex order.
Its vertex density counts the shortest paths from *p* to *q* through each central vertex.
Supported measurements are "VertexDensity", "Cardinality", "CountingMeasure", "Subgraph" and "RiemannianMeasure".
The last measure uses the existing interior-support law.
"Graph", "EdgeDensity", "Length", "Area" and "Volume" are unsupported for these point families.

The segment graph contains all shortest paths from *p* to *q*, oriented toward *q*.
A central vertex minimizes Max[d(p,v),d(v,q)] within this graph.
For even endpoint distance this selects one middle layer; for odd distance it selects both middle layers.
Disconnected endpoints give an empty family; equal anchors give one point.
The "VertexDensity" measurement equals the segment "Midpoint" measurement.
RandomInfraMidpoint samples the distinct central vertices uniformly, independently of their occupation densities.

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

Read both middle layers of a segment with odd length.

```wl
SeedRandom[ 71 ]; With[ { graph = PathGraph[ Range[ 4 ] ] },
  InfraMeasurement[ graph, InfraMidpoint[ 1, 4 ], "VertexDensity" ] ]
```

Read the shortest-path occupation density at the center of a branching segment.

```wl
SeedRandom[ 71 ]; With[ { graph = GridGraph[ { 3, 3 } ] },
  InfraMeasurement[ graph, InfraMidpoint[ 1, 9 ], "VertexDensity" ] ]
```
