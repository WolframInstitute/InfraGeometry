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

<!-- LLM-PROTECTED: Preserve Pavel Hajek's wording; correct only what is wrong or unclear. Keep bold emphasis and linked inline function calls. -->

Abstract written by Pavel Hajek on 25 October 2026.

Infra fiber bundles are **minimal models of fibrations on graphs**. Unlike lattice gauge theory, which usually uses continuous or discrete labels for parallel transport on edges and gauge transformations at vertices, infra fiber bundles operate with **unlabeled graphs** and a vertex projection, and all structure is derived from the fibers and their connectivity.

It turns out that there are natural minimal models of **sections, connections and holonomy**, and that certain natural properties make sense even at the **infra-level**, where all the information is specified by binary vertex connectivity and the projection. We have to relax some conditions because the objects are generally only partially defined. Surprisingly, many constructions still work, and whether they are globally defined becomes a separate question. We also build **scale dependence** into our construction to study different properties at different observer scales.

We use inert objects such as <code>[InfraFiberedGraph]()[*g*, *projection*]</code>. <code>[RandomInfraSection]()[*fib*, *partial*, *k*]</code> samples sections extending a prescribed partial section, and <code>[RandomInfraConnection]()[*fib*, *k*]</code> samples complete connections. <code>[InfraHolonomy]()[*fib*, *connection*, *loop*]</code> gives the map from a fiber to itself obtained by transport around a closed base walk.

There are many natural examples of fibered graphs. For example, a connected **directed graph can be seen as a fibered graph over a path graph** when coordinatized by shortest-path distance from its set of sources. In InfraAnalysis, such graphs are viewed as "puffed" real lines. **Graph coordinatization** - assigning labels to vertices based on natural choices and constructions, such as shortest-path projections onto a chosen set of orthogonal paths - gives another set of examples. When coordinatization is based on observer chains, as in the Wolfram Physics Project, fibers can be understood as **internal degrees of freedom**, which are not visible to mechanical observers.

There are natural constructions of **tangent and cotangent fiber bundles** at a given observer scale r: <code>[InfraTangentBundle]()[*g*, *r*]</code> and <code>[InfraCotangentBundle]()[*g*, *r*]</code>. These can be used to define infra notions of a **Levi-Civita connection** and a **canonical 1-form**, respectively. Whereas the canonical 1-form is an exact construction with a unique result, the Levi-Civita connection need not be uniquely defined. We also distinguish between rays, which take into account the internal "webbing" of the fibers, and their endpoints, called **displacements**. These give different bundles related by a bundle morphism.

We expect our constructions to converge to the corresponding objects in a suitable **Gromov-Hausdorff limit** along sequences of graphs obtained by subdivision. We also want to show how graphs obtained by expansive rewriting give rise to space and continuous notions when aggregated at large observer scales.

<!-- /LLM-PROTECTED -->

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
- `InfraTrivialMonodromyQ` test trivial global monodromy over all base cycles

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

- `InfraFlatConnectionQ` the compatibility spelling of `InfraTrivialMonodromyQ`
- `InfraFibration` the retained inert head accepted alongside `InfraFiberedGraph`
- `InfraTotalGraph`, `InfraBaseGraph`, `InfraFibrationAssociation` compatibility spellings of the structural readers
- `FindInfraSection` the retained deterministic counted spelling for continuous-section enumeration
- `FindInfraHorizontalLift` the retained counted spelling of the unique lift on a complete connection

The fibered-graph sampler takes RandomSeeding, a conjunction of Properties and vertex/edge count specifications. Section and connection samplers take RandomSeeding, a result count and NextVertexFunction. The default section class is set-theoretic; Properties -> {"Continuous"} requests adjacency preservation on every overload. All enumeration is deterministic by default. The Levi-Civita model's partial transport retains its existing model-specific call forms; general literal fibered graphs require a complete connection. The InfraGaugeTheory paclet uses some of the same names with different signatures; load it separately or use full contexts.

The [Infra Bundles tutorial](paclet:WolframInstitute/InfraGeometry/tutorial/InfraBundles) develops the finite definitions and their implications. The [Experimental Infra Bundles tutorial](paclet:WolframInstitute/InfraGeometry/tutorial/ExperimentalInfraBundles) treats model-specific constructions, scale observations and proposed completion questions separately.
