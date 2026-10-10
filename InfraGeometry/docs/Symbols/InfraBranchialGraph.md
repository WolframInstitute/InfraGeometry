---
Template: Symbol
Name: InfraBranchialGraph
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraBranchialGraph
Keywords: [synthetic geometry, graph, construction]
SeeAlso: [InfraSceneMultiway, InfraSceneViewer, InfraStep]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraBranchialGraph]()[*data*, *depth*]</code> gives the observed immediate-parent branchial relation at an event depth.

## Details & Options

The input is a saved InfraSceneMultiway Association and a nonnegative event depth.
The result contains "Graph", "Witnesses", "Complete" and "Frontier".
Vertices are observed states at that depth, including isolated states.
Two distinct states are adjacent when accepted or fixed incoming events share an immediate predecessor.
Witnesses retain every common immediate parent. A distant common ancestor alone creates no edge.
Completeness and frontier come from the saved exploration; missing edges in an incomplete layer do not prove nonadjacency.
The function reads saved data without sampling or continuing exploration.

## Basic Examples

The two first-construction states share the root.

```wl
SeedRandom[ 71 ]; With[
  { graph = PathGraph[ Range[ 3 ] ] },
  { scene = InfraScene[ { p, q }, { InfraStep[ { p == InfraMidpoint[ 1, 3 ], q == InfraMidpoint[ 1, 1 ] } ] } ] },
  { data = InfraSceneMultiway[ scene, graph ] },
  InfraBranchialGraph[ data, 1 ][ "Graph" ] ]
```

Read their common-parent witness.

```wl
SeedRandom[ 71 ]; With[
  { graph = PathGraph[ Range[ 3 ] ] },
  { scene = InfraScene[ { p, q }, { InfraStep[ { p == InfraMidpoint[ 1, 3 ], q == InfraMidpoint[ 1, 1 ] } ] } ] },
  { data = InfraSceneMultiway[ scene, graph ] },
  InfraBranchialGraph[ data, 1 ][ "Witnesses" ] ]
```
