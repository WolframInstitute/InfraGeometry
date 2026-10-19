---
Template: Symbol
Name: InfraPerpendicularBisector
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraPerpendicularBisector
Keywords: [synthetic geometry, graph, equidistant locus, perpendicular bisector]
SeeAlso: [InfraEquidistantSet, FindInfraEquidistantSet, InfraMeasurement, InfraPoint, InfraRegionNearest, InfraPlane]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraPerpendicularBisector]()[*p*, *q*]</code> is the locus of vertices at equal finite graph distance from *p* and *q*.

## Details & Options

On a graph with path distance $d$, the locus is the unique vertex set $\{v : d(p,v) = d(q,v) < \infty\}$.
The head is inert; [InfraMeasurement]() reads its properties on a concrete graph.
Its "VertexDensity" has weight 1 at each vertex of the locus.
Its "Cardinality" is 1, including for the empty locus; "CountingMeasure" counts its vertices.
[InfraMemberQ]()[*graph*, *bisector*, *vertices*] tests whether *vertices* is the complete locus, independently of ordering or repeated vertices.
There is no random bisector: use [RandomInfraPoint]() with an [InfraPoint]() token to choose a point of the locus.

The graph must be finite, simple, undirected and unweighted, with valid vertex anchors.
Equal anchors give their connected component; disconnected anchors give the empty set.
The locus need not separate the anchors or form a line, and it does not assert an angle.
[InfraPlane]() instead describes a family of separating vertex sets.

The inert multipoint analogue is [InfraEquidistantSet]()[{*p1*, ..., *pn*}], the equidistant locus $\{v : d(p_1,v) = \dots = d(p_n,v) < \infty\}$.
It is the intersection of the $n-1$ consecutive perpendicular bisectors.
[InfraMeasurement]() reads its complete locus on the graph.
The existing [FindInfraEquidistantSet]()[*graph*, {*p1*, ..., *pn*}] returns a vertex list on a connected substrate; its optional distance-difference window gives a thickened locus.
For three points this is the graph analogue of the circumcentre locus.

Supported measurements are "VertexDensity", "Cardinality", "CountingMeasure", "Subgraph" and "RiemannianMeasure".
"RiemannianMeasure" counts support vertices whose neighbours all belong to the support.
Unsupported arguments and properties stay unevaluated.

## Basic Examples

Read the bisector of vertices 1 and 3 on a four-cycle. Its vertices are 2 and 4.

```wl
SeedRandom[ 71 ]; With[ { graph = CycleGraph[ 4 ] },
  InfraMeasurement[ graph, InfraPerpendicularBisector[ 1, 3 ], "VertexDensity" ] ]
```

Draw the complete locus.

```wl
SeedRandom[ 71 ]; With[ { graph = CycleGraph[ 4 ] },
  InfraSubstrateHighlight[ graph, { InfraPerpendicularBisector[ 1, 3 ] } ] ]
```

Choose a point on the bisector.

```wl
SeedRandom[ 71 ]; With[ { graph = CycleGraph[ 4 ] },
  RandomInfraPoint[ graph, InfraPoint[ InfraPerpendicularBisector[ 1, 3 ] ] ] ]
```

Find the vertices equidistant from three anchors. On the complete graph with four vertices, the answer is {4}.

```wl
SeedRandom[ 71 ]; Keys @ InfraMeasurement[ CompleteGraph[ 4 ], InfraEquidistantSet[ { 1, 2, 3 } ], "VertexDensity" ]
```
