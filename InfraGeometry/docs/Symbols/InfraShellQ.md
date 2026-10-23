---
Template: Symbol
Name: InfraShellQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraShellQ
Keywords: [shell, sphere, circle, level set, metric sphere, test]
SeeAlso: [InfraShell, InfraBallQ, InfraCircleQ, FindInfraShellCenter, InfraSphere]
---

## Usage

<code>[InfraShellQ]()[*g*, *vs*]</code> gives `True` if the vertex set *vs* is a shell of *g*: all the vertices at distance *r* from some vertex *c*.

## Details & Options

*vs* is a shell when *vs = {v : d(c, v) = r}* for a vertex *c* and a finite radius *r ≥ 0*. A single vertex is the shell of radius 0 about itself.

A shell is a whole level set: a part of one is not a shell. Being at one distance from a centre is not enough.

*vs* is a vertex list, a density `<|v -> m, …|>` read as its support, or a list of vertex lists, which passes when each one does.

In an [InfraScene](), `InfraShellQ[x]` is the assertion that *x* is a shell.

## Basic Examples

On the square grid the shell of radius 2 is a diamond. The square ring of side 4 about the same vertex is not a shell of any vertex:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {xy = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {diamond = InfraMeasurement[g, InfraShell[c, 2], "VertexDensity"]},
  {ring = AssociationThread[Select[VertexList[g], v |-> Max @ Abs[xy[v] - xy[c]] == 2], 1]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {vs, c}, PlotLabel -> InfraShellQ[g, vs]], {vs, {diamond, ring}}]]
```

A shell with one vertex removed is not a shell, on the grid and on the mesh:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small"]}, {c = First @ GraphCenter[g]},
    {shell = Keys @ InfraMeasurement[g, InfraShell[c, 3], "VertexDensity"]},
    {InfraShellQ[g, shell], InfraShellQ[g, Rest @ shell]}],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Scope

A single vertex is a shell, of radius 0:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, InfraShellQ[g, {45}]]
```

A shell cut by the rim of the graph is still a shell:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {shell = Keys @ InfraMeasurement[g, InfraShell[c, 7], "VertexDensity"]},
  InfraSubstrateHighlight[g, {shell, c}, PlotLabel -> InfraShellQ[g, shell], ImageSize -> Medium]]
```

## Possible Issues

Vertices at one distance from a centre need not form a shell. The two neighbours of 45 along one axis miss the other two:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {GraphDistance[g, 45, #] & /@ {44, 46}, InfraShellQ[g, {44, 46}]}]
```
