---
Template: Symbol
Name: InfraCovariantDerivative
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraCovariantDerivative
Keywords: [covariant derivative, Levi-Civita, vector field, displacement, section]
SeeAlso: [FindInfraLeviCivitaConnection, InfraParallelTransport, InfraSection, InfraDisplacementBundle, InfraHolonomyAngle]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[InfraCovariantDerivative]()[[InfraDisplacementBundle]()[*g*, *r*], *conn*, [InfraSection]()[*s*], *walk*]</code> gives the covariant derivative of the vector field *s* along *walk*: an association from each vertex *p* of *walk* but the last to a vertex *x*, the derivative being the vector *p* → *x*.

## Details & Options

The field *s* sends a vertex *p* to a pair {*p*, *v*}, the vector *p* → *v*. For a step *p* → *q* of the walk:

- *conn* carries *s(q)* back to a vector *p* → *v′* at *p*;
- the arrow *v* → *v′* is carried to *p* along a shortest path from *v*, by the Levi-Civita transports at its own length *d(v, v′)*;
- *x* is the endpoint of the carried arrow nearest to *p*.

The derivative is zero, *x = p*, exactly when *conn* carries *s(q)* back to *s(p)*.

At the centre of the square grid the Levi-Civita connection is the translation, and in the examples below the derivative is the difference of the vectors: *x − p = s(q) − s(p)* in coordinates.

The arrow is carried by the Levi-Civita transports whatever *conn* is. A vertex where *s* has no value gets [Missing]().

| Option | Default | Values |
|---|---|---|
| [Method]() | `"Arclength"` | the angle used by the Levi-Civita transports, as in [FindInfraLeviCivitaConnection](): `"Arclength"` or `"Alexandrov"` |

## Basic Examples

In the numbering of the small square grid, *p* + 1 is the vertex above *p* and *p* + 10 the vertex to its right; 45 is the centre. The field pointing up, along a walk to the right, has derivative zero at every step:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {fib = InfraDisplacementBundle[g, 1], walk = {45, 55, 65, 75}},
  {up = InfraSection @ AssociationMap[p |-> {p, p + 1}, walk]},
  {derivative = InfraCovariantDerivative[fib, FindInfraLeviCivitaConnection[fib], up, walk]},
  InfraSubstrateHighlight[g, {InfraWalk[walk], InfraWalk /@ Values[First @ up]}, PlotLabel -> derivative,
    ImageSize -> Medium]]
```

A field that points up at 45 and to the right at 55 and 65. Its derivative at 45 is the vector from 45 to 54, one step right and one down, the difference of the two vectors; at 55 it is zero:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {fib = InfraDisplacementBundle[g, 1], walk = {45, 55, 65}},
  {turn = InfraSection[<|45 -> {45, 46}, 55 -> {55, 65}, 65 -> {65, 75}|>]},
  {derivative = InfraCovariantDerivative[fib, FindInfraLeviCivitaConnection[fib], turn, walk]},
  InfraSubstrateHighlight[g, {InfraWalk[walk], InfraWalk /@ Values[First @ turn], InfraSegment[45, derivative[45]]},
    PlotLabel -> derivative, ImageSize -> Medium]]
```

## Properties and Relations

On the grid the derivative over the step 45 → 55 is *s(55) − s(45)* in coordinates. With *s(45)* pointing up and *s(55)* pointing up, right, down and left:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {xy = AssociationThread[VertexList[g], Round @ GraphEmbedding[g]], fib = InfraDisplacementBundle[g, 1]},
  {conn = FindInfraLeviCivitaConnection[fib]},
  Table[
    {xy[InfraCovariantDerivative[fib, conn, InfraSection[<|45 -> {45, 46}, 55 -> {55, w}|>], {45, 55}][45]] - xy[45],
      (xy[w] - xy[55]) - (xy[46] - xy[45])},
    {w, {56, 65, 54, 45}}]]
```

## Options

### Method

On the grid the comparison angle gives the same derivative:

```wl
With[{fib = InfraDisplacementBundle[InfraSubstrate["SquareGridGraph", "Small"], 1]},
  {conn = FindInfraLeviCivitaConnection[fib], turn = InfraSection[<|45 -> {45, 46}, 55 -> {55, 65}, 65 -> {65, 75}|>]},
  Table[InfraCovariantDerivative[fib, conn, turn, {45, 55, 65}, Method -> m], {m, {"Arclength", "Alexandrov"}}]]
```

## Possible Issues

The field must have a value at both ends of a step. Without a value at 65 the derivative at 55 is missing:

```wl
With[{fib = InfraDisplacementBundle[InfraSubstrate["SquareGridGraph", "Small"], 1]},
  {partial = InfraSection[<|45 -> {45, 46}, 55 -> {55, 56}|>]},
  InfraCovariantDerivative[fib, FindInfraLeviCivitaConnection[fib], partial, {45, 55, 65}]]
```
