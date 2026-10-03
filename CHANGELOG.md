# Changelog

## Unreleased

- **1.5.0** (2026-10-03): **fibered graphs, sections and connections** (InfraFibrations). New exports: the heads `InfraFibration`, `InfraTangentBundle`, `InfraCotangentBundle`, `InfraDisplacementBundle`, `InfraSection`, `InfraConnection`; the primitives `InfraTotalGraph`, `InfraFibrationAssociation`; `InfraBaseGraph`, `InfraFiber`, `InfraFibers`, `InfraRays`, `InfraBundleMorphism`, `InfraBundleMorphismQ`, `InfraFibrationQ`, `InfraFiberBundleQ`, `InfraSectionQ`, `InfraContinuousSectionQ`, `InfraConnectionQ`, `InfraFlatConnectionQ`, `RandomInfraFibration`, `RandomInfraSection`, `RandomInfraConnection`, `FindInfraSection`, `FindInfraHorizontalLift`, `InfraParallelTransport`, `InfraHolonomy`, `FindInfraLeviCivitaConnection`, `InfraHolonomyAngle`, `InfraCovariantDerivative`, `InfraCanonicalOneForm`. Ported from InfraGaugeTheory, which is untouched; five of the names (`InfraParallelTransport`, `InfraHolonomy`, `InfraHolonomyAngle`, `InfraCovariantDerivative`, `InfraCanonicalOneForm`) exist there with other signatures and shadow when both paclets are loaded in one kernel. Symbol pages for all 31 exports; the Infra Fiber Bundles and Infra Analysis guides list them in place of their waits lines. T8 adds `InfraFiberedSubstrate`, the catalogue of fifteen example fibrations (trivial, covering, tangent, displacement, non-bundle) at three sizes, each a fibration head.

- **1.4.0** (2026-10-02): **breaking — regions are inert heads** (InfraRegions). New exports `InfraTube`, `InfraCylinder`, `InfraCone`, `InfraSphere`, `FindInfraSphere`; `InfraBall` and `InfraShell` become inert heads that `InfraMeasurement` and `FindInfraRepresentative` evaluate on a graph, with the nine properties of a set (`"VertexDensity"`, `"EdgeDensity"`, `"Cardinality"`, `"Faithful"`, `"Subgraph"` and the four volumes). Deleted, no alias: `FindInfraBall` (read `FindInfraRepresentative[g, InfraBall[c, r]]`), `FindInfraCylinder`, `FindInfraCone`, and `InfraVolume` with its `"Measure"` option (read the properties `"Volume"`, `"BoundaryVolume"`, `"InteriorVolume"`, `"HalfBoundaryVolume"`). `FindInfraShell[g, c, r]` is the level set only; its count, `Properties` and `Method` moved to `FindInfraSphere`, and a scene that wants the separating subsets writes `InfraSphere[c, r]`. The new cone is the union of the balls of radius `slope (i - 1)` about the axis. The reference pages of the four deleted symbols are removed and the Euclidean and Riemannian guides list the regions; the documentation notebooks are rebuilt in the next docs release.

- **1.3.1** (2026-10-02): **breaking — `InfraVertexList` is renamed `FindInfraRepresentative`** (InfraRepresentative T3). No alias. It is the one generic finder of an inert head's members: the count `n | UpTo[n] | All`, the modifier `"RandomChoice"` and, under `All`, `"Pruning" -> q`, and nothing else. Segments, rays, lines and arcs are read off their graphs as before. The circle is now read by the sweep, `FindInfraCircle` at its defaults; the necklace graph stays what `InfraMeasurement` measures. The scene tokens `InfraShell`, `InfraBall`, `InfraPlane`, `InfraPolygon`, `InfraTriangle`, `InfraPolyline`, `InfraRevolution`, `InfraWalk`, `InfraPoint` and `InfraLine[path]` are clauses of it, read by their searches at the defaults; on a search with a method ladder `"RandomChoice"` is `Method -> "RandomGreedy"` and `"Pruning" -> q` is `Method -> {"Exhaustive", "Pruning" -> q}`. The scene engine calls the export: it strips `"Select"` and `"Branches"` from a token and applies them to the returned `List`, and reads a scene circle `InfraCircle[c, r]` as `InfraCircle[c, "Radius" -> r]`. Segment, ray and line tokens now branch in the lexicographic chain order of the graph instead of `FindPath` order. Every specialised `Find*` is unchanged.

