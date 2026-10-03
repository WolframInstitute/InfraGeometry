Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraCircle *)

(* InfraCircle[c, r] and InfraCircle[c, {r, s}] are inert: the circles of the band W = { v : r <= d(c, v) <= s } around c, scalar r meaning {r, r}, a
   circle being a shortest cycle of the band graph A = G[W] whose removal leaves c in a component that reaches no further than s.  Its graph is the
   List of necklaces of a radial seam sigma -- the band part of a geodesic from c to just outside the band.  On a run S = (s1, ..., sm) of sigma the
   necklace N(S, u, v), with u ~ s1 and v ~ sm in one component of the cut band A - V(sigma), is s1 -> ... -> sm -> v together with the interval DAG
   of the cut band from v to u; its closing arrow u -> s1 is left out, so it is a DAG whose chains are exactly the cycles S v gamma u, all of the one
   length m + 1 + d(v, u) (design Thm. seam).  Kept are the necklaces of least length among those whose cycles separate.  Their cycles always
   separate, and they are every circle exactly once under the winding functional (W) and the one-run hypothesis (T), which the head does not
   certify -- hence "Faithful" -> Undetermined.  Runs are read in seam order alone, which is what picks one of the two orientations of each cycle.
   The circle through a point is the closed arc InfraArc[c, {p, p}] *)

InfraMeasurement[ graph_Graph, InfraCircle[ center_, rs : ( _?NumericQ | { _?NumericQ, _?NumericQ } ) ], "Graph" ] :=
  With[ { dist = AssociationThread[ VertexList @ graph, GraphDistance[ graph, center ] ] },
    { rmin = Max[ 1, First @ Flatten @ { rs } ], rmax = Last @ Flatten @ { rs } },
    { local = Subgraph[ graph, Select[ VertexList @ graph, Lookup[ dist, Key @ # ] <= rmax + 1 & ] ] },
    { ends = SortBy[ Select[ VertexList @ local, Lookup[ dist, Key @ # ] > rmax & ], Lookup[ dist, Key @ # ] & ] },
    { radial = If[ ends === { }, { }, FindShortestPath[ local, center, First @ ends ] ] },
    { seam = Select[ radial, rmin <= Lookup[ dist, Key @ # ] <= rmax & ],
      bandGraph = Subgraph[ local, Select[ VertexList @ local, rmin <= Lookup[ dist, Key @ # ] <= rmax & ] ] },
    { cut = VertexDelete[ bandGraph, seam ] },
    { cutVs = VertexList @ cut },
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
                 "Graph"  -> Graph[ Join[ run, support ],
                   Join[ DirectedEdge @@@ Partition[ Append[ run, v ], 2, 1 ],
                     Catenate @ Map[
                       w |-> DirectedEdge[ w, # ] & /@ Select[ AdjacencyList[ cut, w ],
                         TrueQ @ Lookup[ inside, Key @ # ] && cd[ v, # ] == cd[ v, w ] + 1 & ],
                       support ] ] ] |> ] ],
          If[ Length @ run == 1,
            Subsets[ Intersection[ AdjacencyList[ bandGraph, First @ run ], cutVs ], { 2 } ],
            Tuples[ Intersection[ AdjacencyList[ bandGraph, # ], cutVs ] & /@ { First @ run, Last @ run } ] ] ],
        Catenate @ Table[ Take[ seam, { i, j } ], { i, Length @ seam }, { j, i, Length @ seam } ] ] },
    Replace[
      Catch @ Scan[
        class |-> With[ { admissible = Select[ class,
              necklace |-> AllTrue[ VertexComponent[ VertexDelete[ local, necklace[ "Cycle" ] ], center ],
                Lookup[ dist, Key @ # ] <= rmax & ] ] },
          If[ admissible =!= { }, Throw[ #[ "Graph" ] & /@ admissible ] ] ],
        Values @ KeySort @ GroupBy[ necklaces, #[ "Length" ] & ] ],
      Null -> { } ] ]

InfraMeasurement[ graph_Graph, obj : InfraCircle[ _, _ ], "Length" ] :=
  Replace[
    Union @@ Map[
      dag |-> DeleteCases[ Infinity ] @ Union @ Flatten @ Table[ 1 + GraphDistance[ dag, s, t ],
          { s, Pick[ VertexList @ dag, VertexInDegree @ dag, 0 ] },
          { t, Pick[ VertexList @ dag, VertexOutDegree @ dag, 0 ] } ],
      InfraMeasurement[ graph, obj, "Graph" ] ],
    { one_ } :> one ]

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
        Append[
          Association[ # -> Lookup[ alpha, Key @ First @ # ] Lookup[ beta, Key @ Last @ # ] & /@ EdgeList @ dag ],
          DirectedEdge[ sink, source ] -> Lookup[ alpha, Key @ sink ] ] ],
      InfraMeasurement[ graph, obj, "Graph" ] ],
    Total ]

InfraMemberQ[ graph_Graph, obj : InfraCircle[ _, _ ], path_List ] :=
  path =!= { } &&
  AnyTrue[ InfraMeasurement[ graph, obj, "Graph" ],
    dag |-> AnyTrue[
      Join[ NestList[ RotateLeft, path, Length @ path - 1 ],
            NestList[ RotateLeft, Reverse @ path, Length @ path - 1 ] ],
      rot |-> VertexQ[ dag, First @ rot ] && VertexInDegree[ dag, First @ rot ] == 0 &&
        VertexQ[ dag, Last @ rot ] && VertexOutDegree[ dag, Last @ rot ] == 0 &&
        AllTrue[ Partition[ rot, 2, 1 ], EdgeQ[ dag, DirectedEdge @@ # ] & ] ] ]

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
