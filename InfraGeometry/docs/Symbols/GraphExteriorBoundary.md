---
Template: Symbol
Name: GraphExteriorBoundary
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/GraphExteriorBoundary
Keywords: [boundary, rim, vertex degree, mesh boundary, patch, substrate preparation]
SeeAlso: [BoundarylessGraph, CenterGraph, InfraSubstrate, InfraBoundary]
RelatedGuides: [InfraSubstrates]
---

## Usage

<code>[GraphExteriorBoundary]()[*g*]</code> gives the rim of the graph *g*: the vertices whose degree is below the mean degree.

<code>[GraphExteriorBoundary]()[*mr*]</code> gives the vertices on the boundary of the mesh region *mr*.

## Details & Options

Definition: for a graph, the rim is the set of vertices whose degree is below a threshold, the mean degree with [Method]() -> `"AverageDegree"` (the default) or the largest degree with [Method]() -> `"MaxDegree"`. For a mesh region of dimension *d*, the rim is the set of vertices of the (*d* − 1)-cells that lie in exactly one *d*-cell: its exact boundary, given as positions in [MeshCoordinates](). A region of dimension 1 or less has none.

Inside a lattice or a tiling every vertex has the largest degree, so `"MaxDegree"` finds the rim exactly. Inside a mesh the degrees vary, and `"AverageDegree"` is a guess that also marks some vertices inside.

The rim is that of the whole graph. The boundary of a set of vertices inside the graph is [InfraBoundary]().

## Basic Examples

The rim of the square, hexagonal and triangular tilings, the vertices of less than full degree.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    InfraSubstrateHighlight[g, {GraphExteriorBoundary[g, Method -> "MaxDegree"]}]],
  {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]
```

The boundary of a triangulated disk: the vertices on its circle.

```wl
With[
  {mesh = DiscretizeRegion[Disk[], MaxCellMeasure -> 0.01]},
  {rim = GraphExteriorBoundary[mesh]},
  {InfraSubstrateHighlight[IndexGraph @ MeshConnectivityGraph[mesh, 0], {rim}], Length[rim]}]
```

## Scope

A solid: the boundary of a tetrahedral mesh of the ball is the sphere.

```wl
With[
  {mesh = DiscretizeRegion[Ball[], MaxCellMeasure -> 0.05]},
  {rim = GraphExteriorBoundary[mesh]},
  {Graph3D[Subgraph[IndexGraph @ MeshConnectivityGraph[mesh, 0], rim]], MinMax[Norm /@ MeshCoordinates[mesh][[rim]]]}]
```

## Properties and Relations

[BoundarylessGraph]() deletes the edges between rim vertices, so the contour disappears and the vertices with an edge inward stay as whiskers.

```wl
With[
  {g = GridGraph[{8, 8}]},
  {rim = GraphExteriorBoundary[g, Method -> "MaxDegree"]},
  {GraphicsRow[{InfraSubstrateHighlight[g, {rim}], BoundarylessGraph[g, Method -> "MaxDegree"]}], Length[rim]}]
```

## Possible Issues

On the graph of a mesh the degree test also marks vertices inside. The disk has 43 vertices on its circle; the mean degree marks 111.

```wl
With[
  {mesh = DiscretizeRegion[Disk[], MaxCellMeasure -> 0.01]},
  {graph = IndexGraph @ MeshConnectivityGraph[mesh, 0]},
  {rims = {GraphExteriorBoundary[mesh], GraphExteriorBoundary[graph]}},
  {GraphicsRow[InfraSubstrateHighlight[graph, {#}] & /@ rims], Length /@ rims}]
```
