Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraInfiniteLine *)

(* InfraInfiniteLine[p, q] is inert: the line through p and q.  Its graph is the List of atoms K_{a, b} = I(a, p) union I(p, q) union I(q, b), one per pair
   of ends compatible with (p, q) -- d(a, b) == d(a, p) + d(p, q) + d(q, b) -- and maximal -- no neighbour of a or of b lengthens d(a, b).  The
   chains of K_{a, b} are exactly the inextensible geodesics from a to b through p and then q, and every such geodesic is a chain of exactly one
   atom, while the union of the atoms is not faithful (design Thm. line).  InfraInfiniteLine[p, p] is every maximal geodesic through p, once per orientation
   *)

InfraMeasurement[ graph_Graph,
    InfraInfiniteLine[ p : Except[ _Rule | _RuleDelayed ], q : Except[ _Rule | _RuleDelayed ] ], "Graph" ] :=
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

(* InfraInfiniteLine[germ] is the line through a geodesic germ from p to q: a vertex (p == q), a vertex list, a position-spelled walk or a geodesic DAG
   from its source p to its sink q.  Its atoms are those of InfraInfiniteLine[p, q] with the middle interval I(p, q) replaced by the germ's own edges *)

InfraMeasurement[ graph_Graph, InfraInfiniteLine[ germ : Except[ _Rule | _RuleDelayed ] ], "Graph" ] :=
  With[ { vs = VertexList @ graph, dm = GraphDistanceMatrix @ graph,
          middle = Which[
            VertexQ[ graph, germ ], Graph[ { germ }, { } ],
            ListQ @ germ,           PathGraph[ germ, DirectedEdges -> True ],
            AllTrue[ VertexList @ germ, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ VertexList @ germ ] === Range @ VertexCount @ germ,
              PathGraph[ Last /@ SortBy[ VertexList @ germ, First ], DirectedEdges -> True ],
            True, germ ] },
    { idx = AssociationThread[ vs, Range @ Length @ vs ],
      p = SelectFirst[ VertexList @ middle, VertexInDegree[ middle, # ] == 0 & ],
      q = SelectFirst[ VertexList @ middle, VertexOutDegree[ middle, # ] == 0 & ] },
    { dist = dm[[ idx @ #1, idx @ #2 ]] & },
    { d = dist[ p, q ],
      chain = { a, interval } |-> With[ { inside = AssociationThread[ interval, True ] },
        Catenate @ Map[
          v |-> DirectedEdge[ v, # ] & /@ Select[ AdjacencyList[ graph, v ],
            TrueQ @ Lookup[ inside, Key @ # ] && dist[ a, # ] == dist[ a, v ] + 1 & ],
          interval ] ] },
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
            left  = Select[ vs, dist[ a, # ] + dist[ #, p ] == dist[ a, p ] & ],
            right = Select[ vs, dist[ q, # ] + dist[ #, b ] == dist[ q, b ] & ] },
          Graph[ Union[ left, VertexList @ middle, right ],
            Union[ chain[ a, left ], EdgeList @ middle, chain[ a, right ] ] ] ] ],
      pairs ] ]

Options[ RandomInfraInfiniteLine ] = { "NextVertexFunction" -> Automatic, RandomSeeding -> Automatic }

RandomInfraInfiniteLine[ args___ ] /; FreeQ[ { args }, RandomSeeding -> None, { 1 } ] :=
  With[ { result = BlockRandom[
      RandomInfraInfiniteLine[ Sequence @@ DeleteCases[ { args }, RandomSeeding -> _ ], RandomSeeding -> None ],
      RandomSeeding -> FirstCase[ { args }, ( RandomSeeding -> seed_ ) :> seed, Automatic ] ] },
    result /; ! MatchQ[ result, HoldPattern[ RandomInfraInfiniteLine[ ___, RandomSeeding -> None ] ] ] ]

RandomInfraInfiniteLine[ graph_Graph, p : Except[ _Rule | _RuleDelayed ], q : Except[ _Rule | _RuleDelayed ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( ( VertexQ[ graph, p ] || ! MatchQ[ p, _InfraInfiniteLine ] ) && ( ! ListQ[ p ] || VertexQ[ graph, p ] ) ) :=
  With[ { result = RandomInfraInfiniteLine[ graph, p, q, Infinity, count, opts ] },
    result /; Head[ result ] =!= RandomInfraInfiniteLine ]

RandomInfraInfiniteLine[ graph_Graph, p : Except[ _Rule | _RuleDelayed ], q : Except[ _Rule | _RuleDelayed ], kspec : ( UpTo[ _Integer?( n |-> n >= 0 ) ] | Infinity ),
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ), opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( ( VertexQ[ graph, p ] || ! MatchQ[ p, _InfraInfiniteLine ] ) &&
    SubsetQ[ First /@ Options[ RandomInfraInfiniteLine ], First /@ { opts } ] &&
    ( ! ListQ[ p ] || VertexQ[ graph, p ] ) &&
    ( count =!= All || OptionValue[ RandomInfraInfiniteLine, { opts }, "NextVertexFunction" ] =!= RandomChoice ) ) :=
  With[ { cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ],
          nextFn = If[ count === All &&
              OptionValue[ RandomInfraInfiniteLine, { opts }, "NextVertexFunction" ] === Automatic,
            Identity, OptionValue[ RandomInfraInfiniteLine, { opts }, "NextVertexFunction" ] ] },
    { lines = Fold[
        { found, seed } |-> If[ Length @ found >= cap, found,
          Join[ found,
            RandomInfraInfiniteLine[ graph, seed, kspec, If[ cap === Infinity, All, UpTo[ cap - Length @ found ] ],
              "NextVertexFunction" -> nextFn, RandomSeeding -> None ] ] ],
        { }, RandomInfraSegment[ graph, p, q, If[ cap === Infinity, All, UpTo[ cap ] ],
          "NextVertexFunction" -> nextFn, RandomSeeding -> None ] ] },
    Switch[ count,
      Automatic, First[ lines, { } ],
      All,       lines,
      _UpTo,     Take[ lines, count ],
      _,         If[ Length @ lines < count, { }, Take[ lines, count ] ] ] ]

RandomInfraInfiniteLine[ graph_Graph, seq_List,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( seq =!= { } && ! VertexQ[ graph, seq ] ) :=
  With[ { result = RandomInfraInfiniteLine[ graph, seq, Infinity, count, opts ] },
    result /; Head[ result ] =!= RandomInfraInfiniteLine ]

RandomInfraInfiniteLine[ graph_Graph, seq_List, kspec : ( UpTo[ _Integer?( n |-> n >= 0 ) ] | Infinity ),
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ), opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( SubsetQ[ First /@ Options[ RandomInfraInfiniteLine ], First /@ { opts } ] &&
    seq =!= { } && ! VertexQ[ graph, seq ] &&
    ( count =!= All || OptionValue[ RandomInfraInfiniteLine, { opts }, "NextVertexFunction" ] =!= RandomChoice ) ) :=
  With[ { cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ],
          budget = Replace[ kspec, UpTo[ k_ ] :> k ],
          vs = VertexList @ graph, dm = GraphDistanceMatrix @ graph,
          nextFn = If[ count === All &&
              OptionValue[ RandomInfraInfiniteLine, { opts }, "NextVertexFunction" ] === Automatic,
            Identity, OptionValue[ RandomInfraInfiniteLine, { opts }, "NextVertexFunction" ] ] },
    { idx = AssociationThread[ vs, Range @ Length @ vs ] },
    { dist = dm[[ idx @ #1, idx @ #2 ]] & },
    { order = candidates |-> Which[
        candidates === { } || nextFn === Identity, candidates,
        nextFn === Automatic, RandomSample @ candidates,
        True, Replace[ nextFn @ candidates,
          selected_ /; MemberQ[ candidates, Verbatim @ selected ] :> { selected } ] ] },
    { candidates = { path, added, side } |-> If[ added[[ side ]] >= budget, { }, Sort @ If[ side == 1,
        Select[ AdjacencyList[ graph, First @ path ], dist[ #, Last @ path ] == Length @ path & ],
        Select[ AdjacencyList[ graph, Last @ path ], dist[ First @ path, # ] == Length @ path & ] ] ] },
    (* the side with fewer added vertices grows first, so the first line found is balanced around seq; closing a side is the last branch, so
       every line, cut at the budget on each side, is reached exactly once, and a stuck side stays stuck because a subpath of a geodesic is a
       geodesic *)
    { lines = Catenate @ Last @ Reap @ NestWhile[
        Apply[ { stack, found } |-> Apply[ { path, added, open } |->
            If[ open === { False, False },
              If[ candidates[ path, added, 1 ] === { } && candidates[ path, added, 2 ] === { },
                ( Sow[ path ]; { Rest @ stack, found + 1 } ),
                { Rest @ stack, found } ],
              With[ { side = If[ open[[ 1 ]] && ( ! open[[ 2 ]] || added[[ 1 ]] <= added[[ 2 ]] ), 1, 2 ] },
                { Join[
                    { If[ side == 1, Prepend[ path, # ], Append[ path, # ] ], added + UnitVector[ 2, side ], open } & /@ order @ candidates[ path, added, side ],
                    { { path, added, ReplacePart[ open, side -> False ] } },
                    Rest @ stack ],
                  found } ] ],
            First @ stack ] ],
        { { { seq, { 0, 0 }, { True, True } } }, 0 },
        state |-> First @ state =!= { } && Last @ state < cap ] },
    Switch[ count,
      Automatic, First[ lines, { } ],
      All,       lines,
      _UpTo,     Take[ lines, count ],
      _,         If[ Length @ lines < count, { }, Take[ lines, count ] ] ] ]

(* a parallel to line through p: an inextensible geodesic s ... p ... e of graph inside the level set L = { v : d(v, line) == r }, r = d(p, line) --
   d(s, e) == d(s, p) + d(p, e), every vertex in L, and no neighbour of s or e in L prolonging it.  The pool is one geodesic DAG per admissible end
   pair (s, e): the s -> p and p -> e intervals cut down to L and glued at p, oriented so that s precedes e in canonical order.  All returns the
   pool itself, as RandomInfraInfiniteLine does, and a bounded count streams geodesics off the atoms in the order the next-vertex function gives *)

Options[ RandomInfraParallel ] = {
  Properties           -> { },
  "NextVertexFunction" -> Automatic,
  RandomSeeding        -> Automatic
}

RandomInfraParallel[ args___ ] /; FreeQ[ { args }, RandomSeeding -> None, { 1 } ] :=
  With[ { result = BlockRandom[
      RandomInfraParallel[ Sequence @@ DeleteCases[ { args }, RandomSeeding -> _ ], RandomSeeding -> None ],
      RandomSeeding -> FirstCase[ { args }, ( RandomSeeding -> seed_ ) :> seed, Automatic ] ] },
    result /; ! MatchQ[ result, HoldPattern[ RandomInfraParallel[ ___, RandomSeeding -> None ] ] ] ]

RandomInfraParallel[ graph_Graph, line_, p_,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ]/; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( OptionValue[ RandomInfraParallel, { opts }, Properties ] === { } &&
    ( count =!= All || OptionValue[ RandomInfraParallel, { opts }, "NextVertexFunction" ] =!= RandomChoice ) ) :=
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
      { results = ( { line0, p0 } |-> With[ {
            nextFn = If[ count === All &&
                OptionValue[ RandomInfraParallel, { opts }, "NextVertexFunction" ] === Automatic,
              Identity, OptionValue[ RandomInfraParallel, { opts }, "NextVertexFunction" ] ],
            verts = VertexList @ graph },
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
                  atom = { s, e } |-> With[ { dag = Graph[ { s, e }, Catenate @ Map[
                        EdgeList @ Subgraph[ #, Intersection[ VertexList @ #, level ] ] &,
                        InfraMeasurement[ graph, { InfraSegment[ s, p0 ], InfraSegment[ p0, e ] }, "Graph" ] ] ] },
                      Subgraph[ dag, Intersection[ VertexOutComponent[ dag, s ], VertexInComponent[ dag, e ] ] ] ],
                  cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ],
                  branch = cands |-> Which[
                    cands === { }, { },
                    nextFn === Identity, Sort @ cands,
                    nextFn === Automatic, RandomSample @ cands,
                    True, Replace[ nextFn @ cands,
                      chosen_ /; MemberQ[ cands, Verbatim @ chosen ] :> { chosen } ] ] },
                Fold[ { acc, pair } |-> If[ Length @ acc >= cap || ! admissibleQ @@ pair, acc,
                      Join[ acc, With[ { dag = atom @@ pair }, Which[
                        VertexCount @ dag == 0, { },
                        True,
                          With[ { out = GroupBy[ List @@@ EdgeList @ dag, First -> Last ], need = cap - Length @ acc },
                            Catenate @ Last @ Reap @ NestWhile[
                              Apply[ { stack, found } |-> With[ { nexts = Lookup[ out, Key @ Last @ First @ stack, { } ] },
                                If[ nexts === { },
                                  ( Sow[ First @ stack ]; { Rest @ stack, found + 1 } ),
                                  { Join[ Append[ First @ stack, # ] & /@ branch @ nexts, Rest @ stack ], found } ] ] ],
                              { List /@ branch @ Select[ VertexList @ dag, VertexInDegree[ dag, # ] == 0 & ], 0 },
                              state |-> First @ state =!= { } && Last @ state < need ] ] ] ] ] ],
                    { }, branch @ Tuples[ { level, level } ] ] ] ] ] ] ) @@@
          Tuples[ {
            Which[
              AssociationQ @ line, Keys @ line,
              GraphQ @ line, walksOf @ line,
              MatchQ[ line, { __Graph } ], Catenate[ walksOf /@ line ],
              line === { }, { },
              True, { line } ],
            Keys @ InfraMeasurement[ graph, p, "VertexDensity" ] } ] },
      { parallels = DeleteDuplicates[ If[ GraphQ @ #, #, PathGraph[ #, DirectedEdges -> True ] ] & /@
          DeleteDuplicates @ Flatten[ results, 1 ] ] },
      Switch[ count,
        Automatic, First[ parallels, { } ],
        All,       Replace[ parallels, { one_Graph } :> one ],
        _UpTo,     Take[ parallels, count ],
        _,         If[ Length @ parallels < count, { }, Take[ parallels, count ] ] ] ]
Options[ FindInfraPerpendicular ] = {
  Method   -> "Metric",
  "Radius" -> All
}

FindInfraPerpendicular[ graph_Graph, line_, point_,
    count : ( _Integer | UpTo[ _Integer ] | All ) : All, opts : OptionsPattern[] ]/;
    MatchQ[ OptionValue[ FindInfraPerpendicular, { opts }, Method ],
      "Metric" | "Projection" | "Coordinate" | "Arclength" | "Alexandrov" |
        { "Metric" | "Projection" | "Arclength" | "Alexandrov", ___ } |
        ( { "Coordinate", o___ } /; MatchQ[ Lookup[ { o }, "ZeroTest", "Mean" ],
          "Mean" | "Median" | "Contains" | { "Mean" | "Median" | "Contains", ___ } | Except[ _String | { _String, ___ } ] ] ) ] :=
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
        (* the LONGEST lines through a segment: each side extended independently, joint geodesicity d(s, e) == d(s, p1) + d + d(p2, e), and only the
           maxima of d(s, p1) + d(p2, e) kept *)
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
            With[ { inside = Select[ Range @ Length @ line0, VertexQ[ workGraph, line0[[ # ]] ] & ] },
              { distances = GraphDistance[ workGraph, point0, line0[[ # ]] ] & /@ inside },
              { nearest = Pick[ inside, distances, Min @ distances ] },
              (* Euclid I.12: the centre vertices, one or two, of the piece of the line between two line vertices equidistant from the
                 point, and the nearest vertex when it is unique, where the circle of radius d(point, line) touches the line *)
              { feet = Select[ DeleteCases[ DeleteDuplicates @ Join[
                  Catenate[ ( { lo, hi } |-> line0[[ lo + Floor[ ( hi - lo ) / 2 ] ;; lo + Ceiling[ ( hi - lo ) / 2 ] ]] ) @@@
                    Catenate[ Subsets[ #, { 2 } ] & /@ Values @ GroupBy[ Transpose @ { inside, distances }, Last -> First ] ] ],
                  If[ Length @ nearest == 1, line0[[ nearest ]], { } ] ], point0 ], VertexQ[ workGraph, # ] & ] },
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
              InfraPerpendicularQ[ graph, line0, #, Method -> spec, "Radius" -> radius ] & ]
        ] ] ) @@@
      Tuples[ {
        Which[
          AssociationQ @ line, Keys @ line,
          GraphQ @ line, walksOf @ line,
          MatchQ[ line, { __Graph } ], Catenate[ walksOf /@ line ],
          line === { }, { },
          True, { line } ],
        Keys @ InfraMeasurement[ graph, point, "VertexDensity" ] } ] },
    With[ { perpendiculars = DeleteDuplicates[ PathGraph[ #, DirectedEdges -> True ] & /@ DeleteDuplicates @ Flatten[ results, 1 ] ] },
        Switch[ count,
          All,   Replace[ perpendiculars, { one_Graph } :> one ],
          _UpTo, Take[ perpendiculars, count ],
          _,     If[ Length @ perpendiculars < count, { }, Take[ perpendiculars, count ] ] ] ] ]

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
            RandomInfraInfiniteLine[ graph, First @ uverts, uverts[[ 2 ]], All, RandomSeeding -> None ],
          line |-> SubsetQ[ line, uverts ] ] ] },
    { lines = DeleteDuplicates[ PathGraph[ #, DirectedEdges -> True ] & /@ common ] },
    Switch[ count,
      All,   Replace[ lines, { one_Graph } :> one ],
      _UpTo, Take[ lines, count ],
      _,     If[ Length @ lines < count, { }, Take[ lines, count ] ] ] ]

InfraInfiniteLineQ[ graph_Graph, ws : { __Graph } ] :=
  AllTrue[ ws, InfraInfiniteLineQ[ graph, # ] & ]

InfraInfiniteLineQ[ graph_Graph, ws : { { ___ } .. } ] :=
  AllTrue[ ws, InfraInfiniteLineQ[ graph, # ] & ]

InfraInfiniteLineQ[ graph_Graph, w_Graph ] :=
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
      InfraInfiniteLineQ[ graph, # ] & ] ]

InfraInfiniteLineQ[ graph_Graph, segment_List ] /; Length[ segment ] >= 2 :=
  InfraSegmentQ[ graph, segment ] &&
  NoneTrue[ AdjacencyList[ graph, First @ segment ], GraphDistance[ graph, #, Last @ segment ] == Length[ segment ] & ] &&
  NoneTrue[ AdjacencyList[ graph, Last @ segment ], GraphDistance[ graph, First @ segment, # ] == Length[ segment ] & ]

InfraInfiniteLineQ[ _Graph, segment_List ] /; Length[ segment ] < 2 :=
  False

(* l1 is parallel to l2: disjoint, and d(v, l2) constant over v in l1 up to threshold -- l1 lies on a level set of l2, as the parallels of
   RandomInfraParallel do; the relation is not symmetric *)

InfraParallelQ[ distanceMatrix_List, l1_List, l2_List, threshold_ : 0 ] :=
  ! IntersectingQ[ l1, l2 ] &&
  With[ { d = Min /@ distanceMatrix[[ l1, l2 ]] },
    Equal @@ d || Max[ d ] - Min[ d ] <= threshold ]

InfraParallelQ[ graph_Graph, l1_List, l2_List, threshold_ : 0 ] /; SubsetQ[ VertexList @ graph, Join[ l1, l2 ] ] :=
  InfraParallelQ[ GraphDistanceMatrix @ graph, VertexIndex[ graph, # ] & /@ l1, VertexIndex[ graph, # ] & /@ l2, threshold ]

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

Options[ InfraPerpendicularQ ] = {
  Method   -> "Projection",
  "Radius" -> All
}

InfraPerpendicularQ[ graph_Graph, l1_, l2_, opts : OptionsPattern[] ] /;
    MatchQ[ OptionValue[ InfraPerpendicularQ, { opts }, Method ],
      "Projection" | "Coordinate" | "Arclength" | "Alexandrov" | { "Projection" | "Arclength" | "Alexandrov", ___ } |
        ( { "Coordinate", o___ } /; MatchQ[ Lookup[ { o }, "ZeroTest", "Mean" ],
          "Mean" | "Median" | "Contains" | { "Mean" | "Median" | "Contains", ___ } | Except[ _String | { _String, ___ } ] ] ) ] :=
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
      (* the feet of point on line inside h: the centre vertices, one or two, of the piece of the line between two line vertices
         equidistant from point, and the nearest vertex when it is unique, where the circle of radius d(point, line) touches the line *)
      feet = { h, line, point } |-> With[ { inside = Select[ Range @ Length @ line, VertexQ[ h, line[[ # ]] ] & ] },
        { distances = GraphDistance[ h, point, line[[ # ]] ] & /@ inside },
        { nearest = Pick[ inside, distances, Min @ distances ] },
        Select[ DeleteCases[ DeleteDuplicates @ Join[
          Catenate[ ( { lo, hi } |-> line[[ lo + Floor[ ( hi - lo ) / 2 ] ;; lo + Ceiling[ ( hi - lo ) / 2 ] ]] ) @@@
            Catenate[ Subsets[ #, { 2 } ] & /@ Values @ GroupBy[ Transpose @ { inside, distances }, Last -> First ] ] ],
          If[ Length @ nearest == 1, line[[ nearest ]], { } ] ], point ], VertexQ[ h, # ] & ] ] },
    {
      projectionQ = p |-> With[ { loc = localize @ p, equality = Lookup[ mtdOpts, "Equality", "Subset" ] },
        { localCommon = Intersection[ loc[[ 2 ]], loc[[ 3 ]] ] },
        { proj12 = DeleteDuplicates @ Flatten[ feet[ loc[[ 1 ]], seq1, # ] & /@ Complement[ loc[[ 3 ]], localCommon ] ],
          proj21 = DeleteDuplicates @ Flatten[ feet[ loc[[ 1 ]], seq2, # ] & /@ Complement[ loc[[ 2 ]], localCommon ] ] },
        If[ equality === "Subset",
          SubsetQ[ localCommon, proj12 ] && SubsetQ[ localCommon, proj21 ],
          InfraEqualQ[ graph, InfraMeasurement[ graph, proj12, "VertexDensity" ], InfraMeasurement[ graph, localCommon, "VertexDensity" ], Method -> equality ] &&
          InfraEqualQ[ graph, InfraMeasurement[ graph, proj21, "VertexDensity" ], InfraMeasurement[ graph, localCommon, "VertexDensity" ], Method -> equality ] ] ],
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
            ( angles |-> Equal @@ angles || Max[ angles ] - Min[ angles ] <= tol ) @ ( ( triple |-> If[ mtdHead === "Alexandrov",
                InfraComparisonAngle[ loc[[ 1 ]], triple, "Curvature" -> Lookup[ mtdOpts, "Curvature", 0 ] ],
                With[ { radius = Min[ GraphDistance[ loc[[ 1 ]], triple[[ 2 ]], triple[[ 1 ]] ],
                    GraphDistance[ loc[[ 1 ]], triple[[ 2 ]], triple[[ 3 ]] ] ] },
                  GraphDistance[ VertexDelete[ loc[[ 1 ]],
                    Select[ VertexList @ loc[[ 1 ]], GraphDistance[ loc[[ 1 ]], triple[[ 2 ]], # ] < radius & ] ],
                    triple[[ 1 ]], triple[[ 3 ]] ] / radius ] ] ) /@
              { { First[ h1L ], p, First[ h2L ] },
                { First[ h1L ], p, Last [ h2R ] },
                { Last [ h1R ], p, First[ h2L ] },
                { Last [ h1R ], p, Last [ h2R ] } } ) ] ],
      (* signed coordinates of the projection feet along the receiving line: perpendicular iff the cloud is balanced around p, rather than contained
         in the intersection as in "Projection" *)
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
                           && Min[ c21 ] - ztTol <= 0 <= Max[ c21 ] + ztTol ],
              True, TrueQ @ zeroTest[ c12 ] && TrueQ @ zeroTest[ c21 ] ] ] ] ] },
    Which[
      Length[ common ] != 1,    False,
      mtdHead === "Projection", projectionQ @ First @ common,
      mtdHead === "Coordinate", coordinateQ @ First @ common,
      True,                     angleQ @ First @ common
    ]
  ]

LineCount[ graph_Graph ] :=
  Length @ DeleteDuplicates @ Catenate[
    ( pair |-> ( l |-> First @ Sort @ { l, Reverse[ l ] } ) /@
        RandomInfraInfiniteLine[ graph, pair[[ 1 ]], pair[[ 2 ]], All, RandomSeeding -> None ] ) /@
      Subsets[ VertexList @ graph, { 2 } ] ]

(* the line through u and v, the union of the maximal geodesics through both, is { w : one of u, v, w lies between the other two }
   (Chen-Chvatal); it is universal when it is the whole component of u and v *)

UniversalLineQ[ graph_Graph, { u_, v_ } ] /; VertexQ[ graph, u ] && VertexQ[ graph, v ] :=
  With[ { dm = GraphDistanceMatrix @ graph },
    { du = dm[[ VertexIndex[ graph, u ] ]], dv = dm[[ VertexIndex[ graph, v ] ]] },
    { d = du[[ VertexIndex[ graph, v ] ]] },
    d < Infinity && AllTrue[ Select[ Transpose @ { du, dv }, First @ # < Infinity & ],
      Apply[ { x, y } |-> x + y == d || x + d == y || d + y == x ] ] ]

UniversalLineQ[ graph_Graph ] :=
  With[ { dm = GraphDistanceMatrix @ graph },
    AnyTrue[ Subsets[ Range @ VertexCount @ graph, { 2 } ],
      Apply[ { i, j } |-> With[ { d = dm[[ i, j ]] },
        d < Infinity && AllTrue[ Select[ Transpose @ dm[[ { i, j } ]], First @ # < Infinity & ],
          Apply[ { x, y } |-> x + y == d || x + d == y || d + y == x ] ] ] ] ] ]

RandomInfraInfiniteLine[ graph_Graph, InfraInfiniteLine[ path_List ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( SubsetQ[ First /@ Options[ RandomInfraInfiniteLine ], First /@ { opts } ] &&
    ! VertexQ[ graph, path ] && path =!= { } &&
    ( OptionValue[ RandomInfraInfiniteLine, { opts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) ) :=
  With[ { members = RandomInfraInfiniteLine[ graph, path, All, RandomSeeding -> None ],
          nextFn = OptionValue[ RandomInfraInfiniteLine, { opts }, "NextVertexFunction" ] },
    { ordered = Sort @ members },
    Which[
      count === Automatic, If[ ordered === { }, { }, If[ nextFn === Identity, First @ ordered, RandomChoice @ ordered ] ],
      count === All,       members,
      nextFn === Identity, If[ IntegerQ @ count && Length @ ordered < count, { }, Take[ ordered, count ] ],
      IntegerQ @ count && Length @ ordered < count, { },
      True, RandomSample[ ordered, count ] ] ]

(* with a budget of k vertices per side the token is prolonged from its shortest paths, as RandomInfraInfiniteLine[graph, seq, UpTo[k], count]
   does, and no longer drawn uniformly from its atoms *)

RandomInfraInfiniteLine[ graph_Graph, InfraInfiniteLine[ path_List ], kspec : ( UpTo[ _Integer?( n |-> n >= 0 ) ] | Infinity ),
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ), opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( ! VertexQ[ graph, path ] && path =!= { } ) :=
  With[ { result = RandomInfraInfiniteLine[ graph, path, kspec, count, opts ] },
    result /; Head[ result ] =!= RandomInfraInfiniteLine ]

RandomInfraInfiniteLine[ graph_Graph, InfraInfiniteLine[ p : Except[ _Rule | _RuleDelayed ], q : Except[ _Rule | _RuleDelayed ] ],
    kspec : ( UpTo[ _Integer?( n |-> n >= 0 ) ] | Infinity ),
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ), opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] :=
  With[ { result = RandomInfraInfiniteLine[ graph, p, q, kspec, count, opts ] },
    result /; Head[ result ] =!= RandomInfraInfiniteLine ]

RandomInfraInfiniteLine[ graph_Graph, InfraInfiniteLine[ germ : Except[ _Rule | _RuleDelayed ] ], kspec : ( UpTo[ _Integer?( n |-> n >= 0 ) ] | Infinity ),
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ), opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( SubsetQ[ First /@ Options[ RandomInfraInfiniteLine ], First /@ { opts } ] &&
    ( VertexQ[ graph, germ ] || GraphQ[ germ ] ) &&
    ( count =!= All || OptionValue[ RandomInfraInfiniteLine, { opts }, "NextVertexFunction" ] =!= RandomChoice ) ) :=
  With[ { cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ],
          nextFn = If[ count === All &&
              OptionValue[ RandomInfraInfiniteLine, { opts }, "NextVertexFunction" ] === Automatic,
            Identity, OptionValue[ RandomInfraInfiniteLine, { opts }, "NextVertexFunction" ] ] },
    { seeds = Which[
        VertexQ[ graph, germ ], { { germ } },
        AllTrue[ VertexList @ germ, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ VertexList @ germ ] === Range @ VertexCount @ germ,
          { Last /@ SortBy[ VertexList @ germ, First ] },
        True, Catenate @ Catenate @ Table[ FindPath[ germ, s, t, Infinity, All ],
          { s, Select[ VertexList @ germ, VertexInDegree[ germ, # ] == 0 & ] }, { t, Select[ VertexList @ germ, VertexOutDegree[ germ, # ] == 0 & ] } ] ] },
    { lines = Fold[
        { found, seed } |-> If[ Length @ found >= cap, found,
          Join[ found,
            RandomInfraInfiniteLine[ graph, seed, kspec, If[ cap === Infinity, All, UpTo[ cap - Length @ found ] ],
              "NextVertexFunction" -> nextFn, RandomSeeding -> None ] ] ],
        { }, If[ nextFn === Automatic, RandomSample @ seeds, seeds ] ] },
    Switch[ count,
      Automatic, First[ lines, { } ],
      All,       lines,
      _UpTo,     Take[ lines, count ],
      _,         If[ Length @ lines < count, { }, Take[ lines, count ] ] ] ]

RandomInfraInfiniteLine[ graph_Graph,
    obj : InfraInfiniteLine[ Except[ _Rule | _RuleDelayed ], Except[ _Rule | _RuleDelayed ] ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( SubsetQ[ First /@ Options[ RandomInfraInfiniteLine ], First /@ { opts } ] &&
    ( OptionValue[ RandomInfraInfiniteLine, { opts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) ) :=
  With[ {
      cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ],
      nextFn = OptionValue[ RandomInfraInfiniteLine, { opts }, "NextVertexFunction" ],
      dags = Select[ Replace[ InfraMeasurement[ graph, obj, "Graph" ], dag_Graph :> { dag } ], VertexCount[ # ] > 0 & ] },
    { engines = Map[
        dag |-> With[ { out = GroupBy[ List @@@ EdgeList @ dag, First -> Last ] },
          { beta = Fold[ { a, w } |-> Append[ a, w -> Replace[ Lookup[ out, Key @ w, { } ],
                  { { } -> 1, qs_ :> Total @ Lookup[ a, Key /@ qs ] } ] ],
              <| |>, Reverse @ TopologicalSort @ dag ] },
          { out, beta, Sort @ Pick[ VertexList @ dag, VertexInDegree @ dag, 0 ] } ],
        dags ] },
    { draw = { out, beta, sources } |->
        NestWhile[
          path |-> With[ { nexts = Lookup[ out, Key @ Last @ path, { } ] },
            Append[ path, RandomChoice[ Lookup[ beta, Key /@ nexts ] -> nexts ] ] ],
          { RandomChoice[ Lookup[ beta, Key /@ sources ] -> sources ] },
          path |-> Lookup[ out, Key @ Last @ path, { } ] =!= { } ] },
    { randomDraw = ignored |-> If[ engines === { }, { },
        With[ { weights = Total @ Lookup[ #[[ 2 ]], Key /@ #[[ 3 ]] ] & /@ engines },
          draw @@ RandomChoice[ weights -> engines ] ] ] },
    { enumerate = limit |-> Catenate @ Last @ Reap @ Fold[
          { found, engine } |-> With[ { out = First @ engine },
            Last @ NestWhile[
              Apply[ { stack, got } |-> With[ { path = First @ stack },
                { nexts = Sort @ Lookup[ out, Key @ Last @ path, { } ] },
                { selected = If[ nexts === { } || nextFn === Automatic, nexts,
                    Replace[ nextFn @ nexts,
                      candidate_ /; MemberQ[ nexts, Verbatim @ candidate ] :> { candidate } ] ] },
                If[ nexts === { },
                  ( Sow[ path ]; { Rest @ stack, got + 1 } ),
                  { Join[ Append[ path, # ] & /@ selected, Rest @ stack ],
                    got } ] ] ],
              { List /@ Last @ engine, found },
              state |-> First @ state =!= { } && Last @ state < limit ] ],
          0, engines ] },
    { randomWalk = ignored |-> First[ enumerate @ 1, { } ] },
    { cardinality = Total @ ( Total @ Lookup[ #[[ 2 ]], Key /@ #[[ 3 ]] ] & /@ engines ) },
    { members = Which[
        count === Automatic && nextFn === Automatic,
          { randomDraw[ Null ] },
        nextFn === RandomChoice,
          If[ cap > cardinality && ! MatchQ[ count, _UpTo ], { },
            First @ NestWhile[
              state |-> With[ { member = randomWalk[ Null ] },
                If[ MemberQ[ First @ state, member ], state, { Append[ First @ state, member ], Last @ state + 1 } ] ],
              { { }, 0 },
              Last @ # < If[ MatchQ[ count, _UpTo ], Min[ cap, cardinality ], cap ] & ] ],
        nextFn =!= Automatic,
          enumerate @ cap,
        count === All,
          enumerate @ Infinity,
        cap > cardinality && ! MatchQ[ count, _UpTo ],
          { },
        2 cap >= cardinality,
          RandomSample[ enumerate @ Infinity, Replace[ count, UpTo[ n_ ] :> UpTo[ n ] ] ],
        True,
          First @ NestWhile[
            state |-> With[ { member = randomDraw[ Null ] },
              If[ MemberQ[ First @ state, member ], state, { Append[ First @ state, member ], Last @ state + 1 } ] ],
            { { }, 0 },
            Last @ # < cap & ] ] },
    Switch[ count,
      Automatic, First[ members, { } ],
      All,       members,
      _UpTo,     If[ nextFn === Automatic, members, Take[ members, count ] ],
      _,         If[ Length[ members ] < count, { }, Take[ members, count ] ] ] ]


RandomInfraInfiniteLine[ graph_Graph,
    obj : InfraInfiniteLine[ germ : Except[ _Rule | _RuleDelayed ] ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( SubsetQ[ First /@ Options[ RandomInfraInfiniteLine ], First /@ { opts } ] &&
    ( OptionValue[ RandomInfraInfiniteLine, { opts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) && ( VertexQ[ graph, germ ] || GraphQ[ germ ] ) ) :=
  With[ {
      cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ],
      nextFn = OptionValue[ RandomInfraInfiniteLine, { opts }, "NextVertexFunction" ],
      dags = Select[ Replace[ InfraMeasurement[ graph, obj, "Graph" ], dag_Graph :> { dag } ], VertexCount[ # ] > 0 & ] },
    { engines = Map[
        dag |-> With[ { out = GroupBy[ List @@@ EdgeList @ dag, First -> Last ] },
          { beta = Fold[ { a, w } |-> Append[ a, w -> Replace[ Lookup[ out, Key @ w, { } ],
                  { { } -> 1, qs_ :> Total @ Lookup[ a, Key /@ qs ] } ] ],
              <| |>, Reverse @ TopologicalSort @ dag ] },
          { out, beta, Sort @ Pick[ VertexList @ dag, VertexInDegree @ dag, 0 ] } ],
        dags ] },
    { draw = { out, beta, sources } |->
        NestWhile[
          path |-> With[ { nexts = Lookup[ out, Key @ Last @ path, { } ] },
            Append[ path, RandomChoice[ Lookup[ beta, Key /@ nexts ] -> nexts ] ] ],
          { RandomChoice[ Lookup[ beta, Key /@ sources ] -> sources ] },
          path |-> Lookup[ out, Key @ Last @ path, { } ] =!= { } ] },
    { randomDraw = ignored |-> If[ engines === { }, { },
        With[ { weights = Total @ Lookup[ #[[ 2 ]], Key /@ #[[ 3 ]] ] & /@ engines },
          draw @@ RandomChoice[ weights -> engines ] ] ] },
    { enumerate = limit |-> Catenate @ Last @ Reap @ Fold[
          { found, engine } |-> With[ { out = First @ engine },
            Last @ NestWhile[
              Apply[ { stack, got } |-> With[ { path = First @ stack },
                { nexts = Sort @ Lookup[ out, Key @ Last @ path, { } ] },
                { selected = If[ nexts === { } || nextFn === Automatic, nexts,
                    Replace[ nextFn @ nexts,
                      candidate_ /; MemberQ[ nexts, Verbatim @ candidate ] :> { candidate } ] ] },
                If[ nexts === { },
                  ( Sow[ path ]; { Rest @ stack, got + 1 } ),
                  { Join[ Append[ path, # ] & /@ selected, Rest @ stack ],
                    got } ] ] ],
              { List /@ Last @ engine, found },
              state |-> First @ state =!= { } && Last @ state < limit ] ],
          0, engines ] },
    { randomWalk = ignored |-> First[ enumerate @ 1, { } ] },
    { cardinality = Total @ ( Total @ Lookup[ #[[ 2 ]], Key /@ #[[ 3 ]] ] & /@ engines ) },
    { members = Which[
        count === Automatic && nextFn === Automatic,
          { randomDraw[ Null ] },
        nextFn === RandomChoice,
          If[ cap > cardinality && ! MatchQ[ count, _UpTo ], { },
            First @ NestWhile[
              state |-> With[ { member = randomWalk[ Null ] },
                If[ MemberQ[ First @ state, member ], state, { Append[ First @ state, member ], Last @ state + 1 } ] ],
              { { }, 0 },
              Last @ # < If[ MatchQ[ count, _UpTo ], Min[ cap, cardinality ], cap ] & ] ],
        nextFn =!= Automatic,
          enumerate @ cap,
        count === All,
          enumerate @ Infinity,
        cap > cardinality && ! MatchQ[ count, _UpTo ],
          { },
        2 cap >= cardinality,
          RandomSample[ enumerate @ Infinity, Replace[ count, UpTo[ n_ ] :> UpTo[ n ] ] ],
        True,
          First @ NestWhile[
            state |-> With[ { member = randomDraw[ Null ] },
              If[ MemberQ[ First @ state, member ], state, { Append[ First @ state, member ], Last @ state + 1 } ] ],
            { { }, 0 },
            Last @ # < cap & ] ] },
    Switch[ count,
      Automatic, First[ members, { } ],
      All,       members,
      _UpTo,     If[ nextFn === Automatic, members, Take[ members, count ] ],
      _,         If[ Length[ members ] < count, { }, Take[ members, count ] ] ] ]

