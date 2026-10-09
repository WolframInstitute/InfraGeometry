Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraPoint *)

Options[ RandomInfraPoint ] = { "PairwiseDistance" -> None, "MaxCliques" -> All }

(* n points pairwise at a distance in [lo, hi] are an n-clique of the graph on the pool joining two vertices at such a distance;
   "Max" takes the largest lo that still admits one, which maximises the least pairwise distance *)

RandomInfraPoint[ graph_Graph, region : Except[ _Integer | UpTo[ _Integer ] | All | _Rule | _RuleDelayed ] : Automatic,
    count : ( _Integer | UpTo[ _Integer ] | All ) : Automatic, opts : OptionsPattern[] ] :=
  With[ { pool = Which[
            region === Automatic,                    VertexList @ graph,
            MatchQ[ region, _List | _Association ], Keys @ InfraDensity[ graph, region ],
            True,                                    Keys @ InfraMeasurement[ graph, region, "VertexDensity" ] ],
          dist = OptionValue[ "PairwiseDistance" ], maxCliques = OptionValue[ "MaxCliques" ] },
    { n = Min[ Length @ pool, Replace[ count, { UpTo[ k_ ] :> k, All -> Infinity, Automatic -> 1 } ] ] },
    { points = Which[
        count === Automatic,     If[ pool === { }, { }, RandomChoice @ pool ],
        n <= 1 || dist === None, RandomSample[ pool, n ],
        True,
          With[ { vertexIndex = Lookup[ AssociationThread[ VertexList @ graph, Range @ VertexCount @ graph ], pool ] },
            { poolMatrix = GraphDistanceMatrix[ graph ][[ vertexIndex, vertexIndex ]] },
            { finiteMax = Max @ Select[ Flatten @ poolMatrix, # < Infinity & ] },
            { distMatrix = Replace[ poolMatrix, Infinity -> finiteMax + 1, { 2 } ],
              mask = 1 - IdentityMatrix @ Length @ pool },
            If[ dist === "Max" || dist === "Spread",
              With[ { cliques = Fold[
                  { found, d } |-> If[ found =!= { }, found,
                    FindClique[
                      AdjacencyGraph[ pool, UnitStep[ distMatrix - d ] * UnitStep[ finiteMax - distMatrix ] * mask ],
                      { n, Length @ pool }, maxCliques ] ],
                  { },
                  Reverse @ DeleteCases[ Union @@ distMatrix, 0 | _?( # > finiteMax & ) ] ] },
                Which[
                  cliques === { }, { },
                  dist === "Spread",
                    With[ { index = AssociationThread[ pool -> Range @ Length @ pool ],
                            subsets = DeleteDuplicates[ Sort /@ Catenate[ Subsets[ #, { n } ] & /@ cliques ] ] },
                      If[ n < 3, First @ subsets,
                        First @ MinimalBy[ subsets,
                          s |-> Variance[ distMatrix[[ index @ #[[ 1 ]], index @ #[[ 2 ]] ]] & /@ Subsets[ s, { 2 } ] ] ] ] ],
                  True, RandomSample[ RandomChoice @ cliques, n ] ] ],
              With[ { range = Replace[ dist,
                      { d_?NumericQ :> { d, d },
                        { dMin_, dMax_ } :> { dMin, dMax /. Infinity -> finiteMax } } ] },
                { cliques = FindClique[
                    AdjacencyGraph[ pool, UnitStep[ distMatrix - range[[ 1 ]] ] * UnitStep[ range[[ 2 ]] - distMatrix ] * mask ],
                    { n, Length @ pool }, maxCliques ] },
                If[ cliques === { }, { }, RandomSample[ RandomChoice @ cliques, n ] ] ] ] ] ] },
    If[ IntegerQ @ count && Length @ points < count, { }, points ] ]

Options[ FindInfraMidpoint ] = { Method -> "Metric", "Tolerance" -> 0 }

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
    { band = c |-> If[ GraphQ @ c,
        With[ { layers = If[ VertexCount[ c ] == 0, <| |>,
                  AssociationThread[ VertexList[ c ],
                    GraphDistance[ c, First @ Select[ VertexList[ c ], VertexInDegree[ c, # ] == 0 & ] ] ] ] },
          If[ Length @ layers === 0, <| |>,
            With[ { occ = InfraDensity[ graph, c ], len = Max[ 0, Values @ layers ] },
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
        With[ { walks = Which[
                  GraphQ @ x,               walksOf @ x,
                  MatchQ[ x, { __Graph } ], Catenate[ walksOf /@ x ],
                  x === { },                { },
                  MatchQ[ x, { __List } ],  x,
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

Options[ FindInfraGoldenSection ] = { Method -> "Metric", "Tolerance" -> 0 }

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
    { band = c |-> If[ GraphQ @ c,
        With[ { layers = If[ VertexCount[ c ] == 0, <| |>,
                  AssociationThread[ VertexList[ c ],
                    GraphDistance[ c, First @ Select[ VertexList[ c ], VertexInDegree[ c, # ] == 0 & ] ] ] ] },
          If[ Length @ layers === 0, <| |>,
            With[ { occ = InfraDensity[ graph, c ], len = Max[ 0, Values @ layers ] },
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
        With[ { walks = Which[
                  GraphQ @ x,               walksOf @ x,
                  MatchQ[ x, { __Graph } ], Catenate[ walksOf /@ x ],
                  x === { },                { },
                  MatchQ[ x, { __List } ],  x,
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

(* y with d(x, a) + d(a, y) = d(x, y) and d(a, y) = d(a, x) = r, i.e. d(x, y) = 2 r: the geodesic continuation of x past a at the same distance *)

FindInfraReflection[ graph_Graph, x_, a_,
    count : ( _Integer | UpTo[ _Integer ] | All ) : All ] :=
  With[ { reps = DeleteDuplicates @ Flatten[
      ( { x0, a0 } |-> With[ { r = GraphDistance[ graph, a0, x0 ] },
          If[ r === Infinity, {},
            With[ { localG = NeighborhoodGraph[ graph, a0, 2 r ] },
              Select[ VertexList[ localG ],
                y |-> GraphDistance[ localG, a0, y ] === r && GraphDistance[ localG, x0, y ] === 2 r ] ]
          ]
        ] ) @@@ Tuples[ { Keys @ InfraDensity[ graph, x ], Keys @ InfraDensity[ graph, a ] } ], 1 ] },
    Switch[ count,
      All,   reps,
      _UpTo, Take[ reps, count ],
      _,     If[ Length @ reps < count, { }, Take[ reps, count ] ] ] ]

FindInfraCommonPoint[ graph_Graph, lines_List,
    count : ( _Integer | UpTo[ _Integer ] | All ) : All ] :=
  With[ { support = w |-> Union @
      If[ AllTrue[ VertexList @ w, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ VertexList @ w ] === Range @ VertexCount @ w,
        Last /@ VertexList @ w, VertexList @ w ] },
    { reps = If[ Length[ lines ] == 0, {},
        Apply[ Intersection, Replace[ lines, { g_Graph :> support @ g, gs : { __Graph } :> Union @@ ( support /@ gs ),
              ws : { __List } :> Union @@ ws }, { 1 } ] ] ] },
    Switch[ count,
      All,   reps,
      _UpTo, Take[ reps, count ],
      _,     If[ Length @ reps < count, { }, Take[ reps, count ] ] ] ]

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
        True,                     { x } ] },
    { reps = DeleteDuplicates @ Flatten[
        ( { line0, point0 } |-> MinimalBy[ line0, GraphDistance[ graph, point0, # ] & ] ) @@@
          Tuples[ { spread @ line, Keys @ InfraDensity[ graph, point ] } ], 1 ] },
    Switch[ count,
      All,   reps,
      _UpTo, Take[ reps, count ],
      _,     If[ Length @ reps < count, { }, Take[ reps, count ] ] ] ]

InfraReachableQ[ graph_Graph, p1_, p2_ ] :=
  IntersectingQ[ VertexComponent[ graph, Keys @ InfraDensity[ graph, p1 ] ], Keys @ InfraDensity[ graph, p2 ] ]

FindInfraRepresentative[ graph_Graph, InfraPoint[ ],
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, mods___ ] :=
  takeRepresentatives[ VertexList @ graph, count, mods ]

FindInfraRepresentative[ graph_Graph, InfraPoint[ v_ ],
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, mods___ ] /; pointQ[ graph, v ] :=
  takeRepresentatives[ { v }, count, mods ]
