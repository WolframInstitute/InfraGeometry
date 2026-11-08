# Causal constructions copied into InfraGeometry

## 8 November 2026

Pavel requested copying the chains and causal constructions from InfraCausality into InfraGeometry because they describe DAG topology and discrete relativistic geometry.
The direction is InfraCausality → InfraGeometry.
The source repository is retained unchanged.

Source: [WolframInstitute/InfraCausality, revision f98e9ef6a0693810bedf731699092814bc524491](https://github.com/WolframInstitute/InfraCausality/tree/f98e9ef6a0693810bedf731699092814bc524491), version 2.1.1.
The copied code and documentation retain the source authorship and attribution.
The repositories have the same Wolfram Institute MIT code license and CC BY 4.0 mathematical-content license.
Codex performed the integration and verification.

## Scope

- `Kernel/CausalInfrageometry`: causal futures, pasts and diamonds; chains, worldlines and longest-chain geodesics; light cones; causal-set observables; chain kinematics; drawing and viewers.
- `Kernel/CausalTime`: heights, antichains, slices and extremal events.
- `Kernel/EPSAxiomatics`: message and echo relations, selections, radar coordinates, observer fibers and axiom diagnostics.
- `Kernel/CausalSubstrates`: named causal graphs, random causal graphs and their styles.
- The corresponding tests, 44 symbol pages, four guides and the causal-infrageometry tutorial, including their 49 saved Wolfram notebooks.
- The Wolfram-model causal-graph resource and its asset registration.

The continuum Bondi k-calculus module and its figures are not copied.
Existing notebook links to its guide still target InfraCausality.
The new Markdown guides list only the local related guides.
The InfraSubstrates causal-reconstruction example remains in place.

## Integration changes

The copied public symbols use the InfraGeometry context.
Self-imports are removed, and resource lookup and local documentation URIs use InfraGeometry.
The existing package loader exports the 44 copied symbols and the usage file contains their source descriptions.
The copied 3D projection rule applies only when causal objects are highlighted, preserving the existing behavior of unrelated spatial drawings.
No other algorithm was changed.

Loading both packages exposes the same short symbol names in different contexts and can produce shadowing messages.
Use InfraGeometry alone for the copied constructions, or qualify the context when both packages are needed.
Explicitly qualified causal heights and worldline cardinalities were checked with both packages loaded.
This is a source copy, not a compatibility-alias migration of the original package.

## Verification

The local InfraGeometry package loads without an InfraCausality dependency.
All 334 copied tests pass across the initial run and targeted reruns.
The initial run had one kernel-shadowing-message failure and one aborted brute-force test; the two affected files passed all 40 tests when rerun with sufficient evaluation time.
All 296 existing tests in the measurement, highlighting, fibered-graph and substrate suites pass.
All 49 copied notebooks were inspected as native notebook expressions and checked against the source expressions with the intended context and link substitutions.
Saved example outputs were preserved, not reevaluated or certified as freshly generated.
No paclet release, installation, commit or publication was performed.

## Mathematical scope

Copying an implementation does not establish a continuum reconstruction theorem.
The source's longest-chain length and chain-interval definition of light rays are discrete model choices.
The relations between these choices, Lorentzian geometry and continuum EPS assumptions still need explicit hypotheses.
In particular, a causal-height foliation is an antichain partition but need not meet every maximal causal path in every slice.
The stronger Cauchy-slice assumptions and the distinction between ancestry and coarse graining remain in the [InfraSubstrates companion](InfraSubstrates_notes.md).

One source wording correction remains for the paragraph review: causal height is the pointwise least **nonnegative integer-valued** function increasing strictly along every edge.
Without the nonnegativity or an appropriate source normalization, integer-valued time functions can be shifted downward, so there is no least one.
