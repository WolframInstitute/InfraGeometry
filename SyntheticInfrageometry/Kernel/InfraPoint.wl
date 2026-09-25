Package["WolframInstitute`SyntheticInfrageometry`"]



(* ===================== FindInfraPoint ===================== *)

(* "Distance" constrains which points: r fixes the mutual distance exactly, {dMin, dMax} a range, "Max" maximises the minimum pairwise gap, "Spread" breaks the "Max" ties toward minimal variance of the pairwise distances *)

FindInfraPoint::badfrom = "\"From\" specification `1` is not supported by FindInfraPoint. Supported: All, \"Random\", \"Center\", \"Periphery\", {\"Center\", cap}, anchor -> spec, a vertex, a vertex list, a density.";

Options[ FindInfraPoint ] = { "From" -> "Random", "Distance" -> None, "MaxCliques" -> All };

FindInfraPoint[ graph_Graph, count : ( UpTo[ _Integer ] | Automatic ) : Automatic, opts : OptionsPattern[] ] :=
  Module[ { from = OptionValue[ "From" ], dist = OptionValue[ "Distance" ], maxCl = OptionValue[ "MaxCliques" ],
            n = Replace[ count, { UpTo[ k_ ] :> k, Automatic -> 1 } ], pool, distMatrix, finiteMax, cliques },
    (* an unrecognised selector must raise ::badfrom rather than fall through to the whole vertex pool, which reads as a legitimate random draw *)
    If[ ! ( VertexQ[ graph, from ] || MatchQ[ from, All | "Random" | "Center" | "Periphery" |
          { "Center", _Integer | Infinity } | _Association | _Rule | _List ] ),
      Message[ FindInfraPoint::badfrom, from ]; Return[ $Failed ] ];
    pool = Which[
      from === "Center",    GraphCenter @ graph,
      from === "Periphery", GraphPeriphery @ graph,
      (* orbit of c |-> NeighborhoodGraph[c, GraphCenter[c]], stopping at a fixed point or when the centre-neighbourhood first disconnects *)
      MatchQ[ from, { "Center", _Integer | Infinity } ] && ConnectedGraphQ @ graph,
        With[ { final = NestWhile[ NeighborhoodGraph[ #, GraphCenter @ # ] &, graph,
                  ConnectedGraphQ[ #2 ] && VertexCount[ #1 ] != VertexCount[ #2 ] &, 2, Last @ from ] },
          If[ ConnectedGraphQ @ final, GraphCenter @ final, VertexList @ final ] ],
      MatchQ[ from, { "Center", _ } ] || StringQ @ from, VertexList @ graph,
      AssociationQ @ from,  Keys @ from,
      MatchQ[ from, _Rule ],
        With[ { anchors = Keys @ InfraDensity[ graph, First @ from ], spec = Last @ from,
                vertexIndex = AssociationThread[ VertexList @ graph -> Range @ VertexCount @ graph ] },
          { anchorDists = Association[ # -> GraphDistance[ graph, # ] & /@ anchors ] },
          Select[ VertexList @ graph, v |-> AllTrue[ anchors, a |->
            With[ { d = anchorDists[ a ][[ vertexIndex @ v ]] },
              Switch[ spec,
                _?NumericQ,                   d == spec,
                { _?NumericQ, _?NumericQ },   First @ spec <= d <= Last @ spec,
                "Max",                        d == Max @ Select[ anchorDists @ a, # < Infinity & ],
                _,                            False ] ] ] ] ],
      VertexQ[ graph, from ], { from },
      ListQ @ from,           from,
      True,                   VertexList @ graph ];
    Which[
      count === Automatic,     RandomChoice @ pool,
      n == 1 || dist === None, RandomSample[ pool, UpTo[ n ] ],
      True,
        With[ { vertexIndex = Lookup[ AssociationThread[ VertexList @ graph, Range @ VertexCount @ graph ], pool ] },
          distMatrix = GraphDistanceMatrix[ graph ][[ vertexIndex, vertexIndex ]];
          finiteMax = Max @ Select[ Flatten @ distMatrix, # < Infinity & ];
          distMatrix = Replace[ distMatrix, Infinity -> finiteMax + 1, { 2 } ];
          With[ { mask = 1 - IdentityMatrix @ Length @ vertexIndex },
            If[ dist === "Max" || dist === "Spread",
              cliques = { };
              Do[
                cliques = FindClique[
                  AdjacencyGraph[ pool, UnitStep[ distMatrix - d ] * UnitStep[ finiteMax - distMatrix ] * mask ],
                  { n, Length @ pool }, maxCl ];
                If[ cliques =!= { }, Break[ ] ],
                { d, Reverse @ DeleteCases[ Union @@ distMatrix, 0 | _?( # > finiteMax & ) ] } ];
              Which[
                cliques === { }, { },
                (* among the max-min-gap cliques, the n-subset of minimal variance of pairwise distances *)
                dist === "Spread",
                  With[ { idx = AssociationThread[ pool -> Range @ Length @ pool ],
                          subsets = DeleteDuplicates[ Sort /@ Catenate[ Subsets[ #, { n } ] & /@ cliques ] ] },
                    If[ n < 3, First @ subsets,
                      First @ MinimalBy[ subsets,
                        s |-> Variance[ distMatrix[[ idx @ #[[ 1 ]], idx @ #[[ 2 ]] ]] & /@ Subsets[ s, { 2 } ] ] ] ] ],
                True, RandomSample[ RandomChoice @ cliques, UpTo[ n ] ] ],
              With[ { range = Replace[ dist,
                      { d_?NumericQ :> { d, d },
                        { dMin_, dMax_ } :> { dMin, dMax /. Infinity -> finiteMax } } ] },
                cliques = FindClique[
                  AdjacencyGraph[ pool, UnitStep[ distMatrix - range[[ 1 ]] ] * UnitStep[ range[[ 2 ]] - distMatrix ] * mask ],
                  { Min[ n, Length @ pool ], Length @ pool }, maxCl ];
                If[ cliques === { }, { }, RandomSample[ RandomChoice @ cliques, UpTo[ n ] ] ] ] ] ] ] ] ]

FindInfraPoint[ graph_Graph, All, opts : OptionsPattern[] ] :=
  FindInfraPoint[ graph, UpTo[ VertexCount[ graph ] ], opts ]

FindInfraPoint[ graph_Graph, n_Integer, opts : OptionsPattern[] ] :=
  With[ { result = FindInfraPoint[ graph, UpTo[ n ], opts ] },
    If[ Length[ result ] < n, $Failed, result ] ]


(* ===================== FindInfraMidpoint ===================== *)

(* the vertices at the index closest to the centre index (n + 1)/2: an odd distance gives two of them, an even one a single vertex *)

Options[ FindInfraMidpoint ] = { Method -> "Metric", "Tolerance" -> 0 };

FindInfraMidpoint[ graph_Graph, x : ( _Graph | _List ), opts : OptionsPattern[] ] /; ! VertexQ[ graph, x ] :=
  With[ { method = Replace[ OptionValue[ Method ], { m_String, ___ } :> m ], tol = OptionValue[ "Tolerance" ],
          walksOf = w |-> With[ { vs = VertexList @ w },
              { spelled = AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
                scan = root |-> Reap[ DepthFirstScan[ w, root, { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] },
              Which[
                ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w,
                  { If[ First @ # === Last @ #, #, Append[ #, First @ # ] ] & @
                      If[ spelled, Last /@ SortBy[ vs, First ], scan @ First @ vs ] },
                EdgeCount @ w == 0, List /@ If[ spelled, Last /@ vs, vs ],
                spelled,            { Last /@ SortBy[ vs, First ] },
                DirectedGraphQ @ w,
                  Catenate @ Catenate @ Table[ FindPath[ w, a, b, Infinity, All ],
                    { a, Select[ vs, VertexInDegree[ w, # ] == 0 & ] }, { b, Select[ vs, VertexOutDegree[ w, # ] == 0 & ] } ],
                True, { scan @ SelectFirst[ vs, VertexDegree[ w, # ] == 1 &, First @ vs ] } ] ] },
    (* occupation of the central index band, vertex -> mass: a walk contributes 1 per band vertex, a substrate DAG -- a path graph included -- reads the band off its layers weighted by geodesic occupation, exactly as the enumerated family would; a closed or position-spelled walk graph is read as its vertex sequences *)
    { band = c |-> If[ GraphQ @ c,
        With[ { layers = If[ VertexCount[ c ] == 0, <||>,
                  AssociationThread[ VertexList[ c ],
                    GraphDistance[ c, First @ Select[ VertexList[ c ], VertexInDegree[ c, # ] == 0 & ] ] ] ] },
          If[ Length @ layers === 0, <||>,
            With[ { occ = GeodesicOccupation[ c ], len = Max[ 0, Values @ layers ] },
              { offs = Abs[ # - 1/2 * len ] & /@ layers },
              KeyTake[ occ, Keys @ Select[ offs, # <= Min[ Values @ offs ] + tol & ] ] ] ] ],
        With[ { offsets = Abs[ Range[ Length @ c ] - ( 1 + 1/2 ( Length @ c - 1 ) ) ] },
          Counts @ Pick[ c, Thread[ offsets <= Min[ offsets ] + tol ], True ] ] ],
      carriers = w |-> If[ ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w ||
          AllTrue[ VertexList @ w, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ VertexList @ w ] === Range @ VertexCount @ w,
        walksOf @ w, { w } ] },
    Switch[ method,
      "Metric",
        KeySort @ Merge[ band /@ Which[
            GraphQ @ x,               carriers @ x,
            MatchQ[ x, { __Graph } ], Catenate[ carriers /@ x ],
            x === { },                { },
            MatchQ[ x, { __List } ],  x,
            True,                     { x } ], Total ],
      "Embedding",
        (* closest vertex to the coord-space midpoint of the endpoints *)
        With[ { walks = Which[
                  GraphQ @ x,               walksOf @ x,
                  MatchQ[ x, { __Graph } ], Catenate[ walksOf /@ x ],
                  x === { },                { },
                  True,                     { x } ],
                embOpts = Replace[ OptionValue[ Method ], { { _String, opt___ } :> { opt }, _ -> { } } ] },
          { coords = Replace[ "Coordinates" /. embOpts /. "Coordinates" -> Automatic,
              Automatic :> GraphEmbedding[ Graph[ graph, GraphLayout -> "SpringEmbedding" ] ] ],
            vertexIndex = AssociationThread[ VertexList[ graph ], Range @ VertexCount[ graph ] ] },
          { target = ( coords[[ vertexIndex[ First @ First @ walks ] ]] +
                       coords[[ vertexIndex[ Last @ First @ walks ] ]] ) / 2,
            pool = If[ ( "Pool" /. embOpts /. "Pool" -> "ShortestPaths" ) === "AllPaths",
                     VertexList[ graph ], DeleteDuplicates @ Catenate @ walks ] },
          <| First @
            SortBy[ pool, v |-> EuclideanDistance[ coords[[ vertexIndex[ v ] ]], target ] ] -> 1 |> ]
    ]
  ]

FindInfraMidpoint[ graph_Graph, p1_, p2 : Except[ _Rule | _RuleDelayed ], opts : OptionsPattern[] ] :=
  FindInfraMidpoint[ graph, FindInfraSegment[ graph, p1, p2, All ], opts ]


(* ===================== FindInfraGoldenSection ===================== *)

(* AB/AS == AS/SB, i.e. AS == AB/phi: the vertex at the index closest to 1 + (n - 1)/phi.  The golden index is irrational, so it is a single vertex per walk *)

Options[ FindInfraGoldenSection ] = { Method -> "Metric", "Tolerance" -> 0 };

FindInfraGoldenSection[ graph_Graph, x : ( _Graph | _List ), opts : OptionsPattern[] ] /; ! VertexQ[ graph, x ] :=
  With[ { method = Replace[ OptionValue[ Method ], { m_String, ___ } :> m ], tol = OptionValue[ "Tolerance" ],
          walksOf = w |-> With[ { vs = VertexList @ w },
              { spelled = AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
                scan = root |-> Reap[ DepthFirstScan[ w, root, { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] },
              Which[
                ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w,
                  { If[ First @ # === Last @ #, #, Append[ #, First @ # ] ] & @
                      If[ spelled, Last /@ SortBy[ vs, First ], scan @ First @ vs ] },
                EdgeCount @ w == 0, List /@ If[ spelled, Last /@ vs, vs ],
                spelled,            { Last /@ SortBy[ vs, First ] },
                DirectedGraphQ @ w,
                  Catenate @ Catenate @ Table[ FindPath[ w, a, b, Infinity, All ],
                    { a, Select[ vs, VertexInDegree[ w, # ] == 0 & ] }, { b, Select[ vs, VertexOutDegree[ w, # ] == 0 & ] } ],
                True, { scan @ SelectFirst[ vs, VertexDegree[ w, # ] == 1 &, First @ vs ] } ] ] },
    (* occupation of the central index band, vertex -> mass: a walk contributes 1 per band vertex, a substrate DAG -- a path graph included -- reads the band off its layers weighted by geodesic occupation, exactly as the enumerated family would; a closed or position-spelled walk graph is read as its vertex sequences *)
    { band = c |-> If[ GraphQ @ c,
        With[ { layers = If[ VertexCount[ c ] == 0, <||>,
                  AssociationThread[ VertexList[ c ],
                    GraphDistance[ c, First @ Select[ VertexList[ c ], VertexInDegree[ c, # ] == 0 & ] ] ] ] },
          If[ Length @ layers === 0, <||>,
            With[ { occ = GeodesicOccupation[ c ], len = Max[ 0, Values @ layers ] },
              { offs = Abs[ # - N[ 1 / GoldenRatio ] * len ] & /@ layers },
              KeyTake[ occ, Keys @ Select[ offs, # <= Min[ Values @ offs ] + tol & ] ] ] ] ],
        With[ { offsets = Abs[ Range[ Length @ c ] - ( 1 + N[ 1 / GoldenRatio ] ( Length @ c - 1 ) ) ] },
          Counts @ Pick[ c, Thread[ offsets <= Min[ offsets ] + tol ], True ] ] ],
      carriers = w |-> If[ ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w ||
          AllTrue[ VertexList @ w, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ VertexList @ w ] === Range @ VertexCount @ w,
        walksOf @ w, { w } ] },
    Switch[ method,
      "Metric",
        KeySort @ Merge[ band /@ Which[
            GraphQ @ x,               carriers @ x,
            MatchQ[ x, { __Graph } ], Catenate[ carriers /@ x ],
            x === { },                { },
            MatchQ[ x, { __List } ],  x,
            True,                     { x } ], Total ],
      "Embedding",
        (* closest vertex to the coord-space golden point p1 + (p2 - p1)/phi *)
        With[ { walks = Which[
                  GraphQ @ x,               walksOf @ x,
                  MatchQ[ x, { __Graph } ], Catenate[ walksOf /@ x ],
                  x === { },                { },
                  True,                     { x } ],
                embOpts = Replace[ OptionValue[ Method ], { { _String, opt___ } :> { opt }, _ -> { } } ] },
          { coords = Replace[ "Coordinates" /. embOpts /. "Coordinates" -> Automatic,
              Automatic :> GraphEmbedding[ Graph[ graph, GraphLayout -> "SpringEmbedding" ] ] ],
            vertexIndex = AssociationThread[ VertexList[ graph ], Range @ VertexCount[ graph ] ] },
          { target = coords[[ vertexIndex[ First @ First @ walks ] ]] +
                     ( coords[[ vertexIndex[ Last @ First @ walks ] ]] -
                       coords[[ vertexIndex[ First @ First @ walks ] ]] ) / N[ GoldenRatio ],
            pool = If[ ( "Pool" /. embOpts /. "Pool" -> "ShortestPaths" ) === "AllPaths",
                     VertexList[ graph ], DeleteDuplicates @ Catenate @ walks ] },
          <| First @
            SortBy[ pool, v |-> EuclideanDistance[ coords[[ vertexIndex[ v ] ]], target ] ] -> 1 |> ]
    ]
  ]

FindInfraGoldenSection[ graph_Graph, p1_, p2 : Except[ _Rule | _RuleDelayed ], opts : OptionsPattern[] ] :=
  FindInfraGoldenSection[ graph, FindInfraSegment[ graph, p1, p2, All ], opts ]


(* ===================== FindInfraReflection ===================== *)

(* y with BetweennessQ[x, a, y] and d(a, y) = d(a, x): the geodesic continuation of x past a at the same distance *)

FindInfraReflection[ graph_Graph, x_, a_,
    count : ( _Integer | UpTo[ _Integer ] | All ) : All ] :=
  With[ { reps = DeleteDuplicates @ Flatten[
      ( { x0, a0 } |-> With[ { r = GraphDistance[ graph, a0, x0 ] },
          If[ r === Infinity, {},
            (* Localize: reflection lives in B(a, r), straddle-paths stay in B(a, 2 r). *)
            With[ { localG = NeighborhoodGraph[ graph, a0, 2 r ] },
              Select[ VertexList[ localG ],
                y |-> BetweennessQ[ localG, x0, a0, y ] && GraphDistance[ localG, a0, y ] === r ] ]
          ]
        ] ) @@@ Tuples[ { Keys @ InfraDensity[ graph, x ], Keys @ InfraDensity[ graph, a ] } ], 1 ] },
    Switch[ count,
      All,   reps,
      _UpTo, Take[ reps, count ],
      _,     If[ Length @ reps < count, $Failed, Take[ reps, count ] ] ] ]


(* ===================== CompleteInfraEquilateralTriangle ===================== *)

(* Euclid I.1: c with d(p1, c) = d(p2, c) = d(p1, p2), the intersection of the two spheres *)

Options[ CompleteInfraEquilateralTriangle ] = { Method -> "Metric" };

CompleteInfraEquilateralTriangle[ graph_Graph, p1_, p2_,
    count : ( _Integer | UpTo[ _Integer ] | All ) : All, opts : OptionsPattern[] ] :=
  With[ { reps = DeleteDuplicates @ Flatten[
      ( { q1, q2 } |-> With[ { r = GraphDistance[ graph, q1, q2 ] },
          If[ r === Infinity, {},
            Intersection[
              Select[ VertexList[ graph ], GraphDistance[ graph, q1, # ] == r & ],
              Select[ VertexList[ graph ], GraphDistance[ graph, q2, # ] == r & ] ]
          ]
        ] ) @@@ Tuples[ { Keys @ InfraDensity[ graph, p1 ], Keys @ InfraDensity[ graph, p2 ] } ], 1 ] },
    Switch[ count,
      All,   reps,
      _UpTo, Take[ reps, count ],
      _,     If[ Length @ reps < count, $Failed, Take[ reps, count ] ] ] ]


(* ===================== FindInfraCommonPoint ===================== *)

(* the intersection of the listed lines *)

FindInfraCommonPoint[ graph_Graph, lines_List,
    count : ( _Integer | UpTo[ _Integer ] | All ) : All ] :=
  With[ { support = w |-> Union @
      If[ AllTrue[ VertexList @ w, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ VertexList @ w ] === Range @ VertexCount @ w,
        Last /@ VertexList @ w, VertexList @ w ] },
    { reps = If[ Length[ lines ] == 0, {},
        Apply[ Intersection, Replace[ lines, { g_Graph :> support @ g, gs : { __Graph } :> Union @@ ( support /@ gs ) }, { 1 } ] ] ] },
    Switch[ count,
      All,   reps,
      _UpTo, Take[ reps, count ],
      _,     If[ Length @ reps < count, $Failed, Take[ reps, count ] ] ] ]


(* ===================== FindClosestInfraPoint ===================== *)

(* metric argmin: the vertices of line at minimum distance from point, not the Euclid I.12 foot FindInfraPerpendicular runs *)

FindClosestInfraPoint[ graph_Graph, line_, point_,
    count : ( _Integer | UpTo[ _Integer ] | All ) : All ] :=
  With[ { walksOf = w |-> With[ { vs = VertexList @ w },
      { spelled = AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
        scan = root |-> Reap[ DepthFirstScan[ w, root, { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] },
      Which[
        ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w,
          { If[ First @ # === Last @ #, #, Append[ #, First @ # ] ] & @
              If[ spelled, Last /@ SortBy[ vs, First ], scan @ First @ vs ] },
        EdgeCount @ w == 0, List /@ If[ spelled, Last /@ vs, vs ],
        spelled,            { Last /@ SortBy[ vs, First ] },
        DirectedGraphQ @ w,
          Catenate @ Catenate @ Table[ FindPath[ w, a, b, Infinity, All ],
            { a, Select[ vs, VertexInDegree[ w, # ] == 0 & ] }, { b, Select[ vs, VertexOutDegree[ w, # ] == 0 & ] } ],
        True, { scan @ SelectFirst[ vs, VertexDegree[ w, # ] == 1 &, First @ vs ] } ] ] },
    { spread = x |-> Which[
        AssociationQ @ x,         Keys @ x,
        GraphQ @ x,               walksOf @ x,
        MatchQ[ x, { __Graph } ], Catenate[ walksOf /@ x ],
        x === { },                { },
        MatchQ[ x, ( InfraSegment | InfraRay | InfraLine | InfraCircle | InfraArc )[ _Association ] ],
          Catenate[ walksOf /@ Normal @ x ],
        True,                     { x } ] },
    { reps = DeleteDuplicates @ Flatten[
        ( { line0, point0 } |-> MinimalBy[ line0, GraphDistance[ graph, point0, # ] & ] ) @@@
          Tuples[ { spread @ line, Keys @ InfraDensity[ graph, point ] } ], 1 ] },
    Switch[ count,
      All,   reps,
      _UpTo, Take[ reps, count ],
      _,     If[ Length @ reps < count, $Failed, Take[ reps, count ] ] ] ]


(* ===================== SelectInfraPoint ===================== *)


SelectInfraPoint::badfrom = "\"From\" specification `1` is not supported by SelectInfraPoint. Supported: All, \"Random\", \"Center\", \"Periphery\", anchor -> spec, a vertex, a vertex list, a density.";

Options[ SelectInfraPoint ] = { "From" -> All, "Distance" -> None, "MaxCliques" -> All };

(* an unrecognised selector must raise ::badfrom rather than fall through to the whole vertex pool, which reads as a legitimate random draw *)

SelectInfraPoint[ graph_Graph, vertices_List, UpTo[ nMax_Integer ], opts : OptionsPattern[] ] :=
  With[ { fromSpec = OptionValue[ "From" ], distSpec = OptionValue[ "Distance" ], maxCl = OptionValue[ "MaxCliques" ] },
    Which[
      ! ( VertexQ[ graph, fromSpec ] || MatchQ[ fromSpec, All | "Random" | "Center" | "Periphery" |
            { "Center", _Integer | Infinity } | _Association | _Rule | _List ] ),
        Message[ SelectInfraPoint::badfrom, fromSpec ]; $Failed,
      Length[ vertices ] <= 1, vertices,
      True,
        Module[ { vIdx, subMatrix, poolIdx, pool, poolSubMatrix, finiteMax, range,
                  auxiliaryGraph, cliques, thresholds, n },
          vIdx = Lookup[ AssociationThread[ VertexList @ graph, Range @ VertexCount @ graph ], vertices ];
          subMatrix = GraphDistanceMatrix[ graph ][[ vIdx, vIdx ]];
          poolIdx = Which[
            fromSpec === All, Range @ Length @ vertices,
            fromSpec === "Center" || fromSpec === "Periphery",
              With[ { scores = Max /@ subMatrix },
                Flatten @ Position[ scores, If[ fromSpec === "Center", Min, Max ] @ scores, { 1 }, Heads -> False ] ],
            MatchQ[ fromSpec, _ -> _ ],
              With[ { anchors = If[ AssociationQ @ First @ fromSpec, Keys @ First @ fromSpec, { First @ fromSpec } ],
                      spec = Last @ fromSpec,
                      vertexIndex = AssociationThread[ VertexList[ graph ] -> Range @ VertexCount[ graph ] ] },
                { anchorDists = Association[ # -> GraphDistance[ graph, # ] & /@ anchors ] },
                Flatten @ Position[ vertices,
                  v_ /; AllTrue[ anchors, a |-> With[ { allDists = anchorDists[ a ], idx = vertexIndex[ v ] },
                    ListQ[ allDists ] && IntegerQ[ idx ] && Switch[ spec,
                      _?NumericQ,                 allDists[[ idx ]] == spec,
                      { _?NumericQ, _?NumericQ }, First @ spec <= allDists[[ idx ]] <= Last @ spec,
                      "Max",                      allDists[[ idx ]] == Max @ Select[ allDists, # < Infinity & ],
                      _,                          False ] ] ],
                  { 1 }, Heads -> False ] ],
            AssociationQ @ fromSpec,
              Flatten @ Position[ vertices, Alternatives @@ Keys @ fromSpec, { 1 }, Heads -> False ],
            MemberQ[ vertices, fromSpec ],
              { First @ FirstPosition[ vertices, fromSpec ] },
            ListQ @ fromSpec,
              Flatten @ Position[ vertices, Alternatives @@ fromSpec, { 1 }, Heads -> False ],
            True, Range @ Length @ vertices ];
          pool = vertices[[ poolIdx ]];
          n = Min[ nMax, Length[ pool ] ];
          Which[
            poolIdx === { }, { },
            distSpec === None || n <= 1, If[ n >= Length[ pool ], pool, RandomSample[ pool, n ] ],
            True,
              poolSubMatrix = subMatrix[[ poolIdx, poolIdx ]];
              finiteMax = Replace[ Max @ Select[ Flatten @ poolSubMatrix, # < Infinity & ],
                _?( ! NumericQ @ # & ) -> 0 ];
              poolSubMatrix = Replace[ poolSubMatrix, Infinity -> finiteMax + 1, { 2 } ];
              Which[
                distSpec === "Max" || distSpec === "Spread",
                  thresholds = Reverse @ DeleteCases[ Union @@ poolSubMatrix, 0 | _?( # > finiteMax & ) ];
                  cliques = { };
                  Do[
                    auxiliaryGraph = AdjacencyGraph[ pool,
                      UnitStep[ poolSubMatrix - d ] * UnitStep[ finiteMax - poolSubMatrix ]
                        * ( 1 - IdentityMatrix[ Length[ pool ] ] ) ];
                    cliques = FindClique[ auxiliaryGraph, { n, VertexCount[ auxiliaryGraph ] }, maxCl ];
                    If[ cliques =!= { }, Break[ ] ],
                    { d, thresholds } ];
                  Which[
                    cliques === { }, { },
                    (* among the max-min-gap cliques, the n-subset of minimal variance of pairwise distances *)
                    distSpec === "Spread",
                      With[ { idx = AssociationThread[ pool -> Range @ Length @ pool ],
                              subsets = DeleteDuplicates[ Sort /@ Catenate[ Subsets[ #, { n } ] & /@ cliques ] ] },
                        If[ n < 3,
                          First @ subsets,
                          First @ MinimalBy[ subsets,
                            sub |-> Variance[ poolSubMatrix[[ idx @ #[[ 1 ]], idx @ #[[ 2 ]] ]] & /@ Subsets[ sub, { 2 } ] ] ] ] ],
                    True, RandomSample[ RandomChoice @ cliques, UpTo[ n ] ] ],
                True,
                  range = Replace[ distSpec,
                    { d_?NumericQ                  :> { d, d },
                      { dMin_?NumericQ, Infinity } :> { dMin, finiteMax },
                      { dMin_?NumericQ, dMax_?NumericQ } :> { dMin, dMax },
                      _ :> { 0, finiteMax } } ];
                  auxiliaryGraph = AdjacencyGraph[ pool,
                    UnitStep[ poolSubMatrix - range[[ 1 ]] ] * UnitStep[ range[[ 2 ]] - poolSubMatrix ]
                      * ( 1 - IdentityMatrix[ Length[ pool ] ] ) ];
                  cliques = FindClique[ auxiliaryGraph,
                    { Min[ n, VertexCount[ auxiliaryGraph ] ], VertexCount[ auxiliaryGraph ] }, maxCl ];
                  If[ cliques === { }, { }, RandomSample[ RandomChoice @ cliques, UpTo[ n ] ] ]
              ]
          ]
        ]
    ]
  ]

SelectInfraPoint[ graph_Graph, vertices_List, All, opts : OptionsPattern[] ] :=
  SelectInfraPoint[ graph, vertices, UpTo[ Length[ vertices ] ], opts ]

SelectInfraPoint[ graph_Graph, vertices_List, n_Integer : 1, opts : OptionsPattern[] ] :=
  With[ { result = SelectInfraPoint[ graph, vertices, UpTo[ n ], opts ] },
    If[ ListQ[ result ] && Length[ result ] < n, $Failed, result ] ]

(* a density or a walk graph selects from its support; a set is a vertex list already *)
SelectInfraPoint[ graph_Graph, shape : _Association | _Graph | { __Graph },
                  countSpec : ( _Integer | UpTo[ _Integer ] | All ) : 1, opts : OptionsPattern[] ] :=
  SelectInfraPoint[ graph, Keys @ InfraDensity[ graph, shape ], countSpec, opts ]

SelectInfraPoint[ graph_Graph, countSpec : ( _Integer | UpTo[ _Integer ] | All ), opts : OptionsPattern[] ] :=
  SelectInfraPoint[ graph, #, countSpec, opts ] &


(* ===================== InfraReachableQ ===================== *)
(* single multi-source BFS via VertexComponent: visits only the components touched by p1's realisations *)

InfraReachableQ[ graph_Graph, p1_, p2_ ] :=
  IntersectingQ[ VertexComponent[ graph, Keys @ InfraDensity[ graph, p1 ] ], Keys @ InfraDensity[ graph, p2 ] ]


(* ===================== Scene-DSL constructor ===================== *)

(* InfraPoint survives ONLY here, as the scene-language token for the point search -- FindInfraPoint minus the graph.  It is not a payload wrapper: it has no accessors and no function returns it *)

dispatchConstruction[ graph_Graph, InfraPoint[ ] ] :=
  VertexList @ graph

dispatchConstruction[ graph_Graph, InfraPoint[ v_ ] ] /; pointQ[ graph, v ] :=
  { v }

(* the shapes are literals in the scene language and name themselves, so a bound multiset or vertex list flows into a scene with no token around it *)

dispatchConstruction[ graph_Graph, vs_List ] /;
    vs =!= { } && ! pointQ[ graph, vs ] && SubsetQ[ VertexList @ graph, vs ] :=
  vs

dispatchConstruction[ graph_Graph, fam_Association ] /;
    Length[ fam ] > 0 && SubsetQ[ VertexList @ graph, Keys @ fam ] :=
  Keys @ fam

dispatchConstruction[ graph_Graph, InfraPoint[ pool_String ] ] :=
  Switch[ pool,
    "Center",    GraphCenter[ graph ],
    "Periphery", GraphPeriphery[ graph ],
    _,           VertexList @ graph
  ]

dispatchConstruction[ graph_Graph, InfraPoint[ origin_, dist_ ] ] /; ! MatchQ[ dist, _Rule ] :=
  DeleteDuplicates @ Flatten[ Map[
    o |-> Select[ VertexList @ graph, v |-> GraphDistance[ graph, o, v ] == dist ],
    If[ StringQ @ origin,
      Switch[ origin,
        "Center",    GraphCenter[ graph ],
        "Periphery", GraphPeriphery[ graph ],
        _,           VertexList @ graph ],
      If[ MemberQ[ VertexList @ graph, origin ], { origin }, origin ] ] ], 1 ]

dispatchConstruction[ graph_Graph, InfraPoint[ n_Integer, opts___Rule ] ] :=
  Module[ { dist, distMatrix, finiteMax, dMin, dMax, auxGraph, cliques },
    dist          = "Distance" /. { opts } /. "Distance" -> "Max";
    distMatrix    = GraphDistanceMatrix @ graph;
    finiteMax     = Max @ Select[ Flatten @ distMatrix, # < Infinity & ];
    { dMin, dMax } = Switch[ dist,
      "Max", { finiteMax, finiteMax },
      _List, dist /. Infinity -> finiteMax,
      _,     { dist, finiteMax } ];
    auxGraph = Graph[ VertexList @ graph,
      UndirectedEdge @@@ Select[ Subsets[ VertexList @ graph, { 2 } ],
        pair |-> With[ { d = GraphDistance[ graph, pair[[ 1 ]], pair[[ 2 ]] ] },
          dMin <= d <= dMax ] ] ];
    cliques = Select[ FindClique[ auxGraph, { n, VertexCount @ auxGraph }, All ],
      Length @ # >= n & ];
    If[ cliques === {}, {}, RandomSample[ #, n ] & /@ cliques ]
  ]
