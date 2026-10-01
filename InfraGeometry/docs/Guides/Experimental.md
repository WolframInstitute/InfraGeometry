---
Template: Guide
Name: Experimental
Title: Experimental Functions
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/Experimental
Keywords: [experimental, index, kernel files, synthetic, Riemannian]
RelatedGuides: [EuclideanInfrageometry, RiemannianInfrageometry, InfraTopology, InfraAnalysis, InfraFiberBundles, InfraSubstrates]
---

## Abstract

Every exported symbol that no other guide of the site covers, one section per kernel file: the synthetic branch first, then the Riemannian branch, then the infrastructure. The symplectic branch has no code yet. Each entry is the symbol's usage message cut to one line. A linked name opens its existing reference page, which has not been revised for this site; a name in bold has no reference page.

## Functions

### Synthetic · InfraPoint.wl

- `InfraPoint` the scene-language token for the point search, FindInfraPoint minus the graph
- `FindInfraMidpoint` the density of the middle vertices of every geodesic from p1 to p2, one vertex at even distance, two at odd
- `FindInfraGoldenSection` the density at the golden-ratio index along every geodesic from p1 to p2
- `FindInfraReflection` the reflections x' of x through a
- `CompleteInfraEquilateralTriangle` the apexes equidistant from p1 and p2 at distance d(p1, p2) (Euclid I.1)
- `FindInfraCommonPoint` the points lying on every listed line
- `FindClosestInfraPoint` the vertices of a line at minimum graph distance from a point
- `SelectInfraPoint` draws a vertex from a supplied bundle under graph distance
- `InfraReachableQ` whether p1 and p2 have realisations in the same connected component
- `RandomInfraPoint` a uniformly random vertex, or one at distance d from p
- `InfraCenter` a vertex of least eccentricity

### Synthetic · InfraMeasurement.wl

- `Undetermined` the value of the measurement "Faithful" on a head whose graph is faithful only under a hypothesis this paclet does not certify
- `InfraSubgraph` the subgraph induced on the support of an object; obj -> t thickens the support by t steps

### Synthetic · InfraSegment.wl

- `FindInfraSegment` one geodesic from p to q as a vertex list; a trailing count gives a List of them
- `ExtendInfraSegment` the geodesics containing a segment, extended by at most kspec edges per side
- `InfraWalkQ` whether consecutive vertices of a walk are adjacent, revisits allowed
- `InfraSegmentQ` whether a walk is a geodesic
- `UniqueInfraSegmentQ` whether the u-v geodesic is unique

### Synthetic · InfraWalk.wl

- `InfraWalk` the literal walk through p1, ..., pk, inside InfraScene and InfraSubstrateHighlight
- `FindInfraWalk` grows the walks from p1 in the class cut by the Properties rules until a stopping condition or the budget stops them
- `WalkSingularities` the self-intersections, self-tangencies and cusps of a walk
- `InfraImmersedQ` whether a walk is immersed, a walk with no cusp
- `InfraGenericQ` whether a walk is a generic immersed curve
- `InfraWalkCrossingQ` whether the double visit of a walk at v is a transverse crossing at scale r
- `ExtendInfraWalk` continues a seed walk in the class cut by the Properties rules
- `ConcatenateInfraWalk` joins every compatible walk pair, the last vertex of one being the first of the other

### Synthetic · InfraLine.wl

- `FindInfraLine` one line through p and q as a vertex list, an inextensible geodesic through both; a trailing count gives a List of them
- `FindInfraParallel` one parallel to a line through p
- `FindInfraPerpendicular` the lines through a point perpendicular to a line
- `FindInfraCommonLine` the canonical lines containing every listed vertex
- `InfraLineQ` whether a walk is a line, a geodesic that no neighbour of either endpoint prolongs
- `InfraParallelQ` whether two lines stay at constant distance
- `InfraPerpendicularQ` whether two lines meet perpendicularly at every common vertex
- `LineCount` the number of distinct canonical maximal geodesics in a graph
- `FindLineHull` the smallest superset of S closed under the line operator
- `LineHullQ` whether S is closed under the line operator
- `UniversalLineQ` whether some pair spans a line filling a whole connected component (Chen-Chvatal)

### Synthetic · InfraLineStructure.wl

- `FindLineStructure` a consistent geodesic path system
- `InfraLineStructure` a consistent geodesic path system, stored as its maximal lines
- `ConsistentPathSystemQ` whether a geodesic path system is subpath-closed (Cizma-Linial consistent)

