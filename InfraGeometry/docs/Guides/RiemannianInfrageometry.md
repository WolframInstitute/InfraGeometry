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
RelatedTutorials: [MetricTensorTutorial, VolumeMeasurementTutorial]
---

<!-- LLM-PROTECTED: Do not rewrite the Abstract or Functions sections unless explicitly asked. -->

## Abstract

**Riemannian Infrageometry** studies how to measure and distinguish graphs as geometric substrates. In contrast, synthetic infrageometry asks only whether certain assumptions are satisfied by the substrate so that constructions have given propertes studies constructions and relations of geometric objects within a substrate whose properties are fixed by postulates. Riemann began with the problem of measuring the length of curves. He viewed an $n$-dimensional manifold as an iterated **infinitesimal webbing of paths** and asked what conditions to impose on the infinitesimal element of length. Restricting it to a quadratic form gives the **metric tensor**, which captures the infinitesimal Riemannian geometry. This separates the manifold and its topology from the Riemannian structure placed on it. One can then ask for the moduli space of Riemannian structures on a fixed manifold, or go the other way and obtain topological quantities by integrating local geometric quantities, as in the Gauss–Bonnet theorem.

In infrageometry the discrete **webbing of paths** is the substrate itself. The graph prescribes both the paths and their metric, so this split is not made. But we must always choose an **observer scale** $r$, which can be understood as measuring the substrate using balls of radius $r$. A Gromov–Hausdorff limit of rescaled graphs, when it exists, gives a metric space. If this metric space is a smooth Riemannian manifold, its intrinsic distance determines its Riemannian structure. Thus two such manifolds that are isometric as metric spaces are also isometric as Riemannian manifolds. The geometry is here **in one**.

## Functions

- `RandomInfraGeodesic[...]` grows paths that are shortest in every window of $r$ edges. Unlike smooth geodesics, a germ has many continuations. We ask for the least $r$ at which the most visited paths become globally shortest: proposed `InfraGeodesicStraighteningScale[...]`.

- `InfraMeasurement` measures balls of radii $0,\ldots,r$, tubes of thickness $s$ and cones of slope $s$, along axes ending at different vertices $u$ in the radius-$r$ shell.

- Proposed `InfraDistanceDistribution[...]` gives the histogram of mutual distances in a ball or shell; `Moment` reads its moments.

- `InfraTangentBundle[g, r]` has vectors represented by length-$r$ germs, chains in the spray graph. `InfraDisplacementBundle[g, r]` keeps only their endpoints. `FindInfraLeviCivitaConnection` and `InfraParallelTransport` compare and transport these displacements.

- `InfraMetricTensor[g, p, r]` compares directions at scale $r$ by projection onto metric intervals.

<!-- /LLM-PROTECTED -->

---

### Infrageodesics

- `InfraGeodesic` the inert geodesics at infra-scale s through a germ, a vertex list; InfraMeasurement reads its graph, the window graph of the forward extensions, RandomInfraRepresentative the inextensible simple ones
- `RandomInfraGeodesic` the geodesics at infra-scale s grown from a germ, a vertex or a walk: every window of s consecutive vertices plus the next one is a shortest path; a trailing count gives a List of them
- `InfraGeodesicQ` whether a walk is a geodesic at infra-scale s; scale 1 is InfraWalkQ and Infinity is InfraSegmentQ

### Shells

- `InfraShell` the inert shell {v : rmin <= d(c, v) <= rmax} about a vertex or a vertex set, a level set of the distance; InfraMeasurement reads its volumes, RandomInfraRepresentative its vertices
- `FindInfraShell` the shell {v : d(c, v) = r}, or the band {rmin, rmax}, as a sorted vertex list; the separating subsets of a shell are RandomInfraSphere on the Euclidean Infrageometry guide

### Volume measurements

- `InfraMeasurement` the "CountingMeasure" and the "RiemannianMeasure" of a ball, shell or tube; the profiles are its Table over the radius
- A region on a graph is measured by counting vertices, and its boundary is not negligible at a finite scale: the vertices at distance exactly $r$ are a share of order $1/r$ of the ball of radius $r$. So every region carries two measures. The counting measure is $\mu(A) = |A|$. The Riemannian measure is $\mu^\circ(A) = |A^\circ|$, where $A^\circ = \{v \in A : N(v) \subseteq A\}$ is the set of vertices all of whose neighbours lie in $A$; it is the count without the boundary and the default of the growth estimators.
- On the square grid the ball of radius $r$ has counting measure $2r^2 + 2r + 1$ and Riemannian measure $2r^2 - 2r + 1$, the counting measure of the ball of radius $r - 1$; the shell has counting measure $4r$ and Riemannian measure $0$. The same shift holds on the triangular lattice before the rim, the convention of the Wolfram Physics technical introduction.
- `InfraSubstrate` the example graph of a given name at size Small, Medium or Large, the substrates the volumes are measured on
- `LogDifferenceQuotients` the discrete d log w / d log r of a sequence, q(r) = (log w(r) - log w(r - 1)) / (log(r + 1) - log r); a sequence of Around values carries its spread into error bars
- `DimensionCurvatureFit` dimension and scalar curvature from log-difference quotients by regression on r(r + 1), the intercept and the slope, for the ball, sphere, tube or tube-mantle probe
- `VolumeGrowthObservables` the ball and sphere fits at a vertex over a window as one Association: profiles, quotients, fits and the windows used

### The metric tensor

- `InfraMetricTensor` the matrix d(p, u) / d(p, v) over v, w with u the foot of v on the interval I(p, w); with r, over the shell of radius r; "SelectCoordinate" reads a tie of feet

### Not here

- not here: the Riemann tensor, the curvature tensor from directional growth; its estimators are the backlog item CurvatureTensorEstimators

