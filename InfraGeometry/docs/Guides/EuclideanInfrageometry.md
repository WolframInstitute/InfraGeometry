---
Template: Guide
Name: EuclideanInfrageometry
Title: Euclidean Infrageometry
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/EuclideanInfrageometry
Keywords: [Euclidean geometry, shell, synthetic geometry, graph, symbolic object, point, segment, ray, line, parallel, perpendicular, circle, arc, bisector, ellipse, ball, tube, cylinder, cone, polygon, hull, angle, scalar product, scene]
RelatedGuides: [RiemannianInfrageometry, InfraSubstrates, Experimental]
RelatedTutorials: [BreadthlessTriangleTutorial, StraighteningAtScaleTutorial]
---

<!-- LLM-PROTECTED: Do not rewrite the Abstract or Functions sections unless explicitly asked. -->

## Abstract

**Euclidean Infrageometry** studies natural geometric objects on arbitrary graph substrates using **synthetic methods**. It enumerates these objects, studies their mutual relations, applies operations to them, and performs iterative constructions. If space is represented by a large graph, which we may view as a web of paths, human geometry can be viewed as an idealized theory based on our large-scale perception of **infinitesimality**. This leads to the idealization of space as a continuous "web" containing idealized objects such as the "breadthless line." Infrageometry works directly with the discrete substrate at an observer's scale and does not benefit from infinitesimality. Consequently, objects may not be unique, leading to **multi-objects**, and constructions generate branching **multiway systems**. Although concrete representatives may differ across branches, the system is "causally invariant" in the sense that the dependency graph of construction steps is the same in every branch. We associate each multi-object with **vertex and edge densities** that count the representatives containing each vertex or edge. Dividing by the number of representatives gives the corresponding fractions. We expect that, under a suitable notion of **Gromov-Hausdorff convergence**, these measures converge weakly to Dirac measures supported on classical "thin" geometric objects, provided the limiting space supports the classical Euclidean axioms.

## Functions

We use **inert symbolic objects** such as `InfraSegment[p, q]`, independent of a graph substrate. `InfraMeasurement[g, obj, property]` reads an object on a graph. `RandomInfraRepresentative[g, obj]` draws one concrete representative as a vertex list.

Segments, rays, lines and arcs have compact graph representations. Their paths encode the representatives, allowing counts and densities to be computed without enumerating every path. These graphs are part of the Euclidean construction tools.

An `InfraScene` describes a construction through named objects and hypotheses. `RandomInfraInstance[scene, graph]` draws an admissible instance on a substrate, and `InfraSceneViewer[scene, graph]` displays the construction step by step.

<!-- /LLM-PROTECTED -->

---

### Points

- `InfraPoint` the point, a vertex drawn from a region inside a scene
- `RandomInfraPoint` a vertex drawn from a region, a vertex List, a ball or any other region; a count gives a List of vertices, "PairwiseDistance" constrains the tuple

### Segments

- `InfraSegment` the segment from p to q, every shortest path between them at once; with more points, the polyline of their consecutive segments
- `RandomInfraSegment` one random shortest path from p to q as a vertex list; a trailing count gives a List of them
- `InfraSegmentQ` whether a walk is a shortest path

### Rays and lines

- `InfraRay` the ray from p through q, the shortest paths from p through q that no neighbour of their last vertex prolongs; InfraRay[p, p] is the pencil at p
- `RandomInfraRay` one random ray from p through q as a vertex list; a trailing count gives a List of them
- `InfraLine` the line through p and q, the shortest paths through both that no neighbour of either endpoint prolongs
- `RandomInfraLine` one random line through p and q as a vertex list; a trailing count gives a List of them

### Circles and arcs

- `InfraCircle` the circles around c at radius r, or in the band {r, s}: the shortest cycles of the band that separate c from the outside
- `InfraArc` the arc around c from p1 to pk through the intermediate points, the shortest paths of the band graph of the circle through p1; InfraArc[c, {p, p}] is the closed arc

### Balls and shells

- `InfraBall` the closed ball {v : d(c, v) <= r} about a vertex or a vertex set
- `InfraShell` the shell {v : rmin <= d(c, v) <= rmax} about a vertex or a vertex set, a level set of the distance
- `FindInfraShell` the shell {v : d(c, v) == r}, or the band {rmin, rmax}, as a sorted vertex list

