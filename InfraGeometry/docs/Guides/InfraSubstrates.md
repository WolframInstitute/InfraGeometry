---
Template: Guide
Name: InfraSubstrates
Title: Infra Substrates
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/InfraSubstrates
Keywords: [substrate, template graph, tessellation, regular map, torus, surface, surface-like, Euler characteristic, genus, inflation, warped product]
RelatedGuides: [EuclideanInfrageometry, RiemannianInfrageometry, InfraTopology, InfraAnalysis, InfraFiberBundles, Experimental]
---

## Abstract

The substrate is the graph the observer lives on. The named example substrates come at three sizes, with the style they are drawn in and the code that builds them. The tessellation graphs are the regular and uniform maps: a Platonic solid, a flat torus or a hyperbolic quotient, and the ball cut from an infinite tiling of the plane, the hyperbolic plane or the sphere. A tessellation carries its combinatorial curvature, Euler characteristic and genus, which say what surface the graph is. A uniform-length graph is the contact graph of a hard-sphere packing of a region, a manifold discretised so that its edges have nearly equal length; fractals and trees complete the examples. A substrate is prepared by cutting it to its centre or removing its rim, and any substrate can be inflated by growing a fiber of new vertices over every vertex. Fibered substrates are the same catalogue for fibrations.

## Functions

### Named substrates

- `InfraSubstrate` the named example substrate at size "Small", "Medium" or "Large"
- `InfraSubstrateStyle` the options a substrate is drawn with at a given size
- `InfraSubstrateCode` the held code that builds a named substrate

### Tessellation graphs

- `TessellationGraph` the smallest regular map of type $\{p, q\}$, or a uniform map, as a graph
- `TorusTessellation` the flat torus with the square, triangular or hexagonal tessellation
- `TessellationNeighborhoodGraph` the $r$-ball cut from the infinite $\{p, q\}$ tessellation
- `GridGraph` (WL), `TorusGraph` (WL), `PolyhedronData` (WL), `GraphData` (WL)

### Surface-like graphs

- `TessellationCurvature` the combinatorial Gaussian curvature at a vertex of a map
- `TessellationEulerCharacteristic` the Euler characteristic $V - E + F$ of a tessellation graph
- `TessellationGenus` the genus of the surface a map lies on

### Uniform-length graphs

- `UniformLengthGraph` the contact graph of a hard-sphere packing of a region
- `UniformLengthEmbedding` coordinates under which every edge has length close to 1
- `GraphEmbedding` (WL) the coordinates a graph is drawn with

### Fractals and trees

- `SierpinskiGraph` the trivalent Sierpinski graph
- `BetheGraph` the finite Bethe lattice of $n$ shells and coordination number $z$
- `BranchingSequenceTree` the spherically symmetric tree whose branching depends only on depth
- `KaryTree` (WL), `CompleteKaryTree` (WL)

### Preparing a substrate

- `CenterGraph` the substrate cut to the ball about its centre
- `BoundarylessGraph` the substrate with its rim edges removed
- `GraphExteriorBoundary` the rim vertices, whose neighbourhood is not closed

### Inflated substrates

- `InflateGraph` a fiber of new vertices grown over every vertex, with random vertical and horizontal edges
- `InflatedVertex` the $i$-th fiber vertex over a base vertex of an inflated graph

### Fibered substrates

- `InfraFiberedSubstrate` the named example fibrations: products, coverings, tangent and displacement bundles, branched fibrations
