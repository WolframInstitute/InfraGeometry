---
Template: Symbol
Name: InfraHolonomyAngle
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraHolonomyAngle
Keywords: [holonomy angle, Levi-Civita, curvature, arc radian, displacement bundle]
SeeAlso: [InfraDisplacementBundle, InfraConnection, InfraParallelTransport, InfraHolonomy, FindInfraLeviCivitaConnection, InfraCovariantDerivative]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[InfraHolonomyAngle]()[[InfraDisplacementBundle]()[*g*, *r*], *conn*, *loop*]</code> gives the unsigned rotation angle of the directions around *loop* under *conn*: the mean angle between each moved direction and its image, in arc radians.

<code>[InfraHolonomyAngle]()[[InfraDisplacementBundle]()[*g*, *r*], *loop*]</code> gives the least such angle over the Levi-Civita transports of [InfraParallelTransport]().

## Details & Options

- The angle is a mean of unsigned angles, so it does not tell the sense of the rotation. Directions that do not move, and directions whose transport is blocked, are left out.
- The form without a connection is InfraGaugeTheory's holonomy angle: the least angle over every choice among the best angle-isometries along the loop.

Options:

| Option | Default | Values |
|---|---|---|
| [Method]() | `"Arclength"` | `"Arclength"`: the angle between two directions at *p* is their distance in the graph with the open ball of radius *r* about *p* deleted, over *r*; `"Alexandrov"`: the comparison angle of the polar form |

## Basic Examples

The Levi-Civita connection of the octahedron and a face: the directions at 1 turn by one arc radian.

```wl
With[
  {fib = InfraFiberedSubstrate["OctahedronDisplacementBundle"]},
  {face = {1, 2, 3, 1}},
  {InfraSubstrateHighlight[First @ fib, {InfraWalk[face]}], InfraHolonomyAngle[fib, FindInfraLeviCivitaConnection[fib], face]}]
```

The least angle over the four Levi-Civita transports around the same face.

```wl
With[
  {fib = InfraFiberedSubstrate["OctahedronDisplacementBundle"]},
  {face = {1, 2, 3, 1}},
  {InfraSubstrateHighlight[First @ fib, {InfraWalk[face]}], Length @ InfraParallelTransport[fib, face], InfraHolonomyAngle[fib, face]}]
```

## Options

### Method

Under the comparison angle of the polar form the same face gives $\pi/3$.

```wl
With[
  {fib = InfraFiberedSubstrate["OctahedronDisplacementBundle"]},
  {face = {1, 2, 3, 1}},
  {InfraSubstrateHighlight[First @ fib, {InfraWalk[face]}], InfraHolonomyAngle[fib, FindInfraLeviCivitaConnection[fib], face, Method -> "Alexandrov"]}]
```
