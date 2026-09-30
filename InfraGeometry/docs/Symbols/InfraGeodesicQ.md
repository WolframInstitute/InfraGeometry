---
Template: Symbol
Name: InfraGeodesicQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraGeodesicQ
Keywords: [geodesic, infra-scale, locally shortest, walk, test]
SeeAlso: [FindInfraGeodesic, ExtendInfraGeodesic, InfraWalkQ, InfraSegmentQ, SegmentGraph]
RelatedGuides: [RiemannianGeometryGuide]
---

## Usage

<code>[InfraGeodesicQ]()[*g*, *walk*, *s*]</code> gives `True` if *walk* is a geodesic at infra-scale *s* in *g*, and `False` otherwise.

<code>[InfraGeodesicQ]()[*g*, *walk*]</code> tests at scale `Infinity`: whether *walk* is a shortest path.

## Details & Options

Definition: a walk *v0*, …, *vk* is a geodesic at infra-scale *s* when every window of *s* consecutive vertices together with the next one is a shortest path: *d(v(i−s), vi) = s* for *i ≥ s*, and *d(v0, vi) = i* for *i < s*.

The condition gets stronger as *s* grows, so a walk that passes at *s* passes at every smaller scale. The ladder is exact at both ends: at scale `1` the test is [InfraWalkQ](), at scale `Infinity` it is [InfraSegmentQ]().

*walk* may be a vertex list, a walk graph such as [FindInfraGeodesic]() returns, a list of walk graphs, or a directed acyclic graph. A DAG passes when every path from a source to a sink passes, so the interval and spray graphs can be tested without listing their paths one by one. A walk of fewer than two vertices is not a geodesic.

## Basic Examples

Three walks from the centre of a grid and the scales, among 1 to 4 and `Infinity`, at which each is a geodesic. Round a square, the walk is locally shortest at scale 2 only; round a larger loop, up to scale 3; a staircase is shortest at every scale.

```wl
With[
  {g = GridGraph[{9, 9}]},
  Row[Table[
    Labeled[
      InfraSubstrateHighlight[g, InfraWalk[walk], ImageSize -> 180],
      Select[{1, 2, 3, 4, Infinity}, InfraGeodesicQ[g, walk, #] &]],
    {walk, {{41, 42, 51, 50, 41, 42}, {41, 42, 43, 52, 61, 60, 59, 50}, {41, 42, 51, 52, 61, 62}}}]]]
```

Stepping back is a walk but not a geodesic at scale 2.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {InfraGeodesicQ[g, {41, 42, 41}, 1], InfraGeodesicQ[g, {41, 42, 41}, 2]}]
```

## Properties and Relations

At scale 1 the test is [InfraWalkQ]() and at scale `Infinity` it is [InfraSegmentQ](), on every walk of 4 edges from the centre.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {walkSeqs = Last /@ VertexList[#] & /@ FindInfraGeodesic[g, 41, 1, {4}, All]},
  {AllTrue[walkSeqs, InfraGeodesicQ[g, #, 1] === InfraWalkQ[g, #] &],
   AllTrue[walkSeqs, InfraGeodesicQ[g, #, Infinity] === InfraSegmentQ[g, #] &]}]
```

A geodesic interval graph passes as a whole, since all its paths from the source to the sink are shortest.

```wl
With[
  {g = GridGraph[{9, 9}]},
  InfraGeodesicQ[g, SegmentGraph[g, 41, 61]]]
```
