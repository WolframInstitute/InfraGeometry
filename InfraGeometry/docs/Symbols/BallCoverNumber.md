---
Template: Symbol
Name: BallCoverNumber
Context: WolframInstitute`InfraGeometry`
ContextPath: []
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/BallCoverNumber
Keywords: [ball cover number, covering number, domination number, r-domination number, ball cover]
SeeAlso: [FindBallCover, RandomBallCover, BallCoverQ, InfraBall]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[BallCoverNumber]()[*g*, *r*]</code> gives the least number of balls of radius *r* that cover the vertices of *g*.

<code>[BallCoverNumber]()[*g*, *r*, *target*]</code> gives the least number of balls of radius *r* about vertices of *g* that cover the vertices of *target*.

## Details & Options

The covering number is *Nᵣ(T) = min {|C| : T ⊆ ⋃ Bᵣ(c), c ∈ C}*, with the centres *C* anywhere in *g*. For *T* the whole graph it is the *r*-domination number of *g*; at *r* = 1 it is the domination number.

The target can be a vertex, a vertex list, a density or a region such as [InfraBall](). Only its vertices count. It defaults to [All](), and the radius defaults to 1.

A ball holds at most *m = maxᵥ |Bᵣ(v)|* vertices, so *Nᵣ(T) ≥ |T| / m*. On the square grid *m = 2r² + 2r + 1*.

At radius 0 the number is the number of vertices of the target. It does not increase with the radius. On a connected graph it is 1 exactly from the radius of the graph on. On a cycle or a path with *n* vertices it is *⌈n / (2r + 1)⌉*.

The graph is undirected and unweighted, the radius a nonnegative integer. The number is always the minimum:

| Option | Default | Values |
|---|---|---|
| [Method]() | [Automatic]() | [Automatic](), `"IntegerLinearProgramming"`: the exact integer program |

## Basic Examples

A smallest cover by balls of radius 3, on the square grid and on the square mesh. The number of balls is the label:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    InfraSubstrateHighlight[g, InfraBall[#, 3] & /@ FindBallCover[g, 3], PlotLabel -> BallCoverNumber[g, 3]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The covering number falls with the radius and reaches 1 at the radius of the graph, 9 on the grid and 6 on the mesh:

```wl
ListLinePlot[
  Table[With[{g = InfraSubstrate[name, "Small"]}, Table[{r, BallCoverNumber[g, r]}, {r, 1, GraphRadius[g]}]],
    {name, {"SquareGridGraph", "SquareMeshGraph"}}],
  PlotMarkers -> Automatic, PlotLegends -> {"SquareGridGraph", "SquareMeshGraph"}]
```

## Scope

Covering the ball of radius 4 about the centre of the grid by balls of radius 0 to 4. Its four corners are pairwise 8 apart, so radius 3 still needs four balls:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Table[BallCoverNumber[g, r, InfraBall[c, 4]], {r, 0, 4}]]
```

An empty target needs no balls:

```wl
BallCoverNumber[CycleGraph[6], 1, {}]
```

## Properties and Relations

On a cycle and on a path with *n* vertices the covering number is *⌈n / (2r + 1)⌉*, here at *r* = 1:

```wl
Table[{BallCoverNumber[CycleGraph[n], 1], BallCoverNumber[PathGraph[Range[n]], 1], Ceiling[n / 3]}, {n, 3, 10}]
```

The covering number against the lower bound *|V| / (2r² + 2r + 1)* on the grid:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  ListLinePlot[Transpose @ Table[{{r, BallCoverNumber[g, r]}, {r, VertexCount[g] / (2 r^2 + 2 r + 1)}}, {r, 1, 9}],
    PlotMarkers -> Automatic, PlotLegends -> {"BallCoverNumber", "|V| / (2r² + 2r + 1)"}]]
```

A greedy cover gives an upper bound. At radius 4 on the grid it uses 7 balls where 4 suffice:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  GraphicsRow @ Table[
    With[{cover = FindBallCover[g, 4, Method -> m]},
      InfraSubstrateHighlight[g, InfraBall[#, 4] & /@ cover, PlotLabel -> Length[cover]]],
    {m, {Automatic, "Greedy"}}]]
```

## Possible Issues

`"Greedy"` is not a method of [BallCoverNumber](). The call stays unevaluated:

```wl
BallCoverNumber[CycleGraph[6], 1, Method -> "Greedy"]
```
