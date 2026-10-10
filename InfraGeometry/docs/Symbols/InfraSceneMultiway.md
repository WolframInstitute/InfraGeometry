---
Template: Symbol
Name: InfraSceneMultiway
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSceneMultiway
Keywords: [synthetic geometry, graph, construction]
SeeAlso: [InfraBranchialGraph, InfraSceneViewer, InfraScene, RandomInfraInstance]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraSceneMultiway]()[*scene*, *graph*]</code> explores exact finite construction states and retains their incoming events.

<code>[InfraSceneMultiway]()[*scene*, *graph*, *bindings*, *options*]</code> starts with fixed bindings.

## Details & Options

This is an eager finite explorer for small simple undirected unweighted graphs.
Each pool comes from its construction's named token sampler with All.
The scene must carry valid ScheduleValidity provenance. Rebuild an older descriptor from its original object and hypothesis syntax.
Unsupported schedules and selectors stay unevaluated. Unsupported construction pools and assertions retain diagnostics and do not certify completion.

States merge only when completed-construction IDs and exact labeled bindings agree.
Declared sets normalize, while point labels, walk order, repeated traversals and Graph carriers retain their kinds.
All incoming accepted or fixed events survive merging. Pending assertions remain undecided; unsupported assertions alone cannot certify an empty solution set.

The result is an Association containing States, Events, StateGraph, Layers, StepLayers, Instances, Expansions, Frontier, Completeness, Diagnostics and saved scene/substrate/settings.
Event layers count individual constructions. StepLayers are completed group boundaries.
Final or requested-prefix instances are distinct from an unfinished event-depth frontier.

Options "Steps" (All), "MaxDepth", "MaxStates", "MaxEvents", "MaxCandidates" and "MaxTime" (Infinity) bound the request.
Candidate limits bound examinations, not eager All-pool acquisition or temporary memory.
State, event and candidate frontiers retain their exact unfinished obligations.
Requested-prefix and whole-scene completeness are separate; known state vertices alone do not certify missing incoming events.
There is no resumability or hard memory ceiling.
Tube, cylinder and solid-of-revolution profiles must be explicit numeric radii, bands or per-axis lists; cone slopes must be numeric. Function profiles are unsupported in the explorer and are not invoked. Ordinary named samplers retain function-profile support.
Deferred InfraDistance aggregation accepts Min, Max, Mean, Median and Total. Assertions use registered Infra queries and predicates with arithmetic, comparison and Boolean forms. Custom executable heads remain Unsupported without invocation. Literal graph vertices are recognized first, including function-headed labels.
Repeated option rules use their first supplied value. Delayed option rules are unsupported and rejected before evaluation. A False assertion conclusively rejects a root or candidate even when another assertion is Unsupported; rejection diagnostics retain both results.

## Basic Examples

Two construction orders merge at one terminal state.

```wl
SeedRandom[ 71 ]; With[
  { graph = PathGraph[ Range[ 3 ] ] },
  { scene = InfraScene[ { p, q }, { InfraStep[ { p == InfraMidpoint[ 1, 3 ], q == InfraMidpoint[ 1, 1 ] } ] } ] },
  { data = InfraSceneMultiway[ scene, graph ] },
  data[ "StateGraph" ] ]
```

Inspect a bounded frontier.

```wl
SeedRandom[ 71 ]; With[
  { graph = PathGraph[ Range[ 3 ] ] },
  { scene = InfraScene[ { p, q }, { InfraStep[ { p == InfraMidpoint[ 1, 3 ], q == InfraMidpoint[ 1, 1 ] } ] } ] },
  { data = InfraSceneMultiway[ scene, graph, "MaxEvents" -> 3 ] },
  { data[ "Completeness" ], data[ "Frontier" ] } ]
```
