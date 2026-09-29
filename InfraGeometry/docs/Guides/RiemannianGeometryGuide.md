---
Template: Guide
Name: RiemannianGeometryGuide
Title: Riemannian Infrageometry
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/RiemannianGeometryGuide
Keywords: [Riemannian geometry, graph, geodesic, infra-scale, ball, shell, tube, volume growth, dimension, scalar curvature, metric tensor]
RelatedGuides: [EuclideanGeometryGuide, TopologicalPropertiesGuide, TangentSpacesAndFormsGuide, Experimental]
---

## Abstract

The Riemannian branch measures the substrate instead of constructing on it. Its objects are the level sets of the distance from a vertex: the closed ball B_r(c) = {v : d(c, v) <= r} and the shell S_r(c) = {v : d(c, v) = r}, each a sorted vertex list that FindInfraBall and FindInfraShell compute and that InfraBall and InfraShell name inside a scene. A geodesic is read at a scale: the observer sees s steps back, and a walk is a geodesic at infra-scale s when every window of s consecutive vertices together with the next one is a shortest path, so scale 1 is any walk and scale Infinity is a segment; FindInfraGeodesic grows them, and GeodesicIntervalGraph and GeodesicSprayGraph hold every geodesic between two vertices, or from one vertex, as a directed acyclic graph whose directed paths are exactly the geodesics, built from the distance matrix without listing them. The measurements are counts: the ball volume V(r) = |B_r|, the shell area A(r) = V(r) - V(r - 1) and the tube volume T(s) = |{w : d(w, core) <= s}|, each under a chosen convention for its outermost layer. The log-difference quotient q(r) = d log V / d log r is affine in r(r + 1) over a middle window of radii, and a regression there reads the dimension as the intercept and the scalar curvature as the slope, Bishop-Gromov on a graph; the ball and the shell are two independent probes of the same pair, and the tube about a geodesic reads R + Ric(v, v) along its core. The metric tensor at p is the matrix d(p, u) / d(p, v) with u the foot of v on the interval I(p, w): on a substrate whose large-scale metric is round it tends to max(0, cos theta), the Gram matrix of the unit directions at p, and on a periodic tiling to the projection tensor of the polyhedral norm the path metric converges to. Tubes and cones, the Riemann tensor and the Levi-Civita connection are the sections that still wait for their symbols. The covering dimension and the ball intersection complex are on the Topological Properties guide, and the tangent and cotangent spaces on the Tangent Spaces and Forms guide.

## Functions

### Infrageodesics

- `FindInfraGeodesic` the geodesics at infra-scale s from p1, or from p1 to p2: every window of s consecutive vertices plus the next one is a shortest path; a trailing count gives a List of them
- `InfraGeodesicQ` whether a walk is a geodesic at infra-scale s; scale 1 is InfraWalkQ and Infinity is InfraSegmentQ
- `ExtendInfraGeodesic` continues a seed walk as a geodesic at infra-scale s, by a budget of edges per growing side
- `GeodesicIntervalGraph` the metric interval I(u, v) = {w : d(u, w) + d(w, v) = d(u, v)} as a directed acyclic graph whose directed u-v paths are exactly the geodesics, built from the distance fields without listing them
- `GeodesicSprayGraph` the breadth-first DAG rooted at c, whose source-to-sink paths are exactly the maximal geodesics from c; a list of pairs gives the union of their geodesics

### Balls and shells

- `InfraBall` the scene token for the closed ball of radius r about a centre; a ball itself is a sorted vertex list
- `FindInfraBall` the closed ball {v : d(c, v) <= r} as a sorted vertex list
- `InfraShell` the scene token for the shell of radius r about a centre, a level set of the distance; a shell itself is a sorted vertex list
- `FindInfraShell` the shell {v : d(c, v) = r}, or the band {rmin, rmax}, as a sorted vertex list; Properties -> {"Separating"} searches its minimal subsets separating the centre from the outside

### Tubes and cones

- waits for the region layer: the tube of radius s about a core and the cone at a vertex, with their volumes

### Volume measurements

- `BallVolumes` the ball volume profile {V(0), ..., V(ecc)}, V(r) = |B_r(v)|, at a vertex, a list of vertices or All; "Measure" chooses the convention for the outermost layer
- `ShellAreas` the shell profile A(r) = V(r) - V(r - 1), the radial derivative of BallVolumes under the same measure; Accumulate recovers BallVolumes
- `TubeVolumes` the tube profile T(s) = |{w : d(w, core) <= s}| about a vertex list, about the interval I(p, q), or one profile per target
- `LogDifferenceQuotients` the discrete d log w / d log r of a sequence, q(r) = (log w(r) - log w(r - 1)) / (log(r + 1) - log r); a sequence of Around values carries its spread into error bars
- `DimensionCurvatureFit` dimension and scalar curvature from log-difference quotients by regression on r(r + 1), the intercept and the slope, for the ball, sphere, tube or tube-mantle probe
- `VolumeGrowthObservables` the ball and sphere fits at a vertex over a window as one Association: profiles, quotients, fits and the windows used

### The metric tensor

- `InfraMetricTensor` the matrix d(p, u) / d(p, v) over v, w with u the foot of v on the interval I(p, w); with r, over the shell of radius r; "SelectCoordinate" reads a tie of feet

### The Riemann tensor

- waits: the curvature tensor from directional growth

### The Levi-Civita connection

- waits: the connection on the tangent germs, in InfraGaugeTheory today
