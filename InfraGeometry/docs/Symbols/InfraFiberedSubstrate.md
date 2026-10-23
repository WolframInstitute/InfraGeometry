---
Template: Symbol
Name: InfraFiberedSubstrate
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFiberedSubstrate
Keywords: [fibered graph, fiber bundle, covering, tangent bundle, displacement bundle, example, catalogue]
SeeAlso: [InfraSubstrate, InfraFiberedGraph, InfraTangentBundle, InfraDisplacementBundle, InfraTotalSpace, InfraFibrationQ, InfraFiberBundleQ, InfraFiberedGraphHighlight]
RelatedGuides: [InfraFiberBundles, InfraSubstrates]
RelatedTutorials: [ExperimentalInfraBundles]
---

## Usage

<code>[InfraFiberedSubstrate]()[*name*, *size*]</code> gives the example fibered graph *name* at *size* `"Small"`, `"Medium"` or `"Large"`.

<code>[InfraFiberedSubstrate]()[*name*]</code> gives the `"Medium"` size.

<code>[InfraFiberedSubstrate]()[]</code> gives the names grouped by kind.

<code>[InfraFiberedSubstrate]()[All]</code> gives the list of all names.

## Details & Options

The catalogue has five groups:

| Group | Fibered graphs | Names |
|---|---|---|
| `"Trivial"` | a product of the base with a fiber | `"CycleProductBundle"` (the prism, fiber an edge), `"GridProductBundle"` (fiber a triangle) |
| `"Covering"` | twisted products | `"CycleDoubleCover"`, `"MoebiusLadderCover"`, `"TriangularTorusDoubleCover"` |
| `"Tangent"` | <code>[InfraTangentBundle]()[*g*, 2]</code> | over a grid, a triangular torus, the octahedron and a sphere mesh |
| `"Displacement"` | <code>[InfraDisplacementBundle]()[*g*, 1]</code> | over the same four bases |
| `"NonBundle"` | one vertex over one colour class of the base, an edge over the other | `"BranchedCycleFibration"`, `"BranchedGridFibration"` |

Every entry is a fibration. The trivial and covering entries are fiber bundles; the tangent, displacement and branched entries are not.

The sizes of the bases:

| Base | `"Small"` | `"Medium"` | `"Large"` |
|---|---|---|---|
| cycle | 8 | 16 | 32 |
| grid | 4 × 4 | 8 × 8 | 16 × 16 |
| triangular torus | 6 × 6 | 10 × 10 | 20 × 15 |

The grid is the full [GridGraph](). The octahedron has one size. *size* may also be a raw size of the base: the length of a cycle, the dimensions of a grid or a torus, the cell area of a sphere mesh.

A literal entry is an [InfraFiberedGraph]() with total vertices {*p*, *k*}, the *k*-th vertex over the base vertex *p*. A tangent or displacement entry is the construction itself, and the readers accept it directly.

## Basic Examples

Nine entries at the small size:

```wl
GraphicsGrid @ Partition[
  InfraFiberedGraphHighlight[InfraFiberedSubstrate[#, "Small"]] & /@ {
    "CycleProductBundle", "MoebiusLadderCover", "CycleDoubleCover",
    "GridProductBundle", "TriangularTorusDoubleCover", "BranchedGridFibration",
    "GridTangentBundle", "GridDisplacementBundle", "OctahedronDisplacementBundle"}, 3]
```

The names by group:

```wl
InfraFiberedSubstrate[]
```

## Scope

A raw size. The double cover of the cycle of length 5 is the cycle of length 10:

```wl
With[{fib = InfraFiberedSubstrate["CycleDoubleCover", 5]},
  GraphicsRow[{InfraFiberedGraphHighlight[fib], InfraTotalSpace[fib]}]]
```

A tangent entry is the construction over its base:

```wl
InfraFiberedSubstrate["GridTangentBundle", "Small"] === InfraTangentBundle[GridGraph[{4, 4}], 2]
```

## Properties and Relations

Which entries are fibrations and which are fiber bundles:

```wl
Table[name -> {InfraFibrationQ[#], InfraFiberBundleQ[#]} & @ InfraFiberedSubstrate[name, "Small"],
  {name, InfraFiberedSubstrate[All]}]
```

The prism and the Moebius ladder have isomorphic bases and isomorphic fibers, but their total graphs are not isomorphic:

```wl
With[{prism = InfraFiberedSubstrate["CycleProductBundle", "Small"]},
  {moebius = InfraFiberedSubstrate["MoebiusLadderCover", "Small"]},
  Table[IsomorphicGraphQ[f[prism], f[moebius]], {f, {InfraBaseSpace, InfraFiber[#, 1] &, InfraTotalSpace}}]]
```

## Possible Issues

The grid entries are over the full [GridGraph](), not over the square grid of [InfraSubstrate](), whose rim vertices are pendant:

```wl
{VertexCount @ InfraBaseSpace @ InfraFiberedSubstrate["GridProductBundle", "Small"],
 VertexCount @ InfraSubstrate["SquareGridGraph", "Small"]}
```