- **1.3.0** (2026-10-02): **breaking — three exports leave.** The kernel is restyled to the global Wolfram code style (KernelStyleCleanup): comments gone except the category headers, lines doing mathematics and the reasons of fast paths; every `::bad*`, `::unbounded`, `::eventsided`, `::deadevent` and `::mismatch` message gone, an unknown `Method`, property or count being a non-match that stays unevaluated and a search with no instance giving `{ }`; `Module`, `AppendTo` and `Function` gone from every definition but the two Todd-Coxeter engines, which keep their imperative form for speed; spaced brackets, bodies on a new line, lines under 150 characters, ASCII only; `ImageSize` defaults and hard-coded colours out of the kernel, the viewers keeping the strike-out palette and their dark-mode chips. `CosetEnumeration`, `LowIndexMaps` and `RotationMapGraph` become internal to `TessellationGraphs.wl`; their lines leave the Infra Substrates guide. Every other export and usage is unchanged. Large `All` enumerations are faster and deep searches that hit `$RecursionLimit` now finish; `FindInfraWalk` on the 20x20 grid is within 1.5x.

- **1.2.0** (2026-10-01): the Euclidean guide is closed. It has no "waits" line: the midpoint, the equidistant set, the ball, the segment, ray, line and arc searches are listed as finders, `InfraIntersection`, `InfraUnion` and `InfraSceneInstance` as objects and scene parts, and a "Not here" section names what is left out and where it went (the ball hull on the Infra Topology guide, the tube volumes on the Riemannian guide, the cone, sphere and quadric heads in the backlog item InfraRegions). Every symbol page the guide links has its example run in a fresh kernel. Kernel fixes: `InfraUnion` is accepted as a scene token (one branch per vertex of either operand), a list of heads or of walks given as one entry of `InfraSubstrateHighlight` draws as their sum, six usage messages say "sorted vertex list" instead of "multiset", and the dead `"Gray"` argument is gone from six doc sources. The `"Embedding"` method leaves the `FindInfraMidpoint` page. The pages of the deleted `FindInfraRadarBasis` and `InfraRadarBasisQ` are removed. No new export.

- **1.1.3** (2026-10-01): documentation only; no kernel change. The six guides are named after the branches: Euclidean Infrageometry, Riemannian Infrageometry, Infra Substrates, Infra Fiber Bundles, Infra Analysis (tangent spaces and differential forms) and Infra Topology, with Experimental unchanged; their URLs change with the names. The Euclidean and Riemannian guides open with one introduction to infrageometry, in math mode: the two branches, no infinitesimality and the observer scale, the claim that limits of graphs capture a surface, and the multi-valued constructions read by their vertex densities. The Euclidean guide says shortest path, not geodesic. Every example on the symbol pages the two guides link ends in a picture: a construction drawn with `InfraSubstrateHighlight` on an `InfraSubstrate` tiling, or a measurement as a plot, with a number or a predicate value only beside the picture it belongs to.

- **1.1.2** (2026-10-01): the Riemannian guide is closed and the first tutorial ships. The guide names only what works: the Riemann tensor leaves it for one "not here" line, `InfraSubstrate` joins the volume measurements and `MetricTensorTutorial` is its related tutorial. `MetricTensorTutorial`, the metric tensor of a graph in pictures over size and substrate, is built from `docs/Tutorials/`. Two geodesic fixes: at the tie `FindInfraGeodesic[g, p, x, Infinity]` the endpoint reading wins unless a `Properties` rule bounds the pointed class, and `ExtendInfraGeodesic` / `ExtendInfraWalk` under `"Minimizing"` give no extension of a seed that is not a geodesic at the scale (a both-sides extension from a short seed no longer joins into a non-geodesic). No new export.

- **1.1.1** (2026-10-01): documentation only; no kernel change. The docs site is rebuilt from `docs/` at 1.1 and republished; the seven hand-made guide and tutorial pairs without a source are retired; the Experimental guide is checked against the export list; `InfraSubstrate` is named a Riemannian-branch file in the resource definition. The README's presentation and example-graphs notebooks are rebuilt from `Wiki/Notebooks/` and open without a login; the dead `EmergentEuclid` link, which had no source, is dropped.

- **1.1.0** (2026-09-29): **breaking — four renames to the names of the Euclidean guide scheme**
  (EuclideanGuideScheme T4). No aliases. `InfraHighlightGraph` is `InfraSubstrateHighlight`,
  `InfraGeometricStep` is `InfraStep`, `GeodesicIntervalGraph` is `SegmentGraph` (the graph of
  `InfraSegment[u, v]`) and `GeodesicSprayGraph` is `SprayGraph`; definitions, options and return
  shapes are unchanged. Their reference pages move with them. The Euclidean guide is rewritten to
  the six sections of the user's scheme and lists all four; every export the scheme does not name
  moves to the Experimental or the Riemannian guide (T2, T3).

