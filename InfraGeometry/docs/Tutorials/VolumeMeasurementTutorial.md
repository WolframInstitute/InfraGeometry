---
Template: TechNote
Name: VolumeMeasurementTutorial
Title: Volume Measurement
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/tutorial/VolumeMeasurementTutorial
Keywords: [volume, ball, shell, tube, ellipsoid, quadric, cone, sphere, counting measure, Riemannian measure, Rips graph, median, modular graph, dimension, log-difference quotient, Wolfram Physics]
RelatedGuides: [RiemannianInfrageometry, EuclideanInfrageometry]
---

- A region about a vertex $c$ is a set $X$ of vertices, and its volume is a count. The regions here are the ball, the shell, the tube about the interval of two vertices or about one geodesic, the solid ellipsoid of two foci, the cone about a geodesic and the sphere instance in a band. Each has a size parameter, and its **profile** is its volume as a function of the size.
- Every region is measured twice. The **counting measure** is $|X|$. The **Riemannian measure** is $|X| - |\partial X| = |\mathrm{Int} X|$, where the boundary $\partial X$ is the set of vertices of $X$ with a neighbour outside $X$, and the interior $\mathrm{Int} X$ is the rest.
- The questions: which closed formula each profile follows on a lattice, which formula of the continuum it approaches, why either measure stands for the volume of a region of the limit space, and which dimension the profiles read.
- Each 3 × 3 figure is one substrate at one size: the rows are the sizes small, medium and large, the columns the square tiling, the triangular tiling and an irregular mesh of the square. The pictures keep the embedding of the substrate; no measurement uses it.

## Setup

```wl
Needs["WolframInstitute`InfraGeometry`"]
```

The centre $c$ is a vertex of least eccentricity. The profiles run up to $R = \lfloor (\mathrm{ecc}(c) - 1)/2 \rfloor$, so that a tube of thickness $R$ about a segment of length $R$ from $c$ stays inside the graph.

```wl
profileRadius[g_] := Floor[(VertexEccentricity[g, First @ GraphCenter[g]] - 1)/2]
```

The far end $p$ of the segments: a vertex at distance $R$ from the centre, drawn after a seed.

```wl
farEnd[g_] := (SeedRandom[1]; FindInfraPoint[g, InfraShell[First @ GraphCenter[g], profileRadius[g]]])
```

The two measures of a list of regions: the counting measure first, the Riemannian measure second.

```wl
twoMeasures[g_, regions_] := InfraMeasurement[g, regions, #] & /@ {"CountingMeasure", "RiemannianMeasure"}
```

A region drawn by its two measures: the interior green, the boundary blue. The counting measure counts both colours, the Riemannian measure the green vertices only.

```wl
interiorAndBoundary[g_, region_] := With[{support = FindInfraRepresentative[g, region]}, {InfraInterior[g, support] -> StandardGreen, InfraBoundary[g, support] -> StandardBlue}]
```

## Balls

- The ball is $B_r(c) = \{ v : d(c, v) \le r \}$. Below, the ball of radius $R$ about the centre.

```wl
GraphicsGrid @ Table[
  With[
    {g = (SeedRandom[2]; InfraSubstrate[name, size, "KeepCoordinates" -> True])},
    InfraSubstrateHighlight[g, interiorAndBoundary[g, InfraBall[First @ GraphCenter[g], profileRadius[g]]]]],
  {size, {"Small", "Medium", "Large"}},
  {name, {"SquareTilingGraph", "TriangularTilingGraph", "SquareMeshGraph"}}]
```

- The ball is not round. On the square tiling it is a square, on the triangular tiling a hexagon: the scaled path metric of a lattice tends to a norm, and these are its unit balls.
- On the square lattice the ball holds $L(r) = 2r^2 + 2r + 1$ vertices, on the triangular lattice $L(r) = 3r^2 + 3r + 1$; the leading coefficient is the area of the unit ball of the norm, counted in vertex cells.
- On both lattices every vertex at distance $r \ge 1$ from $c$ has a neighbour at distance $r + 1$, so the interior of $B_r$ is $B_{r-1}$. The Riemannian measure is therefore $L(r - 1)$ for $r \ge 1$, and $0$ at $r = 0$, where the centre has a neighbour outside.
- In the continuum the reference is the small-ball expansion of Gray and Vanhecke. On a Riemannian manifold of dimension $n$, with $\omega_n$ the volume of the Euclidean unit ball and $\mathrm{Scal}$ the scalar curvature at the centre, $\mathrm{Vol} B_r = \omega_n r^n \big( 1 - \frac{\mathrm{Scal}}{6(n+2)} r^2 + O(r^4) \big)$.

The two profiles over $r = 0, \ldots, R$: the counting measure as points in the first colour, the Riemannian measure in the second; the curves are $L(r)$ and $L(r - 1)$.

```wl
GraphicsGrid @ Table[
  With[
    {g = (SeedRandom[2]; InfraSubstrate[name, size])},
    {radius = profileRadius[g]},
    {lattice = Switch[name, "SquareTilingGraph", 2 r^2 + 2 r + 1, "TriangularTilingGraph", 3 r^2 + 3 r + 1, _, Nothing]},
    Show[
      Plot[Evaluate[{lattice, lattice /. r -> r - 1}], {r, 0, radius}],
      ListPlot[twoMeasures[g, Table[InfraBall[First @ GraphCenter[g], r], {r, 0, radius}]], DataRange -> {0, radius}],
      PlotRange -> All]],
  {size, {"Small", "Medium", "Large"}},
  {name, {"SquareTilingGraph", "TriangularTilingGraph", "SquareMeshGraph"}}]
```

