BeginTestSection[ "InfraFiberedRendering" ]

VerificationTest[
  With[ { graph = CompleteGraph[ 4 ], fiber = Graph[ { 1, 2, 3, 4 }, { UndirectedEdge[ 1, 2 ], UndirectedEdge[ 1, 3 ], UndirectedEdge[ 1, 4 ] } ] },
    Check[ With[ { drawing = InfraSubstrateHighlight[ graph, { fiber } ] },
      GraphQ[ drawing ] && AllTrue[ EdgeList @ fiber,
        ! FreeQ[ PropertyValue[ { drawing, # }, EdgeStyle ], AbsoluteThickness ] & ] ], False ] ],
  True,
  TestID -> "Fibered-rendering-branching-native-graph-has-edge-ink"
]

VerificationTest[
  With[ { vertices = { { 1, "a" }, { 2, "b" }, { 3, "c" } } },
    { graph = Graph[ vertices, UndirectedEdge @@@ Subsets[ vertices, { 2 } ] ] },
    Check[ With[ { drawing = InfraSubstrateHighlight[ graph, { Subgraph[ graph, vertices ] } ] },
      GraphQ[ drawing ] && VertexList[ drawing ] === vertices ], False ] ],
  True,
  TestID -> "Fibered-rendering-native-graph-preserves-literal-tuple-vertices"
]

VerificationTest[
  With[ { graph = Graph3D[ PathGraph[ Range[ 3 ] ], VertexCoordinates -> { { 0, 0, 0 }, { 1, 0, 1 }, { 2, 0, 0 } } ] },
    Check[ With[ { drawing = InfraSubstrateHighlight[ graph,
        { <| 1 -> 1, 3 -> 1 |>, InfraWalk[ { 1, 2, 1, 2, 3 } ] }, "Arrowheads" -> True ] },
      GraphQ[ drawing ] && Length @ First @ GraphEmbedding[ drawing ] === 3 &&
        FreeQ[ Options[ drawing, VertexShapeFunction ], Disk | Circle ] ], False ] ],
  True,
  TestID -> "Fibered-rendering-native-three-dimensional-highlight-shapes"
]

VerificationTest[
  With[ { graph = CompleteGraph[ 4 ] },
    { drawing = InfraSubstrateHighlight[ graph, { graph } ] },
    AllTrue[ EdgeList @ graph,
      ! FreeQ[ PropertyValue[ { drawing, # }, EdgeStyle ], AbsoluteThickness ] & ] ],
  True,
  TestID -> "Fibered-rendering-all-edges-of-cyclic-native-graph"
]

VerificationTest[
  With[ { graph = PathGraph[ Range[ 3 ] ] },
    { drawing = InfraSubstrateHighlight[ graph, { UndirectedEdge[ 1, 2 ] -> StandardRed } ] },
    { ! FreeQ[ PropertyValue[ { drawing, UndirectedEdge[ 1, 2 ] }, EdgeStyle ], StandardRed ],
      Options[ drawing, VertexShapeFunction ] === Options[ graph, VertexShapeFunction ],
      FreeQ[ Options[ drawing, VertexStyle ], StandardRed ] } ],
  { True, True, True },
  TestID -> "Fibered-rendering-native-edge-highlights-only-the-edge"
]

VerificationTest[
  With[ { graph = Graph[ { 1, 2, { 1, 2 } }, { UndirectedEdge[ 1, 2 ] } ] },
    { drawing = InfraSubstrateHighlight[ graph, { InfraWalk[ { 1, 2 } ] -> StandardRed } ] },
    { ! FreeQ[ PropertyValue[ { drawing, UndirectedEdge[ 1, 2 ] }, EdgeStyle ], StandardRed ],
      FreeQ[ PropertyValue[ { drawing, { 1, 2 } }, VertexStyle ], StandardRed ] } ],
  { True, True },
  TestID -> "Fibered-rendering-explicit-walk-payload-can-also-be-a-literal-vertex"
]

VerificationTest[
  With[ { label = InfraWalk[ { 1, 2 } ] },
    { graph = Graph[ { 1, 2, label }, { UndirectedEdge[ 1, 2 ] } ] },
    { drawing = InfraSubstrateHighlight[ graph, { label -> StandardRed } ] },
    { FreeQ[ PropertyValue[ { drawing, UndirectedEdge[ 1, 2 ] }, EdgeStyle ], StandardRed ],
      ! FreeQ[ PropertyValue[ { drawing, label }, VertexShapeFunction ], StandardRed ] } ],
  { True, True },
  TestID -> "Fibered-rendering-literal-InfraWalk-headed-vertex-keeps-vertex-precedence"
]

EndTestSection[ ]
