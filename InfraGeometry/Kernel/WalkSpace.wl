Package["WolframInstitute`InfraGeometry`"]

Options[ SelectInfraWalk ] = {
  "From"       -> All,
  "Distance"   -> None,
  "Metric"     -> "Hausdorff",
  "MaxCliques" -> All,
  "Cyclic"     -> False
};

SelectInfraWalk[ graph_Graph, dags : { __Graph },
            countSpec : ( _Integer | UpTo[ _Integer ] | All ) : 1, opts : OptionsPattern[] ] /;
    NoneTrue[ dags, ! LoopFreeGraphQ @ # || ! AcyclicGraphQ @ # ||
      AllTrue[ VertexList @ #, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ VertexList @ # ] === Range @ VertexCount @ # & ] &&
    MatchQ[ OptionValue[ SelectInfraWalk, { opts }, "From" ], "MinLength" | "MaxLength" ] &&
    OptionValue[ SelectInfraWalk, { opts }, "Distance" ] === None :=
  With[ { lengths = Map[ d |-> Max @ GraphDistance[ d, First @ Select[ VertexList @ d, VertexInDegree[ d, # ] == 0 & ] ], dags ] },
    { picked = Pick[ dags, lengths,
        If[ OptionValue[ SelectInfraWalk, { opts }, "From" ] === "MaxLength", Max, Min ] @ lengths ] },
    If[ countSpec === All, Replace[ picked, { one_Graph } :> one ],
      SelectInfraWalk[ graph, picked, countSpec, "From" -> All ] ] ]

SelectInfraWalk[ graph_Graph, walks : { __Graph },
            countSpec : ( _Integer | UpTo[ _Integer ] | All ) : 1, opts : OptionsPattern[] ] :=
  With[ {
      carriersOf = w |-> With[ { vs = VertexList @ w },
        If[ ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w ||
            AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
          { w },
          PathGraph[ #, DirectedEdges -> True ] & /@ If[ EdgeCount @ w == 0, List /@ vs,
            DeleteDuplicates @ Catenate @ Catenate @ Table[ FindPath[ w, s, t, Infinity, All ],
              { s, Select[ vs, VertexInDegree[ w, # ] == 0 & ] }, { t, Select[ vs, VertexOutDegree[ w, # ] == 0 & ] } ] ] ] ],
      seqOf = w |-> With[ { vs = VertexList @ w },
        Which[
          AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs, Last /@ SortBy[ vs, First ],
          EdgeCount @ w == 0, vs,
          True, Reap[ DepthFirstScan[ w,
            SelectFirst[ vs, If[ DirectedGraphQ @ w, VertexInDegree[ w, # ] == 0, VertexDegree[ w, # ] == 1 ] &, First @ vs ],
            { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] ] ] },
    { carriers = Catenate[ carriersOf /@ walks ] },
    { seqs = seqOf /@ carriers },
    { result = SelectInfraWalk[ graph, seqs, countSpec,
        "Cyclic" -> ( ! LoopFreeGraphQ @ First @ carriers || ! AcyclicGraphQ @ First @ carriers ), opts ] },
    Lookup[ AssociationThread[ seqs -> carriers ], result ] /; ListQ[ result ] ]

SelectInfraWalk[ graph_Graph, dag_Graph,
            countSpec : ( _Integer | UpTo[ _Integer ] | All ) : 1, opts : OptionsPattern[] ] /;
    ! ( ! LoopFreeGraphQ @ dag || ! AcyclicGraphQ @ dag ) &&
    ! ( AllTrue[ VertexList @ dag, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ VertexList @ dag ] === Range @ VertexCount @ dag ) &&
    OptionValue[ SelectInfraWalk, { opts }, "From" ] === "MostVisited" &&
    OptionValue[ SelectInfraWalk, { opts }, "Distance" ] === None :=
  Module[ { topo = TopologicalSort @ dag, edges = List @@@ EdgeList @ dag,
            cap = Replace[ countSpec, { All -> Infinity, UpTo[ k_ ] :> k } ],
            source, sink, succ, pred, fwd, bwd, vC, eC, suf, pre, sStar, tight, out, tightDFS },
    source = SelectFirst[ topo, VertexInDegree[ dag, # ] == 0 & ];
    sink   = SelectFirst[ topo, VertexOutDegree[ dag, # ] == 0 & ];
    succ = GroupBy[ edges, First -> Last ];
    pred = GroupBy[ edges, Last -> First ];
    fwd = <| source -> 1 |>;
    Do[ fwd[ w ] = Total @ Lookup[ fwd, Lookup[ pred, w, { } ], 0 ], { w, DeleteCases[ topo, source ] } ];
    bwd = <| sink -> 1 |>;
    Do[ bwd[ w ] = Total @ Lookup[ bwd, Lookup[ succ, w, { } ], 0 ], { w, Reverse @ DeleteCases[ topo, sink ] } ];
    vC = AssociationMap[ fwd[ # ] bwd[ # ] &, topo ];
    eC = AssociationThread[ edges -> ( fwd[ #[[ 1 ]] ] bwd[ #[[ 2 ]] ] & /@ edges ) ];
    suf = <| sink -> vC[ sink ] |>;
    Do[ suf[ w ] = vC[ w ] + Max[ ( eC[ { w, # } ] + suf[ # ] & ) /@ Lookup[ succ, w, { } ] ],
        { w, Reverse @ DeleteCases[ topo, sink ] } ];
    pre = <| source -> vC[ source ] |>;
    Do[ pre[ w ] = vC[ w ] + Max[ ( eC[ { #, w } ] + pre[ # ] & ) /@ Lookup[ pred, w, { } ] ],
        { w, DeleteCases[ topo, source ] } ];
    sStar = suf[ source ];
    tight = AssociationMap[ w |-> Select[ Lookup[ succ, w, { } ], x |-> pre[ w ] + eC[ { w, x } ] + suf[ x ] == sStar ], topo ];
    out = { };
    tightDFS[ path_ ] := If[ Length @ out < cap,
      If[ Last @ path === sink, AppendTo[ out, path ],
        Scan[ x |-> tightDFS[ Append[ path, x ] ], tight[ Last @ path ] ] ] ];
    tightDFS[ { source } ];
    PathGraph[ #, DirectedEdges -> True ] & /@ SelectInfraWalk[ graph, out, countSpec, "From" -> All ]
  ]

SelectInfraWalk[ graph_Graph, w_Graph,
            countSpec : ( _Integer | UpTo[ _Integer ] | All ) : 1, opts : OptionsPattern[] ] :=
  SelectInfraWalk[ graph,
    With[ { vs = VertexList @ w },
      If[ ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w ||
          AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
        { w },
        PathGraph[ #, DirectedEdges -> True ] & /@ If[ EdgeCount @ w == 0, List /@ vs,
          DeleteDuplicates @ Catenate @ Catenate @ Table[ FindPath[ w, s, t, Infinity, All ],
            { s, Select[ vs, VertexInDegree[ w, # ] == 0 & ] }, { t, Select[ vs, VertexOutDegree[ w, # ] == 0 & ] } ] ] ] ],
    countSpec, opts ]

SelectInfraWalk[ graph_Graph, walks_List, UpTo[ n_Integer ], opts : OptionsPattern[] ] /;
    MatchQ[ OptionValue[ SelectInfraWalk, { opts }, "From" ],
      All | "Center" | "Periphery" | "MostVisited" | "Bottleneck" | "MinLength" | "MaxLength" | _Rule | { "Min" | "Max", _ } ] :=
  Module[ { thresholds, cliques, auxiliaryGraph },
    With[ { from = OptionValue[ "From" ], distSpec = OptionValue[ "Distance" ], cyclic = TrueQ @ OptionValue[ "Cyclic" ],
            metric = OptionValue[ "Metric" ], maxCl = OptionValue[ "MaxCliques" ] },
      Which[
        Length @ walks <= 1, walks,
        True,
          With[ {
              needsMatrix = MatchQ[ from, "Center" | "Periphery" | _Rule ] || distSpec =!= None,
              agg = Replace[ metric, { "Frechet" -> Max, "MeanFrechet" -> Mean, _ -> None } ],
              positionsOf = { scores, pick } |-> Flatten @ Position[ scores, pick @ scores, { 1 }, Heads -> False ] },
            { distMatrix  = If[ needsMatrix, GraphDistanceMatrix @ graph, None ],
              vertexIndex = If[ needsMatrix, AssociationThread[ VertexList @ graph, Range @ VertexCount @ graph ], None ],
              baseDist = If[ agg === None,
                { d, x, y } |-> ( m |-> Max[ Max[ Min /@ m ], Max[ Min /@ Transpose @ m ] ] ) @ d[[ x, y ]],
                { d, x, y } |-> If[ Length @ x === Length @ y, agg @ Diagonal @ d[[ x, y ]],
                  With[ { m = Max[ Length @ x, Length @ y ] },
                    agg @ MapThread[ d[[ #1, #2 ]] &,
                      Map[ s |-> If[ Length @ s === m, Range @ m, Round @ Rescale[ Range @ m, { 1, m }, { 1, Length @ s } ] ], { x, y } ] ] ] ] ] },
            { pathDistance = If[ cyclic,
                { dm, xs, ys } |-> Min @ Table[ baseDist[ dm, RotateLeft[ xs, k ], ys ], { k, 0, Length @ xs - 1 } ],
                baseDist ] },
            { pathMatrix = If[ needsMatrix,
                ( # + Transpose[ # ] ) & @ PadRight[
                  Table[ pathDistance[ distMatrix, Lookup[ vertexIndex, walks[[ i ]] ], Lookup[ vertexIndex, walks[[ j ]] ] ],
                    { i, Length @ walks }, { j, i - 1 } ],
                  { Length @ walks, Length @ walks } ],
                None ] },
            { poolIdx = Replace[ from, {
                All         :> Range @ Length @ walks,
                "Center"    :> positionsOf[ Max /@ pathMatrix, Min ],
                "Periphery" :> positionsOf[ Max /@ pathMatrix, Max ],
                "MinLength" :> positionsOf[ Length /@ walks, Min ],
                "MaxLength" :> positionsOf[ Length /@ walks, Max ],
                ( { "Min", scoreFn_ } ) :> positionsOf[ scoreFn /@ walks, Min ],
                ( { "Max", scoreFn_ } ) :> positionsOf[ scoreFn /@ walks, Max ],
                visit : ( "MostVisited" | "Bottleneck" ) :> With[ {
                    edgeSeqs = If[ cyclic,
                      s |-> Sort /@ If[ Length @ s >= 2 && First @ s === Last @ s, Partition[ s, 2, 1 ], Partition[ s, 2, 1, 1 ] ],
                      s |-> Sort /@ Partition[ s, 2, 1 ] ] /@ walks },
                  { vCounts = Counts @ Catenate @ walks, eCounts = Counts @ Catenate @ edgeSeqs },
                  positionsOf[
                    MapThread[ If[ visit === "MostVisited", Total, Min ] @ Join[ Lookup[ vCounts, #1, 0 ], Lookup[ eCounts, #2, 0 ] ] &,
                      { walks, edgeSeqs } ],
                    Max ] ],
                ( anchor_ -> spec_ ) :> With[ { anchors = Replace[ anchor, {
                    a_Graph :> { a },
                    as : { __Graph } :> as,
                    seq_List /; AllTrue[ seq, ListQ ] :> seq,
                    seq_List :> { seq } } ] },
                  { seqs = Map[ a |-> If[ GraphQ @ a,
                      With[ { vs = VertexList @ a },
                        Which[
                          AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs, Last /@ SortBy[ vs, First ],
                          EdgeCount @ a == 0, vs,
                          True, Reap[ DepthFirstScan[ a,
                            SelectFirst[ vs, If[ DirectedGraphQ @ a, VertexInDegree[ a, # ] == 0, VertexDegree[ a, # ] == 1 ] &, First @ vs ],
                            { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] ] ],
                      a ], anchors ] },
                  If[ seqs === { }, { },
                    With[ { rows = Table[
                        Map[ p |-> pathDistance[ distMatrix, Lookup[ vertexIndex, sq ], Lookup[ vertexIndex, p ] ], walks ],
                        { sq, seqs } ] },
                      Select[ Range @ Length @ walks,
                        i |-> AllTrue[ Range @ Length @ seqs,
                          r |-> NumericQ[ rows[[ r, i ]] ] && Switch[ spec,
                            _?NumericQ,                    rows[[ r, i ]] == spec,
                            { _?NumericQ, _?NumericQ },    spec[[ 1 ]] <= rows[[ r, i ]] <= spec[[ 2 ]],
                            "Max",                         rows[[ r, i ]] == Max @ Select[ rows[[ r ]], NumericQ ],
                            _,                             False ] ] ] ] ] ] } ] },
            { pool = walks[[ poolIdx ]] },
            { size = Min[ n, Length @ pool ] },
            Which[
              poolIdx === { }, { },
              distSpec === None || size <= 1, If[ size >= Length @ pool, pool, RandomSample[ pool, size ] ],
              True,
                With[ { finiteMax = Replace[ Max @ Select[ Flatten @ pathMatrix[[ poolIdx, poolIdx ]], # < Infinity & ],
                          _?( ! NumericQ @ # & ) -> 0 ] },
                  { subMatrix = Replace[ pathMatrix[[ poolIdx, poolIdx ]], Infinity -> finiteMax + 1, { 2 } ] },
                  If[ distSpec === "Max",
                    thresholds = Reverse @ DeleteCases[ Union @@ subMatrix, 0 | _?( # > finiteMax & ) ];
                    cliques = { };
                    Do[
                      auxiliaryGraph = AdjacencyGraph[ pool,
                        UnitStep[ subMatrix - d ] * UnitStep[ finiteMax - subMatrix ]
                          * ( 1 - IdentityMatrix[ Length @ pool ] ) ];
                      cliques = FindClique[ auxiliaryGraph, { size, VertexCount @ auxiliaryGraph }, maxCl ];
                      If[ cliques =!= { }, Break[ ] ],
                      { d, thresholds } ];
                    If[ cliques === { }, { }, RandomSample[ RandomChoice[ cliques ], UpTo[ size ] ] ],
                    With[ { range = Replace[ distSpec,
                        { d_?NumericQ                        :> { d, finiteMax },
                          { dMin_?NumericQ, Infinity }       :> { dMin, finiteMax },
                          { dMin_?NumericQ, dMax_?NumericQ } :> { dMin, dMax },
                          _ :> { 0, finiteMax } } ] },
                      { aux = AdjacencyGraph[ pool,
                          UnitStep[ subMatrix - range[[ 1 ]] ] * UnitStep[ range[[ 2 ]] - subMatrix ]
                            * ( 1 - IdentityMatrix[ Length @ pool ] ) ] },
                      { found = FindClique[ aux, { Min[ size, VertexCount @ aux ], VertexCount @ aux }, maxCl ] },
                      If[ found === { }, { }, RandomSample[ RandomChoice[ found ], UpTo[ size ] ] ] ] ] ] ] ] ] ] ]

SelectInfraWalk[ graph_Graph, walks_List, All, opts : OptionsPattern[] ] :=
  With[ { result = SelectInfraWalk[ graph, walks, UpTo[ Length[ walks ] ], opts ] },
    result /; ListQ[ result ] ]

SelectInfraWalk[ graph_Graph, walks_List, n_Integer : 1, opts : OptionsPattern[] ] :=
  With[ { result = SelectInfraWalk[ graph, walks, UpTo[ n ], opts ] },
    If[ Length[ result ] < n, { }, result ] /; ListQ[ result ] ]

SelectInfraWalk[ graph_Graph, countSpec : ( _Integer | UpTo[ _Integer ] | All ), opts : OptionsPattern[] ] :=
  SelectInfraWalk[ graph, #, countSpec, opts ] &

EmbeddingClosest[ graph_Graph, w_Graph, ref_ ] := EmbeddingClosest[ graph, { w }, ref ]

EmbeddingClosest[ graph_Graph, paths : { __Graph }, ref_ ] :=
  With[ {
      carriersOf = w |-> With[ { vs = VertexList @ w },
        If[ ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w ||
            AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
          { w },
          PathGraph[ #, DirectedEdges -> True ] & /@ If[ EdgeCount @ w == 0, List /@ vs,
            DeleteDuplicates @ Catenate @ Catenate @ Table[ FindPath[ w, s, t, Infinity, All ],
              { s, Select[ vs, VertexInDegree[ w, # ] == 0 & ] }, { t, Select[ vs, VertexOutDegree[ w, # ] == 0 & ] } ] ] ] ],
      seqOf = w |-> With[ { vs = VertexList @ w },
        Which[
          AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs, Last /@ SortBy[ vs, First ],
          EdgeCount @ w == 0, vs,
          True, Reap[ DepthFirstScan[ w,
            SelectFirst[ vs, If[ DirectedGraphQ @ w, VertexInDegree[ w, # ] == 0, VertexDegree[ w, # ] == 1 ] &, First @ vs ],
            { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] ] ] },
    { carriers = Catenate[ carriersOf /@ paths ] },
    { seqs = seqOf /@ carriers },
    Lookup[ AssociationThread[ seqs -> carriers ],
      Which[
        ! ( AllTrue[ carriers, ! LoopFreeGraphQ @ # || ! AcyclicGraphQ @ # & ] && MatchQ[ ref, { _, _?NumericQ } ] ),
          EmbeddingClosest[ graph, seqs, ref ],
        Length @ seqs <= 1, seqs,
        True,
          With[ { coords = GraphEmbedding[ Graph[ graph, GraphLayout -> "SpringEmbedding" ] ],
                  vertexIndex = AssociationThread[ VertexList[ graph ], Range @ VertexCount[ graph ] ] },
            { centerPt = coords[[ vertexIndex[ First @ ref ] ]] },
            MinimalBy[ seqs,
              cycle |-> If[ Length @ cycle < 3, Infinity,
                With[ { pts = coords[[ Lookup[ vertexIndex, cycle ] ]], nPts = Max[ 64, 4 * Length @ cycle ] },
                  { circlePoints = Table[ centerPt + Last[ ref ] * { Cos[ t ], Sin[ t ] }, { t, 0, 2 Pi - 2 Pi / nPts, 2 Pi / nPts } ] },
                  RegionHausdorffDistance[
                    Line[ Append[ pts, First @ pts ] ],
                    Line[ Append[ circlePoints, First @ circlePoints ] ] ] ] ] ] ] ] ] ]

EmbeddingClosest[ graph_Graph, paths_List, { p1_, p2_ } ] /; Length[ paths ] <= 1 := paths

EmbeddingClosest[ graph_Graph, paths_List, { p1_, p2_ } ] :=
  With[ { coords = GraphEmbedding[ Graph[ graph, GraphLayout -> "SpringEmbedding" ] ],
          vertexIndex = AssociationThread[ VertexList[ graph ], Range @ VertexCount[ graph ] ] },
    { ends = coords[[ Lookup[ vertexIndex, { p1, p2 } ] ]] },
    MinimalBy[ paths,
      path |-> If[ Length @ path >= 2, RegionHausdorffDistance[ Line[ coords[[ Lookup[ vertexIndex, path ] ]] ], Line[ ends ] ], 0 ] ]
  ]

EmbeddingClosest[ graph_Graph, sets_List, { center_, radius_?NumericQ } ] :=
  With[ { coords = GraphEmbedding[ Graph[ graph, GraphLayout -> "SpringEmbedding" ] ],
          vertexIndex = AssociationThread[ VertexList[ graph ], Range @ VertexCount[ graph ] ] },
    { centerPt = coords[[ vertexIndex @ center ]] },
    SortBy[ sets,
      set |-> If[ set === { }, Infinity,
        Max[ Abs[ EuclideanDistance[ centerPt, # ] - radius ] & /@
              coords[[ Lookup[ vertexIndex, set ] ]] ] ] ]
  ]

EmbeddingClosest[ graph_Graph, paths_List, crv_ ] /;
    ( MatchQ[ crv, _Line | _BSplineCurve | _BezierCurve ] ||
      MatrixQ[ crv, NumericQ ] && Last[ Dimensions[ crv ] ] === 2 && Length[ crv ] >= 3 ) && Length[ paths ] <= 1 := paths

EmbeddingClosest[ graph_Graph, paths_List, crv_ ] /;
    MatchQ[ crv, _Line | _BSplineCurve | _BezierCurve ] ||
    MatrixQ[ crv, NumericQ ] && Last[ Dimensions[ crv ] ] === 2 && Length[ crv ] >= 3 :=
  With[ { coords = GraphEmbedding[ Graph[ graph, GraphLayout -> "SpringEmbedding" ] ],
          vertexIndex = AssociationThread[ VertexList[ graph ], Range @ VertexCount[ graph ] ],
          curvePts = Replace[ crv, {
            Line[ pts_ ] :> pts,
            BSplineCurve[ pts_, o___ ] :> BSplineFunction[ pts, o ] /@ Subdivide[ 0., 1., Max[ 64, 4 Length[ pts ] ] ],
            BezierCurve[ pts_, ___ ] :> BezierFunction[ pts ] /@ Subdivide[ 0., 1., Max[ 64, 4 Length[ pts ] ] ] } ] },
    MinimalBy[ paths,
      path |-> RegionHausdorffDistance[
        If[ Length[ path ] >= 2, Line[ coords[[ Lookup[ vertexIndex, path ] ]] ], Point[ coords[[ vertexIndex @ First @ path ]] ] ],
        Line[ curvePts ] ] ]
  ]

EmbeddingClosest[ graph_Graph, ref_List ] := EmbeddingClosest[ graph, #, ref ] &

EmbeddingClosest[ graph_Graph, crv : ( _Line | _BSplineCurve | _BezierCurve ) ] :=
  EmbeddingClosest[ graph, #, crv ] &

FindEmbeddingClosestPath[ graph_Graph, curve_ ] :=
  With[ { coords = GraphEmbedding[ Graph[ graph, GraphLayout -> "SpringEmbedding" ] ],
          curvePts = Replace[ curve, {
            Line[ pts_ ] :> pts,
            BSplineCurve[ pts_, o___ ] :> BSplineFunction[ pts, o ] /@ Subdivide[ 0., 1., Max[ 64, 4 Length[ pts ] ] ],
            BezierCurve[ pts_, ___ ] :> BezierFunction[ pts ] /@ Subdivide[ 0., 1., Max[ 64, 4 Length[ pts ] ] ] } ] },
    { anchors = First /@ Split[
        Nearest[ coords -> VertexList[ graph ], curvePts ][[ All, 1 ]] ] },
    { walk = Fold[
        Join[ #1, Rest @ FindShortestPath[ graph, Last @ #1, #2 ] ] &,
        { First @ anchors }, Rest @ anchors ] },
    PathGraph[ MapIndexed[ { First @ #2, #1 } &, walk ], DirectedEdges -> True ]
  ]

(* [g, c]: the BFS DAG of all geodesics from c -- edge u -> v whenever d(c, v) = d(c, u) + 1 and u-v is a g-edge.  [g, <| v -> m |>]: the same with d_c replaced by min_i d(ci, v).  [g, pairs]: the union of geodesics between the listed pairs *)

Options[ SprayGraph ] = {
  "AxisLength"    -> All,
  "PathThickness" -> 0,
  "Directed"      -> True
};

SprayGraph[ g_Graph, c_, opts : OptionsPattern[] ] /; MemberQ[ VertexList[ g ], c ] :=
  SprayGraph[ g, <| c -> 1 |>, opts ]

SprayGraph[ g_Graph, sources_List, opts : OptionsPattern[] ] /; SubsetQ[ VertexList[ g ], sources ] :=
  SprayGraph[ g, KeySort @ AssociationMap[ 1 &, sources ], opts ]

SprayGraph[ g_Graph, fam_Association, OptionsPattern[] ] /; SubsetQ[ VertexList[ g ], Keys @ fam ] :=
  With[ { dist = AssociationThread[ VertexList[ g ], Min /@ Transpose[ GraphDistance[ g, # ] & /@ Keys @ fam ] ],
          depth = Replace[ OptionValue[ "AxisLength" ], All -> Infinity ],
          directed = OptionValue[ "Directed" ],
          coords = AssociationThread[ VertexList[ g ], GraphEmbedding[ g ] ] },
    { dagVerts = Select[ VertexList[ g ], dist[ # ] < Infinity && dist[ # ] <= depth & ] },
    Graph[ dagVerts,
      Map[
        e |-> With[ { u = e[[ 1 ]], v = e[[ 2 ]] },
          Which[
            ! directed && Abs[ dist[ u ] - dist[ v ] ] == 1, UndirectedEdge[ u, v ],
            directed && dist[ v ] == dist[ u ] + 1, DirectedEdge[ u, v ],
            directed && dist[ u ] == dist[ v ] + 1, DirectedEdge[ v, u ],
            True, Nothing ] ],
        EdgeList @ UndirectedGraph @ Subgraph[ g, dagVerts ] ],
      VertexCoordinates -> Lookup[ coords, dagVerts ]
    ]
  ]

SprayGraph[ g_Graph, pairs : { { _, _ } .. }, OptionsPattern[] ] :=
  With[ { thickness = OptionValue[ "PathThickness" ],
          directed  = OptionValue[ "Directed" ],
          vertexToIndex = AssociationThread[ VertexList[ g ], Range @ VertexCount[ g ] ],
          distMatrix = GraphDistanceMatrix[ g ] },
    { hausdorff = With[ { dm = distMatrix[[ #1, #2 ]] },
        Max[ Max[ Min /@ dm ], Max[ Min /@ Transpose @ dm ] ] ] & },
    { selectedPaths = Which[
        thickness === 0,
          ( First @ FindPath[ g, #1, #2,
              { distMatrix[[ vertexToIndex[ #1 ], vertexToIndex[ #2 ] ]] }, 1 ] & ) @@@ pairs,
        thickness === Infinity,
          Flatten[ ( FindPath[ g, #1, #2,
              { distMatrix[[ vertexToIndex[ #1 ], vertexToIndex[ #2 ] ]] }, All ] & ) @@@ pairs, 1 ],
        True,
          Flatten[
            ( If[ # === { }, { },
                With[ { ref = vertexToIndex /@ First[ # ] },
                  Select[ #, path |-> hausdorff[ vertexToIndex /@ path, ref ] <= thickness ] ]
              ] & ) /@
            ( ( FindPath[ g, #1, #2,
                { distMatrix[[ vertexToIndex[ #1 ], vertexToIndex[ #2 ] ]] }, All ] & ) @@@ pairs ),
            1 ]
      ] },
    GraphUnion @@ ( PathGraph[ #, DirectedEdges -> directed ] & /@ selectedPaths )
  ]

(* [g, {p1, p2}]: the DAG of all geodesic extensions of the segment p1 -> p2 beyond p2 -- vertex set { e : d(p1, e) == d(p1, p2) + d(p2, e) }, edges u -> v the g-edges with d(p1, v) == d(p1, u) + 1 -- so its directed paths from the source p2 are exactly the geodesics from p2 that stay geodesic behind any p1 -> p2 geodesic.  The set is closed under such steps (d(p1, v) <= d(p1, p2) + d(p2, v) <= d(p1, u) + 1 forces equality), so the edges need no membership test.  Wrapper anchors spread to one DAG per anchor pair *)

GeodesicExtensionGraph[ g_Graph, { p1_, p2_ } ] /; VertexQ[ g, p1 ] && VertexQ[ g, p2 ] :=
  With[ { d1 = AssociationThread[ VertexList @ g, GraphDistance[ g, p1 ] ],
          d2 = AssociationThread[ VertexList @ g, GraphDistance[ g, p2 ] ],
          coords = AssociationThread[ VertexList @ g, GraphEmbedding @ g ] },
    { pool = Select[ VertexList @ g, d1[ # ] < Infinity && d1[ # ] == d1[ p2 ] + d2[ # ] & ] },
    Graph[ pool,
      Catenate @ Map[ u |-> ( DirectedEdge[ u, # ] & /@ Select[ AdjacencyList[ g, u ], v |-> d1[ v ] == d1[ u ] + 1 ] ), pool ],
      VertexCoordinates -> Lookup[ coords, pool ] ]
  ]

GeodesicExtensionGraph[ g_Graph, { p1_, p2_ } ] :=
  With[ {
      walksOf = w |-> With[ { vs = VertexList @ w },
        { spelled = AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
          scan = v |-> Reap[ DepthFirstScan[ w, v, { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] },
        Which[
          vs === { }, { },
          ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w,
            { If[ First @ # === Last @ #, #, Append[ #, First @ # ] ] & @
                If[ spelled, Last /@ SortBy[ vs, First ], scan @ First @ vs ] },
          spelled,            { Last /@ SortBy[ vs, First ] },
          EdgeCount @ w == 0, List /@ vs,
          DirectedGraphQ @ w,
            Catenate @ Catenate @ Table[ FindPath[ w, s, t, Infinity, All ],
              { s, Select[ vs, VertexInDegree[ w, # ] == 0 & ] }, { t, Select[ vs, VertexOutDegree[ w, # ] == 0 & ] } ],
          True, { scan @ SelectFirst[ vs, VertexDegree[ w, # ] == 1 &, First @ vs ] } ] ] },
    { pairs = Tuples[ Map[ x |-> Which[
        AssociationQ @ x,             Keys @ x,
        GraphQ @ x,                   walksOf @ x,
        MatchQ[ x, { __Graph } ],     Catenate[ walksOf /@ x ],
        x === { },                    { },
        True,                         { x } ], { p1, p2 } ] ] },
    Replace[ GeodesicExtensionGraph[ g, # ] & /@ pairs, { one_ } :> one ] /; pairs =!= { { p1, p2 } } ]

(* the union of all simple u-v paths of length at most k; Automatic is the geodesic case k = d(u, v) *)

Options[ PathSubgraph ] = { "Directed" -> True };

PathSubgraph[ g_Graph, u_, v_, lengthSpec : ( _Integer | UpTo[ _Integer ] | All ) : Automatic, OptionsPattern[] ] :=
  With[ { k = Replace[ lengthSpec, {
            Automatic         :> GraphDistance[ g, u, v ],
            UpTo[ n_Integer ] :> n,
            All               -> Infinity,
            n_Integer         :> n } ] },
    If[ u === v, Graph[ { u }, { } ],
      With[ { paths = FindPath[ g, u, v, k, All ] },
        If[ paths === { },
          Graph[ { }, { } ],
          GraphUnion @@ ( PathGraph[ #, DirectedEdges -> OptionValue[ "Directed" ] ] & /@ paths )
        ]
      ]
    ]
  ]

InfraDeformationSize[ ref_, ws : { __Graph } ] := InfraDeformationSize[ ref, # ] & /@ ws

InfraDeformationSize[ ref_, def_Graph ] :=
  InfraDeformationSize[ ref, With[ { vs = VertexList @ def },
    Which[
      AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs, Last /@ SortBy[ vs, First ],
      EdgeCount @ def == 0, vs,
      True, Reap[ DepthFirstScan[ def,
        SelectFirst[ vs, If[ DirectedGraphQ @ def, VertexInDegree[ def, # ] == 0, VertexDegree[ def, # ] == 1 ] &, First @ vs ],
        { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] ] ] ]

InfraDeformationSize[ ref_Graph, def_List ] :=
  InfraDeformationSize[ With[ { vs = VertexList @ ref },
    Which[
      AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs, Last /@ SortBy[ vs, First ],
      EdgeCount @ ref == 0, vs,
      True, Reap[ DepthFirstScan[ ref,
        SelectFirst[ vs, If[ DirectedGraphQ @ ref, VertexInDegree[ ref, # ] == 0, VertexDegree[ ref, # ] == 1 ] &, First @ vs ],
        { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] ] ], def ]

InfraDeformationSize[ ref_List, def_List ] := With[
  { m = Min[ Length @ ref, Length @ def ] },
  { p = LengthWhile[ Transpose @ { Take[ ref, m ], Take[ def, m ] }, Apply @ SameQ ],
    s = LengthWhile[ Transpose @ { Take[ Reverse @ ref, m ], Take[ Reverse @ def, m ] }, Apply @ SameQ ] },
  Max[ 0, ( Length[ ref ] - 1 ) - ( p - 1 ) - ( s - 1 ) ]
]
