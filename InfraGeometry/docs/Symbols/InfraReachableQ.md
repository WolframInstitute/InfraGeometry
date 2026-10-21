---
Template: Symbol
Name: InfraReachableQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraReachableQ
Keywords: [reachable, connected component, path, connectivity, test]
SeeAlso: [InfraDistance, InfraWalkQ, ConnectedComponents, VertexComponent, GraphDistance]
---

## Usage

<code>[InfraReachableQ]()[*g*, *p*, *q*]</code> gives `True` if a walk in *g* joins a vertex of *p* to a vertex of *q*.

## Details & Options

*p* and *q* are vertices, vertex lists or regions such as <code>[InfraBall]()[*c*, *r*]</code>. The test is whether some vertex of *p* and some vertex of *q* lie in one connected component of *g*, that is *d(u, v) < ∞* for some *u* in *p* and *v* in *q*.

On a connected graph every two vertices are reachable.

## Basic Examples

The square grid cut along the column of vertices 6, 16, …, 96 falls into two parts. The vertex 47 lies across the cut from the centre, 43 on the same side:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {cut = VertexDelete[g, Select[VertexList[g], Mod[#, 10] == 6 &]]},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[cut, {45, q}, PlotLabel -> InfraReachableQ[cut, 45, q]], {q, {47, 43}}]]
```

## Scope

A vertex list is reachable when one of its vertices is:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {cut = VertexDelete[g, Select[VertexList[g], Mod[#, 10] == 6 &]]},
  {InfraReachableQ[cut, 45, {47, 48}], InfraReachableQ[cut, 45, {47, 43}]}]
```

A ball lies in one component, however large:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {cut = VertexDelete[g, Select[VertexList[g], Mod[#, 10] == 6 &]]},
  Table[InfraReachableQ[cut, InfraBall[45, r], 47], {r, {1, 5, 20}}]]
```

## Properties and Relations

For two vertices the test is a finite distance:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {cut = VertexDelete[g, Select[VertexList[g], Mod[#, 10] == 6 &]]},
  {GraphDistance[cut, 45, 47], GraphDistance[cut, 45, 43]}]
```
