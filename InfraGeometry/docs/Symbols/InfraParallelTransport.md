---
Template: Symbol
Name: InfraParallelTransport
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraParallelTransport
Keywords: [parallel transport, connection, Levi-Civita, realisation, walk]
SeeAlso: [InfraConnection, InfraHolonomy, InfraHolonomyAngle, FindInfraLeviCivitaConnection, FindInfraHorizontalLift, InfraDisplacementBundle]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[InfraParallelTransport]()[*fib*, *conn*, *walk*]</code> gives the transport along *walk* of the fiber over its first vertex, an association from each fiber vertex to the end of its horizontal lift; vertices whose lift is blocked are dropped.

<code>[InfraParallelTransport]()[[InfraDisplacementBundle]()[*g*, *r*], *walk*]</code> gives the Levi-Civita transports along *walk*, a list with one transport for each choice among the best angle-isometries over its edges.

## Details & Options

- With a connection, a fiber vertex follows the unique edge of *conn* over each step of *walk*.
- Without a connection, over each step *p* -> *q* the transports are the injections of the direction sphere at *p* into the direction sphere at *q* that best match their angles, with the geodesics through *q* kept straight. There are usually several. The list holds every composite along *walk*, without duplicates.
- [FindInfraLeviCivitaConnection]() keeps the first transport over each edge. [InfraHolonomyAngle]() without a connection is the least angle over the list.
- The Levi-Civita realisations are listed in full, with no cap. A long walk through vertices with many directions can give many of them.

Options of the Levi-Civita form:

| Option | Default | Values |
|---|---|---|
| [Method]() | `"Arclength"` | `"Arclength"`: the angle between two directions at *p* is their distance in the graph with the open ball of radius *r* about *p* deleted, over *r*; `"Alexandrov"`: the comparison angle of the polar form |

## Basic Examples

On the Moebius ladder the transport around the cycle swaps the two sheets. The two lifts are drawn.

```wl
With[
  {fib = InfraFiberedSubstrate["MoebiusLadderCover", "Small"]},
  {total = InfraTotalGraph[fib]},
  {conn = InfraConnection @ Select[EdgeList[total], First @ First @ # =!= First @ Last @ # &]},
  {loop = Append[Range[8], 1]},
  {InfraSubstrateHighlight[total, InfraWalk @ First @ FindInfraHorizontalLift[fib, conn, #, loop, 1] & /@ {{1, 1}, {1, 2}}],
    Normal @ InfraParallelTransport[fib, conn, loop]}]
```

The Levi-Civita transports of the directions at 1 around a face of the octahedron. There are four, each drawn as the face with every direction joined to its image.

```wl
With[
  {fib = InfraFiberedSubstrate["OctahedronDisplacementBundle"]},
  {oct = First @ fib, face = {1, 2, 3, 1}},
  {transports = InfraParallelTransport[fib, face]},
  GraphicsRow[
    InfraSubstrateHighlight[oct, Join[{InfraWalk[face], Directive[StandardBlue]},
      InfraWalk[{Last @ First @ #, Last @ Last @ #}] & /@ Select[Normal @ #, First @ # =!= Last @ # &]]] & /@ transports]]
```

## Scope

The single Levi-Civita connection transports along one of the realisations. Over an edge of the octahedron there are two, and the connection takes the first.

```wl
With[
  {fib = InfraFiberedSubstrate["OctahedronDisplacementBundle"]},
  {conn = FindInfraLeviCivitaConnection[fib]},
  {Length @ InfraParallelTransport[fib, {1, 2}], InfraParallelTransport[fib, conn, {1, 2}] === First @ InfraParallelTransport[fib, {1, 2}]}]
```
