---
Template: Guide
Name: Experimental
Title: Experimental Functions
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/Experimental
Keywords: [experimental, index, kernel files, differential forms, cochains]
RelatedGuides: [EuclideanInfrageometry, RiemannianInfrageometry, InfraTopology, InfraAnalysis, InfraFiberBundles, InfraSubstrates]
---

## Abstract

Every exported symbol that no other guide of the site covers, one section per kernel file, titled by the kernel folder and the file. The folders are the category guides, and the Experimental folder holds the research files. The symplectic branch has no code yet. Each entry is the symbol's usage message cut to one line. A linked name opens its existing reference page, which has not been revised for this site; a name in bold has no reference page.

## Functions

### EuclideanInfrageometry · InfraPoint.wl

- `InfraPoint` the scene-language token for the point search, FindInfraPoint minus the graph
- `FindInfraGoldenSection` the density at the golden-ratio index along every geodesic from p1 to p2
- `FindInfraReflection` the reflections x' of x through a
- `FindInfraCommonPoint` the points lying on every listed line
- `FindClosestInfraPoint` the vertices of a line at minimum graph distance from a point
- `SelectInfraPoint` draws a vertex from a supplied bundle under graph distance
- `InfraReachableQ` whether p1 and p2 have realisations in the same connected component
- `RandomInfraPoint` a uniformly random vertex, or one at distance d from p
- `InfraCenter` a vertex of least eccentricity

### EuclideanInfrageometry · InfraMeasurement.wl

- `Undetermined` the value of the measurement "Faithful" on a head whose graph is faithful only under a hypothesis this paclet does not certify
- `InfraSubgraph` the subgraph induced on the support of an object; obj -> t thickens the support by t steps

### EuclideanInfrageometry · InfraSegment.wl

- `InfraWalkQ` whether consecutive vertices of a walk are adjacent, revisits allowed
- `InfraSegmentQ` whether a walk is a geodesic
- `UniqueInfraSegmentQ` whether the u-v geodesic is unique

### RiemannianInfrageometry · InfraWalk.wl

- `InfraWalk` the literal walk through p1, ..., pk, inside InfraScene and InfraSubstrateHighlight
- `FindInfraWalk` grows a germ, a vertex or a walk, into the walks of the class cut by the Properties rules until a stopping condition or the budget stops them
- `WalkSingularities` the self-intersections, self-tangencies and cusps of a walk
- `InfraImmersedQ` whether a walk is immersed, a walk with no cusp
- `InfraGenericQ` whether a walk is a generic immersed curve
- `InfraWalkCrossingQ` whether the double visit of a walk at v is a transverse crossing at scale r
- `ConcatenateInfraWalk` joins every compatible walk pair, the last vertex of one being the first of the other

### EuclideanInfrageometry · InfraLine.wl

- `FindInfraParallel` one parallel to a line through p
- `FindInfraPerpendicular` the lines through a point perpendicular to a line
- `FindInfraCommonLine` the canonical lines containing every listed vertex
- `InfraLineQ` whether a walk is a line, a geodesic that no neighbour of either endpoint prolongs
- `InfraParallelQ` whether two lines stay at constant distance
- `InfraPerpendicularQ` whether two lines meet perpendicularly at every common vertex
- `LineCount` the number of distinct canonical maximal geodesics in a graph
- `UniversalLineQ` whether some pair spans a line filling a whole connected component (Chen-Chvatal)

### RiemannianInfrageometry · InfraShell.wl

- `FindInfraOsculatingShell` the shells whose level set contains a k-vertex window of a path, one per osculating centre
- `FindInfraShellCenter` recovers the centre and radii of a shell
- `InfraShellQ` whether a vertex set is a metric shell { v : d(c, v) == r } for some centre c and radius r

### EuclideanInfrageometry · InfraBall.wl

- `InfraBallQ` whether a vertex set is a closed metric ball

### EuclideanInfrageometry · InfraCircle.wl

- `InfraCircleQ` whether a cycle is a cyclic edge chain whose vertex set is a metric shell

### Experimental · InfraPolygon.wl

- `InfraPolygon` the inert family of regular n-gons whose k-th diagonals satisfy prescribed distances
- `FindInfraRegularPolygon` one closed n-vertex sequence whose k-th diagonal distances all match prescribed values; the polygon through given corners is the closed polyline InfraSegment[p1, ..., pn, p1]
- `InfraRegularPolygonQ` whether a cycle is regular with respect to a diagonal-distance tuple

### Experimental · InfraEllipse.wl

- `InfraEllipse` names the metric-ellipse construction
- `FindInfraEllipse` one shortest separating cycle in the level surface { v : d(p1, v) + d(p2, v) == c }
- `InfraEllipseQ` whether a cycle is a cyclic edge chain whose vertex set is an elliptic shell InfraQuadric[{p1, p2}, {c, c}]

### Experimental · InfraPlane.wl

- `InfraPlane` the bisecting hyperplane of p1 and p2, inside InfraScene
- `FindInfraBisectingHyperplane` the perpendicular bisector { v : d(p1, v) == d(p2, v) }

### EuclideanInfrageometry · InfraRay.wl

- `InfraRayQ` whether a ray is a pointed half-line

### Experimental · InfraPolyline.wl

- `FindInfraPolylineSubdivision` chunks a walk into the fewest geodesic legs whose knots are walk vertices; the knots are the corners of the polyline InfraSegment[p1, ..., pk]

### EuclideanInfrageometry · EuclideanSpace.wl