- On the tilings both profiles sit on their polynomials at every size: a tiling is a patch of its lattice, and a ball that stays one layer inside the patch counts as on the lattice.
- On the mesh both profiles grow quadratically, with no closed form, and the Riemannian profile is again the counting profile one radius later.
- [[ On the hexagonal tiling, does every vertex at distance $r \ge 1$ have a neighbour at distance $r + 1$? Then its Riemannian ball count is $1 + \frac{3}{2} r(r - 1)$, the counting polynomial $1 + \frac{3}{2} r(r + 1)$ one radius earlier. ]]

## Shells

- The shell is $S_r(c) = \{ v : d(c, v) = r \}$, the outer layer of the ball. On the lattices it holds $L(r) - L(r - 1)$ vertices, $4r$ on the square lattice and $6r$ on the triangular one.
- Its Riemannian measure is zero. Every vertex of $S_r$ with $r \ge 1$ has a neighbour at distance $r - 1$, which lies outside the shell, and the centre has a neighbour outside $S_0$. The whole shell is boundary.
- In the continuum the geodesic sphere has area $n \omega_n r^{n-1} \big( 1 - \frac{\mathrm{Scal}}{6n} r^2 + O(r^4) \big)$ and volume zero. The two measures of a shell are its two readings: an area, counted, and a volume, which vanishes.

```wl
GraphicsGrid @ Table[
  With[
    {g = (SeedRandom[2]; InfraSubstrate[name, size, "KeepCoordinates" -> True])},
    InfraSubstrateHighlight[g, interiorAndBoundary[g, InfraShell[First @ GraphCenter[g], profileRadius[g]]]]],
  {size, {"Small", "Medium", "Large"}},
  {name, {"SquareTilingGraph", "TriangularTilingGraph", "SquareMeshGraph"}}]
```

The two profiles over $r = 0, \ldots, R$, against $4r$ and $6r$.

```wl
GraphicsGrid @ Table[
  With[
    {g = (SeedRandom[2]; InfraSubstrate[name, size])},
    {radius = profileRadius[g]},
    {lattice = Switch[name, "SquareTilingGraph", 4 r, "TriangularTilingGraph", 6 r, _, Nothing]},
    Show[
      Plot[lattice, {r, 0, radius}],
      ListPlot[twoMeasures[g, Table[InfraShell[First @ GraphCenter[g], r], {r, 0, radius}]], DataRange -> {0, radius}],
      PlotRange -> All]],
  {size, {"Small", "Medium", "Large"}},
  {name, {"SquareTilingGraph", "TriangularTilingGraph", "SquareMeshGraph"}}]
```

- The counting profile is linear on the tilings and close to linear on the mesh; the Riemannian profile is zero everywhere.

## Tubes

- The tube of thickness $s$ about a set $X$ is $T_s(X) = \{ v : d(v, X) \le s \}$; the tube about one vertex is the ball.
- Two cores join the centre $c$ to the far end $p$. The **fat tube** is the tube about the interval $I(c, p)$, the union of all geodesics from $c$ to $p$: the head [InfraTube]() on the segment. The **thin tube** is the tube about one geodesic $\gamma$: the head on a representative of the segment.
- The interior of a tube is one layer thinner: for $s \ge 1$, $\mathrm{Int} T_s(X) = T_{s-1}(X) \cup \{ w : d(w, X) = s, \text{ no neighbour of } w \text{ at distance } s + 1 \}$. So the Riemannian measure of a tube is the counting measure of the tube one step thinner, together with the dead ends of its outer layer.
- On the square lattice the interval is a box of sides $a_1, a_2$ with $a_1 + a_2 = d(c, p)$, and the fat tube holds $(a_1 + 1)(a_2 + 1) + 2s(a_1 + a_2 + 2) + 2s(s - 1)$ vertices. The thin tube about a staircase geodesic has no closed form.
- In the continuum the thin tube is the counterpart of Gray's tube about a geodesic of length $L$, $\mathrm{Vol} T_s(\gamma) = \omega_{n-1} s^{n-1} \big( L - \frac{s^2}{6(n+1)} \int_\gamma (\mathrm{Scal} + \mathrm{Ric}(\dot\gamma, \dot\gamma)) + O(s^4) \big)$, with the two end caps added; in Euclidean space the tube about a segment is the spherocylinder of volume $\omega_{n-1} s^{n-1} L + \omega_n s^n$. The fat tube has no such counterpart: its core is a box that grows with the offset of the two ends.

The tubes of thickness $\lceil R/2 \rceil$: the thin tube green, the rest of the fat tube blue, and the geodesic.

```wl
GraphicsGrid @ Table[
  With[
    {g = (SeedRandom[2]; InfraSubstrate[name, size, "KeepCoordinates" -> True])},
    {c = First @ GraphCenter[g], p = farEnd[g], thickness = Ceiling[profileRadius[g]/2]},
    {geodesic = FindInfraRepresentative[g, InfraSegment[c, p]]},
    {fat = FindInfraRepresentative[g, InfraTube[InfraSegment[c, p], thickness]], thin = FindInfraRepresentative[g, InfraTube[geodesic, thickness]]},
    InfraSubstrateHighlight[g, {Complement[fat, thin] -> StandardBlue, thin -> StandardGreen, InfraWalk[geodesic]}]],
  {size, {"Small", "Medium", "Large"}},
  {name, {"SquareTilingGraph", "TriangularTilingGraph", "SquareMeshGraph"}}]
```

The profiles over $s = 0, \ldots, R$: the fat tube as joined points, the thin tube as points, the counting measure in the first colour and the Riemannian measure in the second. On the square tiling the curves are the box count and its value one step thinner.

