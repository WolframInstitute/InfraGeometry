---
Template: Symbol
Name: InfraScene
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraScene
Keywords: [scene, construction, Euclid I.1, hypothesis, assertion, ruler and compass]
SeeAlso: [FindInfraScene, InfraSceneInstance, InfraStep, InfraIntersection, InfraDistance, InfraSceneViewer]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraScene]()[{*x1*, *x2*, …}, {*hyp1*, *hyp2*, …}]</code> is a construction stated before any graph: the objects *xi*, and hypotheses that construct them or assert relations between them.

<code>[InfraScene]()[{*x1*, …}, {[InfraStep]()[{*hyp1*, …}, *label*], …}]</code> groups the hypotheses into labelled steps.

## Details & Options

Definition: a scene is a list of objects and a list of hypotheses. A **construction** is a hypothesis `x == token`, whose left side is an object. Every other hypothesis is an **assertion**. A scene computes nothing; [FindInfraScene]() solves it on a graph.

The right side of a construction is a token: an inert head with objects in place of points. [InfraPoint]()`[v]` is the vertex *v*, and <code>[InfraPoint]()[*v*, *d*]</code> every vertex at distance *d* from *v*. [InfraSegment]()`[x, y]` is a shortest path from *x* to *y*, and [InfraRay]()`[x, y]` and [InfraLine]()`[x, y]` a ray and a line. [InfraCircle]()`[x, r]` is a circle about *x* at radius *r*, or in the band `{r, s}`. [InfraIntersection]()`[x, y]` is a vertex the two objects share; an operand may be a token itself.

A token stands for its realisations, and each realisation is one branch. So a construction binds its object to a single vertex, or a single vertex list, per branch, and the branches multiply from one construction to the next.

The token is the head itself: the second argument of [InfraCircle]() is always a radius or a band. The circle through a point is the closed arc [InfraArc]()`[x, {p, p}]`.

An assertion is a predicate on objects: a comparison of [InfraDistance]() values, or one of the `Infra*Q` tests without its graph (`InfraSegmentQ[s]`, `InfraCircleQ[c]`, `InfraParallelQ[l1, l2]` and a few more). The graph is supplied when the scene is solved, and a branch survives only if every assertion holds on it. An `Infra*Q` test that cannot be given the graph is refused with `InfraScene::badassertion`.

Without [InfraStep](), the steps are the levels of the dependency graph of the constructions: first the objects that depend on no other object, then those that depend only on them, and so on. With it, the steps are the ones written, in order.

The objects are ordinary symbols, so they must have no value when the scene is built; `ClearAll` them first.

A scene answers `"Objects"`, `"Constructions"`, `"Assertions"`, `"Steps"`, `"Labels"` and `"DependencyGraph"`. The dependency graph is `None` when the steps are written by hand.

**A construction can stall.** Euclid never postulated that the two circles of I.1 meet, and on a graph they need not. On a square grid a single distance shell spans no cycle, so the circles of I.1 at one radius do not exist. That is the continuity assumption Euclid left unstated, showing up as an empty result. A band two radii thick carries the circles, and there the construction goes through.

## Basic Examples

Euclid I.1 on the square tiling: two points four steps apart, a circle in the band `{4, 5}` about each, and the vertices where the circles meet. On a lattice two circles meet along an edge rather than at a vertex, so there are several meeting vertices.

```wl
ClearAll[pA, pB, circleA, circleB, meet];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; FindInfraPoint[g, InfraShell[a, 4]])},
  {scene = InfraScene[{pA, pB, circleA, circleB, meet},
     {InfraStep[{pA == InfraPoint[a]}, "point A"],
      InfraStep[{pB == InfraPoint[b]}, "point B"],
      InfraStep[{circleA == InfraCircle[pA, {4, 5}]}, "circle about A"],
      InfraStep[{circleB == InfraCircle[pB, {4, 5}]}, "circle about B"],
      InfraStep[{meet == InfraIntersection[circleA, circleB]}, "where they meet"]}]},
  {solved = FindInfraScene[scene, g]},
  {cycleA = InfraSceneInstance[First @ solved, circleA]},
  {cycleB = InfraSceneInstance[First @ solved, circleB]},
  InfraSubstrateHighlight[g,
    Join[{InfraWalk[Append[cycleA, First @ cycleA]], InfraWalk[Append[cycleB, First @ cycleB]], a, b},
      InfraSceneInstance[#, meet] & /@ solved]]]
```

