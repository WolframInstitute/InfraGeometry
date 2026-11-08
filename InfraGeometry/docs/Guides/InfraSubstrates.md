---
Template: Guide
Name: InfraSubstrates
Title: Infra Substrates and Observers
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/guide/InfraSubstrates
Keywords: [substrate, template graph, tessellation, regular map, torus, surface, surface-like, Euler characteristic, genus, inflation, warped product]
RelatedGuides: [InfrageometryBranches, EuclideanInfrageometry, RiemannianInfrageometry, InfraTopology, InfraAnalysis, InfraFiberBundles, Experimental]
---

## Abstract

*Reviewed by Pavel Hajek on 27 October 2026.*

We consider discrete substrates given by a **graph**. A hypothetical **infra geometer** walks on the graph, organizes his observations and builds a notion of **graph geometry**. In general, we can imagine a **computational observer** with bounded computation time and memory, and ask how it perceives the graph.

The substrate we consider here would be called a **spatial graph** in the Wolfram Physics Project. Its vertices correspond to events in a **simultaneity slice** of the causal graph of a single rewriting history, for a chosen observer. **Spatial connectivity** comes from the lowest common ancestor relation, connecting vertices just one light tick away, while **persistence** across time comes from forward causal relations. This is how space emerges in the hypergraph rewriting model for a particular observer.

For a concrete causal reconstruction, let D be a finite layered directed acyclic graph with layers Σ₀, …, Σₜ.
Assume that each edge advances one layer and every maximal directed path meets every layer.
The layers are antichains and serve as discrete Cauchy slices.
Reconstruct the spatial graph on a layer by joining distinct events that share a parent in the preceding layer.
This specifies the one-light-tick common-ancestor rule in this example.
A general DAG can have several lowest common ancestors; a reconstruction rule must retain them or specify a selection.

Between consecutive slices, causal ancestry gives the predecessor set $P_t(y)=\{x\in\Sigma_t:x\prec y\}$, where x ≺ y means that a directed path leads from x to y.
Consider the diamond a → b → d and a → c → d, with slices {a}, {b, c}, {d}.
The middle spatial graph has the edge b—c.
Both b and c have the unique predecessor a, whereas d has the two predecessors b and c.
Exchanging b and c preserves the causal graph, so ancestry alone cannot select one of them as the predecessor of d.

Thus causal persistence is naturally a relation between slices.
It becomes a backward function precisely when every predecessor set is a singleton.
Otherwise, a single-valued identification requires additional observer data.
Time evolution and coarse graining are distinct: a time step may branch or merge, whereas a coarse-graining map explicitly assigns fine vertices to coarse vertices.
A foliation alone supplies neither a canonical such map nor a metric approximation.

As a minimal model of dependence on the observer, we introduce the scalar **observer scale** $r$. The observer aggregates his measurements at this scale. In concrete cases, we can think of him using balls of radius $r$ for his measurements. Making constructions and measurements depend on scale allows us to study **renormalization of the geometry**.

A chosen coarse-graining map q from fine vertices to coarse vertices transports a nonnegative finite measure by $(q_*\mu)(x)=\sum_{y:q(y)=x}\mu(y)$.
Here μ(y) is vertex mass, including any reference weight used to express a density.
For every coarse observable φ, $\sum_x\varphi(x)(q_*\mu)(x)=\sum_y\varphi(q(y))\mu(y)$.
Taking φ = 1 proves preservation of total mass.
An injection transports mass by the same pushforward rule; spreading coarse mass throughout a fiber instead requires weights summing to one.

When causal ancestry is multivalued, choose weights $K_t(y,x)\geq0,\quad \sum_xK_t(y,x)=1$, supported on x ∈ Pₜ(y).
Then $(K_{t*}\nu)(x)=\sum_yK_t(y,x)\nu(y)$ preserves total mass and records distributed ancestry.
In the diamond, the symmetric choice sends unit mass at d to mass 1/2 at each of b and c.
A deterministic choice sends it entirely to one predecessor.
Both preserve mass, but only the latter selects a single predecessor.
The weighting rule is additional data, and composing these kernels preserves mass across several slices.

We distinguish several types of substrates for our purposes. **Open substrates** represent infinitesimal neighborhoods of their centers, with the observer scale set to the radius. As the scale and the graph grow, we have more rays from the center, viewed as germs of paths, and we can study the emergence of a **linear structure** using midpoints, a **Riemannian metric** using shortest path projection, and a **Riemann tensor** using volume measurements around the center. We can cut out these neighborhoods as balls, for example from plane or hyperbolic tessellations, and remove rim edges to indicate potential unboundedness.

Following Riemann, we think of space as a **webbing of paths**: continuous in his case and discrete in ours. He introduced the **Riemannian metric** as the simplest infinitesimal quantity producing a length element with natural properties. In continuous Riemannian geometry, the metric is extra data on a smooth structure. In infrageometry, all geometric information is already contained in the graph, and continuous geometry is a property of **Gromov-Hausdorff limits** of some sequences of graphs.