- **1.0.1** (2026-09-29): four new guides from the PacletBlueprint, *Topological Properties*, *Tangent Spaces and Forms*, *Fiber Bundles* and *Substrates*; the Experimental guide keeps 170 entries, the rest now on those guides, and the Riemannian guide hands them its covering dimension, ball intersection complex, tangent germs and Levi-Civita sections. Documentation only; no kernel change.

- **1.0.0** (2026-09-28): the paclet is renamed `WolframInstitute/InfraGeometry`, context `WolframInstitute`InfraGeometry``; the paclet directory, the loader `Kernel/InfraGeometry.wl` and the guide `InfraGeometryGuide` follow, and every reference to the sibling paclet names it `DiscreteGeometry` (formerly `Infrageometry`). No symbol changed. The cloud object `SyntheticInfrageometry.paclet` is frozen at 0.17.2; new installs use `InfraGeometry.paclet`.

- **0.17.2** (2026-09-27): `InfraHighlightGraph` (below).

- **Breaking: `InfraSceneHighlight` is renamed `InfraHighlightGraph` and draws densities**
  (InfraHighlightGraph, 2026-09-27). No alias. Every object in the list becomes a vertex density
  and an edge density — a vertex, a density, `InfraWalk[{p1, ..., pk}]`, a Euclidean head (its
  `"VertexDensity"` and `"EdgeDensity"`), an intersection or union of heads, a walk graph, a leg
  chain, a region, a list of these. Each is divided by its heaviest mass and the objects are summed:
  strength capped at 1, colour the mass-weighted blend, so overlaps show both objects. A head draws
  the edges its members use, never the chords of its support; an object with one member is one
  stroke. A `Directive` in the list styles the objects after it; `obj -> style` stays. The `i`-th
  object takes the `i`-th colour of `$InfraStrikeOutPalette`. Removed: the seven shape classes,
  `"Palette" -> None` and the `"Shapes"` column of `$InfraPalette`. The viewers draw
  `InfraSegment` and `InfraCircle` heads when no selector is set.

- **0.17.1** (2026-09-27): `InfraMetricTensor` (below), the polyline density fix and the bundle sums.

- **The density of a polyline counts its members.** `InfraSegment[g, p1, ..., pk]` and
  `InfraArc[g, c, {p1, ..., pk}]` gave the sum of the piece densities; a vertex of piece `i` now counts
  `occ_i(v)` times the product of the other pieces' counts, an inner knot once less.

- **Bundles sum by `GroupBy`.** `InfraDensity` of a list and the edge multiset of `InfraSceneHighlight`
  no longer use `Merge[..., Total]`, which is quadratic in the member count: 89 s to 8 s on 24389 walks.

- **`InfraMetricTensor`, the interval-projection metric tensor.** `InfraMetricTensor[g, p]` is the matrix
  over vertex pairs `(v, w)` of `d(p, u) / d(p, v)`, with `u` the vertex of the interval `I(p, w)` closest
  to `v`; `InfraMetricTensor[g, p, r]` restricts it to the shell `FindInfraShell[g, p, r]`. Option
  `"SelectCoordinate" -> Min | Max | Mean | Median | All | f` reduces tied feet. In the plane it is
  `max(0, cos θ)` on a circle; on the square grid it is `1 - d(v, w)/(2r)` on every shell. Every row comes
  from one `GraphDistanceMatrix`. Reference page and a line in `EuclideanGeometryGuide`.

- **The `EuclideanInfrageometry` category, 0.16.0** (2026-09-22). The kernel gains its first named
  category in the `WolframInstitute/PureMath` layout: `Kernel/EuclideanInfrageometry/` holds
  `InfraSegment.wl`, `InfraRay.wl`, `InfraLine.wl`, `InfraCircle.wl`, `InfraScene.wl`,
  `InfraSceneVisualization.wl` and `InfraSceneInteractive.wl`, `Tests/EuclideanInfrageometry/` mirrors
  it, and the test runners discover `.wlt` files recursively. The `Package` loader reads subfolders
  as it reads the root, so nothing else moves.