### Synthetic · InfraShell.wl

- `FindInfraOsculatingShell` the shells whose level set contains a k-vertex window of a path, one per osculating centre
- `FindInfraShellCenter` recovers the centre and radii of a shell
- `InfraShellQ` whether a vertex set is a metric shell { v : d(c, v) == r } for some centre c and radius r
- `SeparatesQ` whether deleting a vertex set disconnects u from v

### Synthetic · InfraEllipticShell.wl

- `InfraEllipticShell` names the elliptic-shell construction
- `FindInfraEllipticShell` the elliptic shell { v : d(p1, v) + d(p2, v) == c }
- `InfraEllipticShellQ` whether a vertex set is an elliptic shell for some pair of foci and some constant

### Synthetic · InfraQuadric.wl

- `FindInfraQuadric` the solid interior of the vertices whose distances to p1, ..., pk sum to at most c

### Synthetic · InfraBall.wl

- `FindInfraBall` the closed ball {v : d(c, v) <= r} as a sorted vertex list
- `InfraBallQ` whether a vertex set is a closed metric ball

### Synthetic · InfraCircle.wl

- `FindInfraCycle` the n shortest simple cycles of a graph
- `InfraCircleQ` whether a cycle is a cyclic edge chain whose vertex set is a metric shell

### Synthetic · InfraArc.wl

- `FindInfraArc` one arc around c through the points as a vertex list; a trailing count gives a List of them

### Synthetic · InfraPolygon.wl

- `InfraPolygon` the closed geodesic chain through the given corners, inside InfraScene
- `FindInfraPolygon` one polygon with corners p1, ..., pn
- `FindInfraRegularPolygon` one closed n-vertex sequence whose k-th diagonal distances all match prescribed values
- `InfraPolygonQ` whether a polygon is a closed cyclic chain of geodesic sides
- `InfraRegularPolygonQ` whether a cycle is regular with respect to a diagonal-distance tuple

### Synthetic · InfraTriangle.wl

- `InfraTriangle` the geodesic triangle on three corners, inside InfraScene, the n = 3 case of InfraPolygon
- `FindInfraTriangle` one triangle with corners a, b, c and a geodesic on each side
- `InfraTriangleQ` whether a polygon is a closed chain of exactly three geodesic sides

### Synthetic · InfraEllipse.wl

- `InfraEllipse` names the metric-ellipse construction
- `FindInfraEllipse` one shortest separating cycle in the level surface { v : d(p1, v) + d(p2, v) == c }
- `InfraEllipseQ` whether a cycle is a cyclic edge chain whose vertex set is an elliptic shell

### Synthetic · InfraPlane.wl

- `InfraPlane` the bisecting hyperplane of p1 and p2, inside InfraScene
- `FindInfraBisectingHyperplane` the perpendicular bisector { v : d(p1, v) == d(p2, v) }

### Synthetic · InfraRay.wl

- `FindInfraRay` one ray from p through q as a vertex list, a geodesic from p through q that no neighbour of its last vertex prolongs; a trailing count gives a List of them
- `InfraRayQ` whether a ray is a pointed half-line
- `PencilDirections` the pencil at O, every ray from O
- `PencilCardinality` the number of rays from O, counted on the ray pools without enumeration

### Synthetic · InfraPolyline.wl

- `InfraPolyline` the open geodesic chain through the given knots, inside InfraScene
- `FindInfraPolylineSubdivision` chunks a walk into the fewest geodesic legs whose knots are walk vertices
- `InfraPolylineQ` whether every leg is a geodesic and consecutive legs share an endpoint

### Synthetic · InfraRevolution.wl

- `InfraRevolution` the InfraScene constructor for a solid of revolution
- `FindInfraRevolution` the rotational vertex set around an axis with a given radius profile
- `FindInfraCylinder` the constant-radius solid of revolution around an axis, by default the r-neighbourhood of the axis
- `FindInfraCone` the cone of a given slope with apex at one end of an axis
- `InfraRevolutionQ` whether a vertex set is the solid of revolution around an axis with a given profile

### Synthetic · EuclideanSpace.wl

- `InfraScalarProduct` the base-point-relative product d(o, u) d(o, v) cos(theta), at curvature 0 the polar form of the metric
- `FindInfraLinearCombination` the vertex realisations of a linear combination of vertices, based at o

### Synthetic · InfraCurveGeometry.wl

