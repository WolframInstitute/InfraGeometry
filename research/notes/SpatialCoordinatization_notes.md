# Spatial Coordinatization: definitions and limits

Companion to the [tutorial](../../InfraGeometry/docs/Tutorials/SpatialCoordinatization.md) and its [notebook](../../InfraGeometry/Documentation/English/Tutorials/SpatialCoordinatization.nb).
Pavel requested these constructions on 8 November 2026.
The implementation uses finite graphs and integer projection coordinates.

## Causal history and frame

A foliation is an ordered partition $V=\bigsqcup_{i=1}^m\Sigma_i$ into nonempty sets such that every edge goes from an earlier set to a later set.
Each set is an antichain because the slice index strictly increases along every directed path.
This definition does not require every maximal chain to cross every slice.
A frame of chains must separately meet each slice under consideration exactly once.
Nearby initial landmarks do not determine their later continuation.

## Spatial reconstruction

Write $u\preceq v$ for reflexive reachability.
A lowest common ancestor of $x,y$ is a maximal element of $\{a:a\preceq x,\ a\preceq y\}$.
There can be several such elements.
For depth $r\geq0$, join distinct $x,y\in\Sigma_i$ when a common ancestor belongs to $\Sigma_{\max(1,i-r)}\cup\cdots\cup\Sigma_{i-1}$.
This is equivalent to requiring a lowest common ancestor in that window.
Indeed, a common ancestor extends to a maximal common ancestor in the finite order.
Its slice index cannot decrease, and it must remain below $i$ because $x,y$ are incomparable.
The converse follows from the definition.

At depth one the ancestor is a common parent: no intermediate slice index is available along either path.
The first reconstructed slice is edgeless.
Without the depth restriction, any slice whose events share one earlier ancestor becomes a clique.
This reconstruction is invariant under adding transitive causal edges.
It depends on the foliation and depth, not only on the partial order.

## Axes and integer projections

For an undirected connected unweighted graph, put $I(p,q)=\{v:d(p,v)+d(v,q)=d(p,q)\}$ and $E(p,q)=|I(p,q)|-d(p,q)-1$.
Choose a shortest germ from the origin $o$ to each direction vertex $a_i$.
The automatic rule extends either endpoint only while the whole path remains shortest and $E$ remains equal to its initial value.
For a geodesic extension, the old interval lies in the new interval and the new endpoint is outside the old interval.
Thus $E$ cannot decrease, so preserving it forbids newly introduced interval excess.
Finite vertex count guarantees termination.
Canonical vertex ordering breaks ties; this choice is not invariant under arbitrary relabeling.

Orient each selected path toward $a_i$, and number its vertices by integers $s_i$ with $s_i(o)=0$.
Define $P_i(v)=\mathop{\rm argmin}_{w\in L_i}d(v,w)$ and $x_i(v)=\min_{w\in P_i(v)}s_i(w)$.
Then $x(o)=0$, and $x_i(a_i)=d(o,a_i)$ because the nearest axis vertex to $a_i$ is itself.
The other coordinates of $a_i$ need not vanish.
Minimum tie-breaking need not commute with reversing an axis.
Explicit oriented shortest paths can replace the automatic axes.

## Fibers and nonorthogonality

The resulting map $x:V\to\mathbb Z^d$ can identify distinct vertices.
Its fibers are $x^{-1}(z)$, and its base is the image equipped with the induced quotient adjacency.
No nearest-neighbor lattice or graph-bundle property follows automatically.
On a Cartesian box, full coordinate rows give unique nearest projections and recover the original integer coordinates.
On the tutorial's reconstructed graph, diagonal edges create projection ties: 27 vertices give 15 tuples under minimum selection.
These are metric projection labels, not coefficients in an oblique basis.
A connection and compatibility conditions would be needed to replace this construction by integrated parallel transport.

## Relations and transport

For slices $i,j$, retain all causally comparable target events as $R_{ij}(v)$.
A canonical function follows only when every row is a singleton.
Branching and merging show why neither temporal direction is universally preferred.
Explicit selection gives a map but does not prove surjectivity or spatial adjacency preservation.
For nonempty rows the uniform kernel is $K_{ij}(v,w)=1/|R_{ij}(v)|$ on the relation and zero elsewhere.
For vertex masses, $\nu(w)=\sum_v\mu(v)K_{ij}(v,w)$ satisfies

$$\sum_w\nu(w)=\sum_v\mu(v)\sum_wK_{ij}(v,w)=\sum_v\mu(v).$$

Densities must first be multiplied by their reference vertex weights.
Independent uniform kernels need not compose to the direct uniform kernel.
Relations themselves compose through an intermediate slice only when the relevant causal paths cross it.
Neither mass preservation nor causal comparability proves metric-measure convergence.

## Verification

The new implementation passes 41 deterministic tests; 414 relevant existing tests also pass.
All nine tutorial code blocks were evaluated without messages in the existing Wolfram kernel.
The saved input boxes were checked against the source expressions, and the four graphical outputs were rendered and inspected.
These are finite checks of the implementation; the arguments above establish the stated finite-graph properties.
The tutorial and implementation were prepared by Codex with Astra xhigh reviews under Pavel's direction.
