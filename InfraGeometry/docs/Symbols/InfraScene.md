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

The right side of a construction is a token: an inert head with objects in place of points. [InfraPoint]()`[v]` is the vertex *v*, and <code>[InfraPoint]()[*v*, *d*]</code> every vertex at distance *d* from *v*. [InfraSegment]()`[x, y]` is a geodesic from *x* to *y*, and [InfraRay]()`[x, y]` and [InfraLine]()`[x, y]` a ray and a line. [InfraCircle]()`[x, r]` is a circle about *x* at radius *r*, or in the band `{r, s}`. [InfraIntersection]()`[x, y]` is a vertex the two objects share; an operand may be a token itself.

A token stands for its realisations, and each realisation is one branch. So a construction binds its object to a single vertex, or a single vertex list, per branch, and the branches multiply from one construction to the next.

Inside a scene the token `InfraCircle[x, r]` reads *r* as a radius. As a head, a bare second argument of [InfraCircle]() is always a point. This is an open inconsistency.

An assertion is a predicate on objects: a comparison of [InfraDistance]() values, or one of the `Infra*Q` tests without its graph (`InfraSegmentQ[s]`, `InfraCircleQ[c]`, `InfraParallelQ[l1, l2]` and a few more). The graph is supplied when the scene is solved, and a branch survives only if every assertion holds on it. An `Infra*Q` test that cannot be given the graph is refused with `InfraScene::badassertion`.

Without [InfraStep](), the steps are the levels of the dependency graph of the constructions: first the objects that depend on no other object, then those that depend only on them, and so on. With it, the steps are the ones written, in order.

The objects are ordinary symbols, so they must have no value when the scene is built; `ClearAll` them first.

A scene answers `"Objects"`, `"Constructions"`, `"Assertions"`, `"Steps"`, `"Labels"` and `"DependencyGraph"`. The dependency graph is `None` when the steps are written by hand.

**A construction can stall.** Euclid never postulated that the two circles of I.1 meet, and on a graph they need not. On a square grid a single distance shell spans no cycle, so the circles of I.1 at one radius do not exist. That is the continuity assumption Euclid left unstated, showing up as an empty result. A band two radii thick carries the circles, and there the construction goes through.

## Basic Examples

Euclid I.1 on a square grid: two points four steps apart, a circle in the band `{4, 5}` about each, and the vertices where the circles meet. There are four, two on each side of the base, since on a lattice two circles meet along an edge rather than at a vertex.

```wl
ClearAll[pA, pB, circleA, circleB, meet];
With[
  {g = GridGraph[{13, 13}]},
  {scene = InfraScene[{pA, pB, circleA, circleB, meet},
     {InfraStep[{pA == InfraPoint[83]}, "point A"],
      InfraStep[{pB == InfraPoint[87]}, "point B"],
      InfraStep[{circleA == InfraCircle[pA, {4, 5}]}, "circle about A"],
      InfraStep[{circleB == InfraCircle[pB, {4, 5}]}, "circle about B"],
      InfraStep[{meet == InfraIntersection[circleA, circleB]}, "where they meet"]}]},
  With[{solved = FindInfraScene[scene, g]},
    With[{first = First @ solved},
      InfraSubstrateHighlight[g,
        Join[{InfraWalk[Append[#, First @ #]] & @ InfraSceneInstance[first, circleA],
              InfraWalk[Append[#, First @ #]] & @ InfraSceneInstance[first, circleB],
              Directive[$InfraPointColor], 83, 87},
          InfraSceneInstance[#, meet] & /@ solved],
        "ThicknessRange" -> 4, ImageSize -> 250]]]]
```

The objects, the step labels and the steps.

```wl
ClearAll[pA, pB, circleA, circleB, meet];
With[
  {scene = InfraScene[{pA, pB, circleA, circleB, meet},
     {InfraStep[{pA == InfraPoint[83]}, "point A"],
      InfraStep[{pB == InfraPoint[87]}, "point B"],
      InfraStep[{circleA == InfraCircle[pA, {4, 5}]}, "circle about A"],
      InfraStep[{circleB == InfraCircle[pB, {4, 5}]}, "circle about B"],
      InfraStep[{meet == InfraIntersection[circleA, circleB]}, "where they meet"]}]},
  {scene["Objects"], scene["Labels"], scene["Steps"]}]
```

The same construction without steps: they are read off the dependencies, three levels deep.

```wl
ClearAll[pA, pB, circleA, circleB, meet];
With[
  {scene = InfraScene[{pA, pB, circleA, circleB, meet},
     {pA == InfraPoint[83], pB == InfraPoint[87],
      circleA == InfraCircle[pA, {4, 5}], circleB == InfraCircle[pB, {4, 5}],
      meet == InfraIntersection[circleA, circleB]}]},
  {scene["Steps"], scene["DependencyGraph"]}]
```

An assertion keeps the branches it holds on. Of the four meeting vertices, one is nearer to the corner 1 than *A* is.

```wl
ClearAll[pA, pB, circleA, circleB, meet];
With[
  {g = GridGraph[{13, 13}]},
  {scene = InfraScene[{pA, pB, circleA, circleB, meet},
     {pA == InfraPoint[83], pB == InfraPoint[87],
      circleA == InfraCircle[pA, {4, 5}], circleB == InfraCircle[pB, {4, 5}],
      meet == InfraIntersection[circleA, circleB],
      InfraDistance[meet, 1] < InfraDistance[pA, 1]}]},
  {scene["Assertions"], InfraSceneInstance[#, meet] & /@ FindInfraScene[scene, g]}]
```

## Properties and Relations

At a single radius the grid has no circle, so the construction finds nothing.

```wl
ClearAll[pA, pB, circleA, circleB, meet];
With[
  {g = GridGraph[{13, 13}]},
  {scene = InfraScene[{pA, pB, circleA, circleB, meet},
     {pA == InfraPoint[83], pB == InfraPoint[87],
      circleA == InfraCircle[pA, 4], circleB == InfraCircle[pB, 4],
      meet == InfraIntersection[circleA, circleB]}]},
  {Length @ FindInfraCircle[g, 83, "Radius" -> 4, All], FindInfraScene[scene, g]}]
```

On the discretized plane a single radius suffices: its shells are cycles by accident of the mesh.

```wl
ClearAll[pA, pB, circleA, circleB, meet];
With[
  {g = InfraSubstrate["SquareMeshGraph", "Medium", "KeepCoordinates" -> True]},
  {centre = First @ GraphCenter[g]},
  {farPoint = SelectFirst[VertexList[g], GraphDistance[g, centre, #] == 4 &]},
  {scene = InfraScene[{pA, pB, circleA, circleB, meet},
     {pA == InfraPoint[centre], pB == InfraPoint[farPoint],
      circleA == InfraCircle[pA, 4], circleB == InfraCircle[pB, 4],
      meet == InfraIntersection[circleA, circleB]}]},
  Length @ FindInfraScene[scene, g]]
```

An operand of [InfraIntersection]() may be a token, bound to no name.

```wl
ClearAll[pA, pB, circleA, meet];
With[
  {g = GridGraph[{13, 13}]},
  {scene = InfraScene[{pA, pB, circleA, meet},
     {pA == InfraPoint[83], pB == InfraPoint[87], circleA == InfraCircle[pA, {4, 5}],
      meet == InfraIntersection[circleA, InfraCircle[pB, {4, 5}]]}]},
  InfraSceneInstance[#, meet] & /@ FindInfraScene[scene, g]]
```
