---
Template: Guide
Name: InfraCausality
Title: InfraCausality
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/InfraCausality
Keywords: [causality, DAG, partial order, topology, chain, antichain, relativistic geometry, foliation]
RelatedGuides: [InfrageometryBranches, InfraTopology, InfraSubstrates]
RelatedTutorials: [SpatialCoordinatization]
---

## Abstract

InfraCausality contains fundamental constructions on finite directed acyclic graphs.
Vertices represent events, and reachability defines their causal order: an event precedes another when a directed path connects them.
Including equality makes this relation a partial order.
Chains consist of comparable events, while antichains consist of mutually incomparable events.
The order also defines a topology whose open sets are upward closed: containing an event requires containing its causal future.

A worldline is a saturated chain: no event can be inserted between consecutive members.
A longest chain between two events is the discrete model used here for a timelike geodesic.
The discrete light-cone construction retains events whose causal interval with the anchor is itself a chain.
These are combinatorial definitions; recovering classical relativistic geometry requires further assumptions.

Causal height counts the edges of a longest chain from a source to an event.
Its level sets are antichains, but need not meet every maximal causal path.
Spatial reconstruction and comparison between slices are discussed in InfraSubstrates.

## Functions

### Causal order and intervals

- `InfraChainQ` tests an ordered chain in the reachability order
- `InfraAntichainQ` tests a set of mutually incomparable events
- `InfraCausalFuture`, `InfraCausalPast` the future and past of an event or event set
- `InfraCausalDiamond` the causal interval between two events
- `InfraCausalFutureQ`, `InfraCausalPastQ`, `InfraCausalDiamondQ` recognize the corresponding event sets

### Worldlines and discrete relativistic geometry

- `InfraWorldline` the family of saturated chains between events
- `InfraTimelikeGeodesic` the family of longest chains between events
- `InfraFutureLightCone`, `InfraPastLightCone` the discrete light cones defined by chain intervals
- `RandomInfraWorldline`, `RandomInfraTimelikeGeodesic` sample saturated or longest chains
- `RandomInfraFutureLightCone`, `RandomInfraPastLightCone` sample light rays
- `InfraWorldlineQ`, `InfraTimelikeGeodesicQ`, `InfraLightRayQ` test individual chains

### Time and slices

- `CausalHeight` the longest-chain length from a source to each event
- `CausalHeightFoliation` the antichains at each causal height
- `InfraSlice` a causal-height slice or a band of slices
- `InfraSliceQ` tests whether a set is a causal-height slice

### Measuring constructions

- `InfraMeasurement` reads cardinalities, lengths, vertex and edge densities on a graph
- `InfraMemberQ` tests membership in a construction

### Spatial reconstruction

- `CausalFoliationQ` tests an ordered partition into antichains, with every causal edge directed toward a later slice
- `CausalSpatialGraphs` reconstructs an undirected graph on each slice; returns an association indexed from 1

Two distinct events are joined when some lowest common ancestor lies in the preceding `"AncestorDepth"` slices, with default depth 1.
All lowest common ancestors are retained; no unique ancestor is assumed.
Equivalently, a common ancestor lies in that window.
At depth 1, the rule joins events sharing a parent in the preceding slice.
Omitting the foliation uses `CausalHeightFoliation`.
The first slice has no reconstructed edges in this finite past-only model.

### Relations and transport between slices

- `CausalSliceRelation` associates each event in slice i with its causally related events in slice j
- `CausalSliceMap` returns a single-valued association when every image is unique; `"SelectImage"` supplies an explicit selection otherwise
- `CausalSliceKernel` returns nested associations of uniform probabilities over each nonempty causal image

The index pair `{i, j}` specifies the direction: forward when i < j, backward when i > j.
A foliation alone supplies neither a preferred direction of coarse graining nor a canonical choice among several images.
A missing image prevents a total map or conservative kernel.
Selected maps need not preserve spatial adjacency or be onto the target slice.
Independent uniform long-range kernels need not equal compositions of adjacent kernels.
