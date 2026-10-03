---
Template: Guide
Name: InfraAnalysis
Title: Infra Analysis
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/InfraAnalysis
Keywords: [tangent space, displacement, vector field, flow, commutator, Killing, differential form, cochain, cup product, tautological 1-form]
RelatedGuides: [EuclideanInfrageometry, RiemannianInfrageometry, InfraTopology, InfraFiberBundles, InfraSubstrates, Experimental]
---

## Abstract

Tangent spaces and differential forms: the first-order structure of a substrate, with the tangent space at a vertex, the displacements that move its vertices, the differential forms and cochains, and the tautological 1-form. A displacement of scale r sends each vertex to a set of vertices within distance r, a discrete flow for time r, and it is multivalued by design. Its operations are metric: scaling moves along the geodesics from each vertex to its images, the sum is the bisector of the two orders of composition, and the commutator is the loop of the two displacements and their inverses, or of their metric negatives. A form is a germ of values at a vertex on tuples of its neighbours, a cochain a value on the cliques of the graph; the restriction and integration maps pass between the two, and the coboundary, the differential, the wedge and the cup products act on them. The tangent space is the tangent bundle, a fibration whose sections are vector fields; the tautological 1-form pairs a vector with a covector.

## Functions

### Tangent spaces

- **InfraTangentBundle** — the tangent spaces of a graph at scale r, the rays of length r over each vertex
- **InfraDisplacementBundle** — the displacements of scale r, the pairs of vertices at distance r
- **InfraRays** — the rays of a given length from a vertex

### Displacements

- **DisplacementCompose** — composes displacements as flows, the leftmost acting first
- **DisplacementScale** — scales a displacement by t along the geodesics from each vertex to its images; t < 0 reflects through the base point
- **DisplacementNegative** — the metric negative of a displacement, each step reflected through its base point
- **DisplacementInverse** — the reversed relation, the inverse when the displacement is bijective
- **DisplacementSum** — the bisector of the two orders of composition of two displacements
- **DisplacementCommutator** — the commutator loop of two displacements, by their inverses or by their metric negatives
- **DisplacementBracket** — the commutator by metric negatives, the scale-dependent bracket
- **DisplacementMagnitude** — the largest step of a displacement, its scale
- **DisplacementReduce** — contracts each value set of a displacement to its metric centre, iterated to a fixed point

### Kinds of displacements

- **DisplacementSingleValuedQ** — whether every value of a displacement is a single vertex
- **DisplacementBijectionQ** — whether a displacement is a single-valued permutation of the vertices
- **DisplacementIsomorphismQ** — whether a displacement is a graph automorphism, a discrete Killing displacement
- **ContinuousDisplacementQ** — whether a displacement is k-continuous, in the weak, Hausdorff or strong sense
- **FindKillingDisplacement** — the nontrivial automorphism of least magnitude, as a displacement
- **KillingDisplacementMagnitude** — the least magnitude of a nonidentity automorphism, Infinity on an asymmetric graph

### Canonical displacements

- **RandomDisplacement** — a random continuous displacement of magnitude at most r
- **PolarDisplacements** — the radial and the angular displacement about a centre
- **GradientDisplacement** — the steepest-ascent displacement of a vertex function
- **TranslationDisplacement** — the translation by a vector of the graph embedding, each vertex moved to the nearest vertices
- **DisplacementPlot** — a displacement, or a sequence of them, drawn as bent arcs over the graph

### Forms and cochains

- **FormValue** — the value of the germ of a form at a vertex on a tuple of its neighbours, alternating in the tuple
- **CochainValue** — the value of an alternating cochain on a vertex tuple
- **OrderedCochainValue** — the value of an ordered cochain on an increasing vertex tuple
- **FormDegree** — the degree of a form
- **CochainDegree** — the degree of a cochain
- **ZeroForm** — a vertex function as a 0-form
- **RestrictionMap** — the form read from an alternating cochain with the base vertex prepended
- **IntegrationMap** — the cochain averaged from the germs of a form over each clique, a left inverse of RestrictionMap
- **Coboundary** — the coboundary of a cochain, the alternating sum over the faces of every clique one dimension up
- **FormDifferential** — the differential of a form, the gradient on 0-forms and with a transport term on 1-forms
- **NaiveDifferential** — the differential of a 1-form with the transport term dropped, kept for comparison
- **FormWedge** — the wedge product of forms, fibre by fibre
- **CochainCup** — the cup product of alternating cochains, antisymmetrised over the orderings of each clique
- **OrderedCochainCup** — the Alexander-Whitney cup product of ordered cochains
- **CochainCupOne** — the Steenrod cup-1 product of ordered cochains
- **AntisymmetrizedCup** — an alias of CochainCup

### The tautological 1-form

- **InfraCotangentBundle** — the tangent bundle on reversed rays
- **InfraCanonicalOneForm** — the pairing of a vector with a covector at a scale, the tautological 1-form
