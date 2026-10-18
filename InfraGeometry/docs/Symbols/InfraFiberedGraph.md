---
Template: Symbol
Name: InfraFiberedGraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFiberedGraph
Keywords: [fibered graph, total space, projection, inert object]
SeeAlso: [InfraFiberedGraphQ, InfraTotalSpace, InfraBaseSpace, InfraProjection, InfraFiber, RandomInfraFiberedGraph, InfraFibrationQ, InfraFibration]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraFiberedGraph]()[*total*, *projection*]</code> is an inert fibered graph with total graph *total* and a vertex projection given by an association or a function.

<code>[InfraFiberedGraph]()[*model*]</code> materializes an Experimental construction as a literal fibered graph, computing its total graph once.

## Details & Options

- The general object imposes no equal-size, lifting, matching or triviality condition. Separate predicates test these properties.
- Readers support finite simple undirected unweighted untagged total graphs. Unsupported graph domains remain unevaluated; projection-dependent readers also leave malformed association projections unevaluated.
- An association projection has exactly one key for each total vertex. A function projection is evaluated at each total vertex.
- Edge-tagged graphs are unsupported; readers do not discard or merge edge tags.
- Vertex labels are literal expressions. List-valued and pattern-like vertices remain individual association keys; use [Key]() for literal lookup.
- [InfraTotalSpace]() gives the total graph and [InfraProjection]() gives the projection association.
- [InfraBaseSpace]() reconstructs the base. Its vertices are all projection values, including those represented only by isolated total vertices.
- Distinct base vertices are adjacent exactly when a total edge joins their fibers. Edges within a fiber are vertical and collapse under projection.
- [InfraFiber]() gives the induced graph on one projection preimage. [InfraFibers]() gives all fibers as an association.
- The empty graph with the empty projection is a valid fibered graph.
- The head stays inert even when its arguments are unsupported. [InfraFiberedGraphQ]() recognizes supported literal objects; supported Experimental models are materialized by their explicit category methods.
- [InfraFibration]() remains a compatibility head. New constructions use [InfraFiberedGraph]().

## Basic Examples

A cycle wraps twice around its reconstructed square base.

```wl
SeedRandom[ 7 ];
With[ { fib = InfraFiberedGraph[ CycleGraph[ 8 ], vertex |-> Mod[ vertex, 4, 1 ] ] },
  InfraFiberedGraphHighlight[ fib, { InfraFiber[ fib, 1 ] } ] ]
```

A general projection can have unequal fibers and missing lifts.

```wl
SeedRandom[ 7 ];
With[ { fib = InfraFiberedGraph[ PathGraph[ Range[ 6 ] ], <| 1 -> "a", 2 -> "a", 3 -> "b", 4 -> "c", 5 -> "c", 6 -> "c" |> ] },
  GraphicsRow[ { InfraFiberedGraphHighlight[ fib ], InfraBaseSpace[ fib ] } ] ]
```

## Scope

Materialize a particular model before repeated structural queries.

```wl
SeedRandom[ 7 ];
With[ { model = InfraDisplacementBundle[ CycleGraph[ 8 ], 1 ] },
  { fib = InfraFiberedGraph[ model ] },
  InfraFiberedGraphHighlight[ fib ] ]
```