For convergence of geometric objects, use a resolution index n distinct from the time index t.
Consider connected spatial graphs with vertex sets Vₙ and rescaled graph metrics converging in the Gromov–Hausdorff sense to a compact metric space X.
Choose corresponding metric approximation maps fₙ : Vₙ → X.
Weak convergence of finite occupation measures means $\sum_{v\in V_n}\varphi(f_n(v))\mu_n(v)\longrightarrow\int_X\varphi\,d\mu$ for every continuous φ on X.
Thus geometry and measures are compared through the same maps.
Conservation of mass alone does not imply this convergence.
Agreement between transported measures and measures reconstructed independently from geometric objects is a further condition.

**Closed substrates** represent global objects. Besides path and cycle graphs in one dimension, we consider **tessellation graphs of closed surfaces** coming from regular and uniform maps. These tessellations should converge to continuous Riemannian surfaces, and their combinatorial structure determines the genus, Euler characteristic and curvature. We ask whether all geometries and geometric objects, such as tangent spaces, canonical forms and tensors, can emerge in a **Gromov-Hausdorff limit** of metric measure spaces.

Going in the other direction, we discretize continuous geometry using **uniform-length graphs**, which we construct as contact graphs of hard-sphere packings. These graphs capture geometry directly in their combinatorial structure, since no edge labels are needed to keep track of lengths. We ask whether such discretizations exist for every continuous geometry. We also use **barycentric subdivision** to study convergence.

We also consider the **hypergraphs** produced by rewriting in the **Wolfram Model**. These differ from the spatial graphs above. We eventually want to ask whether every Riemannian manifold is a **Gromov-Hausdorff limit** of a graph sequence generated by a finite collection of rewriting rules, and how its geometry is determined by properties of those rules. We think that all classical geometry emerges from a binary connectivity relation, so we convert hypergraphs to their **1-skeletons**. The hyperedges themselves could lead to higher geometry.

We also consider **exotic substrates** such as trees, complete graphs and fractal graphs. Any substrate can be **inflated** by growing a fiber over every vertex; **fibered substrates** form a corresponding catalogue of fibrations.

More concretely, the named example substrates come in **three sizes**: `"Small"`, `"Medium"` and `"Large"`.
<code>[InfraSubstrate]()[*name*, *size*]</code> gives the graph, <code>[InfraSubstrateStyle]()[*name*, *size*]</code> gives its drawing options, and <code>[InfraSubstrateCode]()[*name*, *size*]</code> gives the held code that builds it.

## Functions

### Named substrates

- `InfraSubstrate` the named example substrate at size "Small", "Medium" or "Large"
- `InfraSubstrateStyle` the options a substrate is drawn with at a given size
- `InfraSubstrateCode` the held code that builds a named substrate

### Tessellation graphs

- `TessellationGraph` the smallest regular map of type $\{p, q\}$, or a uniform map, as a graph
- `TorusTessellation` the flat torus with the square, triangular or hexagonal tessellation
- `TessellationNeighborhoodGraph` the $r$-ball cut from the infinite $\{p, q\}$ tessellation
- `GridGraph` (WL), `TorusGraph` (WL), `PolyhedronData` (WL), `GraphData` (WL)

### Surface-like graphs

- `TessellationCurvature` the combinatorial Gaussian curvature at a vertex of a map
- `TessellationEulerCharacteristic` the Euler characteristic $V - E + F$ of a tessellation graph
- `TessellationGenus` the genus of the surface a map lies on

### Uniform-length graphs

- `UniformLengthGraph` the contact graph of a hard-sphere packing of a region
- `UniformLengthEmbedding` coordinates under which every edge has length close to 1
- `GraphEmbedding` (WL) the coordinates a graph is drawn with

### Fractals and trees

- `SierpinskiGraph` the trivalent Sierpinski graph
- `BetheGraph` the finite Bethe lattice of $n$ shells and coordination number $z$
- `BranchingSequenceTree` the spherically symmetric tree whose branching depends only on depth
- `KaryTree` (WL), `CompleteKaryTree` (WL)

### Preparing a substrate

- `CenterGraph` the substrate cut to the ball about its centre
- `BoundarylessGraph` the substrate with its rim edges removed
- `GraphExteriorBoundary` the rim vertices, whose neighbourhood is not closed

### Inflated substrates

- `InflateGraph` a fiber of new vertices grown over every vertex, with random vertical and horizontal edges
- `InflatedVertex` the $i$-th fiber vertex over a base vertex of an inflated graph

### Fibered substrates

- `InfraFiberedSubstrate` the named example fibrations: products, coverings, tangent and displacement bundles, branched fibrations
