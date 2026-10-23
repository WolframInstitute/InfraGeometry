---
Template: Guide
Name: InfraFiberBundles
Title: Infra Fiber Bundles
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/InfraFiberBundles
Keywords: [fibration, fiber bundle, fibered graph, base graph, fiber, tangent bundle, displacement bundle, section, connection, parallel transport, holonomy, Levi-Civita]
RelatedGuides: [EuclideanInfrageometry, RiemannianInfrageometry, InfraTopology, InfraAnalysis, InfraSubstrates, Experimental]
RelatedTutorials: [InfraBundles, ExperimentalInfraBundles]
---

## Abstract

A fibered graph is an inert total graph with a vertex projection. Its base is reconstructed from that projection and its total edges. General operations generate examples, extend sections, choose complete connections and read transport and monodromy. Graph bundles additionally require a common fiber graph and transverse matchings preserving fiber adjacency. Particular tangent and metric-selected models are Experimental constructions within this category.

## Functions

### Fibered graphs

- `InfraFiberedGraph` the total graph and its projection, as an inert object
- `InfraTotalSpace`, `InfraProjection` the total graph and the projection association
- `InfraBaseSpace` the reconstructed base, including isolated projection values
- `InfraFiber`, `InfraFibers` the induced graph over one base vertex or every base vertex
- `RandomInfraFiberedGraph` nonempty fibers and transverse edges under explicit property and count constraints
- `InfraEdgeLiftMultiplicity` the transverse neighbour count at every total vertex over every adjacent base vertex

- `InfraFiberedGraphQ`, `InfraEqualFiberSizesQ`, `InfraIsomorphicFibersQ`
- `InfraFibrationQ`, `InfraAtMostOneEdgeLiftQ`, `InfraUniqueEdgeLiftingQ`
- `InfraFiberBundleQ`, `InfraCoveringQ`, `InfraBundleMorphismQ`

### Sections

- `InfraSection` an inert right inverse on a chosen base domain
- `RandomInfraSection` sample a section, restrict its domain or extend prescribed values
- `InfraContinuousSectionQ` test adjacency preservation on the section's domain
- `InfraParallelSectionQ` test agreement with a selected complete connection

- `InfraSectionQ`

### Connections and transport

- `InfraConnection` an inert selection of transverse edges
- `RandomInfraConnection` select complete perfect matchings over every base edge
- `InfraHorizontalLift` the unique ordered lift from a specified starting vertex
- `InfraParallelTransport` the induced fiber bijection along a base walk
- `InfraHolonomy` the fiber permutation around a closed walk
- `InfraFlatConnectionQ` test trivial global monodromy over all base cycles

- `InfraConnectionQ`, `PermutationCycles` (WL)

### Visualization

- `InfraFiberedGraphHighlight` highlight sections, connections, walks and fiber graphs in circular, three-dimensional or total-layout views
- `InfraFiberedGraphViewer` inspect fibers, section values and connections by hovering over the total and base graphs
- `InfraSubstrateHighlight` highlight ordinary objects on the total graph

### Experimental models

- `InfraRays` geodesic rays of a fixed length
- `InfraTangentBundle`, `InfraCotangentBundle` rays over their initial vertices and reversed rays over their terminal vertices
- `InfraDisplacementBundle` pairs of base vertices at a fixed distance
- `InfraBundleMorphism` natural maps between these particular models
- `InfraFiberedSubstrate` a catalogue of products, coverings, branched examples and geometric models
- `RandomInfraFibration` the Experimental compatibility generator with its earlier cyclic-width options
- `FindInfraLeviCivitaConnection` metric-selected partial matchings of a displacement model
- `InfraHolonomyAngle`, `InfraCovariantDerivative`, `InfraCanonicalOneForm` metric measurements in that model

### Migration

- `InfraFibration` the retained inert head accepted alongside `InfraFiberedGraph`
- `InfraTotalGraph`, `InfraBaseGraph`, `InfraFibrationAssociation` compatibility spellings of the structural readers
- `FindInfraSection` the retained deterministic counted spelling for continuous-section enumeration
- `FindInfraHorizontalLift` the retained counted spelling of the unique lift on a complete connection

The fibered-graph sampler takes RandomSeeding, a conjunction of Properties and vertex/edge count specifications. Section and connection samplers take RandomSeeding, a result count and NextVertexFunction. The default section class is set-theoretic; Properties -> {"Continuous"} requests adjacency preservation on every overload. All enumeration is deterministic by default. The Levi-Civita model's partial transport retains its existing model-specific call forms; general literal fibered graphs require a complete connection. The InfraGaugeTheory paclet uses some of the same names with different signatures; load it separately or use full contexts.

The [Infra Bundles tutorial](paclet:WolframInstitute/InfraGeometry/tutorial/InfraBundles) develops the finite definitions and their implications. The [Experimental Infra Bundles tutorial](paclet:WolframInstitute/InfraGeometry/tutorial/ExperimentalInfraBundles) treats model-specific constructions, scale observations and proposed completion questions separately.
