---
Template: Symbol
Name: InfraSceneMultiway
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSceneMultiway
Keywords: [scene, multiway, construction, state, event, branch, branchial graph]
SeeAlso: [InfraScene, RandomInfraSceneInstance, InfraSceneInstance, InfraBranchialGraph, InfraSceneViewer]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraSceneMultiway]()[*scene*, *g*]</code> gives the multiway system of the construction *scene* on the graph *g*: every partial construction and every step between them.

<code>[InfraSceneMultiway]()[*scene*, *g*, *init*]</code> starts from the bindings in the association *init*.

## Details & Options

A state is a set of bindings: the objects constructed so far and their values. An event constructs one more object, with one of its realisations, and leads from a state to a new one. Two orders of construction that reach the same bindings reach the same state.

The final states are the instances of the scene, all that [RandomInfraSceneInstance]() can draw. A branch dies when an assertion fails on it.

The result is an [Association]():

| Key | Value |
|---|---|
| `"States"` | each state: its bindings, the constructions done, its depth |
| `"Events"` | each event: its source, its target, the construction and the value chosen |
| `"StateGraph"` | the states as vertices, the events as edges |
| `"Layers"` | the states at each number of constructions |
| `"StepLayers"` | the states at the end of each step of the scene |
| `"Instances"` | the final states, as [InfraSceneInstance]() objects |
| `"Completeness"` | whether the exploration finished, and if not, why |
| `"Frontier"` | the work left when it did not |

The exploration is exhaustive, for small graphs and short scenes. Options bound it; by default they are `Infinity`, so the result is exact, and a bound makes it partial, as `"Completeness"` reports:

| Option | Default | Values |
|---|---|---|
| `"Steps"` | `All` | the number of scene steps to explore |
| `"MaxDepth"`, `"MaxStates"`, `"MaxEvents"`, `"MaxCandidates"` | `Infinity` | a bound on the exploration |
| `"MaxTime"` | `Infinity` | a time bound in seconds |

[InfraBranchialGraph]() joins the states with a common parent; [InfraSceneViewer]() browses the result.

## Basic Examples

The segment from the centre of the grid to a vertex at distance 4. The two points can be placed in either order, and both orders lead to one state; from it the 4 shortest paths branch:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
  {scene = InfraScene[{pA, pB, seg}, {pA == InfraPoint[a], pB == InfraPoint[b], seg == InfraSegment[pA, pB]}]},
  InfraSceneMultiway[scene, g]["StateGraph"]]
```

The instances are the final states. There is one per shortest path:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
  {scene = InfraScene[{pA, pB, seg}, {pA == InfraPoint[a], pB == InfraPoint[b], seg == InfraSegment[pA, pB]}]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[InfraSceneInstance[inst, seg]], a, b}],
    {inst, InfraSceneMultiway[scene, g]["Instances"]}]]
```

## Scope

Fixed bindings start the exploration further on:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {a = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB, seg}, {pA == InfraPoint[a], pB == InfraPoint[], seg == InfraSegment[pA, pB]}]},
  Length @ InfraSceneMultiway[scene, g, <|pB -> 78|>]["Instances"] == InfraMeasurement[g, InfraSegment[a, 78], "Cardinality"]]
```

The states by the number of constructions done:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
  {scene = InfraScene[{pA, pB, seg}, {pA == InfraPoint[a], pB == InfraPoint[b], seg == InfraSegment[pA, pB]}]},
  #["States"] & /@ InfraSceneMultiway[scene, g]["Layers"]]
```

## Options

### MaxEvents

A bound stops the exploration early. The result says it is incomplete, and why:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
  {scene = InfraScene[{pA, pB, seg}, {pA == InfraPoint[a], pB == InfraPoint[b], seg == InfraSegment[pA, pB]}]},
  InfraSceneMultiway[scene, g, "MaxEvents" -> 3]["Completeness"]]
```

## Properties and Relations

[RandomInfraSceneInstance]() with `All` lists the same instances:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 5], RandomSeeding -> 1]},
  {scene = InfraScene[{pA, pB, seg}, {pA == InfraPoint[a], pB == InfraPoint[b], seg == InfraSegment[pA, pB]}]},
  Sort[InfraSceneMultiway[scene, g]["Instances"]] === Sort[RandomInfraSceneInstance[scene, g, All]]]
```

## Possible Issues

A point drawn from every vertex makes every vertex a branch, and the exploration grows with the graph. Keep such scenes to small graphs; on the 3 × 3 grid the second point has 4 instances:

```wl
With[{g = GridGraph[{3, 3}]},
  {scene = InfraScene[{pA, pB, seg}, {pA == InfraPoint[1], pB == InfraPoint[], InfraDistance[pA, pB] == 2, seg == InfraSegment[pA, pB]}]},
  Length @ InfraSceneMultiway[scene, g]["Instances"]]
```

With two free points every pair of vertices is a branch, and on the grid the exploration does not finish in 30 seconds. A bound stops it:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {scene = InfraScene[{pA, pB, seg}, {pA == InfraPoint[], pB == InfraPoint[], seg == InfraSegment[pA, pB]}]},
  InfraSceneMultiway[scene, g, "MaxStates" -> 500]["Completeness"]]
```
