BeginTestSection[ "ForwardDeformations" ]

VerificationTest[
  Head @ InfraForwardDeformation[ { 1, 2, 3 }, UpTo[ 2 ] ],
  InfraForwardDeformation,
  TestID -> "ForwardDeformation-inert-token"
]

VerificationTest[
  With[ { graph = CycleGraph[ 4 ], reference = { 1, 2, 3 } },
    { FindInfraForwardDeformation[ graph, InfraForwardDeformation[ reference, UpTo[ 3 ], "TubeRadius" -> 0 ], All ],
      InfraMeasurement[ graph, InfraForwardDeformation[ reference, { 0 }, "TubeRadius" -> 0 ], "Cardinality" ],
      InfraMeasurement[ graph, InfraForwardDeformation[ reference, { 1 }, "TubeRadius" -> 0 ], "Cardinality" ] } ],
  { { { 1, 2, 3 } }, 1, 0 },
  TestID -> "ForwardDeformation-zero-tube-is-reference"
]

VerificationTest[
  Sort @ FindInfraForwardDeformation[ CycleGraph[ 4 ], InfraForwardDeformation[ { 1, 2, 3 }, { 0 } ], All ],
  { { 1, 2, 3 }, { 1, 4, 3 } },
  TestID -> "ForwardDeformation-zero-excess-can-have-other-geodesics"
]

