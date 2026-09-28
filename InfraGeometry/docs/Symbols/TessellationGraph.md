---
Template: Symbol
Name: TessellationGraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/TessellationGraph
Keywords: [regular map, tessellation, Platonic solid, flat torus, hyperbolic surface, uniform tiling, Archimedean solid, Schläfli symbol]
SeeAlso: [TorusTessellation, InfraSubstrate, InfraCircle, FindInfraCircle, InfraHighlightGraph]
RelatedGuides: [EuclideanGeometryGuide]
---

## Usage

<code>[TessellationGraph]()[{*p*, *q*}]</code> is the smallest regular map of type {*p*, *q*}, as a graph: *p*-gon faces, *q* of them at every vertex.

<code>[TessellationGraph]()[{*p*, *q*}, *n*]</code> is the *n*-th map of that type: the *n* × *n* flat torus when the type is Euclidean, the *n*-th PSL(2, ℓ) quotient when it is hyperbolic.

<code>[TessellationGraph]()[{*p*, *q*}, {*m*, *n*}]</code> is the *m* × *n* flat torus of a Euclidean type.

<code>[TessellationGraph]()[{*p*, *q*}, *G*]</code> is the map carried by a (2, *p*, *q*)-generation of the finite group *G*.

<code>[TessellationGraph]()[*config*]</code> is the uniform map with vertex configuration *config*, the cyclic list of face sizes around a vertex.

## Details & Options

A regular map of type {*p*, *q*} is a closed surface cut into *p*-gons, *q* at every vertex, with a rotation taking any directed edge to any other. The graph is its 1-skeleton. The faces are not returned; every face is a cycle of length *p*.

The sign of (*p* − 2)(*q* − 2) − 4 is the sign of the curvature. It decides the surface:

| (*p* − 2)(*q* − 2) | Surface | Maps |
|---|---|---|
| < 4 | sphere | the five Platonic solids |
| = 4 | flat torus | {4, 4}, {3, 6} and {6, 3}, one per size |
| > 4 | hyperbolic surface of higher genus | quotients of the hyperbolic tiling |

The Euler characteristic *V* − *E* + *F* with *F* = 2*E*/*p* reads the surface off the graph: 2 on the sphere, 0 on the torus, negative on a hyperbolic surface.

Every map here is **closed**. A line or a circle drawn on it wraps round the surface, and on a small map the wrap is felt within a few steps. For plane geometry use the patches of [InfraSubstrate](), which are cut from the infinite tiling and have no wrap.

The flat tori are [TorusTessellation]() graphs. The uniform maps are built with the Conway operations on a regular seed: rectify, truncate and their composites. Apart from the snub cube and the snub dodecahedron, the snub and elongated families are not built, and give `$Failed` with a message.

Options:

| Option | Default | Values |
|---|---|---|
| `Method` | `Automatic` | `"Platonic"`, `"Torus"`, `"PSL2"`, `"CosetEnumeration"`, or `{"CosetEnumeration", "MaxIndex" -> n}` |

`Automatic` takes the fast construction for the curvature. `"CosetEnumeration"` searches the subgroups of low index in the (2, *p*, *q*) triangle group, up to index 24 by default. `Graph` options are passed on to the graph.

## Basic Examples

The circle of radius 1 about a vertex is its link, a *q*-cycle. On the icosahedron it has 5 vertices, on the triangulated torus 6, on the Klein quartic 7: positive, zero and negative curvature.

```wl
Row[Table[
   With[
     {map = TessellationGraph @@ spec},
     {hub = First @ VertexList[map]},
     Labeled[
       InfraHighlightGraph[map, {InfraCircle[hub, "Radius" -> 1], Directive[$InfraPointColor], hub}, ImageSize -> 200],
       First[spec]]],
   {spec, {{{3, 5}, 1}, {{3, 6}, 6}, {{3, 7}, 1}}}]]
```

Vertices, edges, faces and Euler characteristic of the five Platonic solids, three flat tori and two hyperbolic maps.

```wl
Grid[Prepend[
   Table[
     With[
       {map = TessellationGraph @@ spec},
       {nVerts = VertexCount[map], nEdges = EdgeCount[map], nFaces = 2 EdgeCount[map] / First[First[spec]]},
       {First[spec], nVerts, nEdges, nFaces, nVerts - nEdges + nFaces}],
     {spec, {{{3, 3}, 1}, {{3, 4}, 1}, {{4, 3}, 1}, {{3, 5}, 1}, {{5, 3}, 1},
       {{4, 4}, 6}, {{3, 6}, 6}, {{6, 3}, 6}, {{3, 7}, 1}, {{7, 3}, 1}}}],
   {"type", "V", "E", "F", "χ"}], Alignment -> Left]
```

## Scope

A flat torus of any shape.

```wl
VertexCount /@ {TessellationGraph[{4, 4}, {6, 4}], TessellationGraph[{3, 6}, {6, 4}], TessellationGraph[{6, 3}, {6, 4}]}
```

The second hyperbolic {3, 7} map has 156 vertices and Euler characteristic −26, so genus 14.

```wl
With[
  {map = TessellationGraph[{3, 7}, 2]},
  {VertexCount[map], VertexCount[map] - EdgeCount[map] + 2 EdgeCount[map] / 3}]
```

The map of a group: the alternating group on five letters carries the icosahedron.

```wl
IsomorphicGraphQ[TessellationGraph[{3, 5}, AlternatingGroup[5]], PolyhedronData["Icosahedron", "SkeletonGraph"]]
```

Uniform maps. The configuration {4, 6, 8} is the great rhombicuboctahedron, and {4, 4, 5} is the pentagonal prism.

```wl
{IsomorphicGraphQ[TessellationGraph[{4, 6, 8}], PolyhedronData["GreatRhombicuboctahedron", "SkeletonGraph"]],
 IsomorphicGraphQ[TessellationGraph[{4, 4, 5}], PolyhedronData[{"Prism", 5}, "SkeletonGraph"]]}
```

## Properties and Relations

A map of type {*p*, *q*} is *q*-regular.

```wl
Union @ VertexDegree @ TessellationGraph[{3, 7}]
```

The Euclidean types are the tori of [TorusTessellation]().

```wl
IsomorphicGraphQ[TessellationGraph[{3, 6}, {8, 5}], TorusTessellation[{8, 5}, "Triangular"]]
```
