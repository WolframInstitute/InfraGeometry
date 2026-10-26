---
Template: Symbol
Name: FindInfraLeviCivitaConnection
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraLeviCivitaConnection
Keywords: [Levi-Civita connection, metric connection, displacement bundle, parallel transport, holonomy]
SeeAlso: [InfraParallelTransport, InfraHolonomyAngle, InfraHolonomy, InfraCovariantDerivative, InfraDisplacementBundle, InfraConnectionQ, InfraConnection]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[FindInfraLeviCivitaConnection]()[[InfraDisplacementBundle]()[*g*, *r*]]</code> gives the Levi-Civita [InfraConnection]() of the displacement bundle: over each edge *p* – *q* of *g*, a map of the directions at *p* to the directions at *q* that best keeps the angles between them and continues the geodesics through *q* straight.

## Details & Options

The directions at *p* are the vertices of the sphere *Sᵣ(p)*. Over an edge *p* – *q* the candidates are the one-to-one maps from the smaller of *Sᵣ(p)*, *Sᵣ(q)* into the larger that send each direction whose geodesic passes through *q* to its straightest continuation. The best change the angles between directions least, in the sum of squares.

The best maps are usually several. The connection keeps the first; <code>[InfraParallelTransport]()[[InfraDisplacementBundle]()[*g*, *r*], *walk*]</code> gives all.

A lift *(p, u) → (q, w)* with *u ≠ w* and *u*, *w* not adjacent is not an edge of the displacement bundle and is dropped. Where lifts are dropped, or the spheres differ in size, the result is not a connection in the sense of [InfraConnectionQ]().

On the square grid at scale 1, away from the rim, the connection is the translation *(p, p + e) → (q, q + e)*, and it is flat. On the square torus it is a flat connection. On the octahedron it is a connection, and going around a face turns the four directions at a vertex by one step.

| Option | Default | Values |
|---|---|---|
| [Method]() | `"Arclength"` | `"Arclength"`: the angle of directions *u*, *w* at *p* is their distance in *g* without the open ball of radius *r* about *p*, over *r*; `"Alexandrov"`: the comparison angle from the polar form |

## Basic Examples

The transport over an edge at the centre at scale 1, each direction and its image in one colour. On the grid each direction goes to the parallel one. On the mesh the centre has seven directions and its neighbour five, and only two lifts are edges of the bundle:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {fib = InfraDisplacementBundle[g, 1], q = First @ AdjacencyList[g, c]},
    {transport = InfraParallelTransport[fib, FindInfraLeviCivitaConnection[fib], {c, q}]},
    InfraSubstrateHighlight[g, KeyValueMap[{InfraWalk[#1], InfraWalk[#2]} &, transport]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

On the grid the connection is the translation on every edge whose ends are at distance at least 2 from the rim: a lift from *(p, u)* to *(q, w)* has *w − q = u − p* in coordinates.

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {xy = AssociationThread[VertexList[g], Round @ GraphEmbedding[g]], fib = InfraDisplacementBundle[g, 1]},
  {conn = FindInfraLeviCivitaConnection[fib]},
  {inner = Select[VertexList[g], Min[xy[#]] >= 3 && Max[xy[#]] <= 8 &]},
  {lifts = Select[First @ conn, SubsetQ[inner, First /@ List @@ #] &]},
  {Length[lifts], Union[(xy[#[[2, 2]]] - xy[#[[2, 1]]]) - (xy[#[[1, 2]]] - xy[#[[1, 1]]]) & /@ lifts]}]
```

On the square torus, with no rim, the connection is flat. On the octahedron it is a connection but not flat:

```wl
With[{torus = InfraDisplacementBundle[InfraSubstrate["SquareTorusGraph", "Small"], 1]},
  {octahedron = InfraFiberedSubstrate["OctahedronDisplacementBundle"]},
  Table[{InfraConnectionQ[fib, #], InfraTrivialMonodromyQ[fib, #]} & @ FindInfraLeviCivitaConnection[fib],
    {fib, {torus, octahedron}}]]
```

## Scope

On the octahedron, going around a face turns the four directions at its first vertex by one step, around the square they form:

```wl
With[{fib = InfraFiberedSubstrate["OctahedronDisplacementBundle"]}, {conn = FindInfraLeviCivitaConnection[fib]},
  {VertexList @ InfraFiber[fib, 1], InfraHolonomy[fib, conn, {1, 2, 3, 1}],
    InfraHolonomyAngle[fib, conn, {1, 2, 3, 1}]}]
```

## Options

### Method

On the octahedron `"Alexandrov"` gives the same connection:

```wl
With[{fib = InfraFiberedSubstrate["OctahedronDisplacementBundle"]},
  Sort @ First @ FindInfraLeviCivitaConnection[fib, Method -> "Alexandrov"] ===
    Sort @ First @ FindInfraLeviCivitaConnection[fib]]
```

## Possible Issues

Around a face of the octahedron there are four best transports. The connection follows one of them, chosen by the order of the vertices and edges:

```wl
With[{fib = InfraFiberedSubstrate["OctahedronDisplacementBundle"]}, {face = {1, 2, 3, 1}},
  {all = InfraParallelTransport[fib, face]},
  {chosen = InfraParallelTransport[fib, FindInfraLeviCivitaConnection[fib], face]},
  {Length[all], MemberQ[all, chosen]}]
```
