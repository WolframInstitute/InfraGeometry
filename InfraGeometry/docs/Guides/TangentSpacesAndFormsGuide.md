---
Template: Guide
Name: TangentSpacesAndFormsGuide
Title: Tangent Spaces and Forms
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/TangentSpacesAndFormsGuide
Keywords: [tangent space, displacement, vector field, flow, commutator, Killing, differential form, cochain, cup product, tautological 1-form]
RelatedGuides: [EuclideanGeometryGuide, RiemannianGeometryGuide, TopologicalPropertiesGuide, FiberBundlesGuide, SubstratesGuide, Experimental]
---

## Abstract

The first-order structure of a substrate: the tangent space at a vertex, the displacements that move the vertices, the differential forms and cochains, and the tautological 1-form. A displacement of magnitude r sends each vertex v to a set of vertices within distance r, read as v -> exp_v(r X); it is multivalued by design, and the operations on displacements are metric: the scaled displacement moves along the geodesics v -> X v, the sum is the bisector of the two orders of composition, and the commutator is the loop of the two displacements and their negatives. A form is a germ of values at a vertex on tuples of its neighbours, a cochain a value on the cliques of the graph; the restriction and integration maps pass between them, and the coboundary, the differential, the wedge and the cup products act on them. The tangent space and the tautological 1-form are the sections that still wait; both exist today in the InfraGaugeTheory paclet and are to be copied here.

## Functions

### Tangent spaces

- waits: the tangent space at a vertex, copied from InfraGaugeTheory, where it is GraphTangentBundle and TangentFiberedGraph

### Displacements

- `DisplacementCompose` composes displacements as flows, the leftmost acting first
- `DisplacementScale` scales a displacement by t along the geodesics v -> d(v); t < 0 reflects through the base point
- `DisplacementNegative` the metric negative of a displacement, each step reflected through its base point
- `DisplacementInverse` the reversed relation; the inverse when the displacement is bijective
- `DisplacementSum` the bisector of the two orders of composition of two displacements
- `DisplacementCommutator` the commutator loop of two displacements, exact on bijections or by metric negatives
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
- `PolarDisplacements` the radial and angular displacements about a centre
- `GradientDisplacement` the steepest-ascent displacement of a vertex function
- `TranslationDisplacement` the translation by a vector of the graph embedding, each vertex moved to the nearest vertices
- `DisplacementPlot` a displacement, or a sequence of them, drawn as bent arcs over the graph

### Forms and cochains

- `FormValue` the value of the germ of a form at a vertex on a tuple of its neighbours, alternating in the tuple
- `CochainValue` the value of an alternating cochain on a vertex tuple
- `OrderedCochainValue` the value of an ordered cochain on an increasing vertex tuple
- `FormDegree` the degree of a form
- `CochainDegree` the degree of a cochain
- `ZeroForm` a vertex function as a 0-form
- `RestrictionMap` the form R a read from an alternating cochain with the base vertex prepended
- `IntegrationMap` the cochain I w averaged from the germs of a form over each clique; a left inverse of RestrictionMap
- `Coboundary` the coboundary of a cochain, the alternating sum over the faces of every clique one dimension up
- `FormDifferential` the differential of a form: the gradient on 0-forms, with a transport term on 1-forms
- `NaiveDifferential` the differential of a 1-form with the transport term dropped, kept for comparison
- `FormWedge` the wedge product of forms, fibre by fibre
- `CochainCup` the cup product of alternating cochains, antisymmetrised over the orderings of each clique
- `OrderedCochainCup` the Alexander-Whitney cup product of ordered cochains
- `CochainCupOne` the Steenrod cup-1 product of ordered cochains
- `AntisymmetrizedCup` an alias of CochainCup

### The tautological 1-form

- waits: the tautological 1-form on the cotangent space, copied from InfraGaugeTheory, where it is InfraTautologicalOneForm with GraphCotangentBundle