- `TurningAngles` the exterior angles, Pi minus InfraAngle, at each interior vertex of a path
- `TotalCurvature` the discrete total curvature of a path, the sum of its turning angles
- `TotalAbsoluteCurvature` the sum of the absolute turning angles, the discrete Fenchel integral
- `TurningNumber` the total curvature of a cycle divided by 2 Pi

### Synthetic · AlexandrovGeometry.wl

- `ComparisonTriangle` the Euclidean triangle with side lengths a, b, c
- `InfraComparisonTriangle` the wrapper for comparison triangles of nonzero curvature
- `CATInequalityQ` whether the geodesic triangle on p, q, r satisfies the CAT(k) thinness inequality
- `InfraCurvature` the local Alexandrov upper curvature bound at v

### Synthetic · WalkSpace.wl

- `SelectInfraWalk` draws a walk from a bundle
- `EmbeddingClosest` keeps the bundle elements drawn closest to a Euclidean reference under GraphEmbedding
- `FindEmbeddingClosestPath` snaps an embedded curve to a walk graph, joining the nearest vertices by geodesics
- `GeodesicExtensionGraph` the DAG of geodesic extensions of the segment from p1 to p2 beyond p2
- `PathSubgraph` the union of all shortest u-v paths
- `InfraDeformationSize` the number of edges of a reference walk that a walk replaces

### Synthetic · Homotopy.wl

- `FindInfraHomotopy` one chain of elementary moves from a to b, as the walk graphs it passes through
- `FindInfraHomotopyRepresentative` the length-shortest walks in the homotopy class of a walk
- `FindInfraHomotopyRepresentativeHomotopy` the chain of elementary moves reducing a walk to a shortest representative
- `HomotopicQ` whether a and b lie in the same homotopy class
- `NullHomotopicQ` whether a closed walk is null-homotopic
- `HomotopyMoveType` classifies an elementary move as "Contract", "Extend" or "Lateral"
- `HomotopyMoveTypes` applies HomotopyMoveType to each consecutive pair of a homotopy chain

### Synthetic · MetricAlgebra.wl

- `MetricInterval` the vertices on some geodesic from u to v, { w : d(u, w) + d(w, v) == d(u, v) }
- `GeodesicMultiplicity` the number of distinct geodesics from u to v
- `GeodesicMultiplicityMatrix` the distance matrix together with the matrix of geodesic counts
- `MedianVertices` the vertices minimising the sum of distances to a vertex list
- `FindSegmentHull` the smallest superset of S closed under MetricInterval, as a multiset
- `SegmentHullQ` whether S is geodesically convex

### Synthetic · InfraSet.wl

- `FindInfraEquidistantSet` the vertices equidistant from p1, ..., pn, as a multiset
- `FindAdvancingInfraFront` the foliation by a bouncing wavefront, as a list of sorted vertex lists
- `InfraBoundary` the boundary of a vertex set, multiset or infra-object, as a multiset
- `InfraInterior` the interior of a vertex set, multiset or infra-object, as a multiset
- `InfraVolume` the volume of a vertex set, multiset or infra-object

### Synthetic · TarskiGeometry.wl

- `BetweennessQ` tests Tarski betweenness B(u, w, v)
- `EquidistanceQ` tests Tarski equidistance d(a, b) == d(c, d)
- `TarskiStructure` a memoized association of the Tarski primitives
- `TarskiBetweennessTensor` the sparse rank-3 tensor whose nonzero entries are the betweenness triples
- `TarskiEquidistanceClasses` the partition of unordered vertex pairs by distance value
- `TarskiCongruenceReflexivityQ` tests Tarski axiom A1, ab == ba
- `TarskiCongruenceTransitivityQ` tests Tarski axiom A2, transitivity of congruence
- `TarskiCongruenceIdentityQ` tests Tarski axiom A3, ab == cc implies a == b
- `TarskiSegmentConstructionQ` tests Tarski axiom A4, segment construction
- `TarskiFiveSegmentsQ` tests Tarski axiom A5, five segments
- `TarskiBetweennessIdentityQ` tests Tarski axiom A6, B(a, b, a) implies a == b
- `TarskiInnerPaschQ` tests Tarski axiom A7, inner Pasch
- `TarskiLowerDimensionQ` tests Tarski axiom A8, the existence of three non-collinear points
- `TarskiUpperDimensionQ` tests Tarski axiom A9, three points equidistant from two distinct points are collinear
- `TarskiEuclidAxiomQ` tests Tarski axiom A10, the parallel-axiom variant
- `TarskiContinuityQ` tests Tarski axiom A11, Dedekind continuity
- `TarskiAxiomQ` the per-axiom results of all eleven Tarski axiom predicates
- `FindTarskiCounterexample` vertex tuples witnessing the failure of a Tarski axiom predicate

