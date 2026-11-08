# Euclidean Infrageometry: proposed corrections

Review of the [selected guide](../../InfraGeometry/docs/Guides/EuclideanInfrageometry.md) and its [saved notebook](../../InfraGeometry/Documentation/English/Guides/EuclideanInfrageometry.nb), 7 November 2026.
No matching companion existed when this review began.
Only explicitly accepted passages are applied to the guide; package code is unchanged.
The first two paragraphs were accepted and applied on 7–8 November 2026; see the [revision record](EuclideanInfrageometry_provenance.md).
The [short Mathematica notebook](euclidean_infrageometry_261107.nb) contains the core definitions and one example.
The [Jupyter notebook](euclidean_infrageometry_261107.ipynb) develops the main definitions, proofs and examples.

The framework is mathematically sensible as a theory of graph-metric constructions and families of their realizations.
Its Euclidean interpretation requires additional hypotheses.
The strongest starting point is the segment family: its interval graph, counting formulas and sampling law are precise.
The proposed continuum statement should distinguish convergence of metrics, families of paths, and occupation measures.

## Abstract

**Accepted opening paragraph.**
Euclidean Infrageometry studies geometric objects on graphs using synthetic methods.
An object may have several realizations on a given graph.
We study these families, their mutual relations, and constructions formed by successive operations.

**Accepted second paragraph, clarified on 8 November 2026.**
If space is represented by a large graph, we may view it as a web of paths.
Infinitesimality is an idealized abstraction of our large-scale perception of this web.
This leads to the idealization of space as a “continuous web” supporting objects such as the “breadthless line.”
Infrageometry works directly with the discrete substrate at a chosen observer scale and aggregates instead of subdivides.

**Accepted multi-object passage, 8 November 2026.**
A geometric object may have several realizations on a graph.
We treat these realizations together as a multi-object.
Choosing realizations at successive construction steps generates a branching multiway system.
For a fixed construction scheme, the prescribed dependency graph is the same across branches, although the geometric realizations may differ.
We call this fixed dependency structure causal invariance.

**Accepted densities and measures paragraph, 8 November 2026.**
We associate each multi-object with vertex and edge densities by counting occurrences across its realizations.
For a finite nonempty family, dividing by the number of realizations gives expected occupation under uniform sampling.
Further normalization gives probability measures on vertices or edges.
We ask when suitable scaling and assumptions on the graph sequence make these measures converge weakly to measures supported on classical “thin” geometric objects.

**Accepted axiomatization paragraph, 8 November 2026.**
We also seek an axiomatic system for Euclidean infrageometry and conditions defining Euclidean-like graph sequences.
The aim is to recover the objects, relations and axioms of classical Euclidean geometry in an appropriate scaling limit.

The review items below retain the mathematical rationale and remaining proposals; acceptance is recorded above.

1. **Clarification: substrate and scale.** State the basic setting: a finite connected simple undirected graph with unit edge lengths, and a physical scale factor when comparing different graphs.
   Weighted or infinite graphs require separate conventions.
   Inert expressions can be substrate-independent syntax; their realizations and even their nonemptiness depend on the substrate.

2. **Clarification: fixed dependencies.** A prescribed construction has the same syntactic dependency graph in every complete realization.
   This does not imply that different choices lead to the same result or eventually merge.
   For example, choosing $x\in\{0,1\}$ and setting $y=x$ gives the same dependency graph and different terminal values.
   The user chose to retain causal invariance as the explicitly defined name for this fixed dependency structure.
   The implementation constructs this graph from the input expressions in [InfraScene.wl](../../InfraGeometry/Kernel/EuclideanInfrageometry/InfraScene.wl).

3. **Correction: normalization.** Let a segment family have $N$ members, each with $m$ edges, and let $c(v)$ count its members containing $v$.
   Then $c(v)/N$ is an inclusion probability, but its sum over vertices is $m+1$.
   It defines a finite occupation measure, not a probability measure on vertices.
   If $m\to\infty$, these unscaled measures cannot converge weakly to a finite measure: the integral of the constant function $1$ diverges.
   The vertex probability measure has masses $c(v)/(N(m+1))$.
   For families with unequal member sizes, specify whether to normalize each member first or normalize the combined counts; these give different measures.

4. **Correction: the space carrying a Dirac measure.** A Dirac measure on the substrate is supported at one point.
   A deterministic segment can instead carry normalized arclength measure.
   A Dirac mass at that segment belongs to a space of geometric objects or parametrized paths.
   Specify the ambient space and topology before asserting weak convergence.

5. **Proof gap: Euclidean recovery.** Refinement alone does not produce a Euclidean metric.
   On the square grid with edge scale $1/n$, graph distance is exactly the $\ell^1$ distance between embedded vertices.
   Nevertheless, uniform path occupation between opposite corners converges to normalized length on the diagonal.
   The interval support still fills the square.
   These are three different limiting statements, proved separately in the notebook.
   The notebook also proves a sufficient metric-approximation condition for genuine Euclidean segment convergence.

6. **Implementation correction: sample count.** Replace `RandomInfraSegment[g, InfraSegment[p, q], k]` by `RandomInfraSegment[g, InfraSegment[p, q], UpTo[k]]` in the “up to k” example.
   An integer requests exactly that many distinct paths and returns `{}` when too few exist.
   This agrees with the [sampler documentation](../../InfraGeometry/docs/Symbols/RandomInfraSegment.md) and implementation.

7. **Qualification: compact representations.** Retain the exact interval-DAG statement for segments.
   Say “source-to-sink paths,” rather than arbitrary chains.
   Lines use a family of DAGs indexed by compatible endpoint pairs; these must not simply be merged.
   Closed arcs use copies of vertices to open cycles.
   Avoid suggesting a single uniformly small substrate DAG for every object.

