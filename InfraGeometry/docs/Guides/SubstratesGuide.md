---
Template: Guide
Name: SubstratesGuide
Title: Substrates
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/SubstratesGuide
Keywords: [substrate, template graph, tessellation, regular map, torus, surface, Euler characteristic, genus, warped product]
RelatedGuides: [EuclideanGeometryGuide, RiemannianGeometryGuide, TopologicalPropertiesGuide, TangentSpacesAndFormsGuide, FiberBundlesGuide, Experimental]
---

## Abstract

The substrate is the graph the observer lives on. InfraSubstrate names the example substrates every figure is built on, at three sizes, with the style they are drawn in and the code that builds them. The tessellation graphs are the regular and uniform maps: a Platonic solid, a flat torus or a hyperbolic quotient, and the ball cut from an infinite tiling of the plane, the hyperbolic plane or the sphere. A tessellation carries its combinatorial curvature, Euler characteristic and genus, which say what surface the graph is. Two sections still wait: warped products, whose one example today is the Kasner graph in the dev repo's experimental code, and a test whether a given graph is surface-like.

## Functions

### Named substrates

- `InfraSubstrate` the named example substrate at size "Small", "Medium" or "Large"
- `InfraSubstrateStyle` the option list a substrate backdrop is drawn with at a given size
- `InfraSubstrateCode` the code behind a named substrate, whose evaluation gives the same graph

### Tessellation graphs

- `TessellationGraph` the smallest regular map of type {p, q}, or the uniform map of a vertex configuration, as a graph
- `TorusTessellation` the flat-torus graph carrying the square, triangular or hexagonal tessellation
- `TessellationNeighborhoodGraph` the radius-r ball cut from the infinite regular {p, q} tessellation, with its embedding

### Surface-like graphs

- `TessellationCurvature` the combinatorial Gaussian curvature at a vertex of a regular or uniform map; its sign says spherical, flat or hyperbolic
- `TessellationEulerCharacteristic` the Euler characteristic V - E + F of a tessellation graph
- `TessellationGenus` the orientable genus (2 - chi)/2 of a tessellation graph
- waits: a test whether a given graph is surface-like

### Warped products

- waits: the warped product of a base and a fiber as a graph; Code/KasnerGraph.wl in the dev repo is one example, experimental
