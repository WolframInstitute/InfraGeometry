Package[ "WolframInstitute`InfraGeometry`" ]

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

RandomInfraRepresentative[ graph_Graph, hull : InfraConvexHull[ _, ___ ],
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    ( OptionValue[ RandomInfraRepresentative, { opts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) :=
  With[ { members = Keys @ InfraMeasurement[ graph, hull, "VertexDensity" ],
          nextFn = OptionValue[ RandomInfraRepresentative, { opts }, "NextVertexFunction" ] },
    { ordered = { members } },
    Which[
      count === Automatic, members,
      count === All,       ordered,
      nextFn === Identity, If[ IntegerQ @ count && Length @ ordered < count, { }, Take[ ordered, count ] ],
      IntegerQ @ count && Length @ ordered < count, { },
      True, RandomSample[ ordered, count ] ] ]
