Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraAngle *)

Options[ InfraAngle ] = { "RadiusDelta" -> 0 }

InfraAngle[ graph_Graph, { q1_, p_, q2_ }, opts : OptionsPattern[] ] /;
    SubsetQ[ First /@ Options[ InfraAngle ], First /@ { opts } ] :=
  InfraMeasurement[ graph, InfraArc[ p, { q1, q2 }, "RadiusDelta" -> OptionValue[ "RadiusDelta" ] ], "Length" ]
