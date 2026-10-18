---
Template: Symbol
Name: BallCoverNumber
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/BallCoverNumber
Keywords: [ball cover number, covering number, domination number, r-domination number, ball cover, covering dimension]
SeeAlso: [FindBallCover, BallCoverQ, InfraBall]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[BallCoverNumber]()[*g*, *r*]</code> gives the minimum number of closed balls of radius *r* needed to cover every vertex of *g*.

<code>[BallCoverNumber]()[*g*, *r*, *target*]</code> gives the minimum number needed to cover the vertices of *target*, using centres anywhere in *g*.

## Details & Options

The covering number is the minimum size of a centre set whose closed radius-*r* balls cover the target. For the whole graph this is the *r*-domination number, and at radius one the domination number. The graph is finite, undirected and unweighted; the radius is a nonnegative integer, defaulting to 1. The target defaults to [All]().

Targets can be vertices, vertex lists, density associations, graph carriers or abstract regions such as [InfraBall](). Only vertex support matters. A literal vertex takes precedence over list interpretation. All centres and shortest paths belong to the ambient graph.

| Option | Default | Description |
|---|---|---|
| [Method]() | [Automatic]() | exact algorithm used to compute the minimum |

[Automatic]() and `"IntegerLinearProgramming"` solve the exact integer program. `"Exhaustive"` remains a migration alias. `"Greedy"` and `"Symmetric"` are unsupported: the covering number is always the minimum. Obtain a greedy upper bound by taking the [Length]() of a `"Greedy"` [FindBallCover]() result.

At radius zero the number is the size of the target support. It is zero for an empty target and does not increase with radius. For a nonempty connected graph covered in full, it is one from the graph radius onward.

## Basic Examples

Compute the minimum number of radius-two balls covering a cycle:

```wl
BallCoverNumber[ CycleGraph[ 7 ], 2 ]
```

---

The covering number falls with radius on the plane mesh, square tiling and hexagonal tiling:

```wl
ListLogPlot[
	Table[
		With[
			{ graph = InfraSubstrate[ name, "Small" ] },
			Table[ { r, BallCoverNumber[ graph, r ] }, { r, 0, GraphRadius[ graph ] } ] ],
		{ name, { "SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph" } } ],
	Joined -> True,
	PlotLegends -> { "SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph" },
	AxesLabel -> { "r", "N(r)" } ]
```

## Scope

Cover a radius-four ball within the surrounding hexagonal tiling:

```wl
With[
	{ graph = InfraSubstrate[ "HexagonalTilingGraph", "Small" ] },
	BallCoverNumber[ graph, 2, InfraBall[ First @ GraphCenter[ graph ], 4 ] ] ]
```

---

An empty target needs no balls:

```wl
BallCoverNumber[ CycleGraph[ 6 ], 1, <||> ]
```

## Options

### Method

Select the exact integer program explicitly:

```wl
BallCoverNumber[ GraphData[ "CuboctahedralGraph" ], 1, Method -> "IntegerLinearProgramming" ]
```

## Properties and Relations

The greedy cover supplies an upper bound; on the cuboctahedron it needs an extra ball:

```wl
With[
	{ graph = GraphData[ "CuboctahedralGraph" ] },
	Grid[ { { "Minimum", "Greedy upper bound" },
		{ BallCoverNumber[ graph, 1 ], Length @ FindBallCover[ graph, 1, Method -> "Greedy" ] } }, Frame -> All ] ]
```

---

On a cycle or a path with *n* vertices, the covering number is the ceiling of *n* divided by *2r + 1*:

```wl
Table[
	{ n, BallCoverNumber[ CycleGraph[ n ], 1 ], BallCoverNumber[ PathGraph[ Range[ n ] ], 1 ], Ceiling[ n / 3 ] },
	{ n, 3, 12 } ]
```
