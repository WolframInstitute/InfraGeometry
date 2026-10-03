---
Template: Symbol
Name: InfraFiberedSubstrate
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFiberedSubstrate
Keywords: [fibration, fiber bundle, covering, tangent bundle, displacement bundle, example, roster]
SeeAlso: [InfraSubstrate, InfraFibration, InfraTangentBundle, InfraDisplacementBundle, InfraTotalGraph, InfraFibrationQ, InfraFiberBundleQ]
RelatedGuides: [InfraFiberBundles, InfraSubstrates]
---

## Usage

<code>[InfraFiberedSubstrate]()[*name*, *size*]</code> is the example fibration *name* at *size* `"Small"`, `"Medium"` or `"Large"`.

<code>[InfraFiberedSubstrate]()[*name*]</code> is the `"Medium"` size.

<code>[InfraFiberedSubstrate]()[]</code> gives the roster, the names grouped by kind. <code>[InfraFiberedSubstrate]()[All]</code> gives the flat list of names.

## Details & Options

An entry is a fibration head: a construction [InfraTangentBundle]() or [InfraDisplacementBundle](), or a literal [InfraFibration](). Every fibration function takes it as it is.

The roster has five groups:

| Group | What it is | Names |
|---|---|---|
| `"Trivial"` | a product of the base with a fiber | `"CycleProductBundle"` (the prism), `"GridProductBundle"` (a triangle over every grid vertex) |
| `"Covering"` | twisted, locally trivial | `"CycleDoubleCover"`, `"MoebiusLadderCover"`, `"TriangularTorusDoubleCover"` |
| `"Tangent"` | `InfraTangentBundle[g, 2]` | over a grid, a triangular torus, the octahedron and a sphere mesh |
| `"Displacement"` | `InfraDisplacementBundle[g, 1]` | over the same four bases |
| `"NonBundle"` | fibers of different sizes | `"BranchedCycleFibration"`, `"BranchedGridFibration"` |

The torus and the sphere mesh are [InfraSubstrate]() graphs, drawn where they live. The grid is a full `GridGraph`. The octahedron has one size.

A literal entry has the total vertices `{p, k}`, the `k`-th vertex over the base vertex `p`. Its fiber is drawn on a small circle around `p`.

*size* may also be a raw size of the base: the length of a cycle, the dimensions of a grid or a torus, the cell area of a sphere mesh.

## Basic Examples

Nine entries at the small size. Each fiber is drawn around its base vertex.

```wl
GraphicsGrid @ Partition[
  InfraTotalGraph @ InfraFiberedSubstrate[#, "Small"] & /@ {
    "CycleProductBundle", "MoebiusLadderCover", "CycleDoubleCover",
    "GridProductBundle", "TriangularTorusDoubleCover", "BranchedGridFibration",
    "GridTangentBundle", "GridDisplacementBundle", "OctahedronDisplacementBundle"},
  3]
```

The roster.

```wl
InfraFiberedSubstrate[]
```

## Scope

The trivial and covering entries are fiber bundles. The branched entries are fibrations but not bundles.

```wl
Table[
  name -> InfraFiberBundleQ @ InfraFiberedSubstrate[name, "Small"],
  {name, Join @@ Lookup[InfraFiberedSubstrate[], {"Trivial", "Covering", "NonBundle"}]}]
```

The prism and the Moebius ladder have the same base and the same fiber. Only the twist tells them apart.

```wl
With[
  {prism = InfraTotalGraph @ InfraFiberedSubstrate["CycleProductBundle", "Small"]},
  {moebius = InfraTotalGraph @ InfraFiberedSubstrate["MoebiusLadderCover", "Small"]},
  GraphicsRow[{prism, moebius}]]
```
