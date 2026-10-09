---
Template: Guide
Name: Experimental
Title: Experimental Functions
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/Experimental
Keywords: [experimental, index, kernel files, walks, walk space, homotopy, differential forms, cochains, resolving sets, effective resistance, Ollivier-Ricci curvature, eccentricity]
RelatedGuides: [EuclideanInfrageometry, RiemannianInfrageometry, InfraTopology, InfraAnalysis, InfraFiberBundles, InfraSubstrates]
---

## Abstract

Every exported symbol that no other guide of the site covers, one section per kernel file, titled by the kernel folder and the file. The folders are the category guides, and the Experimental folder holds the research files. The symplectic branch has no code yet. Each entry is the symbol's usage message cut to one line, and each name opens its reference page. Most of these pages predate this site and have not been revised for it.

## Functions

### RiemannianInfrageometry · InfraWalk.wl

- `InfraWalk` the literal walk through p1, ..., pk, inside InfraScene and InfraSubstrateHighlight
- `RandomInfraWalk` grows a germ, a vertex or a walk, into the walks of the class cut by the Properties rules until a stopping condition or the budget stops them
- `WalkSingularities` the self-intersections, self-tangencies and cusps of a walk
- `InfraImmersedQ` whether a walk is immersed, a walk with no cusp
- `InfraGenericQ` whether a walk is a generic immersed curve
- `InfraWalkCrossingQ` whether the double visit of a walk at v is a transverse crossing at scale r
- `ConcatenateInfraWalk` joins every compatible walk pair, the last vertex of one being the first of the other

### RiemannianInfrageometry · InfraShell.wl

- `FindInfraOsculatingShell` the shells whose level set contains a k-vertex window of a path, one per osculating centre
- `FindInfraShellCenter` recovers the centre and radii of a shell
- `InfraShellQ` whether a vertex set is a metric shell { v : d(c, v) == r } for some centre c and radius r

### EuclideanInfrageometry · WalkSpace.wl

- `SelectInfraWalk` draws a walk from a bundle
- `EmbeddingClosest` keeps the bundle elements drawn closest to a Euclidean reference under GraphEmbedding
- `FindEmbeddingClosestPath` snaps an embedded curve to a walk graph, joining the nearest vertices by geodesics
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

- `ShortestPathMultiplicityMatrix` the matrix of the numbers of shortest paths between every two vertices
- `MedianVertices` the vertices minimising the sum of distances to a vertex list

### Experimental · GraphBoundary.wl

- `GraphBoundary` the inner vertex boundary of S in g, the vertices where an edge of g escapes S
- `GraphInterior` the interior of S in g, S minus its GraphBoundary
- `GraphEccentricities` the eccentricity of every vertex, in VertexList order
- `RelativeEccentricity` the eccentricity of each vertex rescaled to run from 0 at the radius to 1 at the diameter

### Experimental · Coordinatization.wl

- `RadarCoordinates` the distance vector from a vertex to each vertex of a basis
- `ResolvingSetQ` whether a basis is a resolving set
- `FindResolvingSet` up to n resolving sets of g, the smallest first; the first of them is a metric basis
- `MetricDimension` the metric dimension of g
- `ResistanceCoordinates` the spectral embedding whose squared distances are the effective resistances

### Experimental · OllivierCurvature.wl

- `OllivierRicciCurvature` the Ollivier-Ricci curvature of every edge, with the uniform measure on each neighbourhood
- `EffectiveResistance` the Klein-Randic resistance distance R(u, v), from the pseudoinverse of the graph Laplacian
- `ResistanceQ` whether a symmetric matrix with zero diagonal is of negative type, as every resistance distance matrix is

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
