---
Template: Symbol
Name: InfraCircleThrough
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraCircleThrough
Keywords: [circle, prescribed points, separating cycle, exact family, DAG]
SeeAlso: [InfraCircle, InfraArc, RandomInfraCircleThrough, InfraMeasurement, InfraMemberQ]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

`InfraCircleThrough[points, InfraCircle[center, {r, s}]]` denotes the shortest separating simple circles in the given band containing every prescribed point.

The head is inert. [InfraMeasurement]() reads its exact family on a graph, and [RandomInfraCircleThrough]() samples its members.

## Details & Options

Graphs are finite, simple, undirected and unweighted. The band has integer radii `1 <= r <= s`. `points` is a nonempty list of literal graph vertices, and `center` is a literal graph vertex. The order and repetitions of the requested points have no effect.

A member is a simple cycle contained in `{v : r <= d(center, v) <= s}`. Deleting its vertices must separate the center from the vertices in its connected component whose distance exceeds `s`. An empty outside set makes this separation condition vacuous, as for [InfraCircle]().

First impose every requested point, simplicity and separation. Then minimize the length and retain every tie. This can yield a longer circle than the unconstrained shortest circles in the band. Filtering those unconstrained shortest circles afterward can incorrectly give an empty result.

Representatives are open cyclic vertex lists, with an implicit last-to-first edge. Rotations and reversal identify the same circle. The first requested vertex in `VertexList[graph]` order is the start; its second vertex precedes its last vertex in that graph order. Each distinct circle therefore has one canonical encoding.

A valid request can have an empty family, including when a requested vertex is outside the band. Its cardinality is `0`, length is `Infinity`, and carrier is an empty directed graph. Unsupported domains stay unevaluated.

This construction keeps the center and band explicit. It does not infer a Euclidean circumcenter from arbitrary prescribed points. The existing closed `InfraArc[c, {p, p}]` describes circles through one point using that arc's radial-band construction; this head imposes an arbitrary prescribed set before minimization.

Measurements:

| Property | Value |
|---|---|
| `"Graph"` | exact directed acyclic carrier |
| `"Faithful"` | `True`: complete carrier paths correspond bijectively to circles |
| `"Cardinality"` | number of distinct minimum circles |
| `"Length"` | their common circumference in graph edges |
| `"VertexDensity"` | number of circles containing each substrate vertex |
| `"EdgeDensity"` | number of circles using each undirected substrate edge |
| `"Subgraph"` | induced subgraph on the nonzero vertex support |
| `"CountingMeasure"` | number of vertices in that support |
| `"RiemannianMeasure"` | support vertices whose ambient neighbors all lie in the support |

`All` returns these properties in an Association. Counts and densities are computed from carrier path counts without expanding every circle.

The carrier is an ordinary Graph. Its vertices have the form `{stateID, substrateVertex}`. Its unique source and sink project to the same requested start vertex. A complete source-to-sink path decodes to a circle by `Last /@ Most[path]`. Arbitrary carrier subpaths are partial walks. The compiler remembers visited vertex sets, removes dead states and merges equal continuation families; its construction can take exponential time.

## Basic Examples

The rim of a wheel passes through both prescribed vertices and separates its center.

```wl
SeedRandom[1];
With[
  {g = WheelGraph[5]},
  {circle = InfraCircleThrough[{2, 4}, InfraCircle[1, {1, 1}]]},
  {InfraSubstrateHighlight[g, {circle, 1, 2, 4}],
   InfraMeasurement[g, circle, {"Cardinality", "Length"}]}]
```

Four prescribed rim vertices of a complete graph admit three distinct minimum circles.

```wl
SeedRandom[1];
With[
  {g = CompleteGraph[5]},
  {circle = InfraCircleThrough[{2, 3, 4, 5}, InfraCircle[1, {1, 1}]]},
  {InfraMeasurement[g, circle, "Cardinality"], RandomInfraCircleThrough[g, circle, All]}]
```
