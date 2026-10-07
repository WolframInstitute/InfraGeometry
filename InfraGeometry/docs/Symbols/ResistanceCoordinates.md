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

<code>[ResistanceCoordinates]()[*g*]</code> gives the association of every vertex *v* of *g* with a point Φ(*v*) whose squared distances are the effective resistances: ‖Φ(*u*) − Φ(*v*)‖² = *R*(*u*, *v*).

<code>[ResistanceCoordinates]()[*g*, *v*]</code> gives the point Φ(*v*) of the vertex *v*.

## Details & Options

Definition: let 0 = λ₁ < λ₂ ≤ … ≤ λₙ be the eigenvalues of the Laplacian *L* = *D* − *A* of a connected graph *g* with *n* vertices, [KirchhoffMatrix](), and φ₁, …, φₙ orthonormal eigenvectors. Then Φ(*v*) = (φ₂(*v*)/√λ₂, …, φₙ(*v*)/√λₙ), a point of ℝⁿ⁻¹.

Since the pseudoinverse of *L* is *L*⁺ = Σᵢ φᵢ φᵢᵀ/λᵢ over *i* ≥ 2, the inner products ⟨Φ(*u*), Φ(*v*)⟩ are the entries of *L*⁺, and ‖Φ(*u*) − Φ(*v*)‖² = *L*⁺ᵤᵤ + *L*⁺ᵥᵥ − 2*L*⁺ᵤᵥ is the [EffectiveResistance]() *R*(*u*, *v*). The points are centred, Σᵥ Φ(*v*) = 0, and unique up to an orthogonal map: the eigenvectors of a repeated eigenvalue may be rotated.

On a graph with *c* components the *c* zero eigenvalues are dropped and the points lie in ℝⁿ⁻ᶜ; points of different components then lie at a finite distance.

With `"Dimension"` -> *k* only the *k* slowest modes are kept. The points then give a spectral drawing of *g*, and their squared distances are at most the resistances.

| Option | Default | |
|---|---|---|
| `"Rescaling"` | `"ResistanceMatching"` | the weight of the mode φᵢ: 1/√λᵢ, or 1 with `"None"`, or e^(−*t* λᵢ) with `"Diffusion"` -> *t*, the diffusion map at time *t* |
| `"Dimension"` | [Automatic]() | the number of modes kept: [Automatic]() or [All]() for all of them, *k*, or [UpTo]()[*k*] |
| `"Origin"` | [None]() | a vertex moved to 0 |

The point *v* may also be a density; the result is then the list of the points of its vertices.

## Basic Examples

The square, hexagonal and triangular tilings drawn at their two slowest modes, and the dimension of the whole embedding, one less than the number of vertices.

```wl
With[
  {graphs = InfraSubstrate[#, "Small"] & /@ {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}},
  {GraphicsRow[Graph[VertexList[#], EdgeList[#], VertexCoordinates -> Normal[ResistanceCoordinates[#, "Dimension" -> 2]]] & /@ graphs],
   Length[First[ResistanceCoordinates[#]]] & /@ graphs}]
```

The squared distance between the points of the centre and of each vertex of the square tiling against their effective resistance: the points lie on the diagonal.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small"]},
  {embedding = ResistanceCoordinates[g], c = First @ GraphCenter[g]},
  {pairs = Table[{EffectiveResistance[g, c, u], Total[(embedding[c] - embedding[u])^2]}, {u, VertexList[g]}]},
  {ListPlot[pairs, AspectRatio -> 1, AxesLabel -> {"R", "‖Φ(c) − Φ(u)‖²"}], Chop[Max[Abs[Subtract @@@ pairs]]]}]
```

## Scope

The three slowest modes of a triangulated sphere and of the buckyball are coordinates in space: drawn at them, both graphs are round, every point at nearly one distance from the centre.

```wl
With[
  {graphs = InfraSubstrate[#, "Small"] & /@ {"SphereMeshGraph", "BuckyballGraph"}},
  {embeddings = ResistanceCoordinates[#, "Dimension" -> 3] & /@ graphs},
  {GraphicsRow[MapThread[Graph3D[VertexList[#1], EdgeList[#1], VertexCoordinates -> Normal[#2]] &, {graphs, embeddings}]],
   MinMax[Norm /@ Values[#]] & /@ embeddings}]
```

## Options

### Rescaling

The two slowest modes of a 12 × 4 grid both run along its length, so each drawing is a curve, the second mode bending it. The plain eigenvectors weigh the two modes alike; the resistance matching weighs the faster one less, and the diffusion map at time 5 less again.

```wl
With[
  {g = GridGraph[{12, 4}]},
  GraphicsRow[Table[
    Graph[VertexList[g], EdgeList[g], VertexCoordinates -> Normal[ResistanceCoordinates[g, "Dimension" -> 2, "Rescaling" -> rescaling]]],
    {rescaling, {"None", "ResistanceMatching", "Diffusion" -> 5}}]]]
```

## Properties and Relations

With fewer modes the squared distances fall below the resistances, and they approach them as modes are added: from the centre of the square tiling with 2, 10 and 40 of its 112 modes, and with all of them.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small"]},
  {c = First @ GraphCenter[g]},
  ListPlot[
    Table[
      With[
        {embedding = ResistanceCoordinates[g, "Dimension" -> k]},
        Table[{EffectiveResistance[g, c, u], Total[(embedding[c] - embedding[u])^2]}, {u, VertexList[g]}]],
      {k, {2, 10, 40, All}}],
    AspectRatio -> 1, PlotLegends -> {"2 modes", "10 modes", "40 modes", "all modes"}, AxesLabel -> {"R", "‖Φ(c) − Φ(u)‖²"}]]
```

The inner products of the points are the entries of the pseudoinverse of the Laplacian.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small"]},
  {gram = Outer[Dot, Values[ResistanceCoordinates[g]], Values[ResistanceCoordinates[g]], 1]},
  {MatrixPlot[gram], Chop[Max[Abs[gram - PseudoInverse[N[KirchhoffMatrix[g]]]]]]}]
```

## Possible Issues

A repeated eigenvalue leaves the points unique only up to a rotation of its eigenvectors. The four slowest modes of the square torus share one eigenvalue, and three of them draw an arbitrary projection of the torus.

```wl
With[
  {g = InfraSubstrate["SquareTorusGraph", "Small"]},
  {Graph3D[VertexList[g], EdgeList[g], VertexCoordinates -> Normal[ResistanceCoordinates[g, "Dimension" -> 3]]],
   Take[Sort[Eigenvalues[N[KirchhoffMatrix[g]]]], 6]}]
```
