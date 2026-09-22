---
Template: Symbol
Name: InfraArc
Context: WolframInstitute`SyntheticInfrageometry`
ContextPath: [WolframInstitute`Infrageometry`]
Paclet: WolframInstitute/SyntheticInfrageometry
URI: WolframInstitute/SyntheticInfrageometry/ref/InfraArc
Keywords: [arc, circle, band, geodesic interval, object]
SeeAlso: [InfraCircle, InfraSegment, FindInfraCircle, GeodesicIntervalGraph, InfraDensity]
RelatedGuides: [EuclideanGeometryGuide]
---

## Usage

<code>[InfraArc]()[*g*, *c*, *p*, *q*]</code> is the arc around *c* from *p* to *q* on the graph *g* as one object: the shortest paths from *p* to *q* inside the band of radius *d*(*c*, *p*), carried as one geodesic DAG with source *p* and sink *q*.

<code>[InfraArc]()[*g*, *c*, *p*, *q*, "Tolerance" -> *t*]</code> widens the band to *d*(*c*, *p*) ± *t*; `{tIn, tOut}` widens it asymmetrically.

## Details & Options

Definition: with *r* = *d*(*c*, *p*) and the band *B* = { *v* : *r* − *t*<sub>in</sub> ≤ *d*(*c*, *v*) ≤ *r* + *t*<sub>out</sub> }, the arc from *p* to *q* is the set of shortest *p*–*q* paths of the subgraph induced on *B*. It is the geodesic interval of the band, so the same object [InfraSegment]() is on the whole graph.

The arc is empty when *q* leaves the band or the band disconnects *p* from *q*.

Antipodal points on a ring carry both half-rings; the circle through *p* is the arc that returns to *p*, see [InfraCircle]().

The object protocol: `arc[[i]]`, `arc[[i ;; j]]`, `Normal[arc]` enumerate the arcs as directed path graphs in canonical order; `arc["Multiplicity"]`, `arc["InfraDensity"]`, `arc["EdgeDensity"]`, `arc["Length"]`, `arc["Graph"]`, `arc["VertexList"]` read the DAG; `arc["Center"]`, `arc["Endpoints"]`, `arc["Band"]` are the anchors.

## Basic Examples

The two half-rings between antipodes of the radius-2 hexagon on a triangular patch.

```wl
With[
  {g = TessellationNeighborhoodGraph[{3, 6}, 5]},
  {c = First @ GraphCenter[g]},
  {ring = Select[VertexList[g], GraphDistance[g, c, #] == 2 &]},
  {p = First @ ring},
  {q = First @ Select[ring, GraphDistance[Subgraph[g, ring], First @ ring, #] == 6 &]},
  {arc = InfraArc[g, c, p, q]},
  {arc["Multiplicity"], arc["Length"], InfraSceneHighlight[g, {arc, c}]}
]
```
