# Infra Substrates: revision record

## 8 November 2026 — causal reconstruction and comparison of densities

The user requested a written example in InfraSubstrates: a DAG of events, a foliation into Cauchy-like slices, spatial edges from lowest common ancestry, and the question of a natural coarse-graining map between slices.
The user then specified that comparison of geometric objects should retain identity across substrates and transport densities while preserving the integral.

Added six paragraphs to the Markdown guide and the matching saved Wolfram notebook:

1. A layered causal reconstruction with explicit path-crossing assumptions.
2. The predecessor relation and the branching-and-merging diamond.
3. The distinction between temporal ancestry and spatial coarse graining.
4. Pushforward of measures, the observable identity, and injections versus weighted lifts.
5. Stochastic ancestral transport and its symmetric diamond example.
6. Weak convergence through metric approximation maps, with resolution distinguished from time.

The additions sit after the existing spatial-graph paragraph, observer-scale paragraph, and paragraph introducing Gromov–Hausdorff limits.
The original guide paragraphs, attribution, review date, notebook metadata and all existing cells remain unchanged.
The original versions remain in Git history.
No package implementation, publication or claim of a general convergence theorem is included.

The mathematical formulation and wording were prepared by Codex in response to the user's explicit request.
Future revisions should preserve both the causal-reconstruction motivation and the requirement of mass-preserving transport.
A many-to-many ancestry relation must not silently be treated as a canonical single-valued map.

## 8 November 2026 — ownership of causal constructions

The user clarified that the DAG chains and causal geometric constructions should be copied from InfraCausality into InfraGeometry.
The implementation, tests and documentation were copied into this repository; nothing was removed from InfraCausality or from the existing InfraSubstrates guide.
The [copy record](CausalConstructions_provenance.md) gives the pinned source, adaptations, verification and remaining mathematical qualifications.

## 8 November 2026 — narrowed scope

Pavel clarified that only fundamental DAG constructions belong here, with a single InfraCausality guide.
The broad copy was reduced accordingly; observer/EPS machinery, specialized models and the extra documentation were removed.
The causal reconstruction paragraphs in InfraSubstrates are unchanged.
