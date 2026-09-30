Package["WolframInstitute`InfraGeometry`"]


(* ===================== Ball hull ===================== *)

(* BallHull[g, S]: intersection of all closed metric balls containing S, the
   smallest ball-convex (Mazur) superset of S.  For each center c the smallest
   enclosing radius is r_c = max_{s in S} d(c, s); v lies in the hull iff
   d(c, v) <= r_c for every c.  Read straight off the distance matrix. *)

BallHull[g_Graph, subgraph_Graph] :=
	BallHull[g, VertexList[subgraph]]

BallHull[g_Graph, S_List] :=
	With[{dist = GraphDistanceMatrix[g], idx = VertexIndex[g, #] & /@ S},
		With[{radii = Max /@ dist[[All, idx]]},
			Pick[VertexList[g], AllTrue[NonNegative] /@ Transpose[radii - dist], True]
		]
	]


(* ===================== Ball volumes ===================== *)

(* V(r) = |B_r(v)| as the List {V(0), ..., V(ecc(v))} (position i is radius i - 1).  Object
   slot 2 (single vertex, list, or All), radius slot 3 (All -> the full profile; r_Integer
   -> the scalar V(r); {rmin, rmax} -> the rectangular window, saturating past the eccentricity
   so that it Transposes over a vertex list).  Option "Measure", with
   dB_r = GraphBoundary[g, B_r] the vertices of the ball adjacent to its complement:
     "FullCount"        |B_r|                                              (default)
     "WithoutBoundary"  |B_r| - |dB_r| = |GraphInterior[g, B_r]|  (= |B_{r-1}| in a lattice bulk)
     "HalfBoundary"     |B_r| - |dB_r|/2   -- on Z^d the parity-d part of the Ehrhart polynomial
                        of the cross-polytope, so the r^(d-1) term is gone: 2 r^2 + 1 on Z^2,
                        4/3 r^3 + 8/3 r on Z^3 (the growth fit's default)
     "ExpandingFront"   the passage count of the advancing front, slot 3 a step count; the front
                        never stops, so All runs it 2 max rho steps, one out-and-back
   A vertex v leaves dB_r at r = max_{w in N[v]} d(v0, w), the maximum of the distance over its
   closed neighbourhood, so the boundary measures are one pass over the adjacency lists
   instead of one GraphInterior per radius.  The growth invariant feeding VolumeGrowthObservables. *)

Options[BallVolumes] = {"Measure" -> "FullCount"};

BallVolumes[g_Graph, opts : OptionsPattern[]] := BallVolumes[g, All, All, opts]

BallVolumes[g_Graph, pts : (All | _List | Except[_Rule | _RuleDelayed]), opts : OptionsPattern[]] :=
	BallVolumes[g, pts, All, opts]

(* the all/list form reads every vertex's distances off one GraphDistanceMatrix:
   one optimized all-pairs call is ~200x faster than V separate GraphDistance BFS
   calls (each carries a fixed graph-to-internal-rep overhead paid V times) *)
BallVolumes[g_Graph,
	vertices : (_List | All),
	range : (_Integer | {_Integer, _Integer} | All),
	OptionsPattern[]
] /; vertices === All || ! MemberQ[VertexList[g], vertices] :=
	With[
		{dm = GraphDistanceMatrix[g], adj = AdjacencyMatrix[g]["AdjacencyLists"], measure = OptionValue["Measure"]},
		{targets = If[vertices === All, VertexList[g], vertices]},
		MapThread[
			{v, rho} |-> With[{bins = {0, Max @ DeleteCases[rho, Infinity] + 1, 1}},
				{full = Accumulate @ BinCounts[rho, bins]},
				{c = Switch[measure,
					"FullCount",       full,
					"WithoutBoundary", Accumulate @ BinCounts[MapThread[Max, {rho, Max[rho[[#]]] & /@ adj}], bins],
					"HalfBoundary",    (full + Accumulate @ BinCounts[MapThread[Max, {rho, Max[rho[[#]]] & /@ adj}], bins]) / 2,
					"ExpandingFront",  Accumulate[Length /@ FindAdvancingInfraFront[g, {v}, Replace[range, {All :> 2 Max @ DeleteCases[rho, Infinity], {_, b_} :> b}]]]
				]},
				{at = r |-> If[0 <= r < Length[c], c[[r + 1]], Last[c]]},
				Switch[range, All, c, _Integer, at[range], _, at /@ Range @@ range]],
			{targets, dm[[VertexIndex[g, #] & /@ targets]]}]
	]

BallVolumes[g_Graph,
	vertex : Except[All | _Rule | _RuleDelayed],
	range : (_Integer | {_Integer, _Integer} | All),
	OptionsPattern[]
] :=
	With[{rho = GraphDistance[g, vertex]},
		{bins = {0, Max @ DeleteCases[rho, Infinity] + 1, 1}},
		{full = Accumulate @ BinCounts[rho, bins]},
		{c = Switch[OptionValue["Measure"],
			"FullCount",       full,
			"WithoutBoundary", Accumulate @ BinCounts[MapThread[Max, {rho, Max[rho[[#]]] & /@ AdjacencyMatrix[g]["AdjacencyLists"]}], bins],
			"HalfBoundary",    (full + Accumulate @ BinCounts[MapThread[Max, {rho, Max[rho[[#]]] & /@ AdjacencyMatrix[g]["AdjacencyLists"]}], bins]) / 2,
			"ExpandingFront",  Accumulate[Length /@ FindAdvancingInfraFront[g, {vertex}, Replace[range, {All :> 2 Max @ DeleteCases[rho, Infinity], {_, b_} :> b}]]]
		]},
		{at = r |-> If[0 <= r < Length[c], c[[r + 1]], Last[c]]},
		Switch[range, All, c, _Integer, at[range], _, at /@ Range @@ range]
	]


(* ===================== Shell areas ===================== *)

(* A(r) = V(r) - V(r-1) as the List {A(0), ..., A(ecc(v))}, with V(-1) = 0: the radial
   derivative of BallVolumes under the SAME "Measure", so Accumulate[ShellAreas] == BallVolumes
   measure for measure.  Object slot 2 and radius slot 3 are BallVolumes'; a finite window
   pads past eccentricity with 0, the empty shell.
     "FullCount"        |S_r(v)| -- the discrete geodesic-sphere area, the crystallography /
                        OEIS coordination sequence, A(1) = the coordination number (default)
     "WithoutBoundary"  the interior shell, |S_r| shifted one radius in a lattice bulk
     "HalfBoundary"     (A(r) + A(r-1))/2, the centred shell count; A(0) = 1/2, since
                        dB_0 = {v} whenever v has a neighbour
     "ExpandingFront"   |F_t|, the size of the advancing front at step t, which continues
                        past the eccentricity where the metric shell dies
   Every branch is the direct count -- the histogram of the distance vector, the histogram of
   its closed-neighbourhood maximum, their mean, the front cardinalities -- so nothing is
   accumulated and then differenced back: this is BallVolumes' work less one Accumulate.
   The sphere probe of VolumeGrowthObservables runs on the "FullCount" shell. *)

Options[ShellAreas] = {"Measure" -> "FullCount"};

ShellAreas[g_Graph, opts : OptionsPattern[]] := ShellAreas[g, All, All, opts]

ShellAreas[g_Graph, pts : (All | _List | Except[_Rule | _RuleDelayed]), opts : OptionsPattern[]] :=
	ShellAreas[g, pts, All, opts]

ShellAreas[g_Graph,
	vertices : (_List | All),
	range : (_Integer | {_Integer, _Integer} | All),
	OptionsPattern[]
] /; vertices === All || ! MemberQ[VertexList[g], vertices] :=
	With[
		{dm = GraphDistanceMatrix[g], adj = AdjacencyMatrix[g]["AdjacencyLists"], measure = OptionValue["Measure"]},
		{targets = If[vertices === All, VertexList[g], vertices]},
		MapThread[
			{v, rho} |-> With[{bins = {0, Max @ DeleteCases[rho, Infinity] + 1, 1}},
				{c = Switch[measure,
					"FullCount",       BinCounts[rho, bins],
					"WithoutBoundary", BinCounts[MapThread[Max, {rho, Max[rho[[#]]] & /@ adj}], bins],
					"HalfBoundary",    (BinCounts[rho, bins] + BinCounts[MapThread[Max, {rho, Max[rho[[#]]] & /@ adj}], bins]) / 2,
					"ExpandingFront",  Length /@ FindAdvancingInfraFront[g, {v}, Replace[range, {All :> 2 Max @ DeleteCases[rho, Infinity], {_, b_} :> b}]]
				]},
				{at = r |-> If[0 <= r < Length[c], c[[r + 1]], 0]},
				Switch[range, All, c, _Integer, at[range], _, at /@ Range @@ range]],
			{targets, dm[[VertexIndex[g, #] & /@ targets]]}]
	]

ShellAreas[g_Graph,
	vertex : Except[All | _Rule | _RuleDelayed],
	range : (_Integer | {_Integer, _Integer} | All),
	OptionsPattern[]
] :=
	With[{rho = GraphDistance[g, vertex]},
		{bins = {0, Max @ DeleteCases[rho, Infinity] + 1, 1}},
		{c = Switch[OptionValue["Measure"],
			"FullCount",       BinCounts[rho, bins],
			"WithoutBoundary", BinCounts[MapThread[Max, {rho, Max[rho[[#]]] & /@ AdjacencyMatrix[g]["AdjacencyLists"]}], bins],
			"HalfBoundary",    (BinCounts[rho, bins] + BinCounts[MapThread[Max, {rho, Max[rho[[#]]] & /@ AdjacencyMatrix[g]["AdjacencyLists"]}], bins]) / 2,
			"ExpandingFront",  Length /@ FindAdvancingInfraFront[g, {vertex}, Replace[range, {All :> 2 Max @ DeleteCases[rho, Infinity], {_, b_} :> b}]]
		]},
		{at = r |-> If[0 <= r < Length[c], c[[r + 1]], 0]},
		Switch[range, All, c, _Integer, at[range], _, at /@ Range @@ range]
	]


(* ===================== Cylinder volumes ===================== *)

(* CylinderVolumes[g, sources, targets, s] gives the matrix of cylinder volumes
   between every source-target pair: the cylinder from p to q is the metric
   interval I(p, q) = { w : d(p, w) + d(w, q) == d(p, q) } (the union of all
   p-q geodesics) thickened to its closed s-neighborhood, and its volume is the
   vertex count.  s defaults to 0 (the bare interval).  A scalar source gives a
   flat list ordered as targets (e.g. center -> shell -> anisotropy profile). *)

CylinderVolumes[g_Graph, source : Except[_List | _Rule | _RuleDelayed], targets_List, s_Integer : 0] :=
	First @ CylinderVolumes[g, {source}, targets, s]

CylinderVolumes[g_Graph, sources_List, targets_List, s_Integer : 0] :=
	With[{dm = GraphDistanceMatrix[g], pos = PositionIndex @ VertexList[g]},
		Outer[
			{p, q} |-> With[{pi = pos[p][[1]], qi = pos[q][[1]]},
				{dpq = dm[[pi, qi]]},
				If[dpq === Infinity, 0,
					With[{interval = Flatten @ Position[dm[[pi]] + dm[[qi]], dpq]},
						If[s == 0, Length[interval], Count[Min /@ Transpose[dm[[interval]]], x_ /; x <= s]]
					]
				]
			],
			sources, targets, 1]
	]


(* ===================== Tube volumes ===================== *)

(* T(s) = |{ w : d(w, S) <= s }|, the tube-volume profile of a vertex set S, as the List
   {T(0), ..., T(sMax)} with T(0) = |S|, saturating at the component of S.  The core S is
   any vertex list -- a geodesic segment, a cycle (capless tube), a submanifold sample;
   TubeVolumes[g, p, q] takes S = the metric interval I(p, q) (so TubeVolumes[g, p, q, s] ==
   CylinderVolumes[g, p, {q}, s]) and TubeVolumes[g, p, targets] one profile per target q
   off a single GraphDistanceMatrix, the core rows giving d(., I(p, q)) as a column-wise
   Min -- the distribution of tube volumes over a shell of p in one call.  Radius slot and
   option "Measure" as in BallVolumes, with dT_s = GraphBoundary[g, T_s].  For a geodesic
   core with direction v, Gray's tube expansion Vol T_s = omega_{n-1} s^(n-1) L
   (1 - (tau + Ric(v,v))/(6(n+1)) s^2 + O(s^4)) makes the quotient fit read the Ricci
   projection: DimensionCurvatureFit[..., "Probe" -> "Tube"]. *)

Options[TubeVolumes] = {"Measure" -> "FullCount"};

(* one BFS from a virtual vertex joined to the core -- no distance matrix *)
TubeVolumes[g_Graph, core_List, range : (_Integer | {_Integer, _Integer} | All) : All, OptionsPattern[]] /;
	! MemberQ[VertexList[g], core] :=
	With[{aux = Unique["tubeSource"], vs = VertexList[g]},
		{aug = EdgeAdd[VertexAdd[g, {aux}], UndirectedEdge[aux, #] & /@ DeleteDuplicates[core]]},
		{rho = Lookup[AssociationThread[VertexList[aug], GraphDistance[aug, aux]], Key /@ vs] - 1},
		{bins = {0, Max @ DeleteCases[rho, Infinity] + 1, 1}},
		{full = Accumulate @ BinCounts[rho, bins]},
		{c = Switch[OptionValue["Measure"],
			"FullCount",       full,
			"WithoutBoundary", Accumulate @ BinCounts[MapThread[Max, {rho, Max[rho[[#]]] & /@ AdjacencyMatrix[g]["AdjacencyLists"]}], bins],
			"HalfBoundary",    (full + Accumulate @ BinCounts[MapThread[Max, {rho, Max[rho[[#]]] & /@ AdjacencyMatrix[g]["AdjacencyLists"]}], bins]) / 2,
			"ExpandingFront",  Accumulate[Length /@ FindAdvancingInfraFront[g, DeleteDuplicates[core], Replace[range, {All :> 2 Max @ DeleteCases[rho, Infinity], {_, b_} :> b}]]]
		]},
		{at = r |-> If[0 <= r < Length[c], c[[r + 1]], Last[c]]},
		Switch[range, All, c, _Integer, at[range], _, at /@ Range @@ range]
	]

TubeVolumes[g_Graph, p_, q_, range : (_Integer | {_Integer, _Integer} | All) : All, opts : OptionsPattern[]] /;
	MemberQ[VertexList[g], p] && MemberQ[VertexList[g], q] :=
	With[{vs = VertexList[g], dp = GraphDistance[g, p], dq = GraphDistance[g, q]},
		TubeVolumes[g, Pick[vs, dp + dq, dp[[VertexIndex[g, q]]]], range, opts]
	]

TubeVolumes[g_Graph, p_, targets : (_List | All), range : (_Integer | {_Integer, _Integer} | All) : All, OptionsPattern[]] /;
	MemberQ[VertexList[g], p] && (targets === All || ! MemberQ[VertexList[g], targets]) :=
	With[
		{dm = GraphDistanceMatrix[g], adj = AdjacencyMatrix[g]["AdjacencyLists"], vs = VertexList[g], measure = OptionValue["Measure"]},
		{dp = dm[[VertexIndex[g, p]]], qis = If[targets === All, Range @ Length @ vs, VertexIndex[g, #] & /@ targets]},
		Table[
			With[{core = Flatten @ Position[dp + dm[[qi]], dp[[qi]]]},
				{rho = Min /@ Transpose[dm[[core]]]},
				{bins = {0, Max @ DeleteCases[rho, Infinity] + 1, 1}},
				{full = Accumulate @ BinCounts[rho, bins]},
				{c = Switch[measure,
					"FullCount",       full,
					"WithoutBoundary", Accumulate @ BinCounts[MapThread[Max, {rho, Max[rho[[#]]] & /@ adj}], bins],
					"HalfBoundary",    (full + Accumulate @ BinCounts[MapThread[Max, {rho, Max[rho[[#]]] & /@ adj}], bins]) / 2,
					"ExpandingFront",  Accumulate[Length /@ FindAdvancingInfraFront[g, vs[[core]], Replace[range, {All :> 2 Max @ DeleteCases[rho, Infinity], {_, b_} :> b}]]]
				]},
				{at = r |-> If[0 <= r < Length[c], c[[r + 1]], Last[c]]},
				Switch[range, All, c, _Integer, at[range], _, at /@ Range @@ range]],
			{qi, qis}]
	]


(* ===================== Interval volumes ===================== *)

(* |I(p, q; r)| for the interval at slack r, I(p, q; r) = { x : d(p, x) + d(x, q) <= d(p, q) + r }
   (the two-focus ellipsoid; I(p, q; 0) is the metric interval), as the List {I(0), ..., I(rMax)}
   indexed by slack.  Two rows of the distance matrix per pair, so IntervalVolumes[g, p, targets]
   gives a shell's worth of profiles in one call.  T(p, q; r) is a subset of I(p, q; 2r) on every
   graph, with equality for all p, q, r exactly on modular graphs: only there are the tube and the
   interval the same observable.  Option "Measure": "FullCount" | "WithoutBoundary" | "HalfBoundary"
   with dI = GraphBoundary[g, I]; slack is not a radius, so there is no front. *)

Options[IntervalVolumes] = {"Measure" -> "FullCount"};

IntervalVolumes[g_Graph, p_, q_, range : (_Integer | {_Integer, _Integer} | All) : All, OptionsPattern[]] /;
	MemberQ[VertexList[g], p] && MemberQ[VertexList[g], q] :=
	With[{dp = GraphDistance[g, p], dq = GraphDistance[g, q]},
		{rho = dp + dq - dp[[VertexIndex[g, q]]]},
		{bins = {0, Max @ DeleteCases[rho, Infinity] + 1, 1}},
		{full = Accumulate @ BinCounts[rho, bins]},
		{c = Switch[OptionValue["Measure"],
			"FullCount",       full,
			"WithoutBoundary", Accumulate @ BinCounts[MapThread[Max, {rho, Max[rho[[#]]] & /@ AdjacencyMatrix[g]["AdjacencyLists"]}], bins],
			"HalfBoundary",    (full + Accumulate @ BinCounts[MapThread[Max, {rho, Max[rho[[#]]] & /@ AdjacencyMatrix[g]["AdjacencyLists"]}], bins]) / 2
		]},
		{at = r |-> If[0 <= r < Length[c], c[[r + 1]], Last[c]]},
		Switch[range, All, c, _Integer, at[range], _, at /@ Range @@ range]
	]

IntervalVolumes[g_Graph, p_, targets : (_List | All), range : (_Integer | {_Integer, _Integer} | All) : All, OptionsPattern[]] /;
	MemberQ[VertexList[g], p] && (targets === All || ! MemberQ[VertexList[g], targets]) :=
	With[
		{dm = GraphDistanceMatrix[g], adj = AdjacencyMatrix[g]["AdjacencyLists"], measure = OptionValue["Measure"]},
		{dp = dm[[VertexIndex[g, p]]], qis = If[targets === All, Range @ Length @ dm, VertexIndex[g, #] & /@ targets]},
		Table[
			With[{rho = dp + dm[[qi]] - dp[[qi]]},
				{bins = {0, Max @ DeleteCases[rho, Infinity] + 1, 1}},
				{full = Accumulate @ BinCounts[rho, bins]},
				{c = Switch[measure,
					"FullCount",       full,
					"WithoutBoundary", Accumulate @ BinCounts[MapThread[Max, {rho, Max[rho[[#]]] & /@ adj}], bins],
					"HalfBoundary",    (full + Accumulate @ BinCounts[MapThread[Max, {rho, Max[rho[[#]]] & /@ adj}], bins]) / 2
				]},
				{at = r |-> If[0 <= r < Length[c], c[[r + 1]], Last[c]]},
				Switch[range, All, c, _Integer, at[range], _, at /@ Range @@ range]],
			{qi, qis}]
	]


(* ===================== SegmentGraph ===================== *)

(* SegmentGraph[g, u, v]: the metric interval I(u, v) as a directed
   acyclic graph -- vertices { w : d(u, w) + d(w, v) == d(u, v) } (= the
   CylinderVolumes support, the union of all u-v geodesics), edges w -> x for
   adjacent w, x in the interval with d(u, x) == d(u, w) + 1.  Directed paths
   u -> v are exactly the u-v geodesics.  Built from two distance fields, never
   enumerating paths, so it is polynomial even when the geodesic count is not. *)

SegmentGraph[g_Graph, u_, v_] :=
	Module[{du = AssociationThread[VertexList[g], GraphDistance[g, u]],
			dv = AssociationThread[VertexList[g], GraphDistance[g, v]], duv, interval, inSet},
		duv = du[v];
		If[duv === Infinity, Graph[{}, {}],
			interval = Select[VertexList[g], du[#] + dv[#] == duv &];
			inSet = AssociationThread[interval, True];
			Graph[interval,
				Catenate @ Map[
					w |-> DirectedEdge[w, #] & /@ Select[AdjacencyList[g, w], TrueQ[inSet[#]] && du[#] == du[w] + 1 &],
					interval
				]
			]
		]
	]


(* ===================== Geodesic occupation ===================== *)

(* GeodesicOccupation[dag]: the per-vertex geodesic occupation c(w) =
   sigma_in(w) * sigma_out(w) over a geodesic DAG, where sigma_in(w) is the
   number of source -> w directed paths and sigma_out(w) the number of w -> sink
   paths (the Brandes shortest-path-count decomposition).  c(w) is the number of
   maximal directed paths through w; the family size M = Max c (attained at the
   endpoints).  Two topological-order DP sweeps, never enumerating the paths.
   GeodesicOccupation[g, u, v] builds the u-v geodesic DAG first. *)

(* Key[] wraps every vertex lookup: a list-valued vertex label (a {i, j} grid
   or tessellation label) would otherwise be read by Lookup / assoc[...] as a
   LIST OF KEYS, silently returning Missing instead of the count. *)
GeodesicOccupation[dag_Graph] :=
	Module[{order = TopologicalSort[dag],
			inNbr = GroupBy[EdgeList[dag], Last -> First],
			outNbr = GroupBy[EdgeList[dag], First -> Last], sigmaIn, sigmaOut},
		sigmaIn = Fold[
			{acc, w} |-> Append[acc, w -> With[{p = Lookup[inNbr, Key[w], {}]}, If[p === {}, 1, Total[Lookup[acc, Key /@ p]]]]],
			<||>, order];
		sigmaOut = Fold[
			{acc, w} |-> Append[acc, w -> With[{q = Lookup[outNbr, Key[w], {}]}, If[q === {}, 1, Total[Lookup[acc, Key /@ q]]]]],
			<||>, Reverse[order]];
		AssociationMap[Lookup[sigmaIn, Key[#]] Lookup[sigmaOut, Key[#]] &, VertexList[dag]]
	]

GeodesicOccupation[g_Graph, u_, v_] := GeodesicOccupation[SegmentGraph[g, u, v]]


(* GeodesicEdgeOccupation[dag]: the per-edge geodesic occupation
   c(u -> v) = sigma_in(u) * sigma_out(v) over a geodesic DAG -- the number of
   maximal directed paths through the edge, keyed by the DAG's DirectedEdges;
   the edge companion of GeodesicOccupation, same two topological-order DP
   sweeps, never enumerating the paths.  GeodesicEdgeOccupation[g, u, v]
   builds the u-v geodesic DAG first. *)

GeodesicEdgeOccupation[dag_Graph] :=
	Module[{order = TopologicalSort[dag],
			inNbr = GroupBy[EdgeList[dag], Last -> First],
			outNbr = GroupBy[EdgeList[dag], First -> Last], sigmaIn, sigmaOut},
		sigmaIn = Fold[
			{acc, w} |-> Append[acc, w -> With[{p = Lookup[inNbr, Key[w], {}]}, If[p === {}, 1, Total[Lookup[acc, Key /@ p]]]]],
			<||>, order];
		sigmaOut = Fold[
			{acc, w} |-> Append[acc, w -> With[{q = Lookup[outNbr, Key[w], {}]}, If[q === {}, 1, Total[Lookup[acc, Key /@ q]]]]],
			<||>, Reverse[order]];
		Association[(# -> Lookup[sigmaIn, Key[First[#]]] Lookup[sigmaOut, Key[Last[#]]]) & /@ EdgeList[dag]]
	]

GeodesicEdgeOccupation[g_Graph, u_, v_] := GeodesicEdgeOccupation[SegmentGraph[g, u, v]]


(* ===================== Log-difference quotients ===================== *)

(* q(r) = (Log w(r) - Log w(r-1)) / (Log(r+1) - Log r): the discrete d Log w / d Log r
   of any sequence w = {w(0), w(1), ...} against the log index, the log-log slope at
   each step.  Log[Ratios[Range[n]], Ratios[w]] == ResourceFunction["LogDifferences"][w].
   For a ball-volume sequence this is the volume-growth dimension estimator SW's
   dimension chapters plot.  Accepts any numeric -- or Around -- sequence: feed it
   BallVolumes[g, v], or aggregate first and let the spread propagate, e.g.
   LogDifferenceQuotients[MeanAround /@ Transpose[BallVolumes[g, subset, {0, R}]]]. *)
LogDifferenceQuotients[w_List] := Log[Ratios[Range[Length[w]]], Ratios[N[w]]]


(* ===================== Volume-growth observables ===================== *)

(* The growth observables at a vertex -- raw profiles and the fitted dimension / scalar
   curvature -- from the Bishop-Gromov regression of the log-difference quotient q(r) on
   x = r (r+1) (the squared geometric-mean radius), for BOTH growth probes:
     Ball volume V(r):  q -> d - R/(3(d+2)) x   (intercept d, R = -3(d+2) slope);
     Sphere area A(r) = V(r) - V(r-1) of the "FullCount" profile, the shell count
                        (Gray: Area(S_r) = sigma_{n-1} r^(n-1)(1 - S/(6 n) r^2)):
                        q -> (n-1) - S/(3 n) x  (intercept n-1, manifold n = intercept+1, S = -3 n slope).
   Returns the flat association
     <|"BallVolumes", "ShellAreas", "BallLogDifferenceQuotients", "SphereLogDifferenceQuotients",
       "BallDimension", "SphereDimension", "BallScalarCurvature", "SphereScalarCurvature",
       "BallCurvatureByRadius", "SphereCurvatureByRadius", "SphereMeanCurvatureByRadius",
       "BallWindow", "SphereWindow"|>,
   where "BallVolumes"/"ShellAreas" are the raw growth profiles, "...LogDifferenceQuotients"
   their log-log slope sequences, the "...Dimension"/"...ScalarCurvature" are the single regressed parameters,
   "...CurvatureByRadius" the per-radius comparison profile (ball R(v,r) = 6(d+2)/r^2
   (1 - V(r)/V_E(d,r)); sphere S(v,r) = 6 n/r^2 (1 - A(r)/A_E(n,r))), and
   "SphereMeanCurvatureByRadius" the discrete geodesic-sphere mean curvature d Log A/dr
   (Raychaudhuri expansion theta).  The two probes give independent (n, S) readouts --
   their agreement is the consistency check.  "BallWindow"/"SphereWindow" are the radius
   windows the two fits used (they differ under Automatic: the sphere window is capped at
   the rising part of A(r) since it is non-monotonic on a finite graph).
   Window slot 3: {rmin, rmax}, All, or Automatic (default), the linear core of the (x, q)
   scatter -- the longest radius window whose least-squares residual stays within twice the
   noise floor.  "Dimension" -> d_Integer pins the intercept; "Measure" is the BallVolumes
   measure the ball probe runs on, default "HalfBoundary" -- the radius convention under
   which a flat lattice's ball volume is the norm-ball volume with no r^(d-1) term; the
   "BallVolumes" key exposes exactly the profile that was fitted.  Vertex slot 2 (single,
   list, or All). *)

Options[VolumeGrowthObservables] = {"Measure" -> "HalfBoundary", "Dimension" -> Automatic};

VolumeGrowthObservables[g_Graph, opts : OptionsPattern[]] :=
	VolumeGrowthObservables[g, All, Automatic, opts]

VolumeGrowthObservables[g_Graph,
	vertices : Except[_Rule | _RuleDelayed],
	window : ({_Integer, _Integer} | All | Automatic) : Automatic,
	OptionsPattern[]
] :=
	With[
		{listed = vertices === All || ListQ[vertices] && ! MemberQ[VertexList[g], vertices],
		 dimOpt = OptionValue["Dimension"],
		 (* q(r) = (Log f(r) - Log f(r-1)) / (Log r - Log(r-1)) on [r, r+1]: the radius-consistent log-log slope, not the index-based LogDifferenceQuotients *)
		 radialQuotients = f |-> Table[(Log[N @ f[[r + 2]]] - Log[N @ f[[r + 1]]]) / (Log[r + 1.] - Log[r]), {r, 1, Length[f] - 2}]},
		(* the quotients q are indexed by radius 1, 2, ...; the Automatic window searches every interval, prefix sums making each residual O(1) *)
		{windowedFit = {q, probe} |-> With[
			{r = Range[Length[q]], x = N[Range[Length[q]] (Range[Length[q]] + 1)]},
			{sel = Which[
				window === All, r,
				ListQ[window], Select[r, window[[1]] <= # <= window[[2]] &],
				Length[q] < 5, r,
				True, Range @@ With[
					{qc = Replace[q, Around[m_, _] :> m, {1}], k = Length[q], k0 = 5},
					{sx = Prepend[Accumulate[x], 0.], sxx = Prepend[Accumulate[x^2], 0.],
					 sq = Prepend[Accumulate[qc], 0.], sqq = Prepend[Accumulate[qc^2], 0.],
					 sxq = Prepend[Accumulate[x qc], 0.]},
					{rse = {i, j} |-> With[
						{m = N[j - i + 1],
						 ax = sx[[j + 1]] - sx[[i]], axx = sxx[[j + 1]] - sxx[[i]],
						 aq = sq[[j + 1]] - sq[[i]], aqq = sqq[[j + 1]] - sqq[[i]],
						 axq = sxq[[j + 1]] - sxq[[i]]},
						{b = (m axq - ax aq) / (m axx - ax^2)},
						Sqrt[Max[aqq - (aq - b ax) aq / m - b axq, 0.] / (m - 2)]
					]},
					{tol = Max[2 Quantile[Table[rse[i, i + k0 - 1], {i, 1, k - k0 + 1}], 1/4], 1.*^-10]},
					SelectFirst[
						Catenate @ Table[{i, i + len - 1}, {len, k, k0, -1}, {i, 1, k - len + 1}],
						p |-> rse[p[[1]], p[[2]]] <= tol,
						{1, k}
					]
				]
			]},
			Append[
				DimensionCurvatureFit[Transpose[{r[[sel]], q[[sel]]}], "Probe" -> probe, "Dimension" -> dimOpt],
				"Window" -> MinMax[r[[sel]]]
			]
		]},
		{fits = MapThread[
			(* A(r) is non-monotonic on a finite graph, peaking where the ball meets the rim or wraps around, so an Automatic window fits only the radii up to the peak *)
			{w, a} |-> With[
				{peak = If[window === Automatic, First @ Ordering[a, -1], Length[a]]},
				{qBall = radialQuotients[w], ballFit = windowedFit[radialQuotients[Take[w, UpTo[peak]]], "Ball"], qSph = radialQuotients[Take[a, peak]]},
				{sphFit = windowedFit[qSph, "Sphere"]},
				{bd = ballFit["Dimension"], sd = sphFit["Dimension"]},
				<|
					"BallVolumes" -> w,
					"ShellAreas" -> a,
					"BallLogDifferenceQuotients" -> qBall,
					"SphereLogDifferenceQuotients" -> radialQuotients[a],
					"BallDimension" -> bd,
					"SphereDimension" -> sd,
					"BallScalarCurvature" -> ballFit["ScalarCurvature"],
					"SphereScalarCurvature" -> sphFit["ScalarCurvature"],
					"BallCurvatureByRadius" ->
						Table[N[6 (bd + 2) / r^2 (1 - w[[r + 1]] Gamma[bd / 2 + 1] / (Pi^(bd / 2) r^bd))], {r, 1, Length[w] - 1}],
					"SphereCurvatureByRadius" ->
						Table[N[6 sd / r^2 (1 - a[[r + 1]] Gamma[sd / 2 + 1] / (sd Pi^(sd / 2) r^(sd - 1)))], {r, 1, Length[a] - 1}],
					"SphereMeanCurvatureByRadius" -> Differences[Log[N[a]]],
					"BallWindow" -> ballFit["Window"],
					"SphereWindow" -> sphFit["Window"]
				|>
			],
			If[listed,
				{BallVolumes[g, vertices, All, "Measure" -> OptionValue["Measure"]], ShellAreas[g, vertices, All]},
				{{BallVolumes[g, vertices, All, "Measure" -> OptionValue["Measure"]]}, {ShellAreas[g, vertices, All]}}]]},
		If[listed, fits, First @ fits]
	]

(* DimensionCurvatureFit[{{r, q(r)}, ...}]: fit dimension d and scalar curvature R to log-difference
   quotients q(r) (each the discrete d Log f / d Log r at radius r) by Bishop-Gromov regression on
   x = r (r+1) -- the squared geometric-mean radius Sqrt[r(r+1)] at which a finite difference quotient
   lives.  DimensionCurvatureFit[{q(0), q(1), ...}] takes a bare quotient list at radii 0, 1, 2, ....
   probe table (dimension = intercept + shift, curvature factor = intercept + offset):
     "Ball"       (V ~ r^d,      shift 0, offset 2):  R = -3(d+2) slope;
     "Sphere"     (A ~ r^(d-1),  shift 1, offset 1):  R = -3 d slope;
     "Tube"       (T ~ s^(d-1),  shift 1, offset 2):  tau + Ric(v,v) = -3(d+1) slope (Gray);
     "TubeMantle" (dT ~ s^(d-2), shift 2, offset 1):  tau + Ric(v,v) = -3(d-1) slope.
   For the tube probes "ScalarCurvature" holds the tube reading tau + Ric(v,v), the Ricci
   projection plus the scalar; subtract a same-window ball tau to isolate Ric(v,v).
   Fits every supplied point (the caller windows by slicing the quotients); the fit uses
   closed-form normal equations (not LeastSquares) so Around-valued quotients carry their
   spread to Around dimension and curvature.  The caller supplies the quotients, so the
   convention is its choice: LogDifferenceQuotients (index-based) of a "FullCount" profile,
   the radius-consistent quotients VolumeGrowthObservables takes of a "HalfBoundary" profile, ... *)

Options[DimensionCurvatureFit] = {"Probe" -> "Ball", "Dimension" -> Automatic};

DimensionCurvatureFit[q : {Except[_List] ..}, opts : OptionsPattern[]] :=
	DimensionCurvatureFit[Transpose[{Range[0, Length[q] - 1], q}], opts]

DimensionCurvatureFit[data : {{_, _} ..}, OptionsPattern[]] := With[
	{probe = OptionValue["Probe"], dimOpt = OptionValue["Dimension"]},
	{shift = Switch[probe, "Ball", 0, "Sphere" | "Tube", 1, "TubeMantle", 2],
	 offset = Switch[probe, "Ball" | "Tube", 2, "Sphere" | "TubeMantle", 1],
	 x = N[data[[All, 1]] (data[[All, 1]] + 1)], q = data[[All, 2]]},
	{dimScalar = If[dimOpt === Automatic,
		With[{m = Length[x], sx = Total[x], sxx = Total[x^2], sq = Total[q], sxq = Total[x q]},
			{den = m sxx - sx^2},
			{c2 = (m sxq - sx sq) / den, c1 = (sxx sq - sx sxq) / den},
			{c1 + shift, -3 (c1 + offset) c2}
		],
		With[{sx = Total[x], sxx = Total[x^2], sxq = Total[x q]},
			{slope = (sxq - (dimOpt - shift) sx) / sxx},
			{N[dimOpt], -3 (dimOpt - shift + offset) slope}
		]
	]},
	<|"Dimension" -> dimScalar[[1]], "ScalarCurvature" -> dimScalar[[2]]|>
]