- **Breaking:** the five Euclidean object heads evaluate. `InfraSegment[g, p, q]`, `InfraRay[g, o, v]`
  (and `InfraRay[g, o]`, the pencil), `InfraLine[g, p, q]` (also through a walk graph or an
  `InfraSegment`), the new `InfraCircle[g, c, p]` and the new symbol `InfraArc[g, c, p, q]` each
  return `head[<| "Atoms" -> {dag, ...}, anchors ... |>]`, an object standing for the whole family:
  `obj[[i]]`, `obj[[i ;; j]]`, `Normal`, `First` enumerate in canonical order; `"Multiplicity"` /
  `Length`, `"InfraDensity"`, `"EdgeDensity"`, `"Length"`, `"Graph"`, `"VertexList"` read the DP off the
  atoms; `HighlightGraph`, `InfraSceneHighlight`, `InfraDensity` and the `*Q` predicates accept the
  objects; each has a summary box. Without the substrate the heads stay the `InfraScene` tokens.
  Each head carries its own complete copy of the protocol (the self-contained rule) on the exported
  `FindInfraSegment` / `FindInfraRay` / `FindInfraLine` carriers and `GeodesicIntervalGraph` /
  `GeodesicOccupation` / `GeodesicEdgeOccupation`. `Find*` is unchanged.

- **The circle through a point.** `InfraCircle[g, c, p, "Tolerance" -> t | {tIn, tOut}]` is the family
  of shortest simple cycles through `p` in the band `d(c, p) - tIn .. d(c, p) + tOut` that separate `c`
  from beyond, carried by the circle pool cut along a radial seam through `p` with every atom rotated
  to start at `p` (source `p`, sinks adjacent to `p`, closing edge implicit); exact on planar bands the
  seam cuts open, the length sweep under `::uncertified` otherwise, the message firing only when the
  sweep finds circles the carrier could not hold. Verified against brute force on grids (families up
  to 256) and on triangular and hexagonal patches. `"Graph"` is the atoms' union with the closing
  edges, oriented alike where shared positions allow; it is acyclic away from `p` in most cases but
  not all, since two circles can pass a neighbour of `p` once leaving and once returning.

- `InfraRayQ` on a `List` of graphs reached the vertex-list rule first and failed; the graph rules now
  precede it.

- `$infraShapeColors` gains the classes `Segment`, `Ray`, `Line`, `Circle` (and `Arc`, drawn as a
  circle), so the objects reach their construction's colour when the palette is off.

- **The documentation tree follows the walk rename** (NotebookWalkAudit T3). The three sets now coincide: 187 exported symbols, 187 `docs/Symbols/*.md` sources, 187 built reference pages. Ten pages for symbols the kernel no longer exports are deleted — `InfraPath`, `InfraPathQ`, `FindInfraPath`, `ExtendInfraPath`, `ConcatenateInfraPath`, `SelectInfraPath`, `SelectInfraCycle`, `$InfraPathColor`, `UniquePencilQ`, `FindForwardDeformation` — and the whole walk family gains one: `FindInfraWalk`, `FindInfraGeodesic`, `ExtendInfraWalk`, `ExtendInfraGeodesic`, `SelectInfraWalk`, `ConcatenateInfraWalk`, `InfraWalk`, `InfraWalkQ`, `InfraGeodesicQ`, `InfraImmersedQ`, `InfraGenericQ`, `InfraWalkCrossingQ`, `WalkSingularities`, `$InfraWalkColor`, `$InfraAccentPointSize`, `$InfraPointSizes`, `$InfraStrikeOutPalette`, with `InfraDeformationSize` and `InfraDensity`. Cross-references to the deleted wrapper heads are swept: `InfraMeasure` and `InfraEffectivePoint` become `InfraDensity`, `InfraSet` a vertex `List` or a density, `InfraString` the free loop.

- **Nothing tropical** (NotebookWalkAudit T2b). `TropicalConvexityGuide.nb` and `TropicalConvexityTutorial.nb` are deleted with their four cross-references. Both documented four `MetricAlgebra.wl` symbols under a tropical title and had no `docs/` source. No symbol lost documentation.

- **The four tutorials follow the rename and the count-less flip** (NotebookWalkAudit T2). `PathSpaceTutorial`, `EuclideanGeometryTutorial`, `ProjectiveGeometryTutorial` and `TropicalConvexityTutorial` evaluate clean in a fresh kernel; `PathSpaceTutorial`'s cycles section moves to the band `{2, 3}`, the shell `2` carrying no cycle on the 5x5 grid.

