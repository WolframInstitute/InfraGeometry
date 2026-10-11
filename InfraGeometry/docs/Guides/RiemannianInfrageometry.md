---
Template: Guide
Name: RiemannianInfrageometry
Title: Riemannian Infrageometry
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/RiemannianInfrageometry
Keywords: [Riemannian geometry, graph, geodesic, infra-scale, ball, shell, tube, volume growth, dimension, scalar curvature, metric tensor]
RelatedGuides: [EuclideanInfrageometry, InfraTopology, InfraAnalysis, InfraFiberBundles, Experimental]
RelatedTutorials: [MetricTensorTutorial, VolumeMeasurementTutorial, DimensionTutorial]
---

<!-- LLM-PROTECTED: Do not rewrite the Abstract or Functions sections unless explicitly asked. -->

## Abstract

**Riemannian Infrageometry** describes and distinguishes graphs as geometric substrates. In contrast, synthetic infrageometry asks only whether certain postulates are satisfied by the substrate so that its propositions about geometric objects hold. Riemann viewed space as an **infinitesimal webbing of paths** and, by imposing conditions on the infinitesimal length element, arrived at the quadratic metric tensor as the lowest-order data satisfying those conditions. This split continuous geometry into a manifold, which carries the topology and global analysis, and a Riemannian structure. This led people such as Gromov to ask about the moduli space of Riemannian structures on a fixed manifold, or, conversely, to derive topological quantities from Riemannian ones. In infrageometry, the **discrete webbing of paths** given by a graph is itself the geometric substrate, so no such split occurs. We relate infrageometry to continuous geometry through rescaled Gromov–Hausdorff convergence, where the scaling is determined by the **observer's scale**. This yields a generalized definition of geometry: if a limit of rescaled graphs is a metric space arising from a Riemannian manifold, then that manifold is uniquely determined up to isomorphism.

## Functions

- A geodesic at observer scale $r$ of length $k$, `InfraGeodesic[germ, r, k]`, is a family of walks of length $k$ that are shortest paths in every window of $r$ edges. A representative can be found with `RandomInfraGeodesic[...]`, and the edge density of the corresponding multi-object with `InfraMeasurement[g, geodesic, "EdgeDensity"]`.

- We can measure the volumes of `InfraBall[p, r0]` for $r_0 \leq r$, `InfraTube[axis, s]` for any ray or line through $p$ and any thickness $s$, and `InfraCone[axis, s]` for slope $s$. Such measurements have asymptotic expansions in the continuous case and can be used to determine limiting curvature components. However, no sphere structure exists a priori on `InfraShell`, so the limiting linear tensors can be compared only through histograms. We can also obtain the histogram of mutual distances between points, which constrains the limiting Riemannian manifold.

- We have `InfraTangentBundle[g, r]` which represents vectors at p by rays of length $r$, and these are compactly encoded as chains in the spray graph at $p$. We have an even simpler infra-bundle, `InfraDisplacementBundle[g, r]`, that keeps only the endpoints of rays. We have a minimal model of the Levi-Civita connection, `FindInfraLeviCivitaConnection[InfraDisplacementBundle[g, r]]`, and `InfraParallelTransport[InfraDisplacementBundle[g, r], walk]`.

- We also have `InfraMetricTensor[g, p, r]`, which computes shortest path projections of rays, displacement commutator `DisplacementCommutator[g, d1, d2]`, and addition of displacements via midpoints with `DisplacementSum[g, d1, d2]`. These can be used to illustrate emergence of linearity.
<!-- /LLM-PROTECTED -->

---

### Infrageodesics

- `InfraGeodesic` the inert geodesics at infra-scale s through a germ, a vertex list; InfraMeasurement reads its graph, the window graph of the forward extensions, RandomInfraGeodesic the inextensible simple ones
- `RandomInfraGeodesic` the geodesics at infra-scale s grown from a germ, a vertex or a walk: every window of s consecutive vertices plus the next one is a shortest path; a trailing count gives a List of them
- `InfraGeodesicQ` whether a walk is a geodesic at infra-scale s; scale 1 is InfraWalkQ and Infinity is InfraSegmentQ

### Shells

- `InfraShell` the inert shell {v : rmin <= d(c, v) <= rmax} about a vertex or a vertex set, a level set of the distance; InfraMeasurement reads its volumes, RandomInfraShell its vertices
- `FindInfraShell` the shell {v : d(c, v) = r}, or the band {rmin, rmax}, as a sorted vertex list; the separating subsets of a shell are RandomInfraSphere on the Euclidean Infrageometry guide

### Volume measurements

- `InfraMeasurement` the "CountingMeasure" and the "RiemannianMeasure" of a ball, shell or tube; the profiles are its Table over the radius
- A region on a graph is measured by counting vertices, and its boundary is not negligible at a finite scale: the vertices at distance exactly $r$ are a share of order $1/r$ of the ball of radius $r$. So every region carries two measures. The counting measure is $\mu(A) = |A|$. The Riemannian measure is $\mu^\circ(A) = |A^\circ|$, where $A^\circ = \{v \in A : N(v) \subseteq A\}$ is the set of vertices all of whose neighbours lie in $A$; it is the count without the boundary and the default of the growth estimators.
- On the square grid the ball of radius $r$ has counting measure $2r^2 + 2r + 1$ and Riemannian measure $2r^2 - 2r + 1$, the counting measure of the ball of radius $r - 1$; the shell has counting measure $4r$ and Riemannian measure $0$. The same shift holds on the triangular lattice before the rim, the convention of the Wolfram Physics technical introduction.
- `InfraSubstrate` the example graph of a given name at size Small, Medium or Large, the substrates the volumes are measured on
- `LogDifferenceQuotients` the discrete d log w / d log r of a sequence, q(r) = (log w(r) - log w(r - 1)) / (log(r + 1) - log r); a sequence of Around values carries its spread into error bars
- `DimensionCurvatureFit` dimension and scalar curvature from log-difference quotients by regression on r(r + 1), the intercept and the slope, for the ball, sphere, tube or tube-mantle probe; the [Dimension tutorial](paclet:WolframInstitute/InfraGeometry/tutorial/DimensionTutorial) compares the growth reading with covering and span
- `VolumeGrowthObservables` the ball and sphere fits at a vertex over a window as one Association: profiles, quotients, fits and the windows used

### The metric tensor

- `InfraMetricTensor` the matrix d(p, u) / d(p, v) over v, w with u the foot of v on the interval I(p, w); with r, over the shell of radius r; "SelectCoordinate" reads a tie of feet

### Not here

- not here: the Riemann tensor, the curvature tensor from directional growth; its estimators are the backlog item CurvatureTensorEstimators
