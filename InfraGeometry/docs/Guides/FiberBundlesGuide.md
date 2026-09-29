---
Template: Guide
Name: FiberBundlesGuide
Title: Fiber Bundles
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/FiberBundlesGuide
Keywords: [fiber bundle, fibered graph, base graph, fiber, connection, parallel transport, holonomy, section]
RelatedGuides: [EuclideanGeometryGuide, RiemannianGeometryGuide, TopologicalPropertiesGuide, TangentSpacesAndFormsGuide, SubstratesGuide, Experimental]
---

## Abstract

A fibered graph is a graph with a projection onto a base graph, the preimage of each base vertex its fiber. It is a fiber bundle when the fibers are isomorphic and the edges over each base edge lift consistently. A connection chooses how an edge of the base lifts to the fibers; transport along a closed walk of the base returns a permutation of the fiber, its holonomy, and the connection is flat when every holonomy is trivial. A section picks a vertex of each fiber. The basic symbols of this layer exist in the InfraGaugeTheory paclet and are to be copied here, so every section of this guide still waits.

## Functions

### Fibered graphs

- waits: fibered graphs and the bundle conditions, copied from InfraGaugeTheory, where they are RandomFiberedGraph, ReconstructBaseGraph, IsomorphicFibersQ, EdgeLiftingPropertyQ, LocallyTrivialQ and FiberBundleQ

### Connections and holonomy

- waits: connections and their holonomy, copied from InfraGaugeTheory, where they are ConnectionQ, RandomConnection, ParallelTransport, HolonomyMatrix and FlatConnectionQ

### Sections

- waits: sections of a fibered graph, copied from InfraGaugeTheory, where they are RandomSection, SmoothSectionQ and FindZeroSection
