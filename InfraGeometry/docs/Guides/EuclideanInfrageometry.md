---
Template: Guide
Name: EuclideanInfrageometry
Title: Euclidean Infrageometry
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/EuclideanInfrageometry
Keywords: [Euclidean geometry, shell, synthetic geometry, graph, symbolic object, point, segment, ray, line, parallel, perpendicular, circle, arc, bisector, ellipse, ball, tube, cylinder, cone, polygon, hull, angle, shapes, gestalt, scene]
RelatedGuides: [RiemannianInfrageometry, InfraSubstrates, Experimental]
RelatedTutorials: [BreathlessLineTutorial, StraighteningAtScaleTutorial]
---

<!-- LLM-PROTECTED: Do not rewrite the Abstract or Functions sections unless explicitly asked. -->
<!-- The protected Functions prose was moved verbatim into the Abstract on 2026-10-13 (user's call):
     markup only, symbols linked, the dead names InfraGeometricScene and InfraGeometricSceneViewer
     replaced by InfraScene and InfraSceneViewer, bold dropped. build_docs.wls renders each
     paragraph as its own GuideAbstract cell. -->

## Abstract

*Reviewed by Pavel Hajek on 18 October 2026.*

Euclidean Infrageometry studies geometric objects on graphs using synthetic methods. An object may have several realizations on a given graph. We study these families, their mutual relations, and constructions formed by successive operations.

If space is represented by a large graph, we may view it as a web of paths. Infinitesimality is an idealized abstraction of our large-scale perception of this web. This leads to the idealization of space as a “continuous web” supporting objects such as the “breadthless line.” Infrageometry works directly with the discrete substrate at a chosen observer scale and aggregates instead of subdivides.

A geometric object may have several realizations on a graph. We treat these realizations together as a multi-object. Choosing realizations at successive construction steps generates a branching multiway system. For a fixed construction scheme, the prescribed dependency graph is the same across branches, although the geometric realizations may differ. We call this fixed dependency structure causal invariance.

We associate each multi-object with vertex and edge densities by counting occurrences across its realizations. For a finite nonempty family, dividing by the number of realizations gives expected occupation under uniform sampling. Further normalization gives probability measures on vertices or edges. We ask when suitable scaling and assumptions on the graph sequence make these measures converge weakly to measures supported on classical “thin” geometric objects.

We also seek an axiomatic system for Euclidean infrageometry and conditions defining Euclidean-like graph sequences. The aim is to recover the objects, relations and axioms of classical Euclidean geometry in an appropriate scaling limit.

We use inert objects such as <code>[InfraSegment]()[*p*, *q*]</code>, independent of a graph substrate. <code>[InfraMeasurement]()[*g*, *obj*, *property*]</code> then computes a property of an object on a concrete graph. Ambiguous objects also have named samplers; for example, <code>[RandomInfraSegment]()[*g*, InfraSegment[*p*, *q*], *k*]</code> gives up to *k* shortest paths from *p* to *q* as vertex lists.

Segments, rays, lines and arcs have compact representations as directed acyclic graphs such that the chains correspond to individual representatives. This allows densities to be computed efficiently without enumerating every path.

Inspired by [GeometricScene](https://reference.wolfram.com/language/ref/GeometricScene.html), [InfraScene]() lets us describe a construction through named objects and hypotheses. <code>[RandomInfraSceneInstance]()[*scene*, *graph*]</code> draws an admissible instance on a given substrate, and <code>[InfraSceneViewer]()[*scene*, *graph*]</code> displays the construction step by step in both the causal and branchial directions.

<!-- /LLM-PROTECTED -->

## Functions

### Substrates and drawing

- `InfraSubstrate` the named example graphs at size "Small", "Medium" or "Large"
- `InfraSubstrateHighlight` the densities of a list of objects drawn on a graph, one palette colour each

### Points

- `InfraPoint` a point drawn from a region
- `RandomInfraPoint` a random vertex of a region, or a tuple of vertices at prescribed mutual distances
- `InfraRegionNearest` the vertices of a region nearest to a query point, retaining all ties
- `RandomInfraRegionNearest` a random nearest point when the minimum is tied
- `GraphDistance` (WL) the path metric $d$ of the substrate

### Segments

- `InfraSegment` the segment from $p$ to $q$, all shortest paths between them at once
- `RandomInfraSegment` random shortest paths from $p$ to $q$ as vertex lists
- `InfraMidpoint` the central layer or two central layers of the oriented segment graph
- `RandomInfraMidpoint` a random vertex in the centre of the segment
- `InfraPerpendicularBisector` the unique equidistant locus $\{v : d(p,v) = d(q,v) < \infty\}$
- `InfraEquidistantSet` the unique multipoint equidistant locus
- `FindShortestPath` (WL) one shortest path from $p$ to $q$

- `InfraSegmentQ`, `UniqueInfraSegmentQ`, `FindInfraPolylineSubdivision`, `MetricInterval`

### Rays and Lines

- `InfraHalfLine` the ray from $p$ through $q$, the shortest paths no neighbour prolongs past their end
- `InfraInfiniteLine` the line through $p$ and $q$, the shortest paths no neighbour prolongs at either end
- `RandomInfraHalfLine`, `RandomInfraInfiniteLine` random rays and lines as vertex lists

- `InfraHalfLineQ`, `InfraInfiniteLineQ`

### Arcs and Circles

- `InfraArc` the arc about $c$ through an ordered list of points
- `InfraCircle` the circles about $c$ at radius $r$, the shortest cycles of the shell that separate $c$ from the outside
- `InfraCircleThrough` the shortest admissible circles through prescribed vertices in a fixed radial band
- `RandomInfraArc`, `RandomInfraCircle` random arcs and circles
- `RandomInfraCircleThrough` random members of a circle-through family

- `InfraCircleQ`

### Balls and Shells

- `InfraBall` the closed ball $\{v : d(c,v) \le r\}$ about a vertex or a vertex set
- `InfraShell` the shell $\{v : r_{min} \le d(c,v) \le r_{max}\}$, a level set of the distance
- `NeighborhoodGraph` (WL) the ball as an induced subgraph

- `InfraBallQ`, `InfraShellQ`

### Scenes

- `InfraScene` a construction stated before any graph: named objects and hypotheses
- `InfraSceneStep` one construction step of a scene
- `InfraSceneInstance` a binding of names to concrete objects of a scene
- `RandomInfraSceneInstance` an admissible instance of a scene on a graph
- `InfraScenePlot` a static figure from saved scene bindings, or explicit geometry at those bindings
- `InfraSceneViewer` a step-by-step view of a scene

- `GeometricScene` (WL), `RandomInstance` (WL)

### Shapes

- `InfraSphere` the inclusion-minimal connected subsets of a shell that separate $c$ from the outside
- `InfraPlane` the separating vertex sets between $p_1$ and $p_2$
- `InfraEllipse` a shortest separating cycle of $\{v : d(p_1,v) + d(p_2,v) = c\}$
- `InfraQuadric` the solid $\{v : \sum w_i d(p_i,v) \le c\}$
- `InfraTube` the union of the balls of radius $r_i$ about vertices $a_i$ of a core
- `InfraCylinder` the cylinder of radius $r$ about a walk, with flat ends
- `InfraCone` the cone of a given slope along a walk, apex at its first vertex
- `InfraSolidOfRevolution` the solid about a walk with a given radius profile
- `InfraRegularPolygon` the regular $n$-gon whose diagonals have prescribed lengths
- `InfraConvexHull` the convex hull of a set under shortest paths
- `InfraBallHull` the intersection of the closed balls containing a set

- `RandomInfraSphere`, `RandomInfraPlane`, `RandomInfraEllipse`, `RandomInfraRegularPolygon`
- `InfraPlaneQ`, `InfraEllipseQ`, `InfraRegularPolygonQ`

### Incidence and reflection

- `FindInfraReflection` the reflections of $x$ through $a$, the vertices $x'$ with $d(x,a) = d(a,x')$ on a shortest path through $a$
- `FindInfraCommonPoint` the points lying on every listed line
- `FindInfraCommonLine` the lines containing every listed vertex
- `FindClosestInfraPoint` the feet of a point on a line

- `InfraReachableQ`, `InfraIntersectQ`, `LineCount`, `UniversalLineQ`

### Parallels and perpendiculars

- `RandomInfraParallel` a random parallel to a line through $p$, at constant distance from it
- `FindInfraPerpendicular` the lines through a point perpendicular to a line
- `FindInfraBisectingHyperplane` the perpendicular bisector $\{v : d(p_1,v) = d(p_2,v)\}$, or a slab about it

- `InfraParallelQ`, `InfraPerpendicularQ`

### Graphs of Multiobjects

- `IntervalGraph` the directed acyclic graph whose source-to-sink paths are the shortest paths from $p$ to $q$
- `SprayGraph` the directed acyclic graph of all maximal shortest paths from $p$
- `RayGraph` the directed acyclic graph of maximal shortest paths from $p$ through $q$
- `BeamGraph` the directed acyclic graphs of the lines through $p$ and $q$
- `ArcGraph` the carrier graph of an arc about $c$
- `PathSubgraph` the union of paths between two vertices, with optional path-length bounds

- `Subgraph` (WL), `HighlightGraph` (WL)

### Properties and Measurements

- `InfraMeasurement` a property of an object on a graph: its graph, cardinality, length, densities or measures
- `InfraAngle` the arc-length measurement between $q_1$ and $q_2$ about $p$
- `InfraMemberQ` whether a vertex list is a member of an object on a graph
- `InfraIntersection` the intersection of two objects, with the product of their densities
- `InfraUnion` the union of two objects, with the sum of their densities

- `InfraGeometricAssertion`, `InfraGeometricTest`
