Package["WolframInstitute`SyntheticInfrageometry`"]


(* ===================== InfraDensity ===================== *)

(* the marginal of a shape to the vertex set, <| v -> m |>: the anchor rule every construction reads its anchors through.  The branches are ordered because a vertex label may itself be a List *)

InfraDensity[ graph_Graph, x_ ] := Which[
  VertexQ[ graph, x ],                                  <| x -> 1 |>,
  AssociationQ[ x ],                                    KeySort @ x,
  GraphQ[ x ],                                          KeySort @ Which[
    AllTrue[ VertexList @ x, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ VertexList @ x ] === Range @ VertexCount @ x,
      Counts[ Last /@ VertexList @ x ],
    ! LoopFreeGraphQ[ x ] || ! AcyclicGraphQ[ x ],      Counts @ VertexList @ x,
    True,                                               GeodesicOccupation @ x ],
  ListQ[ x ] && AllTrue[ x, VertexQ[ graph, # ] & ],    KeySort @ Counts @ x,
  MatchQ[ x, { ( _Graph | _List ) .. } ],               KeySort @ Merge[ InfraDensity[ graph, # ] & /@ x, Total ],
  ListQ[ x ],                                           KeySort @ Counts @ x,
  True,                                                 <| x -> 1 |> ]
