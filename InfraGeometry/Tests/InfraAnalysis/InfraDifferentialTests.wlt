BeginTestSection["InfraDifferential"]

(* ===== InfraDifferential: the 1-form df(u -> v) = f(v) - f(u) on the links of a DAG, on every edge of an undirected substrate ===== *)

differentialDiamond = Graph[ { 1, 2, 3, 4 }, { 1 -> 2, 1 -> 3, 2 -> 4, 3 -> 4 } ]

differentialImplied = Graph[ Range[ 6 ], { 1 -> 2, 2 -> 3, 1 -> 3, 1 -> 4, 4 -> 5, 3 -> 5, 2 -> 6, 5 -> 6, 1 -> 6, 1 -> 5 } ]

differentialF = <| 1 -> 5, 2 -> -2, 3 -> 7, 4 -> 1, 5 -> 3, 6 -> -4 |>

differentialH = <| 1 -> 2, 2 -> 3, 3 -> -1, 4 -> 4, 5 -> 0, 6 -> 6 |>

VerificationTest[
  InfraMeasurement[ differentialDiamond, InfraDifferential[ differentialF ], "Function" ],
  <| DirectedEdge[ 1, 2 ] -> -7, DirectedEdge[ 1, 3 ] -> 2, DirectedEdge[ 2, 4 ] -> 3, DirectedEdge[ 3, 4 ] -> -6 |>,
  TestID -> "InfraDifferential-Diamond-links"
]

(* the differential reads the order, not its encoding: implied edges carry no value, and the transitive closure and reduction give the same 1-form *)
VerificationTest[
  With[ { df = InfraMeasurement[ differentialImplied, InfraDifferential[ differentialF ], "Function" ] },
    { Keys @ df === EdgeList @ TransitiveReductionGraph @ differentialImplied,
      df === InfraMeasurement[ TransitiveClosureGraph @ differentialImplied, InfraDifferential[ differentialF ], "Function" ],
      df === InfraMeasurement[ TransitiveReductionGraph @ differentialImplied, InfraDifferential[ differentialF ], "Function" ] } ],
  { True, True, True },
  TestID -> "InfraDifferential-ImpliedEdgesDAG-order-invariance"
]

VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ], f = AssociationThread[ Range[ 9 ], Prime /@ Range[ 9 ] ] },
    InfraMeasurement[ g, InfraDifferential[ f ], "Function" ] ===
      AssociationMap[ e |-> f[ Last @ e ] - f[ First @ e ], DirectedEdge @@@ EdgeList @ g ] ],
  True,
  TestID -> "InfraDifferential-GridGraph-every-edge-in-EdgeList-orientation"
]

