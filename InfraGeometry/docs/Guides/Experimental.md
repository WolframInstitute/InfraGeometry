---
Template: Guide
Name: Experimental
Title: Experimental Functions
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/Experimental
Keywords: [experimental, walks, walk space, homotopy, differential forms, cochains, resolving sets, effective resistance, Ollivier-Ricci curvature, eccentricity]
RelatedGuides: [EuclideanInfrageometry, RiemannianInfrageometry, InfraTopology, InfraAnalysis, InfraFiberBundles, InfraSubstrates]
RelatedTutorials: [ExperimentalInfraBundles]
---

## Abstract

Research functions not yet settled into a branch: walks and their singularities, osculating shells, the space of walks near a reference curve, the homotopy of walks by elementary moves, shortest-path counts and medians, vertex boundaries and eccentricities, metric coordinates and the metric dimension, Ollivier-Ricci curvature and effective resistance, and differential forms and cochains on the cliques of a graph.

## Functions

### Walks

- `InfraWalk` the walk through $p_1, \dots, p_k$, an object of a scene
- `RandomInfraWalk` random walks grown from a germ under rules and a stopping condition
- `WalkSingularities` the self-intersections, self-tangencies and cusps of a walk
- `ConcatenateInfraWalk` every compatible pair of walks joined end to start
- `FindAdvancingInfraFront` the foliation by a wavefront bouncing outward from an origin

- `InfraWalkQ`, `InfraImmersedQ`, `InfraGenericQ`, `InfraWalkCrossingQ`

### Osculating shells

- `FindInfraOsculatingShell` the shells whose level set contains a window of a path
- `FindInfraShellCenter` the centre and radii of a shell

- `InfraShellQ`

### Walk space

- `SelectInfraWalk` a walk drawn from a bundle
- `EmbeddingClosest` the bundle elements drawn closest to a Euclidean reference
- `FindEmbeddingClosestPath` an embedded curve snapped to a walk graph
- `InfraDeformationSize` the number of edges of a reference walk that a walk replaces

### Homotopy of walks

- `FindInfraHomotopy` a chain of elementary moves from one walk to another
- `FindInfraHomotopyRepresentative` the shortest walks in the homotopy class of a walk
- `FindInfraHomotopyRepresentativeHomotopy` the chain of moves reducing a walk to a shortest representative
- `HomotopyMoveType` an elementary move classified as "Contract", "Extend" or "Lateral"

- `HomotopicQ`, `NullHomotopicQ`, `HomotopyMoveTypes`

### Shortest-path counts and medians

- `ShortestPathMultiplicityMatrix` the numbers of shortest paths between every two vertices
- `MedianVertices` the vertices minimising the sum of distances to a vertex list
- `GraphDistanceMatrix` (WL) the distances between every two vertices

### Boundary and eccentricity

- `GraphBoundary` the vertices of a set where an edge escapes it
- `GraphInterior` a set minus its boundary
- `GraphEccentricities` the eccentricity of every vertex
- `RelativeEccentricity` the eccentricity rescaled from 0 at the radius to 1 at the diameter

- `VertexEccentricity` (WL), `GraphCenter` (WL), `GraphPeriphery` (WL)

### Metric coordinates

- `RadarCoordinates` the distances from a vertex to each vertex of a basis
- `FindResolvingSet` the smallest resolving sets, the first a metric basis
- `MetricDimension` the metric dimension of a graph
- `ResistanceCoordinates` the spectral embedding whose squared distances are the effective resistances

- `ResolvingSetQ`

### Curvature and resistance

- `OllivierRicciCurvature` the Ollivier-Ricci curvature of every edge
- `EffectiveResistance` the resistance distance $R(u, v)$ from the pseudoinverse of the Laplacian
- `KirchhoffMatrix` (WL) the graph Laplacian

- `ResistanceQ`

### Differential forms and cochains

- `ZeroForm` a vertex function as a 0-form
- `FormValue` the value of a form at a vertex on a tuple of its neighbours
- `FormDifferential` the differential of a form
- `FormWedge` the wedge product of forms
- `CochainValue` the value of an alternating cochain on a vertex tuple
- `Coboundary` the coboundary of a cochain
- `CochainCup` the cup product of alternating cochains
- `OrderedCochainCup` the Alexander-Whitney cup product of ordered cochains
- `CochainCupOne` the Steenrod cup-1 product of ordered cochains
- `RestrictionMap` the form read from an alternating cochain
- `IntegrationMap` the cochain averaged from a form over each clique

- `FormDegree`, `CochainDegree`, `OrderedCochainValue`, `NaiveDifferential`, `AntisymmetrizedCup`

### Particular fibered graph models

- `InfraTangentBundle`, `InfraCotangentBundle`, `InfraDisplacementBundle` ray and distance-pair constructions
- `InfraRays`, `InfraBundleMorphism`, `InfraFiberedSubstrate` their rays, natural maps and example catalogue
- `RandomInfraFibration` the compatibility generator with the earlier cyclic-width interpretation
- `FindInfraLeviCivitaConnection`, `InfraHolonomyAngle`, `InfraCovariantDerivative`, `InfraCanonicalOneForm` metric-selected transport and measurements

These remain loaded in the Infra Fiber Bundles category. Their particular geometric assumptions are separate from its general inert objects and complete connections.

The [Experimental Infra Bundles tutorial](paclet:WolframInstitute/InfraGeometry/tutorial/ExperimentalInfraBundles) separates exact finite observations from proposed scale reduction and completion research. General fibered graphs and their structural predicates are covered by [Infra Bundles](paclet:WolframInstitute/InfraGeometry/tutorial/InfraBundles).


### Object relations

- `InfraEqualQ` whether two objects are equal as sets or multisets, by overlap, or diffusely

### Construction viewers

- `PointViewer`, `SegmentViewer`, `ShellViewer`, `CircleViewer` interactive viewers for points, segments, shells and circles
