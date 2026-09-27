Package["WolframInstitute`SyntheticInfrageometry`"]

(* WolframInstitute`SyntheticInfrageometry` :: EuclideanInfrageometry :: InfraSegment *)


(* ===================== InfraSegment ===================== *)

(* InfraSegment[p1, ..., pk] is inert: the polyline of the segments [p_i, p_(i+1)], k >= 2, and for k == 2 the segment itself.  Its graph is the interval DAG I(p, q) = { v : d(p, v) + d(v, q) == d(p, q) } with the arrows v -> w of rising d(p, .), whose chains are exactly the geodesics from p to q (design Thm. segment), and for a polyline the List of the pieces' DAGs, a member concatenating one chain per piece *)

InfraMeasurement[ graph_Graph,
    InfraSegment[ p : Except[ _Rule | _RuleDelayed ], q : Except[ _Rule | _RuleDelayed ] ], "Graph" ] :=
  With[ { dp = AssociationThread[ VertexList @ graph, GraphDistance[ graph, p ] ],
          dq = AssociationThread[ VertexList @ graph, GraphDistance[ graph, q ] ] },
    { d = Lookup[ dp, Key @ q ] },
    { interval = If[ d === Infinity, { },
        Select[ VertexList @ graph, Lookup[ dp, Key @ # ] + Lookup[ dq, Key @ # ] == d & ] ] },
    { inside = AssociationThread[ interval, True ] },
    Graph[ interval,
      Catenate @ Map[
        v |-> DirectedEdge[ v, # ] & /@ Select[ AdjacencyList[ graph, v ],
          TrueQ @ Lookup[ inside, Key @ # ] && Lookup[ dp, Key @ # ] == Lookup[ dp, Key @ v ] + 1 & ],
        interval ] ] ]

InfraMeasurement[ graph_Graph,
    InfraSegment[ pts : Repeated[ Except[ _Rule | _RuleDelayed ], { 3, Infinity } ] ], "Graph" ] :=
  InfraMeasurement[ graph, InfraSegment @@ #, "Graph" ] & /@ Partition[ { pts }, 2, 1 ]

(* a member of a polyline is one chain per piece, so the pieces are factors where the atoms of a line are alternatives *)

InfraMeasurement[ graph_Graph,
    InfraSegment[ pts : Repeated[ Except[ _Rule | _RuleDelayed ], { 3, Infinity } ] ], "Cardinality" ] :=
  Times @@ ( InfraMeasurement[ graph, InfraSegment @@ #, "Cardinality" ] & /@ Partition[ { pts }, 2, 1 ] )

InfraMeasurement[ graph_Graph,
    InfraSegment[ pts : Repeated[ Except[ _Rule | _RuleDelayed ], { 3, Infinity } ] ], "Length" ] :=
  Total[ GraphDistance[ graph, #1, #2 ] & @@@ Partition[ { pts }, 2, 1 ] ]

InfraVertexList[ graph_Graph,
    InfraSegment[ pts : Repeated[ Except[ _Rule | _RuleDelayed ], { 3, Infinity } ] ],
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, mods___ ] :=
  With[ { cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ] },
    { pieces = InfraVertexList[ graph, InfraSegment @@ #, If[ cap === Infinity, All, UpTo[ cap ] ], mods ] & /@
        Partition[ { pts }, 2, 1 ] },
    { members = Fold[ { as, bs } |-> Catenate @ Map[ a |-> ( Join[ a, Rest @ # ] & /@ bs ), as ],
        First @ pieces, Rest @ pieces ] },
    Switch[ count,
      Automatic, First[ members, { } ],
      All,       members,
      _UpTo,     Take[ members, count ],
      _,         If[ Length @ members < count, $Failed, Take[ members, count ] ] ] ]

(* the density counts members: a vertex on occ_i(v) chains of piece i lies on occ_i(v) times the product of the other pieces' counts, and an inner knot, which both pieces meeting there count, once less *)

InfraMeasurement[ graph_Graph,
    InfraSegment[ pts : Repeated[ Except[ _Rule | _RuleDelayed ], { 3, Infinity } ] ], "VertexDensity" ] :=
  With[ { pieces = InfraSegment @@@ Partition[ { pts }, 2, 1 ] },
    { counts = InfraMeasurement[ graph, #, "Cardinality" ] & /@ pieces },
    KeySort @ DeleteCases[ 0 ] @ Merge[
      Append[
        MapIndexed[ { piece, i } |-> ( Times @@ Delete[ counts, i ] ) InfraMeasurement[ graph, piece, "VertexDensity" ], pieces ],
        - ( Times @@ counts ) Counts @ Take[ { pts }, { 2, -2 } ] ],
      Total ] ]

InfraMeasurement[ graph_Graph,
    InfraSegment[ pts : Repeated[ Except[ _Rule | _RuleDelayed ], { 3, Infinity } ] ], "EdgeDensity" ] :=
  With[ { pieces = InfraSegment @@@ Partition[ { pts }, 2, 1 ] },
    { counts = InfraMeasurement[ graph, #, "Cardinality" ] & /@ pieces },
    KeySort @ DeleteCases[ 0 ] @ Merge[
      MapIndexed[ { piece, i } |-> ( Times @@ Delete[ counts, i ] ) InfraMeasurement[ graph, piece, "EdgeDensity" ], pieces ],
      Total ] ]

(* the knots cut the path at prescribed positions: every chain of the piece p_i -> p_(i+1) has length d(p_i, p_(i+1)) *)

InfraMemberQ[ graph_Graph,
    InfraSegment[ pts : Repeated[ Except[ _Rule | _RuleDelayed ], { 3, Infinity } ] ], path_List ] :=
  With[ { pieces = Partition[ { pts }, 2, 1 ] },
    { cuts = Accumulate @ Prepend[ GraphDistance[ graph, #1, #2 ] & @@@ pieces, 1 ] },
    Last @ cuts == Length @ path &&
      AllTrue[ Range @ Length @ pieces,
        i |-> InfraMemberQ[ graph, InfraSegment @@ pieces[[ i ]], Take[ path, { cuts[[ i ]], cuts[[ i + 1 ]] } ] ] ] ]


(* ===================== FindInfraSegment ===================== *)

(* a geodesic (p = v0, v1, ..., vk = q) with k = d(p, q), as a vertex list -- the substrate searched directly by FindPath, independently of the interval DAG.  The count-less call is one geodesic, a bounded count a List of them, All the whole class *)

FindInfraSegment[ graph_Graph, p_, q_,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic ] :=
  With[ { d = GraphDistance[ graph, p, q ],
          cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ] },
    { geodesics = Which[
        d === Infinity, { },
        d === 0,        { { p } },
        True,           FindPath[ graph, p, q, { d }, Replace[ cap, Infinity -> All ] ] ] },
    Switch[ count,
      Automatic, First[ geodesics, { } ],
      All,       geodesics,
      _UpTo,     Take[ geodesics, count ],
      _,         If[ Length @ geodesics < count, $Failed, Take[ geodesics, count ] ] ] ]


(* ===================== ExtendInfraSegment ===================== *)

(* the geodesics containing a geodesic bundle from p1 to p2, extended past its ends by at most kspec edges per free side and inextensible within that budget: kspec Infinity gives the lines through the bundle (FindInfraLine), kspec 0 the bundle itself.  The seed is a walk, a geodesic DAG extended as one object, or anything spreading to walks; the 6-ary form is Tarski A4 *)

ExtendInfraSegment::badproperty  = "Property `1` is not supported by ExtendInfraSegment; local rules on the extension moved to ExtendInfraGeodesic[graph, seed, scale, kspec].";
ExtendInfraSegment::badmethod    = "Method `1` is not supported by ExtendInfraSegment.";
ExtendInfraSegment::baddirection = "Direction `1` is not supported by ExtendInfraSegment.";

Options[ ExtendInfraSegment ] = {
  Properties  -> { },
  Method      -> Automatic,
  "Direction" -> "BothSides"
};

(* a bundle runs from p1 to p2.  Its candidate ends lie in the two extension graphs, and a pair (s, e) is admissible iff jointly geodesic -- d(s, e) == d(s, p1) + d(p1, p2) + d(p2, e), whichever geodesics are used -- with the larger layer passing kspec and each free side either at the budget or inextensible; its atom is I(p1, s) reversed, the bundle, and I(p2, e).  "Exhaustive" with All is the pool of atoms, and every bounded count streams geodesics off the admissible pairs in candidate ("Greedy", "Exhaustive") or random ("RandomGreedy") order, so the class is the same under every Method.  A substrate DAG or path graph is one bundle, and anything else -- a vertex list, a position-spelled walk -- spreads to its walks *)

ExtendInfraSegment[ graph_Graph, seed_,
    kspec : ( _Integer | UpTo[ _Integer ] | { _Integer } | { _Integer, _Integer } | Infinity ) : Infinity,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] :=
  Module[ { acc, descend },
    With[ {
        properties = OptionValue[ ExtendInfraSegment, { opts }, Properties ],
        method     = Replace[ OptionValue[ ExtendInfraSegment, { opts }, Method ],
                       { Automatic :> If[ count === All, "Exhaustive", "Greedy" ], { m_String, ___ } :> m } ],
        direction  = OptionValue[ ExtendInfraSegment, { opts }, "Direction" ],
        kmax   = Replace[ kspec, { { _, hi_ } :> hi, { k_ } :> k, UpTo[ k_ ] :> k } ],
        stepsQ = Replace[ kspec, { Infinity :> ( True & ), { k_ } :> ( # == k & ),
                                   { lo_, hi_ } :> ( lo <= # <= hi & ), UpTo[ k_ ] :> ( # <= k & ),
                                   k_Integer :> ( # <= k & ) } ],
        cap    = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ],
        spelledQ = w |-> AllTrue[ VertexList @ w, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ VertexList @ w ] === Range @ VertexCount @ w },
      { branch  = If[ method === "RandomGreedy", RandomSample, Identity ],
        walksOf = w |-> Which[
          spelledQ @ w,       { Last /@ SortBy[ VertexList @ w, First ] },
          EdgeCount @ w == 0, List /@ VertexList @ w,
          True, Catenate @ Catenate @ Table[ FindPath[ w, s, t, Infinity, All ],
            { s, Select[ VertexList @ w, VertexInDegree[ w, # ] == 0 & ] },
            { t, Select[ VertexList @ w, VertexOutDegree[ w, # ] == 0 & ] } ] ] },
      { bundles = Which[
          GraphQ @ seed && ! spelledQ @ seed,                        { seed },
          MatchQ[ seed, { __Graph } ] && NoneTrue[ seed, spelledQ ], seed,
          True, PathGraph[ #, DirectedEdges -> True ] & /@ Which[
            GraphQ @ seed,                 walksOf @ seed,
            MatchQ[ seed, { __Graph } ],   Catenate[ walksOf /@ seed ],
            AssociationQ @ seed,           Keys @ seed,
            seed === { },                  { },
            True,                          { seed } ] ] },
      descend[ e_, dag_, walk_ ] := (
        If[ Last @ walk === e, AppendTo[ acc, walk ]; If[ Length @ acc >= cap, Throw[ Null, descend ] ] ];
        If[ Last @ walk =!= e,
          Scan[ descend[ e, dag, Append[ walk, # ] ] &,
            branch @ DeleteCases[ VertexOutComponent[ dag, { Last @ walk }, 1 ], Last @ walk ] ] ] );
      Which[
        properties =!= { },
          Message[ ExtendInfraSegment::badproperty, properties ]; $Failed,
        ! MatchQ[ direction, "Forward" | "Backward" | "BothSides" ],
          Message[ ExtendInfraSegment::baddirection, direction ]; $Failed,
        ! MatchQ[ method, "Exhaustive" | "Greedy" | "RandomGreedy" ],
          Message[ ExtendInfraSegment::badmethod, method ]; $Failed,
        True,
          With[ { lines = DeleteDuplicates[ If[ GraphQ @ #, #, PathGraph[ #, DirectedEdges -> True ] ] & /@
              DeleteDuplicates @ Catenate[ Map[ bundle |-> If[ VertexCount @ bundle == 0, { },
                With[ {
                    p1 = First @ Select[ VertexList @ bundle, VertexInDegree[ bundle, # ] == 0 & ],
                    p2 = First @ Select[ VertexList @ bundle, VertexOutDegree[ bundle, # ] == 0 & ],
                    dm = GraphDistanceMatrix @ graph,
                    vidx = AssociationThread[ VertexList @ graph, Range @ VertexCount @ graph ] },
                  { dist = dm[[ vidx @ #1, vidx @ #2 ]] &,
                    leftExt  = GeodesicExtensionGraph[ graph, { p2, p1 } ],
                    rightExt = GeodesicExtensionGraph[ graph, { p1, p2 } ] },
                  { d = dist[ p1, p2 ],
                    pairs = Tuples[ {
                      If[ direction === "Forward",  { p1 }, Select[ VertexList @ leftExt,  dist[ p1, # ] <= kmax & ] ],
                      If[ direction === "Backward", { p2 }, Select[ VertexList @ rightExt, dist[ p2, # ] <= kmax & ] ] } ] },
                  { admissibleQ = { s, e } |-> dist[ s, e ] == dist[ s, p1 ] + d + dist[ p2, e ] &&
                      stepsQ @ Max[ dist[ p1, s ], dist[ p2, e ] ] &&
                      ( direction === "Forward"  || dist[ p1, s ] == kmax ||
                        NoneTrue[ AdjacencyList[ graph, s ], dist[ #, e ] == dist[ s, e ] + 1 & ] ) &&
                      ( direction === "Backward" || dist[ p2, e ] == kmax ||
                        NoneTrue[ AdjacencyList[ graph, e ], dist[ s, # ] == dist[ s, e ] + 1 & ] ),
                    atom = { s, e } |-> Graph @ Sort @ Join[
                      EdgeList @ ReverseGraph @ Subgraph[ leftExt,
                        Select[ VertexList @ leftExt, dist[ p1, # ] + dist[ #, s ] == dist[ p1, s ] & ] ],
                      EdgeList @ bundle,
                      EdgeList @ Subgraph[ rightExt,
                        Select[ VertexList @ rightExt, dist[ p2, # ] + dist[ #, e ] == dist[ p2, e ] & ] ] ] },
                  If[ method === "Exhaustive" && count === All,
                    atom @@@ Select[ pairs, admissibleQ @@ # & ],
                    acc = { };
                    Catch[
                      Scan[ Apply[ { s, e } |-> If[ admissibleQ[ s, e ],
                          With[ { dag = atom[ s, e ] },
                            If[ s =!= e && VertexQ[ dag, s ] && VertexQ[ dag, e ] && GraphDistance[ dag, s, e ] < Infinity,
                              descend[ e, dag, { s } ] ] ] ] ],
                        branch @ pairs ],
                      descend ];
                    acc ] ] ], bundles ] ] ] },
            Switch[ count,
              Automatic, First[ lines, { } ],
              All,       Replace[ lines, { one_Graph } :> one ],
              _UpTo,     Take[ lines, count ],
              _,         If[ Length @ lines < count, $Failed, Take[ lines, count ] ] ] ] ] ] ]


(* Tarski A4: find x with B(a, b, x) and d(b, x) == d(c, d); the last vertex slot excludes rules so an optioned 3-argument call never lands here *)

ExtendInfraSegment[ graph_Graph, a_, b_, c_, d : Except[ _Rule | _RuleDelayed ],
    count : ( _Integer | UpTo[ _Integer ] | All ) : All ] :=
  With[ { target = GraphDistance[ graph, c, d ] },
    { vs = If[ target === Infinity, { },
        Select[ VertexList[ graph ],
          x |-> BetweennessQ[ graph, a, b, x ] && GraphDistance[ graph, b, x ] === target ] ] },
    Switch[ count, All, vs, _UpTo, Take[ vs, count ], _, If[ Length @ vs < count, $Failed, Take[ vs, count ] ] ] ]


(* ===================== Scene-DSL constructor ===================== *)

(* inside a scene the head is the construction token and the scene engine binds its vertex sequences *)

dispatchConstruction[ graph_Graph, InfraSegment[ p1_, p2_, opts___Rule ] ] :=
  capBranches[
    applySelectOption[ graph, FindInfraSegment[ graph, p1, p2, All ],
      "Select" /. { opts } /. "Select" -> None,
      False, <| "Endpoints" -> { p1, p2 } |> ],
    extractBranches[ { opts } ] ]


(* ===================== InfraWalkQ ===================== *)

(* consecutive vertices adjacent, revisits allowed: InfraWalkQ superset InfraSegmentQ superset InfraLineQ *)

InfraWalkQ[ graph_Graph, ws : { __Graph } ] := AllTrue[ ws, InfraWalkQ[ graph, # ] & ]

InfraWalkQ[ graph_Graph, w_Graph ] :=
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
      InfraWalkQ[ graph, # ] & ] ]

InfraWalkQ[ graph_Graph, path_List ] /; Length[ path ] >= 2 :=
  AllTrue[ Partition[ path, 2, 1 ], EdgeQ[ graph, UndirectedEdge @@ # ] & ]

InfraWalkQ[ _Graph, path_List ] /; Length[ path ] < 2 := False


(* ===================== InfraSegmentQ ===================== *)

(* consecutive vertices adjacent and the total edge count equal to d(v0, vk); a graph -- one path or a DAG -- passes iff every walk it stands for does *)

InfraSegmentQ[ graph_Graph, ws : { __Graph } ] := AllTrue[ ws, InfraSegmentQ[ graph, # ] & ]

(* a family of instances, the shape FindInfraSegment[graph, p, q, n | UpTo[n] | All] returns *)
InfraSegmentQ[ graph_Graph, ws : { { ___ } .. } ] := AllTrue[ ws, InfraSegmentQ[ graph, # ] & ]

InfraSegmentQ[ graph_Graph, w_Graph ] :=
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
      InfraSegmentQ[ graph, # ] & ] ]

InfraSegmentQ[ graph_Graph, segment_List ] /; Length[ segment ] >= 2 :=
  GraphDistance[ graph, First[ segment ], Last[ segment ] ] == Length[ segment ] - 1 &&
  AllTrue[ Partition[ segment, 2, 1 ], EdgeQ[ graph, UndirectedEdge @@ # ] & ]

InfraSegmentQ[ _Graph, segment_List ] /; Length[ segment ] < 2 := False


(* ===================== UniqueInfraSegmentQ ===================== *)

(* a geodetic graph: every vertex pair admits a unique geodesic *)

UniqueInfraSegmentQ[ graph_Graph, u_, v_ ] := GeodesicMultiplicity[ graph, u, v ] == 1

UniqueInfraSegmentQ[ graph_Graph ] :=
  AllTrue[ Subsets[ VertexList[ graph ], { 2 } ],
    pair |-> UniqueInfraSegmentQ[ graph, pair[[ 1 ]], pair[[ 2 ]] ] ]
