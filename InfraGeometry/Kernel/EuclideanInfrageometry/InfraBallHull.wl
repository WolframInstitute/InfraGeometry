Package[ "WolframInstitute`InfraGeometry`" ]

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

FindInfraRepresentative[ graph_Graph, hull : InfraBallHull[ _, ___ ],
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, mods___ ] :=
  takeRepresentatives[ { Keys @ InfraMeasurement[ graph, hull, "VertexDensity" ] }, count, mods ]
