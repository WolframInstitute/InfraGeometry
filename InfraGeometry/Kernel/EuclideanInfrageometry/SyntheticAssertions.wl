Package[ "WolframInstitute`InfraGeometry`" ]

InfraGeometricTest[ graph_Graph, InfraGeometricAssertion[ vertices_List, "Distinct" ] ] /;
    UndirectedGraphQ[ graph ] && SimpleGraphQ[ graph ] && ! WeightedGraphQ[ graph ] &&
    AllTrue[ vertices, vertex |-> VertexQ[ graph, vertex ] ] :=
  DuplicateFreeQ[ vertices, SameQ ]

InfraGeometricTest[ graph_Graph, InfraGeometricAssertion[ { vertex_, object_ }, "Member" ] ] /;
    UndirectedGraphQ[ graph ] && SimpleGraphQ[ graph ] && ! WeightedGraphQ[ graph ] && VertexQ[ graph, vertex ] :=
  With[ { density = Which[
      VertexQ[ graph, object ], <| object -> 1 |>,
      MatchQ[ object, _List | _Association | _Graph ], Quiet[ InfraDensity[ graph, object ] ],
      True, Quiet[ InfraMeasurement[ graph, object, "VertexDensity" ] ] ] },
    With[ { support = Keys @ Select[ density, value |-> value != 0 ] },
      AnyTrue[ support, point |-> point === vertex ] ] /;
      AssociationQ[ density ] && AllTrue[ Values[ density ], NumericQ ] &&
      AllTrue[ Keys[ density ], point |-> VertexQ[ graph, point ] ] ]

InfraGeometricTest[ graph_Graph, InfraGeometricAssertion[ { { p_, q_ }, { r_, s_ } }, "EqualDistance" ] ] /;
    UndirectedGraphQ[ graph ] && SimpleGraphQ[ graph ] && ! WeightedGraphQ[ graph ] &&
    AllTrue[ { p, q, r, s }, vertex |-> VertexQ[ graph, vertex ] ] :=
  With[ { distances = { InfraDistance[ graph, p, q ], InfraDistance[ graph, r, s ] } },
    AllTrue[ distances, distance |-> NumericQ[ distance ] && distance < Infinity ] && Equal @@ distances ]
