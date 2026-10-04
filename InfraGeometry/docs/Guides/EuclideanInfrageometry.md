---
Template: Guide
Name: EuclideanInfrageometry
Title: Euclidean Infrageometry
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/EuclideanInfrageometry
Keywords: [Euclidean geometry, graph, inert head, synthetic object, segment, ray, line, arc, circle, ball, tube, cylinder, cone, sphere, hull, angle, measurement, substrate, scene, multi-construction]
RelatedGuides: [RiemannianInfrageometry, Experimental]
RelatedTutorials: [BreadthlessTriangleTutorial, StraighteningAtScaleTutorial]
---

## Abstract

Euclidean infrageometry is synthetic geometry: constructions with natural objects (points, segments, lines, circles) in a discrete substrate represented by a graph $G = (V, E)$. Riemannian infrageometry, in contrast, measures and describes the substrate itself.

## Functions

- Classical geometry has infinitesimality: a segment can be subdivided infinitely many times, whatever the scale of the observer. A graph has no infinitely small part. Infrageometry aggregates instead. An observer scale $r$, the number of steps the observer inspects at once, must be given before an object or a measurement makes sense.
- The claim of infrageometry is that limits of graphs are enough to capture the geometry of a surface, although a graph describes only points and a web of paths between them. This is close to Riemann's original approach. Riemann looked for the infinitesimal object that captures the essence of measuring the length of a curve, and found the line element $ds^2 = g_{ij} dx^i dx^j$.
- In synthetic geometry on a graph a construction is not unique; it is multi-valued. Two vertices are in general joined by many shortest paths, and so they have many midpoints. We deal with this by enumerating the objects a construction gives (points in dimension 0, paths in dimension 1) and attaching to the construction its vertex density $\rho \colon V \to \{0, 1, 2, \dots\}$, where $\rho(v)$ is the number of objects through the vertex $v$. Let graphs converge to a space, $(V_n, d_n, \mu_n) \to (M, d, \mu)$, in the Gromov-Hausdorff sense for metric measure spaces, with $d_n$ the rescaled path metric and $\mu_n$ the rescaled counting measure. We imagine that the normalized densities $\rho_n / \sum_v \rho_n(v)$ then converge weakly to the Dirac density of the corresponding object in the infinitesimal world, concentrated on a point or along a curve.
- Euclidean infrageometry is synthetic geometry of Euclidean-like objects in graphs. We provide a language for elementary multi-valued geometry at the infra-scale, and tools to study its convergence to the classical idealized "infinitesimal" Euclidean geometry, with "breadthless lines", unique intersections and the like. We represent synthetic objects by inert atomic tokens. They can be used for symbolic work, and their evaluation in a concrete graph is postponed.

---

### Basic Euclidean Synthetic Objects

- `InfraSegment` the inert segment from p to q, every shortest path between them at once; with more points, the polyline of their consecutive segments
- `InfraRay` the inert ray from p through q: the shortest paths from p through q that no neighbour of their last vertex prolongs; InfraRay[p, p] is the pencil at p
- `InfraLine` the inert line through p and q: the shortest paths through both that no neighbour of either endpoint prolongs
- `InfraArc` the inert arc around c from p1 to pk through the intermediate points: the shortest paths in the band graph of the circle through p1; InfraArc[c, {p, p}] is the closed arc, the circles through p
- `InfraCircle` the inert circles around c at radius r or in the band {r, s}: the shortest cycles of the band that separate c from the outside
- `InfraAngle` the angle at p between q1 and q2 in radians, Method "Arclength" or "Alexandrov", the comparison angle of the three distances
- `InfraIntersection` the objects common to two inert heads, an inert head again, with the product of their vertex densities
- `InfraUnion` the objects of either of two inert heads, an inert head again, with the sum of their vertex densities

### Regions

- `InfraBall` the inert closed ball {v : d(c, v) <= r} about a vertex or a vertex set; a band {r, s} in place of r is the shell
- `InfraTube` the inert tube {v : d(v, core) <= s} about a vertex, a vertex set, a density, a walk graph or a Euclidean head; a band {s, t} is the mantle
- `InfraCylinder` the inert cylinder of radius r about an axis, the tube of the axis
- `InfraCone` the inert cone of a given slope along an axis, apex at its first vertex
- `InfraSphere` the inert family of inclusion-minimal connected subsets of a shell that separate the centre from the outside; FindInfraSphere is its search

### Measures

