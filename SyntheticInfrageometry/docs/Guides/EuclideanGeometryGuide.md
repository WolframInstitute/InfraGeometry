---
Template: Guide
Name: EuclideanGeometryGuide
Paclet: WolframInstitute/SyntheticInfrageometry
URI: WolframInstitute/SyntheticInfrageometry/guide/EuclideanGeometryGuide
Keywords: [Euclidean geometry, graph, geodesic, synthetic, Euclid, Tarski]
RelatedGuides: [SyntheticInfrageometryGuide, TarskiGeometryGuide, VisualizationGuide]
---

## Abstract

Euclidean geometry rebuilt inside a graph. The graph is all there is: no ambient space, no coordinates. Each Euclidean notion is redefined using graph properties alone, and the shortest-path metric is the layer these definitions sit on. Two things change from the plane. A construction returns a *set* of admissible answers rather than one, so uniqueness fails generically. And some objects fail to exist at all — a circle of a single radius is empty on a lattice, and a perpendicular bisector is empty at odd distance. Both are results, not defects.

## Functions

### Points

- `InfraPoint` the scene token for a point; a point is a bare vertex
- `FindInfraPoint` points drawn from a candidate pool, narrowed by `"From"` and `"Distance"`
- `RandomInfraPoint` a uniformly random vertex, or one at a given distance from a point
- `InfraCenter` a vertex of least eccentricity
- `SelectInfraPoint` the same narrowing applied to a bundle you already hold
- `FindInfraMidpoint` vertices *m* with *d(a,m) = d(m,b) = d(a,b)/2*, over all geodesics
- `FindClosestInfraPoint` the vertices of a line nearest a given point
- `FindInfraReflection` the reflection of a point in a line

### Measuring a Euclidean object

- `InfraMeasurement` evaluates an inert segment, ray, line, circle or arc on a graph: its graph, cardinality, length, densities and volumes
- `InfraVertexList` the members of an object as vertex lists, one, several, all or a uniform random one
- `InfraMemberQ` whether a vertex list is a member of an object
- `InfraSubgraph` the subgraph induced on the support of an object
- `Undetermined` the value of `"Faithful"` where the object's graph is faithful only under an uncertified hypothesis

### Segments and lines

- `InfraSegment` the set of all geodesics between two vertices, as an inert head; a polyline with more points
- `FindInfraSegment` one geodesic, or a list of them, as vertex lists
- `MetricInterval` the vertices lying on some geodesic between two points
- `InfraLine` the inextensible geodesics through two points, as an inert head
- `FindInfraLine` one line through two points or containing a given geodesic, or a list of them, as vertex lists
- `ExtendInfraSegment` the geodesics containing a segment, extended by a budget per side; also Tarski's segment-construction step
- `GeodesicExtensionGraph` the DAG of geodesic extensions of a segment beyond its end, the engine behind lines and rays
- `InfraWalk`, `FindInfraWalk`, `ExtendInfraWalk` walks, where revisiting a vertex is allowed
- `InfraRay`, `FindInfraRay` the geodesics from a base vertex that cannot be prolonged past their far end, which is how direction is expressed: the inert head and the search
- `PencilDirections`, `PencilCardinality` the rays leaving a vertex, and how many there are
- `InfraPolyline`, `FindInfraPolylineSubdivision` a walk cut into geodesic legs

### Circles, shells and balls

- `InfraShell`, `FindInfraShell` the level surface *{v : d(c,v) = r}*, a vertex set
- `InfraBall`, `FindInfraBall` the closed ball *{v : d(c,v) <= r}*, whose volume is an exact polynomial on a lattice
- `InfraCircle`, `FindInfraCircle` the shortest separating cycles of a band around a centre, empty at single radius on a lattice: the inert head and the search
- `InfraArc`, `FindInfraArc` the minor arcs of a circle between two points: the inert head and the search
- `InfraEllipse`, `FindInfraEllipse` the sum-of-distances band around two foci
- `InfraPlane`, `FindInfraBisectingHyperplane` the perpendicular bisector, empty at odd distance

### Polygons and triangles

- `InfraTriangle`, `FindInfraTriangle` three vertices with their connecting segments
- `InfraPolygon`, `FindInfraPolygon` a cyclic vertex sequence
- `FindInfraRegularPolygon` cycles whose diagonals all have prescribed lengths
- `CompleteInfraEquilateralTriangle` the apexes completing two given vertices to an equilateral triangle

### Measurement

- `InfraAngle` an angle at a vertex, by arclength on the punched-out boundary or by comparison triangle
- `InfraScalarProduct` the polar form of the metric at a base point
- `InfraMetricTensor` the metric tensor at a base point, read from where vertices project onto intervals
- `InfraCurvature` a local curvature from the growth of balls
- `ComparisonTriangle`, `InfraComparisonTriangle`, `CATInequalityQ` the CAT(k) comparison layer
- `TurningAngles`, `TotalCurvature`, `TurningNumber` curvature along a walk

### Predicates

- `InfraWalkQ`, `InfraSegmentQ`, `InfraLineQ` a strict hierarchy: walk, then geodesic, then inextensible geodesic
- `UniqueInfraSegmentQ` whether the geodesic between two points is unique, so whether Euclid's first postulate holds sharply
- `InfraParallelQ`, `FindInfraParallel` constant distance to a line
- `InfraPerpendicularQ`, `FindInfraPerpendicular` right angles, with several inequivalent methods
- `InfraShellQ`, `InfraBallQ`, `InfraCircleQ`, `InfraEllipseQ`, `InfraPolygonQ`, `InfraTriangleQ` membership tests for each shape
- `SeparatesQ` whether a vertex set disconnects one point from another
- `InfraEqualQ` equality of two infra-objects, under a choice of set or multiset semantics

### Axioms

- `BetweennessQ` Tarski's *B(u,w,v)*: *d(u,w) + d(w,v) = d(u,v)*
- `EquidistanceQ` Tarski's congruence: *d(a,b) = d(c,d)*
- `TarskiAxiomQ` all eleven axioms tested at once on a graph
- `TarskiStructure`, `TarskiBetweennessTensor`, `TarskiEquidistanceClasses` the two primitives as explicit data
- `FindTarskiCounterexample` a witness to an axiom failing

### Substrates and drawing

- `InfraHighlightGraph` the one rendering primitive; intensity follows multiplicity
- `InfraScene`, `FindInfraScene`, `InfraGeometricStep` a construction stated as constraints and then solved
- `InfraSceneViewer` a construction stepped through interactively
- `$InfraPalette` the colour of each object head, in one place