- **Breaking:** the renderer keys on **shape**, not on a head (InfraWrapperOntology T7). `inkClass[graph, x]` names the class — `Point`, `Density`, `Set`, `SetFamily`, `Walk`, `Polyline`, `PolylineFamily` — and `InfraSceneHighlight` has one ink row per class; `$infraHeadColors` and the `"Points"` / `"Paths"` / `"Cycles"` / `"Sets"` type strings are gone. Two user-visible consequences: a vertex `List` now draws as a **region**, and `InfraDensity[graph, set]` is how you ask for a point family instead; polyline knots and polygon corners are back, read off the leg chain. Only three of the ten named colors are shape-reachable — `$InfraPointColor` (`Point`, `Density`), `$InfraBallColor` (`Set`, `SetFamily`), `$InfraWalkColor` (`Walk`, `Polyline`, `PolylineFamily`) — the other seven name a construction no carrier remembers, and a caller cites those by name. `$InfraPalette`'s `"Heads"` column is now `"Shapes"`; `$InfraSceneHighlightPalette` is deleted. Every class normalises its opacity by its heaviest mass.

- **Breaking:** `InfraMeasure` is replaced by `InfraDensity[graph, x]` (InfraWrapperOntology T6) — the raw marginal of any shape to the vertex set, `<|v -> m|>` against the counting measure, and the **one** public coercion in the API. It takes no `Method` and no `"On"`: the two normalisations are one division away (`d / Max @ Values @ d` for the occupation, `d / Total @ d` for the distribution), and edge weights are internal to the renderer. `Counts` promotes a vertex list to a density, `Keys` demotes a density to its support.

- **Breaking:** `InfraHomotopy` is deleted (InfraWrapperOntology T6). A chain is the `List` of walk graphs it passes through, under the count contract — `["Realizations"]` is that `List`, `["Mass"]` is `Length`, and `["Weights"]` was always all-ones. `FindInfraHomotopy` and `FindInfraHomotopyRepresentativeHomotopy` default to one chain (`Automatic`), not `All`.

- **Breaking:** `InfraIntersection` and `InfraUnion` are graph-first — `InfraIntersection[graph, s1, s2]` (InfraWrapperOntology T6). Without a substrate a set of list-labelled vertices and a family of sets are the same expression: on `TessellationGraph[{4, 4}, 2]`, `InfraIntersection[ball1, ball2]` returned `{1, 2}`, the coordinates. The scene token is unaffected, its first argument being a construction. `InfraEqualQ`'s cross-head refusal is dropped: `Method` names what is compared, so a point in a set overlaps and a walk equals its support under `"Set"`.

- **Breaking:** the **count contract** on every `Find*` (InfraWrapperOntology T5). A count-less call gives **one instance** (`{ }` when there is none), `n` or `UpTo[n]` a `List` of them (a strict `n` failing on under-supply), and `All` the `List` of instances — except in the geodesic class, where `All` is the interval **DAG**: `FindInfraSegment[graph, p, q, All]` is the geodesic graph again, and a multi-source call gives a `List` of DAGs. Closed families — circle, ellipse, polygon, triangle, regular polygon — give a `List` of cycle graphs under `All`. `ExtendInfraSegment` and `FindInfraLine` accept `UpTo[k]` alongside their bare `k`.

- **Breaking:** the `Infra*` payload wrappers are gone; **the shape is the kind** (InfraWrapperOntology T2, T3, T5, T6). A point is a vertex of the substrate, carrying its label verbatim; a set is a sorted, duplicate-free `List`; a density is a key-sorted Association `<|v -> m|>`, and appears only where multiplicity is real; every 1-d object is a `Graph` — a directed path graph for one walk, a directed cycle for a closed one, a DAG for a geodesic bundle — and a polyline, polygon or triangle is the `List` of its legs, one path graph each, consecutive legs sharing a knot. Every 2-d object (ball, shell, plane, elliptic shell, revolution, quadric) is a set.

  Deleted as payload heads: `InfraPoint`, `InfraSet`, `InfraWalk[{…}]`, `InfraLoop`, `InfraString`, `InfraObject`, `InfraEffectivePoint`, `InfraMeasure`, `InfraHomotopy`, `InfraInterval` / `FindInfraInterval`, the `Infra<Kind>[reps_List]` realisation lists, and the `meta` slot. The fifteen **construction** heads survive only as scene-DSL tokens (`InfraSegment[p, q]` inside an `InfraScene`) and as the `Find*` names; `InfraSet` goes outright, naming no construction and binding in no scene.

  Every accessor goes with the wrapper, replaced by a Wolfram operation on the shape: `["Vertices"]` → `VertexList` or `Keys`, `["Length"]` → `EdgeCount` or `Length`, `["Graph"]` → the object itself, `["Measure"]` / `["Multiplicity"]` → `InfraDensity[graph, x]`, `["Realizations"]` → the `List` a bounded count or `All` returns, `["Sides"]` / `["Knots"]` → the leg list and `polylineToKnots`, `obj[[k]]` → `Part` of that `List`. `["Meta"]` has no replacement.

  The rule the design is held to: **every return value is a legal `HighlightGraph` argument** — a vertex, a vertex list, a `Graph`, a list of `Graph`s. Associations carry mass and nothing else.

