---
Template: Symbol
Name: InfraFiberedSubstrate
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFiberedSubstrate
Keywords: [fibration, fiber bundle, covering, tangent bundle, displacement bundle, example, roster]
SeeAlso: [InfraSubstrate, InfraFiberedGraph, InfraTangentBundle, InfraDisplacementBundle, InfraTotalSpace, InfraFibrationQ, InfraFiberBundleQ, FindInfraLeviCivitaConnection]
RelatedGuides: [InfraFiberBundles, InfraSubstrates]
RelatedTutorials: [ExperimentalInfraBundles]
---

## Usage

<code>[InfraFiberedSubstrate]()[*name*, *size*]</code> is the example fibered graph *name* at *size* `"Small"`, `"Medium"` or `"Large"`.

<code>[InfraFiberedSubstrate]()[*name*]</code> is the `"Medium"` size.

<code>[InfraFiberedSubstrate]()[]</code> gives the roster, the names grouped by kind. <code>[InfraFiberedSubstrate]()[All]</code> gives the flat list of names.

## Details & Options

- This is a particular Experimental construction in the Infra Fiber Bundles category. Its existing call forms remain available.


An entry is a fibered-graph construction: a construction [InfraTangentBundle]() or [InfraDisplacementBundle](), or a literal [InfraFiberedGraph](). The general readers accept these construction heads.

The roster has five groups:

| Group | What it is | Names |
|---|---|---|
| `"Trivial"` | a product of the base with a fiber | `"CycleProductBundle"` (the prism), `"GridProductBundle"` (a triangle over every grid vertex) |
| `"Covering"` | twisted, locally trivial | `"CycleDoubleCover"`, `"MoebiusLadderCover"`, `"TriangularTorusDoubleCover"` |
| `"Tangent"` | `InfraTangentBundle[g, 2]` | over a grid, a triangular torus, the octahedron and a sphere mesh |
| `"Displacement"` | `InfraDisplacementBundle[g, 1]` | over the same four bases |
| `"NonBundle"` | fibers of different sizes | `"BranchedCycleFibration"`, `"BranchedGridFibration"` |

The torus and sphere mesh use the corresponding combinatorial base graphs. The grid is a full `GridGraph`. The octahedron has one size.

A literal entry has total vertices `{p, k}`, the `k`-th vertex over the base vertex `p`. Structural evaluation stores no drawing coordinates; [InfraFiberedGraphHighlight]() arranges its fibers over the base.

*size* may also be a raw size of the base: the length of a cycle, the dimensions of a grid or a torus, the cell area of a sphere mesh.

## Basic Examples

Nine entries at the small size. Each marked fiber is arranged around its base vertex.

```wl
SeedRandom[ 7 ];
GraphicsGrid @ Partition[
  InfraFiberedGraphHighlight[ InfraFiberedSubstrate[ #, "Small" ] ] & /@ {
    "CycleProductBundle", "MoebiusLadderCover", "CycleDoubleCover",
    "GridProductBundle", "TriangularTorusDoubleCover", "BranchedGridFibration",
    "GridTangentBundle", "GridDisplacementBundle", "OctahedronDisplacementBundle"},
  3]
```

The roster.

```wl
SeedRandom[ 7 ];
Normal @ InfraFiberedSubstrate[]
```

## Scope

The trivial and covering entries are fiber bundles. The branched entries are fibrations but not bundles.

```wl
SeedRandom[ 7 ];
Table[
  name -> InfraFiberBundleQ @ InfraFiberedSubstrate[name, "Small"],
  {name, Join @@ Lookup[InfraFiberedSubstrate[], {"Trivial", "Covering", "NonBundle"}]}]
```

The prism and the Moebius ladder have the same base and the same fiber. Only the twist tells them apart.

```wl
SeedRandom[ 7 ];
With[
  {prism = InfraTotalSpace @ InfraFiberedSubstrate["CycleProductBundle", "Small"]},
  {moebius = InfraTotalSpace @ InfraFiberedSubstrate["MoebiusLadderCover", "Small"]},
  GraphicsRow[{prism, moebius}]]
```

## Possible Issues

The tangent and displacement entries are fibrations, but not fiber bundles in the sense of [InfraFiberBundleQ]().

```wl
SeedRandom[ 7 ];
Table[
  name -> {InfraFibrationQ[#], InfraFiberBundleQ[#]} & @ InfraFiberedSubstrate[name, "Small"],
  {name, {"GridTangentBundle", "GridDisplacementBundle", "OctahedronTangentBundle", "OctahedronDisplacementBundle"}}]
```
