---
Template: Symbol
Name: FindInfraLeviCivitaConnection
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraLeviCivitaConnection
Keywords: [Levi-Civita connection, metric connection, displacement bundle, parallel transport]
SeeAlso: [InfraParallelTransport, InfraHolonomyAngle, InfraHolonomy, InfraCovariantDerivative, InfraDisplacementBundle, InfraConnectionQ, InfraConnection]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[FindInfraLeviCivitaConnection]()[[InfraDisplacementBundle]()[*g*, *r*]]</code> gives the Levi-Civita [InfraConnection](): over each edge *p* -> *q* of *g* the first of the best angle-isometries from the directions at *p* to those at *q* fixing the geodesics through *q*; its lifts that are not total edges are dropped.

## Details & Options

- The best angle-isometries over an edge are usually several. The connection keeps the first, as InfraGaugeTheory does. All of them are read by <code>[InfraParallelTransport]()[[InfraDisplacementBundle]()[*g*, *r*], *walk*]</code> and <code>[InfraHolonomyAngle]()[[InfraDisplacementBundle]()[*g*, *r*], *loop*]</code>.
- A dropped lift sends a direction to a non-adjacent direction. Where lifts are dropped, the result need not satisfy [InfraConnectionQ]().

Options:

| Option | Default | Values |
|---|---|---|
| [Method]() | `"Arclength"` | `"Arclength"`: the angle between two directions at *p* is their distance in the graph with the open ball of radius *r* about *p* deleted, over *r*; `"Alexandrov"`: the comparison angle of the polar form |

## Basic Examples

The Levi-Civita connection of the octahedron is a connection of its displacement bundle, and it is not flat. Its holonomy around a face is drawn: the face, and every direction at 1 joined to its image.

```wl
With[
  {fib = InfraFiberedSubstrate["OctahedronDisplacementBundle"]},
  {conn = FindInfraLeviCivitaConnection[fib], face = {1, 2, 3, 1}},
  {transport = InfraParallelTransport[fib, conn, face]},
  {InfraSubstrateHighlight[First @ fib, Join[{InfraWalk[face], Directive[StandardBlue]},
      InfraWalk[{Last @ First @ #, Last @ Last @ #}] & /@ Select[Normal @ transport, First @ # =!= Last @ # &]]],
    InfraConnectionQ[fib, conn], InfraFlatConnectionQ[fib, conn]}]
```

The list form gives every realisation. Around the face there are four; the connection follows one of them.

```wl
With[
  {fib = InfraFiberedSubstrate["OctahedronDisplacementBundle"]},
  {conn = FindInfraLeviCivitaConnection[fib], face = {1, 2, 3, 1}},
  {Length @ InfraParallelTransport[fib, face], MemberQ[InfraParallelTransport[fib, face], InfraParallelTransport[fib, conn, face]]}]
```

## Scope

The triangular torus from the catalogue: the hexagon around a vertex, with the Levi-Civita holonomy angle of the connection and the least angle over the realisations.

```wl
With[
  {fib = InfraFiberedSubstrate["TriangularTorusDisplacementBundle", "Small"]},
  {torusGraph = First @ fib},
  {torusVertex = First @ VertexList[torusGraph]},
  {hexagon = Append[#, First @ #] & @ FindCycle[Subgraph[torusGraph, AdjacencyList[torusGraph, torusVertex]], {6}, 1][[1, All, 1]]},
  {InfraSubstrateHighlight[torusGraph, {InfraWalk[hexagon]}], InfraHolonomyAngle[fib, FindInfraLeviCivitaConnection[fib], hexagon], InfraHolonomyAngle[fib, hexagon]}]
```

## Options

### Method

Under `"Alexandrov"` the octahedron gives the same connection.

```wl
With[
  {fib = InfraFiberedSubstrate["OctahedronDisplacementBundle"]},
  Sort @ First @ FindInfraLeviCivitaConnection[fib, Method -> "Alexandrov"] === Sort @ First @ FindInfraLeviCivitaConnection[fib]]
```
