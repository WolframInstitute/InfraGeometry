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
<!-- The protected Functions prose was moved verbatim into the Abstract on 2026-10-13 (user's call):
     markup only, symbols linked, bold dropped. build_docs.wls renders each paragraph as its own
     GuideAbstract cell. -->

## Abstract

*Abstract written by Pavel Hajek on 18 October 2026.*

Riemannian Infrageometry describes and distinguishes graphs as **geometric substrates**. In contrast, synthetic infrageometry asks only whether certain postulates are satisfied by the substrate so that its propositions about geometric objects hold.

Riemann viewed space as an infinitesimal webbing of paths and, by imposing conditions on the infinitesimal length element, arrived at the **quadratic metric tensor** as the lowest-order data satisfying those conditions. This split continuous geometry into a manifold, which carries the topology and global analysis, and a Riemannian structure. This led people such as Gromov to ask about the moduli space of Riemannian structures on a fixed manifold, or, conversely, to derive topological quantities from Riemannian ones.

In infrageometry, the discrete webbing of paths given by a graph is itself the geometric substrate, so no such split occurs. We relate infrageometry to continuous geometry through **rescaled Gromov–Hausdorff convergence**, where the scaling is determined by the observer's scale. This yields a generalized definition of geometry: if a limit of rescaled graphs is a metric space arising from a Riemannian manifold, then that manifold is uniquely determined up to isomorphism.

A geodesic at observer scale $r$ of length $k$, <code>[InfraGeodesic]()[*germ*, *r*, *k*]</code>, is a family of walks of length $k$ that are shortest paths in every window of $r$ edges. A representative can be found with <code>[RandomInfraGeodesic]()[…]</code>, and the edge density of the corresponding multi-object with <code>[InfraMeasurement]()[*g*, *geodesic*, "EdgeDensity"]</code>.

We can measure the volumes of <code>[InfraBall]()[*p*, *r0*]</code> for $r_0 \leq r$, <code>[InfraTube]()[*axis*, *s*]</code> for any ray or line through $p$ and any thickness $s$, and <code>[InfraCone]()[*axis*, *s*]</code> for slope $s$. Such measurements have asymptotic expansions in the continuous case and can be used to determine **limiting curvature components**. However, no sphere structure exists a priori on [InfraShell](), so the limiting linear tensors can be compared only through histograms. We can also obtain the histogram of mutual distances between points, which constrains the limiting Riemannian manifold.

We have <code>[InfraTangentBundle]()[*g*, *r*]</code> which represents vectors at p by rays of length $r$, and these are compactly encoded as chains in the spray graph at $p$. We have an even simpler infra-bundle, <code>[InfraDisplacementBundle]()[*g*, *r*]</code>, that keeps only the endpoints of rays. We have a minimal model of the Levi-Civita connection, <code>[FindInfraLeviCivitaConnection]()[InfraDisplacementBundle[*g*, *r*]]</code>, and <code>[InfraParallelTransport]()[InfraDisplacementBundle[*g*, *r*], *walk*]</code>.

We also have <code>[InfraMetricTensor]()[*g*, *p*, *r*]</code>, which computes shortest path projections of rays, displacement commutator <code>[DisplacementCommutator]()[*g*, *d1*, *d2*]</code>, and addition of displacements via midpoints with <code>[DisplacementSum]()[*g*, *d1*, *d2*]</code>. These can be used to illustrate **emergence of linearity**.

<!-- /LLM-PROTECTED -->

## Functions

### Infrageodesics

- `InfraGeodesic` the geodesics at infra-scale $s$ through a germ, walks that are shortest paths in every window of $s$ steps
- `RandomInfraGeodesic` random geodesics at infra-scale $s$ grown from a vertex or a walk
- `InfraGeodesicQ` whether a walk is a geodesic at infra-scale $s$
- `FindShortestPath` (WL) a geodesic at infinite scale, a shortest path

- `InfraWalkQ`, `InfraSegmentQ`

### Straight walks

- `RandomInfraWalk` walks grown from a germ; `{"Geodesic", "Straightness" -> β}` weighs each step by its mean gain, and the bare `"Geodesic"` is a shortest path
- A step from the tip $w_t$ of the window $(w_0, \dots, w_t)$ to a neighbour $v$ has the gain $g_i(v) = d(w_i, v) - d(w_i, w_t) \in \{-1, 0, 1\}$ against each earlier vertex, and the mean gain $g(v) = \frac{1}{t} \sum_{i < t} g_i(v)$.
- The walk draws $v$ with probability proportional to $e^{\beta g(v)}$. Only differences of scores matter, so the mean gain ranks like the total distance $\sum_{i < t} d(w_i, v)$ to the window, and the exponential is the only such weight.
- On a mesh whose path distance is a rounding of the Euclidean distance, $g(v) \approx \cos\theta$ for a turn by the angle $\theta$, since the roundings up and down balance along a window not aligned with the mesh. The turning angle follows the von Mises distribution $e^{\beta \cos\theta}$, approximately Gaussian with variance $1/\beta$.
- On the square grid a turn by $90^\circ$ has gain $1$ as well, and the straightest walks are staircases.

### Distances between objects

- `InfraDistance` the graph distance between the supports of two objects, with a choice of aggregation

### Balls, shells and tubes

- `InfraBall` the closed ball $\{v : d(c, v) \le r\}$
- `InfraShell` the shell $\{v : r_{min} \le d(c, v) \le r_{max}\}$, a level set of the distance
- `InfraTube` the tube of thickness $s$ about a ray or a line
- `InfraCone` the cone of slope $s$ along a ray
- `NeighborhoodGraph` (WL) the ball as an induced subgraph

### Volume measurements

- `InfraMeasurement` the counting measure $|A|$ of a region and its Riemannian measure $|A^\circ|$, the size of its interior
- `LogDifferenceQuotients` the discrete logarithmic derivative $d \log w / d \log r$ of a volume profile
- `DimensionCurvatureFit` dimension and scalar curvature from the log-difference quotients
- `VolumeGrowthObservables` the ball and sphere profiles, quotients and fits at a vertex
- `InfraSubstrate` the example substrates the volumes are measured on

### The metric tensor

- `InfraMetricTensor` the matrix $d(p, u) / d(p, v)$ over pairs of vertices, $u$ the foot of $v$ on the interval $I(p, w)$

### Bundles, connection and linearity

- `InfraTangentBundle` vectors at a vertex as rays of length $r$
- `InfraDisplacementBundle` vectors at a vertex as endpoints of rays of length $r$
- `FindInfraLeviCivitaConnection` the Levi-Civita connection of a displacement bundle
- `InfraParallelTransport` the parallel transport along a walk
- `DisplacementSum` the sum of two displacements via midpoints
- `DisplacementCommutator` the commutator loop of two displacements


### Linear structure and comparison angles

- `InfraScalarProduct` the product $d(o,u)d(o,v)\cos\theta$ based at $o$
- `FindInfraLinearCombination` the vertices realising a linear combination of vertices based at $o$
- `InfraComparisonAngle` the comparison angle of a metric triangle in a model of prescribed curvature

### Orthogonal axes and coordinates

- `FindInfraOrthogonalAxes` a maximal set of mutually perpendicular lines through a centre
- `FindInfraOrthogonalRays` a maximal set of mutually perpendicular rays from a centre
- `FindInfraSpanningAxes` $n$ well-separated longest shortest paths across a graph
- `OrthogonalCoordinates` the signed position of the foot of each vertex on each axis
