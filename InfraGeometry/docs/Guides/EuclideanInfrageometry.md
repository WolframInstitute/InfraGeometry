---
Template: Guide
Name: EuclideanInfrageometry
Title: Euclidean Infrageometry
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/EuclideanInfrageometry
Keywords: [Euclidean geometry, graph, inert head, synthetic object, segment, ray, line, arc, circle, ball, hull, angle, measurement, substrate, scene, multi-construction]
RelatedGuides: [RiemannianInfrageometry, Experimental]
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
- `InfraArc` the inert arc around c from p1 to pk through the intermediate points: the shortest paths in the band graph of the circle through p1
- `InfraCircle` the inert circle around c through p: the shortest cycles through p that separate c from the outside of its band; "Radius" -> r or {r, s} in place of p takes the whole band
- waits: InfraEquidistantSet, the points at the same distance from the given points, {v : d(p1, v) == ... == d(pn, v)}
- waits: InfraMidpoint, the center of the interval graph of p and q
- waits: InfraQuadric, its name and what it should be; today FindInfraQuadric gives the solid interior {v : d(p1, v) + ... + d(pk, v) <= c}
- waits: InfraBallHull, the intersection of all balls of radius r that contain a set of points
- waits: InfraConvexHull, the k-th layer of a filtration: layer 0 is the set, each next layer the union of all shortest paths between points of the one before
- waits: InfraSphere, the separating connected subsets of the shell of radius r about a centre
- `InfraBall` the closed ball {v : d(c, v) <= r} of radius r about c; today a scene token only
- waits: InfraTube, the tube of radius s about a core
- waits: InfraCone, the cone of a given slope with apex at one end of an axis
- `InfraAngle` the angle at p between q1 and q2 in radians, Method "Arclength" or "Alexandrov", the comparison angle of the three distances; a method from the shortest paths waits
- waits: InfraCrossection, an invariant of four points, as the distance is of two points and the angle of three

### Find Functions

- `FindInfraPoint` a vertex drawn from the candidate pool, narrowed by "From" and "Distance"; a trailing count gives a List of vertices
- `FindInfraCircle` one circle around c through p as a cyclic vertex list; a trailing count gives a List of them

### Measurements

- `InfraMeasurement` a property of a head on a graph: "Graph", "Cardinality", "Length", "VertexDensity", "EdgeDensity", "Subgraph", "Faithful" and the volumes; a List of properties gives an Association, All gives every property
- `InfraDensity` the marginal of any shape to the vertex set with respect to the counting measure: a vertex, a vertex list, a density, a walk graph; the one coercion in the API
- `InfraVertexList` one member of a head as a vertex list; a trailing count gives a List of them, "RandomChoice" a uniformly random member
- `InfraMemberQ` whether a vertex list is a member of a head on a graph; the form whose head has unknowns, true when some parameters make the vertex set its evaluation, waits
- waits: FindInfraParameters, the inverse of every head: the values of its unknowns for which a vertex set is its evaluation, one parameter set as an Association, a trailing count a List of them, a condition list fixing some

### Substrates and Drawing

- `InfraSubstrate` the named example substrates at size "Small", "Medium" or "Large": the tilings, meshes and closed surfaces the other pages draw on; InfraSubstrate[] lists the roster
- `InfraSubstrateHighlight` the summed densities of a list of objects drawn on a graph, the i-th object in the i-th palette color; a Directive styles the objects after it

### Multi-constructions

- Whereas the causal graph of Euclidean constructions is causally invariant, the branchial graphs in infrageometry are non-trivial due to multi-constructions.
- `InfraScene` a construction stated before any graph: the objects, and hypotheses that construct them with inert heads or assert relations between them
- `InfraStep` one construction encapsulated as a step of a scene; a second argument labels it
- `FindInfraScene` a scene solved on a graph, step by step; a List of InfraSceneInstance bindings, one per admissible combination
- `InfraSceneViewer` a step-by-step view of a scene on a graph; an interactive multi-construction stepper in the causal and branchial direction waits

### Underlying graphs

- `SegmentGraph` the interval I(p, q) as a directed acyclic graph whose directed p-q paths are exactly the shortest paths from p to q: the graph of InfraSegment[p, q]
- `SprayGraph` the breadth-first DAG rooted at c, whose source-to-sink paths are exactly the maximal shortest paths from c
- waits: ArcGraph, the band interval DAG of an arc, whose chains are its members; internal today
- waits: BeamGraph, the graph of a line: the List of its atoms, whose chains are the lines
