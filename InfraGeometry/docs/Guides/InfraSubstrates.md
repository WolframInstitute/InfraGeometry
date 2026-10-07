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

The substrate is the graph the observer lives on. InfraSubstrate names the example substrates every figure is built on, at three sizes, with the style they are drawn in and the code that builds them. The tessellation graphs are the regular and uniform maps: a Platonic solid, a flat torus or a hyperbolic quotient, and the ball cut from an infinite tiling of the plane, the hyperbolic plane or the sphere. A tessellation carries its combinatorial curvature, Euler characteristic and genus, which say what surface the graph is. A uniform-length graph is the contact graph of a hard-sphere packing of a region, a manifold discretised so that its edges have nearly equal length; the example graphs add fractals and trees. A substrate is prepared by cutting it to its centre or removing its rim, and any substrate can be inflated: InflateGraph grows a fiber of extra vertices over every vertex, and InfraSubstrate applies it through its Inflate option. Every function InfraSubstrate builds its roster from is on this page. InfraFiberedSubstrate does the same for fibrations: example fibrations over a cycle, a grid, a torus, the octahedron and a sphere mesh. Two sections still wait: warped products, whose one example today is the Kasner graph in the dev repo's experimental code, and a test whether a graph is surface-like, that is, whether at the scale of the constructions its metric balls are discs and its metric shells are cycles.

## Functions

### Named substrates

- `InfraSubstrate` the named example substrate at size "Small", "Medium" or "Large", or at a raw size
- `InfraSubstrateStyle` the option list a substrate backdrop is drawn with at a given size
- `InfraSubstrateCode` the held code behind a named substrate, which evaluates to the same graph

### Tessellation graphs

- `TessellationGraph` the smallest regular map of type {p, q}, or the uniform map of a vertex configuration, as a graph
- `TorusTessellation` the flat-torus graph carrying the square, triangular or hexagonal tessellation
- `TessellationNeighborhoodGraph` the radius-r ball cut from the infinite regular {p, q} tessellation, with its embedding

### Uniform-length graphs

- `UniformLengthGraph` the contact graph of a hard-sphere packing relaxed in a region, filling a solid or meshing a surface
- `UniformLengthEmbedding` coordinates in R^d under which the edges of a graph have length close to 1

### Other example graphs

- `SierpinskiGraph` the trivalent Sierpinski graph
- `BetheGraph` the finite Bethe lattice, or Cayley tree, of n shells and coordination number z
- `BranchingSequenceTree` the spherically symmetric rooted tree whose offspring count depends only on depth

### Surface-like graphs

- `TessellationCurvature` the combinatorial Gaussian curvature at a vertex of a regular or uniform map; its sign says spherical, flat or hyperbolic
- `TessellationEulerCharacteristic` the Euler characteristic V - E + F of a tessellation graph
- `TessellationGenus` the orientable genus of a tessellation graph, from its Euler characteristic
- waits: a test whether a graph is surface-like at a scale, its metric balls discs and its metric shells cycles

### Preparing a substrate

- `CenterGraph` the substrate cut to the ball of k hops about its centre; a negative k counts back from the radius, Scaled[q] takes a fraction of it
- `BoundarylessGraph` deletes every edge joining two rim vertices and then the vertices this isolates, an open window onto the geometry
- `GraphExteriorBoundary` the rim vertices of the whole graph, the vertices whose neighbourhood is not closed

### Inflated substrates

- `InflateGraph` grows a fiber of extra vertices over every vertex, joined to its base vertex, with random edges from every fiber to the vertices nearby
- `InflatedVertex` the i-th fiber vertex over a base vertex in a graph produced by InflateGraph

### Fibered substrates

- `InfraFiberedSubstrate` the named example fibrations at size "Small", "Medium" or "Large", each a fibration over a substrate: products, coverings, tangent and displacement bundles, branched fibrations; the fibrations themselves are on the Infra Fiber Bundles guide

### Warped products

- waits: the warped product of a base and a fiber as a graph; the Kasner graph in the dev repo's experimental code is one example
