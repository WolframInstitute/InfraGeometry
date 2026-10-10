Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraHalfLine *)

(* InfraHalfLine[p, q] is inert: the ray from p through q.  Its graph is the ray DAG R(p, q) = I(p, q) union F(p, q), F(p, q) = { v : d(p, v) == d(p, q) +
   d(q, v) }, with the arrows v -> w of rising d(p, .); its chains from p to a sink are exactly the geodesics from p through q that cannot be
   prolonged while staying geodesic (design Thm. ray).  InfraHalfLine[p, p] is the pencil at p, every maximal geodesic out of p *)

InfraMeasurement[ graph_Graph,
    InfraHalfLine[ p : Except[ _Rule | _RuleDelayed ], q : Except[ _Rule | _RuleDelayed ] ], "Graph" ] :=
  With[ { dp = AssociationThread[ VertexList @ graph, GraphDistance[ graph, p ] ],
          dq = AssociationThread[ VertexList @ graph, GraphDistance[ graph, q ] ] },
    { k = Lookup[ dp, Key @ q ] },
    { support = If[ k === Infinity, { },
        Select[ VertexList @ graph,
          Lookup[ dp, Key @ # ] < Infinity &&
          ( Lookup[ dp, Key @ # ] + Lookup[ dq, Key @ # ] == k || Lookup[ dp, Key @ # ] == k + Lookup[ dq, Key @ # ] ) & ] ] },
    { inside = AssociationThread[ support, True ] },
    Graph[ support,
      Catenate @ Map[
        v |-> DirectedEdge[ v, # ] & /@ Select[ AdjacencyList[ graph, v ],
          TrueQ @ Lookup[ inside, Key @ # ] && Lookup[ dp, Key @ # ] == Lookup[ dp, Key @ v ] + 1 & ],
        support ] ] ]

(* a ray from p through q: a geodesic p ... q ... e with d(p, e) == d(p, q) + d(q, e) that no neighbour of e prolongs.  Found on the substrate
   directly, by prolonging a geodesic from p to q one outward step at a time, independently of the ray DAG *)

Options[ RandomInfraHalfLine ] = { "NextVertexFunction" -> Automatic }

RandomInfraHalfLine[ graph_Graph, p_, q_,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /; ( VertexQ[ graph, p ] || ! MatchQ[ p, _InfraHalfLine | _InfraRay ] ) &&
    SubsetQ[ First /@ Options[ RandomInfraHalfLine ], First /@ { opts } ] &&
    ( count =!= All || OptionValue[ RandomInfraHalfLine, { opts }, "NextVertexFunction" ] =!= RandomChoice ) :=
  With[ { cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ],
          dp  = AssociationThread[ VertexList @ graph, GraphDistance[ graph, p ] ],
          nextFn = If[ count === All &&
              OptionValue[ RandomInfraHalfLine, { opts }, "NextVertexFunction" ] === Automatic,
            Identity, OptionValue[ RandomInfraHalfLine, { opts }, "NextVertexFunction" ] ] },
    { k = Lookup[ dp, Key @ q ] },
    { rays = Catenate @ Last @ Reap @ NestWhile[
        Apply[ { stack, found } |-> With[ { path = First @ stack },
          { candidates = Sort @ Select[ AdjacencyList[ graph, Last @ path ],
              Lookup[ dp, Key @ # ] == Lookup[ dp, Key @ Last @ path ] + 1 & ] },
          { nexts = Which[
              candidates === { } || nextFn === Identity, candidates,
              nextFn === Automatic, RandomSample @ candidates,
              True, Replace[ nextFn @ candidates,
                selected_ /; MemberQ[ candidates, Verbatim @ selected ] :> { selected } ] ] },
          If[ nexts === { },
            ( Sow[ path ]; { Rest @ stack, found + 1 } ),
            { Join[ Append[ path, # ] & /@ nexts, Rest @ stack ], found } ] ] ],
        { Which[
            k === Infinity, { },
            k === 0,        { { p } },
          True,           RandomInfraSegment[ graph, p, q,
            If[ cap === Infinity, All, UpTo[ cap ] ], "NextVertexFunction" -> nextFn ] ],
          0 },
        state |-> First @ state =!= { } && Last @ state < cap ] },
    Switch[ count,
      Automatic, First[ rays, { } ],
      All,       rays,
      _UpTo,     Take[ rays, count ],
      _,         If[ Length @ rays < count, { }, Take[ rays, count ] ] ] ]

InfraHalfLineQ[ graph_Graph, ws : { __Graph } ] :=
  AllTrue[ ws, InfraHalfLineQ[ graph, # ] & ]

InfraHalfLineQ[ graph_Graph, ws : { { ___ } .. } ] :=
  AllTrue[ ws, InfraHalfLineQ[ graph, # ] & ]

InfraHalfLineQ[ graph_Graph, w_Graph ] :=
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
      InfraHalfLineQ[ graph, # ] & ] ]

InfraHalfLineQ[ graph_Graph, ray_List ] /; Length[ ray ] >= 2 :=
  InfraSegmentQ[ graph, ray ] &&
  NoneTrue[ AdjacencyList[ graph, Last @ ray ],
    GraphDistance[ graph, First @ ray, # ] == Length[ ray ] & ]

InfraHalfLineQ[ _Graph, ray_List ] /; Length[ ray ] < 2 :=
  False

RandomInfraHalfLine[ graph_Graph,
    obj : ( InfraHalfLine | InfraRay )[ Except[ _Rule | _RuleDelayed ], Except[ _Rule | _RuleDelayed ] ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /; SubsetQ[ First /@ Options[ RandomInfraHalfLine ], First /@ { opts } ] &&
    ( OptionValue[ RandomInfraHalfLine, { opts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) :=
  With[ {
      cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ],
      nextFn = OptionValue[ RandomInfraHalfLine, { opts }, "NextVertexFunction" ],
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


Options[ RandomInfraRay ] = Options[ RandomInfraHalfLine ]

RandomInfraRay[ graph_Graph, args___ ] :=
  RandomInfraHalfLine[ graph, args ]

InfraRayQ[ graph_Graph, args___ ] :=
  InfraHalfLineQ[ graph, args ]

RandomInfraHalfLine[ graph_Graph, InfraRay[ p_, q_ ], args___ ] :=
  RandomInfraHalfLine[ graph, InfraHalfLine[ p, q ], args ]
