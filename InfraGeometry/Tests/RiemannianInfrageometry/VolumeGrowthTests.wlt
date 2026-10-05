BeginTestSection["VolumeGrowth"]

(* The volume-growth tests, moved from the DiscreteGeometry paclet's InfrageometryTests.wlt by PacletSplit T2c as
   RiemannianTests.wlt; its other sections went to the test files of their kernel files on 2026-10-05 (APISurfaceCleanup T9). *)

(* ===== Synthetic invariants: the two measures of the regions / LogDifferenceQuotients ===== *)

(* the two measures of the balls about vertex 1 of the Petersen graph: every vertex of the ball
   touches the complement until the ball is the whole graph, so the Riemannian measure lags
   the counting measure by one shell *)
VerificationTest[
    Table[InfraMeasurement[PetersenGraph[], InfraBall[1, r], #], {r, 0, 2}] & /@ {"CountingMeasure", "RiemannianMeasure"},
    {{1, 4, 10}, {0, 1, 10}},
    TestID -> "InfraBall-two-measures-Petersen"
]

(* the counting measure less the Riemannian measure is the inner vertex boundary of the ball at every radius *)
VerificationTest[
    With[{g = GridGraph[{7, 7}]},
        {row = GraphDistance[g, 25]},
        Table[InfraMeasurement[g, InfraBall[25, r], "CountingMeasure"] - InfraMeasurement[g, InfraBall[25, r], "RiemannianMeasure"],
            {r, 0, Max[row]}] ===
            Table[Length @ GraphBoundary[g, Pick[VertexList[g], Thread[row <= r]]], {r, 0, Max[row]}]
    ],
    True,
    TestID -> "InfraBall-counting-less-Riemannian-is-GraphBoundary"
]

(* in the bulk of a lattice the boundary of B_r is the whole shell S_r, so the Riemannian
   measure of B_r is the counting measure of B_(r-1) *)
VerificationTest[
    With[{g = GridGraph[{11, 11}]},
        Table[InfraMeasurement[g, InfraBall[61, r], "RiemannianMeasure"], {r, 1, 4}] ===
            Table[InfraMeasurement[g, InfraBall[61, r], "CountingMeasure"], {r, 0, 3}]
    ],
    True,
    TestID -> "InfraBall-Riemannian-shifts-on-lattice"
]

(* on Z^2 and Z^3 the counting measure of B_r is the Ehrhart polynomial L_d(r) of the cross-polytope,
   2 r^2 + 2 r + 1 and 4/3 r^3 + 2 r^2 + 8/3 r + 1, and the Riemannian measure is L_d(r - 1) *)
VerificationTest[
    {Table[InfraMeasurement[GridGraph[{11, 11}], InfraBall[61, r], #], {r, 1, 4}] & /@ {"CountingMeasure", "RiemannianMeasure"},
     Table[InfraMeasurement[GridGraph[{9, 9, 9}], InfraBall[365, r], #], {r, 1, 3}] & /@ {"CountingMeasure", "RiemannianMeasure"}},
    {{Table[2 r^2 + 2 r + 1, {r, 1, 4}], Table[2 (r - 1)^2 + 2 (r - 1) + 1, {r, 1, 4}]},
     {Table[4/3 r^3 + 2 r^2 + 8/3 r + 1, {r, 1, 3}], Table[4/3 (r - 1)^3 + 2 (r - 1)^2 + 8/3 (r - 1) + 1, {r, 1, 3}]}},
    TestID -> "InfraBall-two-measures-Ehrhart-Z2-Z3"
]

(* Ehrhart-Macdonald reciprocity read off the counting measure: the polynomial through the
   first three Z^2 volumes is 2 x^2 + 2 x + 1, and its values at -r are the open counts |B_(r-1)|,
   which are the Riemannian measures of B_r *)
VerificationTest[
    With[{v = Table[InfraMeasurement[GridGraph[{11, 11}], InfraBall[61, r], "CountingMeasure"], {r, 0, 4}]},
        {ell = InterpolatingPolynomial[Table[{r, v[[r + 1]]}, {r, 0, 2}], x]},
        {Expand[ell], Table[ell /. x -> -r, {r, 1, 4}] === v[[1 ;; 4]],
         Table[ell /. x -> -r, {r, 1, 4}] === Table[InfraMeasurement[GridGraph[{11, 11}], InfraBall[61, r], "RiemannianMeasure"], {r, 1, 4}]}
    ],
    {1 + 2 x + 2 x^2, True, True},
    TestID -> "InfraBall-Ehrhart-reciprocity-Z2"
]

(* the triangular and honeycomb lattices: the counting measures 3 r^2 + 3 r + 1 and 1 + 3 r (r + 1) / 2,
   the Riemannian measures one radius earlier *)
VerificationTest[
    With[{tri = IndexGraph @ TessellationGraph[{3, 6}, {16, 16}], hex = IndexGraph @ TessellationGraph[{6, 3}, {14, 14}]},
        Table[InfraMeasurement[#1, InfraBall[1, r], #2], {r, 1, 5}] & @@@ Tuples[{{tri, hex}, {"CountingMeasure", "RiemannianMeasure"}}]
    ],
    {Table[3 r^2 + 3 r + 1, {r, 1, 5}], Table[3 r^2 - 3 r + 1, {r, 1, 5}],
     Table[1 + 3 r (r + 1) / 2, {r, 1, 5}], Table[1 + 3 r (r - 1) / 2, {r, 1, 5}]},
    TestID -> "InfraBall-two-measures-triangular-honeycomb"
]

(* the log-difference quotient of a clean power law r^d recovers the exponent d *)
VerificationTest[
    Round[Last @ LogDifferenceQuotients[N[Range[1, 20]^3]], 0.001],
    3.,
    TestID -> "LogDifferenceQuotients-power-law-exponent"
]

(* the defining identity of the shell count: A(r) = V(r) - V(r-1), V(-1) = 0, under the counting measure *)
VerificationTest[
    With[{g = GridGraph[{9, 9}]},
        Accumulate @ Table[InfraMeasurement[g, InfraShell[41, r], "CountingMeasure"], {r, 0, 8}] ===
            Table[InfraMeasurement[g, InfraBall[41, r], "CountingMeasure"], {r, 0, 8}]],
    True,
    TestID -> "InfraShell-counting-accumulates-to-InfraBall"
]

(* the counting measure of the shells is the OEIS coordination sequence, A(1) the degree *)
VerificationTest[
    {Table[InfraMeasurement[GridGraph[{11, 11}], InfraShell[61, r], "CountingMeasure"], {r, 0, 4}],
     Table[InfraMeasurement[HypercubeGraph[4], InfraShell[1, r], "CountingMeasure"], {r, 0, 4}],
     Table[InfraMeasurement[CycleGraph[9], InfraShell[1, r], "CountingMeasure"], {r, 0, 4}]},
    {{1, 4, 8, 12, 16}, {1, 4, 6, 4, 1}, {1, 2, 2, 2, 2}},
    TestID -> "InfraShell-counting-is-the-coordination-sequence"
]

(* past the eccentricity the shell is empty *)
VerificationTest[
    Table[InfraMeasurement[PathGraph[Range[4]], InfraShell[1, r], "CountingMeasure"], {r, 0, 6}],
    {1, 1, 1, 1, 0, 0, 0},
    TestID -> "InfraShell-counting-is-zero-past-the-eccentricity"
]

(* the sphere probe of the growth fit reads exactly the counting measure of the shells *)
VerificationTest[
    With[{g = GridGraph[{13, 13}]},
        VolumeGrowthObservables[g, 85]["ShellAreas"] ===
            Table[InfraMeasurement[g, InfraShell[85, r], "CountingMeasure"], {r, 0, VertexEccentricity[g, 85]}]],
    True,
    TestID -> "VolumeGrowthObservables-sphere-probe-is-the-shell-count"
]

(* slope-of-mean: average the ball profiles over the vertices, then one slope.
   On a vertex-transitive graph every profile is identical, so it equals the
   single-vertex slope -- aggregation is caller-side composition, no option *)
VerificationTest[
    With[{w = Table[InfraMeasurement[CycleGraph[40], InfraBall[v, r], "CountingMeasure"], {v, 40}, {r, 0, 18}]},
        Max @ Abs[LogDifferenceQuotients[Mean /@ Transpose[w]] - LogDifferenceQuotients[First @ w]] < 10.^-10],
    True,
    TestID -> "LogDifferenceQuotients-slope-of-mean-vertex-transitive"
]

(* averaging over a vertex SUBSET reproduces the single-vertex slope on a transitive graph *)
VerificationTest[
    With[{w = Table[InfraMeasurement[CycleGraph[40], InfraBall[v, r], "CountingMeasure"], {v, {1, 5, 9}}, {r, 0, 18}]},
        Max @ Abs[LogDifferenceQuotients[Mean /@ Transpose[w]] - LogDifferenceQuotients[First @ w]] < 10.^-10],
    True,
    TestID -> "LogDifferenceQuotients-subset-aggregation"
]

(* MeanAround carries the per-vertex spread into Around; central values match Mean *)
VerificationTest[
    With[{w = Transpose @ Table[InfraMeasurement[GridGraph[{5, 5}], InfraBall[v, r], "CountingMeasure"], {v, 25}, {r, 0, 6}]},
        Max @ Abs[(#[[1]] & /@ LogDifferenceQuotients[MeanAround /@ w]) - LogDifferenceQuotients[Mean /@ w]] < 10.^-10
    ],
    True,
    TestID -> "LogDifferenceQuotients-MeanAround-central-equals-Mean"
]

(* ===== VolumeGrowthObservables: joined ball + sphere growth fit (flat assoc) ===== *)

(* endpoint of a path: shell area A(r) = 1 (one vertex per distance) is a pure r^0 power,
   so the sphere probe reads the manifold dimension n = 1 exactly with S = 0 (the ball probe
   is not exact here: the boundary correction distorts a graph this small) *)
VerificationTest[
    With[{r = VolumeGrowthObservables[PathGraph[Range[5]], 1]},
        {Chop[r["SphereDimension"] - 1], Chop @ r["SphereScalarCurvature"]}
    ],
    {0, 0},
    TestID -> "VolumeGrowthObservables-P5-sphere-exact-line"
]

(* the cycle: until the wrap the shell count is 2, so the sphere probe reads d = 1 and R = 0 exactly;
   the Riemannian measure of B_r is 2 r - 1, so the ball probe reads d within 0.15 of 1 and R within 0.01
   of 0, on the Automatic window and on the full range alike *)
VerificationTest[
    With[{auto = VolumeGrowthObservables[CycleGraph[40], 1], full = VolumeGrowthObservables[CycleGraph[40], 1, All]},
        {Chop[{auto["SphereDimension"] - 1, auto["SphereScalarCurvature"]}, 10.^-8],
         Max @ Abs[{auto["BallDimension"], full["BallDimension"]} - 1] < 0.15,
         Max @ Abs[{auto["BallScalarCurvature"], full["BallScalarCurvature"]}] < 0.01}
    ],
    {{0, 0}, True, True},
    TestID -> "VolumeGrowthObservables-C40-cycle"
]

(* on a flat lattice the counting measure of B_r carries a positive r^(d-1) term and the Riemannian
   measure a negative one, so the two ball probes read the dimension from below and from above *)
VerificationTest[
    Table[
        With[{g = c[[1]], v = c[[2]], d = c[[3]]},
            VolumeGrowthObservables[g, v, "Measure" -> "CountingMeasure"]["BallDimension"] < d <
                VolumeGrowthObservables[g, v, "Measure" -> "RiemannianMeasure"]["BallDimension"]],
        {c, {{CycleGraph[40], 1, 1}, {GridGraph[{15, 15}], 113, 2},
             With[{t = TessellationGraph[{4, 4}, {20, 20}]}, {t, First @ VertexList @ t, 2}]}}],
    {True, True, True},
    TestID -> "VolumeGrowthObservables-two-measures-bracket-the-dimension"
]

(* the measure is one of the two; any other name leaves the call unevaluated *)
VerificationTest[
    With[{g = GridGraph[{7, 7}]},
        {VolumeGrowthObservables[g, 25, "Measure" -> "CountingMeasure"]["BallVolumes"] ===
             Table[InfraMeasurement[g, InfraBall[25, r], "CountingMeasure"], {r, 0, 6}],
         MatchQ[VolumeGrowthObservables[g, 25, "Measure" -> "HalfBoundary"], _VolumeGrowthObservables]}],
    {True, True},
    TestID -> "VolumeGrowthObservables-two-measures-only"
]

(* flat 20x20 square torus: the Riemannian measure is V(r) = 2 r^2 - 2 r + 1 until the wrap at r = 10, so
   the Automatic window stays before the wrap and reads d ~ 2, R ~ 0 -- with the honest bias
   of the r^(d-1) term, which pushes the quotient above 2 on a coarse lattice (the sphere
   probe is the exact one here) *)
VerificationTest[
    With[{g = TessellationGraph[{4, 4}, {20, 20}]},
        {v = First @ VertexList @ g},
        {auto = VolumeGrowthObservables[g, v]},
        {Abs[auto["BallDimension"] - 2] < 0.35, Abs[auto["BallScalarCurvature"]] < 0.1, Last[auto["BallWindow"]] <= 10}
    ],
    {True, True, True},
    TestID -> "VolumeGrowthObservables-torus-window-before-wrap"
]

(* the Automatic ball fit is reproducible from its own reported window *)
VerificationTest[
    With[{auto = VolumeGrowthObservables[CycleGraph[40], 1]},
        KeyTake[auto, {"BallDimension", "BallScalarCurvature", "BallWindow"}] ===
            KeyTake[VolumeGrowthObservables[CycleGraph[40], 1, auto["BallWindow"]], {"BallDimension", "BallScalarCurvature", "BallWindow"}]
    ],
    True,
    TestID -> "VolumeGrowthObservables-automatic-window-consistency"
]

(* the per-radius ball curvature profile has one entry per radius r = 1..ecc(v) *)
VerificationTest[
    Length[VolumeGrowthObservables[HypercubeGraph[8], 1]["BallCurvatureByRadius"]] === VertexEccentricity[HypercubeGraph[8], 1],
    True,
    TestID -> "VolumeGrowthObservables-ball-CurvatureByRadius-length"
]

(* positively curved Hamming cube: the sphere probe reads S > 0 on the rising shells *)
VerificationTest[
    VolumeGrowthObservables[HypercubeGraph[8], 1]["SphereScalarCurvature"] > 0,
    True,
    TestID -> "VolumeGrowthObservables-Q8-sphere-positive-curvature"
]

(* flat square grid: the ball probe on the Riemannian measure reads R = 0 to within 0.1 on the
   detected window (the r^(d-1) term of the measure is the residual) *)
VerificationTest[
    With[{g = GridGraph[{15, 15}]},
        Abs[VolumeGrowthObservables[g, First @ GraphCenter @ g]["BallScalarCurvature"]] < 0.1
    ],
    True,
    TestID -> "VolumeGrowthObservables-grid2D-ball-flat"
]

(* pinned dimension fits only the slope, on the same detected window *)
VerificationTest[
    With[{g = TessellationGraph[{4, 4}, {20, 20}]},
        {v = First @ VertexList @ g},
        {pinned = VolumeGrowthObservables[g, v, "Dimension" -> 2], auto = VolumeGrowthObservables[g, v]},
        {pinned["BallDimension"], pinned["BallWindow"] === auto["BallWindow"]}
    ],
    {2., True},
    TestID -> "VolumeGrowthObservables-pinned-dimension-window"
]

(* flat square grid: shell area A(r) = 4 r exactly on the rising part, so q == 1, the
   sphere intercept is n - 1 = 1, the reported manifold dimension is n = 2 and S = 0 *)
VerificationTest[
    With[{g = GridGraph[{15, 15}]},
        {r = VolumeGrowthObservables[g, First @ GraphCenter @ g]},
        {Abs[r["SphereDimension"] - 2] < 1.*^-6, Abs @ r["SphereScalarCurvature"] < 1.*^-6}
    ],
    {True, True},
    TestID -> "VolumeGrowthObservables-grid2D-sphere-flat"
]

(* flat cubic grid: sphere manifold dimension recovered as ~ 3 *)
VerificationTest[
    With[{g = GridGraph[{9, 9, 9}]},
        Abs[VolumeGrowthObservables[g, First @ GraphCenter @ g]["SphereDimension"] - 3] < 0.2
    ],
    True,
    TestID -> "VolumeGrowthObservables-grid3D-sphere-dimension"
]

(* dual probe: ball and sphere agree on the manifold dimension of a flat lattice *)
VerificationTest[
    With[{g = GridGraph[{15, 15}]},
        {p = VolumeGrowthObservables[g, First @ GraphCenter @ g]},
        Abs[p["BallDimension"] - p["SphereDimension"]] < 0.4
    ],
    True,
    TestID -> "VolumeGrowthObservables-ball-sphere-dimension-agreement-flat"
]

(* flat torus through the sphere probe: d = 2, S = 0 *)
VerificationTest[
    With[{g = TessellationGraph[{4, 4}, {20, 20}]},
        {r = VolumeGrowthObservables[g, First @ VertexList @ g]},
        {Abs[r["SphereDimension"] - 2] < 0.05, Abs @ r["SphereScalarCurvature"] < 1.*^-6}
    ],
    {True, True},
    TestID -> "VolumeGrowthObservables-torus-sphere-flat"
]

(* negative curvature: ball and sphere scalar-curvature estimates share sign (both < 0)
   on a radius-5 disk of the hyperbolic {3,7} tessellation -- the dual-probe consistency check *)
VerificationTest[
    With[{p = VolumeGrowthObservables[TessellationNeighborhoodGraph[{3, 7}, 5], 1]},
        Sign[p["BallScalarCurvature"]] === Sign[p["SphereScalarCurvature"]] === -1
    ],
    True,
    TestID -> "VolumeGrowthObservables-negative-curvature-sign-agreement"
]

(* the sphere fit exposes the per-radius area-curvature and mean-curvature profiles *)
VerificationTest[
    With[{r = VolumeGrowthObservables[HypercubeGraph[8], 1]},
        {Length[r["SphereCurvatureByRadius"]] === VertexEccentricity[HypercubeGraph[8], 1],
         Length[r["SphereMeanCurvatureByRadius"]] === VertexEccentricity[HypercubeGraph[8], 1]}
    ],
    {True, True},
    TestID -> "VolumeGrowthObservables-sphere-profiles-length"
]

(* the bundle is self-consistent: "BallVolumes" is the Riemannian measure of the balls that the fit
   consumes (default), "ShellAreas" the counting measure of the shells, and "...LogDifferenceQuotients"
   the radius-correct log-log slope of exactly those profiles *)
VerificationTest[
    With[{g = GridGraph[{9, 9}]},
        {v = First @ GraphCenter @ g},
        {r = VolumeGrowthObservables[g, v], radii = Range[0, VertexEccentricity[g, v]],
         rq = (f |-> Table[(Log[N @ f[[k + 2]]] - Log[N @ f[[k + 1]]]) / (Log[k + 1.] - Log[k]), {k, 1, Length[f] - 2}])},
        {
            r["ShellAreas"] === Prepend[Differences[InfraMeasurement[g, InfraBall[v, #], "CountingMeasure"] & /@ radii], 1],
            r["BallVolumes"] === (InfraMeasurement[g, InfraBall[v, #], "RiemannianMeasure"] & /@ radii),
            Max @ Abs[r["BallLogDifferenceQuotients"] - rq[r["BallVolumes"]]] < 10.^-10,
            Max @ Abs[r["SphereLogDifferenceQuotients"] - rq[r["ShellAreas"]]] < 10.^-10
        }
    ],
    {True, True, True, True},
    TestID -> "VolumeGrowthObservables-raw-profiles-match-the-heads"
]

(* ===== DimensionCurvatureFit: Bishop-Gromov regression of log-differences ===== *)

(* an exactly linear quotient sequence q(r) = d - R/(3(d+2)) r(r+1) is recovered exactly:
   here d = 2, slope = -0.1 on x = r(r+1), so R = -3 (2 + 2) (-0.1) = 1.2 *)
VerificationTest[
    With[{pairs = Table[{r, 2 - 0.1 r (r + 1)}, {r, 1, 10}]},
        {fit = DimensionCurvatureFit[pairs]},
        {Chop[fit["Dimension"] - 2], Chop[fit["ScalarCurvature"] - 1.2]}
    ],
    {0, 0},
    TestID -> "DimensionCurvatureFit-recovers-exact-line"
]

(* a bare quotient list defaults to radii 0, 1, 2, ... -- same as the explicit pairs form *)
VerificationTest[
    With[{q = {1.0, 0.92, 0.81, 0.63, 0.4}},
        DimensionCurvatureFit[q] === DimensionCurvatureFit[Transpose[{Range[0, Length[q] - 1], q}]]
    ],
    True,
    TestID -> "DimensionCurvatureFit-bare-list-radii-default"
]

(* the headline composition: the index-based LogDifferenceQuotients of the counting measure of the balls,
   sliced to an inner window and regressed, reads the lattice dimension d = 2 (the off-by-one of
   the index quotient on the counting measure is the one-radius boundary shift) *)
VerificationTest[
    With[{g = GridGraph[{21, 21}]},
        {v = First @ GraphCenter @ g},
        {q = LogDifferenceQuotients[Table[InfraMeasurement[g, InfraBall[v, r], "CountingMeasure"], {r, 0, VertexEccentricity[g, v]}]]},
        {pairs = Select[Transpose[{Range[0, Length[q] - 1], q}], 1 <= #[[1]] <= 7 &]},
        Abs[DimensionCurvatureFit[pairs]["Dimension"] - 2] < 0.4
    ],
    True,
    TestID -> "DimensionCurvatureFit-counting-index-reads-lattice-dimension"
]

(* Around-valued quotients (the across-vertex spread of the averaged profile) carry through the
   closed-form fit to Around dimension and curvature *)
VerificationTest[
    With[{g = GridGraph[{15, 15}]},
        {rq = (f |-> Table[(Log[f[[k + 2]]] - Log[f[[k + 1]]]) / (Log[k + 1.] - Log[k]), {k, 1, Length[f] - 2}])},
        {avg = Exp /@ (MeanAround /@ Transpose[Log[N[Table[InfraMeasurement[g, InfraBall[v, r], "RiemannianMeasure"], {v, VertexList[g]}, {r, 0, 8}]]]])},
        {fit = DimensionCurvatureFit[rq[avg]]},
        {Head[fit["Dimension"]], Head[fit["ScalarCurvature"]]}
    ],
    {Around, Around},
    TestID -> "DimensionCurvatureFit-Around-propagates"
]

(* pinning the dimension fixes the intercept and fits the slope only *)
VerificationTest[
    With[{pairs = Table[{r, 2.3 - 0.05 r (r + 1)}, {r, 1, 8}]},
        DimensionCurvatureFit[pairs, "Dimension" -> 2]["Dimension"] == 2
    ],
    True,
    TestID -> "DimensionCurvatureFit-pinned-dimension"
]

(* ===== InfraTube: the tube measures T(s) = |{ w : d(w, core) <= s }| ===== *)

(* tube around a meridian of the flat torus: T(s) = 20 (2s + 1) exactly until saturation *)
VerificationTest[
    With[{torus = GraphProduct[CycleGraph[20], CycleGraph[20], "Cartesian"]},
        Table[InfraMeasurement[torus, InfraTube[Select[VertexList[torus], First[#] === 1 &], s], "CountingMeasure"], {s, 0, 8}]
    ],
    Table[20 (2 s + 1), {s, 0, 8}],
    TestID -> "InfraTube-torus-meridian-exact"
]

(* fiber tube in a Cartesian product decouples: T(s; {x0} x V(H)) = |V(H)| V_G(s; x0) *)
VerificationTest[
    With[{prod = GraphProduct[GridGraph[{5, 5}], CycleGraph[6], "Cartesian"]},
        Table[InfraMeasurement[prod, InfraTube[Thread[{13, Range[6]}], s], "CountingMeasure"], {s, 0, 4}] ===
            6 Table[InfraMeasurement[GridGraph[{5, 5}], InfraBall[13, s], "CountingMeasure"], {s, 0, 4}]
    ],
    True,
    TestID -> "InfraTube-product-fiber-decouples"
]

(* T(0) = |core|; the profile is nondecreasing and saturates at the component size *)
VerificationTest[
    With[{prof = Table[InfraMeasurement[PetersenGraph[], InfraTube[{1, 2}, s], "CountingMeasure"], {s, 0, 2}]},
        {First[prof] == 2, prof === Sort[prof], Last[prof] == 10}
    ],
    {True, True, True},
    TestID -> "InfraTube-profile-shape"
]

(* a one-vertex core is the ball: both measures agree with the ball's *)
VerificationTest[
    With[{g = GridGraph[{5, 5}]},
        And @@ Flatten @ Table[InfraMeasurement[g, InfraTube[{13}, s], m] === InfraMeasurement[g, InfraBall[13, s], m],
            {m, {"CountingMeasure", "RiemannianMeasure"}}, {s, 0, 4}]
    ],
    True,
    TestID -> "InfraTube-point-core-is-ball"
]

(* the torus meridian: the two outer rows of the tube are its boundary, so the Riemannian
   measure is the counting measure one thickness earlier, 20 (2 s - 1) *)
VerificationTest[
    With[{torus = GraphProduct[CycleGraph[20], CycleGraph[20], "Cartesian"]},
        Table[InfraMeasurement[torus, InfraTube[Select[VertexList[torus], First[#] === 1 &], s], "RiemannianMeasure"], {s, 1, 8}]
    ],
    Table[20 (2 s - 1), {s, 1, 8}],
    TestID -> "InfraTube-torus-meridian-Riemannian"
]

(* Tube probe: q(s) = (d - 1) - (tau + Ric(v,v))/(3(d+1)) s(s+1); d = 2 makes the
   synthetic slope -Q/9 read back as exactly Q *)
VerificationTest[
    With[{pairs = Table[{s, 1. - (0.9/9) s (s + 1)}, {s, 1, 8}]},
        {fit = DimensionCurvatureFit[pairs, "Probe" -> "Tube"]},
        Max[Abs[fit["Dimension"] - 2], Abs[fit["ScalarCurvature"] - 0.9]] < 10.^-10
    ],
    True,
    TestID -> "DimensionCurvatureFit-Tube-probe-exact"
]

(* TubeMantle probe: q(s) = (d - 2) - (tau + Ric(v,v))/(3(d-1)) s(s+1); d = 3 slope -Q/6 *)
VerificationTest[
    With[{pairs = Table[{s, 1. - (0.6/6) s (s + 1)}, {s, 1, 8}]},
        {fit = DimensionCurvatureFit[pairs, "Probe" -> "TubeMantle"]},
        Max[Abs[fit["Dimension"] - 3], Abs[fit["ScalarCurvature"] - 0.6]] < 10.^-10
    ],
    True,
    TestID -> "DimensionCurvatureFit-TubeMantle-probe-exact"
]

(* pinned tube probe fits the slope only, through the pinned intercept d - 1 *)
VerificationTest[
    With[{pairs = Table[{s, 1. - (0.9/9) s (s + 1)}, {s, 1, 8}]},
        {fit = DimensionCurvatureFit[pairs, "Probe" -> "Tube", "Dimension" -> 2]},
        {fit["Dimension"], Abs[fit["ScalarCurvature"] - 0.9] < 10.^-10}
    ],
    {2., True},
    TestID -> "DimensionCurvatureFit-Tube-pinned"
]

EndTestSection[]
