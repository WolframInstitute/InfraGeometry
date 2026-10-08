---
Template: Guide
Name: EuclideanInfrageometry
Title: Euclidean Infrageometry
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/EuclideanInfrageometry
Keywords: [Euclidean geometry, shell, synthetic geometry, graph, inert head, point, segment, ray, line, parallel, perpendicular, circle, arc, bisector, ellipse, ball, tube, cylinder, cone, polygon, hull, angle, scalar product, scene]
RelatedGuides: [RiemannianInfrageometry, InfraSubstrates, Experimental]
RelatedTutorials: [BreadthlessTriangleTutorial, StraighteningAtScaleTutorial]
---

## Abstract

Euclidean infrageometry is synthetic geometry on a graph $G = (V, E)$ with its path metric $d$. The points are the vertices, and the segments, rays, lines, circles, balls and polygons are defined from $d$ alone, as in Euclid. Riemannian infrageometry, in contrast, measures the substrate itself.

## Functions

- Classical geometry has infinitesimality: a segment can be subdivided infinitely many times, whatever the scale of the observer. A graph has no infinitely small part. Infrageometry aggregates instead: an observer scale $r$, the number of steps the observer inspects at once, must be given before an object makes sense.
- A construction on a graph is multi-valued: two vertices are joined by many geodesics, and so they have many midpoints. A construction therefore gives a family of objects, points in dimension 0 and paths in dimension 1, together with its vertex density $\rho \colon V \to \{0, 1, 2, \dots\}$, where $\rho(v)$ is the number of its objects through the vertex $v$.
- Let graphs converge to a space, $(V_n, d_n, \mu_n) \to (M, d, \mu)$, in the Gromov-Hausdorff sense for metric measure spaces, with $d_n$ the rescaled path metric and $\mu_n$ the rescaled counting measure. We expect the normalized densities $\rho_n / \sum_v \rho_n(v)$ to converge weakly to the Dirac density of the corresponding classical object, concentrated on a point or along a curve. The classical objects are breadthless and the classical intersections unique; the constructions here are their finite-scale versions.
- Each notion has three symbols. The inert head, InfraSegment[p, q], is the construction stated before any graph; InfraMeasurement reads it on a graph. The finder, FindInfraSegment[g, p, q], gives one object as a vertex list, and with a trailing count a List of them. The predicate, InfraSegmentQ[g, walk], tests a vertex list.
- The inert heads combine: InfraIntersection and InfraUnion of heads are heads again, and a head is an object of an InfraScene.

---

### Points

- `InfraPoint` the inert point, a vertex drawn from a region inside a scene
- `FindInfraPoint` a vertex drawn from a region, a vertex List, a ball or any other region; a count gives a List of vertices, "PairwiseDistance" constrains the tuple
- `FindInfraMidpoint` the middle vertices of the geodesics from p1 to p2 as a density, one vertex at even distance and two at odd

### Segments

- `InfraSegment` the inert segment from p to q, every geodesic between them at once; with more points, the polyline of their consecutive segments
- `FindInfraSegment` one geodesic from p to q as a vertex list; a trailing count gives a List of them
- `InfraSegmentQ` whether a walk is a geodesic

### Rays and lines

- `InfraRay` the inert ray from p through q, the geodesics from p through q that no neighbour of their last vertex prolongs; InfraRay[p, p] is the pencil at p
- `FindInfraRay` one ray from p through q as a vertex list; a trailing count gives a List of them
- `InfraLine` the inert line through p and q, the geodesics through both that no neighbour of either endpoint prolongs
- `FindInfraLine` one line through p and q as a vertex list; a trailing count gives a List of them

### Circles and arcs

- `InfraCircle` the inert circles around c at radius r, or in the band {r, s}: the shortest cycles of the band that separate c from the outside
- `InfraArc` the inert arc around c from p1 to pk through the intermediate points, the geodesics of the band graph of the circle through p1; InfraArc[c, {p, p}] is the closed arc

### Balls and shells

