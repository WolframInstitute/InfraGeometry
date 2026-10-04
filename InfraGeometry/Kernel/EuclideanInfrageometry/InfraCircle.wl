Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraCircle *)

(* InfraCircle[c, r] and InfraCircle[c, {r, s}] are inert: the circles of the band W = { v : r <= d(c, v) <= s } around c, scalar r meaning {r, r}, a
   circle being a shortest cycle of the band graph A = G[W] whose removal leaves c in a component that reaches no further than s.  The band is cut
   along a radial seam sigma = (x_r, ..., x_s) -- the band part of a geodesic from c to just outside the band -- into the cut band A - V(sigma).
   When the cut band is connected (hypothesis (C)), two neighbours u, v of a seam vertex x off the seam lie on the same bank of the seam iff the
   cycle x v gamma u, gamma a path of the cut band, does not separate, and consecutive seam vertices are glued through the seam between them; the
   banks are a sign on the attachments of the seam, read off separation alone.  The unrolled band is the cyclic cover of A along the seam: sheets
   (w, n) of the cut band, seam copies (x, n + 1/2), the attachment w of x joined to the sheet below x on the bank -1 and above it on the bank +1.
   A circle through x lifts to a geodesic from (x, 1/2) to (x, 3/2), and the graph is the List of atoms, one per seam vertex x_i, of least length
   among the interval DAGs from (x_i, 1/2) to (x_i, 3/2) in the cover without the copies of x_r, ..., x_(i-1): each circle once, at its first seam
   vertex, under the winding functional (W) and (C), with no hypothesis on how often a circle meets the seam.
   An atom is projected to the graph, its sink kept as the separate copy {x, 3/2} of its source x, so that its chains are the circles as closed
   walks x -> ... -> x.  When the cut band is disconnected, or the banks are one-sided, the graph is the List of necklaces instead: on a run
   S = (s1, ..., sm) of the seam, N(S, u, v) with u ~ s1 and v ~ sm in one component of the cut band is s1 -> ... -> sm -> v, the interval DAG of
   the cut band from v to u, and the closing arrow u -> {s1, 3/2}, the cycles S v gamma u of least length that separate (design Thm. seam).  A
   one-sided bank relation witnesses a failure of (W) or of the annulus, hence "Faithful" -> False there; otherwise neither hypothesis is
   certified and "Faithful" is Undetermined.  The circle through a point is the closed arc InfraArc[c, {p, p}] *)

