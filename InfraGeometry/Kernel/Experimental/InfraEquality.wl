Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: Experimental :: InfraEquality *)

Options[ InfraEqualQ ] = { Method -> "Diffuse" }

InfraEqualQ[ graph_Graph, a_, b_, opts : OptionsPattern[] ] /;
    MatchQ[ OptionValue[ InfraEqualQ, { opts }, Method ], "Overlap" | "Diffuse" | "Set" | "Multiset" ] :=
  With[ { ma = InfraMeasurement[ graph, a, "VertexDensity" ], mb = InfraMeasurement[ graph, b, "VertexDensity" ] },
    Switch[ OptionValue @ Method,
      "Overlap",  Total @ Merge[ KeyIntersection @ { ma, mb }, Min ] > 0,
      "Diffuse",  3 Total @ Merge[ KeyIntersection @ { ma, mb }, Min ] > Total @ ma + Total @ mb,
      "Set",      Sort @ Keys @ ma === Sort @ Keys @ mb,
      "Multiset", KeySort @ ma === KeySort @ mb ] /;
      AssociationQ @ ma && AssociationQ @ mb ]
