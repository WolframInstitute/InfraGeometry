Package["WolframInstitute`InfraGeometry`"]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraLine *)

(* InfraLine[p, q] is inert: the line through p and q.  Its graph is the List of atoms K_{a, b} = I(a, p) union I(p, q) union I(q, b), one per pair of ends compatible with (p, q) -- d(a, b) == d(a, p) + d(p, q) + d(q, b) -- and maximal -- no neighbour of a or of b lengthens d(a, b).  The chains of K_{a, b} are exactly the inextensible geodesics from a to b through p and then q, and every such geodesic is a chain of exactly one atom, while the union of the atoms is not faithful (design Thm. line).  InfraLine[p, p] is every maximal geodesic through p, once per orientation *)

InfraMeasurement[ graph_Graph,
    InfraLine[ p : Except[ _Rule | _RuleDelayed ], q : Except[ _Rule | _RuleDelayed ] ], "Graph" ] :=
  With[ { vs = VertexList @ graph, dm = GraphDistanceMatrix @ graph },
    { idx = AssociationThread[ vs, Range @ Length @ vs ] },
    { dist = dm[[ idx @ #1, idx @ #2 ]] & },
    { d = dist[ p, q ] },
    { pairs = If[ d === Infinity, { },
        Select[
          Tuples @ { Select[ vs, dist[ #, q ] == dist[ #, p ] + d & ],
                     Select[ vs, dist[ p, # ] == d + dist[ q, # ] & ] },
          Apply[ { a, b } |->
            dist[ a, b ] == dist[ a, p ] + d + dist[ q, b ] &&
            NoneTrue[ AdjacencyList[ graph, a ], dist[ #, b ] > dist[ a, b ] & ] &&
            NoneTrue[ AdjacencyList[ graph, b ], dist[ a, # ] > dist[ a, b ] & ] ] ] ] },
    Map[
      Apply[ { a, b } |-> With[ {
            support = Select[ vs,
              dist[ a, # ] + dist[ #, p ] == dist[ a, p ] ||
              dist[ p, # ] + dist[ #, q ] == d ||
              dist[ q, # ] + dist[ #, b ] == dist[ q, b ] & ] },
          { inside = AssociationThread[ support, True ] },
          Graph[ support,
            Catenate @ Map[
              v |-> DirectedEdge[ v, # ] & /@ Select[ AdjacencyList[ graph, v ],
                TrueQ @ Lookup[ inside, Key @ # ] && dist[ a, # ] == dist[ a, v ] + 1 & ],
              support ] ] ] ],
      pairs ] ]

FindInfraLine[ graph_Graph, p : Except[ _Rule | _RuleDelayed ], q : Except[ _Rule | _RuleDelayed ],
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic ] /;
    ! ListQ[ p ] || VertexQ[ graph, p ] :=
  With[ { cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ] },
    { lines = Fold[
        { found, seed } |-> If[ Length @ found >= cap, found,
          Join[ found,
            FindInfraLine[ graph, seed, If[ cap === Infinity, All, UpTo[ cap - Length @ found ] ] ] ] ],
        { }, FindInfraSegment[ graph, p, q, If[ cap === Infinity, All, UpTo[ cap ] ] ] ] },
    Switch[ count,
      Automatic, First[ lines, { } ],
      All,       lines,
      _UpTo,     Take[ lines, count ],
      _,         If[ Length @ lines < count, $Failed, Take[ lines, count ] ] ] ]

FindInfraLine[ graph_Graph, seq_List,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic ] /;
    seq =!= { } && ! VertexQ[ graph, seq ] :=
  Module[ { acc = { }, back, front },
    With[ { cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ],
            vs = VertexList @ graph, dm = GraphDistanceMatrix @ graph },
      { idx = AssociationThread[ vs, Range @ Length @ vs ] },
      { dist = dm[[ idx @ #1, idx @ #2 ]] & },
      front[ path_ ] := With[ { nexts = Sort @ Select[ AdjacencyList[ graph, Last @ path ],
            dist[ First @ path, # ] == Length @ path & ] },
        If[ nexts === { },
          If[ NoneTrue[ AdjacencyList[ graph, First @ path ], dist[ #, Last @ path ] == Length @ path & ],
            AppendTo[ acc, path ]; If[ Length @ acc >= cap, Throw[ Null, front ] ] ],
          Scan[ front[ Append[ path, # ] ] &, nexts ] ] ];
      back[ path_ ] := ( front @ path;
        Scan[ back[ Prepend[ path, # ] ] &,
          Sort @ Select[ AdjacencyList[ graph, First @ path ], dist[ #, Last @ path ] == Length @ path & ] ] );
      Catch[ back @ seq; Null, front ];
      Switch[ count,
        Automatic, First[ acc, { } ],
        All,       acc,
        _UpTo,     Take[ acc, count ],
        _,         If[ Length @ acc < count, $Failed, Take[ acc, count ] ] ] ] ]

(* a parallel to line through p: an inextensible geodesic s ... p ... e of graph inside the level set L = { v : d(v, line) == r }, r = d(p, line) -- d(s, e) == d(s, p) + d(p, e), every vertex in L, and no neighbour of s or e in L prolonging it.  The pool is one geodesic DAG per admissible end pair (s, e): the s -> p and p -> e intervals cut down to L and glued at p, oriented so that s precedes e in canonical order.  One class under every Method -- "Exhaustive" with All returns the pool itself, as FindInfraLine does, and a bounded count streams geodesics off the atoms in candidate ("Greedy", "Exhaustive") or random ("RandomGreedy") order *)

FindInfraParallel::badmethod   = "Method `1` is not supported by FindInfraParallel.";
FindInfraParallel::badproperty = "Property `1` is not supported by FindInfraParallel (FindInfraParallel accepts only Properties -> {}).";

Options[ FindInfraParallel ] = {
  Properties -> { },
  Method     -> Automatic
};

FindInfraParallel[ graph_Graph, line_, p_,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] :=
  Module[ { found, descend },
    descend[ out_, pick_, limit_, path_ ] := With[ { nexts = Lookup[ out, Key @ Last @ path, { } ] },
      If[ nexts === { },
        ( AppendTo[ found, path ]; If[ Length @ found >= limit, Throw[ found, descend ] ] ),
        Scan[ descend[ out, pick, limit, Append[ path, # ] ] &, pick @ nexts ] ] ];
    With[ {
        walksOf = w |-> With[ { vs = VertexList @ w },
          { spelled = AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
            scan = v |-> Reap[ DepthFirstScan[ w, v, { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] },
          Which[
            ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w,
              { If[ First @ # === Last @ #, #, Append[ #, First @ # ] ] & @
                  If[ spelled, Last /@ SortBy[ vs, First ], scan @ First @ vs ] },
            EdgeCount @ w == 0, List /@ If[ spelled, Last /@ vs, vs ],
            spelled || DirectedGraphQ @ w,
              If[ spelled, Map[ Last, #, { 2 } ], # ] & @ Catenate @ Catenate @ Table[ FindPath[ w, s, t, Infinity, All ],
                { s, Select[ vs, VertexInDegree[ w, # ] == 0 & ] }, { t, Select[ vs, VertexOutDegree[ w, # ] == 0 & ] } ],
            True, { scan @ SelectFirst[ vs, VertexDegree[ w, # ] == 1 &, First @ vs ] } ] ] },
      { results = ( { line0, p0 } |-> Catch @ With[ {
            properties = OptionValue[ FindInfraParallel, { opts }, Properties ],
            methodHead = Replace[ OptionValue[ FindInfraParallel, { opts }, Method ],
                           { Automatic :> If[ count === All, "Exhaustive", "Greedy" ], { m_String, ___ } :> m } ],
            verts = VertexList @ graph },
          If[ properties =!= { }, Message[ FindInfraParallel::badproperty, properties ]; Throw[ $Failed ] ];
          If[ ! MatchQ[ methodHead, "Exhaustive" | "Greedy" | "RandomGreedy" ],
            Message[ FindInfraParallel::badmethod, methodHead ]; Throw[ $Failed ] ];
          With[ { dm = GraphDistanceMatrix[ graph ], vidx = AssociationThread[ verts, Range @ Length @ verts ] },
            { dist = dm[[ vidx @ #1, vidx @ #2 ]] &,
              lineDist = Min @ dm[[ vidx @ #, vidx /@ line0 ]] & },
            { r = lineDist @ p0 },
            If[ r === Infinity, { },
              With[ { level = Select[ verts, lineDist @ # == r & ] },
                { admissibleQ = { s, e } |-> Order[ s, e ] == 1 && dist[ s, e ] < Infinity &&
                    dist[ s, e ] == dist[ s, p0 ] + dist[ p0, e ] &&
                    NoneTrue[ AdjacencyList[ graph, s ], MemberQ[ level, # ] && dist[ #, e ] == dist[ s, e ] + 1 & ] &&
                    NoneTrue[ AdjacencyList[ graph, e ], MemberQ[ level, # ] && dist[ s, # ] == dist[ s, e ] + 1 & ],
                  atom = { s, e } |-> With[ { dag = Graph[ { s, e }, Join[
                        EdgeList @ Subgraph[ #, Intersection[ VertexList @ #, level ] ] & @ SegmentGraph[ graph, s, p0 ],
                        EdgeList @ Subgraph[ #, Intersection[ VertexList @ #, level ] ] & @ SegmentGraph[ graph, p0, e ] ] ] },
                      Subgraph[ dag, Intersection[ VertexOutComponent[ dag, s ], VertexInComponent[ dag, e ] ] ] ],
                  cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ],
                  branch = If[ methodHead === "RandomGreedy", RandomSample, Identity ] },
                If[ methodHead === "Exhaustive" && count === All,
                  Select[ atom @@@ Select[ Tuples[ { level, level } ], admissibleQ @@ # & ],
                    VertexCount[ # ] > 0 & ],
                  Fold[ { acc, pair } |-> If[ Length @ acc >= cap || ! admissibleQ @@ pair, acc,
                      Join[ acc, With[ { dag = atom @@ pair }, Which[
                        VertexCount @ dag == 0, { },
                        cap === Infinity,
                          Catenate @ Catenate @ Table[ FindPath[ dag, s, t, Infinity, All ],
                            { s, Select[ VertexList @ dag, VertexInDegree[ dag, # ] == 0 & ] },
                            { t, Select[ VertexList @ dag, VertexOutDegree[ dag, # ] == 0 & ] } ],
                        True,
                          found = { };
                          Catch[
                            Scan[ descend[ GroupBy[ List @@@ EdgeList @ dag, First -> Last ], branch, cap - Length @ acc, { # } ] &,
                              branch @ Select[ VertexList @ dag, VertexInDegree[ dag, # ] == 0 & ] ];
                            found, descend ] ] ] ] ],
                    { }, branch @ Tuples[ { level, level } ] ] ] ] ] ] ] ) @@@
          Tuples[ {
            Which[
              AssociationQ @ line, Keys @ line,
              GraphQ @ line, walksOf @ line,
              MatchQ[ line, { __Graph } ], Catenate[ walksOf /@ line ],
              line === { }, { },
              True, { line } ],
            Keys @ InfraDensity[ graph, p ] } ] },
      If[ MemberQ[ results, $Failed ], $Failed,
        With[ { parallels = DeleteDuplicates[ If[ GraphQ @ #, #, PathGraph[ #, DirectedEdges -> True ] ] & /@
            DeleteDuplicates @ Flatten[ results, 1 ] ] },
          Switch[ count,
            Automatic, First[ parallels, { } ],
            All,       Replace[ parallels, { one_Graph } :> one ],
            _UpTo,     Take[ parallels, count ],
            _,         If[ Length @ parallels < count, $Failed, Take[ parallels, count ] ] ] ] ] ] ]

(* ===================== Sketch: Method dispatch (NOT WIRED) =====================
   Two honest, computable parallelism criteria; see Wiki/Concepts/Parallelism.md
   for the design rationale.

     (E) Equidistant   -- the current implementation (level-set construction).
                          phi_{L1}(v) := Min[d(v, u) : u in L1] is constant on L2.
                          A Euclidean *theorem* used as a graph *definition*.

     (T) Transversal   -- Euclid I.27 / I.29. Pick the shortest path t between
                          L1 and L2; the angle t makes with L1 at its L1-end
                          equals the angle t makes with L2 at its L2-end.

   Planned signature:

     Method -> "Equidistant" (default, current behaviour) |
               "Transversal" (Euclid I.27)

   InfraParallelQ would gain a _Graph overload because the transversal test
   needs the graph itself, not just the distance matrix.

   Sketch of the transversal branch (Euclid I.27, alternate-angle equality):

     findTransversalParallel[ graph_Graph, line_List, p_ ] :=
       Module[ { pencil, lineDist = v |-> Min[ GraphDistance[ graph, v, # ] & /@ line ] },
         pencil = #[[ 1, 1 ]] & /@ FindInfraLine[ graph, p, All ];
         Select[ pencil, candidate |->
           DisjointQ[ candidate, line ] &&
           transversalAngleEqualQ[ graph, line, candidate ] ]
       ]

     transversalAngleEqualQ[ graph_Graph, l1_List, l2_List ] :=
       Module[ { dm, minPair, a, b, ap, bp, alpha, beta },
         dm = Outer[ GraphDistance[ graph, #1, #2 ] &, l1, l2 ];
         minPair = First @ Position[ dm, Min @@ Flatten @ dm ];
         a  = l1[[ minPair[[ 1 ]] ]];
         b  = l2[[ minPair[[ 2 ]] ]];
         ap = l1[[ If[ minPair[[ 1 ]] == Length[ l1 ],
                       minPair[[ 1 ]] - 1, minPair[[ 1 ]] + 1 ] ]];
         bp = l2[[ If[ minPair[[ 2 ]] == Length[ l2 ],
                       minPair[[ 2 ]] - 1, minPair[[ 2 ]] + 1 ] ]];
         alpha = InfraAngle[ graph, { ap, a, b } ];
         beta  = InfraAngle[ graph, { bp, b, a } ];
         alpha == beta
       ]

   Edge cases to settle on implementation:
     - Non-unique shortest transversal: require equality for all of them.
     - Orientation of {ap, bp} ("same side of the transversal"): the discrete
       analogue of Euclid's "alternate interior" is unresolved. Provisional
       choice in the sketch: pick the unique next-along-line vertex.
     - Lines of length 1 (no a' / b'): skip the anchor and try the next pair.
     - alpha == beta is a number equality with InfraAngle's "Arclength" measure;
       a tolerance form alpha - beta is below threshold may be wanted.

   Worked numbers in Wiki/Concepts/Parallelism.md:
     - GridGraph[{6,6}], L1 = {1..6}, L2 = {7..12}:
         (E) True; alpha = beta = 2  --> (T) True. Both agree.
     - PetersenGraph[], L1 = {1, 4, 2}, L2 = {3, 8, 7}:
         (E) False; alpha = beta = 3  --> (T) True. The criteria diverge.

   ============================================================================= *)

FindInfraPerpendicular::badmethod = "Method `1` is not supported by FindInfraPerpendicular.";

Options[ FindInfraPerpendicular ] = {
  Method   -> "Metric",
  "Radius" -> All
};

FindInfraPerpendicular[ graph_Graph, line_, point_,
    count : ( _Integer | UpTo[ _Integer ] | All ) : All, opts : OptionsPattern[] ] :=
  With[ {
      walksOf = w |-> With[ { vs = VertexList @ w },
          { spelled = AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
            scan = v |-> Reap[ DepthFirstScan[ w, v, { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] },
          Which[
            ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w,
              { If[ First @ # === Last @ #, #, Append[ #, First @ # ] ] & @
                  If[ spelled, Last /@ SortBy[ vs, First ], scan @ First @ vs ] },
            EdgeCount @ w == 0, List /@ If[ spelled, Last /@ vs, vs ],
            spelled || DirectedGraphQ @ w,
              If[ spelled, Map[ Last, #, { 2 } ], # ] & @ Catenate @ Catenate @ Table[ FindPath[ w, s, t, Infinity, All ],
                { s, Select[ vs, VertexInDegree[ w, # ] == 0 & ] }, { t, Select[ vs, VertexOutDegree[ w, # ] == 0 & ] } ],
            True, { scan @ SelectFirst[ vs, VertexDegree[ w, # ] == 1 &, First @ vs ] } ] ] },
    { results = ( { line0, point0 } |-> With[ {
          spec   = OptionValue[ FindInfraPerpendicular, { opts }, Method   ],
          radius = OptionValue[ FindInfraPerpendicular, { opts }, "Radius" ] },
        { workGraph = If[ radius === All, graph, NeighborhoodGraph[ graph, point0, radius ] ] },
        (* the LONGEST lines through a segment: each side extended independently, joint geodesicity d(s, e) == d(s, p1) + d + d(p2, e), and only the maxima of d(s, p1) + d(p2, e) kept *)
        { extensions = segment |-> If[ Length[ segment ] < 2, { segment },
            With[ { p1 = First[ segment ], p2 = Last[ segment ], verts = VertexList[ workGraph ] },
              (* one compiled all-pairs matrix: the pair enumeration is quadratic, and per-pair GraphDistance re-ran a BFS each time *)
              { dm = GraphDistanceMatrix[ workGraph ],
                vidx = AssociationThread[ verts, Range @ Length @ verts ] },
              { d1 = dm[[ vidx[ p1 ] ]], d2 = dm[[ vidx[ p2 ] ]] },
              { d = d1[[ vidx[ p2 ] ]] },
              { maxPairs = MaximalBy[
                  Select[ Tuples[ {
                      Select[ verts, c |-> d1[[ vidx[ c ] ]] + d == d2[[ vidx[ c ] ]] ],
                      Select[ verts, c |-> d2[[ vidx[ c ] ]] + d == d1[[ vidx[ c ] ]] ] } ],
                    pair |-> dm[[ vidx[ pair[[ 1 ]] ], vidx[ pair[[ 2 ]] ] ]] ==
                             d1[[ vidx[ pair[[ 1 ]] ] ]] + d + d2[[ vidx[ pair[[ 2 ]] ] ]] ],
                  d1[[ vidx[ #[[ 1 ]] ] ]] + d2[[ vidx[ #[[ 2 ]] ] ]] & ] },
              If[ maxPairs === { } || maxPairs === { { p1, p2 } }, { segment },
                Catenate[
                  With[ { s = #[[ 1 ]], e = #[[ 2 ]] },
                    { db = d1[[ vidx[ s ] ]], da = d2[[ vidx[ e ] ]] },
                    { bp = If[ db == 0, { {} }, Most /@ FindPath[ workGraph, s, p1, { db }, All ] ],
                      ap = If[ da == 0, { {} }, Rest /@ FindPath[ workGraph, p2, e, { da }, All ] ] },
                    Flatten[ Outer[ Join[ #1, segment, #2 ] &, bp, ap, 1 ], 1 ]
                  ] & /@ maxPairs ] ] ] ],
          canonical = l |-> First @ Sort @ { l, Reverse[ l ] } },
        Switch[ Replace[ spec, { m_String, ___ } :> m ],
          "Metric",
            With[ { localLine = Select[ line0, MemberQ[ VertexList[ workGraph ], # ] & ] },
              { distances = GraphDistance[ workGraph, point0, # ] & /@ localLine },
              { feet = DeleteCases[ DeleteDuplicates @ Flatten[
                  ( group |-> Map[
                      pair |-> With[ { lo = Min @@ pair, hi = Max @@ pair },
                        localLine[[ lo ;; hi ]][[ Ceiling[ ( hi - lo + 1 ) / 2 ] ]] ],
                      Subsets[ group, { 2 } ] ]
                  ) /@ Values @ GroupBy[ Range @ Length @ localLine, distances[[ # ]] & ],
                  1 ], point0 ] },
              Select[
                DeleteDuplicates @ Map[ canonical, Catenate[
                  Map[ foot |-> Catenate[ extensions /@
                      With[ { d = GraphDistance[ workGraph, foot, point0 ] },
                        If[ d === Infinity, { }, FindPath[ workGraph, foot, point0, { d }, All ] ] ] ],
                    feet ] ] ],
                Length[ # ] >= 2 & ] ],
          "Projection" | "Coordinate" | "Arclength" | "Alexandrov",
            Select[
              DeleteDuplicates @ Map[ canonical, Catenate[
                Map[ neighbor |-> extensions @ { point0, neighbor }, AdjacencyList[ workGraph, point0 ] ] ] ],
              InfraPerpendicularQ[ graph, line0, #, Method -> spec, "Radius" -> radius ] & ],
          _, Message[ FindInfraPerpendicular::badmethod, spec ]; $Failed
        ] ] ) @@@
      Tuples[ {
        Which[
          AssociationQ @ line, Keys @ line,
          GraphQ @ line, walksOf @ line,
          MatchQ[ line, { __Graph } ], Catenate[ walksOf /@ line ],
          line === { }, { },
          True, { line } ],
        Keys @ InfraDensity[ graph, point ] } ] },
    If[ MemberQ[ results, $Failed ], $Failed,
      With[ { perpendiculars = DeleteDuplicates[ PathGraph[ #, DirectedEdges -> True ] & /@ DeleteDuplicates @ Flatten[ results, 1 ] ] },
        Switch[ count,
          All,   Replace[ perpendiculars, { one_Graph } :> one ],
          _UpTo, Take[ perpendiculars, count ],
          _,     If[ Length @ perpendiculars < count, $Failed, Take[ perpendiculars, count ] ] ] ] ] ]

FindInfraCommonLine[ graph_Graph, verts_List,
    count : ( _Integer | UpTo[ _Integer ] | All ) : All ] :=
  With[ { spelledQ = w |-> AllTrue[ VertexList @ w, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ VertexList @ w ] === Range @ VertexCount @ w },
    { uverts = DeleteDuplicates @ Catenate[ Map[ x |-> Which[
          AssociationQ @ x,                  Keys @ x,
          MatchQ[ x, _Graph | { __Graph } ], Union @@ ( If[ spelledQ @ #, Last /@ VertexList @ #, VertexList @ # ] & /@ Flatten[ { x } ] ),
          MatchQ[ x, { __List } ],           Union @@ x,
          ListQ @ x,                         Union @ x,
          True,                              { x } ], verts ] ] },
    { common = If[ Length[ uverts ] < 2, { },
        DeleteDuplicates @ Select[
          ( l |-> First @ Sort @ { l, Reverse[ l ] } ) /@
            FindInfraLine[ graph, First @ uverts, uverts[[ 2 ]], All ],
          line |-> SubsetQ[ line, uverts ] ] ] },
    { lines = DeleteDuplicates[ PathGraph[ #, DirectedEdges -> True ] & /@ common ] },
    Switch[ count,
      All,   Replace[ lines, { one_Graph } :> one ],
      _UpTo, Take[ lines, count ],
      _,     If[ Length @ lines < count, $Failed, Take[ lines, count ] ] ] ]

InfraLineQ[ graph_Graph, ws : { __Graph } ] := AllTrue[ ws, InfraLineQ[ graph, # ] & ]

InfraLineQ[ graph_Graph, ws : { { ___ } .. } ] := AllTrue[ ws, InfraLineQ[ graph, # ] & ]

InfraLineQ[ graph_Graph, w_Graph ] :=
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
      InfraLineQ[ graph, # ] & ] ]

InfraLineQ[ graph_Graph, segment_List ] /; Length[ segment ] >= 2 :=
  InfraSegmentQ[ graph, segment ] &&
  NoneTrue[ AdjacencyList[ graph, First @ segment ], GraphDistance[ graph, #, Last @ segment ] == Length[ segment ] & ] &&
  NoneTrue[ AdjacencyList[ graph, Last @ segment ], GraphDistance[ graph, First @ segment, # ] == Length[ segment ] & ]

InfraLineQ[ _Graph, segment_List ] /; Length[ segment ] < 2 := False

(* l1, l2 disjoint and d(v, l2) constant over v in l1, up to threshold *)

InfraParallelQ[ distanceMatrix_List, l1_List, l2_List, threshold_ : 0 ] :=
  If[ IntersectingQ[ l1, l2 ], False,
    With[ { lineDistances = Min[ distanceMatrix[[ #, l2 ]] ] & /@ l1 },
      Max[ lineDistances ] - Min[ lineDistances ] <= threshold ]
  ]

InfraParallelQ[ graph_Graph, l1_List, l2_List, threshold_ : 0 ] :=
  If[ IntersectingQ[ l1, l2 ], False,
    With[ { lineDistances = Table[ Min[ GraphDistance[ graph, v, # ] & /@ l2 ], { v, l1 } ] },
      Max[ lineDistances ] - Min[ lineDistances ] <= threshold ]
  ]

InfraParallelQ[ graph_Graph,
    l1 : _Graph | { __Graph } | _List,
    l2 : _Graph | { __Graph } | _List,
    threshold_ : 0 ] /; ! MatchQ[ { l1, l2 }, { Except[ { __Graph }, _List ], Except[ { __Graph }, _List ] } ] :=
  With[ {
      walksOf = w |-> With[ { vs = VertexList @ w },
          { spelled = AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
            scan = v |-> Reap[ DepthFirstScan[ w, v, { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] },
          Which[
            ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w,
              { If[ First @ # === Last @ #, #, Append[ #, First @ # ] ] & @
                  If[ spelled, Last /@ SortBy[ vs, First ], scan @ First @ vs ] },
            EdgeCount @ w == 0, List /@ If[ spelled, Last /@ vs, vs ],
            spelled || DirectedGraphQ @ w,
              If[ spelled, Map[ Last, #, { 2 } ], # ] & @ Catenate @ Catenate @ Table[ FindPath[ w, s, t, Infinity, All ],
                { s, Select[ vs, VertexInDegree[ w, # ] == 0 & ] }, { t, Select[ vs, VertexOutDegree[ w, # ] == 0 & ] } ],
            True, { scan @ SelectFirst[ vs, VertexDegree[ w, # ] == 1 &, First @ vs ] } ] ] },
    { reps1 = If[ MatchQ[ l1, _Graph | { __Graph } ], Catenate[ walksOf /@ Flatten[ { l1 } ] ], { l1 } ],
      reps2 = If[ MatchQ[ l2, _Graph | { __Graph } ], Catenate[ walksOf /@ Flatten[ { l2 } ] ], { l2 } ] },
    AllTrue[ Tuples[ { reps1, reps2 } ],
      pair |-> InfraParallelQ[ graph, pair[[ 1 ]], pair[[ 2 ]], threshold ] ]
  ]

InfraPerpendicularQ::badmethod   = "Method `1` is not supported by InfraPerpendicularQ.";
InfraPerpendicularQ::badzerotest = "ZeroTest `1` is not supported by InfraPerpendicularQ \"Coordinate\".";

Options[ InfraPerpendicularQ ] = {
  Method   -> "Projection",
  "Radius" -> All
};

InfraPerpendicularQ[ graph_Graph, l1_, l2_, OptionsPattern[] ] :=
  With[ {
      seqOf = w |-> With[ { vs = VertexList @ w },
        If[ AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
          Last /@ SortBy[ vs, First ],
          Reap[ DepthFirstScan[ w,
            SelectFirst[ vs, If[ DirectedGraphQ @ w, VertexInDegree[ w, # ] == 0, VertexDegree[ w, # ] == 1 ] &, First @ vs ],
            { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] ] ],
      mtd = OptionValue[ Method ], radius = OptionValue[ "Radius" ] },
    { seq1 = If[ GraphQ @ l1, seqOf @ l1, l1 ], seq2 = If[ GraphQ @ l2, seqOf @ l2, l2 ] },
    { common  = Intersection[ seq1, seq2 ],
      mtdHead = Replace[ mtd, { m_String, ___ } :> m ],
      mtdOpts = Replace[ mtd, { { _String, o___ } :> { o }, _ -> { } } ],
      localize = q |-> With[ { localG = If[ radius === All, graph, NeighborhoodGraph[ graph, q, radius ] ] },
        { ball = If[ radius === All, All, VertexList @ localG ] },
        { localG,
          If[ ball === All, seq1, Select[ seq1, MemberQ[ ball, # ] & ] ],
          If[ ball === All, seq2, Select[ seq2, MemberQ[ ball, # ] & ] ] } ],
      feet = { h, line, point } |-> With[ { localLine = Select[ line, MemberQ[ VertexList[ h ], # ] & ] },
        { distances = GraphDistance[ h, point, # ] & /@ localLine },
        DeleteCases[ DeleteDuplicates @ Flatten[
          ( group |-> Map[
              pair |-> With[ { lo = Min @@ pair, hi = Max @@ pair },
                localLine[[ lo ;; hi ]][[ Ceiling[ ( hi - lo + 1 ) / 2 ] ]] ],
              Subsets[ group, { 2 } ] ]
          ) /@ Values @ GroupBy[ Range @ Length @ localLine, distances[[ # ]] & ],
          1 ], point ] ] },
    {
      projectionQ = p |-> With[ { loc = localize @ p, equality = Lookup[ mtdOpts, "Equality", "Subset" ] },
        { localCommon = Intersection[ loc[[ 2 ]], loc[[ 3 ]] ] },
        { proj12 = DeleteDuplicates @ Flatten[ feet[ loc[[ 1 ]], loc[[ 2 ]], # ] & /@ Complement[ loc[[ 3 ]], localCommon ] ],
          proj21 = DeleteDuplicates @ Flatten[ feet[ loc[[ 1 ]], loc[[ 3 ]], # ] & /@ Complement[ loc[[ 2 ]], localCommon ] ] },
        If[ equality === "Subset",
          SubsetQ[ localCommon, proj12 ] && SubsetQ[ localCommon, proj21 ],
          InfraEqualQ[ graph, InfraDensity[ graph, proj12 ], InfraDensity[ graph, localCommon ], Method -> equality ] &&
          InfraEqualQ[ graph, InfraDensity[ graph, proj21 ], InfraDensity[ graph, localCommon ], Method -> equality ] ] ],
      angleQ = p |-> With[ { loc = localize @ p, tol = Lookup[ mtdOpts, "Tolerance", 0 ] },
        { s1 = loc[[ 2 ]], s2 = loc[[ 3 ]] },
        { i1 = FirstPosition[ s1, p, { 0 }, { 1 }, Heads -> False ][[ 1 ]],
          i2 = FirstPosition[ s2, p, { 0 }, { 1 }, Heads -> False ][[ 1 ]] },
        { h1L = s1[[ ;; i1 - 1 ]], h1R = s1[[ i1 + 1 ;; ]],
          h2L = s2[[ ;; i2 - 1 ]], h2R = s2[[ i2 + 1 ;; ]] },
        Which[
          i1 == 0 || i2 == 0, False,
          h1L === { } || h1R === { } || h2L === { } || h2R === { }, False,
          True,
            Max[ # ] - Min[ # ] <= tol & @ ( InfraAngle[ loc[[ 1 ]], #, Method -> mtd ] & /@
              { { First[ h1L ], p, First[ h2L ] },
                { First[ h1L ], p, Last [ h2R ] },
                { Last [ h1R ], p, First[ h2L ] },
                { Last [ h1R ], p, Last [ h2R ] } } ) ] ],
      (* signed coordinates of the projection feet along the receiving line: perpendicular iff the cloud is balanced around p, rather than contained in the intersection as in "Projection" *)
      coordinateQ = p |-> With[ { loc = localize @ p, zeroTest = Lookup[ mtdOpts, "ZeroTest", "Mean" ] },
        { s1 = loc[[ 2 ]], s2 = loc[[ 3 ]] },
        { i1 = FirstPosition[ s1, p, { 0 }, { 1 }, Heads -> False ][[ 1 ]],
          i2 = FirstPosition[ s2, p, { 0 }, { 1 }, Heads -> False ][[ 1 ]],
          signedCoord = { seq, pIdx, v } |->
            Mean[ ( FirstPosition[ seq, #, { 0 }, { 1 }, Heads -> False ][[ 1 ]] - pIdx ) & /@
              FindClosestInfraPoint[ loc[[ 1 ]], seq, v, All ] ] },
        If[ i1 == 0 || i2 == 0, False,
          With[ { c12 = signedCoord[ s1, i1, # ] & /@ DeleteCases[ s2, p ],
                  c21 = signedCoord[ s2, i2, # ] & /@ DeleteCases[ s1, p ] },
            { ztTol = Lookup[ Replace[ zeroTest, { { _String, o___ } :> { o }, _ -> { } } ], "Tolerance", 0 ] },
            Which[
              Length[ c12 ] == 0 || Length[ c21 ] == 0, False,
              StringQ[ zeroTest ] || MatchQ[ zeroTest, { _String, ___ } ],
                Switch[ Replace[ zeroTest, { m_String, ___ } :> m ],
                  "Mean",     Abs[ N @ Mean[ c12 ] ]   <= ztTol && Abs[ N @ Mean[ c21 ] ]   <= ztTol,
                  "Median",   Abs[ N @ Median[ c12 ] ] <= ztTol && Abs[ N @ Median[ c21 ] ] <= ztTol,
                  "Contains", Min[ c12 ] - ztTol <= 0 <= Max[ c12 ] + ztTol
                           && Min[ c21 ] - ztTol <= 0 <= Max[ c21 ] + ztTol,
                  _,          Message[ InfraPerpendicularQ::badzerotest, zeroTest ]; False ],
              True, TrueQ @ zeroTest[ c12 ] && TrueQ @ zeroTest[ c21 ] ] ] ] ] },
    Which[
      Length[ common ] == 0,                          False,
      mtdHead === "Projection",                       AllTrue[ common, projectionQ ],
      mtdHead === "Coordinate",                       AllTrue[ common, coordinateQ ],
      MemberQ[ { "Arclength", "Alexandrov" }, mtdHead ], AllTrue[ common, angleQ ],
      True, Message[ InfraPerpendicularQ::badmethod, mtd ]; $Failed
    ]
  ]

LineCount[ graph_Graph ] :=
  Length @ DeleteDuplicates @ Catenate[
    ( pair |-> ( l |-> First @ Sort @ { l, Reverse[ l ] } ) /@
        FindInfraLine[ graph, pair[[ 1 ]], pair[[ 2 ]], All ] ) /@
      Subsets[ VertexList @ graph, { 2 } ] ]

Options[ FindLineHull ] = { "LineStructure" -> None };

FindLineHull[ graph_Graph, s : Except[ _Rule | _RuleDelayed ], OptionsPattern[] ] :=
  With[ { lines = Replace[ OptionValue[ "LineStructure" ], {
            None :> DeleteDuplicates @ Catenate[
              ( pair |-> ( l |-> First @ Sort @ { l, Reverse[ l ] } ) /@
                  FindInfraLine[ graph, pair[[ 1 ]], pair[[ 2 ]], All ] ) /@
                Subsets[ VertexList @ graph, { 2 } ] ],
            ls_InfraLineStructure :> ls[ "Lines" ] } ],
          S = Which[
            AssociationQ @ s,                  Keys @ s,
            MatchQ[ s, _Graph | { __Graph } ], Union @@ ( If[ AllTrue[ VertexList @ #, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ VertexList @ # ] === Range @ VertexCount @ #,
                Last /@ VertexList @ #, VertexList @ # ] & /@ Flatten[ { s } ] ),
            MatchQ[ s, { __List } ],           Union @@ s,
            ListQ @ s,                         Union @ s,
            True,                              { s } ] },
    Union @ FixedPoint[
      T |-> Union[ T, Catenate @ Select[ lines, Length @ Intersection[ #, T ] >= 2 & ] ],
      Union @ S
    ]
  ]

Options[ LineHullQ ] = { "LineStructure" -> None };

LineHullQ[ graph_Graph, s : Except[ _Rule | _RuleDelayed ], opts : OptionsPattern[] ] :=
  With[ { vs = Which[
      AssociationQ @ s,                  Keys @ s,
      MatchQ[ s, _Graph | { __Graph } ], Union @@ ( If[ AllTrue[ VertexList @ #, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ VertexList @ # ] === Range @ VertexCount @ #,
          Last /@ VertexList @ #, VertexList @ # ] & /@ Flatten[ { s } ] ),
      MatchQ[ s, { __List } ],           Union @@ s,
      ListQ @ s,                         Union @ s,
      True,                              { s } ] },
    FindLineHull[ graph, vs, opts ] === Union @ vs ]

UniversalLineQ[ graph_Graph, { u_, v_ } ] :=
  AnyTrue[ ConnectedComponents @ graph,
    c |-> ContainsAll[ c, { u, v } ] &&
      Union @ Catenate @ Select[ DeleteDuplicates @ Catenate[
          ( pair |-> ( l |-> First @ Sort @ { l, Reverse[ l ] } ) /@
              FindInfraLine[ graph, pair[[ 1 ]], pair[[ 2 ]], All ] ) /@
            Subsets[ VertexList @ graph, { 2 } ] ],
        ContainsAll[ #, { u, v } ] & ] === Sort @ c ]

UniversalLineQ[ graph_Graph ] :=
  AnyTrue[ Subsets[ VertexList @ graph, { 2 } ], UniversalLineQ[ graph, # ] & ]

dispatchConstruction[ graph_Graph, InfraLine[ path_List, opts___Rule ] ] :=
  capBranches[
    applySelectOption[ graph, FindInfraLine[ graph, path, All ],
      "Select" /. { opts } /. "Select" -> None,
      False, <| "Endpoints" -> { First @ path, Last @ path } |> ],
    extractBranches[ { opts } ] ]

dispatchConstruction[ graph_Graph, InfraLine[ p1_, p2_, opts___Rule ] ] /;
  MemberQ[ VertexList @ graph, p1 ] :=
  capBranches[
    applySelectOption[ graph, FindInfraLine[ graph, p1, p2, All ],
      "Select" /. { opts } /. "Select" -> None,
      False, <| "Endpoints" -> { p1, p2 } |> ],
    extractBranches[ { opts } ] ]