- Documentation: the eight reference pages for symbols this refactor deleted (`InfraSet`, `InfraObject`, `InfraEffectivePoint`, `InfraMeasure`, `InfraHomotopy`, `InfraLoop`, `InfraString`, `$InfraObjectColor`) are removed with their `docs/Symbols/*.md` sources; `docs/Symbols/InfraDensity.md` replaces `InfraMeasure.md`.

- **Breaking:** a walk is a `Graph`, never a wrapper (InfraWrapperOntology T4). `FindInfraWalk`, `FindInfraGeodesic`, `ExtendInfraWalk`, `ExtendInfraGeodesic`, `ConcatenateInfraWalk`, `FindEmbeddingClosestPath` and `FindInfraHomotopyRepresentative` return each walk as a directed `PathGraph` on the position pairs `{i, v}` — `EdgeCount` is the length, `Last /@ VertexList` the vertex sequence, `GraphUnion` the bundle; a closed walk is a directed cycle on them, the constant loop one vertex with a self-loop. The heads `InfraWalk[{…}]`, `InfraLoop` and `InfraString` are gone (`InfraWalk[v1, …, vk]` survives as the scene token); every consumer — `InfraWalkQ`, `InfraGeodesicQ`, `WalkSingularities`, `InfraImmersedQ`, `InfraGenericQ`, `InfraWalkCrossingQ`, `SelectInfraWalk`, `EmbeddingClosest`, `InfraDeformationSize`, `InfraParallelQ`, `InfraVolume`, `FindInfraOsculatingShell`, `FindInfraRevolution`, the homotopy finders, `InfraSceneHighlight`, `InfraDistance` — takes a walk graph, a list of them, or a bare vertex list. The homotopy class is read off the shape: an open walk has its endpoints fixed, a cycle graph is the based loop, `"FreeHomotopy" -> True` frees either (the former `InfraString`); `FindInfraHomotopy` / `HomotopicQ` refuse an open against a closed walk with `::mismatch`, and the bare-list `::wrap` refusal is gone.
- **Breaking:** the walk-family length budget `kspec` is `UpTo[k]` (at most `k` edges), `{k}`, `{lo, hi}` or `Infinity` — never a bare integer. With no wrapper to mark it, a bare integer after `p1` is the endpoint `p2` of the two-point form (`FindInfraWalk[g, 1, 9]`), an Association its multiset, so `FindInfraWalk[g, 1, 4, All]` now means the walks from `1` to `4`; write `UpTo[4]` for the budget. A count needs an explicit `kspec` before it. `FindInfraGeodesic`'s pointed reading wins the one remaining tie, `[g, p1, p2, Infinity]`; give `kspec` there. `ExtendInfraSegment` still takes a bare `k` (the segment family is T5's).

- **Breaking:** `FindInfraCircle` joins the `Method` ladder. New option `Method -> Automatic | "Exhaustive" | {"Exhaustive", "Pruning" -> spec} | "Greedy" | "RandomGreedy"`, and the count default moves from `All` to one witness: `FindInfraCircle[g, c, r]` now returns one shortest separating circle, deterministic and streamed off the circle pool on the certified class; `FindInfraCircle[g, c, r, All]` is the pool as before. The class is the same under every `Method`: a bounded count streams circles off the pool's atoms in candidate (`"Greedy"`, `"Exhaustive"`) or random (`"RandomGreedy"`) order, and off the certified class every `Method` runs the same length sweep, where `"Pruning"` caps the cycles kept per length. Code that read the whole family without a count should pass `All`.

- **Breaking:** `FindInfraPolygon` and `FindInfraTriangle` take `Method -> Automatic` (was `"Exhaustive"`) and a count default of one witness (was `All`), like every ladder symbol. A bounded count streams that many geodesics per side and reads the first members of their product, instead of forming the whole product and discarding; `All` still forms the product. A bad `Method` raises `FindInfraPolygon::badmethod` / `FindInfraTriangle::badmethod` (was `FindInfraSegment::badmethod`). The count-less witness of a corner polygon may retrace a side; the class admits it.

- **Breaking:** `Method -> Automatic` on a bounded or absent count now resolves to `"Greedy"` on every `Find*` / `Extend*` ladder symbol (`All` still gives `"Exhaustive"`). The default witness is deterministic and reproducible without `SeedRandom`; the random-order descent is `Method -> "RandomGreedy"`, explicit only. Code that relied on the 2026-09-03 random default should say so. On the count-less two-point walk (`kspec Infinity`, no stopping condition, constraint-only rules) `"Greedy"` — and so the default — is the shortest path, the canonical witness.

