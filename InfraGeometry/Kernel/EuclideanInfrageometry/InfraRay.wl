Package["WolframInstitute`InfraGeometry`"]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraRay *)

(* InfraRay[p, q] is inert: the ray from p through q.  Its graph is the ray DAG R(p, q) = I(p, q) union F(p, q), F(p, q) = { v : d(p, v) == d(p, q) + d(q, v) }, with the arrows v -> w of rising d(p, .); its chains from p to a sink are exactly the geodesics from p through q that cannot be prolonged while staying geodesic (design Thm. ray).  InfraRay[p, p] is the pencil at p, every maximal geodesic out of p *)

InfraMeasurement[ graph_Graph,
    InfraRay[ p : Except[ _Rule | _RuleDelayed ], q : Except[ _Rule | _RuleDelayed ] ], "Graph" ] :=
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

(* a ray from p through q: a geodesic p ... q ... e with d(p, e) == d(p, q) + d(q, e) that no neighbour of e prolongs.  Found on the substrate directly, by prolonging a geodesic from p to q one outward step at a time, independently of the ray DAG *)

FindInfraRay[ graph_Graph, p_, q_,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic ] :=
  With[ { cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ],
          dp  = AssociationThread[ VertexList @ graph, GraphDistance[ graph, p ] ] },
    { k = Lookup[ dp, Key @ q ] },
    { rays = Catenate @ Last @ Reap @ NestWhile[
        Apply[ { stack, found } |-> With[ { path = First @ stack },
          { nexts = Sort @ Select[ AdjacencyList[ graph, Last @ path ],
              Lookup[ dp, Key @ # ] == Lookup[ dp, Key @ Last @ path ] + 1 & ] },
          If[ nexts === { },
            ( Sow[ path ]; { Rest @ stack, found + 1 } ),
            { Join[ Append[ path, # ] & /@ nexts, Rest @ stack ], found } ] ] ],
        { Which[
            k === Infinity, { },
            k === 0,        { { p } },
            True,           FindPath[ graph, p, q, { k }, Replace[ cap, Infinity -> All ] ] ],
          0 },
        state |-> First @ state =!= { } && Last @ state < cap ] },
    Switch[ count,
      Automatic, First[ rays, { } ],
      All,       rays,
      _UpTo,     Take[ rays, count ],
      _,         If[ Length @ rays < count, { }, Take[ rays, count ] ] ] ]

InfraRayQ[ graph_Graph, ws : { __Graph } ] := AllTrue[ ws, InfraRayQ[ graph, # ] & ]

InfraRayQ[ graph_Graph, ws : { { ___ } .. } ] := AllTrue[ ws, InfraRayQ[ graph, # ] & ]

InfraRayQ[ graph_Graph, w_Graph ] :=
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
      InfraRayQ[ graph, # ] & ] ]

InfraRayQ[ graph_Graph, ray_List ] /; Length[ ray ] >= 2 :=
  InfraSegmentQ[ graph, ray ] &&
  NoneTrue[ AdjacencyList[ graph, Last @ ray ],
    GraphDistance[ graph, First @ ray, # ] == Length[ ray ] & ]

InfraRayQ[ _Graph, ray_List ] /; Length[ ray ] < 2 := False

PencilDirections[ graph_Graph, origin_ ] := FindInfraRay[ graph, origin, origin, All ]

PencilCardinality[ graph_Graph, origin_ ] := InfraMeasurement[ graph, InfraRay[ origin, origin ], "Cardinality" ]

dispatchConstruction[ graph_Graph, InfraRay[ origin_, v_, opts___Rule ] ] :=
  capBranches[
    applySelectOption[ graph, FindInfraRay[ graph, origin, v, All ],
      "Select" /. { opts } /. "Select" -> None,
      False, <| "Endpoints" -> { origin, v } |> ],
    extractBranches[ { opts } ] ]
