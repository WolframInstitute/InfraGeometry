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

<code>[RandomInfraMidpoint]()[*graph*, *p*, *q*, *count*]</code> samples the central vertices of the oriented segment graph from *p* to *q*.

<code>[RandomInfraMidpoint]()[*graph*, *token*, *count*]</code> accepts an [InfraMidpoint]() token.

## Details & Options

The segment graph contains all shortest paths from *p* to *q*, oriented toward *q*.
A central vertex minimizes Max[d(p,v),d(v,q)] within this graph.
Even endpoint distance gives one middle layer; odd distance gives both middle layers.
Disconnected endpoints give an empty family; equal anchors give one point.
Sampling is uniform over distinct central vertices. The InfraMidpoint "VertexDensity" measurement separately counts shortest-path occupation at each center.

The graph must be finite, simple, undirected and unweighted, with valid anchors.
Omitted count or Automatic gives one uniformly random vertex; an empty pool gives {}.
An integer gives that many distinct vertices, or {} when too few exist.
UpTo[n] gives at most n distinct vertices; All gives the complete pool in graph vertex order.
Zero gives {}; negative counts and unsupported options stay unevaluated.

"NextVertexFunction" defaults to Automatic. Identity selects in graph vertex order.
These are the only supported selector values. All and Identity are deterministic. `RandomSeeding -> Automatic` (default) seeds each call afresh, independently of `SeedRandom`; an integer or string gives a reproducible draw, and `Inherited` a local snapshot of the current state. The outer random state is restored afterward, as with [RandomInstance](https://reference.wolfram.com/language/ref/RandomInstance.html).
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
  { point = RandomInfraMidpoint[ graph, InfraMidpoint[ 1, 3 ], RandomSeeding -> 71 ] },
  InfraSubstrateHighlight[ graph, { <| point -> 1 |> } ] ]
```

## Options

### RandomSeeding

A fixed seed reproduces the draw, whatever state `SeedRandom` has set:

```wl
Table[SeedRandom[k]; RandomInfraMidpoint[CycleGraph[4], 1, 3, RandomSeeding -> 7], {k, 2}]
```
