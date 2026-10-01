---
Template: Guide
Name: InfraTopology
Title: Infra Topology
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/InfraTopology
Keywords: [topology, ball topology, specialization preorder, ball intersection complex, Cech complex, Vietoris-Rips, ball cover, covering dimension, ball hull]
RelatedGuides: [EuclideanInfrageometry, RiemannianInfrageometry, InfraAnalysis, InfraFiberBundles, InfraSubstrates, Experimental]
---

## Abstract

The topological properties of a substrate are read off its metric balls. The closed balls of one radius r generate a topology: a vertex q lies in the closure of a vertex p when the r-ball at p is contained in the r-ball at q. BallTopology returns this specialization preorder as a digraph, and closure, interior, boundary, neighbourhood and continuity are computed on it. A family of balls forms a complex through its intersections: a simplex is admitted when every k of its balls have a common point, so k = 2 gives the Vietoris-Rips complex of twice the radius, k = Infinity the Cech complex, and the orders between interpolate. The least number N(r) of balls of radius r that cover the substrate falls as r grows, and the rate of that fall is a dimension. The intersection of all closed balls containing a set of points is its ball hull, the smallest ball-convex set containing it. Three things still wait: the covering dimension as a function, the intersection of the balls of one radius r containing a set, and, as a tutorial rather than a function, the dimension read from where the intersection of the balls containing k given points becomes degenerate.

## Functions

### The ball topology

- **BallTopology** — the Hasse diagram of the r-ball specialization preorder: an edge q -> p when the closed r-ball at p lies inside the one at q
- **TopologicalClosure** — the closure of a vertex list in the preorder digraph, the union of the down-sets of its vertices
- **TopologicalInterior** — the interior of a vertex list in the preorder digraph, the complement of the closure of its complement
- **TopologicalBoundary** — the two-sided boundary of a vertex list, its closure minus its interior
- **TopologicalNeighborhood** — the smallest open set containing a vertex list, the union of the up-sets of its vertices
- **ContinuousMapQ** — whether a vertex map is continuous from one preorder digraph to another
- **TopologyGraph** — the graph drawn with the Hasse arrows of a preorder digraph on top

### The ball intersection complex

- **BallIntersectionComplex** — the order-k complex of closed radius-r balls: a simplex is admitted when every k of its balls have a common point
- **CechComplex** — the nerve of the closed radius-r balls, the order-Infinity ball intersection complex
- **MiniballRadius** — the radius of the smallest ball enclosing a set of points
- **BallIntersectionFiltrationValue** — the birth radius of a simplex in the order-k complex
- **BallIntersectionFiltration** — the order-k complexes over a list of radii, ready for persistence
- **CechFiltration** — the Cech complexes over a list of radii
- **BallIntersectionBifiltration** — the complexes over the radius and the order together

### Ball covers and the covering dimension

- **FindBallCover** — a smallest set of centres whose radius-r balls cover every vertex, or a given set of targets
- **BallCoverQ** — whether the radius-r balls about a set of centres cover every vertex, or a given set of targets
- **DominationNumber** — the size N(r) of a smallest radius-r ball cover
- waits: the covering dimension, from how N(r) falls as r grows, or from how many balls of radius r cover a ball of radius 2r
- waits, as a tutorial: the dimension read from where the intersection of the balls containing k given points becomes degenerate

### Ball hulls

- **BallHull** — the intersection of all closed balls containing a vertex set, the smallest ball-convex superset
- `FindBallHull` the ball hull of any shape, a vertex, a vertex list, a density or a walk, as a sorted vertex list
- `BallHullQ` whether a vertex set is ball-convex, equal to its own ball hull
