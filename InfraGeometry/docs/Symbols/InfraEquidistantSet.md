---
Template: Symbol
Name: InfraEquidistantSet
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraEquidistantSet
Keywords: [equidistant locus, graph, circumcentre, synthetic geometry]
SeeAlso: [InfraPerpendicularBisector, FindInfraEquidistantSet, InfraMeasurement, InfraMemberQ, InfraPoint]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraEquidistantSet]()[{*p1*, ..., *pn*}]</code> is the inert locus of vertices at equal finite graph distance from all the anchors.

## Details & Options

On a graph with path distance $d$, the locus is $\{v : d(p_1,v) = \dots = d(p_n,v) < \infty\}$.
It is one unique vertex set. There is no random equidistant-set constructor.
The head is inert; [InfraMeasurement]() reads it on a concrete graph.

For two anchors it is [InfraPerpendicularBisector]()[*p1*, *p2*].
For three anchors it is the graph analogue of the circumcentre locus.
For $n \ge 2$ anchors it is the intersection of the $n-1$ consecutive perpendicular bisectors.
Repeated anchors do not change the locus.
A single anchor gives its connected component. An empty anchor list gives every vertex of the graph.
Anchors in distinct connected components give the empty locus.

The substrate must be finite, simple, undirected and unweighted, and all anchors must be vertices.
List-valued vertex labels are supported: each anchor remains a single entry of the outer list.
Unsupported arguments and properties stay unevaluated.

"VertexDensity" gives weight 1 to each locus vertex.
"Cardinality" is 1, including when the locus is empty.
"CountingMeasure" counts the locus vertices; "Subgraph" gives the subgraph induced on them.
"RiemannianMeasure" counts locus vertices whose neighbours all lie in the locus.
[InfraMemberQ]()[*graph*, *object*, *vertices*] tests whether *vertices* is the complete locus, independently of ordering or repetition.

[RandomInfraPoint]() with [InfraPoint]()[*object*] chooses a vertex of the locus.
The older [FindInfraEquidistantSet]() returns an explicit vertex list and also supports a thickened distance-difference window.

## Basic Examples

Read the vertices equidistant from 1, 2 and 3 in the complete graph on four vertices. The density is <|4 -> 1|>.

```wl
SeedRandom[ 71 ]; With[ { graph = CompleteGraph[ 4 ] },
  InfraMeasurement[ graph, InfraEquidistantSet[ { 1, 2, 3 } ], "VertexDensity" ] ]
```

Draw the common equidistant locus of vertices 1 and 3 on a four-cycle.

```wl
SeedRandom[ 71 ]; With[ { graph = CycleGraph[ 4 ] },
  InfraSubstrateHighlight[ graph, { InfraEquidistantSet[ { 1, 3 } ], { 1, 3 } } ] ]
```

Read the number of objects and their number of vertices separately. An empty bisector is one set with no vertices.

```wl
SeedRandom[ 71 ]; With[ { graph = PathGraph[ { 1, 2 } ] },
  { object = InfraEquidistantSet[ { 1, 2 } ] },
  { InfraMeasurement[ graph, object, "Cardinality" ], InfraMeasurement[ graph, object, "CountingMeasure" ] } ]
```

Choose one point of an equidistant locus.

```wl
SeedRandom[ 71 ]; With[ { graph = CycleGraph[ 4 ] },
  RandomInfraPoint[ graph, InfraPoint[ InfraEquidistantSet[ { 1, 3 } ] ], RandomSeeding -> 71 ] ]
```
