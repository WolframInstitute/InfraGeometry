---
Template: Guide
Name: InfraFiberBundles
Title: Infra Fiber Bundles
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/InfraFiberBundles
Keywords: [fibration, fiber bundle, fibered graph, base graph, fiber, tangent bundle, displacement bundle, section, connection, parallel transport, holonomy, Levi-Civita]
RelatedGuides: [EuclideanInfrageometry, RiemannianInfrageometry, InfraTopology, InfraAnalysis, InfraSubstrates, Experimental]
---

## Abstract

A fibration of graphs is a total graph with a projection of its vertices onto a base graph; the fiber over a base vertex is the subgraph on its preimage. The tangent, cotangent and displacement bundles of a graph at a scale are fibrations over it. A section picks a total vertex over each base vertex. A connection chooses the lifts of the base edges, and transport around a closed walk permutes a fiber, its holonomy. The Levi-Civita connection is the connection of the displacement bundle that the metric singles out. The names of parallel transport, holonomy, holonomy angle, covariant derivative and canonical one-form also exist in the InfraGaugeTheory paclet with other signatures; load the two paclets in separate kernels or call the symbols by their full context.

## Functions

### Fibrations

- `InfraFibration` a fibration, the total graph with the projection of its vertices onto the base
- `InfraTotalGraph`, `InfraFibrationAssociation` the total graph, and the projection as an association
- `InfraBaseGraph` the base graph reconstructed from the projection
- `InfraFiber`, `InfraFibers` the fiber over a base vertex, or over every base vertex
- `RandomInfraFibration` a random fibration over a base graph

- `InfraFibrationQ`, `InfraFiberBundleQ`, `IsomorphicGraphQ` (WL), `GraphProduct` (WL)

### The tangent, cotangent and displacement bundles

- `InfraRays` the rays of length $r$ from a vertex
- `InfraTangentBundle` the rays of length $r$ over their first vertex
- `InfraCotangentBundle` the reversed rays over their last vertex
- `InfraDisplacementBundle` the pairs of vertices at distance $r$ over their first vertex
- `InfraBundleMorphism` the natural maps between bundles over one base

- `InfraBundleMorphismQ`

### Sections

- `InfraSection` a section, a map from base vertices to total vertices over them
- `RandomInfraSection` a random total vertex over every base vertex
- `FindInfraSection` continuous sections over the whole base

- `InfraSectionQ`, `InfraContinuousSectionQ`

### Connections and holonomy

- `InfraConnection` a connection, one lift of each base edge at each total vertex
- `RandomInfraConnection` a connection from a random maximum matching over every base edge
- `FindInfraHorizontalLift` the lifts of a base walk along a connection
- `InfraParallelTransport` the transport of a fiber along a walk
- `InfraHolonomy` the transport around a closed walk, as a permutation of the fiber

- `InfraConnectionQ`, `InfraFlatConnectionQ`, `FindIndependentEdgeSet` (WL), `PermutationCycles` (WL)

### The Levi-Civita connection

- `FindInfraLeviCivitaConnection` the Levi-Civita connection of a displacement bundle
- `InfraParallelTransport` every Levi-Civita realisation of transport along a walk
- `InfraHolonomyAngle` the angle of the holonomy around a loop
- `InfraCovariantDerivative` the covariant derivative of a section along a walk
- `InfraCanonicalOneForm` the pairing of a vector with the step to a vertex

### Examples

- `InfraFiberedSubstrate` the named example fibrations: products, coverings, bundles over grids, tori and spheres, and branched fibrations
