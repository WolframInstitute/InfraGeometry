Package["WolframInstitute`InfraGeometry`"]

(* the closed ball { v : d(c, v) <= r }, a sorted vertex list.  The centre goes through the anchor rule, and an anchor of several vertices weights one carrier rather than multiplying objects: the ball of a set is its closed r-neighbourhood, the union of the balls around its members *)

FindInfraBall[ graph_Graph, c_, r_ ] :=
  With[ { centers = Keys @ InfraDensity[ graph, c ] },
    Union @ Select[ VertexList[ graph ],
      v |-> AnyTrue[ centers, GraphDistance[ graph, #, v ] <= r & ] ] ]

(* vs is a closed ball iff some c in vs has { v : d(c, v) <= max_{w in vs} d(c, w) } == vs; a family of sets passes iff each does *)

InfraBallQ[ graph_Graph, fam_Association ] := InfraBallQ[ graph, Keys @ fam ]

InfraBallQ[ graph_Graph, sets : { __List } ] /; ! AllTrue[ sets, VertexQ[ graph, # ] & ] :=
  AllTrue[ sets, InfraBallQ[ graph, # ] & ]

InfraBallQ[ graph_Graph, vs_List ] :=
  vs =!= { } &&
  AnyTrue[ vs, c |->
    With[ { r = Max @ ( GraphDistance[ graph, c, # ] & /@ vs ) },
      Sort @ Select[ VertexList[ graph ], GraphDistance[ graph, c, # ] <= r & ] === Sort @ vs
    ]
  ]

FindBallHull[ graph_Graph, s_ ] :=
  Union @ BallHull[ graph, Keys @ InfraDensity[ graph, s ] ]

BallHullQ[ graph_Graph, s_ ] :=
  With[ { vs = Keys @ InfraDensity[ graph, s ] },
    Sort @ BallHull[ graph, vs ] === vs ]

dispatchConstruction[ graph_Graph, InfraBall[ center_, r_ ] ] :=
  applySelectOption[ graph,
    { FindInfraBall[ graph, center, r ] },
    None, False, <| "Center" -> center, "Radius" -> r |> ]
