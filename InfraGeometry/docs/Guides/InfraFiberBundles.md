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

A fibration of graphs is a total graph with a projection of its vertices onto a base graph. The fiber over a base vertex is the subgraph on its preimage. Three heads carry a fibration: the literal InfraFibration and the constructions InfraTangentBundle, InfraCotangentBundle and InfraDisplacementBundle over a base graph at a scale. Every function on this page reads a fibration through two primitives, InfraTotalGraph and InfraFibrationAssociation, so it runs on all of them. Sections and connections are inert maps that carry no graph. A section picks a total vertex over each base vertex. A connection chooses the lifts of the base edges, and transport around a closed walk permutes a fiber, its holonomy. The Levi-Civita connection is the connection of the displacement bundle that the metric singles out. The names InfraParallelTransport, InfraHolonomy, InfraHolonomyAngle, InfraCovariantDerivative and InfraCanonicalOneForm also exist in the InfraGaugeTheory paclet with other signatures. With both paclets loaded in one kernel the later load shadows the earlier; load them in separate kernels or call the symbols by their full context.

## Functions

### Fibrations

- `InfraFibration` a fibration: the total graph with the projection of its vertices onto the base; with a construction, the same fibration as a literal one
- `InfraTotalGraph`, `InfraFibrationAssociation` the two primitives: the total graph, and the projection as an association from total vertices to base vertices
- `InfraBaseGraph` the base graph reconstructed from the projection: two base vertices adjacent iff some total edge projects onto them
- `InfraFiber`, `InfraFibers` the fiber over a base vertex, or over every base vertex, as a subgraph of the total graph
- `InfraFibrationQ` whether every total vertex over p has a neighbour over every base neighbour of p, the edge lifting property
- `InfraFiberBundleQ` whether the fibers are isomorphic, each base edge lifts once at each vertex, and the fibration is trivial over every ball of radius 1
- `RandomInfraFibration` a random fibration over a base graph, each fiber drawn around its base vertex

### The tangent, cotangent and displacement bundles

- `InfraRays` the rays of length r from a vertex, the walks that move one step further from it at each step
- `InfraTangentBundle` the rays of length r over their first vertex, two rays adjacent iff their vertices are equal or adjacent at every position
- `InfraCotangentBundle` the reversed rays over their last vertex, with the adjacency of the tangent bundle
- `InfraDisplacementBundle` the pairs of vertices at distance r over their first vertex, two pairs adjacent iff their base points and their endpoints are equal or adjacent
- `InfraBundleMorphismQ` whether a map of total vertices is a graph homomorphism covering a map of the bases
- `InfraBundleMorphism` the natural map between two bundles over one base: the endpoint map, the truncation, the reversal

### Sections

- `InfraSection` a section as an inert map from base vertices to total vertices over them
- `InfraSectionQ` whether each value lies over its base vertex
- `InfraContinuousSectionQ` whether a section sends every base edge between its keys to a total edge
- `RandomInfraSection` a random total vertex over every base vertex
- `FindInfraSection` continuous sections over the whole base, by a count n, UpTo[n] or All

### Connections and holonomy

- `InfraConnection` a connection as an inert set of horizontal edges, one lift of each base edge at each total vertex
- `InfraConnectionQ` whether the edges are a connection of a fibration
- `InfraFlatConnectionQ` whether each horizontal leaf meets every fiber at most once, so that every holonomy is trivial
- `RandomInfraConnection` a connection from a random maximum matching over every base edge
- `FindInfraHorizontalLift` the lifts of a base walk along a connection from a total vertex
- `InfraParallelTransport` the transport of the fiber over the first vertex of a walk, from each fiber vertex to the end of its lift
- `InfraHolonomy` the transport around a closed walk, as Cycles on the fiber

### The Levi-Civita connection

- `FindInfraLeviCivitaConnection` the single Levi-Civita connection of a displacement bundle: over each edge, the first of the best angle-isometries of the direction spheres
- `InfraParallelTransport` without a connection, on a displacement bundle: the list of every Levi-Civita realisation along a walk
- `InfraHolonomyAngle` the unsigned angle of the holonomy around a loop in arc radians; without a connection, the least angle over the realisations
- `InfraCovariantDerivative` the covariant derivative of a section of a displacement bundle along a walk
- `InfraCanonicalOneForm` the pairing of a vector with the step to a vertex, the polar form of the path metric

### The catalogue

- `InfraFiberedSubstrate` the named example fibrations at size "Small", "Medium" or "Large": products, coverings, tangent and displacement bundles over a grid, a torus, the octahedron and a sphere, and branched fibrations that are not bundles

### Not here

- not here: a connection with a structure group on the base, the gauge-theory flavour; it stays in the InfraGaugeTheory paclet
