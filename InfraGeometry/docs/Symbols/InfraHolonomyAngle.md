---
Template: Symbol
Name: InfraHolonomyAngle
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraHolonomyAngle
Keywords: [holonomy angle, Levi-Civita, parallel transport, curvature, arc radian, displacement bundle]
SeeAlso: [InfraDisplacementBundle, FindInfraLeviCivitaConnection, InfraParallelTransport, InfraHolonomy, InfraConnection, InfraCovariantDerivative]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[InfraHolonomyAngle]()[[InfraDisplacementBundle]()[*g*, *r*], *conn*, *loop*]</code> gives the angle by which transport along *loop* under *conn* turns the directions at the start of *loop*: the mean angle between each moved direction and its image.

<code>[InfraHolonomyAngle]()[[InfraDisplacementBundle]()[*g*, *r*], *loop*]</code> gives the least such angle over the Levi-Civita transports along *loop*.

## Details & Options

The fiber of <code>[InfraDisplacementBundle]()[*g*, *r*]</code> over *p* is the set of directions at *p*: the pairs {*p*, *v*} with *d(p, v) = r*. Transport around a loop at *p* sends each direction *u* to a direction *σ(u)*.

The holonomy angle is the mean of *∠(u, σ(u))* over the directions with *σ(u) ≠ u*. It is 0 when no direction moves. Directions whose transport is blocked are left out.

The angle is unsigned: it does not tell the sense of the rotation.

The angle between two directions *u*, *w* at *p*:

| Method | *∠(u, w)* |
|---|---|
| `"Arclength"` | *d′(u, w)/r*, with *d′* the distance in *g* with the open ball of radius *r* about *p* removed |
| `"Alexandrov"` | *arccos(1 − d(u, w)²/(2r²))*, the angle of the plane triangle with sides *r*, *r*, *d(u, w)* |

The form without a connection takes the minimum over all Levi-Civita transports, as listed by <code>[InfraParallelTransport]()[*fib*, *loop*]</code>. [FindInfraLeviCivitaConnection]() picks one of them over each edge.

Options:

| Option | Default | Values |
|---|---|---|
| [Method]() | `"Arclength"` | `"Arclength"`, `"Alexandrov"` |

## Basic Examples

Around a face of the octahedron the four directions at the vertex 1 turn by one step, an angle of 1:

```wl
With[{fib = InfraFiberedSubstrate["OctahedronDisplacementBundle"]}, {face = {1, 2, 3, 1}},
  InfraSubstrateHighlight[First @ fib, {InfraWalk[face]},
    PlotLabel -> InfraHolonomyAngle[fib, FindInfraLeviCivitaConnection[fib], face], ImageSize -> Medium]]
```

On the square grid a face gives 0. The grid is flat:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {face = {c, c + 1, c + 11, c + 10, c}}, {fib = InfraDisplacementBundle[g, 1]},
  InfraSubstrateHighlight[g, {InfraWalk[face]},
    PlotLabel -> InfraHolonomyAngle[fib, FindInfraLeviCivitaConnection[fib], face], ImageSize -> Medium]]
```

## Scope

The transport around the octahedron face. Each neighbour of 1 moves to the next one:

```wl
With[{fib = InfraFiberedSubstrate["OctahedronDisplacementBundle"]},
  InfraParallelTransport[fib, FindInfraLeviCivitaConnection[fib], {1, 2, 3, 1}]]
```

Without a connection: the number of Levi-Civita transports around the face, and the least angle among them:

```wl
With[{fib = InfraFiberedSubstrate["OctahedronDisplacementBundle"]},
  {Length @ InfraParallelTransport[fib, {1, 2, 3, 1}], InfraHolonomyAngle[fib, {1, 2, 3, 1}]}]
```

All eight faces of the octahedron give 1:

```wl
With[{fib = InfraFiberedSubstrate["OctahedronDisplacementBundle"]}, {conn = FindInfraLeviCivitaConnection[fib]},
  InfraHolonomyAngle[fib, conn, Append[#, First @ #]] & /@ (First /@ # & /@ FindCycle[First @ fib, {3}, All])]
```

## Options

### Method

With the comparison angle the same step is *π*/3, the angle of an equilateral triangle:

```wl
With[{fib = InfraFiberedSubstrate["OctahedronDisplacementBundle"]},
  InfraHolonomyAngle[fib, FindInfraLeviCivitaConnection[fib], {1, 2, 3, 1}, Method -> "Alexandrov"]]
```

## Possible Issues

The angle is unsigned. Reversing the loop turns the directions the other way, 2 to 6 instead of 2 to 3, and gives the same angle:

```wl
With[{fib = InfraFiberedSubstrate["OctahedronDisplacementBundle"]}, {conn = FindInfraLeviCivitaConnection[fib]},
  {InfraParallelTransport[fib, conn, {1, 3, 2, 1}],
   InfraHolonomyAngle[fib, conn, {1, 2, 3, 1}], InfraHolonomyAngle[fib, conn, {1, 3, 2, 1}]}]
```
