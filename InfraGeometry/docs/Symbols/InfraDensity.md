---
Template: Symbol
Name: InfraDensity
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraDensity
Keywords: [density, occupation, marginal, counting measure, multiset, support]
SeeAlso: [InfraMeasurement, InfraVertexList, InfraSubstrateHighlight, FindInfraSegment, FindInfraMidpoint, InfraIntersection]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraDensity]()[*graph*, *x*]</code> gives the marginal of the shape *x* to the vertex set of *graph*, an `Association` of vertices *v* to masses *m*, with respect to the counting measure.

## Details & Options

Definition: the density of a shape is the number of times it covers each vertex: once for a vertex, once per occurrence in a vertex list, and once per walk through the vertex for a family of walks.

It reads every shape:

| *x* | <code>[InfraDensity]()[*graph*, *x*]</code> |
|---|---|
| a vertex *v* | `<\|v -> 1\|>` |
| a vertex list | its `Counts` |
| a density `<\|v -> m\|>` | itself |
| a walk graph, a DAG, or a `List` of walks | the number of walks through each vertex |

The result is key-sorted, so two densities built by different routes compare with `SameQ`.

It is the one coercion of the API. `Keys` demotes a density to its support, and `Counts` promotes a vertex list to a density.

A Euclidean head is not a shape here: <code>[InfraDensity]()[*graph*, [InfraSegment]()[*p*, *q*]]</code> is `<|InfraSegment[p, q] -> 1|>`. The density of a head is <code>[InfraMeasurement]()[*graph*, *obj*, "VertexDensity"]</code>, and it equals the density of the head's members.

It is the raw marginal and takes no options. The two normalisations are one division away: `d / Max[d]` is the occupation in [0, 1], and `d / Total[d]` is the distribution summing to 1.

## Basic Examples

The six geodesics from the centre of a grid to a vertex two steps up and two across, as a density: both end points are covered six times, the middle vertex four times. Each vertex is drawn as large as its mass.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {dens = InfraDensity[g, FindInfraSegment[g, 41, 61, All]]},
  {InfraSubstrateHighlight[g, dens, "PointSizeRange" -> {4, 16}, ImageSize -> 250], dens}]
```

A vertex, a vertex list with a repeat, and a density.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {InfraDensity[g, 41], InfraDensity[g, {42, 41, 42}], InfraDensity[g, <|42 -> 2, 41 -> 1|>]}]
```

The two normalisations.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {dens = InfraDensity[g, FindInfraSegment[g, 41, 61, All]]},
  {dens[51] / Max[dens], Total[dens / Total[dens]]}]
```

## Properties and Relations

The density of a head's members is the head's `"VertexDensity"`, and so is the density of the head's graph.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {seg = InfraSegment[41, 61]},
  {InfraDensity[g, InfraVertexList[g, seg, All]] === InfraMeasurement[g, seg, "VertexDensity"],
   InfraDensity[g, InfraMeasurement[g, seg, "Graph"]] === InfraMeasurement[g, seg, "VertexDensity"]}]
```

A head itself is not read.

```wl
InfraDensity[GridGraph[{9, 9}], InfraSegment[41, 61]]
```

[FindInfraMidpoint]() returns a density: the number of geodesics centred at each vertex.

```wl
FindInfraMidpoint[GridGraph[{9, 9}], 41, 61]
```
