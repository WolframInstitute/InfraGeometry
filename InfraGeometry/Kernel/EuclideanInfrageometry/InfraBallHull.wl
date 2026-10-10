Package[ "WolframInstitute`InfraGeometry`" ]

Options[ RandomInfraBallHull ] = { "NextVertexFunction" -> Automatic }

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraBallHull *)

(* the intersection of the closed balls B_rho(c) containing S with rho in the band {r, t}: at a centre c the least ball containing S has the
   radius r_c = max_{s in S} d(c, s), so the least admissible one has the radius max(r_c, r) and exists iff r_c <= t; with no such c the family is
   empty and the hull is the whole graph.  A bare r is the band {0, r}, the balls of radius at most r, and {r} the band {r, r}, exactly r;
   InfraBallHull[S] is {0, Infinity}, the Mazur hull.  The distances are clipped at the vertex count, where a centre that misses a seed's component
   constrains nothing, and r at n - 1, the radius past which a ball is its component *)

InfraMeasurement[ graph_Graph, InfraBallHull[ s_ ], "VertexDensity" ] :=
  InfraMeasurement[ graph, InfraBallHull[ s, { 0, Infinity } ], "VertexDensity" ]

InfraMeasurement[ graph_Graph, InfraBallHull[ s_, r : Except[ _List ] ], "VertexDensity" ] :=
  InfraMeasurement[ graph, InfraBallHull[ s, { 0, r } ], "VertexDensity" ]

InfraMeasurement[ graph_Graph, InfraBallHull[ s_, { r_ } ], "VertexDensity" ] :=
  InfraMeasurement[ graph, InfraBallHull[ s, { r, r } ], "VertexDensity" ]

InfraMeasurement[ graph_Graph, InfraBallHull[ s_, { r_, t_ } ], "VertexDensity" ] :=
  With[ { n = VertexCount @ graph, vlist = VertexList @ graph },
    { dm = Clip[ GraphDistanceMatrix @ graph, { 0, n } ],
      seeds = Keys @ If[ VertexQ[ graph, s ] || MatchQ[ s, _List | _Association | _Graph ],
        InfraDensity[ graph, s ],
        InfraMeasurement[ graph, s, "VertexDensity" ] ] },
    { radii = Max /@ dm[[ All, VertexIndex[ graph, # ] & /@ seeds ]] },
    AssociationThread[ Sort @ Pick[ vlist, Times @@ UnitStep[ ( If[ # <= t, Max[ #, Min[ r, n - 1 ] ], n ] & /@ radii ) - dm ], 1 ], 1 ] ]

InfraMeasurement[ graph_Graph, hull : InfraBallHull[ _, ___ ], "EdgeDensity" ] :=
  AssociationThread[ EdgeList @ Subgraph[ graph, Keys @ InfraMeasurement[ graph, hull, "VertexDensity" ] ], 1 ]

InfraMeasurement[ _Graph, InfraBallHull[ _, ___ ], "Cardinality" ] :=
  1

InfraMeasurement[ _Graph, InfraBallHull[ _, ___ ], "Faithful" ] :=
  True

InfraMeasurement[ graph_Graph, hull : InfraBallHull[ _, ___ ], All ] :=
  InfraMeasurement[ graph, hull,
    { "Faithful", "Cardinality", "VertexDensity", "EdgeDensity", "Subgraph",
      "CountingMeasure", "RiemannianMeasure" } ]

RandomInfraBallHull[ graph_Graph, hull : InfraBallHull[ _ ] | InfraBallHull[ _, _?NumericQ | Infinity | { _?NumericQ | Infinity } | { _?NumericQ | Infinity, _?NumericQ | Infinity } ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /; SubsetQ[ First /@ Options[ RandomInfraBallHull ], First /@ { opts } ] &&
    ( OptionValue[ RandomInfraBallHull, { opts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) :=
  With[ { members = Keys @ InfraMeasurement[ graph, hull, "VertexDensity" ],
          nextFn = OptionValue[ RandomInfraBallHull, { opts }, "NextVertexFunction" ] },
    { ordered = { members } },
    Which[
      count === Automatic, members,
      count === All,       ordered,
      nextFn === Identity, If[ IntegerQ @ count && Length @ ordered < count, { }, Take[ ordered, count ] ],
      IntegerQ @ count && Length @ ordered < count, { },
      True, RandomSample[ ordered, count ] ] ]

RandomInfraBallHull[ graph_Graph, seeds_, band : _?NumericQ | Infinity | { _?NumericQ | Infinity } | { _?NumericQ | Infinity, _?NumericQ | Infinity },
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[] ] /; ! MatchQ[ First @ { seeds, band }, _InfraBallHull ] &&
    SubsetQ[ First /@ Options[ RandomInfraBallHull ], First /@ { opts } ] :=
  RandomInfraBallHull[ graph, InfraBallHull[ seeds, band ], count,
    "NextVertexFunction" -> OptionValue[ "NextVertexFunction" ] ]

RandomInfraBallHull[ graph_Graph, seeds_, opts : OptionsPattern[] ] /;
    ! MatchQ[ seeds, _InfraBallHull ] && SubsetQ[ First /@ Options[ RandomInfraBallHull ], First /@ { opts } ] :=
  RandomInfraBallHull[ graph, InfraBallHull[ seeds ], Automatic, opts ]
