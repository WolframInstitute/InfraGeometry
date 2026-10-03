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

<code>[InfraCovariantDerivative]()[[InfraDisplacementBundle]()[*g*, *r*], *conn*, [InfraSection]()[*s*], *walk*]</code> gives an association from each vertex *p* of *walk* but the last to a vertex *x*: for the step *p* -> *q*, *conn* carries <code>*s*[*q*]</code> back to *p*, the arrow from <code>*s*[*p*]</code> to that image is carried to *p* by the Levi-Civita transports at its own length, and *x* is the endpoint nearest to *p*, *x* = *p* for zero.

## Details & Options

- The derivative at *p* is the displacement *p* -> *x*. It is zero, *x* = *p*, when *conn* carries <code>*s*[*q*]</code> back to <code>*s*[*p*]</code>.
- The arrow is carried by the Levi-Civita transports whatever *conn* is. For a *conn* other than [FindInfraLeviCivitaConnection]() the result mixes the two connections.
- A vertex where *s* has no value, or where the transport is blocked, gets [Missing]().

Options:

| Option | Default | Values |
|---|---|---|
| [Method]() | `"Arclength"` | `"Arclength"`: the angle between two directions at *p* is their distance in the graph with the open ball of radius *r* about *p* deleted, over *r*; `"Alexandrov"`: the comparison angle of the polar form |

## Basic Examples

The up field on the grid along a walk to the right: the Levi-Civita connection carries each value to the next, and the derivative is zero at every step.

```wl
With[
  {fib = InfraFiberedSubstrate["GridDisplacementBundle", "Small"]},
  {g = First @ fib, conn = FindInfraLeviCivitaConnection[fib]},
  {up = InfraSection @ AssociationMap[p |-> {p, p + 1}, Select[Range[16], Mod[#, 4] != 0 &]]},
  {walk = {2, 6, 10}},
  {InfraSubstrateHighlight[g, Join[{InfraWalk[walk], Directive[StandardBlue]}, InfraWalk /@ Lookup[First @ up, walk]]],
    Normal @ InfraCovariantDerivative[fib, conn, up, walk]}]
```

A field that turns from up to the right between the first two vertices of the walk has a nonzero derivative there, and zero after.

```wl
With[
  {fib = InfraFiberedSubstrate["GridDisplacementBundle", "Small"]},
  {g = First @ fib, conn = FindInfraLeviCivitaConnection[fib]},
  {turn = InfraSection[<|2 -> {2, 3}, 6 -> {6, 10}, 10 -> {10, 14}|>]},
  {walk = {2, 6, 10}},
  {InfraSubstrateHighlight[g, Join[{InfraWalk[walk], Directive[StandardBlue]}, InfraWalk /@ Values @ First @ turn]],
    Normal @ InfraCovariantDerivative[fib, conn, turn, walk]}]
```
