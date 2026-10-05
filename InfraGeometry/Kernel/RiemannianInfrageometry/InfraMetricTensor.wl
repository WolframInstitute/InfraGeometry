Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: RiemannianInfrageometry :: InfraMetricTensor *)

(* T[v, w] = d(p, u) / d(p, v) with u the vertex of I(p, w) closest to v; in Euclidean space clamp(cos theta, 0, |w|/|v|), on a shell max(0, cos
   theta) (Euclid II.12-13) *)

Options[ InfraMetricTensor ] = { "SelectCoordinate" -> Min }

InfraMetricTensor[ graph_Graph, p_, r : ( _Integer | All ) : All, OptionsPattern[] ] :=
  With[ { verts = VertexList @ graph, dm = GraphDistanceMatrix @ graph, sel = OptionValue[ "SelectCoordinate" ] },
    { dp = dm[[ VertexIndex[ graph, p ] ]] },
    { s = If[ r === All, All, VertexIndex[ graph, # ] & /@ Sort @ Pick[ verts, dp, r ] ] },
    { dS = dm[[ s ]], dpS = dp[[ s ]] },
    Transpose @ MapThread[
      { dw, k } |-> With[ { iw = Pick[ Range @ Length @ verts, dp + dw, k ] },
        { idx = dp[[ iw ]], M = dS[[ All, iw ]] },
        { tie = 1 - Unitize[ M - Min /@ M ] },
        { tied = tie ConstantArray[ idx, Length @ tie ] },
        Switch[ sel,
          Min,  Min /@ ( tied + ( 1 - tie ) k ),
          Max,  Max /@ tied,
          Mean, Total[ tied, { 2 } ] / Total[ tie, { 2 } ],
          All,  Pick[ idx, #, 1 ] & /@ tie,
          _,    sel @ Pick[ idx, #, 1 ] & /@ tie ] ],
      { dS, dpS } ] / Clip[ dpS, { 1, Infinity } ]
  ]
