---
Template: Symbol
Name: InfraEdgeLiftMultiplicity
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraEdgeLiftMultiplicity
Keywords: [edge lift, multiplicity, local degree, equitable partition]
SeeAlso: [InfraFibrationQ, InfraAtMostOneEdgeLiftQ, InfraUniqueEdgeLiftingQ, InfraProjection, InfraFibers]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraEdgeLiftMultiplicity]()[*fib*]</code> gives the numbers of transverse neighbours as a nested association from each total vertex to each adjacent base vertex.

## Details & Options

- For a total vertex *x* over *p*, the inner association has one key *q* for every neighbour of *p* in [InfraBaseSpace](). Its value counts neighbours of *x* in the fiber over *q*.
- Zero counts are included. They record a missing lift over an existing base edge.
- Vertical neighbours are not counted. A vertex over an isolated base vertex has an empty inner association.
- The empty fibered graph gives an empty outer association.
- All counts positive is [InfraFibrationQ](). All counts at most one is [InfraAtMostOneEdgeLiftQ](). All counts one is [InfraUniqueEdgeLiftingQ]().
- Constant inner associations within each fiber express transverse equitable multiplicity. A full equitable partition additionally requires constant vertical degree within each fiber.
- The reader consumes no random draws. Unsupported objects remain unevaluated.

## Basic Examples

The two isolated total vertices have zero lifts over the existing base edge.

```wl
SeedRandom[ 7 ];
With[ { fib = InfraFiberedGraph[ Graph[ Range[ 4 ], { UndirectedEdge[ 1, 3 ] } ], <| 1 -> "p", 2 -> "p", 3 -> "q", 4 -> "q" |> ] },
  { InfraFiberedGraphHighlight[ fib ], InfraEdgeLiftMultiplicity[ fib ] } ]
```

## Properties and Relations

Complete joins between equal fibers have constant transverse multiplicity.

```wl
SeedRandom[ 7 ];
With[ { fib = RandomInfraFiberedGraph[ CycleGraph[ 4 ], "VerticalVertexCount" -> { 3 }, "HorizontalEdgeCount" -> All ] },
  { multiplicities = InfraEdgeLiftMultiplicity[ fib ] },
  InfraFiberedGraphHighlight[ fib, { Map[ counts |-> Total @ Values[ counts ], multiplicities ] } ] ]
```
