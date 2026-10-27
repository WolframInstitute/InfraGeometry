---
Template: Guide
Name: InfraTopology
Title: Infra Topology
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/InfraTopology
Keywords: [topology, ball topology, specialization preorder, ball intersection complex, Cech complex, Vietoris-Rips, ball cover, covering dimension, paths, walks, loops, homotopy, deformation]
RelatedGuides: [EuclideanInfrageometry, RiemannianInfrageometry, InfraAnalysis, InfraFiberBundles, InfraSubstrates, Experimental]
RelatedTutorials: [DimensionTutorial]
---

## Abstract

*Abstract written by Pavel Hajek on 27 October 2026.*

We study the topology, or global structure, of an infra substrate as seen by an infra observer at scale $r$. The **ball intersection complex**, computed by [BallIntersectionComplex](), encodes the intersections among the balls of radius $r$ covering the substrate. A collection of $k+1$ balls spans a $k$-simplex whenever every subcollection of at most $m$ balls has nonempty intersection. The case $m=\infty$ recovers the **Čech complex**, computed by [CechComplex](), while $m=2$ recovers the **Vietoris–Rips complex** at threshold $2r$.

We consider several notions of **dimension** at an observer scale $r$. A **Hausdorff-type dimension** is based on the number of balls of radius $s<r$ required to cover a ball of radius $r$ centered at a point $p$. [BallCoverNumber]() computes the minimal number of such balls, while [FindBallCover]() finds their centers. In particular, we can study how the number of radius-$r/2$ balls needed to cover a radius-$r$ ball varies with $r$. Another notion is based on the maximal number of **mutually orthogonal axes** of length $r$ through $p$, computed by [FindInfraOrthogonalAxes](). We also define a dimension in terms of **equidistant sets**. Starting from pairs of maximally separated points on the radius-$r$ shell around $p$, we consider their perpendicular bisectors and determine the maximal number of independent bisectors with a nonempty common intersection. [InfraEquidistantSet]() represents this common set, while [FindInfraEquidistantSet]() computes it. A further notion is based on intersections of radius-$r$ balls and asks for the smallest intersection order for which intersections of small subcollections determine whether the entire family has a common point. Finally, [VolumeGrowthObservables]() implements the Riemannian idea of extracting dimension, together with scalar curvature, from the growth of **ball and shell volumes** with radius.

We also study **homotopy of paths and loops** through local deformations. `"NullHomotopicCycles"` specifies which cycles may be contracted. [FindInfraHomotopy]() finds sequences of deformations, while [HomotopicQ]() and [NullHomotopicQ]() test homotopy and null-homotopy. We also consider **controlled deformations of shortest paths**, keeping endpoints fixed and bounding both the excess length and the distance from the reference path. One restricted family consists of **forward walks**, for which distance from the starting point never decreases. Their excess length counts steps within distance shells, and such walks can be counted using powers of the adjacency matrix of the admissible-step graph. [InfraDeformationSize]() measures the extent of the change along the reference path, between the common prefix and suffix.

Infra topology also includes the **topological properties of fibre bundles**, discussed in the [Infra Fiber Bundles](paclet:WolframInstitute/InfraGeometry/guide/InfraFiberBundles) guide.
<!-- Dimension provenance: BlogWriting/MeetingsMaterial/Infrageometry_2026-06-07.nb, Equidistant set and dimension; GeneralMeetings/NikMeeting2.nb, Dimensions; SubProjects/DiscreteGeometry/Wiki/DiscreteGeometry/BallIntersectionComplex.md, The Helly ladder. Graph dimension criteria remain proposals. -->

## Functions

### The ball topology

- `BallTopology` the Hasse diagram of the specialization preorder of the $r$-balls
- `TopologicalClosure` the closure of a vertex set, the union of the down-sets of its vertices
- `TopologicalInterior` the interior of a vertex set, the complement of the closure of its complement
- `TopologicalBoundary` the closure minus the interior
- `TopologicalNeighborhood` the smallest open set containing a vertex set
- `ContinuousMapQ` whether a vertex map is continuous between two preorders
- `TopologyGraph` a graph drawn with the Hasse arrows of its preorder on top

- `TransitiveReductionGraph` (WL), `TransitiveClosureGraph` (WL), `VertexInComponent` (WL), `VertexOutComponent` (WL)

### Region operations

- `InfraBoundary` the boundary of a vertex set, density or object
- `InfraInterior` the interior of a vertex set, density or object

### The ball intersection complex

- `BallIntersectionComplex` the order-$k$ complex of the closed $r$-balls
- `CechComplex` the nerve of the closed $r$-balls
- `MiniballRadius` the radius of the smallest ball enclosing a set of points
- `BallIntersectionFiltration` the order-$k$ complexes over a list of radii
- `CechFiltration` the Cech complexes over a list of radii
- `BallIntersectionBifiltration` the complexes over the radius and the order together

- `BallIntersectionFiltrationValue`, `FindClique` (WL)

### Ball covers and the covering dimension

- `FindBallCover` centres whose $r$-balls cover a target, minimizing their number by default
- `RandomBallCover` uniformly sampled minimum centre sets covering a target
- `BallCoverNumber` the covering number $N(r)$, the $r$-domination number
- `BallCoverQ` whether the $r$-balls about a set of centres cover the substrate
- `InfraBallHull` the intersection of all closed balls containing a set

### Notions of dimension

- `InfraEquidistantSet` the common equidistant set of a list of points
- `FindInfraEquidistantSet` the vertices at equal graph distance from all points
- `FindInfraOrthogonalAxes` a maximal family of mutually perpendicular axes through a point
- `VolumeGrowthObservables` dimension and scalar curvature from ball and shell volumes

### Paths and walks

- `InfraWalk` an oriented walk through a vertex sequence
- `RandomInfraWalk` walks grown from a germ under local rules and a stopping condition
- `InfraWalkQ` whether consecutive vertices form a walk of the substrate
- `ConcatenateInfraWalk` compatible walks joined end to start
- `WalkSingularities` repeated vertices, repeated arcs and cusps of a walk
- `InfraImmersedQ`, `InfraGenericQ`, `InfraWalkCrossingQ`

### Path families and deformations

- `IntervalGraph` the directed graph carrying all shortest paths between two vertices
- `PathSubgraph` the union of simple paths between two vertices within a length bound
- `SprayGraph` the union of shortest paths growing outward from an origin
- `SelectInfraWalk` representatives selected from a family of walks
- `EmbeddingClosest` the walks closest to an embedded reference curve
- `FindEmbeddingClosestPath` an embedded curve snapped to a walk graph
- `InfraDeformationSize` the number of reference edges between the common prefix and suffix

### Path and loop homotopy

- `FindInfraHomotopy` a witness sequence of elementary moves between paths or loops
- `HomotopicQ` certified homotopy or non-homotopy, remaining unevaluated when undecided
- `NullHomotopicQ` whether a loop contracts, remaining unevaluated when undecided
- `FindInfraHomotopyRepresentative` certified shortest representatives, remaining unevaluated when undecided
- `FindInfraHomotopyRepresentativeHomotopy` witness chains to certified shortest representatives
- `HomotopyMoveType` a length change classified as contraction, extension or lateral movement
- `HomotopyMoveTypes` the length-change types of successive walks in a chain
