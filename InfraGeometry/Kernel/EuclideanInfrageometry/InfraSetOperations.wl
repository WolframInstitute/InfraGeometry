Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraSetOperations *)

(* each vertex u of the front S_i steps one shell outward from S_{i-1} -- to the neighbours v with d(S_{i-1}, v) = d(S_{i-1}, u) + 1 -- and reflects
   where there is no outward neighbour, stepping back to a neighbour at d(u) - 1.
   The state is the pair (S_{i-1}, S_i), so this is a NestList on consecutive fronts: the discrete second-order (wave-equation) form, momentum
   carried as the trailing front. *)

FindAdvancingInfraFront[ graph_Graph, origin_, steps_Integer ] :=
  With[
    { vl  = VertexList[ graph ],
      src = Keys @ InfraMeasurement[ graph, origin, "VertexDensity" ] },
    { adj  = AssociationMap[ AdjacencyList[ graph, # ] &, vl ],
      vidx = AssociationThread[ vl, Range[ Length @ vl ] ],
      dm   = GraphDistanceMatrix[ graph ] },
    { step = pair |-> With[
        { prev = pair[[ 1 ]], cur = pair[[ 2 ]] },
        { dp = AssociationThread[ vl, Min /@ Transpose[ dm[[ Lookup[ vidx, prev ] ]] ] ] },
        { cur, DeleteDuplicates @ Catenate[
          ( u |-> With[
              { out = Select[ adj @ u, dp[ # ] == dp[ u ] + 1 & ],
                in  = Select[ adj @ u, dp[ # ] == dp[ u ] - 1 & ] },
              Which[ out =!= { }, out, in =!= { }, in, True, { u } ] ] ) /@ cur ] } ] },
    Union /@ NestList[ step, { src, src }, steps ][[ All, 2 ]]
  ]

Options[ InfraBoundary ] = { Method -> "Combinatorial" }
Options[ InfraInterior ] = { Method -> "Combinatorial" }

InfraBoundary[ g_Graph, s_, opts : OptionsPattern[] ] /;
    MatchQ[ OptionValue[ InfraBoundary, { opts }, Method ], "Combinatorial" | "Alexandrov" | { "Combinatorial" | "Alexandrov", ___ } ] :=
  With[ { density = InfraMeasurement[ g, s, "VertexDensity" ] },
    Switch[ Replace[ OptionValue[ Method ], { m_String, ___ } :> m ],
      "Combinatorial", Union @ GraphBoundary[ g, Keys @ density ],
      "Alexandrov",    Union @ TopologicalBoundary[
        BallTopology[ g, Lookup[ Replace[ OptionValue[ Method ], { { _String, o___ } :> { o }, _ -> { } } ], "Radius", 1 ] ], Keys @ density ] ] /;
      AssociationQ @ density ]

InfraInterior[ g_Graph, s_, opts : OptionsPattern[] ] /;
    MatchQ[ OptionValue[ InfraInterior, { opts }, Method ], "Combinatorial" | "Alexandrov" | { "Combinatorial" | "Alexandrov", ___ } ] :=
  With[ { density = InfraMeasurement[ g, s, "VertexDensity" ] },
    Switch[ Replace[ OptionValue[ Method ], { m_String, ___ } :> m ],
      "Combinatorial", Union @ GraphInterior[ g, Keys @ density ],
      "Alexandrov",    Union @ TopologicalInterior[
        BallTopology[ g, Lookup[ Replace[ OptionValue[ Method ], { { _String, o___ } :> { o }, _ -> { } } ], "Radius", 1 ] ], Keys @ density ] ] /;
      AssociationQ @ density ]