- **Breaking:** `FindInfraParallel` returns one class under every `Method`: the inextensible geodesics through `p` inside the level set `{v : d(v, line) == d(p, line)}`, each in canonical orientation. Previously `"Exhaustive"` kept only the longest chain through each seed edge and `"Greedy"` emitted every inextensible chain in both orientations; the two now agree, and a `p` isolated in its level set gives `InfraLine[{}]` under every `Method` (the greedy used to return `{{p}}`). Built on a pair pool over the distance matrix, streamed lazily for bounded counts.

- `FindInfraShell`, `FindInfraBisectingHyperplane`, `FindInfraEllipticShell`: the lazy peel under `Method -> "Greedy"` / `"RandomGreedy"` visits each subset once. `Method -> "Greedy"` with `All` on a 5×5 grid went from minutes to under a second; the class is unchanged.

- **Breaking:** `SelectPath` / `SelectCycle` renamed to `SelectInfraPath` / `SelectInfraCycle` for naming consistency with the `Infra*` wrapper family. New `SelectInfraPoint[g, vertices, n]` is the vertex-bundle analogue of `SelectInfraPath` — same calling triple, same `"From"` / `"Distance"` / `"MaxCliques"` options; no `"Metric"` (graph distance is canonical on vertex bundles). `EmbeddingClosestPaths` and `EmbeddingClosestCycles` collapsed into a single polymorphic `EmbeddingClosest[g, bundle, ref]`: reference shape `{p1, p2}` dispatches to segment-shape, `{center, radius_?NumericQ}` to circle-shape. Bundles preserve their wrappers (`InfraSegment`, `InfraLine`, `InfraPath`, `InfraRay`, `InfraCircle`). No deprecation aliases — direct rename.

- **Breaking:** `InfraExampleGraph` retired. Replaced by two primitives in `Kernel/ExampleGraphs.wl`: `PunchHole[g, r]` removes a closed `r`-ball around a random vertex (or `PunchHole[g, c -> r]` for an explicit center); multi-hole use is `Fold[PunchHole, g, list]`. `TorusTessellation[shape, {m, n}]` for `shape \[Element] {"Rectangular", "Triangular", "Hexagonal"}` — the three vertex-transitive flat-torus `{p, q}`-tessellations (`{4, 4}`, `{3, 6}`, `{6, 3}` respectively). The old registry was thin scaffolding over existing built-ins (`GridGraph`, `GraphData[{"Triangular", ...}]`, `PetersenGraph[]`, `CayleyGraph[FiniteGroupData[..., ...]]`, mesh discretisation); call those directly. The honeycomb `TorusTessellation["Hexagonal", {m, n}]` form implements the two-orbit Cayley graph on `Z_m × Z_n × Z_2` (previously documented only conceptually in `Wiki/Concepts/HomogeneousGraphs.md`). The earlier `HoleAdd[g, {{count, radius}, ...}]` / `GridGraphWithHoles[{m, n}, holes]` API has been replaced by `PunchHole`; recover the old behaviour with `Fold[PunchHole, GridGraph[{m, n}], Catenate[ConstantArray[Last @ #, First @ #] & /@ holes]]`.

- **Breaking:** `SelectPaths` / `SelectCycles` renamed to `SelectPath` / `SelectCycle` and redesigned as `FindPoint`-on-path-space. The bundle is now treated as a finite metric space (paths = points, distance = path-space metric); the API mirrors `FindPoint` exactly. Calling triple `SelectPath[g, paths, n_Integer | UpTo[n] | All]` with default `n = 1`. Options: `"From"` (pool selector: `All` (default), `"Center"`, `"Periphery"`, `"MostVisited"`, `anchor -> spec`, `InfraSegment[{...}] -> spec`; `SelectCycle` additionally accepts `"ShortestCircumference"` / `"LongestCircumference"`), `"Distance"` (mutual-distance constraint between returned paths: `None` (default), `"Max"`, numeric, range — k-clique in path-space), `"Metric"` (path-space metric: `"Hausdorff"` (default — well-defined on mixed-length bundles), `"Frechet"`, `"MeanFrechet"`), `"MaxCliques"`. Operator form: `SelectPath[g, n, opts][paths]`. The old `Method -> "Frechet" | ...` option becomes the quoted-string `"Metric"` option, and the default flipped from `"Frechet"` to `"Hausdorff"` to close the silent-failure mode of Frechet alignment on mixed-length bundles. The old criterion strings `"Central"` / `"Peripheral"` become `"From" -> "Center"` / `"Periphery"`; folded-list chaining of criteria is dropped — chain via `//` instead. To recover the previous behaviour: `SelectPaths[g, paths, "Central"]` → `SelectPath[g, paths, All, "From" -> "Center", "Metric" -> "Frechet"]`; `SelectCycles[g, cycles, "ShortestCircumference"]` → `SelectCycle[g, cycles, All, "From" -> "ShortestCircumference"]`.