### Synthetic · ProjectiveGeometry.wl

- `SameDirectionQ` whether some ray from O through v contains w
- `CollinearQ` whether all listed vertices lie on a common line
- `ConcurrentQ` whether all listed lines share a common vertex
- `UniqueCollinearQ` whether the listed vertices lie on a unique common line
- `UniqueConcurrentQ` whether the listed lines share exactly one common vertex
- `WhiteheadW1Q` tests Whitehead axiom W1
- `WhiteheadW2Q` tests Whitehead axiom W2
- `WhiteheadW3Q` tests Whitehead axiom W3, the intersection property
- `ProjectivePlaneGraphQ` whether a graph is a synthetic projective plane

### Synthetic · InfraEquality.wl

- `InfraEqualQ` tests equality of two infra-objects through their diffusion diagrams

### Synthetic · InfraScene.wl

- `InfraSceneInstance` wraps a solved binding association; with a symbol, reads one object out of it
- `InfraIntersection` the vertex-set intersection of shapes on a graph
- `InfraUnion` the vertex-set union of shapes on a graph, as a sorted list
- `InfraDistance` the graph distance between two infra-objects, aggregated over their vertex sets
- `InfraPlaneQ` whether h lies in the bisector slab of p1 and p2 and separates them
- `InfraIntersectQ` asserts inside an InfraScene that two sets intersect

### Synthetic · InfraSceneVisualization.wl

- `$InfraPointColor` the named color of points
- `$InfraSegmentColor` the named color of segments
- `$InfraShellColor` the named color of shells
- `$InfraPlaneColor` the named color of planes
- `$InfraCircleColor` the named color of circles and arcs
- `$InfraRayColor` the named color of rays
- `$InfraWalkColor` the named color of walks
- `$InfraLineColor` the named color of lines

### Synthetic · InfraSceneInteractive.wl

- `PointViewer` an interactive viewer for selecting points
- `SegmentViewer` an interactive viewer for exploring geodesic segments
- `ShellViewer` an interactive viewer for exploring metric shells
- `CircleViewer` an interactive viewer for exploring separating cycles

### Riemannian · VolumeGrowth.wl

- **CylinderVolumes** — the matrix of cylinder volumes between every source-target pair
- **IntervalVolumes** — the volume profile of the interval between p and q, over the slack r
- **GeodesicOccupation** — the per-vertex geodesic occupation over a geodesic DAG
- **GeodesicEdgeOccupation** — the per-edge geodesic occupation over a geodesic DAG

### Riemannian · Boundary.wl

- **GraphBoundary** — the inner vertex boundary of S in g, the vertices where an edge of g escapes S
- **GraphInterior** — the interior of S in g, S minus its GraphBoundary
- **GraphEccentricities** — the eccentricity of every vertex, in VertexList order
- **RelativeEccentricity** — the eccentricity of each vertex rescaled to run from 0 at the radius to 1 at the diameter

### Riemannian · Coordinatization.wl

- **RadarCoordinates** — the distance vector from a vertex to each vertex of a basis
- **ResolvingSetQ** — whether a basis is a resolving set
- **FindResolvingSet** — up to n resolving sets, or metric bases, of g by ascending size
- **MetricDimension** — the metric dimension of g
- **ResistanceCoordinates** — the spectral embedding whose squared distances are the effective resistances
- `OrthogonalCoordinates` the integer displacement of v along each axis through the centre c
- `FindInfraOrthogonalFrame` frames of mutually perpendicular geodesic axes through the centre c
- `FindInfraSpanningAxes` n mutually well-separated longest geodesics across a graph, with no fixed centre

### Riemannian · OllivierCurvature.wl

- **OllivierRicciCurvature** — the Ollivier-Ricci curvature of every edge, with the uniform measure on each neighbourhood
- **EffectiveResistance** — the Klein-Randic resistance distance R(u, v), from the pseudoinverse of the graph Laplacian
- **ResistanceQ** — whether a symmetric matrix with zero diagonal is realisable as a resistance distance matrix

### Infrastructure · GraphEnumeration.wl

- `EnumerateGraphs` the connected n-vertex graphs from GraphData satisfying a predicate
