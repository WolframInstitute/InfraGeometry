---
Template: Guide
Name: InfraAnalysis
Title: Infra Analysis
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/InfraAnalysis
Keywords: [tangent space, displacement, vector field, flow, commutator, Killing, tautological 1-form]
RelatedGuides: [EuclideanInfrageometry, RiemannianInfrageometry, InfraTopology, InfraFiberBundles, InfraSubstrates, Experimental]
---

## Abstract

Infra analysis studies the first-order structure of a substrate: the tangent space at a vertex, the displacements that move its vertices, and the tautological 1-form. A displacement of scale $r$ sends each vertex to a set of vertices within distance $r$, a discrete flow for time $r$, and it is multivalued by design. Its operations are metric: scaling moves along the shortest paths from each vertex to its images, the sum is the bisector of the two orders of composition, and the commutator is the loop of two displacements and their inverses, or of their metric negatives. The automorphisms of the substrate are its Killing displacements. The tangent space is the tangent bundle, a fibration whose sections are vector fields, and the tautological 1-form pairs a vector with a covector.

## Functions

### Tangent spaces

- `InfraTangentBundle` the tangent spaces at scale $r$, the rays of length $r$ over each vertex
- `InfraDisplacementBundle` the displacements of scale $r$, the pairs of vertices at distance $r$
- `InfraRays` the rays of a given length from a vertex

### Displacements

- `DisplacementCompose` the composition of displacements as flows
- `DisplacementScale` a displacement scaled by $t$ along the shortest paths to its images
- `DisplacementNegative` the metric negative, each step reflected through its base point
- `DisplacementInverse` the reversed relation
- `DisplacementSum` the bisector of the two orders of composition
- `DisplacementCommutator` the commutator loop of two displacements
- `DisplacementBracket` the scale-dependent bracket, the commutator by metric negatives
- `DisplacementMagnitude` the largest step of a displacement
- `DisplacementReduce` each value set contracted to its metric centre

### Kinds of displacements

- `FindKillingDisplacement` the nontrivial automorphism of least magnitude, as a displacement
- `KillingDisplacementMagnitude` the least magnitude of a nonidentity automorphism
- `GraphAutomorphismGroup` (WL) the automorphism group of the substrate

- `DisplacementSingleValuedQ`, `DisplacementBijectionQ`, `DisplacementIsomorphismQ`, `ContinuousDisplacementQ`

### Canonical displacements

- `RandomDisplacement` a random continuous displacement of magnitude at most $r$
- `PolarDisplacements` the radial and the angular displacement about a centre
- `GradientDisplacement` the steepest-ascent displacement of a vertex function
- `TranslationDisplacement` the translation by a vector of the graph embedding
- `DisplacementPlot` a displacement drawn as bent arcs over the graph

### The tautological 1-form

- `InfraCotangentBundle` the tangent bundle on reversed rays
- `InfraCanonicalOneForm` the pairing of a vector with a covector at a scale