Euclid I.1 without steps: they are read off the dependencies, three levels deep. The dependency graph, beside the objects and the steps.

```wl
ClearAll[pA, pB, circleA, circleB, meet];
With[
  {scene = InfraScene[{pA, pB, circleA, circleB, meet},
     {pA == InfraPoint[1], pB == InfraPoint[2],
      circleA == InfraCircle[pA, {4, 5}], circleB == InfraCircle[pB, {4, 5}],
      meet == InfraIntersection[circleA, circleB]}]},
  {scene["DependencyGraph"], scene["Objects"], scene["Steps"]}]
```

An assertion keeps the branches it holds on: here the meeting vertices nearer than *A* to a vertex of the rim.

```wl
ClearAll[pA, pB, circleA, circleB, meet];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; FindInfraPoint[g, InfraShell[a, 4]])},
  {rim = (SeedRandom[1]; FindInfraPoint[g, GraphPeriphery[g]])},
  {scene = InfraScene[{pA, pB, circleA, circleB, meet},
     {pA == InfraPoint[a], pB == InfraPoint[b],
      circleA == InfraCircle[pA, {4, 5}], circleB == InfraCircle[pB, {4, 5}],
      meet == InfraIntersection[circleA, circleB],
      InfraDistance[meet, rim] < InfraDistance[pA, rim]}]},
  {kept = InfraSceneInstance[#, meet] & /@ FindInfraScene[scene, g]},
  {InfraSubstrateHighlight[g, Join[{a, b, rim}, kept]], scene["Assertions"], kept}]
```

## Properties and Relations

At a single radius the square tiling has no circle, so the construction finds nothing. The shell about *A* is drawn: it has no two adjacent vertices.

```wl
ClearAll[pA, pB, circleA, circleB, meet];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; FindInfraPoint[g, InfraShell[a, 4]])},
  {scene = InfraScene[{pA, pB, circleA, circleB, meet},
     {pA == InfraPoint[a], pB == InfraPoint[b],
      circleA == InfraCircle[pA, 4], circleB == InfraCircle[pB, 4],
      meet == InfraIntersection[circleA, circleB]}]},
  {InfraSubstrateHighlight[g, {FindInfraShell[g, a, 4], a, b}],
   FindInfraRepresentative[g, InfraCircle[a, 4], All], FindInfraScene[scene, g]}]
```

On the discretized plane a single radius suffices: its shells are cycles by accident of the mesh.

```wl
ClearAll[pA, pB, circleA, circleB, meet];
With[
  {g = InfraSubstrate["SquareMeshGraph", "Medium", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = SelectFirst[VertexList[g], GraphDistance[g, a, #] == 4 &]},
  {scene = InfraScene[{pA, pB, circleA, circleB, meet},
     {pA == InfraPoint[a], pB == InfraPoint[b],
      circleA == InfraCircle[pA, 4], circleB == InfraCircle[pB, 4],
      meet == InfraIntersection[circleA, circleB]}]},
  {solved = FindInfraScene[scene, g]},
  {InfraSubstrateHighlight[g, Join[{a, b}, InfraSceneInstance[#, meet] & /@ solved]],
   Length @ solved}]
```

An operand of [InfraIntersection]() may be a token, bound to no name.

```wl
ClearAll[pA, pB, circleA, meet];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; FindInfraPoint[g, InfraShell[a, 4]])},
  {scene = InfraScene[{pA, pB, circleA, meet},
     {pA == InfraPoint[a], pB == InfraPoint[b], circleA == InfraCircle[pA, {4, 5}],
      meet == InfraIntersection[circleA, InfraCircle[pB, {4, 5}]]}]},
  {meets = InfraSceneInstance[#, meet] & /@ FindInfraScene[scene, g]},
  {InfraSubstrateHighlight[g, Join[{a, b}, meets]], meets}]
```