VerificationTest[
  With[ { graph = CycleGraph[ 4 ] },
    FindInfraForwardDeformation[ graph,
      InfraForwardDeformation[ #, UpTo[ 2 ], "TubeRadius" -> 0 ], All ] & /@ { { 1, 2, 3 }, { 1, 4, 3 } } ],
  { { { 1, 2, 3 } }, { { 1, 4, 3 } } },
  TestID -> "ForwardDeformation-family-depends-on-reference"
]

VerificationTest[
  With[ { graph = CompleteGraph[ 3 ] },
    { InfraMeasurement[ graph, InfraForwardDeformation[ { 1, 2 }, { 2 } ], "Cardinality" ],
      FindInfraForwardDeformation[ graph,
        InfraForwardDeformation[ { 1, 2 }, { 2 }, "FirstArrival" -> False ], All ] } ],
  { 0, { { 1, 2, 3, 2 } } },
  TestID -> "ForwardDeformation-first-arrival-is-explicit"
]

VerificationTest[
  With[ { graph = Graph[ { 1 <-> 2, 1 <-> 3, 2 <-> 3, 2 <-> 4, 3 <-> 4 } ],
      object = InfraForwardDeformation[ { 1, 2, 4 }, UpTo[ 4 ] ] },
    { InfraMeasurement[ graph, object, "Cardinality" ],
      Length @ FindInfraForwardDeformation[ graph, object, All ],
      InfraMeasurement[ graph, object, "Length" ],
      AllTrue[ InfraMeasurement[ graph, object, "Graph" ], AcyclicGraphQ ] } ],
  { 10, 10, { 2, 3, 4, 5, 6 }, True },
  TestID -> "ForwardDeformation-trellis-counts-transverse-repetitions"
]

VerificationTest[
  With[ { graph = CycleGraph[ 4 ], object = InfraForwardDeformation[ { 1, 2, 3 }, { 0 } ] },
    { Length @ FindInfraForwardDeformation[ graph, object ],
      Length @ FindInfraForwardDeformation[ graph, object, 2 ],
      FindInfraForwardDeformation[ graph, object, 3 ],
      Length @ FindInfraForwardDeformation[ graph, object, UpTo[ 3 ] ] } ],
  { 3, 2, { }, 2 },
  TestID -> "ForwardDeformation-finder-count-contract"
]

VerificationTest[
  { InfraMeasurement[ PathGraph[ Range[ 3 ] ], InfraForwardDeformation[ { 2 }, UpTo[ 2 ] ], "Cardinality" ],
    FindInfraForwardDeformation[ PathGraph[ Range[ 3 ] ], InfraForwardDeformation[ { 2 }, { 0 } ], All ] },
  { 1, { { 2 } } },
  TestID -> "ForwardDeformation-constant-reference"
]

VerificationTest[
  MatchQ[ InfraMeasurement[ CompleteGraph[ 3 ], InfraForwardDeformation[ { 1, 2, 3 }, { 0 } ], "Graph" ], _InfraMeasurement ],
  True,
  TestID -> "ForwardDeformation-nongeodesic-reference-is-nonmatch"
]

VerificationTest[
  MatchQ[ InfraMeasurement[ CycleGraph[ 4 ],
    InfraForwardDeformation[ { 1, 2, 3 }, { 0 }, "UnknownOption" -> 1 ], "Graph" ], _InfraMeasurement ],
  True,
  TestID -> "ForwardDeformation-unknown-option-is-nonmatch"
]

VerificationTest[
  MapThread[
    { graph, reference, matrix } |-> Table[
      InfraMeasurement[ graph, InfraForwardDeformation[ reference, { excess }, "TubeRadius" -> Infinity ], "Cardinality" ] ==
        MatrixPower[ matrix, Length @ reference - 1 + excess ][[ 1, Last @ reference ]],
      { excess, 0, 3 } ],
    { { CompleteGraph[ 3 ], CycleGraph[ 4 ], Graph[ { 1 <-> 2, 1 <-> 3, 2 <-> 3, 2 <-> 4, 3 <-> 4 } ] },
      { { 1, 2 }, { 1, 2, 3 }, { 1, 2, 4 } },
      { { { 0, 1, 1 }, { 0, 0, 0 }, { 0, 1, 0 } },
        { { 0, 1, 0, 1 }, { 0, 0, 1, 0 }, { 0, 0, 0, 0 }, { 0, 0, 1, 0 } },
        { { 0, 1, 1, 0 }, { 0, 0, 1, 1 }, { 0, 1, 0, 1 }, { 0, 0, 0, 0 } } } } ],
  ConstantArray[ True, { 3, 4 } ],
  TestID -> "ForwardDeformation-counts-match-independent-transfer-matrices"
]

VerificationTest[
  With[ { graph = Graph[ { 1 <-> 2, 1 <-> 3, 2 <-> 3, 2 <-> 4, 3 <-> 4 } ],
      object = InfraForwardDeformation[ { 1, 2, 4 }, UpTo[ 2 ] ] },
    { walks = FindInfraForwardDeformation[ graph, object, All ],
      vertices = InfraMeasurement[ graph, object, "VertexDensity" ],
      edges = InfraMeasurement[ graph, object, "EdgeDensity" ] },
    { vertices === KeySort @ Counts @ Catenate @ walks,
      edges === KeySort @ Counts @ Catenate[ ( DirectedEdge @@@ Partition[ #, 2, 1 ] ) & /@ walks ],
      Total @ Values @ vertices == Total[ Length /@ walks ],
      Total @ Values @ edges == Total[ Length /@ walks ] - Length @ walks } ],
  { True, True, True, True },
  TestID -> "ForwardDeformation-projected-densities-match-walk-multiplicities"
]

VerificationTest[
  With[ { graph = CycleGraph[ 4 ], object = InfraForwardDeformation[ { 1, 2, 3 }, { 0 }, "TubeRadius" -> 0 ] },
    InfraMemberQ[ graph, object, # ] & /@ { { 1, 2, 3 }, { 1, 4, 3 }, { 1, 2 }, { 1, 3 }, { } } ],
  { True, False, False, False, False },
  TestID -> "ForwardDeformation-membership-tests-projected-walk"
]

VerificationTest[
  With[ { graph = Graph[ { { 1 }, { 2 }, { 3 } }, { UndirectedEdge[ { 1 }, { 2 } ], UndirectedEdge[ { 2 }, { 3 } ] } ],
      object = InfraForwardDeformation[ { { 1 }, { 2 }, { 3 } }, { 0 } ] },
    { InfraMeasurement[ graph, object, "VertexDensity" ],
      InfraMeasurement[ graph, object, "EdgeDensity" ],
      InfraMemberQ[ graph, object, { { 1 }, { 2 }, { 3 } } ] } ],
  { <| { 1 } -> 1, { 2 } -> 1, { 3 } -> 1 |>,
    <| DirectedEdge[ { 1 }, { 2 } ] -> 1, DirectedEdge[ { 2 }, { 3 } ] -> 1 |>, True },
  TestID -> "ForwardDeformation-projection-preserves-list-valued-labels"
]

VerificationTest[
  With[ { graph = CycleGraph[ 4 ], object = InfraForwardDeformation[ { 1, 2, 3 }, { 0 }, "TubeRadius" -> 0 ] },
    { values = InfraMeasurement[ graph, object, All ] },
    { Keys @ values, AllTrue[ Values @ values, FreeQ[ _InfraMeasurement ] ],
      VertexList @ values[ "Subgraph" ], values[ "CountingMeasure" ] } ],
  { { "Graph", "Cardinality", "Length", "VertexDensity", "EdgeDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" },
    True, { 1, 2, 3 }, 3 },
  TestID -> "ForwardDeformation-all-measurements-project-to-substrate"
]

VerificationTest[
  With[ { graph = PathGraph[ Range[ 3 ] ], object = InfraForwardDeformation[ { 2 }, { 0 } ] },
    { InfraMeasurement[ graph, object, "VertexDensity" ], InfraMeasurement[ graph, object, "EdgeDensity" ],
      InfraMemberQ[ graph, object, { 2 } ] } ],
  { <| 2 -> 1 |>, <| |>, True },
  TestID -> "ForwardDeformation-constant-member-and-densities"
]

EndTestSection[ ]
