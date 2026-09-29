---
Template: Guide
Name: SubstratesGuide
Title: Substrates
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/SubstratesGuide
Keywords: [substrate, template graph, tessellation, regular map, torus, surface, surface-like, Euler characteristic, genus, inflation, warped product]
RelatedGuides: [EuclideanGeometryGuide, RiemannianGeometryGuide, TopologicalPropertiesGuide, TangentSpacesAndFormsGuide, FiberBundlesGuide, Experimental]
---

## Abstract

The substrate is the graph the observer lives on. InfraSubstrate names the example substrates every figure is built on, at three sizes, with the style they are drawn in and the code that builds them. The tessellation graphs are the regular and uniform maps: a Platonic solid, a flat torus or a hyperbolic quotient, and the ball cut from an infinite tiling of the plane, the hyperbolic plane or the sphere. A tessellation carries its combinatorial curvature, Euler characteristic and genus, which say what surface the graph is. Any substrate can be inflated: InflateGraph grows a fiber of extra vertices over every vertex, and InfraSubstrate applies it through its Inflate option. Two sections still wait: warped products, whose one example today is the Kasner graph in the dev repo's experimental code, and a test whether a graph is surface-like, that is, whether at the scale of the constructions its metric balls are discs and its metric shells are cycles.

## Functions

### Named substrates

- `InfraSubstrate` the named example substrate at size "Small", "Medium" or "Large", or at a raw size
- **InfraSubstrateStyle** — the option list a substrate backdrop is drawn with at a given size
- **InfraSubstrateCode** — the held code behind a named substrate, which evaluates to the same graph

### Tessellation graphs

- `TessellationGraph` the smallest regular map of type {p, q}, or the uniform map of a vertex configuration, as a graph
- `TorusTessellation` the flat-torus graph carrying the square, triangular or hexagonal tessellation
- **TessellationNeighborhoodGraph** — the radius-r ball cut from the infinite regular {p, q} tessellation, with its embedding

### Surface-like graphs

- **TessellationCurvature** — the combinatorial Gaussian curvature at a vertex of a regular or uniform map; its sign says spherical, flat or hyperbolic
- **TessellationEulerCharacteristic** — the Euler characteristic V - E + F of a tessellation graph
- **TessellationGenus** — the orientable genus of a tessellation graph, from its Euler characteristic
- waits: a test whether a graph is surface-like at a scale, its metric balls discs and its metric shells cycles

### Inflated substrates

- **InflateGraph** — grows a fiber of extra vertices over every vertex, joined to its base vertex, with random edges between nearby fibers
- **InflatedVertex** — the i-th fiber vertex over a base vertex in a graph produced by InflateGraph

### Warped products

- waits: the warped product of a base and a fiber as a graph; the Kasner graph in the dev repo's experimental code is one example
