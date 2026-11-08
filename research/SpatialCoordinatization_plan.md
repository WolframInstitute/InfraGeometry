# Spatial reconstruction and coordinatization

Requested by Pavel on 8 November 2026.
Keep one InfraCausality guide and add one Spatial Coordinatization tutorial.
Do not restore the removed EPS, radar, model-generator or viewer modules.

## Implementation

1. Validate an ordered antichain partition of a finite DAG.
2. Reconstruct each slice using common ancestors in a finite number of preceding slices.
   The default depth is one; omitting a depth cutoff would turn descendants of a common root into a clique.
3. Return associations for relations, selected maps and conservative uniform kernels between specified slice indexes.
   Support both directions; a general foliation supplies neither a canonical selection nor a guaranteed graph quotient.
4. Construct oriented spatial axes through an origin and direction vertices.
   Preserve the shortest-path interval excess during extension, with deterministic tie breaking.
5. Assign signed nearest-axis projection coordinates, selecting the minimum tied integer by default.
   Accept explicitly supplied axes and keep this spatial function independent of causal reconstruction.
6. Build a tutorial from a causal graph, its foliation and four nearby chains to slice coordinate maps and fibered graphs.
   Include visible fibers and a small regular-grid calibration.

## Mathematical checks

- All lowest common ancestors are retained; do not select one silently.
- A missing causal image prevents a conservative kernel or total selected map.
- A selected map preserves total mass under pushforward, but need not preserve adjacency or be onto the target slice.
- Independent uniform kernels need not compose to the direct uniform kernel.
- Axis projections on nonorthogonal frames are coordinate labels, not oblique basis coefficients.
- The coordinate image lies in an integer lattice; its induced quotient graph need not be the nearest-neighbor lattice or a fiber bundle.
- Parallel transport requires a specified connection and does not follow from a foliation alone.

## Verification and delivery

Run deterministic tests of reconstruction, label handling, map direction, mass preservation, axis orientation, ties and coordinate fibers.
Check the new tutorial examples in the existing Wolfram kernel, inspect the rendered figures, and save their checked outputs in the new notebook.
Preserve all unrelated human-edited notebooks and existing guide paragraphs.
Record mathematical definitions and the limits of the first implementation in the tutorial companion.

Status: complete. Seven public functions implemented; 41 new tests and 414 existing regression tests pass. Nine tutorial blocks evaluated without messages. Saved input expressions, preserved guide cells and four rendered graphical outputs checked.
