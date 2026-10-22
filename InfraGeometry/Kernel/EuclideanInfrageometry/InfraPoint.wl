Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraPoint *)

Options[ RandomInfraPoint ] = { "PairwiseDistance" -> None, "MaxCliques" -> All, "NextVertexFunction" -> Automatic, RandomSeeding -> Automatic }

RandomInfraPoint[ args___ ] /; FreeQ[ { args }, RandomSeeding -> None, { 1 } ] :=
  With[ { result = BlockRandom[
      RandomInfraPoint[ Sequence @@ DeleteCases[ { args }, RandomSeeding -> _ ], RandomSeeding -> None ],
      RandomSeeding -> FirstCase[ { args }, ( RandomSeeding -> seed_ ) :> seed, Automatic ] ] },
    result /; ! MatchQ[ result, HoldPattern[ RandomInfraPoint[ ___, RandomSeeding -> None ] ] ] ]

(* n points pairwise at a distance in [lo, hi] are an n-clique of the graph on the pool joining two vertices at such a distance;
   "Max" takes the largest lo that still admits one, which maximises the least pairwise distance *)

RandomInfraPoint[ graph_Graph, region : Except[ _Integer | UpTo[ _Integer ] | All | _Rule | _RuleDelayed ] : Automatic,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( ! MatchQ[ region, _InfraPoint ] &&
    MemberQ[ { Automatic, Identity }, OptionValue[ RandomInfraPoint, { opts }, "NextVertexFunction" ] ] &&
    SubsetQ[ First /@ Options[ RandomInfraPoint ], First /@ { opts } ] ) :=
  With[ { pool = Which[
            region === Automatic, VertexList @ graph,
            VertexQ[ graph, region ], { region },
            MatchQ[ region, _InfraUnion ],
              Union @@ Map[ If[ VertexQ[ graph, # ], { # }, RandomInfraPoint[ graph, #, All, RandomSeeding -> None ] ] &, List @@ region ],
            MatchQ[ region, _InfraIntersection ],
              Intersection @@ Map[ If[ VertexQ[ graph, # ], { # }, RandomInfraPoint[ graph, #, All, RandomSeeding -> None ] ] &, List @@ region ],
            MatchQ[ region, _InfraCircle ], Union @@ RandomInfraCircle[ graph, region, All, RandomSeeding -> None ],
            MatchQ[ region, _InfraCircleThrough ], Keys @ InfraMeasurement[ graph, region, "VertexDensity" ],
            MatchQ[ region, _InfraPlane ], Union @@ RandomInfraPlane[ graph, region, All, RandomSeeding -> None ],
            MatchQ[ region, _InfraRegularPolygon | _InfraPolygon ], Union @@ RandomInfraRegularPolygon[ graph, region, All, RandomSeeding -> None ],
            MatchQ[ region, _InfraEllipse ], Union @@ ( VertexList /@ RandomInfraEllipse[ graph, region, All, RandomSeeding -> None ] ),
            MatchQ[ region, _InfraWalk ], Union @@ RandomInfraWalk[ graph, region, All, RandomSeeding -> None ],
            MatchQ[ region, _InfraGeodesic ], Union @@ RandomInfraGeodesic[ graph, region, All, RandomSeeding -> None ],
            True, Keys @ Select[ InfraMeasurement[ graph, region, "VertexDensity" ], value |-> value != 0 ] ],
          dist = OptionValue[ "PairwiseDistance" ], maxCliques = OptionValue[ "MaxCliques" ],
          deterministic = count === All || OptionValue[ "NextVertexFunction" ] === Identity },
    { n = Min[ Length @ pool, Replace[ count, { UpTo[ k_ ] :> k, All -> Infinity, Automatic -> 1 } ] ] },
    { points = Which[
        count === Automatic,     If[ pool === { }, { }, If[ deterministic, First @ pool, RandomChoice @ pool ] ],
        n <= 1 || dist === None, If[ deterministic, Take[ pool, n ], RandomSample[ pool, n ] ],
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
                  True, If[ deterministic, Take[ First @ cliques, n ], RandomSample[ RandomChoice @ cliques, n ] ] ] ],
              With[ { range = Replace[ dist,
                      { d_?NumericQ :> { d, d },
                        { dMin_, dMax_ } :> { dMin, dMax /. Infinity -> finiteMax } } ] },
                { cliques = FindClique[
                    AdjacencyGraph[ pool, UnitStep[ distMatrix - range[[ 1 ]] ] * UnitStep[ range[[ 2 ]] - distMatrix ] * mask ],
                    { n, Length @ pool }, maxCliques ] },
                If[ cliques === { }, { }, If[ deterministic, Take[ First @ cliques, n ], RandomSample[ RandomChoice @ cliques, n ] ] ] ] ] ] ] },
    If[ IntegerQ @ count && Length @ points < count, { }, points ] ]

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
        ] ) @@@ Tuples[ { Keys @ InfraMeasurement[ graph, x, "VertexDensity" ], Keys @ InfraMeasurement[ graph, a, "VertexDensity" ] } ], 1 ] },
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
        MatchQ[ x, { __List } ] && ! AllTrue[ x, vertex |-> VertexQ[ graph, vertex ] ], x,
        x === { },                { },
        True,                     { x } ] },
    { reps = DeleteDuplicates @ Flatten[
        ( { line0, point0 } |-> MinimalBy[ line0, GraphDistance[ graph, point0, # ] & ] ) @@@
          Tuples[ { spread @ line, Keys @ InfraMeasurement[ graph, point, "VertexDensity" ] } ], 1 ] },
    Switch[ count,
      All,   reps,
      _UpTo, Take[ reps, count ],
      _,     If[ Length @ reps < count, { }, Take[ reps, count ] ] ] ]

InfraReachableQ[ graph_Graph, p1_, p2_ ] :=
  IntersectingQ[ VertexComponent[ graph, Keys @ InfraMeasurement[ graph, p1, "VertexDensity" ] ], Keys @ InfraMeasurement[ graph, p2, "VertexDensity" ] ]

RandomInfraPoint[ graph_Graph, InfraPoint[ ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( SubsetQ[ { "NextVertexFunction", RandomSeeding }, First /@ { opts } ] &&
    ( OptionValue[ RandomInfraPoint, { opts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) ) :=
  With[ { members = VertexList @ graph,
          nextFn = OptionValue[ RandomInfraPoint, { opts }, "NextVertexFunction" ] },
    { ordered = Sort @ members },
    Which[
      count === Automatic, If[ ordered === { }, { }, If[ nextFn === Identity, First @ ordered, RandomChoice @ ordered ] ],
      count === All,       members,
      nextFn === Identity, If[ IntegerQ @ count && Length @ ordered < count, { }, Take[ ordered, count ] ],
      IntegerQ @ count && Length @ ordered < count, { },
      True, RandomSample[ ordered, count ] ] ]

RandomInfraPoint[ graph_Graph, InfraPoint[ v_ ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( SubsetQ[ { "NextVertexFunction", RandomSeeding }, First /@ { opts } ] &&
    pointQ[ graph, v ] &&
      ( OptionValue[ RandomInfraPoint, { opts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) ) :=
  With[ { members = { v },
          nextFn = OptionValue[ RandomInfraPoint, { opts }, "NextVertexFunction" ] },
    { ordered = Sort @ members },
    Which[
      count === Automatic, If[ ordered === { }, { }, If[ nextFn === Identity, First @ ordered, RandomChoice @ ordered ] ],
      count === All,       members,
      nextFn === Identity, If[ IntegerQ @ count && Length @ ordered < count, { }, Take[ ordered, count ] ],
      IntegerQ @ count && Length @ ordered < count, { },
      True, RandomSample[ ordered, count ] ] ]


RandomInfraPoint[ graph_Graph, InfraPoint[ region_ ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( ! VertexQ[ graph, region ] &&
    SubsetQ[ First /@ Options[ RandomInfraPoint ], First /@ { opts } ] &&
    MemberQ[ { Automatic, Identity }, OptionValue[ RandomInfraPoint, { opts }, "NextVertexFunction" ] ] ) :=
  With[ { density = InfraMeasurement[ graph, region, "VertexDensity" ] },
    RandomInfraPoint[ graph, region, count, opts ] /; AssociationQ[ density ] ]
