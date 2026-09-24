Package["WolframInstitute`SyntheticInfrageometry`"]


(* Metric coordinatization and covering of a graph: landmark (radar) coordinates and
   resolving sets, the resistance-matching spectral embedding, minimum ball covers,
   and the orthogonal-frame and spanning-axis searches built on them. *)

PackageScope[resistanceEmbeddingMatrix]


(* ===================== Radar coordinates & resolving sets ===================== *)

(* the distance vector (d(v, b1), ..., d(v, bk)).  An anchor is a vertex, a set, a density
   or a walk graph; "AnchorAggregation" reduces its support to one distance.  On a bare
   vertex InfraDensity gives <| v -> 1 |>, on which every aggregation is the distance itself,
   so the crisp case needs no separate rule. *)

Options[ RadarCoordinates ] = { "AnchorAggregation" -> Min };

RadarCoordinates[ g_Graph, b_List, v : Except[ _Rule | _RuleDelayed | _Association ], opts : OptionsPattern[] ] /;
  MemberQ[ VertexList[ g ], v ] :=
  With[ { agg = OptionValue[ "AnchorAggregation" ] },
    infraAnchorDistance[ g, v, #, agg ] & /@ b
  ]

(* Outer over a crisp basis stays the fast path: one GraphDistance call per (vertex, anchor) *)
RadarCoordinates[ g_Graph, b_List, opts : OptionsPattern[] ] :=
  AssociationThread[ VertexList[ g ],
    If[ FreeQ[ b, _Association | _Graph ],
      Outer[ GraphDistance[ g, #1, #2 ] &, VertexList[ g ], b, 1 ],
      RadarCoordinates[ g, b, #, opts ] & /@ VertexList[ g ]
    ]
  ]

RadarCoordinates[ g_Graph, b_List, fam_Association, opts : OptionsPattern[] ] /;
  SubsetQ[ VertexList[ g ], Keys @ fam ] :=
  If[ Length[ fam ] === 1,
    RadarCoordinates[ g, b, First @ Keys @ fam, opts ],
    RadarCoordinates[ g, b, #, opts ] & /@ Keys @ fam ]

(* b resolves g iff the radar map v |-> (d(v, b_i))_i is injective over V(g) *)
ResolvingSetQ[ g_Graph, b_List ] :=
    DuplicateFreeQ[ Outer[ GraphDistance[ g, #1, #2 ] &, VertexList[ g ], b, 1 ] ]

(* up to n resolving sets (metric bases) by ascending size; m restricts the
   candidate sizes (All, an integer max, {min, max}, or {exact}). Subsets are
   enumerated in size-then-Gosper order so the first found is smallest. *)
FindResolvingSet[g_Graph, n_Integer : 1, m_ : All] :=
    Module[{v = VertexList[g], dm = GraphDistanceMatrix[g], vc = VertexCount[g], found = {}, mask, last},
        Map[v[[#]] &,
            Catch[
                Scan[
                    k |-> (
                        mask = 2^k - 1;
                        last = BitShiftLeft[2^k - 1, vc - k];
                        While[mask <= last,
                            With[{s = Pick[Range[vc], IntegerDigits[mask, 2, vc], 1]},
                                If[DuplicateFreeQ[dm[[All, s]]],
                                    AppendTo[found, s];
                                    If[Length[found] >= n, Throw[found]]
                                ]
                            ];
                            (* Gosper's hack: next k-subset bitmask in lex order. *)
                            mask = With[{c = BitAnd[mask, -mask]}, {r = mask + c},
                                BitOr[r, Quotient[BitXor[r, mask], 4 c]]]
                        ]
                    ),
                    Replace[m, {All :> Range[vc], _Integer :> Range[m], {min_, max_} :> Range[min, max], {num_} :> {num}}]
                ];
                Throw[found]
            ]
        ]
    ]

(* metric dimension: size of a smallest resolving set *)
MetricDimension[g_Graph] := Length @ First @ FindResolvingSet[g, 1, All]

(* ===================== Resistance coordinates ===================== *)

Options[ResistanceCoordinates] = {"Rescaling" -> "ResistanceMatching", "Dimension" -> Automatic, "Origin" -> None};

(* spectral embedding Phi with ||Phi(u) - Phi(v)||^2 == EffectiveResistance(u, v)
   (Klein-Randic).  "Rescaling" -> "None" gives plain Laplacian eigenvectors,
   "Diffusion" -> t the diffusion-map embedding; "Origin" -> v recentres on v. *)
ResistanceCoordinates[g_Graph, opts : OptionsPattern[]] :=
    With[{mat = resistanceEmbeddingMatrix[g, OptionValue["Rescaling"], OptionValue["Dimension"]], origin = OptionValue["Origin"]},
        With[{originVec = If[origin === None, ConstantArray[0., Length @ First @ mat], mat[[ First @ FirstPosition[VertexList[g], origin] ]]]},
            AssociationThread[VertexList[g], # - originVec & /@ mat]
        ]
    ]

ResistanceCoordinates[g_Graph, v_, opts : OptionsPattern[]] /; MemberQ[VertexList[g], v] :=
    ResistanceCoordinates[g, opts][v]

(* the multiset query: one embedding, read at each key *)
ResistanceCoordinates[ g_Graph, fam_Association, opts : OptionsPattern[] ] /; SubsetQ[ VertexList[ g ], Keys @ fam ] :=
  With[ { all = ResistanceCoordinates[ g, opts ] }, all /@ Keys @ fam ]

(* ===================== Ball covers & domination ===================== *)

(* a minimum r-ball cover: a smallest centre set (chosen from all of V) whose radius-r balls
   cover the targets (every vertex by default, or a given subset) as a set-cover integer program.
   For a target subset the candidate centres are pruned to B_r(targets) -- a centre outside it covers
   no target, so the minimum is unchanged -- and the cover relation is read off bounded depth-r
   neighbourhoods, so the full GraphDistanceMatrix is never formed (the slow part for a small subset
   of a large graph).
   count = 1 (default) returns one cover as a centre list; n / UpTo[n] return up to n distinct
   minimum covers; All returns every one. Enumerating all minimum covers is #P-hard (the count of
   minimum set covers), so All / n>1 brute-force the size-k centre subsets and are cheap only for small g.
   Method -> "Exhaustive" (default) is the exact integer program; "Greedy" repeatedly takes the centre
   covering the most still-uncovered targets -- O(gamma) ball lookups, but NOT minimum in general (it
   over-counts even on vertex-transitive graphs: the cuboctahedron has gamma = 3 yet every greedy run
   returns 4). "Symmetric" returns the smallest Aut(g)-symmetric cover -- a minimum-size union of
   automorphism orbits whose balls cover the targets; exact when a minimum cover is orbit-shaped (a
   perfect / near-perfect code, as on vertex-transitive graphs), an upper bound otherwise, and far
   cheaper than the full program on highly symmetric graphs. "Greedy" / "Symmetric" return a single
   cover and ignore count. *)
Options[FindBallCover] = {Method -> "Exhaustive"};
FindBallCover[g_Graph, r_ : 1, targets : (_List | All) : All, count : (_Integer | All | UpTo[_Integer]) : 1, opts : OptionsPattern[]] :=
    With[
        {vs = VertexList[g]},
        {candmat = If[targets === All,
            {vs, Map[Boole[# <= r] &, GraphDistanceMatrix[g], {2}]},
            With[
                {balls = VertexList[NeighborhoodGraph[g, #, r]] & /@ targets},
                {cc = Union @@ balls},
                {ix = AssociationThread[cc, Range @ Length[cc]]},
                {cc, SparseArray[Join @@ MapIndexed[{ball, i} |-> ({First[i], ix[#]} -> 1 & /@ ball), balls], {Length[targets], Length[cc]}]}
            ]
        ]},
        {cand = candmat[[1]], mat = candmat[[2]]},
        Switch[OptionValue[Method],
            "Greedy",
            cand[[ Module[{uncov = ConstantArray[1, Length[mat]], chosen = {}},
                While[Total[uncov] > 0,
                    With[{j = First @ Ordering[uncov . mat, -1]},
                        AppendTo[chosen, j]; uncov = uncov (1 - Normal[mat[[All, j]]])]];
                chosen] ]],
            "Symmetric",
            With[
                {els = DeleteCases[GroupElements[GraphAutomorphismGroup[g]], Cycles[{}]],
                 dmat = GraphDistanceMatrix[g], n = Length[vs],
                 tIdx = If[targets === All, Range @ Length[vs], Flatten[FirstPosition[vs, #] & /@ targets]]},
                {orbits = Select[DeleteDuplicates[Sort /@ Flatten[GroupOrbits[PermutationGroup[{#}], Range[n]] & /@ els, 1]], Length[#] >= 2 &]},
                {m = Length[orbits], contain = Table[Select[Range @ Length[orbits], MemberQ[orbits[[#]], v] &], {v, n}]},
                {y = Array[\[FormalY], m], z = Array[\[FormalZ], n]},
                {sol = LinearOptimization[Total[z],
                    Join[
                        Flatten @ Table[z[[v]] >= y[[k]], {k, m}, {v, orbits[[k]]}],
                        Table[z[[v]] <= Total[y[[ contain[[v]] ]]], {v, n}],
                        Table[Total[ z[[ Flatten @ Position[dmat[[t]], d_ /; d <= r] ]] ] >= 1, {t, tIdx}],
                        Thread[0 <= Join[y, z] <= 1]
                    ],
                    Join[y, z] \[Element] Vectors[m + n, Integers]]},
                vs[[ Flatten @ Position[Round[z /. sol], 1] ]]
            ],
            _,
            With[
                {x = Array[\[FormalX], Length[cand]]},
                {one = cand[[ Flatten @ Position[Round[x /. LinearOptimization[Total[x], Join[Thread[mat . x >= 1], Thread[0 <= x <= 1]], x \[Element] Vectors[Length[cand], Integers]]], 1] ]]},
                If[count === 1, one,
                    With[{covers = Select[Subsets[cand, {Length[one]}], BallCoverQ[g, r, #, targets] &]},
                        Replace[count, {All -> covers, (n_Integer | UpTo[n_]) :> Take[covers, UpTo[n]]}]
                    ]
                ]
            ]
        ]
    ]

BallCoverQ[g_Graph, r_, s_List, targets : (_List | All) : All] :=
    With[
        {vs = VertexList[g], dm = GraphDistanceMatrix[g]},
        {pos = Flatten[FirstPosition[vs, #] & /@ s], rows = If[targets === All, dm, dm[[Flatten[FirstPosition[vs, #] & /@ targets]]]]},
        AllTrue[rows, row |-> AnyTrue[pos, j |-> row[[j]] <= r]]
    ]

(* r-domination number: size of a minimum r-ball cover (of the targets) *)
DominationNumber[g_Graph, r_ : 1, targets : (_List | All) : All] := Length @ FindBallCover[g, r, targets]

(* ===================== OrthogonalCoordinates ===================== *)

(* projects v onto each axis ai through the centre c by shortest-path distance, signed relative to the first centre-order vertex lying on the axis; a tied projection is reduced by "SelectCoordinate" *)

Options[ OrthogonalCoordinates ] = { "SelectCoordinate" -> "Centered" };

OrthogonalCoordinates[ g_Graph, c_, axes_List, v_, opts : OptionsPattern[] ] /;
    pointQ[ g, v ] :=
  With[ {
      centerVs  = infraVertexSet[ g, c ],
      axisPaths = Replace[ #, w_Graph :> First @ walkRealisations @ w ] & /@ axes,
      sel       = OptionValue[ "SelectCoordinate" ]
    },
    Map[
      axis |-> selectCoordinate[ sel,
        axisLayerIndex[ g, axis, v ] -
          First @ axisLayerIndex[ g, axis, perAxisAnchor[ axis, centerVs ] ] ],
      axisPaths ]
  ]

OrthogonalCoordinates[ g_Graph, c_, axes_List, opts : OptionsPattern[] ] :=
  Association[ # -> OrthogonalCoordinates[ g, c, axes, #, opts ] & /@ VertexList[ g ] ]


(* ===================== FindInfraOrthogonalFrame ===================== *)

(* build GeodesicSprayGraph[g, c], enumerate candidate lines via antipodal DAG-vertex pairs, then DFS the choice tree, filtering by perpendicularity at each step.
   Perpendicular at c: every vertex w of B has c's axis-index on A among w's tied closest positions on A, and symmetrically. *)

Options[ FindInfraOrthogonalFrame ] = {
  Method             -> Automatic,
  "AxisCount"        -> Automatic,
  "BranchSampleSize" -> All,
  "SelectCoordinate" -> "Centered"
};

axisLengthPattern = All | _Integer | _UpTo | { _, _ };

FindInfraOrthogonalFrame[ g_Graph, c_, axisLength : axisLengthPattern, opts : OptionsPattern[] ] /; pointQ[ g, c ] :=
  With[ { result = findOrthogonalFrameCore[ g, c, axisLength, 1, { opts } ] },
    If[ result =!= { }, wrapFrame @ First @ result, $Failed ]
  ]

FindInfraOrthogonalFrame[ g_Graph, c_, axisLength : axisLengthPattern, All, opts : OptionsPattern[] ] /; pointQ[ g, c ] :=
  wrapFrame /@ findOrthogonalFrameCore[ g, c, axisLength, All, { opts } ]

FindInfraOrthogonalFrame[ g_Graph, c_, axisLength : axisLengthPattern, UpTo[ n_Integer ], opts : OptionsPattern[] ] /; pointQ[ g, c ] :=
  wrapFrame /@ Take[ findOrthogonalFrameCore[ g, c, axisLength, n, { opts } ], UpTo[ n ] ]

FindInfraOrthogonalFrame[ g_Graph, c_, axisLength : axisLengthPattern, n_Integer, opts : OptionsPattern[] ] /; pointQ[ g, c ] :=
  With[ { result = findOrthogonalFrameCore[ g, c, axisLength, n, { opts } ] },
    If[ Length[ result ] >= n, wrapFrame /@ Take[ result, n ], $Failed ]
  ]


FindInfraOrthogonalFrame[ g_Graph, ip_Association, axisLength : axisLengthPattern, opts : OptionsPattern[] ] /; SubsetQ[ VertexList[ g ], Keys @ ip ] :=
  With[ { result = findOrthogonalFrameCore[ g, ip, axisLength, 1, { opts } ] },
    If[ result =!= { }, wrapFrame @ First @ result, $Failed ]
  ]

FindInfraOrthogonalFrame[ g_Graph, ip_Association, axisLength : axisLengthPattern, All, opts : OptionsPattern[] ] /; SubsetQ[ VertexList[ g ], Keys @ ip ] :=
  wrapFrame /@ findOrthogonalFrameCore[ g, ip, axisLength, All, { opts } ]

FindInfraOrthogonalFrame[ g_Graph, ip_Association, axisLength : axisLengthPattern, UpTo[ n_Integer ], opts : OptionsPattern[] ] /; SubsetQ[ VertexList[ g ], Keys @ ip ] :=
  wrapFrame /@ Take[ findOrthogonalFrameCore[ g, ip, axisLength, n, { opts } ], UpTo[ n ] ]

FindInfraOrthogonalFrame[ g_Graph, ip_Association, axisLength : axisLengthPattern, n_Integer, opts : OptionsPattern[] ] /; SubsetQ[ VertexList[ g ], Keys @ ip ] :=
  With[ { result = findOrthogonalFrameCore[ g, ip, axisLength, n, { opts } ] },
    If[ Length[ result ] >= n, wrapFrame /@ Take[ result, n ], $Failed ]
  ]


(* ===================== FindInfraSpanningAxes ===================== *)

(* no-center form: greedy mutually-separated longest geodesics across the whole graph *)

Options[ FindInfraSpanningAxes ] = {
  "AxisDistance"  -> "MinEndpoint",
  "MinLength"     -> Automatic,
  "MinSeparation" -> Automatic,
  "AxisThickness" -> 0,
  "RandomPick"    -> False
};

FindInfraSpanningAxes[ g_Graph, All, opts : OptionsPattern[] ] :=
  With[ { distMatrix = GraphDistanceMatrix[ g ] },
    { minLength = Replace[ OptionValue[ "MinLength" ], Automatic -> Max[ distMatrix ] ] },
    orthogonalGreedy[ g, findLongestPaths[ g, All, Max[ distMatrix ] - minLength ], { opts } ]
  ]

FindInfraSpanningAxes[ g_Graph, UpTo[ n_Integer ], opts : OptionsPattern[] ] :=
  Take[ FindInfraSpanningAxes[ g, All, opts ], UpTo[ n ] ]

FindInfraSpanningAxes[ g_Graph, n_Integer : 1, opts : OptionsPattern[] ] :=
  With[ { result = FindInfraSpanningAxes[ g, UpTo[ n ], opts ] },
    If[ Length[ result ] >= n, Take[ result, n ], $Failed ]
  ]

(* ===================== Helpers: anchor distance ===================== *)

(* one row, not two: InfraDensity already sends a bare vertex to <| v -> 1 |>, on which every aggregation is the distance itself *)

infraAnchorDistance[ g_Graph, v_, anchor_, agg_ ] :=
  agg[ GraphDistance[ g, v, # ] & /@ Keys @ InfraDensity[ g, anchor ] ]


(* ===================== Helpers: orthogonal coordinates ===================== *)

(* every 0-based layer tied at the minimum distance from v to the axis; callers reduce the list via "SelectCoordinate" *)

axisLayerIndex[ g_Graph, axis_List, v_ ] :=
  With[ { dists = GraphDistance[ g, v, # ] & /@ axis },
    Flatten @ Position[ dists, Min @ dists ] - 1
  ]

axisLayerIndex[ g_Graph, dag_Graph, v_ ] :=
  With[ { verts = VertexList[ dag ] },
    { sources = Select[ verts, VertexInDegree[ dag, # ] == 0 & ] },
    { depth = u |-> Min[ GraphDistance[ dag, #, u ] & /@ sources ] },
    { layers = Table[ Select[ verts, depth[ # ] == k & ], { k, 0, Max[ depth /@ verts ] } ],
      dists  = GraphDistance[ g, v, # ] & /@ verts },
    { proj = Pick[ verts, dists, Min @ dists ] },
    Flatten @ Table[ Position[ layers, u ][[ All, 1 ]] - 1, { u, proj } ]
  ]


selectCoordinate[ "Centered", shifted_List ] :=
  If[ MemberQ[ shifted, 0 ], 0, Round @ Median[ shifted ] ]
selectCoordinate[ All, ix_List ] := ix
selectCoordinate[ f_,   ix_List ] := f @ ix


perAxisAnchor[ axis_List, vs_List ] :=
  SelectFirst[ vs, MemberQ[ axis, # ] &, First @ vs ]

perAxisAnchor[ axis_Graph, vs_List ] :=
  SelectFirst[ vs, MemberQ[ VertexList @ axis, # ] &, First @ vs ]


(* ===================== Helpers: orthogonal-frame search ===================== *)


allHalfAxes[ dag_Graph, c_ ] :=
  Catenate[ FindPath[ dag, c, #, Infinity, All ] & /@ VertexList[ dag ] ]


(* every candidate line through c with both half-axes of depth >= minLength, paired by antipodal endpoints and deduped on the orientation-canonical sequence *)

enumerateAxes[ g_Graph, dag_Graph, c_, minLength_Integer ] :=
  With[ { dist = AssociationThread[ VertexList[ dag ], GraphDistance[ dag, c, # ] & /@ VertexList[ dag ] ],
          halvesByEnd = GroupBy[ allHalfAxes[ dag, c ], Last ] },
    { vertsAtDepth = Select[ VertexList[ dag ], dist[ # ] >= minLength & ] },
    DeleteDuplicatesBy[
      Catenate @ Map[
        pair |-> Flatten[
          Outer[
            { hPos, hNeg } |-> Join[ Reverse @ hNeg, Rest @ hPos ],
            halvesByEnd[ pair[[ 1 ]] ], halvesByEnd[ pair[[ 2 ]] ], 1 ], 1 ],
        Select[ Subsets[ vertsAtDepth, { 2 } ],
          pair |-> GraphDistance[ g, pair[[ 1 ]], pair[[ 2 ]] ] === dist[ pair[[ 1 ]] ] + dist[ pair[[ 2 ]] ] ]
      ],
      First @ Sort[ { #, Reverse @ # } ] &
    ]
  ]


(* length first, then ascending endpoint-geodesic-multiplicity so straight axes outrank L-shapes on grids, then lex-min for determinism *)

axisSortKey[ axisMult_ ][ axis_List ] :=
  { -Length[ axis ], axisMult[ axis ], Min[ axis, Reverse @ axis ] }


(* the same condition as the OrthogonalCoordinates coordinate of w being 0 *)

projectsToCenterQ[ g_Graph, axis_, c_, w_, sel_ ] :=
  selectCoordinate[ sel,
    axisLayerIndex[ g, axis, w ] - First @ axisLayerIndex[ g, axis, c ] ] === 0


restrictDagToCenter[ g_Graph, dag_Graph, axis_List, c_, sel_ ] :=
  Subgraph[ dag, Select[ VertexList[ dag ], projectsToCenterQ[ g, axis, c, #, sel ] & ] ]


canonicalFrame[ axes_List ] :=
  Sort[ First @ Sort[ { #, Reverse @ # } ] & /@ axes ]


frameSortKey[ axisMult_ ][ frame_List ] :=
  { -Length[ frame ], -Total[ Length /@ frame ],
    Total[ axisMult /@ frame ], canonicalFrame[ frame ] }


(* precomputed via GeodesicMultiplicityMatrix so the per-axis lookup is O(1) *)

axisMultiplicityFn[ g_Graph ] :=
  With[ { mMat   = Last @ GeodesicMultiplicityMatrix[ g ],
          posMap = AssociationThread[ VertexList[ g ] -> Range @ VertexCount[ g ] ] },
    axis |-> mMat[[ posMap[ First @ axis ], posMap[ Last @ axis ] ]]
  ]


recordFrameQ[ Automatic ][ len_, vAxes_ ] := vAxes === { } && len > 0
recordFrameQ[ All       ][ len_, _ ]       := len > 0
recordFrameQ[ n_Integer ][ len_, _ ]       := len === n
recordFrameQ[ UpTo[ n_ ] ][ len_, vAxes_ ] := len === n || ( vAxes === { } && len > 0 )

recurseDFSQ[ Automatic ][ _, vAxes_ ]     := vAxes =!= { }
recurseDFSQ[ All       ][ _, vAxes_ ]     := vAxes =!= { }
recurseDFSQ[ n_Integer ][ len_, vAxes_ ]  := len < n && vAxes =!= { }
recurseDFSQ[ UpTo[ n_ ] ][ len_, vAxes_ ] := len < n && vAxes =!= { }


orthogonalFrameDFS[ g_Graph, c_, fullDag_Graph, axisCountSpec_, minLength_, sampleSize_, maxFrames_, sel_, axisMult_, perpQ_ ] :=
  Module[ { frames = { }, canonForms = { }, dfs },
    dfs[ dag_, currentAxes_ ] :=
      Module[ { len, axisCands, validAxes, sortedAxes, sampledAxes, canon },
        len = Length[ currentAxes ];
        axisCands = enumerateAxes[ g, dag, c, minLength ];
        validAxes = Select[ axisCands, perpQ[ currentAxes, # ] & ];
        If[ recordFrameQ[ axisCountSpec ][ len, validAxes ],
          canon = canonicalFrame[ currentAxes ];
          If[ ! MemberQ[ canonForms, canon ],
            AppendTo[ canonForms, canon ];
            AppendTo[ frames, currentAxes ];
            If[ Length[ frames ] >= maxFrames, Throw[ Null ] ]
          ]
        ];
        If[ recurseDFSQ[ axisCountSpec ][ len, validAxes ],
          sortedAxes = SortBy[ validAxes, axisSortKey[ axisMult ] ];
          sampledAxes = If[ sampleSize === All || Length[ sortedAxes ] <= sampleSize,
            sortedAxes,
            RandomSample[ sortedAxes, sampleSize ] ];
          Scan[
            axis |-> dfs[ restrictDagToCenter[ g, dag, axis, c, sel ], Append[ currentAxes, axis ] ],
            sampledAxes ]
        ]
      ];
    Catch[ dfs[ fullDag, { } ] ];
    frames
  ]


parseAxisLengthSpec[ All ]            := { 1, Infinity }
parseAxisLengthSpec[ n_Integer ]      := { n, n }
parseAxisLengthSpec[ UpTo[ n_ ] ]     := { 1, n }
parseAxisLengthSpec[ { min_, max_ } ] := { min, max }


resolveSearchMethod[ opts_List ] :=
  Replace[ Method /. opts /. Method -> Automatic, Automatic -> "Exhaustive" ]


(* default oracle: every vertex of every previously chosen axis projects to the centre on the candidate *)

inlineFramePerpQ[ g_Graph, c_, sel_ ][ currentAxes_, cand_ ] :=
  AllTrue[ currentAxes,
    prev |-> AllTrue[ prev, w |-> projectsToCenterQ[ g, cand, c, w, sel ] ] ]


predicateFramePerpQ[ g_Graph, predOpts_List ][ currentAxes_, cand_ ] :=
  AllTrue[ currentAxes, prev |-> InfraPerpendicularQ[ g, prev, cand, Sequence @@ predOpts ] ]


resolveFramePerpQ[ g_Graph, c_, sel_, methodSpec_ ] :=
  If[ methodName @ methodSpec === "Predicate",
    predicateFramePerpQ[ g, predicateSubOpts @ propertiesSubOpts @ methodSpec ],
    inlineFramePerpQ[ g, c, sel ]
  ]


predicateSubOpts[ subOpts_List ] :=
  With[ { testVal = "Test" /. subOpts /. { "Test" -> Automatic } },
    Join[
      If[ testVal === Automatic, { }, { Method -> testVal } ],
      Cases[ subOpts, ( "Radius" | "Tolerance" | "Equality" ) -> _ ]
    ]
  ]


findOrthogonalFrameCore[ g_Graph, c_, axisLength_, count_, opts_List ] /; pointQ[ g, c ] :=
  Module[ { minLength, maxDepth, localG },
    { minLength, maxDepth } = parseAxisLengthSpec[ axisLength ];
    (* Localize: every distance the search needs lies in B(c, 2 maxDepth). *)
    localG = If[ maxDepth === Infinity, g, NeighborhoodGraph[ g, c, 2 maxDepth ] ];
    With[ { dag = GeodesicSprayGraph[ localG, c, "AxisLength" -> Replace[ maxDepth, Infinity -> All ] ],
            axisCountSpec = "AxisCount" /. opts /. "AxisCount" -> Automatic,
            methodSpec = resolveSearchMethod[ opts ],
            sel = "SelectCoordinate" /. opts /. "SelectCoordinate" -> "Centered",
            axisMult = axisMultiplicityFn[ localG ] },
      { method = methodName @ methodSpec,
        perpQ  = resolveFramePerpQ[ localG, c, sel, methodSpec ] },
      { sampleSize = If[ method === "Greedy", All,
            "BranchSampleSize" /. opts /. "BranchSampleSize" -> All ],
        maxFrames  = If[ method === "Greedy" && IntegerQ @ count, count, Infinity ] },
      { frames = orthogonalFrameDFS[ localG, c, dag, axisCountSpec, minLength, sampleSize, maxFrames, sel, axisMult, perpQ ] },
      If[ method === "Greedy", frames, SortBy[ frames, frameSortKey[ axisMult ] ] ]
    ]
  ]

findOrthogonalFrameCore[ g_Graph, fam_Association, axisLength_, count_, opts_List ] :=
  With[ { method = methodName @ resolveSearchMethod[ opts ],
          axisMult = axisMultiplicityFn[ g ] },
    { perSource = Map[ findOrthogonalFrameCore[ g, #, axisLength, All, opts ] &, Keys @ fam ] },
    { allFrames = DeleteDuplicatesBy[ Catenate @ perSource, canonicalFrame ] },
    { sortedFrames = If[ method === "Greedy", allFrames, SortBy[ allFrames, frameSortKey[ axisMult ] ] ],
      maxFrames    = If[ count === All, Infinity, count ] },
    Take[ sortedFrames, UpTo[ maxFrames ] ]
  ]


wrapFrame[ frame_List ] := geodesicGraph /@ frame


(* ===================== Helpers: longest paths / spanning axes ===================== *)

findLongestPaths[ g_Graph, n_, epsilon_ : 0 ] :=
  With[ { distMatrix = GraphDistanceMatrix[ g ], vertices = VertexList[ g ] },
    { maxDist = Max[ distMatrix ] },
    { pairs = Select[
        DeleteDuplicatesBy[ Position[ distMatrix, _?( # >= maxDist - epsilon & ) ], Sort ],
        #[[ 1 ]] =!= #[[ 2 ]] & ] },
    { numPairs = Length[ pairs ] },
    If[ numPairs == 0, { },
      With[ { counts = If[ n === All,
            ConstantArray[ All, numPairs ],
            RandomSample @ Table[ Quotient[ n, numPairs ] + Boole[ i <= Mod[ n, numPairs ] ], { i, numPairs } ] ] },
        Flatten[
          Cases[
            Transpose[ { pairs, counts } ],
            { { i_, j_ }, cnt_ /; cnt =!= 0 } :>
              FindPath[ g, vertices[[ i ]], vertices[[ j ]], { distMatrix[[ i, j ]] }, cnt ] ],
          1 ]
      ]
    ]
  ]


orthogonalGreedy[ g_Graph, paths_List, opts_List ] :=
  Module[ { axes, candidates, next, previousIndices, previousEndpoints, separation, closeAxes, scores,
            vertices = VertexList[ g ],
            distMatrix = GraphDistanceMatrix[ g ],
            distanceFunction = "AxisDistance" /. opts /. "AxisDistance" -> "MinEndpoint",
            thickness = "AxisThickness" /. opts /. "AxisThickness" -> 0,
            pick = If[ ! TrueQ[ "RandomPick" /. opts /. "RandomPick" -> False ], First, RandomChoice ] },
    If[ paths === { }, Return[ { } ] ];
    With[ { vertexIndex = AssociationThread[ vertices, Range @ Length @ vertices ],
            minSeparation = Replace[ "MinSeparation" /. opts /. "MinSeparation" -> Automatic,
              Automatic -> ( Length[ First[ paths ] ] - 1 ) / 2 ] },
      axes = { pick[ paths ] };
      previousIndices = Lookup[ vertexIndex, axes[[ 1 ]] ];
      previousEndpoints = { vertexIndex[ axes[[ 1, 1 ]] ], vertexIndex[ axes[[ 1, -1 ]] ] };
      candidates = Complement[ paths, axes ];
      While[ candidates =!= { },
        scores = Switch[ distanceFunction,
          "MinEndpoint",
            ( Min[
                distMatrix[[ vertexIndex[ #[[ 1 ]] ], previousEndpoints ]],
                distMatrix[[ vertexIndex[ #[[ -1 ]] ], previousEndpoints ]] ] & ) /@ candidates,
          "Hausdorff",
            ( p |-> HausdorffDistance[ distMatrix, Lookup[ vertexIndex, p ], previousIndices ] ) /@ candidates,
          "Separation",
            ( p |-> MinimalSeparationDistance[ distMatrix, Lookup[ vertexIndex, p ], previousIndices ] ) /@ candidates,
          _, Return[ axes ]
        ];
        separation = Max[ scores ];
        If[ separation < minSeparation, Break[ ] ];
        next = pick[ candidates[[ Flatten @ Position[ scores, separation ] ]] ];
        closeAxes = If[ thickness == 0, { next },
          Select[ candidates,
            HausdorffDistance[ distMatrix, Lookup[ vertexIndex, # ], Lookup[ vertexIndex, next ] ] <= thickness & ] ];
        axes = Join[ axes, closeAxes ];
        previousIndices = Union[ previousIndices, Flatten[ Lookup[ vertexIndex, # ] & /@ closeAxes ] ];
        previousEndpoints = Union[ previousEndpoints,
          Flatten[ { vertexIndex[ #[[ 1 ]] ], vertexIndex[ #[[ -1 ]] ] } & /@ closeAxes ] ];
        candidates = Complement[ candidates, closeAxes ]
      ];
      axes
    ]
  ]


(* ===================== Helpers: resistance embedding ===================== *)

resistanceEmbeddingMatrix[g_Graph, rescaling_, dimSpec_] :=
    With[{es = Eigensystem[N @ Normal @ KirchhoffMatrix[g]]},
        {ord = Ordering[es[[1]]]},
        {vals = es[[1, ord]], vecs = es[[2, ord]]},
        {keep = Select[Range @ Length @ vals, vals[[#]] > 10^-10 Max[Abs @ vals, 1] &]},
        {idx = Take[keep, Replace[dimSpec, {Automatic | All :> Length[keep], UpTo[k_Integer] :> Min[k, Length[keep]], k_Integer :> Min[k, Length[keep]]}]]},
        {weights = Replace[rescaling, {"ResistanceMatching" :> 1 / Sqrt[vals[[idx]]], "None" :> ConstantArray[1, Length[idx]], ("Diffusion" -> t_) :> Exp[-t vals[[idx]]]}]},
        Transpose[weights vecs[[idx]]]
    ]
