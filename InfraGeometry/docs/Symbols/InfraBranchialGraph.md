---
Template: Symbol
Name: InfraBranchialGraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraBranchialGraph
SeeAlso: [InfraSceneMultiway, InfraSceneViewer, InfraSceneStep]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraBranchialGraph]()[*data*, *d*]</code> gives the branchial graph at depth *d* of the construction states recorded in *data*, an [InfraSceneMultiway]() result.

## Details & Options

The vertices are the states at depth *d*. Two states are joined when they have a common immediate parent: a state one step earlier from which an accepted event leads to each. A common ancestor further back gives no edge.

The result is an association:

| Key | Value |
|---|---|
| `"Graph"` | the branchial graph |
| `"Depth"` | *d* |
| `"Witnesses"` | for each edge, the common parents |
| `"Complete"` | whether the layer at depth *d* was explored in full |
| `"Frontier"` | the unexplored obligations above depth *d* |

When the layer is not complete, a missing edge does not prove that two states have no common parent.

[InfraBranchialGraph]() reads the saved data. It does not explore further. A depth that was not recorded leaves it unevaluated.

## Basic Examples

A scene that picks a neighbour *p* of the centre of the square grid, then a neighbour *q* of *p*. The four choices of *p* share the root; the sixteen states (*p*, *q*) form four groups, one per *p*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {scene = InfraScene[{p, q}, {InfraSceneStep[{p == InfraPoint[InfraShell[a, 1]]}], InfraSceneStep[{q == InfraPoint[InfraShell[p, 1]]}]}]},
  {data = InfraSceneMultiway[scene, g]},
  GraphicsRow @ Table[InfraBranchialGraph[data, d]["Graph"], {d, 1, 2}]]
```

The groups at depth 2 and whether the layer is complete:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {scene = InfraScene[{p, q}, {InfraSceneStep[{p == InfraPoint[InfraShell[a, 1]]}], InfraSceneStep[{q == InfraPoint[InfraShell[p, 1]]}]}]},
  {branchial = InfraBranchialGraph[InfraSceneMultiway[scene, g], 2]},
  {Length /@ ConnectedComponents[branchial["Graph"]], branchial["Complete"]}]
```

## Properties and Relations

Each edge has one witness at depth 2, the state after the choice of *p*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {scene = InfraScene[{p, q}, {InfraSceneStep[{p == InfraPoint[InfraShell[a, 1]]}], InfraSceneStep[{q == InfraPoint[InfraShell[p, 1]]}]}]},
  {branchial = InfraBranchialGraph[InfraSceneMultiway[scene, g], 2]},
  {EdgeCount[branchial["Graph"]], Union[Length /@ Values[branchial["Witnesses"]]]}]
```
