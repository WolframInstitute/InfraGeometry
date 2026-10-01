Package["WolframInstitute`InfraGeometry`"]

(* the distance vector (d(v, b1), ..., d(v, bk)).  An anchor is a vertex, a set, a density
   or a walk graph; "AnchorAggregation" reduces its support to one distance.  On a bare
   vertex InfraDensity gives <| v -> 1 |>, on which every aggregation is the distance itself,
   so the crisp case needs no separate rule. *)

Options[ RadarCoordinates ] = { "AnchorAggregation" -> Min };

RadarCoordinates[ g_Graph, b_List, v : Except[ _Rule | _RuleDelayed | _Association ], opts : OptionsPattern[] ] /;
  MemberQ[ VertexList[ g ], v ] :=
  With[ { agg = OptionValue[ "AnchorAggregation" ] },
    ( anchor |-> agg[ GraphDistance[ g, v, # ] & /@ Keys @ InfraDensity[ g, anchor ] ] ) /@ b
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

MetricDimension[g_Graph] := Length @ First @ FindResolvingSet[g, 1, All]

Options[ResistanceCoordinates] = {"Rescaling" -> "ResistanceMatching", "Dimension" -> Automatic, "Origin" -> None};

(* spectral embedding Phi with ||Phi(u) - Phi(v)||^2 == EffectiveResistance(u, v)
   (Klein-Randic).  "Rescaling" -> "None" gives plain Laplacian eigenvectors,
   "Diffusion" -> t the diffusion-map embedding; "Origin" -> v recentres on v. *)
ResistanceCoordinates[g_Graph, opts : OptionsPattern[]] :=
    With[{es = Eigensystem[N @ Normal @ KirchhoffMatrix[g]], rescaling = OptionValue["Rescaling"], dimSpec = OptionValue["Dimension"], origin = OptionValue["Origin"]},
        {ord = Ordering[es[[1]]]},
        {vals = es[[1, ord]], vecs = es[[2, ord]]},
        {keep = Select[Range @ Length @ vals, vals[[#]] > 10^-10 Max[Abs @ vals, 1] &]},
        {idx = Take[keep, Replace[dimSpec, {Automatic | All :> Length[keep], UpTo[k_Integer] :> Min[k, Length[keep]], k_Integer :> Min[k, Length[keep]]}]]},
        {weights = Replace[rescaling, {"ResistanceMatching" :> 1 / Sqrt[vals[[idx]]], "None" :> ConstantArray[1, Length[idx]], ("Diffusion" -> t_) :> Exp[-t vals[[idx]]]}]},
        {mat = Transpose[weights vecs[[idx]]]},
        {originVec = If[origin === None, ConstantArray[0., Length @ First @ mat], mat[[ First @ FirstPosition[VertexList[g], origin] ]]]},
        AssociationThread[VertexList[g], # - originVec & /@ mat]
    ]

ResistanceCoordinates[g_Graph, v_, opts : OptionsPattern[]] /; MemberQ[VertexList[g], v] :=
    ResistanceCoordinates[g, opts][v]

ResistanceCoordinates[ g_Graph, fam_Association, opts : OptionsPattern[] ] /; SubsetQ[ VertexList[ g ], Keys @ fam ] :=
  With[ { all = ResistanceCoordinates[ g, opts ] }, all /@ Keys @ fam ]

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

DominationNumber[g_Graph, r_ : 1, targets : (_List | All) : All] := Length @ FindBallCover[g, r, targets]

Options[ OrthogonalCoordinates ] = { "SelectCoordinate" -> "Centered" };

OrthogonalCoordinates[ g_Graph, c_, axes_List, v_, opts : OptionsPattern[] ] /;
    VertexQ[ g, v ] :=
  With[ {
      centerVs  = Keys @ InfraDensity[ g, c ],
      axisPaths = Replace[ #, w_Graph :> With[ { vs = VertexList @ w },
        { spelled = AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
          scan = u |-> Reap[ DepthFirstScan[ w, u, { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] },
        Which[
          ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w,
            If[ First @ # === Last @ #, #, Append[ #, First @ # ] ] & @
              If[ spelled, Last /@ SortBy[ vs, First ], scan @ First @ vs ],
          spelled,            Last /@ SortBy[ vs, First ],
          EdgeCount @ w == 0, If[ DirectedGraphQ @ w, Take[ vs, 1 ], vs ],
          DirectedGraphQ @ w,
            First @ Catenate @ Catenate @ Table[ FindPath[ w, s, t, Infinity, All ],
              { s, Select[ vs, VertexInDegree[ w, # ] == 0 & ] }, { t, Select[ vs, VertexOutDegree[ w, # ] == 0 & ] } ],
          True, scan @ SelectFirst[ vs, VertexDegree[ w, # ] == 1 &, First @ vs ] ] ] ] & /@ axes,
      sel       = OptionValue[ "SelectCoordinate" ],
      layerIndex = { axis, u } |-> With[ { dists = GraphDistance[ g, u, # ] & /@ axis }, Flatten @ Position[ dists, Min @ dists ] - 1 ]
    },
    Map[
      axis |-> With[ { ix = layerIndex[ axis, v ] - First @ layerIndex[ axis, SelectFirst[ centerVs, MemberQ[ axis, # ] &, First @ centerVs ] ] },
        Switch[ sel, "Centered", If[ MemberQ[ ix, 0 ], 0, Round @ Median[ ix ] ], All, ix, _, sel @ ix ] ],
      axisPaths ]
  ]

OrthogonalCoordinates[ g_Graph, c_, axes_List, opts : OptionsPattern[] ] :=
  Association[ # -> OrthogonalCoordinates[ g, c, axes, #, opts ] & /@ VertexList[ g ] ]

Options[ FindInfraOrthogonalFrame ] = {
  Method             -> Automatic,
  "AxisCount"        -> Automatic,
  "BranchSampleSize" -> All,
  "SelectCoordinate" -> "Centered"
};

FindInfraOrthogonalFrame[ g_Graph, c_, axisLength : ( All | _Integer | _UpTo | { _, _ } ),
    count : ( All | UpTo[ _Integer ] | _Integer ) : Automatic, opts : OptionsPattern[] ] /; VertexQ[ g, c ] :=
  Module[ { frames = { }, canonForms = { }, layerIndex, centredQ, canonical, axisMult, axisKey, frameKey, enumerate, perpQ,
            recordQ, recurseQ, dfs },
    With[
      { lengths = Replace[ axisLength, { All -> { 1, Infinity }, k_Integer :> { k, k }, UpTo[ k_ ] :> { 1, k } } ] },
      { minLength = First @ lengths, maxDepth = Last @ lengths },
      { localG = If[ maxDepth === Infinity, g, NeighborhoodGraph[ g, c, 2 maxDepth ] ] },
      { spray = SprayGraph[ localG, c, "AxisLength" -> Replace[ maxDepth, Infinity -> All ] ],
        axisCountSpec = "AxisCount" /. { opts } /. "AxisCount" -> Automatic,
        methodSpec = Replace[ Method /. { opts } /. Method -> Automatic, Automatic -> "Exhaustive" ],
        sel = "SelectCoordinate" /. { opts } /. "SelectCoordinate" -> "Centered",
        limit = Replace[ count, { Automatic -> 1, UpTo[ k_ ] :> k } ] },
      { method = Replace[ methodSpec, { m_String, ___ } :> m ] },
      { sampleSize = If[ method === "Greedy", All,
            "BranchSampleSize" /. { opts } /. "BranchSampleSize" -> All ],
        maxFrames  = If[ method === "Greedy" && IntegerQ @ limit, limit, Infinity ] },
      layerIndex = { axis, u } |-> With[ { dists = GraphDistance[ localG, u, # ] & /@ axis }, Flatten @ Position[ dists, Min @ dists ] - 1 ];
      centredQ = { axis, w } |-> With[ { ix = layerIndex[ axis, w ] - First @ layerIndex[ axis, c ] },
        Switch[ sel, "Centered", If[ MemberQ[ ix, 0 ], 0, Round @ Median[ ix ] ], All, ix, _, sel @ ix ] === 0 ];
      canonical = axes |-> Sort[ First @ Sort[ { #, Reverse @ # } ] & /@ axes ];
      axisMult = With[ { mMat = Last @ GeodesicMultiplicityMatrix[ localG ],
                         posMap = AssociationThread[ VertexList[ localG ] -> Range @ VertexCount[ localG ] ] },
        axis |-> mMat[[ posMap[ First @ axis ], posMap[ Last @ axis ] ]] ];
      axisKey = axis |-> { -Length[ axis ], axisMult[ axis ], Min[ axis, Reverse @ axis ] };
      frameKey = frame |-> { -Length[ frame ], -Total[ Length /@ frame ], Total[ axisMult /@ frame ], canonical[ frame ] };
      (* every candidate line through c with both half-axes of depth >= minLength, paired by antipodal endpoints and deduped on the orientation-canonical sequence *)
      enumerate = dag |-> With[
        { dist = AssociationThread[ VertexList[ dag ], GraphDistance[ dag, c, # ] & /@ VertexList[ dag ] ],
          halvesByEnd = GroupBy[ Catenate[ FindPath[ dag, c, #, Infinity, All ] & /@ VertexList[ dag ] ], Last ] },
        { vertsAtDepth = Select[ VertexList[ dag ], dist[ # ] >= minLength & ] },
        DeleteDuplicatesBy[
          Catenate @ Map[
            pair |-> Flatten[
              Outer[
                { hPos, hNeg } |-> Join[ Reverse @ hNeg, Rest @ hPos ],
                halvesByEnd[ pair[[ 1 ]] ], halvesByEnd[ pair[[ 2 ]] ], 1 ], 1 ],
            Select[ Subsets[ vertsAtDepth, { 2 } ],
              pair |-> GraphDistance[ localG, pair[[ 1 ]], pair[[ 2 ]] ] === dist[ pair[[ 1 ]] ] + dist[ pair[[ 2 ]] ] ]
          ],
          First @ Sort[ { #, Reverse @ # } ] & ] ];
      perpQ = If[ method === "Predicate",
        With[ { subOpts = Replace[ methodSpec, { { _String, o___ } :> { o }, _ -> { } } ] },
          { testVal = "Test" /. subOpts /. { "Test" -> Automatic } },
          { predOpts = Join[
              If[ testVal === Automatic, { }, { Method -> testVal } ],
              Cases[ subOpts, ( "Radius" | "Tolerance" | "Equality" ) -> _ ] ] },
          { chosen, cand } |-> AllTrue[ chosen, prev |-> InfraPerpendicularQ[ localG, prev, cand, Sequence @@ predOpts ] ] ],
        { chosen, cand } |-> AllTrue[ chosen, prev |-> AllTrue[ prev, w |-> centredQ[ cand, w ] ] ] ];
      recordQ = { len, vAxes } |-> Switch[ axisCountSpec,
        Automatic, vAxes === { } && len > 0,
        All,       len > 0,
        _Integer,  len === axisCountSpec,
        _UpTo,     len === First @ axisCountSpec || ( vAxes === { } && len > 0 ) ];
      recurseQ = { len, vAxes } |-> Switch[ axisCountSpec,
        Automatic | All,  vAxes =!= { },
        _Integer,         len < axisCountSpec && vAxes =!= { },
        _UpTo,            len < First @ axisCountSpec && vAxes =!= { } ];
      dfs[ sub_, currentAxes_ ] :=
        With[ { len = Length[ currentAxes ], validAxes = Select[ enumerate[ sub ], perpQ[ currentAxes, # ] & ] },
          If[ recordQ[ len, validAxes ] && ! MemberQ[ canonForms, canonical[ currentAxes ] ],
            AppendTo[ canonForms, canonical[ currentAxes ] ];
            AppendTo[ frames, currentAxes ];
            If[ Length[ frames ] >= maxFrames, Throw[ Null ] ]
          ];
          If[ recurseQ[ len, validAxes ],
            Scan[
              axis |-> dfs[ Subgraph[ sub, Select[ VertexList[ sub ], centredQ[ axis, # ] & ] ], Append[ currentAxes, axis ] ],
              If[ sampleSize === All || Length[ validAxes ] <= sampleSize,
                SortBy[ validAxes, axisKey ],
                RandomSample[ SortBy[ validAxes, axisKey ], sampleSize ] ] ]
          ]
        ];
      Catch[ dfs[ spray, { } ] ];
      frames = If[ method === "Greedy", frames, SortBy[ frames, frameKey ] ];
      Switch[ count,
        Automatic, If[ frames =!= { }, PathGraph[ #, DirectedEdges -> True ] & /@ First @ frames, $Failed ],
        All,       Map[ PathGraph[ #, DirectedEdges -> True ] &, frames, { 2 } ],
        _UpTo,     Map[ PathGraph[ #, DirectedEdges -> True ] &, Take[ frames, count ], { 2 } ],
        _,         If[ Length[ frames ] >= count, Map[ PathGraph[ #, DirectedEdges -> True ] &, Take[ frames, count ], { 2 } ], $Failed ] ]
    ]
  ]

FindInfraOrthogonalFrame[ g_Graph, ip_Association, axisLength : ( All | _Integer | _UpTo | { _, _ } ),
    count : ( All | UpTo[ _Integer ] | _Integer ) : Automatic, opts : OptionsPattern[] ] /; SubsetQ[ VertexList[ g ], Keys @ ip ] :=
  With[
    { method = Replace[ Replace[ Method /. { opts } /. Method -> Automatic, Automatic -> "Exhaustive" ], { m_String, ___ } :> m ],
      limit = Replace[ count, { Automatic -> 1, UpTo[ k_ ] :> k } ],
      canonical = axes |-> Sort[ First @ Sort[ { #, Reverse @ # } ] & /@ axes ],
      axisMult = With[ { mMat = Last @ GeodesicMultiplicityMatrix[ g ],
                         posMap = AssociationThread[ VertexList[ g ] -> Range @ VertexCount[ g ] ] },
        axis |-> mMat[[ posMap[ First @ axis ], posMap[ Last @ axis ] ]] ] },
    { allFrames = DeleteDuplicatesBy[
        Catenate @ Map[ Map[ VertexList, FindInfraOrthogonalFrame[ g, #, axisLength, All, opts ], { 2 } ] &, Keys @ ip ],
        canonical ] },
    { frames = Take[
        If[ method === "Greedy", allFrames,
          SortBy[ allFrames, frame |-> { -Length[ frame ], -Total[ Length /@ frame ], Total[ axisMult /@ frame ], canonical[ frame ] } ] ],
        UpTo[ If[ limit === All, Infinity, limit ] ] ] },
    Switch[ count,
      Automatic, If[ frames =!= { }, PathGraph[ #, DirectedEdges -> True ] & /@ First @ frames, $Failed ],
      All,       Map[ PathGraph[ #, DirectedEdges -> True ] &, frames, { 2 } ],
      _UpTo,     Map[ PathGraph[ #, DirectedEdges -> True ] &, Take[ frames, count ], { 2 } ],
      _,         If[ Length[ frames ] >= count, Map[ PathGraph[ #, DirectedEdges -> True ] &, Take[ frames, count ], { 2 } ], $Failed ] ]
  ]

Options[ FindInfraSpanningAxes ] = {
  "AxisDistance"  -> "MinEndpoint",
  "MinLength"     -> Automatic,
  "MinSeparation" -> Automatic,
  "AxisThickness" -> 0,
  "RandomPick"    -> False
};

FindInfraSpanningAxes[ g_Graph, All, opts : OptionsPattern[] ] :=
  Module[ { axes, candidates, next, previousIndices, previousEndpoints, separation, closeAxes, scores },
    With[ { vertices = VertexList[ g ], distMatrix = GraphDistanceMatrix[ g ] },
      { maxDist = Max[ distMatrix ] },
      { epsilon = maxDist - Replace[ OptionValue[ "MinLength" ], Automatic -> maxDist ] },
      { paths = Flatten[
          FindPath[ g, vertices[[ #[[ 1 ]] ]], vertices[[ #[[ 2 ]] ]], { distMatrix[[ #[[ 1 ]], #[[ 2 ]] ]] }, All ] & /@ Select[
            DeleteDuplicatesBy[ Position[ distMatrix, _?( # >= maxDist - epsilon & ) ], Sort ],
            #[[ 1 ]] =!= #[[ 2 ]] & ],
          1 ],
        distanceFunction = "AxisDistance" /. { opts } /. "AxisDistance" -> "MinEndpoint",
        thickness = "AxisThickness" /. { opts } /. "AxisThickness" -> 0,
        pick = If[ ! TrueQ[ "RandomPick" /. { opts } /. "RandomPick" -> False ], First, RandomChoice ],
        vertexIndex = AssociationThread[ vertices, Range @ Length @ vertices ],
        hausdorff = sub |-> Max[ Max[ Min /@ sub ], Max[ Min /@ Transpose @ sub ] ] },
      { minSeparation = Replace[ "MinSeparation" /. { opts } /. "MinSeparation" -> Automatic,
          Automatic :> ( Length[ First[ paths, { } ] ] - 1 ) / 2 ] },
      If[ paths === { }, Return[ { } ] ];
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
            ( p |-> hausdorff[ distMatrix[[ Lookup[ vertexIndex, p ], previousIndices ]] ] ) /@ candidates,
          "Separation",
            ( p |-> Min[ distMatrix[[ Lookup[ vertexIndex, p ], previousIndices ]] ] ) /@ candidates,
          _, Return[ axes ]
        ];
        separation = Max[ scores ];
        If[ separation < minSeparation, Break[ ] ];
        next = pick[ candidates[[ Flatten @ Position[ scores, separation ] ]] ];
        closeAxes = If[ thickness == 0, { next },
          Select[ candidates,
            hausdorff[ distMatrix[[ Lookup[ vertexIndex, # ], Lookup[ vertexIndex, next ] ]] ] <= thickness & ] ];
        axes = Join[ axes, closeAxes ];
        previousIndices = Union[ previousIndices, Flatten[ Lookup[ vertexIndex, # ] & /@ closeAxes ] ];
        previousEndpoints = Union[ previousEndpoints,
          Flatten[ { vertexIndex[ #[[ 1 ]] ], vertexIndex[ #[[ -1 ]] ] } & /@ closeAxes ] ];
        candidates = Complement[ candidates, closeAxes ]
      ];
      axes
    ]
  ]

FindInfraSpanningAxes[ g_Graph, UpTo[ n_Integer ], opts : OptionsPattern[] ] :=
  Take[ FindInfraSpanningAxes[ g, All, opts ], UpTo[ n ] ]

FindInfraSpanningAxes[ g_Graph, n_Integer : 1, opts : OptionsPattern[] ] :=
  With[ { result = FindInfraSpanningAxes[ g, UpTo[ n ], opts ] },
    If[ Length[ result ] >= n, Take[ result, n ], $Failed ]
  ]