- `InfraBall` the inert closed ball {v : d(c, v) <= r} about a vertex or a vertex set
- `InfraShell` the inert shell {v : rmin <= d(c, v) <= rmax} about a vertex or a vertex set, a level set of the distance
- `FindInfraShell` the shell {v : d(c, v) == r}, or the band {rmin, rmax}, as a sorted vertex list

### Reading a construction on a graph

- `InfraMeasurement` a property of an inert head on a graph: "Graph", "Cardinality", "Length", "VertexDensity", "EdgeDensity", "Subgraph", "Faithful", "CountingMeasure", "RiemannianMeasure"; the "Graph" of a segment, ray, line or arc is the directed acyclic graph whose directed paths are exactly its objects
- `FindInfraRepresentative` one member of a head as a vertex list; a trailing count gives a List of them, "RandomChoice" a random member
- `InfraMemberQ` whether a vertex list is a member of a head on a graph
- `InfraDensity` the vertex density of any object: a vertex, a vertex list, a density, a walk graph
- `InfraIntersection` the objects common to two inert heads, an inert head again, with the product of their vertex densities
- `InfraUnion` the objects of either of two inert heads, an inert head again, with the sum of their vertex densities

### Substrates and drawing

- `InfraSubstrate` the named example graphs at size "Small", "Medium" or "Large", listed on the Infra Substrates guide
- `InfraSubstrateHighlight` the densities of a list of objects drawn on a graph, the i-th object in the i-th palette color; a Directive styles the objects after it

### Scenes

- `InfraScene` a construction stated before any graph: the objects, and hypotheses that construct them with inert heads or assert relations between them
- `InfraStep` one construction encapsulated as a step of a scene; a second argument labels it
- `FindInfraScene` a scene solved on a graph, step by step; a List of bindings, one per admissible combination
- `InfraSceneInstance` one solved binding of a scene; with an object name, that object read out of it
- `InfraSceneViewer` a step-by-step view of a scene on a graph

### Experimental: Points

- `FindInfraGoldenSection` the density at the golden-ratio index along every geodesic from p1 to p2
- `FindInfraReflection` the reflections x' of x through a, the vertices with d(x, a) == d(a, x') on a geodesic through a
- `FindInfraCommonPoint` the points lying on every listed line
- `FindClosestInfraPoint` the vertices of a line at minimum distance from a point, the feet of the point on the line
- `FindInfraEquidistantSet` the vertices equidistant from p1, ..., pn as a sorted vertex list; a trailing {lo, hi} thickens each bisector to a slab
- `InfraReachableQ` whether p1 and p2 lie in the same connected component

### Experimental: Segments and lines

- `UniqueInfraSegmentQ` whether the geodesic from u to v is unique
- `MetricInterval` the interval {w : d(u, w) + d(w, v) == d(u, v)}, the union of the geodesics from u to v
- `FindInfraPolylineSubdivision` the fewest geodesic legs a walk splits into, the corners of the polyline InfraSegment[p1, ..., pk]
- `InfraRayQ` whether a walk is a ray, a geodesic from its first vertex that cannot be prolonged past its last
- `InfraLineQ` whether a walk is a line, a geodesic that no neighbour of either endpoint prolongs
- `FindInfraParallel` the parallels to a line through p, the lines through p at constant distance from it
- `InfraParallelQ` whether two lines stay at constant distance
- `FindInfraPerpendicular` the lines through a point perpendicular to a line
- `InfraPerpendicularQ` whether two lines meet perpendicularly at every common vertex
- `FindInfraCommonLine` the lines containing every listed vertex
- `LineCount` the number of distinct lines in a graph
- `UniversalLineQ` whether some pair of vertices spans a line filling a whole connected component, the Chen-Chvatal property

### Experimental: Circles, spheres and conics

- `InfraCircleQ` whether a cycle is a circle, a cyclic edge chain whose vertex set is a metric shell
- `InfraSphere` the inert family of inclusion-minimal connected subsets of the shell {v : d(c, v) == r} that separate c from the outside
- `FindInfraSphere` n of these separating subsets as vertex lists
- `InfraPlane` the inert bisecting hyperplane of p1 and p2
- `FindInfraBisectingHyperplane` the perpendicular bisector {v : d(p1, v) == d(p2, v)}, or the slab around it
- `InfraEllipse` the inert ellipse with foci p1 and p2, the shortest separating cycle in the level set {v : d(p1, v) + d(p2, v) == c}
- `FindInfraEllipse` one such cycle as a cyclic vertex list
- `InfraEllipseQ` whether a cycle is an ellipse
- `InfraQuadric` the inert solid {v : sum_i w_i d(p_i, v) <= c} about the foci p_i; one focus is the ball, two the ellipse, a band {c, c} the elliptic shell, weights {1, -1} a hyperbola branch

