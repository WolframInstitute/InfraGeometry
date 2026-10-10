BeginTestSection[ "ConstructionGraphs" ]

VerificationTest[
  With[ { graph = GridGraph[ { 3, 3 } ] },
    { dag = IntervalGraph[ graph, 1, 9 ] },
    { AcyclicGraphQ @ dag, Sort @ FindPath[ dag, 1, 9, Infinity, All ] ===
        Sort @ FindPath[ graph, 1, 9, { 4 }, All ] } ],
  { True, True },
  TestID -> "IntervalGraph-all-shortest-paths"
]

VerificationTest[
  With[ { graph = PathGraph @ Range[ 5 ] },
    FindPath[ #, First @ VertexList @ #, Last @ VertexList @ #, Infinity, All ] & /@
      IntervalGraph[ graph, 1, 3, 5 ] ],
  { { { 1, 2, 3 } }, { { 3, 4, 5 } } },
  TestID -> "IntervalGraph-polyline-keeps-pieces"
]

VerificationTest[
  With[ { dag = RayGraph[ CycleGraph[ 6 ], 1, 2 ] },
    FindPath[ dag, 1, 4, Infinity, All ] ],
  { { 1, 2, 3, 4 } },
  TestID -> "RayGraph-extends-through-anchor-to-maximal-end"
]

VerificationTest[
  With[ { dag = RayGraph[ CycleGraph[ 6 ], 1, 1 ] },
    Sort @ FindPath[ dag, 1, 4, Infinity, All ] ],
  { { 1, 2, 3, 4 }, { 1, 6, 5, 4 } },
  TestID -> "RayGraph-coincident-anchors-give-spray"
]

VerificationTest[
  Sort @ Catenate @ Map[
    dag |-> With[ {
        source = First @ Pick[ VertexList @ dag, VertexInDegree @ dag, 0 ],
        sink = First @ Pick[ VertexList @ dag, VertexOutDegree @ dag, 0 ] },
      FindPath[ dag, source, sink, Infinity, All ] ],
    BeamGraph[ CycleGraph[ 6 ], 1, 2 ] ],
  Sort @ { { 1, 2, 3, 4 }, { 6, 1, 2, 3 }, { 5, 6, 1, 2 } },
  TestID -> "BeamGraph-keeps-exactly-three-lines-on-six-cycle"
]

VerificationTest[
  With[ { graph = GridGraph[ { 3, 3 } ], germ = { 1, 2, 5 } },
    { atoms = BeamGraph[ graph, germ ] },
    AllTrue[ atoms, EdgeQ[ #, DirectedEdge[ 1, 2 ] ] && EdgeQ[ #, DirectedEdge[ 2, 5 ] ] & ] &&
      Length @ atoms > 0 ],
  True,
  TestID -> "BeamGraph-preserves-specified-germ"
]

VerificationTest[
  With[ { dag = ArcGraph[ CycleGraph[ 8 ], 1, { 3, 7 }, "RadiusDelta" -> 2 ] },
    FindPath[ dag, 3, 7, Infinity, All ] ],
  { { 3, 4, 5, 6, 7 } },
  TestID -> "ArcGraph-shortest-path-in-widened-radial-band"
]

VerificationTest[
  With[ { graph = CycleGraph[ 8 ] },
    { IntervalGraph[ graph, 1, 5 ] === InfraMeasurement[ graph, InfraSegment[ 1, 5 ], "Graph" ],
      RayGraph[ graph, 1, 2 ] === InfraMeasurement[ graph, InfraRay[ 1, 2 ], "Graph" ],
      BeamGraph[ graph, 1, 2 ] === InfraMeasurement[ graph, InfraLine[ 1, 2 ], "Graph" ],
      ArcGraph[ graph, 1, { 3, 7 }, "RadiusDelta" -> 2 ] ===
        InfraMeasurement[ graph, InfraArc[ 1, { 3, 7 }, "RadiusDelta" -> 2 ], "Graph" ] } ],
  { True, True, True, True },
  TestID -> "ConstructionGraphs-agree-with-measurement-carriers"
]

EndTestSection[ ]
