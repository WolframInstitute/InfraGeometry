Package[ "WolframInstitute`InfraGeometry`" ]

(* the tube { v : d(v, C) <= s } with d(v, C) = min_{c in C} d(v, c) over the core's vertices C; a band {s, t} is the complement of two tubes *)

InfraMeasurement[ graph_Graph, InfraTube[ core_, s : Except[ _List ] ], "VertexDensity" ] :=
  With[
    { support = Keys @ If[ VertexQ[ graph, core ] || MatchQ[ core, _List | _Association | _Graph ],
        InfraDensity[ graph, core ],
        InfraMeasurement[ graph, core, "VertexDensity" ] ] },
    AssociationThread[ Union @ VertexList @ NeighborhoodGraph[ graph, support, Floor @ Min[ s, VertexCount @ graph ] ], 1 ] ]

InfraMeasurement[ graph_Graph, InfraTube[ core_, { s_, t_ } ], "VertexDensity" ] :=
  AssociationThread[
    Complement[
      Keys @ InfraMeasurement[ graph, InfraTube[ core, t ], "VertexDensity" ],
      If[ s > 0, Keys @ InfraMeasurement[ graph, InfraTube[ core, Ceiling[ s ] - 1 ], "VertexDensity" ], { } ] ],
    1 ]

InfraMeasurement[ graph_Graph, InfraCylinder[ axis_, r_ ], "VertexDensity" ] :=
  InfraMeasurement[ graph, InfraTube[ axis, r ], "VertexDensity" ]

(* the cone { v : exists i, d(v, a_i) <= slope (i - 1) } along the axis a_1, ..., a_n with apex a_1 *)

InfraMeasurement[ graph_Graph, InfraCone[ axis_List, slope_ ], "VertexDensity" ] :=
  AssociationThread[
    Union @@ MapIndexed[ { a, i } |-> Keys @ InfraMeasurement[ graph, InfraTube[ a, slope ( First @ i - 1 ) ], "VertexDensity" ], axis ],
    1 ]

InfraMeasurement[ graph_Graph, region : ( InfraTube | InfraCylinder | InfraCone )[ _, _ ], "EdgeDensity" ] :=
  AssociationThread[ EdgeList @ Subgraph[ graph, Keys @ InfraMeasurement[ graph, region, "VertexDensity" ] ], 1 ]

InfraMeasurement[ _Graph, ( InfraTube | InfraCylinder | InfraCone )[ _, _ ], "Cardinality" ] :=
  1

InfraMeasurement[ _Graph, ( InfraTube | InfraCylinder | InfraCone )[ _, _ ], "Faithful" ] :=
  True

InfraMeasurement[ graph_Graph, region : ( InfraTube | InfraCylinder | InfraCone )[ _, _ ], All ] :=
  InfraMeasurement[ graph, region,
    { "Faithful", "Cardinality", "VertexDensity", "EdgeDensity", "Subgraph",
      "Volume", "BoundaryVolume", "InteriorVolume", "HalfBoundaryVolume" } ]

FindInfraRepresentative[ graph_Graph, region : ( InfraTube | InfraCylinder | InfraCone )[ _, _ ],
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, mods___ ] :=
  takeRepresentatives[ { Keys @ InfraMeasurement[ graph, region, "VertexDensity" ] }, count, mods ]