Suggested replacement for the central mathematical paragraph:

> On a fixed graph, a geometric object may be a family of admissible realizations.
> A prescribed sequence of constructions retains its dependency graph while choices of realizations generate branches.
> For a finite nonempty family, uniform sampling gives vertex and edge occupation densities.
> Their sums record expected size; further normalization is needed for probability measures on the substrate.
> Along rescaled graph sequences, one can ask whether the graph metrics approach a Euclidean metric and whether the associated path laws and occupation measures converge.
> A deterministic limiting segment corresponds to a Dirac measure on path space and to normalized arclength measure on the substrate.
> These conclusions require explicit hypotheses on the substrates, scales and sampling laws.

This is proposed text, not an accepted revision.
The broader claim about recovering an axiomatic Euclidean geometry remains a research objective.

## Functions

The following corrections follow the guide's section order.

| Section | Proposed correction or qualification |
|---|---|
| Points | Restrict the basic metric discussion to connected graphs, or explicitly allow infinite distances between components. |
| Segments | Distinguish the family of shortest paths from its support $I(p,q)=\{v:d(p,v)+d(v,q)=d(p,q)\}$. A bisector is uniquely defined as a set, but may be empty or thick. In a bipartite graph it is empty when $d(p,q)$ is odd. |
| Rays and Lines | Say “maximal geodesic paths on the finite substrate.” These finite paths are not isometric copies of $[0,\infty)$ or $\mathbb R$, and their endpoints depend on the finite substrate. |
| Arcs and Circles | Define “outside” as $\{v:d(c,v)>r_{max}\}$, and specify deletion of the cycle's vertices. Require $c$ outside the cycle. If the outside is empty, separation is vacuous. A single distance shell in a bipartite graph has no edges, so a radial band can be necessary. |
| Balls and Shells | A shell with $r_{min}<r_{max}$ is a distance band, not one level set. For a center set $C$, define $d(C,v)=\min_{c\in C}d(c,v)$ and take $C\ne\varnothing$. |
| Scenes | Distinguish a prescribed construction from a successful realization. A branch may have no admissible continuation. |
| Shapes | Describe `InfraPlane` as the inclusion-minimal separators contained in the specified bisector or slab, excluding the two endpoints. The current guide omits this restriction. A distance-sum sublevel set called `InfraQuadric` is not generally a quadratic algebraic locus. |
| Incidence and reflection | “Reflection through a point” is a set-valued metric construction. It need not define an involutive isometry. |
| Parallels and perpendiculars | `InfraParallelQ` is a one-sided constant-distance predicate and can be asymmetric. State this in the guide. Perpendicularity depends on the selected method; Euclidean equivalence of those methods has not been established. |
| Graphs of Multiobjects | Keep separate endpoint-pair DAGs for lines and the lifted vertices for closed arcs. The symbol pages already explain these distinctions. |
| Properties and Measurements | `InfraAngle` returns arc length in edges, not radians. Even arc length divided by radius requires Euclidean metric and arc convergence to recover the classical angle. Density addition under `InfraUnion` is superposition: the density of a union with itself doubles. Density multiplication under `InfraIntersection` counts pairs of realizations; it gives the intersection inclusion probability only after normalization and an independence assumption. These density rules differ from the Boolean operations on supports. |

The property called `"RiemannianMeasure"` also needs a qualification if discussed as a measure.
It counts vertices whose neighbors remain in the region and is not additive in the region.
On a graph consisting of one edge, each singleton has value zero and their union has value two.
It is an interior-size statistic; a continuum volume interpretation would need a separate limit theorem.

## Mathematical directions

1. **Euclidean metric approximation.** For a specific substrate sequence, bound the error between rescaled graph distances and Euclidean distances.
   The notebook proves that an error $\varepsilon$ confines every parametrized segment to within $\frac12\sqrt{6L\varepsilon+9\varepsilon^2}$ of the Euclidean segment of length $L$.
   It also gives a proximity-graph construction with a vanishing error bound.
   This is the most direct next question for a Euclidean theory.

2. **Dependence on sampling.** Determine when path occupation concentrates and which perturbations preserve its limit.
   Compare uniform sampling of whole paths with uniform choices of outgoing edges; they generally differ.
   The current default segment sampler correctly weights successors by their numbers of completions.
   A useful result would give explicit conditions under which different sampling rules have the same limiting occupation measure.

3. **Stability of circle and plane constructions.** First restrict to a specified class of planar substrates, or to graphs approximating a fixed Euclidean domain.
   Specify a nonempty exterior and the physical width of shells or slabs.
   Then prove existence and convergence of the chosen separating objects.
   Segment convergence alone does not settle this question.

## Sources and verification

- Read the guide in Markdown and its saved Wolfram notebook, the relevant symbol descriptions, and the segment, measurement, scene, plane, circle and angle implementations.
- The path-count factorization and predecessor recurrence are standard; see [Brandes, *A Faster Algorithm for Betweenness Centrality* (2001), Lemmas 1 and 3 and the formula following Lemma 1, printed pp. 4–6](https://snap.stanford.edu/class/cs224w-readings/brandes01centrality.pdf).
- The Jupyter notebook contains independent Python computations of the mathematical definitions. It does not execute or certify the Wolfram paclet.
- The notebook records exact finite checks separately from proofs. No theorem here is asserted to be new.
- All five code cells executed successfully. Path counts and densities were checked against exhaustive enumeration on a small grid; the occupation moment was checked with exact fractions for $n=1,2,4,8,16$. The generated figure was inspected.
- Prepared with Codex from the guide marked “Reviewed by Pavel Hajek on 18 October 2026.” The repository attributes the research direction to Stephen Wolfram; that attribution is preserved.
