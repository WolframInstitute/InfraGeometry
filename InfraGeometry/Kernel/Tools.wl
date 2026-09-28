Package["WolframInstitute`InfraGeometry`"]


(* ===================== InfraDensity ===================== *)

(* the marginal of a shape to the vertex set, <| v -> m |>: the anchor rule every construction reads its anchors through.  The branches are ordered because a vertex label may itself be a List.  A bundle sums by GroupBy, not Merge[ ..., Total ], which is quadratic in the member count: 18 s against 0.2 s on 16000 walks *)

InfraDensity[ graph_Graph, x_ ] := Which[
  VertexQ[ graph, x ],                                  <| x -> 1 |>,
  AssociationQ[ x ],                                    KeySort @ x,
  GraphQ[ x ],                                          KeySort @ Which[
    AllTrue[ VertexList @ x, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ VertexList @ x ] === Range @ VertexCount @ x,
      Counts[ Last /@ VertexList @ x ],
    ! LoopFreeGraphQ[ x ] || ! AcyclicGraphQ[ x ],      Counts @ VertexList @ x,
    True,                                               GeodesicOccupation @ x ],
  ListQ[ x ] && AllTrue[ x, VertexQ[ graph, # ] & ],    KeySort @ Counts @ x,
  MatchQ[ x, { ( _Graph | _List ) .. } ],               KeySort @ GroupBy[ Catenate[ Normal[ InfraDensity[ graph, # ] ] & /@ x ], First -> Last, Total ],
  ListQ[ x ],                                           KeySort @ Counts @ x,
  True,                                                 <| x -> 1 |> ]
