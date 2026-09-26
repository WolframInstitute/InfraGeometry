---
Template: Symbol
Name: InfraScene
Context: WolframInstitute`SyntheticInfrageometry`
ContextPath: [WolframInstitute`Infrageometry`]
Paclet: WolframInstitute/SyntheticInfrageometry
URI: WolframInstitute/SyntheticInfrageometry/ref/InfraScene
Keywords: [scene, construction, Euclid I.10, constraint, ruler and compass]
SeeAlso: [FindInfraScene, InfraGeometricStep, InfraSceneInstance, InfraSceneViewer, InfraIntersection]
RelatedGuides: [EuclideanGeometryGuide]
---

## Usage

<code>[InfraScene]()[{*objects*}, {*steps*}]</code> is a construction: a list of object names, and a list of [InfraGeometricStep]() constraints that define them.

## Details & Options

Definition: a scene names some objects and states constraints relating them. It is a construction written down, not yet carried out. [FindInfraScene]() carries it out.

This is how a ruler-and-compass construction is expressed. Each step is a constraint of the form `object == constructor[...]`, optionally with side conditions like `u != v`. Later steps may refer to objects bound by earlier ones, so the steps read in the order Euclid writes them.

Inside a scene the `Infra*` heads are **constructors**, not values. `InfraPoint[v]` names a point at *v*. `InfraSegment[p, q]` names the segment between two named points. `InfraCircle[c, r]` names a circle of radius *r* — inside a scene the token still reads *r* as a radius, unlike the head, where a bare second argument is always a point; this is an open inconsistency. `InfraIntersection[x, y]` names where two named objects meet. The names are ordinary symbols, so they must be undefined when the scene is built — `ClearAll` them first.

The whole of Euclidean construction is available: circles and their intersections are what a compass is for, so [InfraCircle]() and [InfraIntersection]() carry most of the work. Use circles, not level sets — a circle is the geometric object, and a shell is the set it was cut from.

Accessors: `["Objects"]` the names, `["Labels"]` the step labels, `["Constructions"]` the constraint for each object, `["Steps"]`, `["Assertions"]` and `["DependencyGraph"]`.

Two practical notes. Solving is done step by step, and `FindInfraScene[scene, g, k]` solves the first *k* steps, so `k` is a step index and not a count of solutions. And each step multiplies the branching: a step whose object has several admissible realisations produces one instance per combination, so the instance count grows as the construction proceeds.

**A construction can stall.** Euclid never postulated that the two circles of I.1 actually meet, and on a graph they need not. The same construction that succeeds on a triangulated mesh has no solution on a square grid, because there a single distance shell spans no cycle, so the circles do not exist. That is the continuity assumption Euclid left unstated, showing up as an empty result.

**Bind every construction to a name.** An operand of [InfraIntersection]() must be a name bound by an earlier step, not an inline constructor. Writing `InfraIntersection[cA, InfraCircle[b, 4]]` fails, because the inline constructor is never dispatched and reaches the set operation with its own head intact. Give the circle its own step and refer to it by name, as below.

## Basic Examples

Euclid I.1: two points at distance 4, the circle of radius 4 about each, and the vertices where the circles meet. On the discretized plane this succeeds.

```wl
ClearAll[a, b, cA, cB, u];
With[
  {g = InfraSubstrate["SquareMeshGraph", "Medium", "KeepCoordinates" -> True]},
  {p1 = First @ GraphCenter[g]},
  {p2 = SelectFirst[VertexList[g], GraphDistance[g, p1, #] == 4 &]},
  {scene = InfraScene[{a, b, cA, cB, u},
     {InfraGeometricStep[{a == InfraPoint[p1]}, "point a"],
      InfraGeometricStep[{b == InfraPoint[p2]}, "point b"],
      InfraGeometricStep[{cA == InfraCircle[a, 4]}, "circle around a"],
      InfraGeometricStep[{cB == InfraCircle[b, 4]}, "circle around b"],
      InfraGeometricStep[{u == InfraIntersection[cA, cB]}, "they meet"]}]},
  <|"objects" -> scene["Objects"], "labels" -> scene["Labels"]|>]
```

Solving it. The third argument is the step to solve up to, and the last step binds every object.

```wl
ClearAll[a, b, cA, cB, u];
With[
  {g = InfraSubstrate["SquareMeshGraph", "Medium", "KeepCoordinates" -> True]},
  {p1 = First @ GraphCenter[g]},
  {p2 = SelectFirst[VertexList[g], GraphDistance[g, p1, #] == 4 &]},
  {scene = InfraScene[{a, b, cA, cB, u},
     {InfraGeometricStep[{a == InfraPoint[p1]}, "point a"],
      InfraGeometricStep[{b == InfraPoint[p2]}, "point b"],
      InfraGeometricStep[{cA == InfraCircle[a, 4]}, "circle around a"],
      InfraGeometricStep[{cB == InfraCircle[b, 4]}, "circle around b"],
      InfraGeometricStep[{u == InfraIntersection[cA, cB]}, "they meet"]}]},
  {solved = FindInfraScene[scene, g, 5]},
  <|"instances" -> Length[solved], "bound objects" -> Keys @ First @ First[solved]|>]
```

On a square grid the same construction finds nothing: at a single radius there is no circle at all, so there is nothing to meet.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {p1 = First @ GraphCenter[g]},
  {p2 = SelectFirst[VertexList[g], GraphDistance[g, p1, #] == 4 &]},
  {Length @ FindInfraCircle[g, p1, "Radius" -> 4, All], Length @ FindInfraCircle[g, p2, "Radius" -> 4, All]}]
```