```wl
GraphicsGrid @ Table[
  With[
    {g = (SeedRandom[2]; InfraSubstrate[name, size])},
    {c = First @ GraphCenter[g], p = farEnd[g], radius = profileRadius[g]},
    {geodesic = FindInfraRepresentative[g, InfraSegment[c, p]]},
    {box = If[name == "SquareTilingGraph", InfraMeasurement[g, InfraSegment[c, p], "CountingMeasure"] + 2 s (radius + 2) + 2 s (s - 1), Nothing]},
    Show[
      Plot[Evaluate[{box, box /. s -> s - 1}], {s, 0, radius}],
      ListLinePlot[twoMeasures[g, Table[InfraTube[InfraSegment[c, p], s], {s, 0, radius}]], DataRange -> {0, radius}, PlotMarkers -> Automatic],
      ListPlot[twoMeasures[g, Table[InfraTube[geodesic, s], {s, 0, radius}]], DataRange -> {0, radius}],
      PlotRange -> All]],
  {size, {"Small", "Medium", "Large"}},
  {name, {"SquareTilingGraph", "TriangularTilingGraph", "SquareMeshGraph"}}]
```

- The fat tube contains the thin one and outgrows it. On the square tiling the fat tube follows the box count, and its Riemannian measure is the count one step thinner.

## The ellipsoid

- Two foci $c, p$ at distance $n$ bound the **solid ellipsoid** of slack $k$, $E_k = \{ v : d(c, v) + d(v, p) \le n + k \}$, which [InfraQuadric]() gives. At slack zero it is the interval $I(c, p)$, the core of the fat tube.
- On every graph $T_s(I(c, p)) \subseteq E_{2s}$. For $x$ within $s$ of a vertex $y$ of the interval, two triangle inequalities through $y$ give $d(c, x) + d(x, p) \le d(c, y) + d(y, p) + 2 d(x, y) \le n + 2s$.
- A **median** of three vertices lies on a geodesic between each two of them. If $m$ is a median of $c$, $p$ and $x$, then $d(c, m) + d(m, p) = n$, $d(c, m) + d(m, x) = d(c, x)$ and $d(p, m) + d(m, x) = d(p, x)$; adding the last two and subtracting the first gives $2 d(m, x) = d(c, x) + d(x, p) - n$. A median converts the slack of $x$ into its distance from the interval, at the rate two.
- A graph is **modular** when every three vertices have a median. On a modular graph a vertex of slack at most $2s$ has its median within $s$, so $E_{2s} = T_s(I(c, p))$: the ellipsoid of slack $2s$ is the fat tube of thickness $s$, under both measures.
- In the Euclidean plane the two differ: the ellipse of slack $k$ bulges to a half-width of order $\sqrt{nk}$ in the middle, the tube keeps the half-width $k/2$. Under the $\ell^1$ norm, $|x + a| + |x - a| = 2 \max(a, |x|)$, and the ellipse is the tube; the square lattice carries the $\ell^1$ norm.

The ellipsoid of slack $2s$ and the fat tube of thickness $s$, for $s = \lceil R/2 \rceil$: the tube green, the vertices of the ellipsoid outside the tube red, and the interval.

```wl
GraphicsGrid @ Table[
  With[
    {g = (SeedRandom[2]; InfraSubstrate[name, size, "KeepCoordinates" -> True])},
    {c = First @ GraphCenter[g], p = farEnd[g], thickness = Ceiling[profileRadius[g]/2]},
    {ellipsoid = FindInfraRepresentative[g, InfraQuadric[{c, p}, GraphDistance[g, c, p] + 2 thickness]]},
    {tube = FindInfraRepresentative[g, InfraTube[InfraSegment[c, p], thickness]]},
    InfraSubstrateHighlight[g, {Complement[ellipsoid, tube] -> StandardRed, tube -> StandardGreen, InfraSegment[c, p]}]],
  {size, {"Small", "Medium", "Large"}},
  {name, {"SquareTilingGraph", "TriangularTilingGraph", "SquareMeshGraph"}}]
```

- On the square tiling no vertex is red at any size: the ellipsoid is the tube. On the triangular tiling and on the mesh the ellipsoid reaches beyond the tube.

The profiles over $s = 0, \ldots, R$: the ellipsoid of slack $2s$ as joined points, the fat tube of thickness $s$ as points, the counting measure in the first colour and the Riemannian measure in the second.

```wl
GraphicsGrid @ Table[
  With[
    {g = (SeedRandom[2]; InfraSubstrate[name, size])},
    {c = First @ GraphCenter[g], p = farEnd[g], radius = profileRadius[g]},
    Show[
      ListLinePlot[twoMeasures[g, Table[InfraTube[FindInfraRepresentative[g, InfraQuadric[{c, p}, radius + 2 s]], 0], {s, 0, radius}]], DataRange -> {0, radius}, PlotMarkers -> Automatic],
      ListPlot[twoMeasures[g, Table[InfraTube[InfraSegment[c, p], s], {s, 0, radius}]], DataRange -> {0, radius}],
      PlotRange -> All]],
  {size, {"Small", "Medium", "Large"}},
  {name, {"SquareTilingGraph", "TriangularTilingGraph", "SquareMeshGraph"}}]
```

- On the square tiling the points sit on the joined points under both measures. On the triangular tiling and on the mesh the ellipsoid outgrows the tube, and the gap widens with $s$.

The modularity of the substrates themselves, checked rather than assumed: for every pair $p, q$ and every vertex $x$, the triple has a median exactly when $2\, d(x, I(p, q)) = d(p, x) + d(x, q) - d(p, q)$. Each vertex is inked by the number of pairs with which it has no median; the small substrates.