### Reading a construction on a graph

- `InfraMeasurement` reads "Graph", "Cardinality", "Length", "VertexDensity", "EdgeDensity", "Subgraph", "Faithful", "CountingMeasure" and "RiemannianMeasure"; "Midpoint" gives the middle-layer density of a segment
- `RandomInfraRepresentative` draws one member of an object as a vertex list; a trailing count requests several; "NextVertexFunction" -> Identity gives deterministic enumeration, and All gives every member
- `Undetermined` the value of "Faithful" when the geometric hypotheses needed for a carrier are not certified
- `InfraMemberQ` whether a vertex list is a member of a head on a graph
- `InfraDensity` converts a vertex, vertex list, density or walk graph to vertex multiplicities
- `InfraIntersection` the symbolic intersection of two objects, with the product of their vertex densities
- `InfraUnion` the symbolic union of two objects, with the sum of their vertex densities

### Graphs of a construction

- `SprayGraph` the spray graph at p, the DAG of all maximal shortest paths starting at p; also accepts a source set or density
- `IntervalGraph` the interval graph from p to q, the DAG whose source-to-sink paths are exactly the shortest paths from p to q; with more points, the List of consecutive interval DAGs
- `RayGraph` the DAG of maximal shortest paths starting at p and passing through q; p == q gives the spray at p
- `BeamGraph` the List of DAGs of lines through p and q, one per compatible pair of maximal endpoints; also accepts a shortest-path germ
- `ArcGraph` the arc carrier around c through an ordered point list; two distinct endpoints give the interval DAG in the radial band, and closed arcs use seam carriers
- `PathSubgraph` the union of all shortest paths from u to v as a substrate subgraph

### Substrates and drawing

- `InfraSubstrate` the named example graphs at size "Small", "Medium" or "Large", listed on the Infra Substrates guide
- `InfraSubstrateHighlight` the densities of a list of objects drawn on a graph, the i-th object in the i-th palette color; a Directive styles the objects after it

### Scenes

- `InfraScene` a symbolic multi-construction stated before any graph: the objects, and hypotheses that construct them or assert relations between them
- `InfraStep` one construction encapsulated as a step of a scene; a second argument labels it
- `RandomInfraInstance` draws an admissible instance of a scene on a graph, returning an InfraSceneInstance binding
- `InfraSceneInstance` one solved binding of a scene; with an object name, that object read out of it
- `InfraSceneViewer` a step-by-step view of a scene on a graph

### Experimental

- `FindInfraReflection` the reflections x' of x through a, the vertices with d(x, a) == d(a, x') on a shortest path through a
- `FindInfraCommonPoint` the points lying on every listed line
- `FindClosestInfraPoint` the vertices of a line at minimum distance from a point, the feet of the point on the line
- `FindInfraEquidistantSet` the vertices equidistant from p1, ..., pn as a sorted vertex list; a trailing {lo, hi} thickens each bisector to a slab
- `InfraReachableQ` whether p1 and p2 lie in the same connected component

- `MetricInterval` the interval {w : d(u, w) + d(w, v) == d(u, v)}, the union of the shortest paths from u to v
- `FindInfraPolylineSubdivision` the fewest shortest-path legs a walk splits into, the corners of the polyline InfraSegment[p1, ..., pk]
- `InfraRayQ` whether a walk is a ray, a shortest path from its first vertex that cannot be prolonged past its last
- `InfraLineQ` whether a walk is a line, a shortest path that no neighbour of either endpoint prolongs
- `RandomInfraParallel` a random parallel to a line through p, drawn from the lines through p at constant distance from it
- `InfraParallelQ` whether two lines stay at constant distance
- `FindInfraPerpendicular` the lines through a point perpendicular to a line
- `InfraPerpendicularQ` whether two lines meet perpendicularly at every common vertex
- `FindInfraCommonLine` the lines containing every listed vertex
- `LineCount` the number of distinct lines in a graph
- `UniversalLineQ` whether some pair of vertices spans a line filling a whole connected component, the Chen-Chvatal property

