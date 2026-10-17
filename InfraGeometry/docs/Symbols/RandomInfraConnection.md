---
Template: Symbol
Name: RandomInfraConnection
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraConnection
Keywords: [random connection, perfect matching, sampling, enumeration]
SeeAlso: [InfraConnection, InfraConnectionQ, InfraHorizontalLift, InfraHolonomy, RandomInfraFibration, RandomInfraSection]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[RandomInfraConnection]()[*fib*]</code> samples one complete connection of *fib*, or gives {} when none is found.

<code>[RandomInfraConnection]()[*fib*, *count*]</code> samples or enumerates distinct complete connections.

## Details & Options

- A complete connection chooses a perfect matching between the whole fibers over every base edge, using only transverse total edges.
- Unequal neighbouring fiber sizes or a perfect-matching obstruction give an empty result. An invalid partial matching is never returned as a connection.
- Omitted count or Automatic returns one [InfraConnection]() directly. An integer *n* returns exactly *n* distinct connections, or {} on shortage. UpTo[*n*] returns at most *n*. All enumerates the class.
- On an empty base there is one connection, <code>[InfraConnection]()[{}]</code>. An empty result list means that no member was returned.
- The sampler uses the ambient random stream. [SeedRandom]() before a call makes it reproducible.
- Search processes base edges and source fiber vertices in their graph orders. At each step, candidates are unused target vertices whose choice admits a completion of that matching. A bounded search stops once it has enough members.
- Random candidate order does not give a uniform distribution over completed connections.

| Option | Default | Meaning |
|---|---|---|
| `"NextVertexFunction"` | Automatic | Candidate order or selection at each matching step. |

Automatic uses random candidate permutations for bounded sampling and deterministic order for All. Identity is deterministic. RandomSample randomly permutes candidates with backtracking. RandomChoice retains one random candidate at each step without backtracking and is unsupported with All.

A callback receives a list of literal total-vertex candidates. It may return one member or a duplicate-free list of retained members. A returned list that is itself a candidate is read as that one vertex first. A pruning callback restricts the search tree: shortage then concerns that retained tree. RandomChoice retains at most one complete route, so an exact count above one returns {}. Unsupported option names, nominal selectors and callback results remain unevaluated. The first duplicate option takes precedence.

## Basic Examples

Two vertices per fiber over a hexagon, with complete joins between adjacent fibers, admit complete connections.

```wl
SeedRandom[ 3 ];
With[
  { fib = RandomInfraFibration[
      CycleGraph[ 6 ], "VerticalVertices" -> 2, "VerticalEdges" -> 0,
      "IsomorphicFibers" -> True, "HorizontalEdgesDensity" -> All
    ] },
  { connection = RandomInfraConnection[ fib ] },
  { InfraFiberedGraphHighlight[ fib, connection ],
    InfraConnectionQ[ fib, connection ],
    InfraHolonomy[ fib, connection, { 1, 2, 3, 4, 5, 6, 1 } ] }
]
```

There are exactly two perfect matchings between these fibers.

```wl
SeedRandom[ 1 ];
With[
  { fib = InfraFibration[
      Graph[ Range[ 4 ], UndirectedEdge @@@ Tuples[ { { 1, 2 }, { 3, 4 } } ] ],
      <| 1 -> "p", 2 -> "p", 3 -> "q", 4 -> "q" |>
    ] },
  { connections = RandomInfraConnection[ fib, All ] },
  { GraphicsRow[ InfraFiberedGraphHighlight[ fib, # ] & /@ connections ],
    Length @ connections, RandomInfraConnection[ fib, 3 ] }
]
```

## Possible Issues

Equal fiber sizes and positive degrees do not guarantee a perfect matching: two source vertices below share only one target.

```wl
SeedRandom[ 1 ];
With[
  { fib = InfraFibration[
      Graph[ Range[ 6 ], UndirectedEdge @@@ { { 1, 4 }, { 2, 4 }, { 3, 5 }, { 3, 6 } } ],
      <| 1 -> "p", 2 -> "p", 3 -> "p", 4 -> "q", 5 -> "q", 6 -> "q" |>
    ] },
  { InfraFiberedGraphHighlight[ fib ], RandomInfraConnection[ fib, All ] }
]
```
