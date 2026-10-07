---
Template: Symbol
Name: InfraGeodesic
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraGeodesic
Keywords: [geodesic, infra-scale, window graph, extension, germ, inert head]
SeeAlso: [FindInfraGeodesic, InfraGeodesicQ, InfraMeasurement, FindInfraRepresentative, InfraRay, InfraLine]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

<code>[InfraGeodesic]()[*germ*, *s*]</code> is the geodesics at infra-scale *s* through *germ*, a vertex list: the walks extending *germ* in which every *s* consecutive vertices together with the next one form a shortest path. It is inert; [InfraMeasurement]() and [FindInfraRepresentative]() evaluate it on a graph.

## Details & Options

Its graph — <code>[InfraMeasurement]()[*g*, InfraGeodesic[*germ*, *s*], "Graph"]</code> — is the window graph of the forward extensions. A vertex is a window, the last at most *s* vertices of a walk, as a list. A window *w*<sub>1</sub>, …, *w*<sub>m</sub> has an arrow to the window that appends *v* whenever *d(w<sub>1</sub>, v) = m*. The admissible step depends on the window alone, so the walks of *k* edges from the germ's window are exactly the *k*-step forward extensions of *germ*: the germ followed by the last vertex of each window, revisits included.

The graph carries no length budget. It is finite, and its cycles are the closed geodesics at scale *s*; at scale 1 it is the graph with both orientations of every edge. The extensions of *k* steps are read off the powers of its adjacency matrix rather than listed.

At scale `Infinity` the walk is a shortest path from the germ's first vertex *p*, so the window collapses to its last vertex. The graph is then the part of the ray DAG of <code>[InfraRay]()[*p*, *q*]</code> reachable from the germ's last vertex *q*; for a one-vertex germ it is the pencil at *p*.

The germ must itself be a geodesic at scale *s*; otherwise the call stays unevaluated.

A member read by [FindInfraRepresentative]() is an inextensible simple geodesic through the germ, grown on both sides.

## Basic Examples

The endpoints of the six-step extensions of a three-edge germ ending at the centre, sized by how many extensions end there, at scales 2, 4 and 8. At scale 2 they spread over a wide arc; from scale 4 on they gather.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
    {o = First @ GraphCenter[g]},
    {germ = First @ FindInfraRepresentative[g, InfraSegment[(SeedRandom[2]; FindInfraPoint[g, InfraShell[o, 3]]), o], 1]},
    {windows = InfraMeasurement[g, InfraGeodesic[germ, scale], "Graph"]},
    {from = UnitVector[VertexCount[windows], VertexIndex[windows, Take[germ, -Min[scale, Length[germ]]]]]},
    {ends = Select[Merge[Thread[Last /@ VertexList[windows] -> from . MatrixPower[AdjacencyMatrix[windows], 6]], Total], Positive]},
    InfraSubstrateHighlight[g, {ends, InfraWalk[germ]}]],
  {scale, {2, 4, 8}}]
```

At scale `Infinity` the graph is drawn on the substrate beside the ray through the germ's ends: the same arrows past the germ.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {o = First @ GraphCenter[g]},
  {through = (SeedRandom[1]; FindInfraPoint[g, InfraShell[o, 2]])},
  {germ = First @ FindInfraRepresentative[g, InfraSegment[o, through], 1]},
  {windows = InfraMeasurement[g, InfraGeodesic[germ, Infinity], "Graph"]},
  GraphicsRow[{InfraSubstrateHighlight[g, {windows, InfraWalk[germ]}],
    InfraSubstrateHighlight[g, {InfraRay[o, through], InfraWalk[germ]}]}]]
```

## Properties and Relations

The walks of *k* edges from the germ's window are the extensions [FindInfraGeodesic]() lists. The number of windows, whether the graph has cycles, the number of six-step extensions read off the adjacency matrix, and the number listed.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {o = First @ GraphCenter[g]},
  {germ = First @ FindInfraRepresentative[g, InfraSegment[(SeedRandom[2]; FindInfraPoint[g, InfraShell[o, 3]]), o], 1]},
  Table[
    With[
      {windows = InfraMeasurement[g, InfraGeodesic[germ, scale], "Graph"]},
      {from = UnitVector[VertexCount[windows], VertexIndex[windows, Take[germ, -Min[scale, Length[germ]]]]]},
      {scale, VertexCount[windows], AcyclicGraphQ[windows], Total[from . MatrixPower[AdjacencyMatrix[windows], 6]],
       Length @ FindInfraGeodesic[g, germ, scale, {6}, All]}],
    {scale, {1, 2, 4, 8}}]]
```

At scale `Infinity` the graph is the part of the [InfraRay]() graph past the germ.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {o = First @ GraphCenter[g]},
  {through = (SeedRandom[1]; FindInfraPoint[g, InfraShell[o, 2]])},
  {germ = First @ FindInfraRepresentative[g, InfraSegment[o, through], 1]},
  {ray = InfraMeasurement[g, InfraRay[o, through], "Graph"]},
  Sort @ EdgeList @ InfraMeasurement[g, InfraGeodesic[germ, Infinity], "Graph"] ===
    Sort @ EdgeList @ Subgraph[ray, VertexOutComponent[ray, through]]]
```