- A region on a graph is measured by counting vertices, and its boundary is never negligible at a finite scale: the vertices at distance exactly $r$ are a share of order $1/r$ of the ball of radius $r$. So every region carries two measures, read by InfraMeasurement as properties of the region on a graph.
- Counting measure, "CountingMeasure": $\mu(A) = |A|$, the number of vertices of the support $A$ of the region.
- Riemannian measure, "RiemannianMeasure": $\mu^\circ(A) = |A^\circ|$, where $A^\circ = \{v \in A : N(v) \subseteq A\}$ is the set of vertices all of whose neighbours lie in $A$. It is the count without the boundary, the default of the volume growth estimators.
- `InfraBall`, `InfraShell`, `InfraTube`, `InfraCylinder`, `InfraCone`, `InfraSphere` the region heads, each measured by both; so is every Euclidean head, through the support of its vertex density
- Ball on the square grid: counting measure $2r^2 + 2r + 1$, Riemannian measure $2r^2 - 2r + 1$, the counting measure of the ball of radius $r - 1$. The same shift holds on the triangular lattice, before the rim, and is the convention of the Wolfram Physics technical introduction; on the hexagonal lattice it is measured, not proved.
- Shell on the square grid: counting measure $4r$, the coordination sequence; Riemannian measure $0$, since a shell is all boundary.
- Segment on the square grid between vertices $a$ and $b$ steps apart along the two axes, $a, b \geq 1$: its interval is a rectangle, with counting measure $(a + 1)(b + 1)$ and Riemannian measure $(a - 1)(b - 1)$.
- Ball on the discretized plane: the Riemannian measure can exceed the counting measure of the smaller ball, when a vertex at distance $r$ has no neighbour at distance $r + 1$.
- `VolumeGrowthObservables` the dimension and the scalar curvature read from the growth of the balls under either measure; it lives on the Riemannian Infrageometry guide

### Find Functions

- `FindInfraPoint` a vertex drawn from the candidate pool, narrowed by "From" and "Distance"; a trailing count gives a List of vertices
- `FindInfraMidpoint` the middle vertices of the shortest paths from p1 to p2 as a density, one vertex at even distance, two at odd
- `FindInfraEquidistantSet` the vertices equidistant from p1, ..., pn, as a sorted vertex list; a trailing {lo, hi} thickens each bisector to a slab
- `FindInfraSphere` n inclusion-minimal connected subsets of the shell of c that separate its inside from its outside; Properties chooses the class, "NextVertexFunction" the order of the peel
- `FindInfraSegment` one shortest path from p to q as a vertex list; a trailing count gives a List of them
- `FindInfraRay` one ray from p through q as a vertex list, a shortest path from p through q that no neighbour of its last vertex prolongs; a trailing count gives a List of them
- `FindInfraLine` one line through p and q as a vertex list, an inextensible shortest path through both; a trailing count gives a List of them

### Measurements

- `InfraMeasurement` a property of a head on a graph: "Graph", "Cardinality", "Length", "VertexDensity", "EdgeDensity", "Subgraph", "Faithful", "CountingMeasure" and "RiemannianMeasure"; a List of properties gives an Association, All gives every property
- `InfraDensity` the marginal of any shape to the vertex set with respect to the counting measure: a vertex, a vertex list, a density, a walk graph; the one coercion in the API
- `FindInfraRepresentative` one member of a head as a vertex list, read off its graph or found by its search; a trailing count gives a List of them, "RandomChoice" a random member
- `InfraMemberQ` whether a vertex list is a member of a head on a graph

### Substrates and Drawing

- `InfraSubstrate` the named example substrates at size "Small", "Medium" or "Large": the tilings, meshes and closed surfaces the other pages draw on; InfraSubstrate[] lists the roster
- `InfraSubstrateHighlight` the summed densities of a list of objects drawn on a graph, the i-th object in the i-th palette color; a Directive styles the objects after it

### Multi-constructions

- Whereas the causal graph of Euclidean constructions is causally invariant, the branchial graphs in infrageometry are non-trivial due to multi-constructions.
- `InfraScene` a construction stated before any graph: the objects, and hypotheses that construct them with inert heads or assert relations between them
- `InfraStep` one construction encapsulated as a step of a scene; a second argument labels it
- `FindInfraScene` a scene solved on a graph, step by step; a List of bindings, one per admissible combination
- `InfraSceneInstance` one solved binding of a scene; with an object name, reads that object out of it
- `InfraSceneViewer` a step-by-step view of a scene on a graph

### Underlying graphs

- `SprayGraph` the breadth-first DAG rooted at c, whose source-to-sink paths are exactly the maximal shortest paths from c

### Not here

- `FindBallHull` the intersection of all balls containing a set of points; it lives on the Infra Topology guide
- not here: the quadric as an inert head and the layers of the convex hull; FindInfraQuadric stays on the Experimental guide
- not here: an invariant of four points, the inverse of every head (the values of its unknowns for a given vertex set), and the graph of a line or of an arc as an exported name; none is in an item yet
- not here: the interactive multi-construction stepper in the causal and branchial direction; it stays on the Experimental guide
