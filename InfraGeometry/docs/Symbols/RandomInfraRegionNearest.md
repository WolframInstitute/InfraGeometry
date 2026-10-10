---
Template: Symbol
Name: RandomInfraRegionNearest
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraRegionNearest
Keywords: [synthetic geometry, graph, construction]
SeeAlso: [InfraRegionNearest, RandomInfraPoint, InfraMeasurement]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraRegionNearest]()[*graph*, *object*, *p*, *count*]</code> samples the point family of all nearest support vertices to *p*.

<code>[RandomInfraRegionNearest]()[*graph*, *token*, *count*]</code> accepts an [InfraRegionNearest]() token.

## Details & Options

The support is the nonzero supported vertex density of the object, or a supported raw vertex, vertex List, density Association or Graph carrier.
Every finite-distance minimizer is retained. Empty or unreachable support gives an empty family. Unsupported support stays unevaluated. If *p* is in the support, it is the unique nearest point.

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
SeedRandom[ 71 ]; With[ { graph = PathGraph[ Range[ 3 ] ] },
  RandomInfraRegionNearest[ graph, InfraRegionNearest[ { 1, 3 }, 2 ], All ] ]
```

Draw and highlight one point.

```wl
SeedRandom[ 71 ]; With[ { graph = PathGraph[ Range[ 3 ] ] },
  { point = RandomInfraRegionNearest[ graph, InfraRegionNearest[ { 1, 3 }, 2 ] ] },
  InfraSubstrateHighlight[ graph, { <| point -> 1 |> } ] ]
```
