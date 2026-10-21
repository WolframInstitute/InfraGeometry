---
Template: Symbol
Name: ResistanceCoordinates
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/ResistanceCoordinates
Keywords: [resistance coordinates, spectral embedding, Laplacian eigenmap, effective resistance, diffusion map, spectral drawing, Klein-Randic]
SeeAlso: [EffectiveResistance, ResistanceQ, RadarCoordinates, OrthogonalCoordinates]
RelatedGuides: [Experimental]
---

## Usage

<code>[ResistanceCoordinates]()[*g*]</code> gives the association of every vertex *v* of *g* with a point *Φ(v)* whose squared distances are the effective resistances, *‖Φ(u) − Φ(v)‖² = R(u, v)*.

<code>[ResistanceCoordinates]()[*g*, *v*]</code> gives the point *Φ(v)*.

## Details & Options

Let *0 = λ₁ < λ₂ ≤ … ≤ λₙ* be the eigenvalues of the Laplacian *L* = [KirchhoffMatrix]() of a connected graph with *n* vertices, and *φ₁, …, φₙ* orthonormal eigenvectors. Then *Φ(v) = (φ₂(v)/√λ₂, …, φₙ(v)/√λₙ)*, a point of *ℝⁿ⁻¹*.

The inner products *⟨Φ(u), Φ(v)⟩* are the entries of the pseudoinverse *L⁺*, so *‖Φ(u) − Φ(v)‖² = L⁺ᵤᵤ + L⁺ᵥᵥ − 2L⁺ᵤᵥ = R(u, v)*, the [EffectiveResistance](). The points are centred, *Σ Φ(v) = 0*, and unique up to an orthogonal map; a repeated eigenvalue lets its eigenvectors rotate.

The graph must be connected: between two components the resistance is infinite.

The point *v* can be a density; the result is then the list of the points of its vertices.

| Option | Default | Values |
|---|---|---|
| `"Rescaling"` | `"ResistanceMatching"` | the weight of the mode *φᵢ*: *1/√λᵢ*; 1 with `"None"`; *e^(−tλᵢ)* with `"Diffusion" -> t`, the diffusion map at time *t* |
| `"Dimension"` | [Automatic]() | the number of slowest modes kept: [Automatic]() or [All]() for all, *k*, or [UpTo]()[*k*] |
| `"Origin"` | [None]() | a vertex moved to 0 |

## Basic Examples

The square grid and the square mesh drawn at their two slowest modes:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small"]},
    Graph[VertexList[g], EdgeList[g], VertexCoordinates -> Normal[ResistanceCoordinates[g, "Dimension" -> 2]]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The squared distance from the point of the centre against the effective resistance, for every vertex of the mesh. The points lie on the diagonal:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g], phi = ResistanceCoordinates[g]},
  ListPlot[Table[{EffectiveResistance[g, c, u], Total[(phi[c] - phi[u])^2]}, {u, VertexList[g]}],
    AspectRatio -> 1]]
```

## Scope

The three slowest modes of the sphere mesh are coordinates in space. Drawn at them the sphere is round: every point lies at nearly the same distance from the origin:

```wl
With[{g = InfraSubstrate["SphereMeshGraph", "Small"]},
  {phi = ResistanceCoordinates[g, "Dimension" -> 3]},
  Graph3D[VertexList[g], EdgeList[g], VertexCoordinates -> Normal[phi], PlotLabel -> MinMax[Norm /@ Values[phi]]]]
```

## Options

### Rescaling

The two slowest modes of a 12 × 4 grid both run along its length, so each drawing is a curve. The plain eigenvectors weigh the two alike, the resistance matching weighs the faster one less, and the diffusion map at time 5 less again:

```wl
With[{g = GridGraph[{12, 4}]},
  GraphicsRow @ Table[
    With[{phi = ResistanceCoordinates[g, "Dimension" -> 2, "Rescaling" -> r]},
      Graph[VertexList[g], EdgeList[g], VertexCoordinates -> Normal[phi]]],
    {r, {"None", "ResistanceMatching", "Diffusion" -> 5}}]]
```

### Dimension

With fewer modes the squared distances fall below the resistances. From the centre of the mesh with 2, 10 and 40 of its 101 modes:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  ListPlot[
    Table[With[{phi = ResistanceCoordinates[g, "Dimension" -> k]},
      Table[{EffectiveResistance[g, c, u], Total[(phi[c] - phi[u])^2]}, {u, VertexList[g]}]],
      {k, {2, 10, 40, All}}],
    AspectRatio -> 1, PlotLegends -> {2, 10, 40, All}]]
```

### Origin

With the centre as the origin, the squared norm of each point is its resistance to the centre:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {phi = ResistanceCoordinates[g, "Origin" -> c]},
  {Norm[phi[c]], Chop @ Max @ Abs @ Table[Norm[phi[u]]^2 - EffectiveResistance[g, c, u], {u, VertexList[g]}]}]
```

## Properties and Relations

The inner products of the points are the entries of the pseudoinverse of the Laplacian:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {phi = Values @ ResistanceCoordinates[g]},
  Chop @ Max @ Abs[phi . Transpose[phi] - PseudoInverse[N @ KirchhoffMatrix[g]]]]
```

## Possible Issues

On a graph with two components there are no coordinates, and the call stays unevaluated:

```wl
With[{g = GraphUnion[PathGraph[{1, 2, 3}], PathGraph[{4, 5}]]},
  {EffectiveResistance[g, 1, 4], ResistanceCoordinates[g]}]
```
