---
Template: Symbol
Name: RandomInfraMidpoint
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraMidpoint
Keywords: [synthetic geometry, graph, construction]
SeeAlso: [InfraMidpoint, RandomInfraPoint, InfraMeasurement]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraMidpoint]()[*graph*, *p*, *q*, *count*]</code> samples the exact midpoint point family between *p* and *q*.

<code>[RandomInfraMidpoint]()[*graph*, *token*, *count*]</code> accepts an [InfraMidpoint]() token.

## Details & Options

A vertex belongs exactly when both endpoint distances equal half the finite endpoint distance. Odd distance and disconnected endpoints give an empty family; equal anchors give one point.
This differs from the segment "Midpoint" measurement, which retains middle-layer construction density and can contain two layers.

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
SeedRandom[ 71 ]; With[ { graph = CycleGraph[ 4 ] },
  RandomInfraMidpoint[ graph, InfraMidpoint[ 1, 3 ], All ] ]
```

Draw and highlight one point.

```wl
SeedRandom[ 71 ]; With[ { graph = CycleGraph[ 4 ] },
  { point = RandomInfraMidpoint[ graph, InfraMidpoint[ 1, 3 ] ] },
  InfraSubstrateHighlight[ graph, { <| point -> 1 |> } ] ]
```
