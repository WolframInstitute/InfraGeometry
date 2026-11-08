# InfraCausality: fundamental DAG constructions

## Accepted scope — 8 November 2026

Pavel requested copying the fundamental constructions on directed acyclic graphs into InfraGeometry.
He clarified that this does not include all of InfraCausality and should have at most one guide page, named InfraCausality.
The earlier broad copy was removed; its record is retained in [Archive](../../Archive/CausalConstructions_261108/initial_broad_copy_provenance.md).

The retained implementation is in `InfraGeometry/Kernel/InfraCausality/`.
It contains seven source files and 23 public symbols for chains, antichains, causal futures and pasts, causal intervals, saturated worldlines, longest chains, discrete light cones, causal height and slices.
The existing measurement protocol supplies their cardinalities, lengths and densities.
Seven corresponding test files live in `InfraGeometry/Tests/InfraCausality/`.
The randomized causal-height test fixture was replaced by the same explicit graph, removing its dependency on the specialized graph generator.

The only added guide is [InfraCausality](../../InfraGeometry/docs/Guides/InfraCausality.md), with its matching [Wolfram notebook](../../InfraGeometry/Documentation/English/Guides/InfraCausality.nb).
It is linked from the README and Branches of Infrageometry.
The four extra guides, copied tutorial and copied symbol-page collections were removed.
Observer/EPS machinery, radar coordinates, specialized causal substrates, estimators, kinematics and viewers remain in the source project.
No causal resource asset or additional paclet dependency is required.

## Source and attribution

Source: [WolframInstitute/InfraCausality, revision f98e9ef6a0693810bedf731699092814bc524491](https://github.com/WolframInstitute/InfraCausality/tree/f98e9ef6a0693810bedf731699092814bc524491), version 2.1.1.
The source repository remains unchanged.
The copied code retains its authorship under the repositories' matching Wolfram Institute MIT license.
Codex performed the scoped copy and prepared the guide under Pavel's direction.
No installation, release, commit or publication was performed.

## Verification and mathematical limits

All 143 retained DAG tests pass after reloading the reduced package.
The native guide matches its intended notebook expression.
The Branches notebook retains every original cell and option, with only the two new InfraCausality links inserted.
The guide's functions are listed without links to the removed symbol pages.

Saturated chains, longest chains and chain-interval light cones are distinct combinatorial constructions.
Their relativistic interpretation does not by itself prove a continuum reconstruction theorem.
Causal-height levels are antichains, but a general such level need not intersect every maximal causal path.
A spatial reconstruction and a choice of inter-slice transport require additional data, as explained in the [InfraSubstrates companion](InfraSubstrates_notes.md).
Loading both packages still gives duplicate short names for the copied symbols; qualify their contexts if both packages are needed.

## Requested spatial machinery — 8 November 2026

Pavel subsequently requested reconstruction from a DAG and foliation, inter-slice associations, spatial frame coordinates and a visual tutorial.
Added `SpatialReconstruction.wl` with `CausalFoliationQ`, `CausalSpatialGraphs`, `CausalSliceRelation`, `CausalSliceMap` and `CausalSliceKernel`.
Added `RectilinearCoordinates.wl` with `FindInfraCoordinateAxes` and `RectilinearCoordinates` in RiemannianInfrageometry.
These are new implementations; the seven copied fundamental modules remain unchanged.
The single InfraCausality guide was extended and one explicitly requested [Spatial Coordinatization tutorial](../../InfraGeometry/Documentation/English/Tutorials/SpatialCoordinatization.nb) was added.
Existing guide cells and options were preserved by targeted insertion.
The [tutorial companion](SpatialCoordinatization_notes.md) records definitions, proofs and limitations.
Codex coordinated three Astra xhigh agents for causal mathematics, coordinates and tutorial design, as explicitly requested.
Validation: 41 new tests and 414 relevant existing tests passed; all nine tutorial blocks evaluated without messages.
Four graphical outputs were rendered and inspected, including the interactive fiber selector.
No commit, installation or publication was performed.

## Release integration — 8 November 2026

The release-wide sampler coverage test identified the four newly imported causal samplers.
They now follow InfraGeometry's existing `RandomSeeding` convention, with explicit reproducibility and outer-state preservation tests.
The copied reproducibility fixture now supplies `RandomSeeding` explicitly; the statistical worldline fixture explicitly uses the seeded ambient stream.
This adaptation changes the three sampler source files and two corresponding test files from the imported baseline; the upstream repository remains unchanged.

Release validation: all 2,835 tests across 86 files passed after the sampler integration.
