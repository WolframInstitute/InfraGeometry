Package[ "WolframInstitute`InfraGeometry`" ]

(* the intersection of the closed balls of radius at most r containing S: at a centre c the least of them has the radius r_c = max_{s in S} d(c, s),
   so v is in the hull iff d(c, v) <= r_c for every c with r_c <= r; with no such c the family is empty and the hull is the whole graph.
   r = Infinity is the Mazur hull.  The distances are clipped at the vertex count, where a centre that misses a seed's component constrains nothing *)

InfraMeasurement[ graph_Graph, InfraBallHull[ s_, r_ : Infinity ], "VertexDensity" ] :=
  With[ { n = VertexCount @ graph, vlist = VertexList @ graph },
    { dm = Clip[ GraphDistanceMatrix @ graph, { 0, n } ],
      seeds = Keys @ If[ VertexQ[ graph, s ] || MatchQ[ s, _List | _Association | _Graph ],
        InfraDensity[ graph, s ],
        InfraMeasurement[ graph, s, "VertexDensity" ] ] },
    { radii = Max /@ dm[[ All, VertexIndex[ graph, # ] & /@ seeds ]] },
    AssociationThread[ Sort @ Pick[ vlist, Times @@ UnitStep[ ( If[ # <= r, #, n ] & /@ radii ) - dm ], 1 ], 1 ] ]

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
