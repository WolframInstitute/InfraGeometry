Package[ "WolframInstitute`InfraGeometry`" ]

Options[ RandomInfraConvexHull ] = { "NextVertexFunction" -> Automatic }

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraConvexHull *)

(* the k-th round of the interval closure: round 0 is S, round i + 1 the union of the intervals I(u, v) = { w : d(u, w) + d(w, v) == d(u, v) }
   over the pairs u, v of round i, which contains round i as I(u, u) = { u }; the fixed point, k = Infinity, is the geodesic convex hull
   (Farber-Jamison).  A round reads I(u, v) for every v at once off the rows of one distance matrix; clipped at the vertex count, the distances
   give I(u, v) = { u, v } across two components *)

InfraMeasurement[ graph_Graph, InfraConvexHull[ s_, k_ : Infinity ], "VertexDensity" ] :=
  With[ { n = VertexCount @ graph, vlist = VertexList @ graph },
    { dm = Clip[ GraphDistanceMatrix @ graph, { 0, n } ],
      seeds = Keys @ If[ VertexQ[ graph, s ] || MatchQ[ s, _List | _Association | _Graph ],
        InfraDensity[ graph, s ],
        InfraMeasurement[ graph, s, "VertexDensity" ] ] },
    AssociationThread[
      Sort @ vlist[[ FixedPoint[
        ids |-> Union @@ Map[
          u |-> Pick[ Range @ n, Times @@ Unitize[ ( # + dm[[ u ]] & ) /@ ( dm[[ ids ]] - dm[[ ids, u ]] ) ], 0 ],
          ids ],
        Union[ VertexIndex[ graph, # ] & /@ seeds ],
        k ] ]],
      1 ] ]

InfraMeasurement[ graph_Graph, hull : InfraConvexHull[ _, ___ ], "EdgeDensity" ] :=
  AssociationThread[ EdgeList @ Subgraph[ graph, Keys @ InfraMeasurement[ graph, hull, "VertexDensity" ] ], 1 ]

InfraMeasurement[ _Graph, InfraConvexHull[ _, ___ ], "Cardinality" ] :=
  1

InfraMeasurement[ _Graph, InfraConvexHull[ _, ___ ], "Faithful" ] :=
  True

InfraMeasurement[ graph_Graph, hull : InfraConvexHull[ _, ___ ], All ] :=
  InfraMeasurement[ graph, hull,
    { "Faithful", "Cardinality", "VertexDensity", "EdgeDensity", "Subgraph",
      "CountingMeasure", "RiemannianMeasure" } ]

RandomInfraConvexHull[ graph_Graph, hull : InfraConvexHull[ _ ] | InfraConvexHull[ _, _Integer?( n |-> n >= 0 ) | Infinity ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /; SubsetQ[ First /@ Options[ RandomInfraConvexHull ], First /@ { opts } ] &&
    ( OptionValue[ RandomInfraConvexHull, { opts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) :=
  With[ { members = Keys @ InfraMeasurement[ graph, hull, "VertexDensity" ],
          nextFn = OptionValue[ RandomInfraConvexHull, { opts }, "NextVertexFunction" ] },
    { ordered = { members } },
    Which[
      count === Automatic, members,
      count === All,       ordered,
      nextFn === Identity, If[ IntegerQ @ count && Length @ ordered < count, { }, Take[ ordered, count ] ],
      IntegerQ @ count && Length @ ordered < count, { },
      True, RandomSample[ ordered, count ] ] ]

RandomInfraConvexHull[ graph_Graph, seeds_, rounds : _Integer?( n |-> n >= 0 ) | Infinity,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[] ] /; ! MatchQ[ First @ { seeds, rounds }, _InfraConvexHull ] &&
    SubsetQ[ First /@ Options[ RandomInfraConvexHull ], First /@ { opts } ] :=
  RandomInfraConvexHull[ graph, InfraConvexHull[ seeds, rounds ], count,
    "NextVertexFunction" -> OptionValue[ "NextVertexFunction" ] ]

RandomInfraConvexHull[ graph_Graph, seeds_, opts : OptionsPattern[] ] /;
    ! MatchQ[ seeds, _InfraConvexHull ] && SubsetQ[ First /@ Options[ RandomInfraConvexHull ], First /@ { opts } ] :=
  RandomInfraConvexHull[ graph, InfraConvexHull[ seeds ], Automatic, opts ]
