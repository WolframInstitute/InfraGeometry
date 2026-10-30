BeginTestSection[ "InfraFiberedGraphViewer" ]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ CycleGraph[ 4 ], Identity ] },
    Head @ InfraFiberedGraphViewer[ fib, { InfraSection[ <| 1 -> 1 |> ],
      InfraConnection[ { UndirectedEdge[ 1, 2 ], UndirectedEdge[ 2, 3 ], UndirectedEdge[ 3, 4 ], UndirectedEdge[ 4, 1 ] } ] } ] ],
  DynamicModule,
  TestID -> "Fibered-viewer-interactive-total-and-base"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ CycleGraph[ 4 ], Identity ] },
    Head /@ ( InfraFiberedGraphViewer[ fib, Method -> # ] & /@ { "CircularFiber", "3DFiber", "HighlightFiber" } ) ],
  { DynamicModule, DynamicModule, DynamicModule },
  TestID -> "Fibered-viewer-all-three-views"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ PathGraph[ Range[ 3 ] ], Identity ] },
    { coordinates = <| 1 -> { 0, 0 }, 2 -> { 1, 0 }, 3 -> { 2, 0 } |> },
    SeedRandom[ 29 ];
    With[ { expected = RandomInteger[ 100000 ] },
      SeedRandom[ 29 ];
      InfraFiberedGraphViewer[ fib, { InfraWalk[ { 1, 2, 1, 2, 3 } ] },
        "BaseVertexCoordinates" -> coordinates ];
      RandomInteger[ 100000 ] === expected ] ],
  True,
  TestID -> "Fibered-viewer-never-resamples-fixed-input"
]

VerificationTest[
  Head @ InfraFiberedGraphViewer[ InfraFiberedGraph[ CycleGraph[ 4 ], Identity ], { }, Method -> "Unrecognized" ],
  InfraFiberedGraphViewer,
  TestID -> "Fibered-viewer-unsupported-view-remains-unevaluated"
]


VerificationTest[
  With[ { fib = InfraFiberedGraph[ CycleGraph[ 4 ], Identity ],
      malformed = InfraFiberedGraph[ CycleGraph[ 4 ], <| 1 -> "p" |> ] },
    { Head @ InfraFiberedGraphViewer[ fib, { }, "UnknownOption" -> True ],
      Head @ InfraFiberedGraphViewer[ malformed, { } ] } ],
  { InfraFiberedGraphViewer, InfraFiberedGraphViewer },
  TestID -> "InfraFiberedGraphViewer-unknown-option-and-malformed-projection-stay-unevaluated"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ PathGraph[ Range[ 3 ] ], Identity ] },
    Map[ coordinates |-> Check[
      Head @ InfraFiberedGraphViewer[ fib, { }, "BaseVertexCoordinates" -> coordinates ], "Message" ],
      { <| 1 -> { 0, 0 } |>, <| 1 -> { 0, 0 }, 2 -> { 1, 0, 1 }, 3 -> { 2, 0 } |> } ] ],
  { InfraFiberedGraphViewer, InfraFiberedGraphViewer },
  TestID -> "InfraFiberedGraphViewer-malformed-coordinate-associations-remain-unevaluated"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ CycleGraph[ 4 ], Identity ] },
    Head @ InfraFiberedGraphViewer[ fib, { }, { Method -> "3DFiber", ImageSize -> 200 } ] ],
  DynamicModule,
  TestID -> "Fibered-viewer-explicit-items-and-standard-option-list"
]

VerificationTest[
  With[ { vertices = { { "p", 1 }, { "q", 2 } }, coordinates = { { 0, 0 }, { 2, 0 } } },
    { fib = InfraFiberedGraph[ PathGraph[ vertices ], Identity ],
      rules = MapThread[ Rule, { Reverse @ vertices, Reverse @ coordinates } ] },
    Table[ Check[ Head @ InfraFiberedGraphViewer[ fib, { }, Method -> method,
        "BaseVertexCoordinates" -> specification, "BaseVertexCoordinates" -> <| |> ], "Message" ],
      { method, { "CircularFiber", "3DFiber", "HighlightFiber" } }, { specification, { coordinates, rules } } ] ],
  ConstantArray[ DynamicModule, { 3, 2 } ],
  TestID -> "Fibered-viewer-general-head-native-coordinate-forms-and-first-option"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ PathGraph[ Range[ 3 ] ], Identity ] },
    Map[ coordinates |-> Check[
      Head @ InfraFiberedGraphViewer[ fib, { }, "BaseVertexCoordinates" -> coordinates ], "Message" ],
      { { { 0, 0 }, { 1, 0 } }, { 1 -> { 0, 0 }, 2 -> { 1, 0 } },
        { 1 -> { 0, 0 }, 2 -> { 1, 0 }, 3 -> { 2, 0, 1 } } } ] ],
  ConstantArray[ InfraFiberedGraphViewer, 3 ],
  TestID -> "Fibered-viewer-incomplete-native-coordinate-forms-remain-unevaluated"
]

EndTestSection[ ]
