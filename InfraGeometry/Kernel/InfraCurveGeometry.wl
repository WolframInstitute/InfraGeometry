Package["WolframInstitute`InfraGeometry`"]


(* ===================== TurningAngles ===================== *)

(* kappa_i = Pi - InfraAngle[g, {v_{i-1}, v_i, v_{i+1}}]; a closed cycle includes the wrap-around triple *)

TurningAngles[ _Graph, { } ] := { }

(* a walk graph is read as its vertex sequence, closed when it is a cycle; turning happens only at the knots of a polyline -- a List of geodesic legs -- since the interior of each leg is straight by construction *)
TurningAngles[ graph_Graph, x : ( _Graph | { __Graph } ) ] :=
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
    TurningAngles[ graph,
      If[ GraphQ @ x,
        First @ walksOf @ x,
        Prepend[ Last @ First @ walksOf @ # & /@ x, First @ First @ walksOf @ First @ x ] ] ] ]

TurningAngles[ graph_Graph, path : { __ } ] /; ! MatchQ[ path, { __Graph } ] :=
  With[ { triples =
      If[ First[ path ] === Last[ path ] && Length[ path ] >= 3,
        Partition[ Most[ path ], 3, 1, { 1, 1 } ],
        Partition[ path, 3, 1 ]
      ]
    },
    Pi - ( InfraAngle[ graph, # ] & /@ triples )
  ]


(* ===================== TotalCurvature ===================== *)

(* K(c) = Sum_i kappa_i, exact rather than an approximation of Integral kappa ds, since the curve already is a polygon *)

TotalCurvature[ graph_Graph, path : ( { __ } | _Graph ) ] :=
  Total @ TurningAngles[ graph, path ]


(* ===================== TotalAbsoluteCurvature ===================== *)

(* Sum_i |kappa_i|; conjecturally >= 2 Pi for any closed cycle, the graph analogue of Fenchel's inequality *)

TotalAbsoluteCurvature[ graph_Graph, path : ( { __ } | _Graph ) ] :=
  Total @ Abs @ TurningAngles[ graph, path ]


(* ===================== TurningNumber ===================== *)

(* r(c) = K(c) / (2 Pi); Hopf forces r in {+1, -1} for smooth simple closed curves, on a graph it is generally real *)

TurningNumber[ graph_Graph, cycle : ( { __ } | _Graph ) ] :=
  TotalCurvature[ graph, cycle ] / ( 2 Pi )