InfraMeasurement[ graph_Graph, InfraCircle[ center_, rs : ( _?NumericQ | { _?NumericQ, _?NumericQ } ) ], "Graph" ] :=
  With[ { dist = AssociationThread[ VertexList @ graph, GraphDistance[ graph, center ] ] },
    { rmin = Max[ 1, First @ Flatten @ { rs } ], rmax = Last @ Flatten @ { rs } },
    { local = Subgraph[ graph, Select[ VertexList @ graph, Lookup[ dist, Key @ # ] <= rmax + 1 & ] ] },
    { ends = SortBy[ Select[ VertexList @ local, Lookup[ dist, Key @ # ] > rmax & ], Lookup[ dist, Key @ # ] & ] },
    { radial = If[ ends === { }, { }, FindShortestPath[ local, center, First @ ends ] ] },
    { seam = Select[ radial, rmin <= Lookup[ dist, Key @ # ] <= rmax & ],
      bandGraph = Subgraph[ local, Select[ VertexList @ local, rmin <= Lookup[ dist, Key @ # ] <= rmax & ] ] },
    { cut = VertexDelete[ bandGraph, seam ],
      index = First /@ PositionIndex @ seam,
      attached = AssociationMap[ Complement[ AdjacencyList[ bandGraph, # ], seam ] &, seam ],
      separatesQ = cycle |-> AllTrue[ VertexComponent[ VertexDelete[ local, cycle ], center ], Lookup[ dist, Key @ # ] <= rmax & ] },
    { active = Select[ seam, attached[ # ] =!= { } & ] },
    { reference = AssociationMap[ First @ attached[ # ] &, active ] },
    { bank = If[ active === { } || ! ConnectedGraphQ @ cut, <| |>,
        With[ { flips = FoldList[
              { f, pair } |-> f If[ separatesQ @ Join[ Take[ seam, index /@ pair ],
                  FindShortestPath[ cut, reference @ Last @ pair, reference @ First @ pair ] ], -1, 1 ],
              1, Partition[ active, 2, 1 ] ] },
          Association @ MapThread[
            { x, f } |-> ( { x, # } -> f If[ # =!= reference @ x && separatesQ @ Prepend[ FindShortestPath[ cut, #, reference @ x ], x ], 1, -1 ] & /@
              attached @ x ),
            { active, flips } ] ] ] },
    If[ Length @ Union @ Values @ bank == 2,
      With[ { onSeam = AssociationThread[ seam, True ] },
        { lift = { e, n } |-> Switch[ { TrueQ @ Lookup[ onSeam, Key @ First @ e ], TrueQ @ Lookup[ onSeam, Key @ Last @ e ] },
            { False, False }, UndirectedEdge[ { First @ e, n }, { Last @ e, n } ],
            { True, True },   UndirectedEdge[ { First @ e, n + 1/2 }, { Last @ e, n + 1/2 } ],
            { True, False },  UndirectedEdge[ { Last @ e, n + ( 1 + bank[ { First @ e, Last @ e } ] ) / 2 }, { First @ e, n + 1/2 } ],
            { False, True },  UndirectedEdge[ { First @ e, n + ( 1 + bank[ { Last @ e, First @ e } ] ) / 2 }, { Last @ e, n + 1/2 } ] ] },
        { cover = sheets |-> Graph @ Flatten @ Table[ lift[ e, n ], { e, EdgeList @ bandGraph }, { n, sheets } ] },
        { bound = Min[ With[ { small = cover @ { 0, 1 } }, GraphDistance[ small, { #, 1/2 }, { #, 3/2 } ] & /@ seam ] ] },
        (* a path of length bound from (x, 1/2) to (x, 3/2) needs two edges, a seam copy and a sheet, per sheet it climbs and again per sheet it
           descends, so it stays within the sheets 1 - bound / 4 .. 1 + bound / 4 *)
        { full = cover @ Range[ Floor[ 1/2 - bound / 4 ], Ceiling[ 1 + bound / 4 ] ] },
        { atoms = MapIndexed[
            { x, i } |-> With[
              { reduced = VertexDelete[ full, Select[ VertexList @ full, MemberQ[ Take[ seam, First @ i - 1 ], First @ # ] & ] ],
                source = { x, 1/2 }, sink = { x, 3/2 } },
              (* BreadthFirstScan: one single-source GraphDistance costs 0.2 s on the 3084-vertex cover of the 25 x 25 grid band {5, 9},
                 a scan 2 ms *)
              { ds = Association @@ Last @ Reap @ BreadthFirstScan[ reduced, source, { "DiscoverVertex" -> ( Sow[ #1 -> #3 ] & ) } ],
                dt = Association @@ Last @ Reap @ BreadthFirstScan[ reduced, sink, { "DiscoverVertex" -> ( Sow[ #1 -> #3 ] & ) } ] },
              { d = Lookup[ ds, Key @ sink, Infinity ] },
              { interval = Select[ Keys @ ds, ds[ # ] + Lookup[ dt, Key @ #, Infinity ] == d & ],
                project = v |-> If[ v === sink, sink, First @ v ] },
              { inside = AssociationThread[ interval, True ] },
              If[ d === Infinity, Nothing,
                <| "Length" -> d,
                   "Graph"  -> Graph[ DeleteDuplicates[ project /@ interval ], DeleteDuplicates @ Catenate @ Map[
                     v |-> DirectedEdge[ project @ v, project @ # ] & /@
                       Select[ AdjacencyList[ reduced, v ], TrueQ @ Lookup[ inside, Key @ # ] && ds[ # ] == ds[ v ] + 1 & ],
                     interval ] ] |> ] ],
            seam ] },
        #[ "Graph" ] & /@ Select[ atoms, #[ "Length" ] == Min[ #[ "Length" ] & /@ atoms ] & ] ],
      With[ { cutVs = VertexList @ cut },
        { cdm = If[ cutVs === { }, { }, GraphDistanceMatrix @ cut ],
          cidx = AssociationThread[ cutVs, Range @ Length @ cutVs ] },
        { cd = cdm[[ cidx @ #1, cidx @ #2 ]] & },
        { necklaces = Catenate @ Map[
            run |-> Map[
              pair |-> With[ { u = First @ pair, v = Last @ pair },
                { duv = cd[ Last @ pair, First @ pair ] },
                { support = If[ duv === Infinity, { }, Select[ cutVs, cd[ v, # ] + cd[ #, u ] == duv & ] ] },
                { inside = AssociationThread[ support, True ] },
                If[ duv === Infinity, Nothing,
                  <| "Length" -> Length @ run + duv + 1,
                     "Cycle"  -> Join[ run, FindShortestPath[ cut, v, u ] ],
                     "Graph"  -> Graph[ Join[ run, support, { { First @ run, 3/2 } } ],
                       Join[ DirectedEdge @@@ Partition[ Append[ run, v ], 2, 1 ],
                         Catenate @ Map[
                           w |-> DirectedEdge[ w, # ] & /@ Select[ AdjacencyList[ cut, w ],
                             TrueQ @ Lookup[ inside, Key @ # ] && cd[ v, # ] == cd[ v, w ] + 1 & ],
                           support ],
                         { DirectedEdge[ u, { First @ run, 3/2 } ] } ] ] |> ] ],
              If[ Length @ run == 1,
                Subsets[ Intersection[ AdjacencyList[ bandGraph, First @ run ], cutVs ], { 2 } ],
                Tuples[ Intersection[ AdjacencyList[ bandGraph, # ], cutVs ] & /@ { First @ run, Last @ run } ] ] ],
            Catenate @ Table[ Take[ seam, { i, j } ], { i, Length @ seam }, { j, i, Length @ seam } ] ] },
        Replace[
          Catch @ Scan[
            class |-> With[ { admissible = Select[ class, separatesQ @ #[ "Cycle" ] & ] },
              If[ admissible =!= { }, Throw[ #[ "Graph" ] & /@ admissible ] ] ],
            Values @ KeySort @ GroupBy[ necklaces, #[ "Length" ] & ] ],
          Null -> { } ] ] ] ]

InfraMeasurement[ graph_Graph, InfraCircle[ center_, rs : ( _?NumericQ | { _?NumericQ, _?NumericQ } ) ], "Faithful" ] :=
  With[ { dist = AssociationThread[ VertexList @ graph, GraphDistance[ graph, center ] ] },
    { rmin = Max[ 1, First @ Flatten @ { rs } ], rmax = Last @ Flatten @ { rs } },
    { local = Subgraph[ graph, Select[ VertexList @ graph, Lookup[ dist, Key @ # ] <= rmax + 1 & ] ] },
    { ends = SortBy[ Select[ VertexList @ local, Lookup[ dist, Key @ # ] > rmax & ], Lookup[ dist, Key @ # ] & ] },
    { radial = If[ ends === { }, { }, FindShortestPath[ local, center, First @ ends ] ] },
    { seam = Select[ radial, rmin <= Lookup[ dist, Key @ # ] <= rmax & ],
      bandGraph = Subgraph[ local, Select[ VertexList @ local, rmin <= Lookup[ dist, Key @ # ] <= rmax & ] ] },
    { cut = VertexDelete[ bandGraph, seam ],
      index = First /@ PositionIndex @ seam,
      attached = AssociationMap[ Complement[ AdjacencyList[ bandGraph, # ], seam ] &, seam ],
      separatesQ = cycle |-> AllTrue[ VertexComponent[ VertexDelete[ local, cycle ], center ], Lookup[ dist, Key @ # ] <= rmax & ] },
    { active = Select[ seam, attached[ # ] =!= { } & ] },
    { reference = AssociationMap[ First @ attached[ # ] &, active ] },
    { bank = If[ active === { } || ! ConnectedGraphQ @ cut, <| |>,
        With[ { flips = FoldList[
              { f, pair } |-> f If[ separatesQ @ Join[ Take[ seam, index /@ pair ],
                  FindShortestPath[ cut, reference @ Last @ pair, reference @ First @ pair ] ], -1, 1 ],
              1, Partition[ active, 2, 1 ] ] },
          Association @ MapThread[
            { x, f } |-> ( { x, # } -> f If[ # =!= reference @ x && separatesQ @ Prepend[ FindShortestPath[ cut, #, reference @ x ], x ], 1, -1 ] & /@
              attached @ x ),
            { active, flips } ] ] ] },
    If[ Length @ Union @ Values @ bank == 1, False, Undetermined ] ]

InfraMeasurement[ graph_Graph, obj : InfraCircle[ _, _ ], "VertexDensity" ] :=
  KeySort @ Merge[
    Map[
      dag |-> With[ { inNbr = GroupBy[ EdgeList @ dag, Last -> First ],
                      outNbr = GroupBy[ EdgeList @ dag, First -> Last ],
                      order = TopologicalSort @ dag,
                      sink = First @ Pick[ VertexList @ dag, VertexOutDegree @ dag, 0 ] },
        { alpha = Fold[ { a, w } |-> Append[ a, w -> Replace[ Lookup[ inNbr, Key @ w, { } ],
                { { } -> 1, ps_ :> Total @ Lookup[ a, Key /@ ps ] } ] ], <| |>, order ],
          beta = Fold[ { a, w } |-> Append[ a, w -> Replace[ Lookup[ outNbr, Key @ w, { } ],
                { { } -> 1, qs_ :> Total @ Lookup[ a, Key /@ qs ] } ] ], <| |>, Reverse @ order ] },
        AssociationMap[ Lookup[ alpha, Key @ # ] Lookup[ beta, Key @ # ] &, DeleteCases[ VertexList @ dag, sink ] ] ],
      InfraMeasurement[ graph, obj, "Graph" ] ],
    Total ]

InfraMeasurement[ graph_Graph, obj : InfraCircle[ _, _ ], "EdgeDensity" ] :=
  KeySort @ Merge[
    Map[
      dag |-> With[ { inNbr = GroupBy[ EdgeList @ dag, Last -> First ],
                      outNbr = GroupBy[ EdgeList @ dag, First -> Last ],
                      order = TopologicalSort @ dag,
                      source = First @ Pick[ VertexList @ dag, VertexInDegree @ dag, 0 ],
                      sink = First @ Pick[ VertexList @ dag, VertexOutDegree @ dag, 0 ] },
        { alpha = Fold[ { a, w } |-> Append[ a, w -> Replace[ Lookup[ inNbr, Key @ w, { } ],
                { { } -> 1, ps_ :> Total @ Lookup[ a, Key /@ ps ] } ] ], <| |>, order ],
          beta = Fold[ { a, w } |-> Append[ a, w -> Replace[ Lookup[ outNbr, Key @ w, { } ],
                { { } -> 1, qs_ :> Total @ Lookup[ a, Key /@ qs ] } ] ], <| |>, Reverse @ order ] },
        Association[ If[ Last @ # === sink, DirectedEdge[ First @ #, source ], # ] ->
          Lookup[ alpha, Key @ First @ # ] Lookup[ beta, Key @ Last @ # ] & /@ EdgeList @ dag ] ],
      InfraMeasurement[ graph, obj, "Graph" ] ],
    Total ]

InfraMemberQ[ graph_Graph, obj : InfraCircle[ _, _ ], path_List ] :=
  path =!= { } &&
  AnyTrue[ InfraMeasurement[ graph, obj, "Graph" ],
    dag |-> With[ { source = First @ Pick[ VertexList @ dag, VertexInDegree @ dag, 0 ],
                    sink = First @ Pick[ VertexList @ dag, VertexOutDegree @ dag, 0 ] },
      AnyTrue[
        Join[ NestList[ RotateLeft, path, Length @ path - 1 ],
              NestList[ RotateLeft, Reverse @ path, Length @ path - 1 ] ],
        rot |-> First @ rot === source && AllTrue[ Partition[ Append[ rot, sink ], 2, 1 ], EdgeQ[ dag, DirectedEdge @@ # ] & ] ] ] ]

FindInfraCycle[ graph_Graph, n : ( _Integer | UpTo[ _Integer ] | All ) : All ] :=
  FindInfraCycle[ graph, { 1, VertexCount[ graph ] }, n ]

FindInfraCycle[ graph_Graph, { k_Integer },
    n : ( _Integer | UpTo[ _Integer ] | All ) : All ] :=
  With[ { reps = Graph[ #, DirectedEdge @@@ Partition[ #, 2, 1, 1 ] ] & /@ ( First /@ # & /@ FindCycle[ graph, { k }, All ] ) },
    Switch[ n,
      All,   reps,
      _UpTo, Take[ reps, n ],
      _,     If[ Length @ reps < n, { }, Take[ reps, n ] ] ] ]

FindInfraCycle[ graph_Graph, { kMin_Integer, kMax_ },
    n : ( _Integer | UpTo[ _Integer ] | All ) : All ] :=
  With[ { cycles = SortBy[ Length ] @ Flatten[
        ( First /@ # & ) /@ FindCycle[ graph, { # }, All ] & /@
          Range[ kMin, Min[ kMax, VertexCount[ graph ] ] ], 1 ] },
    { reps = Graph[ #, DirectedEdge @@@ Partition[ #, 2, 1, 1 ] ] & /@ cycles },
    Switch[ n,
      All,   reps,
      _UpTo, Take[ reps, n ],
      _,     If[ Length @ reps < n, { }, Take[ reps, n ] ] ] ]

(* a metric circle iff consecutive vertices and the wrap-around are adjacent and the vertex set is a metric shell; a cycle graph is read as its
   closed walk *)

InfraCircleQ[ graph_Graph, ws : { __Graph } ] :=
  AllTrue[ ws, InfraCircleQ[ graph, # ] & ]

InfraCircleQ[ graph_Graph, w_Graph ] :=
  With[ { vs = VertexList @ w },
    { spelled = AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
      scan = v |-> Reap[ DepthFirstScan[ w, v, { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] },
    AllTrue[
      Which[
        ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w,
          { If[ First @ # === Last @ #, #, Append[ #, First @ # ] ] & @
              If[ spelled, Last /@ SortBy[ vs, First ], scan @ First @ vs ] },
        EdgeCount @ w == 0, List /@ If[ spelled, Last /@ vs, vs ],
        spelled,            { Last /@ SortBy[ vs, First ] },
        DirectedGraphQ @ w,
          Catenate @ Catenate @ Table[ FindPath[ w, s, t, Infinity, All ],
            { s, Select[ vs, VertexInDegree[ w, # ] == 0 & ] }, { t, Select[ vs, VertexOutDegree[ w, # ] == 0 & ] } ],
        True, { scan @ SelectFirst[ vs, VertexDegree[ w, # ] == 1 &, First @ vs ] } ],
      InfraCircleQ[ graph, # ] & ] ]

InfraCircleQ[ graph_Graph, cycle_List ] /; Length[ cycle ] >= 3 :=
  With[ {
      closed = If[ First @ cycle === Last @ cycle, cycle, Append[ cycle, First @ cycle ] ] },
    { verts = Most @ closed,
      pairs = Partition[ closed, 2, 1 ] },
    DuplicateFreeQ[ verts ] &&
    AllTrue[ pairs, EdgeQ[ graph, UndirectedEdge @@ # ] & ] &&
    InfraShellQ[ graph, verts ]
  ]

InfraCircleQ[ _Graph, cycle_List ] /; Length[ cycle ] < 3 :=
  False

FindInfraRepresentative[ graph_Graph, InfraCircle[ center_, rs : ( _?NumericQ | { _?NumericQ, _?NumericQ } ) ],
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, mods___ ] :=
  With[ { dist = AssociationThread[ VertexList @ graph, GraphDistance[ graph, center ] ] },
    { rmin = Max[ 1, First @ Flatten @ { rs } ], rmax = Last @ Flatten @ { rs } },
    { local = Subgraph[ graph, Select[ VertexList @ graph, Lookup[ dist, Key @ # ] <= rmax + 1 & ] ] },
    { bandGraph = Subgraph[ local, Select[ VertexList @ local, rmin <= Lookup[ dist, Key @ # ] <= rmax & ] ] },
    { circles = Replace[
        Catch @ Scan[
          k |-> With[ { found = Select[ First /@ # & /@ FindCycle[ bandGraph, { k }, All ],
                cycle |-> AllTrue[ VertexComponent[ VertexDelete[ local, cycle ], center ], Lookup[ dist, Key @ # ] <= rmax & ] ] },
            If[ found =!= { }, Throw @ found ] ],
          Range[ 3, VertexCount @ bandGraph ] ],
        Null -> { } ] },
    takeRepresentatives[ circles, count, mods ] ]
