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

The topology of a substrate is read off its metric balls. The closed balls of one radius $r$ generate a topology: a vertex $q$ lies in the closure of a vertex $p$ when the $r$-ball at $p$ is contained in the $r$-ball at $q$. This specialization preorder carries closure, interior, boundary, neighbourhood and continuity. A family of balls forms a complex through its intersections: a simplex is admitted when every $k$ of its balls have a common point, so $k = 2$ gives the Vietoris-Rips complex of twice the radius, $k = \infty$ the Cech complex, and the orders between interpolate. The least number $N(r)$ of balls of radius $r$ that cover the substrate falls as $r$ grows, and the rate of that fall is a dimension.

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