- `InfraScalarProduct` the base-point-relative product d(o, u) d(o, v) cos(theta), at curvature 0 the polar form of the metric
- `FindInfraLinearCombination` the vertex realisations of a linear combination of vertices, based at o

### EuclideanInfrageometry · WalkSpace.wl

- `SelectInfraWalk` draws a walk from a bundle
- `EmbeddingClosest` keeps the bundle elements drawn closest to a Euclidean reference under GraphEmbedding
- `FindEmbeddingClosestPath` snaps an embedded curve to a walk graph, joining the nearest vertices by geodesics
- `PathSubgraph` the union of all shortest u-v paths
- `InfraDeformationSize` the number of edges of a reference walk that a walk replaces

### Experimental · Homotopy.wl

- `FindInfraHomotopy` one chain of elementary moves from a to b, as the walk graphs it passes through
- `FindInfraHomotopyRepresentative` the length-shortest walks in the homotopy class of a walk
- `FindInfraHomotopyRepresentativeHomotopy` the chain of elementary moves reducing a walk to a shortest representative
- `HomotopicQ` whether a and b lie in the same homotopy class
- `NullHomotopicQ` whether a closed walk is null-homotopic
- `HomotopyMoveType` classifies an elementary move as "Contract", "Extend" or "Lateral"
- `HomotopyMoveTypes` applies HomotopyMoveType to each consecutive pair of a homotopy chain

### Experimental · MetricAlgebra.wl

- `MetricInterval` the vertices on some geodesic from u to v, { w : d(u, w) + d(w, v) == d(u, v) }
- `ShortestPathMultiplicityMatrix` the matrix of the numbers of shortest paths between every two vertices
- `MedianVertices` the vertices minimising the sum of distances to a vertex list

### EuclideanInfrageometry · InfraSet.wl

- `FindAdvancingInfraFront` the foliation by a bouncing wavefront, as a list of sorted vertex lists
- `InfraBoundary` the boundary of a vertex set, density or shape, as a sorted vertex list
- `InfraInterior` the interior of a vertex set, density or shape, as a sorted vertex list

### Experimental · InfraEquality.wl

- `InfraEqualQ` tests equality of two infra-objects through their diffusion diagrams

### EuclideanInfrageometry · InfraScene.wl

- `InfraDistance` the graph distance between two infra-objects, aggregated over their vertex sets
- `InfraPlaneQ` whether h lies in the bisector slab of p1 and p2 and separates them
- `InfraIntersectQ` asserts inside an InfraScene that two sets intersect

### EuclideanInfrageometry · InfraSceneInteractive.wl

- `PointViewer` an interactive viewer for selecting points
- `SegmentViewer` an interactive viewer for exploring geodesic segments
- `ShellViewer` an interactive viewer for exploring metric shells
- `CircleViewer` an interactive viewer for exploring separating cycles

### Experimental · GraphBoundary.wl

- **GraphBoundary** — the inner vertex boundary of S in g, the vertices where an edge of g escapes S
- **GraphInterior** — the interior of S in g, S minus its GraphBoundary
- **GraphEccentricities** — the eccentricity of every vertex, in VertexList order
- **RelativeEccentricity** — the eccentricity of each vertex rescaled to run from 0 at the radius to 1 at the diameter

### Experimental · Coordinatization.wl

- **RadarCoordinates** — the distance vector from a vertex to each vertex of a basis
- **ResolvingSetQ** — whether a basis is a resolving set
- **FindResolvingSet** — up to n resolving sets, or metric bases, of g by ascending size
- **MetricDimension** — the metric dimension of g
- **ResistanceCoordinates** — the spectral embedding whose squared distances are the effective resistances
- `OrthogonalCoordinates` the integer displacement of v along each axis through the centre c
- `FindInfraOrthogonalFrame` frames of mutually perpendicular geodesic axes through the centre c
- `FindInfraSpanningAxes` n mutually well-separated longest geodesics across a graph, with no fixed centre

### Experimental · OllivierCurvature.wl

- **OllivierRicciCurvature** — the Ollivier-Ricci curvature of every edge, with the uniform measure on each neighbourhood
- **EffectiveResistance** — the Klein-Randic resistance distance R(u, v), from the pseudoinverse of the graph Laplacian
- **ResistanceQ** — whether a symmetric matrix with zero diagonal is realisable as a resistance distance matrix

### Experimental · DifferentialForms.wl

- `FormValue` the value of the germ of a form at a vertex on a tuple of its neighbours, alternating in the tuple
- `CochainValue` the value of an alternating cochain on a vertex tuple
- `OrderedCochainValue` the value of an ordered cochain on an increasing vertex tuple
- `FormDegree` the degree of a form
- `CochainDegree` the degree of a cochain
- `ZeroForm` a vertex function as a 0-form
- `RestrictionMap` the form read from an alternating cochain with the base vertex prepended
- `IntegrationMap` the cochain averaged from the germs of a form over each clique, a left inverse of RestrictionMap
- `Coboundary` the coboundary of a cochain, the alternating sum over the faces of every clique one dimension up
- `FormDifferential` the differential of a form, the gradient on 0-forms and with a transport term on 1-forms
- `NaiveDifferential` the differential of a 1-form with the transport term dropped, kept for comparison
- `FormWedge` the wedge product of forms, fibre by fibre
- `CochainCup` the cup product of alternating cochains, antisymmetrised over the orderings of each clique
- `OrderedCochainCup` the Alexander-Whitney cup product of ordered cochains
- `CochainCupOne` the Steenrod cup-1 product of ordered cochains
- `AntisymmetrizedCup` an alias of CochainCup
