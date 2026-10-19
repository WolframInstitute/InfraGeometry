Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: RiemannianInfrageometry :: Experimental :: InfraComparisonAngle *)

Options[ InfraComparisonAngle ] = { "Curvature" -> 0 }

InfraComparisonAngle[ graph_Graph, { q1_, p_, q2_ }, opts : OptionsPattern[] ] :=
  With[ { curvature = OptionValue[ "Curvature" ],
          opposite = GraphDistance[ graph, q1, q2 ],
          first = GraphDistance[ graph, p, q1 ], second = GraphDistance[ graph, p, q2 ] },
    { scale = Sqrt @ Abs @ curvature },
    ArcCos @ Which[
      curvature == 0, ( first^2 + second^2 - opposite^2 ) / ( 2 first second ),
      curvature > 0,
        ( Cos[ opposite scale ] - Cos[ first scale ] Cos[ second scale ] ) / ( Sin[ first scale ] Sin[ second scale ] ),
      curvature < 0,
        ( Cosh[ first scale ] Cosh[ second scale ] - Cosh[ opposite scale ] ) / ( Sinh[ first scale ] Sinh[ second scale ] ) ] ]
