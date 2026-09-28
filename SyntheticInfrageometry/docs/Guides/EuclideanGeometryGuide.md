---
Template: Guide
Name: EuclideanGeometryGuide
Title: Euclidean Infrageometry
Context: WolframInstitute`SyntheticInfrageometry`
Paclet: WolframInstitute/SyntheticInfrageometry
URI: WolframInstitute/SyntheticInfrageometry/guide/EuclideanGeometryGuide
Keywords: [Euclidean geometry, graph, geodesic, inert head, point, segment, ray, line, arc, circle, scene, substrate]
RelatedGuides: [Experimental]
---

## Abstract

A Euclidean object is an inert head: InfraSegment[p, q], InfraRay[p, q], InfraLine[p, q], InfraCircle[c, p] and InfraArc[c, {p, q}] hold their points and compute nothing. Its members and its properties are read off a graph: a graph in front of the head evaluates it, InfraVertexList gives a member and InfraMeasurement gives its graph, cardinality, length and densities. A point is a vertex of the substrate and has no head. Each object is a family, every geodesic from p to q or every ray from p through q, and its graph is a digraph whose chains, or directed cycles, are exactly the members, each once; so what the plane answers with one point, the graph answers with a family and its occupation density, and an object the graph cannot carry, such as a circle of a single radius on a bipartite grid, is empty. A Find function searches the same family without the graph and returns what InfraVertexList returns. A scene states a construction as inert heads and hypotheses and is solved on a graph; InfraHighlightGraph draws the summed densities of a list of objects.

## Functions

### Surface graphs

- `InfraSubstrate` the named example substrates at size "Small", "Medium" or "Large": the tilings, meshes and closed surfaces the other pages draw on; InfraSubstrate[] lists the roster
- `TessellationGraph` the regular map {p, q} or the uniform map of a vertex configuration as a graph, sized to a flat torus or to a hyperbolic quotient
- `TorusTessellation` the m × n flat torus carrying the square, triangular or hexagonal tessellation

### Points

- `InfraPoint` the scene token for a point; a point is a vertex of the substrate, carrying its label verbatim
- `FindInfraPoint` a vertex drawn from the candidate pool, narrowed by "From" and "Distance"; a trailing count gives a List of vertices
- `FindInfraMidpoint` the density of the middle vertices of every geodesic from p1 to p2, one vertex at even distance and two at odd
- `RandomInfraPoint` a uniformly random vertex, or one at a given distance from a point

### Segments

- `InfraSegment` the inert segment from p to q, every geodesic between them at once; with more points, the polyline of their consecutive segments
- `FindInfraSegment` one geodesic from p to q as a vertex list; a trailing count gives a List of them
- `InfraSegmentQ` whether a vertex list is a geodesic

### Rays and lines

- `InfraRay` the inert ray from p through q: the geodesics from p through q that no neighbour of their last vertex prolongs; InfraRay[p, p] is the pencil at p
- `FindInfraRay` one ray from p through q as a vertex list; a trailing count gives a List of them
- `InfraLine` the inert line through p and q: the geodesics through both that no neighbour of either endpoint prolongs
- `FindInfraLine` one line through p and q as a vertex list, or the prolongations of a given geodesic; a trailing count gives a List

### Arcs and circles

- `InfraCircle` the inert circle around c through p: the shortest cycles through p that separate c from the outside of its band; "Radius" -> r or {r, s} in place of p takes the whole band
- `FindInfraCircle` one circle around c through p as a cyclic vertex list; a trailing count gives a List of them
- `InfraArc` the inert arc around c from p1 to pk through the intermediate points: the geodesics of the band graph of the circle through p1
- `FindInfraArc` one arc around c through the points as a vertex list; a trailing count gives a List of them

### Properties

- `InfraMeasurement` a property of a head on a graph: "Graph", "Cardinality", "Length", "VertexDensity", "EdgeDensity", "Subgraph", "Faithful" and the volumes; a List of properties gives an Association, All gives every property
- `InfraVertexList` one member of a head as a vertex list; a trailing count gives a List of them, "RandomChoice" a uniformly random member
- `InfraMemberQ` whether a vertex list is a member of a head
- `InfraSubgraph` the subgraph induced on the support of a head; obj -> t thickens the support by t steps
- `InfraDensity` the marginal of any shape to the vertex set with respect to the counting measure: a vertex, a vertex list, a density, a walk graph; the one coercion in the API

### Scenes

- `InfraScene` a construction stated before any graph: the objects, and hypotheses that construct them with inert heads or assert relations between them
- `FindInfraScene` a scene solved on a graph, step by step; a List of InfraSceneInstance bindings, one per admissible combination
- `InfraSceneInstance` the solved bindings of one instance; a second argument reads one object out of it

### Drawing

- `InfraHighlightGraph` draws the summed densities of a list of objects on a graph, the i-th object in the i-th palette color; a Directive styles the objects after it
