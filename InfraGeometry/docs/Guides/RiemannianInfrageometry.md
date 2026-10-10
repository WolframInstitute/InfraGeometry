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

## Abstract

Riemannian infrageometry measures and describes a discrete substrate represented by a graph $G = (V, E)$. Euclidean infrageometry, in contrast, is synthetic geometry: constructions with natural objects (points, segments, lines, circles) in the substrate.

## Functions

- Classical geometry has infinitesimality: a segment can be subdivided infinitely many times, whatever the scale of the observer. A graph has no infinitely small part. Infrageometry aggregates instead. An observer scale $r$, the number of steps the observer inspects at once, must be given before an object or a measurement makes sense.
- The claim of infrageometry is that limits of graphs are enough to capture the geometry of a surface, although a graph describes only points and a web of paths between them. This is close to Riemann's original approach. Riemann looked for the infinitesimal object that captures the essence of measuring the length of a curve, and found the line element $ds^2 = g_{ij} dx^i dx^j$.
- In synthetic geometry on a graph a construction is not unique; it is multi-valued. Two vertices are in general joined by many shortest paths, and so they have many midpoints. We deal with this by enumerating the objects a construction gives (points in dimension 0, paths in dimension 1) and attaching to the construction its vertex density $\rho \colon V \to \{0, 1, 2, \dots\}$, where $\rho(v)$ is the number of objects through the vertex $v$. Let graphs converge to a space, $(V_n, d_n, \mu_n) \to (M, d, \mu)$, in the Gromov-Hausdorff sense for metric measure spaces, with $d_n$ the rescaled path metric and $\mu_n$ the rescaled counting measure. We imagine that the normalized densities $\rho_n / \sum_v \rho_n(v)$ then converge weakly to the Dirac density of the corresponding object in the infinitesimal world, concentrated on a point or along a curve.
- The Riemannian branch measures the substrate instead of constructing on it. Its objects are the level sets of the distance from a vertex: the closed ball B_r(c) = {v : d(c, v) <= r} and the shell S_r(c) = {v : d(c, v) = r}, each an inert head, InfraBall and InfraShell, whose volumes InfraMeasurement reads and whose vertices FindInfraRepresentative gives; FindInfraShell computes the shell as a sorted vertex list. A geodesic is read at a scale: the observer sees s steps back, and a walk is a geodesic at infra-scale s when every window of s consecutive vertices together with the next one is a shortest path, so scale 1 is any walk and scale Infinity is a segment; FindInfraGeodesic grows them, and the "Graph" of InfraMeasurement[g, InfraSegment[p, q]] and SprayGraph hold every geodesic between two vertices, or from one vertex, as a directed acyclic graph whose directed paths are exactly the geodesics, built from the distance matrix without listing them. The measurements are counts: the ball volume V(r) = |B_r|, the shell area A(r) = V(r) - V(r - 1) and the tube volume T(s) = |{w : d(w, core) <= s}|, each under a chosen convention for its outermost layer. The log-difference quotient q(r) = d log V / d log r is affine in r(r + 1) over a middle window of radii, and a regression there reads the dimension as the intercept and the scalar curvature as the slope, Bishop-Gromov on a graph; the ball and the shell are two independent probes of the same pair, and the tube about a geodesic reads R + Ric(v, v) along its core. The metric tensor at p is the matrix d(p, u) / d(p, v) with u the foot of v on the interval I(p, w): on a substrate whose large-scale metric is round it tends to max(0, cos theta), the Gram matrix of the unit directions at p, and on a periodic tiling to the projection tensor of the polyhedral norm the path metric converges to. The Riemann tensor is not here yet. The ball, tube, cylinder, cone and sphere heads and the two geodesic graphs are on the Euclidean Infrageometry guide, the covering dimension and the ball intersection complex on the Infra Topology guide, the tangent and cotangent spaces on the Infra Analysis guide, and the Levi-Civita connection on the Infra Fiber Bundles guide.

---

### Infrageodesics

- `InfraGeodesic` the inert geodesics at infra-scale s through a germ, a vertex list; InfraMeasurement reads its graph, the window graph of the forward extensions, FindInfraRepresentative the inextensible simple ones
- `FindInfraGeodesic` the geodesics at infra-scale s grown from a germ, a vertex or a walk: every window of s consecutive vertices plus the next one is a shortest path; a trailing count gives a List of them
- `InfraGeodesicQ` whether a walk is a geodesic at infra-scale s; scale 1 is InfraWalkQ and Infinity is InfraSegmentQ

### Shells

- `InfraShell` the inert shell {v : rmin <= d(c, v) <= rmax} about a vertex or a vertex set, a level set of the distance; InfraMeasurement reads its volumes, FindInfraRepresentative its vertices
- `FindInfraShell` the shell {v : d(c, v) = r}, or the band {rmin, rmax}, as a sorted vertex list; the separating subsets of a shell are FindInfraSphere on the Euclidean Infrageometry guide

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

