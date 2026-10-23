---
Template: Guide
Name: InfraAnalysis
Title: Infra Analysis
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/InfraAnalysis
Keywords: [integral, differential, codifferential, antiderivative, derivative, Moebius function, incidence algebra, directed acyclic graph, value density, tangent space, displacement, vector field, flow, commutator, Killing, tautological 1-form]
RelatedGuides: [EuclideanInfrageometry, RiemannianInfrageometry, InfraTopology, InfraFiberBundles, InfraSubstrates, Experimental]
---

## Abstract

Infra analysis studies functions and flows on a substrate. A function on the vertices has a differential on the edges. A function is integrated over a region by summing it, one unit per vertex, and along a walk by summing it over the walk. Most objects are families of walks, so an integral along an object is itself a multi-object, one value per member. It is read as its value density, without enumerating the members. The integral of a differential $df$ has the single value $f(q) - f(p)$ on every member from $p$ to $q$.

On a directed acyclic graph, or on any substrate seen from an origin, an antiderivative accumulates a function over the past of each vertex through a kernel of the incidence algebra: the zeta function, the number of chains, the visiting probabilities of the backward and the forward random walk, or of a uniformly random maximal chain. The derivative of the same method is its exact inverse; it is local exactly when the kernel sums over chains weighted on the links. The zeta kernel, the plain sum over the whole past, is the exception: its inverse, the Möbius derivative, reaches past the links wherever two chains with the same ends diverge. On the light-cone lattice that derivative is the discrete wave operator.

Infra analysis also studies the first-order structure of a substrate: the tangent space at a vertex, the displacements that move its vertices, and the tautological 1-form. A displacement of scale $r$ sends each vertex to a set of vertices within distance $r$, a discrete flow for time $r$, and it is multivalued by design. Its operations are metric: scaling moves along the shortest paths from each vertex to its images, the sum is the bisector of the two orders of composition, and the commutator is the loop of two displacements and their inverses, or of their metric negatives. The automorphisms of the substrate are its Killing displacements. The tangent space is the tangent bundle, a fibration whose sections are vector fields, and the tautological 1-form pairs a vector with a covector.

## Functions

### Differentials

- `InfraDifferential` the 1-form $df(u \to v) = f(v) - f(u)$ of a function $f$
- `InfraCodifferential` the 0-form $\delta\omega(v)$, the incoming minus the outgoing values of a 1-form $\omega$

### Integrals

- `InfraIntegral` the integral of a 0-form or 1-form over an object: a sum over a region, or one sum per member of a family of walks
- `InfraMeasurement` its readings "Value", "ValueDensity", "Mean", "Cardinality", "Flux"

### Antiderivatives and derivatives

- `InfraAntiderivative` the accumulation $F(v) = \sum_{u \preceq v} f(u) K(u, v)$ over the past through the kernel $K$ of a method
- `InfraDerivative` its inverse $D_K = K^{-1}$, local for path kernels, the Möbius inversion for the zeta kernel
- `SprayGraph`, `TransitiveReductionGraph` (WL) the order an antiderivative reads

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