- `InfraCircleQ` whether a cycle is a circle, a cyclic edge chain whose vertex set is a metric shell
- `InfraSphere` the family of inclusion-minimal connected subsets of the shell {v : d(c, v) == r} that separate c from the outside
- `RandomInfraSphere` random separating connected subsets of a shell, as vertex lists
- `InfraPlane` the bisecting hyperplane of p1 and p2
- `FindInfraBisectingHyperplane` the perpendicular bisector {v : d(p1, v) == d(p2, v)}, or the slab around it
- `InfraEllipse` the ellipse with foci p1 and p2, the shortest separating cycle in the level set {v : d(p1, v) + d(p2, v) == c}
- `RandomInfraEllipse` one random such cycle as a cyclic vertex list
- `InfraEllipseQ` whether a cycle is an ellipse
- `InfraQuadric` the solid {v : sum_i w_i d(p_i, v) <= c} about the foci p_i; one focus is the ball, two the ellipse, a band {c, c} the elliptic shell, weights {1, -1} a hyperbola branch

- `InfraBallQ` whether a vertex set is a closed ball
- `InfraShellQ` whether a vertex set is a shell {v : d(c, v) == r} for some centre c and radius r
- `InfraTube` the tube {v : d(a_i, v) <= r_i for some i} along a core, the profile a radius, a band, a list along the core or a function of the position; Method "Balls" or "Sliced"
- `InfraCylinder` the cylinder of radius r about a walk, the sliced tube with flat ends
- `InfraCone` the cone of a given slope along a walk, apex at its first vertex and a flat base
- `InfraSolidOfRevolution` the solid about a walk with a given radius profile

- `InfraPolygon` the regular n-gon whose k-th diagonals have prescribed lengths; the polygon through given corners is the closed polyline InfraSegment[p1, ..., pn, p1]
- `RandomInfraRegularPolygon` one random closed n-vertex sequence whose k-th diagonal lengths match the prescribed ones
- `InfraRegularPolygonQ` whether a cycle is regular with respect to a tuple of diagonal lengths
- `InfraConvexHull` the convex hull under shortest paths of a set, the closure under MetricInterval; with k, the k-th round of the closure
- `InfraBallHull` the intersection of the closed balls containing a set, of radius at most r, {r} exactly r or {r, s} between; without a radius the Mazur hull

- `InfraAngle` the angle at p between q1 and q2 in radians, Method "Arclength" or "Alexandrov", the comparison angle of the three distances
- `InfraScalarProduct` the product d(o, u) d(o, v) cos(theta) based at o, the polar form of the metric at curvature 0
- `FindInfraLinearCombination` the vertices realising a linear combination of vertices based at o

- `FindInfraOrthogonalAxes` a maximal set of mutually perpendicular lines through a centre c, each a vertex list
- `FindInfraOrthogonalRays` a maximal set of mutually perpendicular rays from a centre c, each a vertex list
- `FindInfraSpanningAxes` n mutually well-separated longest shortest paths across a graph, with no fixed centre
- `OrthogonalCoordinates` the signed position of the foot of each vertex on each of a list of axes, counted from the centre c

- `InfraDistance` the distance between two objects, aggregated over their vertex sets
- `InfraBoundary` the boundary of a vertex set, density or object, as a sorted vertex list
- `InfraInterior` the interior of a vertex set, density or object, as a sorted vertex list
- `InfraEqualQ` whether two objects are equal; Method chooses set, multiset, overlap or diffuse equality

- `InfraIntersectQ` the hypothesis that two objects of a scene meet
- `InfraPlaneQ` the hypothesis that a set of a scene lies in the bisector slab of p1 and p2 and separates them
- `PointViewer`, `SegmentViewer`, `ShellViewer`, `CircleViewer` interactive viewers for points, shortest-path segments, shells and circles

### Possible cleanup

- `InfraSubgraph` induces the substrate subgraph on an object's support; the unthickened form is also InfraMeasurement[g, obj, "Subgraph"], while obj -> t provides neighbourhood thickening
- `UniqueInfraSegmentQ` tests whether the segment's "Cardinality" is 1

### Not here

- not here: an invariant of four points, and the inverse of every head, the values of its unknowns for a given vertex set
- not here: the geodesics at a scale and the volume measurements, which are on the Riemannian Infrageometry guide
