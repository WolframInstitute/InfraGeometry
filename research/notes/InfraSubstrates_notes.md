# Infra Substrates: causal slices and transport of measures

Companion to the [selected guide](../../InfraGeometry/docs/Guides/InfraSubstrates.md) and its [saved notebook](../../InfraGeometry/Documentation/English/Guides/InfraSubstrates.nb).
No matching companion existed before this work.
The user requested the causal-reconstruction example and mass-preserving comparison of densities on 8 November 2026.
Six explanatory paragraphs were added in the relevant parts of the guide; existing paragraphs and package code were retained.

## Spatial reconstruction and persistence

The added example assumes a finite layered event DAG.
Every edge advances one layer, and every maximal directed path crosses every layer.
These hypotheses make the layers antichains that meet every maximal causal path exactly once.
An arbitrary foliation into antichains need not have this stronger property.

The supplied one-light-tick reconstruction is made precise by joining two events in a layer when they share a parent in the preceding layer.
In a general DAG, lowest common ancestors mean maximal common ancestors in the reachability order; they need not be unique.
The choice of the one-tick threshold is part of the reconstruction rule.

For consecutive layers, define

$$R_t=\{(x,y)\in\Sigma_t\times\Sigma_{t+1}:x\prec y\},\qquad P_t(y)=\{x:(x,y)\in R_t\}.$$

Both projections of this relation are onto under the stated path-crossing hypothesis.
The backward relation is a function exactly when every $P_t(y)$ is a singleton.
For three slices crossed by every intervening causal path, the long-range ancestry relation is the composition of the two shorter relations.
One inclusion follows by concatenating causal paths; the other follows by intersecting a causal path with the intermediate slice.

In the diamond $a\to b\to d$, $a\to c\to d$, the middle spatial graph is the edge $b-c$.
The backward relation sends $b,c$ uniquely to $a$, but $P_1(d)=\{b,c\}$.
The automorphism exchanging $b,c$ fixes $a,d$, so no selection of one predecessor of $d$ is invariant under all symmetries of this example.
A normalized predecessor distribution is possible without breaking that symmetry.

Time evolution, spatial coarse graining, and refinement of a discretization are distinct operations.
A chosen coarse map records a coarse identity and its fine fiber, not an invertible identity of individual vertices.
A causal relation records possible ancestry; a stochastic kernel records distributed ancestry.
None of these alone proves preservation of spatial adjacency or metric approximation.

## Observer scale and mass-preserving transport

For finite vertex sets and a map $q:V_f\to V_c$, transport vertex masses by

$$\mu_c(x)=(q_*\mu_f)(x)=\sum_{q(y)=x}\mu_f(y).$$

Reordering the finite sum proves the observable identity

$$\sum_x\varphi(x)\mu_c(x)=\sum_y\varphi(q(y))\mu_f(y).$$

Total mass preservation is the case $\varphi=1$.
The same definition works for an injection, assigning zero mass outside its image.

If $\rho_f$ is a density relative to positive vertex weights $m_f$, then $\mu_f(y)=\rho_f(y)m_f(y)$.
If the coarse reference weights are $m_c=q_*m_f$ and $q$ is onto, the transported density is

$$\rho_c(x)=\frac{\sum_{q(y)=x}\rho_f(y)m_f(y)}{\sum_{q(y)=x}m_f(y)}.$$

This is a weighted average because the reference measure is also transported.
If both reference measures instead assign unit weight to each vertex, density masses are summed over fibers.
Simply copying a coarse density to every fine vertex generally changes its integral.
To lift coarse mass through a surjection, specify weights $L(x,y)$ supported on $q(y)=x$ with $\sum_yL(x,y)=1$.
Then $\mu_f(y)=\sum_xL(x,y)\mu_c(x)$ preserves mass and satisfies $q_*\mu_f=\mu_c$.

For causal slices use $K_t(y,x)\geq0$ supported on $x\in P_t(y)$, with $\sum_xK_t(y,x)=1$.
Then $\mu_t(x)=\sum_yK_t(y,x)\mu_{t+1}(y)$ preserves total mass.
The same interchange of finite sums gives the dual identity against observables.
Kernels compose by matrix multiplication, which preserves row sums of one.
Uniform weights over available predecessors are one possible rule; path-count weights or a deterministic selection give other rules.

## Metric and measure convergence

Use $n$ for resolution and $t$ for causal time.
The added weak-convergence formula uses metric approximation maps $f_n:V_n\to X$ for rescaled connected graph metrics and a compact limiting space $X$.
It states precisely that $(f_n)_*\mu_n$ converges weakly to $\mu$.
No assertion is made that a general causal graph or its spatial reconstruction satisfies the required metric estimates.

Mass preservation is necessary for comparison but does not imply weak convergence.
Nor must pushing forward the uniform occupation measure of fine shortest paths give the uniform occupation measure of newly constructed coarse shortest paths.
Commutativity, or a controlled approximation to it, is an additional research condition.
Likewise, independently chosen long-range kernels need not equal compositions of adjacent kernels; the coherent system must be specified.

The remaining research question is to construct observer-compatible comparisons that have controlled metric distortion and compatible object measures.
The example settles the need for relations or additional choices; it does not settle that convergence question.

## Sources and verification

The user subsequently requested copying the causal constructions from InfraCausality into InfraGeometry.
Only the fundamental DAG constructions are retained: chains, antichains, causal intervals, worldlines, longest chains, light cones and slices.
See the [copy record](CausalConstructions_provenance.md) and the single [InfraCausality guide](../../InfraGeometry/docs/Guides/InfraCausality.md).
The common-parent spatial reconstruction in this guide remains a separate construction: `InfraSlice` returns an induced causal slice, whose single-layer subgraph has no causal edges.
The copy does not supply a canonical inter-slice function or prove metric-measure convergence.

- The user supplied the spatial reconstruction by common ancestry and the requirement to preserve integrals.
- Stephen Wolfram, [*Foliations of Causal Graphs*, §6.9](https://www.wolframphysics.org/technical-introduction/the-updating-process-in-our-models/foliations-of-causal-graphs/), explains foliations compatible with causal order.
- Stephen Wolfram, [*Time and Spacetime*, §8.5](https://www.wolframphysics.org/technical-introduction/potential-relation-to-physics/time-and-spacetime/), describes event DAGs, reachability, and observer-dependent slices.
- These sources provide background; the precise layered model, diamond example and transport formulas here are an explicit mathematical formulation of the user's proposed example, not quotations of those sources.
- The diamond paths, predecessor distances, mass conservation and observable identity for the symmetric kernel were checked with exact arithmetic in the existing Wolfram kernel.
- The native notebook was checked against its saved baseline after removing the six inserted cells; existing cells and options were preserved.
- The pushforward paragraph and its formulas were rendered and visually inspected.
- Added text was prepared with Codex under the user's explicit request. No novelty claim is made. See the [revision record](InfraSubstrates_provenance.md).

## Implemented spatial reconstruction — 8 November 2026

The subsequent explicit request is now implemented by `CausalSpatialGraphs`, separately from the induced causal `InfraSlice`.
`CausalSliceRelation`, `CausalSliceMap` and `CausalSliceKernel` supply inter-slice associations in either requested direction.
The map requires singleton rows or an explicit selection; the kernel requires nonempty rows.
These constructions preserve the distinctions and limitations above.
See the [Spatial Coordinatization tutorial](../../InfraGeometry/Documentation/English/Tutorials/SpatialCoordinatization.nb) and its [mathematical companion](SpatialCoordinatization_notes.md).
