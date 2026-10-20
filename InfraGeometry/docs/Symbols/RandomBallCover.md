---
Template: Symbol
Name: RandomBallCover
Context: WolframInstitute`InfraGeometry`
ContextPath: []
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomBallCover
Keywords: [random ball cover, minimum cover, dominating set, uniform sampling, nonuniqueness]
SeeAlso: [FindBallCover, BallCoverNumber, BallCoverQ, InfraBall, RandomSeeding, RandomSample]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[RandomBallCover]()[*g*, *r*]</code> gives a uniformly chosen minimum centre set whose closed radius-*r* balls cover every vertex of *g*.

<code>[RandomBallCover]()[*g*, *r*, *target*]</code> samples a minimum cover of *target*, using centres anywhere in *g*.

<code>[RandomBallCover]()[*g*, *r*, *target*, *n*]</code> gives exactly *n* distinct minimum covers, sampled without replacement, or an empty list if fewer exist.

<code>[RandomBallCover]()[*g*, *r*, *target*, [UpTo]()[*n*]]</code> samples at most *n* distinct minimum covers.

<code>[RandomBallCover]()[*g*, *r*, *target*, [All]()]</code> gives every minimum cover in deterministic enumeration order.

## Details & Options

A centre set covers a target when every target vertex is at graph distance at most *r* from some centre. A minimum cover has the fewest centres among
all such sets. Each distinct minimum centre set has equal sampling probability; different permutations of the same centres are one cover.

The graph is finite, undirected and unweighted; the radius is a nonnegative integer, defaulting to 1. The target defaults to [All](). It accepts a
vertex, vertex list, density association, graph carrier or abstract region such as [InfraBall](). Only vertex support matters. A literal vertex takes
precedence over list interpretation. Centres and distances belong to the ambient graph.

Omitting the count gives one centre list. Every explicit count gives a list of centre lists; explicit 1 therefore gives a one-element list. Counts
occupy the fourth argument, after the target. Integer counts are strict, while [UpTo]() permits fewer. Sampling is without replacement within a call;
separate calls can repeat.

`RandomSeeding -> Automatic` (default) seeds each call afresh, independently of `SeedRandom`; an integer or string gives a reproducible draw, and `Inherited` a local snapshot of the current state. The outer random state is restored afterward, as with [RandomInstance](https://reference.wolfram.com/language/ref/RandomInstance.html). [All](), 0 and [UpTo]()[0] make no draw. [All]() returns the same complete family as [FindBallCover]() with [All](); its order has no intrinsic geometric meaning.

| Option | Default | Description |
|---|---|---|
| [Method]() | [Automatic]() | exact algorithm used to determine the minimum-cover family |
| `RandomSeeding` | `Automatic` | seed of the local random stream |

[Automatic]() and `"IntegerLinearProgramming"` use exact integer optimization. `"Exhaustive"` is a compatibility alias for that algorithm. These are
method values of this function, not the solver method names of [LinearOptimization](). `"Greedy"` is unsupported; a greedy cover need not be minimum.

A positive bounded sample request first enumerates every minimum centre set, even for one draw. This family can have exponential size. The count controls the number returned,
not the search effort; there is no heuristic fallback.

The empty target has one minimum cover, the empty centre list. Omitting the count gives `{}`; explicit 1, [UpTo]()[1] and [All]() give `{{}}`. An
empty association `<||>` specifies an empty target even when `{}` is itself a vertex label.

## Basic Examples

Sample one minimum cover of a six-cycle:

#| annotation: 26.10.18: FindShortestPath illustrates witness selection without a canonical tie rule; FindBallCover retains that role. RandomPoint and RandomSample motivate ambient seeding for the separate sampler. Here the distribution is explicitly uniform over minimum centre sets, implemented by complete exact enumeration. No native RandomBallCover counterpart or extra cover wrapper is assumed.
```wl
SeedRandom[ 101 ];
RandomBallCover[ CycleGraph[ 6 ], 1, RandomSeeding -> 101 ]
```

---

Draw two different minimum covers and show their covering balls:

```wl
SeedRandom[ 101 ];
With[
	{ graph = CycleGraph[ 6 ] },
	{ covers = RandomBallCover[ graph, 1, All, 2 ] },
	GraphicsRow @ Map[
		centres |-> Labeled[ InfraSubstrateHighlight[ graph,
			InfraBall[ #, 1 ] & /@ centres ], centres ], covers ] ]
```

---

Cover a ball inside an ambient cycle:

```wl
SeedRandom[ 101 ];
RandomBallCover[ CycleGraph[ 8 ], 1, InfraBall[ 1, 2 ], RandomSeeding -> 101 ]
```

## Scope

An explicit count of one retains the outer list:

```wl
SeedRandom[ 101 ];
RandomBallCover[ CycleGraph[ 6 ], 1, All, 1 ]
```

---

A strict request for four covers fails because only three exist:

```wl
SeedRandom[ 101 ];
RandomBallCover[ CycleGraph[ 6 ], 1, All, 4 ]
```

---

A bounded request returns the three available covers in random order:

```wl
SeedRandom[ 101 ];
RandomBallCover[ CycleGraph[ 6 ], 1, All, UpTo[ 4 ] ]
```

---

Enumerate every minimum cover without a random draw:

```wl
RandomBallCover[ CycleGraph[ 6 ], 1, All, All ]
```

---

The empty target has one empty minimum cover:

```wl
RandomBallCover[ CycleGraph[ 6 ], 1, <||>, All ]
```

## Options

### Method

Select exact integer optimization explicitly:

```wl
SeedRandom[ 101 ];
RandomBallCover[ CycleGraph[ 6 ], 1, Method -> "IntegerLinearProgramming", RandomSeeding -> 101 ]
```

### RandomSeeding

A fixed seed reproduces the draw, whatever state `SeedRandom` has set:

```wl
Table[SeedRandom[k]; RandomBallCover[PathGraph[Range[4]], RandomSeeding -> 7], {k, 2}]
```

## Properties and Relations

The found and sampled covers have the same minimum size:

```wl
SeedRandom[ 101 ];
With[
	{ graph = CycleGraph[ 6 ] },
	Grid[ { { "Minimum size", "Found cover", "Random cover" },
		{ BallCoverNumber[ graph, 1 ], FindBallCover[ graph, 1 ], RandomBallCover[ graph, 1, RandomSeeding -> 101 ] } }, Frame -> All ] ]
```

---

Resetting the seed repeats a draw:

```wl
With[
	{ graph = CycleGraph[ 6 ] },
	{ first = RandomBallCover[ graph, 1, RandomSeeding -> 101 ] },
	SeedRandom[ 101 ];
	RandomBallCover[ graph, 1, RandomSeeding -> 101 ] === first ]
```

## Possible Issues

A random greedy trajectory is a different distribution from uniform sampling of minimum covers. Randomized greedy is not a method of this sampler:

```wl
RandomBallCover[ CycleGraph[ 6 ], 1, Method -> "Greedy" ]
```

The input remains unevaluated.