- **Breaking:** `OrthogonalCoordinates` no longer auto-discovers a frame from a centre, and the `"Origin"` option is gone. The centre is now a required positional argument and the frame must be supplied explicitly. New canonical signatures: `OrthogonalCoordinates[graph, c, {a1, ..., an}, v]` and `OrthogonalCoordinates[graph, c, {a1, ..., an}]`. To recover the previous behaviour: `OrthogonalCoordinates[graph, c, FindOrthogonalFrame[graph, c]]`. The dropped overloads (`OrthogonalCoordinates[g, axes, v]`, `OrthogonalCoordinates[g, c, v]`, `OrthogonalCoordinates[g, c]`, `OrthogonalCoordinates[g, InfraPoint[...], v]`) and the `"Origin"` option no longer match a pattern, so calls fall through unevaluated.

## 0.8.3

- New public `InfraExampleGraph[name, params]` — paclet-wide example-graph registry for guides, tutorials, and symbol-page demonstrations. Twelve keys covering the curvature spectrum (`"Grid"`, `"RectangleMesh"`, `"DiskMesh"`, `"SphereMesh"`, `"TriangularLattice"`, `"HexagonalLattice"`, `"RegularTree"`, `"Cayley"`) plus small named gems (`"Petersen"`, `"Heawood"`, `"MobiusKantor"`, `"Tutte"`). Mesh keys forward `MaxCellMeasure` / `AccuracyGoal` to `DiscretizeRegion`.
- Retire `InfraMode`. The path/cycle cases collapse to `SelectPaths[g, infra, "MostVisited"]` / `SelectCycles[g, infra, "MostVisited"]`; `SelectPaths` extended to accept `InfraLine`, `InfraRay`, and `InfraPencil` (mapped over its rays).

## 0.8.2

- New public `InfraMode[graph, infra]` — picks the most-visited realisation(s) from any single-`_List`-arg `Infra*` wrapper (point, segment, line, shell, plane, circle, ray, pencil), the single-realisation readout of the diffuse measure that `InfraSceneHighlight` paints. Same engine exposed bundle-level as a new `"MostVisited"` criterion on `SelectPaths` / `SelectCycles`.

## 0.8.1

- Concise usage-message style: every `::usage` is one sentence per signature, no inline tutorials.
- Retire `Tessellations` from the kernel; the corresponding wiki entry is archived.
- Documentation: `Layer` -> `Geometry` rename across guide notebooks.

## 0.8.0

- Projective layer aligned with the `Find*` -> `Infra*` multi-object pattern used by the Euclidean and Tropical layers.
- New wrapper heads `InfraRay` (multi-realisation) and `InfraPencil` (multi-constituent).
- `FindRay` (formerly the roster's `FindRayClass`); `FindCommonLine` / `FindCommonPoint` accept `InfraPoint` / `InfraSegment` / `InfraRay` / `InfraPencil` anchors.
- New predicate `UniqueConcurrentQ`.

## 0.7.3

- Rename `Aggregation` -> `SelectCoordinate` in `OrthogonalCoordinates`; bare-symbol values (`First`, `Min`, `Median`, ...); add `All` for tied-list preservation.

## 0.7.2

- `Find*` wrapper pass: `FindPoint` / `FindSegment` / `FindLine` / `FindShell` / `FindCircle` return `Infra*` heads with consistent accessors.
- Tropical operations split into a dedicated `TropicalOperations.wl`.
- Option rename pass for consistency with Wolfram conventions.

## 0.6.0

- Euclidean API cleanup: `FindParallel` placeholder allow-list entries `"Spectral"` / `"Resistance"` removed (only `"Metric"` and `"Embedding"` remain).
- `InfraInstance` accessor overloads `InfraInstance[inst, sym]` / `InfraInstance[inst, {sym1, ...}]`.
- `Viewers.wl` split into `Highlights.wl` (diffuse-rendering primitive `InfraSceneHighlight`) + `Viewers.wl` (`Manipulate`-based interactive viewers).

## 0.5.x

See git log for the v0.5 series (curvature engine, Tarski layer, `PathSpace.wl`, `FindShell` / `FindCircle` split, `Curvatures.wl`).
