---
Template: Symbol
Name: InfraRegionNearest
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraRegionNearest
Keywords: [synthetic geometry, graph, nearest point, metric projection]
SeeAlso: [RandomInfraRegionNearest, InfraMeasurement, InfraDistance, InfraPoint]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraRegionNearest]()[*object*, *p*]</code> is the family of vertices of *object* nearest to the query vertex *p* in graph distance, retaining all ties.

## Details & Options

This is the metric projection of a point onto a region.
Let $S$ be the nonzero support of the vertex density of *object*, and let $S_p$ be the vertices of $S$ reachable from *p*.
The family is $\{v \in S_p : d(p,v) = \min_{u \in S_p} d(p,u)\}$.
It is empty when $S_p$ is empty.
Thus the first argument specifies where the answer must lie; the second argument is the point from which distance is measured.

For example, in the path 1--2--3--4--5, the nearest vertex of {1, 5} to 2 is 1.
The nearest vertices of the same region to 3 are 1 and 5, tied at distance 2.
If *p* belongs to the region, it is the unique nearest vertex.

The head is inert; [InfraMeasurement]() gives the complete family with unit "VertexDensity".
[RandomInfraRegionNearest]() chooses one nearest vertex, or a requested number of distinct nearest vertices.
One representative is a raw vertex label, including a List-valued label.
Density weights determine the support but do not affect which vertices are nearest.

The region may be an inert object supported by "VertexDensity", a raw vertex, a vertex list, a numeric density association, or a graph carrier.
The substrate must be finite, simple, undirected and unweighted, and *p* must be one of its vertices.
Empty or unreachable regions give an empty family.
Unsupported arguments and properties stay unevaluated.

Supported measurements are "VertexDensity", "Cardinality", "CountingMeasure", "Subgraph" and "RiemannianMeasure".
"RiemannianMeasure" counts support vertices whose neighbours all belong to the support.

## Basic Examples

Find the point of {1, 5} nearest to 2. The density is <|1 -> 1|>.

```wl
SeedRandom[ 71 ]; With[ { graph = PathGraph[ Range[ 5 ] ] },
  InfraMeasurement[ graph, InfraRegionNearest[ { 1, 5 }, 2 ], "VertexDensity" ] ]
```

Retain both ties when the query point is 3. The density is <|1 -> 1, 5 -> 1|>.

```wl
SeedRandom[ 71 ]; With[ { graph = PathGraph[ Range[ 5 ] ] },
  InfraMeasurement[ graph, InfraRegionNearest[ { 1, 5 }, 3 ], "VertexDensity" ] ]
```

Project a point onto a ball, then draw the nearest point together with the ball and the query point.

```wl
SeedRandom[ 71 ]; With[ { graph = PathGraph[ Range[ 7 ] ] },
  { region = InfraBall[ 2, 1 ] },
  InfraSubstrateHighlight[ graph, { region, InfraRegionNearest[ region, 7 ], { 7 } } ] ]
```

Choose one of the tied nearest vertices.

```wl
SeedRandom[ 71 ]; With[ { graph = PathGraph[ Range[ 5 ] ] },
  RandomInfraRegionNearest[ graph, InfraRegionNearest[ { 1, 5 }, 3 ] ] ]
```