(* a function applied to each vertex is the same 0-form as its Association *)
VerificationTest[
  With[ { g = GridGraph[ { 3, 3 } ] },
    InfraMeasurement[ g, InfraDifferential[ #^2 & ], "Function" ] ===
      InfraMeasurement[ g, InfraDifferential[ AssociationThread[ Range[ 9 ], Range[ 9 ]^2 ] ], "Function" ] ],
  True,
  TestID -> "InfraDifferential-GridGraph-function-integrand"
]

(* Leibniz: d(f h) = f dh + h df + df dh on every link, f and h read at its start *)
VerificationTest[
  With[ { df = InfraMeasurement[ differentialImplied, InfraDifferential[ differentialF ], "Function" ],
          dh = InfraMeasurement[ differentialImplied, InfraDifferential[ differentialH ], "Function" ],
          dfh = InfraMeasurement[ differentialImplied, InfraDifferential[ differentialF differentialH ], "Function" ] },
    AllTrue[ Keys @ dfh, e |-> dfh[ e ] == differentialF[ First @ e ] dh[ e ] + differentialH[ First @ e ] df[ e ] + df[ e ] dh[ e ] ] ],
  True,
  TestID -> "InfraDifferential-ImpliedEdgesDAG-Leibniz"
]

VerificationTest[
  With[ { g = GridGraph[ { 4, 3 } ], f = AssociationThread[ Range[ 12 ], Prime /@ Range[ 12 ] ], h = AssociationThread[ Range[ 12 ], Mod[ Range[ 12 ]^2, 7 ] ] },
    With[ { df = InfraMeasurement[ g, InfraDifferential[ f ], "Function" ], dh = InfraMeasurement[ g, InfraDifferential[ h ], "Function" ],
            dfh = InfraMeasurement[ g, InfraDifferential[ f h ], "Function" ] },
      AllTrue[ Keys @ dfh, e |-> dfh[ e ] == f[ First @ e ] dh[ e ] + h[ First @ e ] df[ e ] + df[ e ] dh[ e ] ] ] ],
  True,
  TestID -> "InfraDifferential-GridGraph-Leibniz"
]

(* heads compose: the differential of an antiderivative is the differential of its "Function" *)
VerificationTest[
  InfraMeasurement[ differentialDiamond, InfraDifferential[ InfraAntiderivative[ differentialF, Method -> "PathCount" ] ], "Function" ] ===
    InfraMeasurement[ differentialDiamond, InfraDifferential[ InfraMeasurement[ differentialDiamond, InfraAntiderivative[ differentialF, Method -> "PathCount" ], "Function" ] ], "Function" ],
  True,
  TestID -> "InfraDifferential-Diamond-of-an-antiderivative-head"
]

VerificationTest[
  InfraMeasurement[ differentialDiamond, InfraDifferential[ differentialF ], All ],
  <| "Function" -> InfraMeasurement[ differentialDiamond, InfraDifferential[ differentialF ], "Function" ] |>,
  TestID -> "InfraDifferential-Diamond-All"
]

(* a directed graph with a cycle has no order, and a 1-form is not differentiated: both stay unevaluated with no message *)
VerificationTest[
  { Head @ InfraMeasurement[ Graph[ { 1 -> 2, 2 -> 3, 3 -> 1 } ], InfraDifferential[ differentialF ], "Function" ],
    Head @ InfraMeasurement[ Graph[ { 1 -> 2, 2 -> 3, 3 -> 1 } ], InfraDifferential[ differentialF ], All ],
    Head @ InfraMeasurement[ differentialDiamond, InfraDifferential[ <| DirectedEdge[ 1, 2 ] -> 1 |> ], "Function" ] },
  { InfraMeasurement, InfraMeasurement, InfraMeasurement },
  TestID -> "InfraDifferential-cyclic-digraph-and-1-form-unevaluated"
]

(* the generic readings of InfraMeasurement need a "Graph" and stay unevaluated on a differential *)
VerificationTest[
  Head @ InfraMeasurement[ differentialDiamond, InfraDifferential[ differentialF ], # ] & /@
    { "Graph", "Cardinality", "Length", "VertexDensity", "EdgeDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure", "Faithful" },
  ConstantArray[ InfraMeasurement, 9 ],
  TestID -> "InfraDifferential-generic-readings-unevaluated"
]

(* ===== InfraCodifferential: the 0-form, incoming minus outgoing link values; on an undirected substrate the sum of w(u -> v) over u ~ v ===== *)

VerificationTest[
  InfraMeasurement[ differentialDiamond,
    InfraCodifferential[ <| DirectedEdge[ 1, 2 ] -> 3, DirectedEdge[ 1, 3 ] -> 5, DirectedEdge[ 2, 4 ] -> -1, DirectedEdge[ 3, 4 ] -> 2 |> ], "Function" ],
  <| 1 -> -8, 2 -> 4, 3 -> 3, 4 -> 1 |>,
  TestID -> "InfraCodifferential-Diamond-in-minus-out"
]

(* a 1-form is read antisymmetrically: w(v -> u) = -w(u -> v), whichever orientation the Association names *)
VerificationTest[
  InfraMeasurement[ PathGraph[ Range[ 4 ] ], InfraCodifferential[ <| DirectedEdge[ 1, 2 ] -> 3, DirectedEdge[ 3, 2 ] -> 5, DirectedEdge[ 3, 4 ] -> 1 |> ], "Function" ],
  <| 1 -> -3, 2 -> 8, 3 -> -6, 4 -> 1 |>,
  TestID -> "InfraCodifferential-PathGraph-antisymmetric"
]

(* delta d is the Laplacian: of the undirected Hasse diagram on a DAG, of the graph on an undirected substrate *)
VerificationTest[
  Values @ InfraMeasurement[ differentialImplied, InfraCodifferential[ InfraDifferential[ differentialF ] ], "Function" ] ===
    KirchhoffMatrix[ UndirectedGraph @ TransitiveReductionGraph @ differentialImplied ] . Values[ differentialF ],
  True,
  TestID -> "InfraCodifferential-ImpliedEdgesDAG-delta-d-is-Laplacian"
]

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ], f = AssociationThread[ Range[ 16 ], Prime /@ Range[ 16 ] ] },
    Values @ InfraMeasurement[ g, InfraCodifferential[ InfraDifferential[ f ] ], "Function" ] === Normal[ KirchhoffMatrix[ g ] ] . Values[ f ] ],
  True,
  TestID -> "InfraCodifferential-GridGraph-delta-d-is-Laplacian"
]

VerificationTest[
  With[ { w = AssociationThread[ EdgeList @ TransitiveReductionGraph @ differentialImplied, { 2, -1, 4, 3, -5, 1 } ] },
    InfraMeasurement[ differentialImplied, InfraCodifferential[ w ], "Function" ] ===
      InfraMeasurement[ TransitiveClosureGraph @ differentialImplied, InfraCodifferential[ w ], "Function" ] ],
  True,
  TestID -> "InfraCodifferential-ImpliedEdgesDAG-order-invariance"
]

(* the region of every vertex has no boundary, so the codifferential sums to zero *)
VerificationTest[
  SeedRandom[ 3 ];
  With[ { g = GridGraph[ { 4, 5 } ] },
    { w = AssociationThread[ RandomChoice[ { DirectedEdge @@ #, DirectedEdge @@ Reverse @ # } ] & /@ ( List @@@ EdgeList @ g ), RandomInteger[ { -5, 5 }, EdgeCount @ g ] ] },
    Total @ InfraMeasurement[ g, InfraCodifferential[ w ], "Function" ] ],
  0,
  TestID -> "InfraCodifferential-GridGraph-sums-to-zero"
]

VerificationTest[
  Head @ InfraMeasurement[ differentialDiamond, InfraCodifferential[ differentialF ], "Function" ],
  InfraMeasurement,
  TestID -> "InfraCodifferential-0-form-unevaluated"
]

EndTestSection[]
