---
Template: Symbol
Name: RandomInfraSceneInstance
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraSceneInstance
Keywords: [scene, construction, instance, backtracking, constraint]
SeeAlso: [InfraScene, InfraSceneInstance, InfraSceneStep, InfraScenePlot]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraSceneInstance]()[*scene*, *g*]</code> gives a random instance of the [InfraScene]() *scene* on the graph *g*.

<code>[RandomInfraSceneInstance]()[*scene*, *g*, *n*]</code> gives a list of *n* distinct instances.

<code>[RandomInfraSceneInstance]()[*scene*, *g*, *bindings*]</code> and <code>[RandomInfraSceneInstance]()[*scene*, *g*, *n*, *bindings*]</code> keep the objects fixed by the association *bindings*.

## Details & Options

An instance binds every object of the scene to a vertex, a vertex list or a member of its construction, so that every assertion holds. It is an [InfraSceneInstance]() and gives the value of an object *x* as <code>[InfraSceneInstance]()[*inst*, *x*]</code>.

A construction is a family, so a scene has many instances. A segment gives one instance per shortest path, and so the instances of "a point at distance *d* from *c* and the segment to it" are counted by *Σ C(c, v)* over the vertices *v* at distance *d*, with *C(c, v)* the number of shortest paths.

The search binds one object at a time, checks each assertion as soon as its objects are bound, and backtracks from a dead end. The draw is not uniform over the instances.

The count *n* can be `n`, `UpTo[n]` or `All`. A scene with no instance gives `{}`.

Options:

| Option | Default | Values |
|---|---|---|
| `"Steps"` | `All` | *k*: bind only the objects of the first *k* steps of the scene |
| `"NextVertexFunction"` | `Automatic` | `Automatic` random order; `Identity` fixed order; a function of the candidate list keeps the candidates it returns |
| [RandomSeeding]() | `Automatic` | an integer or a string for a reproducible search; `Inherited` to search from the current random state |

With a pruning function such as `RandomSample[#, UpTo[2]] &`, `All` gives every instance of the pruned search only.

## Basic Examples

A point at distance 3 from the centre and the segment to it, one instance on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {scene = InfraScene[{pA, pB, ab},
      {pA == InfraPoint[c], pB == InfraPoint[], InfraDistance[pA, pB] == 3, ab == InfraSegment[pA, pB]}]},
    {instance = RandomInfraSceneInstance[scene, g, RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraWalk[InfraSceneInstance[instance, ab]], c, InfraSceneInstance[instance, pB]}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

All instances on the grid: one per vertex at distance 3 and shortest path to it. The segments of all of them drawn together:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB, ab},
    {pA == InfraPoint[c], pB == InfraPoint[], InfraDistance[pA, pB] == 3, ab == InfraSegment[pA, pB]}]},
  {instances = RandomInfraSceneInstance[scene, g, All]},
  InfraSubstrateHighlight[g, {InfraSceneInstance[#, ab] & /@ instances, c}, PlotLabel -> Length[instances],
    ImageSize -> Medium]]
```

The number of instances is the total number of shortest paths from the centre to the vertices at distance 3:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small"]}, {c = First @ GraphCenter[g]},
    {scene = InfraScene[{pA, pB, ab},
      {pA == InfraPoint[c], pB == InfraPoint[], InfraDistance[pA, pB] == 3, ab == InfraSegment[pA, pB]}]},
    {Length @ RandomInfraSceneInstance[scene, g, All],
     Total[InfraMeasurement[g, InfraSegment[c, #], "Cardinality"] & /@ RandomInfraPoint[g, InfraShell[c, 3], All]]}],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Scope

Fixing the second point leaves only the segment to choose, one instance per shortest path:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1]},
  {scene = InfraScene[{pA, pB, ab},
    {pA == InfraPoint[c], pB == InfraPoint[], InfraDistance[pA, pB] == 3, ab == InfraSegment[pA, pB]}]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[InfraSceneInstance[instance, ab]], c, b}],
    {instance, RandomInfraSceneInstance[scene, g, All, <|pB -> b|>]}]]
```

## Options

### Steps

The scene has two steps, the points and then the segment. `"Steps" -> 1` binds the points only, and gives the circle of radius 3:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB, ab},
    {pA == InfraPoint[c], pB == InfraPoint[], InfraDistance[pA, pB] == 3, ab == InfraSegment[pA, pB]}]},
  {points = InfraSceneInstance[#, pB] & /@ RandomInfraSceneInstance[scene, g, All, "Steps" -> 1]},
  InfraSubstrateHighlight[g, {points, c}, PlotLabel -> scene["Steps"], ImageSize -> Medium]]
```

### NextVertexFunction

Keeping at most *k* candidates at each construction prunes the search. The number of instances found, out of 28; with 2 candidates for the second point none is at distance 3:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB, ab},
    {pA == InfraPoint[c], pB == InfraPoint[], InfraDistance[pA, pB] == 3, ab == InfraSegment[pA, pB]}]},
  Table[k -> Length @ RandomInfraSceneInstance[scene, g, All,
      "NextVertexFunction" -> (RandomSample[#, UpTo[k]] &), RandomSeeding -> 1], {k, {2, 10, 50, 96}}]]
```

## Possible Issues

A scene with no instance gives `{}`. No vertex is at distance 20 from the centre:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB}, {pA == InfraPoint[c], pB == InfraPoint[], InfraDistance[pA, pB] == 20}]},
  RandomInfraSceneInstance[scene, g]]
```
