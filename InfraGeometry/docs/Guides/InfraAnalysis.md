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

Tangent spaces: the first-order structure of a substrate, with the tangent space at a vertex, the displacements that move its vertices, and the tautological 1-form. A displacement of scale r sends each vertex to a set of vertices within distance r, a discrete flow for time r, and it is multivalued by design. Its operations are metric: scaling moves along the geodesics from each vertex to its images, the sum is the bisector of the two orders of composition, and the commutator is the loop of the two displacements and their inverses, or of their metric negatives. The differential forms and cochains are on the Experimental guide. The tangent space is the tangent bundle, a fibration whose sections are vector fields; the tautological 1-form pairs a vector with a covector.

## Functions

### Tangent spaces

- `InfraTangentBundle` the tangent spaces of a graph at scale r, the rays of length r over each vertex
- `InfraDisplacementBundle` the displacements of scale r, the pairs of vertices at distance r
- `InfraRays` the rays of a given length from a vertex

### Displacements

- `DisplacementCompose` composes displacements as flows, the leftmost acting first
- `DisplacementScale` scales a displacement by t along the geodesics from each vertex to its images; t < 0 reflects through the base point
- `DisplacementNegative` the metric negative of a displacement, each step reflected through its base point
- `DisplacementInverse` the reversed relation, the inverse when the displacement is bijective
- `DisplacementSum` the bisector of the two orders of composition of two displacements
- `DisplacementCommutator` the commutator loop of two displacements, by their inverses or by their metric negatives
- `DisplacementBracket` the commutator by metric negatives, the scale-dependent bracket
- `DisplacementMagnitude` the largest step of a displacement, its scale
- `DisplacementReduce` contracts each value set of a displacement to its metric centre, iterated to a fixed point

### Kinds of displacements

- `DisplacementSingleValuedQ` whether every value of a displacement is a single vertex
- `DisplacementBijectionQ` whether a displacement is a single-valued permutation of the vertices
- `DisplacementIsomorphismQ` whether a displacement is a graph automorphism, a discrete Killing displacement
- `ContinuousDisplacementQ` whether a displacement is k-continuous, in the weak, Hausdorff or strong sense
- `FindKillingDisplacement` the nontrivial automorphism of least magnitude, as a displacement
- `KillingDisplacementMagnitude` the least magnitude of a nonidentity automorphism, Infinity on an asymmetric graph

### Canonical displacements

- `RandomDisplacement` a random continuous displacement of magnitude at most r
- `PolarDisplacements` the radial and the angular displacement about a centre
- `GradientDisplacement` the steepest-ascent displacement of a vertex function
- `TranslationDisplacement` the translation by a vector of the graph embedding, each vertex moved to the nearest vertices
- `DisplacementPlot` a displacement, or a sequence of them, drawn as bent arcs over the graph

### The tautological 1-form

- `InfraCotangentBundle` the tangent bundle on reversed rays
- `InfraCanonicalOneForm` the pairing of a vector with a covector at a scale, the tautological 1-form
