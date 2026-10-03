---
Template: Guide
Name: InfraFiberBundles
Title: Infra Fiber Bundles
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/InfraFiberBundles
Keywords: [fiber bundle, fibered graph, base graph, fiber, connection, parallel transport, holonomy, section]
RelatedGuides: [EuclideanInfrageometry, RiemannianInfrageometry, InfraTopology, InfraAnalysis, InfraSubstrates, Experimental]
---

## Abstract

A fibered graph is a graph with a projection onto a base graph, the preimage of each base vertex its fiber. It is a fiber bundle when the fibers are isomorphic and the edges over each base edge lift consistently. A connection chooses how an edge of the base lifts to the fibers; transport along a closed walk of the base returns a permutation of the fiber, its holonomy, and the connection is flat when every holonomy is trivial. A section picks a vertex of each fiber. The Levi-Civita connection is the connection of the displacement bundle that the metric singles out: over each edge the best angle-isometries of the direction spheres fixing the geodesics through it. Three heads carry a fibration: the literal InfraFibration and the two constructions InfraTangentBundle and InfraDisplacementBundle. Every function runs on all three through InfraTotalGraph and InfraFibrationAssociation. Sections, connections and bundle morphisms are inert maps that carry no graph. The names InfraParallelTransport, InfraHolonomy, InfraHolonomyAngle, InfraCovariantDerivative and InfraCanonicalOneForm also exist in the InfraGaugeTheory paclet with other signatures. With both paclets loaded in one kernel the later load shadows the earlier; load them in separate kernels or call the symbols by their full context.

## Functions

### Fibrations

- **InfraFibration** — a fibered graph: the total graph with its projection onto the base
- **InfraTotalGraph** — the total graph of a fibration
- **InfraFibrationAssociation** — the projection of a fibration, total vertex to base vertex
- **InfraBaseGraph** — the base graph reconstructed from the projection
- **InfraFiber** — the fiber over a base vertex, as a subgraph of the total graph
- **InfraFibers** — the fibers over all base vertices
- **RandomInfraFibration** — a random fibered graph over a base
- **InfraFibrationQ** — whether edges of the base lift to the total graph
- **InfraFiberBundleQ** — whether the fibers are isomorphic and the fibration is locally trivial
- **InfraBundleMorphismQ** — whether a map of total vertices is a graph homomorphism covering a map of bases

### Tangent, cotangent and displacement bundles

- **InfraRays** — the rays of a given length from a vertex
- **InfraTangentBundle** — the bundle of rays of length r, adjacent vertexwise
- **InfraCotangentBundle** — the tangent bundle on reversed rays
- **InfraDisplacementBundle** — the bundle of pairs of vertices at distance r
- **InfraBundleMorphism** — the natural map between two bundles: endpoint, truncation, reversal

### Sections

- **InfraSection** — a section as an inert map from base vertices to total vertices
- **InfraSectionQ** — whether a map picks a vertex of each fiber
- **InfraContinuousSectionQ** — whether a section sends base edges to total edges
- **RandomInfraSection** — a random section of a fibration
- **FindInfraSection** — continuous sections over the whole base

### Connections and holonomy

- **InfraConnection** — the horizontal edges chosen as lifts of the base edges
- **InfraConnectionQ** — whether the edges form a connection of a fibration
- **InfraFlatConnectionQ** — whether the horizontal leaves project injectively
- **RandomInfraConnection** — a random connection of a fibration
- **FindInfraHorizontalLift** — the horizontal lifts of a walk from a fiber vertex
- **InfraParallelTransport** — the transport of a fiber along a walk; on a displacement bundle without a connection, the Levi-Civita transports
- **InfraHolonomy** — the transport around a closed walk, as Cycles on the fiber

### Levi-Civita connection

- **FindInfraLeviCivitaConnection** — the connection of a displacement bundle singled out by the metric
- **InfraHolonomyAngle** — the unsigned angle of the holonomy around a loop, in arc radians
- **InfraCovariantDerivative** — the covariant derivative of a section along a walk
- **InfraCanonicalOneForm** — the pairing of a vector with the step of its base point