```wl
GraphicsRow @ Table[
  With[
    {g = (SeedRandom[2]; InfraSubstrate[name, "Small", "KeepCoordinates" -> True])},
    {d = GraphDistanceMatrix[g], vertexTotal = VertexCount[g]},
    {lacking = Total @ Flatten[Table[
      With[{core = Pick[Range[vertexTotal], d[[i]] + d[[j]], d[[i, j]]]}, Unitize[2 (Min /@ d[[All, core]]) - (d[[i]] + d[[j]] - d[[i, j]])]],
      {i, vertexTotal}, {j, i + 1, vertexTotal}], 1]},
    InfraSubstrateHighlight[g, {Select[AssociationThread[VertexList[g], lacking], Positive]}]],
  {name, {"SquareTilingGraph", "TriangularTilingGraph", "SquareMeshGraph"}}]
```

- The small square tiling carries no ink: every triple has a median, the patch is modular, and the ellipsoid of slack $2s$ is the tube of thickness $s$ for every pair of foci. The square lattice itself is a median graph, with the coordinatewise median.
- On the triangular tiling and on the mesh every vertex lacks a median with some pair.

The smallest counterexample to the equality on the triangular tiling, with foci at distance two and thickness one: the corners $a, b, x$ of a triangle of side two, with the three intervals between them.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {beyond = focus |-> Complement[FindInfraRepresentative[g, InfraQuadric[{a, focus}, 4]], FindInfraRepresentative[g, InfraTube[InfraSegment[a, focus], 1]]]},
  {b = SelectFirst[FindInfraShell[g, a, 2], beyond[#] =!= {} &]},
  {x = First @ beyond[b]},
  InfraSubstrateHighlight[g, {InfraSegment[a, b], InfraSegment[b, x], InfraSegment[x, a], {a, b, x}}]]
```

- The three intervals are the three sides of the triangle, and no vertex lies on all three: $a, b, x$ have no median. The corner $x$ has slack two over the foci $a, b$, so it lies in the ellipsoid $E_2$, but its distance from the side $I(a, b)$ is two, so it lies outside the tube $T_1$.
- [[ On a non-modular substrate, is the gap between the ellipsoid of slack $2s$ and the tube of thickness $s$ of the order $s \sqrt{n s}$, as for the Euclidean ellipse? ]]

## Cones

- The cone of slope $m$ about a geodesic $\gamma = (\gamma_0, \ldots, \gamma_n)$ from the apex $c = \gamma_0$ to $p = \gamma_n$ is $C_m(\gamma) = \{ v : d(v, \gamma_i) \le \lfloor m i \rfloor \text{ for some } i \}$: a ball of growing radius slid along $\gamma$.
- For $m \ge 1$ the cone is the ball $B_{\lfloor mn \rfloor}(p)$ about the far end: $d(v, p) \le \lfloor m i \rfloor + n - i \le \lfloor mn \rfloor$, on every graph.
- For $m < 1$ no closed lattice count is known. In the Euclidean plane the cone over a segment of length $R$ is the convex hull of the apex and the disk of radius $mR$ about the far end, of area $R^2 m \sqrt{1 - m^2} + m^2 R^2 (\pi - \arccos m)$. On a manifold the solid cone of radius $r$ over a set $\Omega$ of unit directions has volume $\frac{\sigma(\Omega)}{n} r^n - \frac{r^{n+2}}{6(n+2)} \int_\Omega \mathrm{Ric}(u, u) \, du + O(r^{n+4})$.

The cone of slope one half about one geodesic from the centre to the far end, by its two measures, with its axis.

```wl
GraphicsGrid @ Table[
  With[
    {g = (SeedRandom[2]; InfraSubstrate[name, size, "KeepCoordinates" -> True])},
    {geodesic = FindInfraRepresentative[g, InfraSegment[First @ GraphCenter[g], farEnd[g]]]},
    InfraSubstrateHighlight[g, Append[interiorAndBoundary[g, InfraCone[geodesic, 1/2]], InfraWalk[geodesic]]]],
  {size, {"Small", "Medium", "Large"}},
  {name, {"SquareTilingGraph", "TriangularTilingGraph", "SquareMeshGraph"}}]
```

The profiles over the slope $m = 0, \frac{1}{8}, \ldots, \frac{3}{2}$: the cone as points, the ball of radius $\lfloor mR \rfloor$ about the far end as joined points, the counting measure in the first colour and the Riemannian measure in the second.

```wl
GraphicsGrid @ Table[
  With[
    {g = (SeedRandom[2]; InfraSubstrate[name, size])},
    {p = farEnd[g], radius = profileRadius[g], slopes = Range[0, 3/2, 1/8]},
    {geodesic = FindInfraRepresentative[g, InfraSegment[First @ GraphCenter[g], p]]},
    Show[
      ListLinePlot[twoMeasures[g, Table[InfraBall[p, Floor[m radius]], {m, slopes}]], DataRange -> {0, 3/2}],
      ListPlot[twoMeasures[g, Table[InfraCone[geodesic, m], {m, slopes}]], DataRange -> {0, 3/2}],
      PlotRange -> All]],
  {size, {"Small", "Medium", "Large"}},
  {name, {"SquareTilingGraph", "TriangularTilingGraph", "SquareMeshGraph"}}]
```

- From slope one on, the cone is the far ball under both measures, on every substrate. Below slope one the cone contains the far ball and is larger: at slope zero it is the geodesic itself.
- [[ For a rational slope $0 < m < 1$, is the counting measure of the cone about a geodesic of length $R$ in the square lattice a quasi-polynomial in $R$, and does it depend on the geodesic chosen in the interval? ]]

## Spheres

- A set $\Sigma$ in the band $S_{r,s}(c) = \{ v : r \le d(c, v) \le s \}$ **separates** if every path from $c$ to a vertex beyond distance $s$ meets $\Sigma$. A **sphere instance** of the band is a separating set that induces a connected subgraph and has no proper subset with both properties: a minimal wall around $c$. The head [InfraSphere]() is the family of instances; one instance, found greedily, is its representative.
- In the band $S_{r, r+1}$ the Riemannian measure of an instance is zero whenever every vertex at distance $r + 1$ has a neighbour at distance $r + 2$: every vertex of the band then has a neighbour outside it.
- In the continuum an instance stands for the geodesic sphere, of area $n \omega_n r^{n-1} \big( 1 - \frac{\mathrm{Scal}}{6n} r^2 + O(r^4) \big)$. An instance is not a shell: no two vertices at one distance from $c$ are adjacent on the square tiling, so a wall there zigzags between two shells.

One instance in the band between the radii $\lceil R/2 \rceil$ and $\lceil R/2 \rceil + 1$, orange, drawn over the band, green.

```wl
GraphicsGrid @ Table[
  With[
    {g = (SeedRandom[2]; InfraSubstrate[name, size, "KeepCoordinates" -> True])},
    {c = First @ GraphCenter[g], inner = Ceiling[profileRadius[g]/2]},
    {wall = (SeedRandom[1]; FindInfraRepresentative[g, InfraSphere[c, {inner, inner + 1}]])},
    InfraSubstrateHighlight[g, {InfraShell[c, {inner, inner + 1}] -> StandardGreen, wall -> StandardOrange}]],
  {size, {"Small", "Medium", "Large"}},
  {name, {"SquareTilingGraph", "TriangularTilingGraph", "SquareMeshGraph"}}]
```

The profiles of one instance in each band $S_{r, r+1}$ over $r = 1, \ldots, \min(R, 6)$ as points, the counting measure in the first colour and the Riemannian measure in the second, with the counting measures of the two shells $S_r$ and $S_{r+1}$ as joined points.

```wl
GraphicsGrid @ Table[
  With[
    {g = (SeedRandom[2]; InfraSubstrate[name, size])},
    {c = First @ GraphCenter[g], bandRadii = Range[1, Min[profileRadius[g], 6]]},
    {walls = Table[InfraTube[(SeedRandom[1]; FindInfraRepresentative[g, InfraSphere[c, {r, r + 1}]]), 0], {r, bandRadii}]},
    {shells = InfraMeasurement[g, Table[InfraShell[c, r], {r, First[bandRadii], Last[bandRadii] + 1}], "CountingMeasure"]},
    Show[
      ListLinePlot[{Transpose[{bandRadii, Most[shells]}], Transpose[{bandRadii, Rest[shells]}]}, PlotStyle -> Gray],
      ListPlot[Transpose[{bandRadii, #}] & /@ twoMeasures[g, walls]],
      PlotRange -> All]],
  {size, {"Small", "Medium", "Large"}},
  {name, {"SquareTilingGraph", "TriangularTilingGraph", "SquareMeshGraph"}}]
```

- An instance grows linearly in $r$, like the shells of its band, and its Riemannian measure stays zero.
- The instance found depends on the search. On the triangular tiling either shell of the band is an instance by itself, and the one found is the outer shell. On the square tiling a wall needs vertices of both shells and is larger than either.
- [[ Is the size of the least sphere instance in the band $S_{r, r+1}$ of a lattice a polynomial in $r$? ]]

## The measure

The two measures differ by a layer, and that layer holds a share of order $1/r$ of a ball. Which of them is the volume? The argument runs through a graph that approximates a manifold.

- **The approximating graph.** Let $M$ be a closed Riemannian manifold with normalized volume $\mu$, and $V \subset M$ a sample of $N$ points whose **mesh** $h = \sup_{x \in M} \min_{v \in V} d(x, v)$ is small. The **Rips graph** $G_\varepsilon$ joins two points at distance less than $\varepsilon$; $H_\varepsilon$ is its hop distance and $\nu_V = \frac{1}{N} \sum_{v \in V} \delta_v$ its normalized counting measure.
- **Topology.** For every small scale $\varepsilon$ and every sample dense enough for it, the clique complex of $G_\varepsilon$ has the homotopy type of $M$ ([Latschev](https://doi.org/10.1007/PL00000526)); quantitatively, $14h < \varepsilon < \frac{7}{8} \Delta$ suffices, with $\Delta$ a bound from the convexity radius and the sectional curvature ([Majhi](https://arxiv.org/abs/2305.17288)). The complex carries the topology, not the graph.
- **Distance.** If $2h < \varepsilon$, then $d \le \varepsilon H_\varepsilon \le \frac{\varepsilon}{\varepsilon - 2h} \, d + \varepsilon$: a geodesic of length $d$ cut into pieces of length below $\varepsilon - 2h$, each division point moved to a sample point within $h$, is a path of the graph. As $\varepsilon \to 0$ and $h / \varepsilon \to 0$ the scaled hop distance converges uniformly to $d$, and shortest paths of the graph converge, along subsequences, to minimizing geodesics.
- **Volume.** Coverage alone does not make $\nu_V$ approximate $\mu$: equally spaced points on a circle, with as many again crowded on a short arc, have a small mesh and put half the mass on the arc. It does when the mesh tends to zero and the nearest-vertex cells $C_v \subseteq B_h(v)$ have nearly equal volumes, and almost surely when the points are drawn independently from $\mu$. Each vertex represents its cell, the centre of a ball included.
- **Balls.** Let $\varepsilon \to 0$, $h / \varepsilon \to 0$ and $\nu_V \to \mu$ weakly, and let the hop radius $r$ grow with $\varepsilon r \to R$. Both the closed graph ball $B_r = \{ H_\varepsilon \le r \}$ and the open one $B_{r-1} = \{ H_\varepsilon < r \}$ have normalized counts converging to $\mu(B_R(p))$, since they lie between the geodesic balls of radii $R - a$ and $R + a$ with $a \to 0$, and the geodesic sphere has volume zero. Removing the outer graph layer is consistent, and it is not required.
- The Riemannian measure counts the interior of $B_r$, and $B_{r-1} \subseteq \mathrm{Int} B_r \subseteq B_r$, since a vertex at hop distance at most $r - 1$ has all its neighbours within $r$. So the Riemannian measure converges to the same volume. The counting measure **represents the ball of radius $r$** read as a closed ball, the Riemannian measure represents it read as an open ball, and the argument singles out neither.

A Rips graph of points sprinkled in the unit square at the scale $\varepsilon = N^{-1/3}$, for a growing number $N$ of points, and the ball about the point nearest the middle at the hop radius closest to a quarter. Each point is drawn with its nearest-point cell: the cells of the interior green, of the boundary blue. The red circle has the radius $r$ times the mean length of one hop from the centre.

```wl
GraphicsRow @ Table[
  With[
    {points = (SeedRandom[2]; RandomPoint[Rectangle[], count])},
    {rips = NearestNeighborGraph[points, {All, count^(-1/3)}]},
    {c = First @ Nearest[points, {1/2, 1/2}]},
    {hop = Mean @ Map[pt |-> EuclideanDistance[pt, c]/GraphDistance[rips, c, pt], DeleteCases[points, c]]},
    {radius = Round[1/(4 hop)]},
    {ball = FindInfraRepresentative[rips, InfraBall[c, radius]]},
    {inner = InfraInterior[rips, ball]},
    Graphics[{
      Map[cell |-> With[{owner = First @ Nearest[points, RegionCentroid[cell]]},
        {EdgeForm[LightGray], Which[MemberQ[inner, owner], Lighter[StandardGreen, 0.5], MemberQ[ball, owner], Lighter[StandardBlue, 0.5], True, FaceForm[]], cell}],
        MeshPrimitives[VoronoiMesh[points, {{0, 1}, {0, 1}}], 2]],
      Point[points], StandardRed, Circle[c, hop radius]}]],
  {count, {100, 400, 1600}}]
```

- The cells of the closed ball overshoot the circle by about one layer of cells, the cells of the interior fall short of it by about as much. Both layers thin out as the sample refines, and both unions of cells approach the disk.

- **Exact evidence.** On the cycle of $N$ vertices, spacing $a = 1/N$ and $R = ar$, the ball of radius $R$ has volume $2R$, the closed graph ball has mass $2R + a$ and the open one $2R - a$. The two one-layer conventions err by one vertex mass with opposite signs; half weight at the two end vertices gives $2R$ exactly.

The two measures of the ball of radius $R = 1/10$ on cycles of growing length, divided by $N$, beside the volume $2R$.

```wl
Grid[Prepend[
  Table[
    With[{g = CycleGraph[count]}, {ball = InfraBall[1, count/10]},
      {count, N[InfraMeasurement[g, ball, "RiemannianMeasure"]/count], N[1/5], N[InfraMeasurement[g, ball, "CountingMeasure"]/count]}],
    {count, {100, 200, 400}}],
  {"N", "Riemannian", "volume", "counting"}], Frame -> All]
```

- On the square lattice with spacing $a$, vertex area $a^2$ and $R = ar$, the closed and the open count give $2R^2 + 2aR + a^2$ and $2R^2 - 2aR + a^2$, against the area $2R^2$ of the $\ell^1$ ball: relative errors $\pm a/R + a^2/(2R^2)$. Deleting the outer layer reverses the linear correction and keeps the constant term.

The two measures of the balls about the centre over $r = 0, \ldots, R$ as points, against the continuum volume counted in vertex cells. Here the columns are the square tiling, the mesh of the unit square and a mesh of the unit sphere. The continuum volume is, in turn, the area $2r^2$ of the $\ell^1$ ball, the area of the disk of radius $a r$ times the number of vertices, and the area of the cap of angular radius $a r$ times the number of vertices per unit area. The hop length $a$ is the mean distance of a vertex from the centre per hop, in the metric of the continuum: on the square tiling the $\ell^1$ metric of the lattice, which in the stored coordinates, turned by an eighth of a turn, is the chessboard metric; on the square the Euclidean metric; on the sphere the angle.

```wl
GraphicsGrid @ Table[
  With[
    {g = (SeedRandom[2]; InfraSubstrate[First[spec], size, "KeepCoordinates" -> True])},
    {c = First @ GraphCenter[g], radius = profileRadius[g], where = AssociationThread[VertexList[g], GraphEmbedding[g]]},
    {hop = Mean @ Map[pt |-> spec[[2]][where[pt], where[c]]/GraphDistance[g, c, pt], DeleteCases[VertexList[g], c]]},
    Show[
      Plot[spec[[3]][hop r, VertexCount[g]], {r, 0, radius}],
      ListPlot[twoMeasures[g, Table[InfraBall[c, r], {r, 0, radius}]], DataRange -> {0, radius}],
      PlotRange -> All]],
  {size, {"Small", "Medium", "Large"}},
  {spec, {
    {"SquareTilingGraph", ChessboardDistance, {rho, total} |-> 2 rho^2},
    {"SquareMeshGraph", EuclideanDistance, {rho, total} |-> total Pi rho^2},
    {"SphereMeshGraph", VectorAngle, {rho, total} |-> total (1 - Cos[rho])/2}}}]
```

- On every substrate the continuum volume runs between the two measures: the counting measure above, the Riemannian measure below, one layer of vertices apart.
- **The centre.** The ball of radius zero has counting measure one and Riemannian measure zero, and neither is wrong. The centre represents its cell; a ball of physical radius below the spacing contains only the centre, and its volume exponent is zero. A dimension appears only over a range of resolved scales, $h \ll \varepsilon \ll R \to 0$, and there closed balls and balls rounded by one hop have the same asymptotics.
- [[ Which weighting of the boundary, such as half weight on it as on the cycle, makes the error second order on a mesh? ]]

## Dimension

- On a space of dimension $d$ the ball volume grows like $r^d$. The **log-difference quotient** $\Delta(r) = \frac{\log V(r+1) - \log V(r)}{\log(r+1) - \log r}$ is the slope of $\log V$ against $\log r$ between two radii, and [LogDifferenceQuotients]() computes it.
- For a polynomial profile of degree $d$ with leading coefficient $c_d$ and next coefficient $c_{d-1}$, $\Delta(r) = d - \frac{c_{d-1}/c_d}{r} + O(r^{-2})$. For a lattice ball count $c_{d-1}/c_d = d/2$, so the counting profile $L(r)$ gives $d - \frac{d}{2r}$, from below, and the Riemannian profile $L(r - 1)$ gives $d + \frac{d}{2r}$, from above, at the same rate.
- The technical introduction of the Wolfram Physics Project, [section 4.5](https://www.wolframphysics.org/technical-introduction/limiting-behavior-and-emergent-geometry/the-notion-of-dimension/), defines $V_r$ as the number of vertices within distance $r$ and $\Delta(r)$ as above. Its code applies the log-differences to the list $V_0, V_1, V_2, \ldots$ that starts at radius zero, so the value it plots at radius $r$ is computed from $V_{r-1}$. On a lattice $V_{r-1}$ is the count of the interior of $B_r$: the introduction reads the Riemannian measure.

The introduction's code, beside the quotients of the paclet's two profiles, on the grid graph of the introduction.

```wl
With[
  {g = GridGraph[{51, 51}]},
  {c = First @ GraphCenter[g]},
  {ballVolumes = InfraMeasurement[g, Table[InfraBall[c, r], {r, 0, 25}], "CountingMeasure"]},
  ListLinePlot[{
      Take[ResourceFunction["LogDifferences"][N @ First @ Values @ ResourceFunction["GraphNeighborhoodVolumes"][g, {c}]], 24],
      LogDifferenceQuotients[N @ InfraMeasurement[g, Table[InfraBall[c, r], {r, 1, 25}], "RiemannianMeasure"]],
      LogDifferenceQuotients[N @ Rest[ballVolumes]]},
    PlotLegends -> {"introduction", "Riemannian", "counting"}, PlotMarkers -> Automatic, GridLines -> {None, {2}}, PlotRange -> All]]
```

- The introduction's curve is the Riemannian curve, point for point. The counting curve, each volume at its own radius, approaches two from below: the two readings of one profile differ most at small radius, where the dimension is read.

The two curves on the substrates: the counting curve $\Delta$ of $r \mapsto |B_r|$ in the first colour, the Riemannian curve $\Delta$ of $r \mapsto |\mathrm{Int} B_r|$ in the second, over the radii below the eccentricity of the centre. The curves are $2 - 1/r$ and $2 + 1/r$, the two rates of the planar lattices, and the line is the dimension two.

```wl
GraphicsGrid @ Table[
  With[
    {g = (SeedRandom[2]; InfraSubstrate[name, size])},
    {c = First @ GraphCenter[g]},
    {top = VertexEccentricity[g, c]},
    Show[
      Plot[{2 - 1/r, 2 + 1/r}, {r, 1, top - 2}],
      ListPlot[LogDifferenceQuotients /@ N[twoMeasures[g, Table[InfraBall[c, r], {r, 1, top - 1}]]]],
      GridLines -> {None, {2}}, PlotRange -> {0, 4}]],
  {size, {"Small", "Medium", "Large"}},
  {name, {"SquareTilingGraph", "TriangularTilingGraph", "SquareMeshGraph"}}]
```

- On every substrate the counting curve rises towards two from below and the Riemannian curve falls towards it from above, until the balls meet the rim of the substrate.
- The two curves part most at small radius, where a finite substrate is read. Their mean is $d + O(r^{-2})$ on the lattices.

### The row of section 4.5

The figures of the introduction's section, measured with the heads of this paclet: the balls through [InfraBall]() and [InfraMeasurement](), the quotients through [LogDifferenceQuotients](). Each quotient plot shows the introduction's reading, the profile from radius zero, as joined points, the counting curve at its own radius as points, and the reference dimension as a line.

The grids of dimension one, two and three, and their balls of radius zero to five about the centre.

```wl
Column @ Table[
  With[
    {g = GridGraph[sides]},
    {c = First @ GraphCenter[g]},
    GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraBall[c, r]}], {r, 0, 5}]],
  {sides, {{11}, {11, 11}, {7, 7, 7}}}]
```

The ball volumes of the finite grids against the infinite grid, $L_d(r) = \sum_k 2^k \binom{d}{k} \binom{r}{k}$, and against the leading term $\frac{2^d}{d!} r^d$.

```wl
GraphicsRow @ Table[
  With[
    {g = GridGraph[ConstantArray[11, dim]]},
    {c = First @ GraphCenter[g]},
    {top = VertexEccentricity[g, c]},
    Show[
      Plot[{Sum[2^k Binomial[dim, k] Binomial[r, k], {k, 0, dim}], 2^dim r^dim/dim!}, {r, 0, top}],
      ListPlot[InfraMeasurement[g, Table[InfraBall[c, r], {r, 0, top}], "CountingMeasure"], DataRange -> {0, top}],
      PlotRange -> All]],
  {dim, 3}]
```

The quotients at the centres of grids of dimension one, two and three.

```wl
GraphicsRow @ Table[
  With[
    {g = GridGraph[ConstantArray[First[spec], Last[spec]]]},
    {c = First @ GraphCenter[g]},
    {ballVolumes = N @ Table[InfraMeasurement[g, InfraBall[c, r], "CountingMeasure"], {r, 0, VertexEccentricity[g, c]}]},
    ListLinePlot[{LogDifferenceQuotients[ballVolumes], LogDifferenceQuotients[Rest[ballVolumes]]}, PlotMarkers -> Automatic, Joined -> {True, False}, GridLines -> {None, {Last[spec]}}, PlotRange -> All]],
  {spec, {{51, 1}, {51, 2}, {21, 3}}}]
```

The triangulated rectangle of the introduction, and its balls of radius one to six about the centre.

```wl
With[
  {g = MeshConnectivityGraph[DiscretizeRegion[Rectangle[], MaxCellMeasure -> 0.002]]},
  {c = First @ GraphCenter[g]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraBall[c, r]}], {r, 6}]]
