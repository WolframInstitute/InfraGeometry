---
Template: Guide
Name: EuclideanInfrageometry
Title: Euclidean Infrageometry
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/EuclideanInfrageometry
Keywords: [Euclidean geometry, shell, synthetic geometry, graph, symbolic object, point, segment, ray, line, parallel, perpendicular, circle, arc, bisector, ellipse, ball, tube, cylinder, cone, polygon, hull, angle, scalar product, scene]
RelatedGuides: [RiemannianInfrageometry, InfraSubstrates, Experimental]
RelatedTutorials: [BreadthlessTriangleTutorial, StraighteningAtScaleTutorial, NamedConstructionSamplers, SyntheticGeometryMigration]
---

<!-- LLM-PROTECTED: Do not rewrite the Abstract or Functions sections unless explicitly asked. -->
<!-- The protected Functions prose was moved verbatim into the Abstract on 2026-10-13 (user's call):
     markup only, symbols linked, the dead names InfraGeometricScene and InfraGeometricSceneViewer
     replaced by InfraScene and InfraSceneViewer, bold dropped. build_docs.wls renders each
     paragraph as its own GuideAbstract cell. -->

## Abstract

Euclidean Infrageometry studies natural geometric objects on arbitrary graph substrates using synthetic methods. It enumerates these objects, studies their mutual relations, applies operations to them, and performs iterative constructions. If space is represented by a large graph, which we may view as a web of paths, human geometry can be viewed as an idealized theory based on our large-scale perception of infinitesimality. This leads to the idealization of space as a "continuous web" supporting idealized objects such as the "breadthless line." In contrast, Infrageometry works directly with the discrete substrate at an observer's scale and aggregates instead of subdivides. Consequently, objects at the least scale may not be unique, leading to multi-objects, so that constructions generate branching multiway systems. Although concrete representatives may differ across branches, the system is "causally invariant" in the sense that the dependency graph of construction steps is the same in every branch. We associate each multi-object with vertex and edge densities that count the representatives containing each vertex or edge, obtaining a measure by dividing by the total number of representatives. We expect that, under a suitable notion of Gromov-Hausdorff convergence, these measures converge weakly to Dirac measures supported on classical "thin" geometric objects. We also expect that a suitable axiomatization of Euclidean infrageometry can be formulated and the notion of  Euclidean-like graphs can be defined so that subdivision and convergence converges to the continuous axiomatic Euclidean geometry.

We use inert objects such as <code>[InfraSegment]()[*p*, *q*]</code>, independent of a graph substrate. <code>[InfraMeasurement]()[*g*, *obj*, *property*]</code> then computes a property of an object on a concrete graph. Each object also has a named sampler; for example, <code>[RandomInfraSegment]()[*g*, InfraSegment[*p*, *q*], *k*]</code> gives up to *k* shortest paths from *p* to *q* as vertex lists.

Segments, rays, lines and arcs have compact representations as directed acyclic graphs such that the chains correspond to individual representatives. This allows densities to be computed efficiently without enumerating every path.

Inspired by [GeometricScene](https://reference.wolfram.com/language/ref/GeometricScene.html), [InfraScene]() lets us describe a construction through named objects and hypotheses. <code>[RandomInfraInstance]()[*scene*, *graph*]</code> draws an admissible instance on a given substrate, and <code>[InfraSceneViewer]()[*scene*, *graph*]</code> displays the construction step by step in both the causal and branchial directions.

<!-- /LLM-PROTECTED -->

## Functions

### Points

- `InfraPoint` a point, a vertex drawn from a region inside a scene
- `RandomInfraPoint` a random vertex of a region, or a tuple of vertices at prescribed mutual distances
- `GraphDistance` (WL) the path metric $d$ of the substrate

### Segments

- `InfraSegment` the segment from $p$ to $q$, all shortest paths between them at once
- `RandomInfraSegment` random shortest paths from $p$ to $q$ as vertex lists
- `FindShortestPath` (WL) one shortest path from $p$ to $q$

- `InfraSegmentQ`, `UniqueInfraSegmentQ`, `FindInfraPolylineSubdivision`, `MetricInterval`

### Rays and lines

- `InfraHalfLine` the ray from $p$ through $q$, the shortest paths no neighbour prolongs past their end
- `InfraInfiniteLine` the line through $p$ and $q$, the shortest paths no neighbour prolongs at either end
- `RandomInfraHalfLine`, `RandomInfraInfiniteLine` random rays and lines as vertex lists

- `InfraHalfLineQ`, `InfraInfiniteLineQ`

### Circles and arcs

- `InfraCircle` the circles about $c$ at radius $r$, the shortest cycles of the shell that separate $c$ from the outside
- `InfraArc` the arc about $c$ through an ordered list of points
- `RandomInfraCircle`, `RandomInfraArc` random circles and arcs

- `InfraCircleQ`

### Balls and shells

- `InfraBall` the closed ball $\{v : d(c, v) \le r\}$ about a vertex or a vertex set
- `InfraShell` the shell $\{v : r_{min} \le d(c, v) \le r_{max}\}$, a level set of the distance
- `FindInfraShell` the shell or band as a sorted vertex list
- `NeighborhoodGraph` (WL) the ball as an induced subgraph

- `RandomInfraBall`, `RandomInfraShell`, `InfraBallQ`, `InfraShellQ`

### Exact point families

- `InfraMidpoint` the vertices at half the distance from both endpoints; empty at odd distance
- `InfraPerpendicularBisector` the equidistant locus $\{v : d(p, v) = d(q, v)\}$
- `InfraRegionNearest` the nearest vertices of a region, ties retained
- `RandomInfraMidpoint`, `RandomInfraPerpendicularBisector`, `RandomInfraRegionNearest` random members of these families

### Reading a construction on a graph

- `InfraMeasurement` a property of an object on a graph: its graph, cardinality, length, densities or measures
- `InfraDensity` the vertex multiplicities of a vertex, vertex list, density or walk graph
- `InfraMemberQ` whether a vertex list is a member of an object on a graph
- `InfraIntersection` the intersection of two objects, with the product of their densities
- `InfraUnion` the union of two objects, with the sum of their densities
- `Undetermined` the value of "Faithful" when the hypotheses behind a carrier are not certified

- `RandomInfraIntersection`, `RandomInfraUnion`, `InfraGeometricAssertion`, `InfraGeometricTest`

### Graphs of a construction

- `IntervalGraph` the directed acyclic graph whose source-to-sink paths are the shortest paths from $p$ to $q$
- `SprayGraph` the directed acyclic graph of all maximal shortest paths from $p$
- `RayGraph` the directed acyclic graph of maximal shortest paths from $p$ through $q$
- `BeamGraph` the directed acyclic graphs of the lines through $p$ and $q$
- `ArcGraph` the carrier graph of an arc about $c$
- `PathSubgraph` the union of all shortest paths from $u$ to $v$ as a subgraph
- `InfraSubgraph` the subgraph induced on the support of an object, optionally thickened

- `Subgraph` (WL), `HighlightGraph` (WL)

### Substrates and drawing

- `InfraSubstrate` the named example graphs at size "Small", "Medium" or "Large"
- `InfraSubstrateHighlight` the densities of a list of objects drawn on a graph, one palette colour each

### Scenes

- `InfraScene` a construction stated before any graph: named objects and hypotheses
- `InfraStep` one construction step of a scene
- `RandomInfraInstance` an admissible instance of a scene on a graph
- `InfraSceneInstance` one solved binding of a scene
- `InfraSceneMultiway` the finite multiway system of construction states
- `InfraBranchialGraph` the branchial graph of construction states at one depth
- `InfraScenePlot` a static figure from saved scene bindings, or explicit geometry at those bindings
- `InfraSceneViewer` a step-by-step view of a scene

- `InfraIntersectQ`, `InfraPlaneQ`, `GeometricScene` (WL), `RandomInstance` (WL)

### Experimental: incidence and reflection

- `FindInfraReflection` the reflections of $x$ through $a$, the vertices $x'$ with $d(x, a) = d(a, x')$ on a shortest path through $a$
- `FindInfraCommonPoint` the points lying on every listed line
- `FindInfraCommonLine` the lines containing every listed vertex
- `FindClosestInfraPoint` the feet of a point on a line
- `FindInfraEquidistantSet` the vertices equidistant from $p_1, \dots, p_n$

- `InfraReachableQ`, `LineCount`, `UniversalLineQ`

### Experimental: parallels and perpendiculars

- `RandomInfraParallel` a random parallel to a line through $p$, at constant distance from it
- `FindInfraPerpendicular` the lines through a point perpendicular to a line
- `FindInfraBisectingHyperplane` the perpendicular bisector $\{v : d(p_1, v) = d(p_2, v)\}$, or a slab about it

- `InfraParallelQ`, `InfraPerpendicularQ`

### Experimental: spheres, planes and conics

- `InfraSphere` the inclusion-minimal connected subsets of a shell that separate $c$ from the outside
- `InfraPlane` the separating vertex sets between $p_1$ and $p_2$
- `InfraEllipse` the ellipse with foci $p_1, p_2$, a shortest separating cycle of $\{v : d(p_1, v) + d(p_2, v) = c\}$
- `InfraQuadric` the solid $\{v : \sum w_i d(p_i, v) \le c\}$; balls, ellipses and hyperbola branches as special cases

- `RandomInfraSphere`, `RandomInfraPlane`, `RandomInfraEllipse`, `RandomInfraQuadric`, `InfraEllipseQ`

### Experimental: solids

- `InfraTube` the tube along a core, the union of the balls of radius $r_i$ about its vertices $a_i$
- `InfraCylinder` the cylinder of radius $r$ about a walk, with flat ends
- `InfraCone` the cone of a given slope along a walk, apex at its first vertex
- `InfraSolidOfRevolution` the solid about a walk with a given radius profile

- `RandomInfraTube`, `RandomInfraCylinder`, `RandomInfraCone`, `RandomInfraSolidOfRevolution`

### Experimental: polygons and hulls

- `InfraRegularPolygon` the regular $n$-gon whose diagonals have prescribed lengths
- `InfraConvexHull` the convex hull of a set under shortest paths
- `InfraBallHull` the intersection of the closed balls containing a set

- `RandomInfraRegularPolygon`, `RandomInfraConvexHull`, `RandomInfraBallHull`, `InfraRegularPolygonQ`

### Experimental: angles and linear structure

- `InfraAngle` the angle at $p$ between $q_1$ and $q_2$, by arclength or by Alexandrov comparison
- `InfraScalarProduct` the product $d(o, u) d(o, v) \cos \theta$ based at $o$
- `FindInfraLinearCombination` the vertices realising a linear combination of vertices based at $o$

### Experimental: orthogonal axes

- `FindInfraOrthogonalAxes` a maximal set of mutually perpendicular lines through a centre
- `FindInfraOrthogonalRays` a maximal set of mutually perpendicular rays from a centre
- `FindInfraSpanningAxes` $n$ well-separated longest shortest paths across a graph
- `OrthogonalCoordinates` the signed position of the foot of each vertex on each axis

### Experimental: sets

- `InfraDistance` the distance between two objects
- `InfraBoundary` the boundary of a vertex set, density or object
- `InfraInterior` the interior of a vertex set, density or object
- `InfraEqualQ` whether two objects are equal, as sets, multisets, by overlap or diffusely

### Experimental: viewers

- `PointViewer`, `SegmentViewer`, `ShellViewer`, `CircleViewer` interactive viewers for points, segments, shells and circles
