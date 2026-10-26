---
Template: Guide
Name: InfraAnalysis
Title: Infra Analysis
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/InfraAnalysis
Keywords: [InfraCalculus, aggregation, integral, differential, codifferential, antiderivative, derivative, Moebius function, incidence algebra, directed acyclic graph, value density, coordinatization, multivariate calculus, tangent space, tangent bundle, displacement, vector field, flow, commutator, Killing, differential form, cochain, tautological 1-form]
RelatedGuides: [EuclideanInfrageometry, RiemannianInfrageometry, InfraTopology, InfraFiberBundles, InfraSubstrates, Experimental]
---

## Abstract

Abstract written and reviewed by Pavel Hajek on 26 October 2026.

<!-- LLM-PROTECTED: Pavel Hajek's current notebook wording. Preserve it verbatim; formatting and symbol-link changes only unless explicitly requested. -->

The main building block of InfraAnalysis is **InfraCalculus**, which develops integration and differentiation of functions on the vertices of directed acyclic graphs. Integration takes several forms of aggregation along the natural direction from sources to sinks, with corresponding inverse operations chosen to satisfy a **fundamental theorem of calculus**. [InfraAntiderivative]() and [InfraDerivative]() are inverse operations for the same integration method. Note that the derivative for some forms of integration may be nonlocal.

Organizing a directed graph into **transversal and radial components** according to shortest-path distance from the sources gives a fibered graph over a path graph. We can consider its blow-ups and contractions in the radial direction and study the **renormalizability of InfraCalculus** by examining their compatibility with integration and differentiation.

Moreover, we have several methods of **coordinatization**, most notably shortest-path projection onto a collection of orthogonal paths, as in [OrthogonalCoordinates](). This gives graphs fibered over a coordinate grid and can be used to define **multivariate calculus** and study the validity of **Stokes' and Green's theorems**. We also consider various versions of **differential forms** and study their relations to cochains on the Rips complex. **Tangent and cotangent graphs**, together with Levi-Civita connections and covariant derivatives, are also parts of InfraAnalysis.

<!-- /LLM-PROTECTED -->

## Functions

### InfraCalculus: aggregation and differentiation

- `InfraAntiderivative` the accumulation of a vertex function over the past through the incidence-algebra kernel of a method
- `InfraDerivative` the inverse of the corresponding antiderivative, including the nonlocal Möbius derivative
- `InfraIntegral` the integral over a region or along a family of walks, with one value per member
- `InfraDifferential` the 1-form $df(u \to v) = f(v) - f(u)$ of a function $f$
- `InfraCodifferential` the 0-form $\delta\omega(v)$, the incoming minus the outgoing values of a 1-form $\omega$
- `InfraMeasurement` the readings "Function", "Kernel", "Value", "ValueDensity", "Mean", "Cardinality" and "Flux" where defined
- `SprayGraph`, `TransitiveReductionGraph` (WL) the order seen from an origin and the links of a partial order

### Coordinatizations

- `FindInfraOrthogonalAxes`, `FindInfraOrthogonalRays` mutually perpendicular axes or rays through a centre
- `FindInfraSpanningAxes` well-separated longest shortest paths across a graph
- `OrthogonalCoordinates` the signed positions of the shortest-path projections onto chosen axes
- `RadarCoordinates` the distances from each vertex to a chosen set of vertices
- `FindResolvingSet`, `MetricDimension` resolving sets and the minimum number of distance coordinates that distinguish all vertices
- `ResistanceCoordinates` spectral coordinates whose squared distances are effective resistances

- `ResolvingSetQ`

### Multivariate calculus

- `GradientDisplacement` the steepest-ascent displacement of a function on the vertices
- `PolarDisplacements` the radial and angular displacements about a centre
- `TranslationDisplacement` the translation by a vector of the graph embedding
- `InfraCovariantDerivative` the change of a vector field along a walk using the displacement-bundle model

### Tangent spaces and vector fields

- `InfraTangentBundle` the tangent spaces at scale $r$, the rays of length $r$ over each vertex
- `InfraDisplacementBundle` the displacements of scale $r$, the pairs of vertices at distance $r$
- `InfraCotangentBundle` the cotangent model on reversed rays
- `InfraRays` the rays of a given length from a vertex
- `InfraSection` a section of a tangent or displacement bundle representing a vector field on its domain
- `InfraBundleMorphism` the natural maps between ray and displacement models

### Displacement algebra

- `DisplacementCompose` the composition of displacements as flows
- `DisplacementScale` a displacement scaled by $t$ along the shortest paths to its images
- `DisplacementNegative` the metric negative, each step reflected through its base point
- `DisplacementInverse` the reversed relation
- `DisplacementSum` the bisector of the two orders of composition
- `DisplacementCommutator` the commutator loop of two displacements
- `DisplacementBracket` the scale-dependent bracket, the commutator by metric negatives
- `DisplacementMagnitude` the largest step of a displacement
- `DisplacementReduce` each value set contracted to its metric centre

### Killing displacements

- `FindKillingDisplacement` the nontrivial automorphism of least magnitude, as a displacement
- `KillingDisplacementMagnitude` the least magnitude of a nonidentity automorphism
- `GraphAutomorphismGroup` (WL) the automorphism group of the substrate

- `DisplacementSingleValuedQ`, `DisplacementBijectionQ`, `DisplacementIsomorphismQ`, `ContinuousDisplacementQ`

### Sampling and visualization

- `RandomDisplacement` a random continuous displacement of magnitude at most $r$
- `DisplacementPlot` a displacement drawn as bent arcs over the graph
- `InfraSubstrateHighlight` highlight vertex functions, regions and walks on the substrate
- `InfraFiberedGraphHighlight` highlight vector fields and fibers in their bundle models

### Differential forms

- `ZeroForm` a vertex function as a 0-form
- `FormValue` the value of a form at a vertex on a tuple of its neighbours
- `FormDifferential` the differential of a 0-form or 1-form
- `FormWedge` the wedge product of forms
- `InfraCanonicalOneForm` the pairing of a vector with a covector at a scale

- `FormDegree`, `NaiveDifferential`

### Cochains and integration of forms

- `CochainValue` the value of an alternating cochain on a vertex tuple
- `Coboundary` the coboundary of a cochain
- `CochainCup` the cup product of alternating cochains
- `OrderedCochainCup` the Alexander-Whitney cup product of ordered cochains
- `CochainCupOne` the Steenrod cup-1 product of ordered cochains
- `RestrictionMap` the form read from an alternating cochain
- `IntegrationMap` the cochain averaged from a form over each clique

- `CochainDegree`, `OrderedCochainValue`, `AntisymmetrizedCup`
