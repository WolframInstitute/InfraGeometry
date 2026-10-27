---
Template: Symbol
Name: InfraDeformation
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraDeformation
Keywords: [deformation, simple path, fixed endpoints, excess length, tube, exact count, path family]
SeeAlso: [RandomInfraDeformation, FindInfraDeformation, InfraMeasurement, InfraMemberQ, InfraForwardDeformation, InfraDeformationSize]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[InfraDeformation]()[*reference*, *excess*]</code> represents the simple paths with the endpoints of the shortest path *reference*, within a reference tube and the specified excess length.

## Details & Options

The object is inert. [RandomInfraDeformation]() samples or enumerates its members, [InfraMeasurement]() reads its properties, and [InfraMemberQ]() tests membership.

The substrate is a simple undirected unweighted graph. *reference* is a nonempty vertex list forming a shortest path. Write *L* for its edge length. A member is a vertex list with no repeated vertex, the same ordered endpoints, and length *L + k* for an allowed excess *k*. Every vertex of the member is within the tube radius of some reference vertex, using graph distance.

| Excess specification | Allowed excess |
|---|---|
| `{k}` | exactly *k* |
| `{lo, hi}` | each integer from *lo* through *hi* |
| `UpTo[k]` | 0 through *k* |

The bounds are nonnegative integers.

| Option | Default | Meaning |
|---|---|---|
| `"TubeRadius"` | `1` | nonnegative integer graph distance from the reference vertex set, or `Infinity` |
| `"MaxStates"` | `100000` | positive integer limit on construction states, or `Infinity` |

A radius-0 tube contains only the reference when excess 0 is allowed. A wider tube can contain other shortest paths at excess 0. A one-vertex reference has only its constant path when excess 0 is allowed.

Members may move toward the starting vertex as well as away from it. This differs from [InfraForwardDeformation](), whose walks never decrease that distance and may repeat vertices.

Membership describes proximity and length, not homotopy. [FindInfraDeformation]() separately searches for a chain of elementary face moves that respects the bounds throughout.

### Measurements

| Property | Value |
|---|---|
| `"Graph"` | one directed acyclic graph encoding all members by elapsed step and retained path history, with a terminal state |
| `"Cardinality"` | the exact number of members |
| `"CountsByExcess"` | an association from each requested excess to its exact count, including zeros |
| `"Length"` | attained edge lengths; a scalar for one length, otherwise a list |
| `"VertexDensity"` | the number of members containing each substrate vertex |
| `"EdgeDensity"` | the number of members traversing each directed substrate edge |
| `"Subgraph"` | the substrate subgraph induced on the family support |
| `"CountingMeasure"` | the number of support vertices |
| `"RiemannianMeasure"` | the number of support vertices all of whose substrate neighbours belong to the support |

`All` returns these nine readings. Counts and densities are computed on the directed acyclic graph without enumerating its paths. Use the sampler to obtain vertex-list members; the graph's states encode history rather than substrate vertices alone.

### Computation bounds

When the maximum excess is below the girth of the tube graph, nonbacktracking walks within the length bound are exactly the simple paths. The construction then has polynomial size. In particular, excess at most 2 has this guarantee on every simple graph, and excess at most 3 on a square grid.

For larger excess, the construction retains enough recent history to exclude repeated vertices exactly. Its size can grow exponentially with the excess. Reaching `"MaxStates"` leaves the graph reading, dependent measurements and sampling calls unevaluated; no partial count is returned. Membership is checked directly and does not require constructing the family graph.

## Basic Examples

An edge of a square and its longer route around the other three sides:

```wl
SeedRandom[1];
With[{g = CycleGraph[4]}, {family = InfraDeformation[{1, 2}, UpTo[2]]},
  InfraMeasurement[g, family, {"CountsByExcess", "Length"}]]
```

The two paths stay inside the radius-1 tube, and both have fixed endpoints:

```wl
SeedRandom[1];
With[{g = CycleGraph[4]},
  RandomInfraDeformation[g, InfraDeformation[{1, 2}, UpTo[2]], All, RandomSeeding -> 1]]
```

## Scope

Larger excess is still counted exactly when the finite-history construction fits the state budget:

```wl
SeedRandom[1];
With[{g = CompleteGraph[5]},
  InfraMeasurement[g, InfraDeformation[{1, 2}, UpTo[3]], "CountsByExcess"]]
```

A radius-0 tube singles out the reference:

```wl
SeedRandom[1];
With[{g = CycleGraph[4]},
  RandomInfraDeformation[g, InfraDeformation[{1, 2, 3}, UpTo[4], "TubeRadius" -> 0], All, RandomSeeding -> 1]]
```
