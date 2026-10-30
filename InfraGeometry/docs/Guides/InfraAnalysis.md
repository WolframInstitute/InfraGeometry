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

*Abstract written by Pavel Hajek on 26 October 2026.*

<!-- LLM-PROTECTED: Pavel Hajek's current notebook wording. Preserve it verbatim; formatting and symbol-link changes only unless explicitly requested. -->

The main component of InfraAnalysis is **InfraCalculus**, which develops integration and differentiation of functions on the vertices of directed acyclic graphs. It is a **mesoscale theory**. A function corresponds to labels on vertices. We can imagine these labels as aggregations on a more elementary unlabeled graph, for example by counting the number of elements in the fibers of some observer-induced fibration. **InfraIntegration** takes several forms of aggregation along the natural direction from sources to sinks. **InfraDerivative** is an operation on labeled directed graphs chosen such that, together with the corresponding integration, it satisfies the **fundamental theorem of calculus**. That is, differentiation is a left inverse of infra integration. Interestingly, some derivatives are non-local.

A directed graph can be seen as a fibered graph over a path graph, where the fibration map is given by the graph distance to sources. The decomposition into horizontal and vertical components gives a decomposition into **transverse and radial subgraphs**. We can consider various notions of blow-ups, either in the radial or transverse directions. These can be parametrized by a group parameter and induce an action on functions on the graph, giving a **renormalization flow**. We then ask about the **renormalizability of infra calculus**.

We have several methods of **coordinatization**, meaning assigning tuples of labels to graph vertices. One example is the shortest-path projection onto a collection of orthogonal paths, as in [OrthogonalCoordinates](). This makes the graph fibered over a coordinate grid. A linear order on the individual coordinate components then defines directed acyclic graphs through the points. We can use these to define **partial derivatives**, leading to **multivariate calculus**. We study the validity of **Stokes' and Green's theorems**.

We also consider various versions of **differential forms** on a graph and study their relations to cochains on the Rips complex. **Tangent and cotangent graphs**, connections, and **covariant derivatives** are also parts of InfraAnalysis.

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

- `CochainDegree`, `OrderedCochainValue`
