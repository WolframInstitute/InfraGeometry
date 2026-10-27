---
Template: Guide
Name: InfraTopology
Title: Infra Topology
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/InfraTopology
Keywords: [topology, ball topology, specialization preorder, ball intersection complex, Cech complex, Vietoris-Rips, ball cover, covering dimension]
RelatedGuides: [EuclideanInfrageometry, RiemannianInfrageometry, InfraAnalysis, InfraFiberBundles, InfraSubstrates, Experimental]
RelatedTutorials: [DimensionTutorial]
---

## Abstract

*Abstract written by Pavel Hajek on 27 October 2026.*

We consider topology as viewed by an observer at scale $r$. The **ball intersection complex**, computed by [BallIntersectionComplex](), uses the information of overlaps of cover by balls of radius $r$. A collection of $k+1$ balls forms a $k$-simplex when every subcollection of at most $m$ balls has a common point. For $m=\infty$, we obtain the **Cech complex**, computed by [CechComplex](). For $m=2$, we obtain the **Vietoris-Rips complex** with threshold $2r$.

We consider several notions of **dimension** at an observer scale. A **Hausdorff-type dimension** is based on the number of balls of radius $s<r$ needed to cover a ball of radius $r$ around a point $p$. [BallCoverNumber]() computes the minimal number of balls, while [FindBallCover]() finds their centers. In particular, we can study how the number of radius-$r/2$ balls needed to cover a radius-$r$ ball changes with $r$. Another notion is based on the maximal number of **mutually orthogonal axes** of length $r$ through $p$, computed using [FindInfraOrthogonalAxes](). We also define a dimension using **equidistant sets**: starting from pairs of maximally distant points on the radius-$r$ shell around $p$, we consider their perpendicular bisectors and ask for the maximal number of independent bisectors having a nonempty common intersection. [InfraEquidistantSet]() represents this common set, and [FindInfraEquidistantSet]() computes it. A further notion uses intersections of radius-$r$ balls and asks for the smallest intersection order at which intersections of small subcollections determine whether the whole family has a common point. Finally, [VolumeGrowthObservables]() implements the Riemannian idea of extracting dimension, together with scalar curvature, from the growth of **ball and shell volumes** with radius.

We also study **homotopy of paths and loops** through small deformations. "NullHomotopicCycles" specifies which cycles can be contracted. [FindInfraHomotopy]() finds deformations, while [HomotopicQ]() and [NullHomotopicQ]() test homotopy and null-homotopy. We also consider **forward deformations of shortest paths**: distance from the starting point never decreases, and excess length counts steps within distance shells. These walks can be counted using adjacency-matrix powers. [InfraDeformationSize]() measures how many edges of the reference path are replaced.

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

### Path and loop homotopy

- `FindInfraHomotopy` a sequence of elementary deformations between two paths or loops
- `HomotopicQ` whether two paths or loops are homotopic
- `NullHomotopicQ` whether a loop can be contracted to a point
- `FindInfraHomotopyRepresentative` the shortest representatives of a homotopy class
- `FindInfraHomotopyRepresentativeHomotopy` a sequence of deformations to a shortest representative
- `InfraDeformationSize` the number of edges of a reference path replaced by a deformation
- `HomotopyMoveType` an elementary deformation classified as contraction, extension or lateral movement
- `HomotopyMoveTypes` the types of successive deformations in a homotopy
