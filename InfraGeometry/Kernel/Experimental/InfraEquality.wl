Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: Experimental :: InfraEquality *)

Options[ InfraEqualQ ] = { Method -> "Diffuse" }

InfraEqualQ[ graph_Graph, a_, b_, opts : OptionsPattern[] ] /;
    MatchQ[ OptionValue[ InfraEqualQ, { opts }, Method ], "Overlap" | "Diffuse" | "Set" | "Multiset" ] :=
  With[ { ma = InfraDensity[ graph, a ], mb = InfraDensity[ graph, b ] },
    { capMass = Total @ KeyValueMap[ { k, v } |-> Min[ v, Lookup[ mb, k, 0 ] ], ma ] },
    Switch[ OptionValue @ Method,
      "Overlap",  capMass > 0,
      "Diffuse",  3 capMass > Total @ ma + Total @ mb,
      "Set",      Sort @ Keys @ ma === Sort @ Keys @ mb,
      "Multiset", KeySort @ ma === KeySort @ mb
    ]
  ]