```

Its quotients, the profiles averaged over the centres and their neighbours.

```wl
With[
  {g = MeshConnectivityGraph[DiscretizeRegion[Rectangle[], MaxCellMeasure -> 0.002]]},
  {seeds = VertexList @ NeighborhoodGraph[g, GraphCenter[g], 1]},
  {top = Min[VertexEccentricity[g, #] & /@ seeds]},
  {ballVolumes = MeanAround /@ Transpose @ Table[InfraMeasurement[g, Table[InfraBall[seed, r], {r, 0, top}], "CountingMeasure"], {seed, seeds}]},
  ListLinePlot[{LogDifferenceQuotients[ballVolumes], LogDifferenceQuotients[Rest[ballVolumes]]}, PlotMarkers -> Automatic, Joined -> {True, False}, GridLines -> {None, {2}}]]
```

The Sierpinski graphs of six and seven steps, against the Hausdorff dimension $\log 3 / \log 2$. The introduction averages the profiles over all vertices, here over a random sample of them.

```wl
GraphicsRow @ Table[
  With[
    {g = IndexGraph[MeshConnectivityGraph[SierpinskiMesh[steps], 0]]},
    {top = GraphRadius[g], seeds = (SeedRandom[3]; RandomSample[VertexList[g], 64])},
    {ballVolumes = MeanAround /@ Transpose @ Table[InfraMeasurement[g, Table[InfraBall[seed, r], {r, 0, top}], "CountingMeasure"], {seed, seeds}]},
    ListLinePlot[{LogDifferenceQuotients[ballVolumes], LogDifferenceQuotients[Rest[ballVolumes]]}, PlotMarkers -> Automatic, Joined -> {True, False}, GridLines -> {None, {Log[2, 3]}}]],
  {steps, {6, 7}}]
```

The binary tree of eleven levels, the profiles averaged over a random sample of vertices.

```wl
With[
  {g = KaryTree[2047]},
  {top = GraphRadius[g], seeds = (SeedRandom[3]; RandomSample[VertexList[g], 64])},
  {ballVolumes = MeanAround /@ Transpose @ Table[InfraMeasurement[g, Table[InfraBall[seed, r], {r, 0, top}], "CountingMeasure"], {seed, seeds}]},
  ListLinePlot[{LogDifferenceQuotients[ballVolumes], LogDifferenceQuotients[Rest[ballVolumes]]}, PlotMarkers -> Automatic, Joined -> {True, False}]]
```

Two Wolfram models, in the introduction's reading only. The first at the centre of its states after 500, 1000, …, 2500 steps; the second averaged over a random sample of vertices of the same states. Both against the dimension two.

```wl
GraphicsRow @ Table[
  Show[
    ListLinePlot[
      Table[
        With[
          {g = UndirectedGraph @ ResourceFunction["HypergraphToGraph"][Quiet @ ResourceFunction["WolframModel"][First[spec], {{0, 0, 0}, {0, 0, 0}}, steps, "FinalState"]]},
          {top = GraphRadius[g], seeds = If[Last[spec], (SeedRandom[3]; RandomSample[VertexList[g], 32]), {First @ GraphCenter[g]}]},
          LogDifferenceQuotients[MeanAround /@ Transpose @ Table[InfraMeasurement[g, Table[InfraBall[seed, r], {r, 0, top}], "CountingMeasure"], {seed, seeds}]]],
        {steps, 500, 2500, 500}]],
    GridLines -> {None, {2}}],
  {spec, {{{{1, 2, 2}, {3, 1, 4}} -> {{2, 5, 2}, {2, 3, 5}, {4, 5, 5}}, False}, {{{1, 1, 2}, {1, 3, 4}} -> {{4, 4, 5}, {5, 4, 2}, {3, 2, 5}}, True}}}]
```

- On the grids and the mesh the introduction's reading approaches the dimension from above, and the counting curve at its own radius from below; the two differ most at the small radii, which are all a finite graph has. On the Sierpinski graphs both readings oscillate about the Hausdorff dimension, the introduction's above the other at small radii.
- The binary tree has no finite dimension under either reading: its quotients grow with the radius, as its ball volume grows exponentially. The two models settle near two as they grow.