### Experimental: Solids

- `InfraBallQ` whether a vertex set is a closed ball
- `InfraShellQ` whether a vertex set is a shell {v : d(c, v) == r} for some centre c and radius r
- `InfraTube` the inert tube {v : d(a_i, v) <= r_i for some i} along a core, the profile a radius, a band, a list along the core or a function of the position; Method "Balls" or "Sliced"
- `InfraCylinder` the inert cylinder of radius r about a walk, the sliced tube with flat ends
- `InfraCone` the inert cone of a given slope along a walk, apex at its first vertex and a flat base
- `InfraSolidOfRevolution` the inert solid about a walk with a given radius profile

### Experimental: Polygons and hulls

- `InfraPolygon` the inert regular n-gon whose k-th diagonals have prescribed lengths; the polygon through given corners is the closed polyline InfraSegment[p1, ..., pn, p1]
- `FindInfraRegularPolygon` one closed n-vertex sequence whose k-th diagonal lengths match the prescribed ones
- `InfraRegularPolygonQ` whether a cycle is regular with respect to a tuple of diagonal lengths
- `InfraConvexHull` the inert geodesic convex hull of a set, the closure under MetricInterval; with k, the k-th round of the closure
- `InfraBallHull` the inert intersection of the closed balls containing a set, of radius at most r, {r} exactly r or {r, s} between; without a radius the Mazur hull

### Experimental: Angles

- `InfraAngle` the angle at p between q1 and q2 in radians, Method "Arclength" or "Alexandrov", the comparison angle of the three distances
- `InfraScalarProduct` the product d(o, u) d(o, v) cos(theta) based at o, the polar form of the metric at curvature 0
- `FindInfraLinearCombination` the vertices realising a linear combination of vertices based at o

### Experimental: Perpendicular axes

- `FindInfraOrthogonalAxes` a maximal set of mutually perpendicular lines through a centre c, each a vertex list
- `FindInfraOrthogonalRays` a maximal set of mutually perpendicular rays from a centre c, each a vertex list
- `FindInfraSpanningAxes` n mutually well-separated longest geodesics across a graph, with no fixed centre
- `OrthogonalCoordinates` the signed position of the foot of each vertex on each of a list of axes, counted from the centre c

### Experimental: Sets

- `InfraDistance` the distance between two objects, aggregated over their vertex sets
- `InfraBoundary` the boundary of a vertex set, density or object, as a sorted vertex list
- `InfraInterior` the interior of a vertex set, density or object, as a sorted vertex list
- `InfraEqualQ` whether two objects are equal; Method chooses set, multiset, overlap or diffuse equality

### Experimental: Graphs of a construction

- `SprayGraph` the directed acyclic graph rooted at c whose source-to-sink paths are exactly the maximal geodesics from c
- `PathSubgraph` the union of all geodesics from u to v, as a subgraph
- `InfraSubgraph` the subgraph induced on the support of an object; obj -> t thickens the support by t steps
- `Undetermined` the value of "Faithful" on a head whose graph is faithful only under a hypothesis the paclet does not certify

### Experimental: Scenes

- `InfraIntersectQ` the hypothesis that two objects of a scene meet
- `InfraPlaneQ` the hypothesis that a set of a scene lies in the bisector slab of p1 and p2 and separates them
- `PointViewer`, `SegmentViewer`, `ShellViewer`, `CircleViewer` interactive viewers for points, geodesic segments, shells and circles
### Not here

- not here: an invariant of four points, and the inverse of every head, the values of its unknowns for a given vertex set
- not here: the geodesics at a scale and the volume measurements, which are on the Riemannian Infrageometry guide
