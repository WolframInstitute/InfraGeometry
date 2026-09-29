---
Template: Guide
Name: TopologicalPropertiesGuide
Title: Topological Properties
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/TopologicalPropertiesGuide
Keywords: [topology, ball topology, specialization preorder, ball intersection complex, Cech complex, Vietoris-Rips, ball cover, covering dimension, ball hull]
RelatedGuides: [EuclideanGeometryGuide, RiemannianGeometryGuide, TangentSpacesAndFormsGuide, FiberBundlesGuide, SubstratesGuide, Experimental]
---

## Abstract

The topological properties of a substrate are read off its metric balls. The closed balls of one radius r generate a topology: a vertex p is in the closure of q when the r-ball at p lies inside the r-ball at q, and BallTopology returns that specialization preorder as a digraph on which closure, interior, boundary, neighbourhood and continuity are computed. A family of balls forms a complex through its intersections: a simplex is admitted when every k of its balls meet, so k = 2 is the Vietoris-Rips complex, k = Infinity the Cech complex, and the orders between interpolate. The number of balls of radius r needed to cover the substrate falls as r grows, and how fast it falls is a dimension. The intersection of all closed balls containing a set of points is its ball hull, the smallest ball-convex set containing it. Two sections still wait: the covering dimension as a function, and the intersection of the balls of one radius r containing a set; the dimension read from where the intersection of the balls through k given points becomes degenerate is an idea for a tutorial rather than a function.

## Functions

### The ball topology

- `BallTopology` the Hasse diagram of the r-ball specialization preorder: an edge q -> p when the closed r-ball at p lies inside the one at q
- `TopologicalClosure` the closure of a vertex list in the preorder digraph, the union of the down-sets of its vertices
- `TopologicalInterior` the interior V \ cl(V \ S) of a vertex list in the preorder digraph
- `TopologicalBoundary` the two-sided boundary cl(S) \ int(S) of a vertex list in the preorder digraph
- `TopologicalNeighborhood` the minimal open neighbourhood of a vertex list, the union of the up-sets of its vertices
- `ContinuousMapQ` whether a vertex map is continuous between two preorder digraphs
- `TopologyGraph` the graph drawn with the Hasse arrows of the preorder on top

### The ball intersection complex

- `BallIntersectionComplex` the order-k complex of closed radius-r balls: a simplex is admitted when every k of its balls have a common point; k = 2 is Vietoris-Rips, k = Infinity is Cech
- `CechComplex` the nerve of the closed radius-r balls, the order-Infinity ball intersection complex
- `MiniballRadius` the radius of the smallest ball enclosing a set of points
- `BallIntersectionFiltrationValue` the birth radius of a simplex in the order-k complex, the largest miniball radius over its k-subsets
- `BallIntersectionFiltration` the order-k complexes over a list of radii, ready for persistence
- `CechFiltration` the Cech complexes over a list of radii
- `BallIntersectionBifiltration` the complexes over radii and orders together; at fixed r the order-k complex contains the order-(k + 1) one

### Ball covers and the covering dimension

- `FindBallCover` a smallest set of centres whose radius-r balls cover every vertex, or a given subset of vertices
- `BallCoverQ` whether the radius-r balls about a set of centres cover every vertex
- `DominationNumber` the size N(r) of a minimum radius-r ball cover
- waits: the covering dimension, read from how N(r) falls as r grows
- waits, as a tutorial: the dimension read from where the intersection of the balls containing k given points becomes degenerate

### Ball hulls

- `BallHull` the intersection of all closed balls containing a vertex set, the smallest ball-convex superset
- `FindBallHull` the same ball hull as a multiset
- `BallHullQ` whether a vertex set is ball-convex, an intersection of closed balls
- waits: the intersection of all closed balls of one radius r containing a set of points
