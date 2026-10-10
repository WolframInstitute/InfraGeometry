---
Template: Symbol
Name: RandomInfraPerpendicularBisector
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraPerpendicularBisector
Keywords: [synthetic geometry, graph, construction]
SeeAlso: [InfraPerpendicularBisector, RandomInfraPoint, InfraMeasurement]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraPerpendicularBisector]()[*graph*, *p*, *q*, *count*]</code> samples the point family at equal finite distance from *p* and *q*.

<code>[RandomInfraPerpendicularBisector]()[*graph*, *token*, *count*]</code> accepts an [InfraPerpendicularBisector]() token.

## Details & Options

Equal anchors give their connected component; disconnected anchors give an empty family.
This is an equidistant locus. It need not separate the anchors or be a line, and it does not assert an angle. InfraPlane retains its separating-family meaning.

The graph must be finite, simple, undirected and unweighted, with valid anchors.
Omitted count or Automatic gives one uniformly random vertex; an empty pool gives {}.
An integer gives that many distinct vertices, or {} when too few exist.
UpTo[n] gives at most n distinct vertices; All gives the complete pool in graph vertex order.
Zero gives {}; negative counts and unsupported options stay unevaluated.

"NextVertexFunction" defaults to Automatic. Identity selects in graph vertex order.
These are the only supported selector values. All and Identity do not advance random state.
List-valued points remain intact. For an empty-List vertex, All and count 1 distinguish {{}} from an empty pool.


## Basic Examples

Enumerate the complete point family.

```wl
SeedRandom[ 71 ]; With[ { graph = CompleteGraph[ 3 ] },
  RandomInfraPerpendicularBisector[ graph, InfraPerpendicularBisector[ 1, 2 ], All ] ]
```

Draw and highlight one point.

```wl
SeedRandom[ 71 ]; With[ { graph = CompleteGraph[ 3 ] },
  { point = RandomInfraPerpendicularBisector[ graph, InfraPerpendicularBisector[ 1, 2 ] ] },
  InfraSubstrateHighlight[ graph, { <| point -> 1 |> } ] ]
```
