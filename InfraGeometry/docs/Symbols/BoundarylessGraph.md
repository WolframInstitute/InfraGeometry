---
Template: Symbol
Name: BoundarylessGraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/BoundarylessGraph
Keywords: [boundary, rim, open window, substrate preparation, mesh, patch]
SeeAlso: [GraphExteriorBoundary, CenterGraph, InfraSubstrate, TessellationNeighborhoodGraph]
RelatedGuides: [InfraSubstrates]
---

## Usage

<code>[BoundarylessGraph]()[*g*]</code> deletes every edge of *g* with both ends on its rim, then the vertices this leaves without an edge.

<code>[BoundarylessGraph]()[*mr*]</code> does the same on the edges of the mesh region *mr*, whose rim is its boundary.

## Details & Options

With *∂g* the rim, <code>[GraphExteriorBoundary]()[*g*]</code>, the result is *g* − {*uv* : *u*, *v* ∈ *∂g*}, without its isolated vertices.

The contour of the rim disappears, and a rim vertex with an edge inward stays as a whisker. The graph models an open subset of the plane or of space: a window onto the geometry with no curve drawn round it.

On the *n* × *n* grid the contour has 4(*n* − 1) edges and the four corners are left isolated, so *n*² − 4 vertices remain.

The patches of [InfraSubstrate]() are made this way: the grids from [GridGraph](), the tilings from balls of [TessellationNeighborhoodGraph](), the meshes from their mesh regions.

| Option | Default | Values |
|---|---|---|
| `"KeepCoordinates"` | [True]() | [False]() drops the vertex coordinates |

[Graph]() options are passed on.

## Basic Examples

The 10 × 10 grid and a triangulated square without their contours, labelled with the number of edges removed:

```wl
With[{mesh = DiscretizeRegion[Rectangle[], MaxCellMeasure -> 0.0085]}, {grid = GridGraph[{10, 10}]},
  GraphicsRow[{Graph[BoundarylessGraph[grid], PlotLabel -> EdgeCount[grid] - EdgeCount[BoundarylessGraph[grid]]],
    Graph[BoundarylessGraph[mesh], PlotLabel -> MeshCellCount[mesh, 1] - EdgeCount[BoundarylessGraph[mesh]]]}]]
```

The removed edges are the edges between two rim vertices:

```wl
With[{g = GridGraph[{10, 10}]}, {rim = GraphExteriorBoundary[g]},
  InfraSubstrateHighlight[g, {Subgraph[g, rim]}, PlotLabel -> EdgeCount[Subgraph[g, rim]], ImageSize -> Medium]]
```

## Options

### KeepCoordinates

Without the coordinates the graph is laid out by springs:

```wl
GraphicsRow @ Table[BoundarylessGraph[GridGraph[{10, 10}], "KeepCoordinates" -> keep], {keep, {True, False}}]
```

## Properties and Relations

The square grid substrate is the 10 × 10 grid without its contour, with 10² − 4 vertices:

```wl
With[{window = BoundarylessGraph[GridGraph[{10, 10}]]},
  {VertexCount[window], Sort @ EdgeList[window] === Sort @ EdgeList @ InfraSubstrate["SquareGridGraph", "Small"]}]
```

The graph of a mesh gives the same window as the mesh region:

```wl
With[{mesh = DiscretizeRegion[Rectangle[], MaxCellMeasure -> 0.0085]}, {graph = IndexGraph @ MeshConnectivityGraph[mesh, 0]},
  Sort[Sort /@ EdgeList @ BoundarylessGraph[graph]] === Sort[Sort /@ EdgeList @ BoundarylessGraph[mesh]]]
```
