---
Template: Symbol
Name: FindBallCover
Context: WolframInstitute`InfraGeometry`
ContextPath: []
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindBallCover
Keywords: [ball cover, dominating set, r-domination, covering number, set cover, integer program]
SeeAlso: [RandomBallCover, BallCoverQ, BallCoverNumber, CechComplex, InfraBall]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[FindBallCover]()[*g*, *r*]</code> gives a list of centres whose closed balls of radius *r* cover every vertex of *g*, minimizing their number by default.

<code>[FindBallCover]()[*g*, *r*, *target*]</code> covers the vertices of *target*, using centres anywhere in *g*.

<code>[FindBallCover]()[*g*, *r*, *target*, *n*]</code> gives exactly *n* different minimum covers, or an empty list if fewer exist.

<code>[FindBallCover]()[*g*, *r*, *target*, [UpTo]()[*n*]]</code> gives at most *n* different minimum covers.

<code>[FindBallCover]()[*g*, *r*, *target*, [All]()]</code> gives every minimum cover.

## Details & Options

A centre set $C$ covers a target $T$ when every target vertex is at graph distance at most $r$ from some centre. Its balls and distances are read on the ambient graph *g*. The graph is finite, undirected and unweighted; the radius is a nonnegative integer, defaulting to 1. The target defaults to [All]().

A target can be a vertex, a vertex list, a density association, a graph carrier or an abstract region such as [InfraBall](). Only its vertex support matters; density masses are ignored. A literal vertex of *g* takes precedence over list interpretation. An association can specify a target set without this ambiguity.

| Option | Default | Description |
|---|---|---|
| [Method]() | [Automatic]() | algorithm used to find the cover |

| Method value | Guarantee |
|---|---|
| [Automatic]() | a minimum cover, found by integer linear programming |
| `"IntegerLinearProgramming"` | the same exact optimization, explicitly selected |
| `"Greedy"` | a feasible cover obtained by repeatedly choosing a centre covering the most uncovered targets |

`"Exhaustive"` remains a compatibility alias for `"IntegerLinearProgramming"`; it does not describe a separate brute-force algorithm. These strings are method values of this function, not solver method names of [LinearOptimization](). `"Symmetric"` is unsupported because its restricted covers need not attain the ordinary covering number.

The result without a count is one centre list. An explicit count gives a list of centre lists; in particular, explicit 1 gives a one-element list. Counts occupy the fourth argument, after the target. Exact methods enumerate distinct minimum centre sets. A single optimum is a solver-selected witness, not an intrinsic canonical choice; it need not be the first entry of [All](). Calls with different counts are not promised to form nested prefixes. Enumeration can be expensive even when finding one cover is fast. Use [RandomBallCover]() to sample uniformly from the minimum family.

`"Greedy"` supports only the form without a count. It breaks equal maximum-gain ties by the current candidate order, without random draws. Its result is feasible but need not be minimum or inclusion-minimal. An inclusion-minimal cover has no removable centre; a minimum cover has the fewest centres.

The empty target has one minimum cover, the empty centre list. The count-less result is `{}`, while explicit 1, [UpTo]()[1] and [All]() give `{{}}`. An empty association `<||>` specifies an empty target even when `{}` is itself a vertex label.

## Basic Examples

Find one minimum cover of a cycle by balls of radius one:

```wl
FindBallCover[ CycleGraph[ 6 ], 1 ]
```

---

A smallest cover by balls of radius three on the plane mesh, square tiling and hexagonal tiling:

```wl
GraphicsRow @ Table[
	With[
		{ graph = InfraSubstrate[ name, "Small", "KeepCoordinates" -> True ] },
		InfraSubstrateHighlight[ graph, InfraBall[ #, 3 ] & /@ FindBallCover[ graph, 3 ] ] ],
	{ name, { "SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph" } } ]
```

---

Cover a radius-four ball by radius-two balls, using the ambient graph for centres and distances:

```wl
GraphicsRow @ Table[
	With[
		{ graph = InfraSubstrate[ name, "Small", "KeepCoordinates" -> True ] },
		{ target = InfraBall[ First @ GraphCenter[ graph ], 4 ] },
		InfraSubstrateHighlight[ graph,
			{ target -> StandardGray, FindBallCover[ graph, 2, target ] -> StandardRed } ] ],
	{ name, { "SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph" } } ]
```

## Scope

The cycle has three minimum covers; request every one:

```wl
FindBallCover[ CycleGraph[ 6 ], 1, All, All ]
```

---

An explicit count of one retains the outer list:

```wl
FindBallCover[ CycleGraph[ 6 ], 1, All, 1 ]
```

---

Requesting four minimum covers gives no answers because only three exist:

```wl
FindBallCover[ CycleGraph[ 6 ], 1, All, 4 ]
```

---

A bounded count returns the available minimum covers:

```wl
FindBallCover[ CycleGraph[ 6 ], 1, All, UpTo[ 4 ] ]
```

---

The empty target has one empty minimum cover:

```wl
FindBallCover[ CycleGraph[ 6 ], 1, <||>, All ]
```

## Options

### Method

Select the exact integer program explicitly:

```wl
FindBallCover[ CycleGraph[ 6 ], 1, Method -> "IntegerLinearProgramming" ]
```

---

A greedy cover can use more balls than a minimum cover; each picture shows its covering balls:

```wl
With[
	{ graph = GraphData[ "CuboctahedralGraph" ] },
	{ methods = { Automatic, "Greedy" } },
	GraphicsRow @ Map[
		method |-> With[
			{ centres = FindBallCover[ graph, 1, Method -> method ] },
			Labeled[ InfraSubstrateHighlight[ graph, InfraBall[ #, 1 ] & /@ centres ],
				Row[ { method, ": ", Length[ centres ], " balls" } ] ] ], methods ] ]
```

## Properties and Relations

A found cover satisfies the coverage predicate:

```wl
With[
	{ graph = CycleGraph[ 12 ] },
	BallCoverQ[ graph, 1, FindBallCover[ graph, 1 ] ] ]
```

---

The length of a minimum cover is the covering number:

```wl
With[
	{ graph = CycleGraph[ 12 ] },
	Length @ FindBallCover[ graph, 1 ] == BallCoverNumber[ graph, 1 ] ]
```
