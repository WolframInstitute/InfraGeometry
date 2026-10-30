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

Experimental functions that are not yet part of the main API and can change drammatically or be dropped.

## Functions

- Paths, walks, path selection and homotopy are covered by [Infra Topology](paclet:WolframInstitute/InfraGeometry/guide/InfraTopology).

### Wavefronts

- `FindAdvancingInfraFront` the foliation by a wavefront bouncing outward from an origin

### Osculating shells

- `FindInfraOsculatingShell` the shells whose level set contains a window of a path
- `FindInfraShellCenter` the centre and radii of a shell

- `InfraShellQ`

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

- `FormDegree`, `CochainDegree`, `OrderedCochainValue`, `NaiveDifferential`

### Particular fibered graph models

- `InfraTangentBundle`, `InfraCotangentBundle`, `InfraDisplacementBundle` ray and distance-pair constructions
- `InfraRays`, `InfraBundleMorphism`, `InfraFiberedSubstrate` their rays, natural maps and example catalogue
- `RandomInfraFibration` a random fibered graph with cyclic-width horizontal bands
- `FindInfraLeviCivitaConnection`, `InfraHolonomyAngle`, `InfraCovariantDerivative`, `InfraCanonicalOneForm` metric-selected transport and measurements

### Object relations

- `InfraEqualQ` whether two objects are equal as sets or multisets, by overlap, or diffusely

### Construction viewers

- `PointViewer`, `SegmentViewer`, `ShellViewer`, `CircleViewer` interactive viewers for points, segments, shells and circles
