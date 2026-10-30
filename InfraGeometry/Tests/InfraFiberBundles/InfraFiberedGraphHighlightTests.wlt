BeginTestSection[ "InfraFiberedGraphHighlight" ]

VerificationTest[
  With[ { total = CycleGraph[ 6 ] },
    { fib = InfraFiberedGraph[ total, point |-> Mod[ point, 3, 1 ] ] },
    Map[ method |-> With[ { drawing = InfraFiberedGraphHighlight[ fib, Method -> method ] },
      GraphQ[ drawing ] && VertexList[ drawing ] === VertexList[ total ] && EdgeList[ drawing ] === EdgeList[ total ] ],
      { "CircularFiber", "3DFiber", "HighlightFiber" } ] ],
  { True, True, True },
  TestID -> "Fibered-highlight-three-views-preserve-graph"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ PathGraph[ Range[ 3 ] ], Identity ] },
    { coordinates = <| 1 -> { 0, 0 }, 2 -> { 2, 0 }, 3 -> { 4, 0 } |> },
    GraphEmbedding @ InfraFiberedGraphHighlight[ fib, "BaseVertexCoordinates" -> coordinates,
      "FiberRadius" -> .4 ] ],
  { { 0, 0 }, { 2, 0 }, { 4, 0 } },
  SameTest -> ( #1 == #2 & ),
  TestID -> "Fibered-highlight-explicit-base-coordinates"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ CycleGraph[ 6 ], point |-> Mod[ point, 3, 1 ] ] },
    Length @ First @ GraphEmbedding @ InfraFiberedGraphHighlight[ fib, Method -> "3DFiber" ] ],
  3,
  TestID -> "Fibered-highlight-three-dimensional-coordinates"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ CycleGraph[ 6 ], point |-> Mod[ point, 3, 1 ] ] },
    { section = InfraSection[ <| 1 -> 1, 2 -> 2, 3 -> 3 |> ],
      connection = InfraConnection[ { UndirectedEdge[ 4, 5 ] } ] },
    Map[ method |-> With[ { drawing = InfraFiberedGraphHighlight[ fib,
          { Style[ section, StandardRed ], connection -> StandardBlue }, Method -> method ] },
        ! FreeQ[ Options[ drawing, EdgeStyle ], StandardBlue ] &&
          ! FreeQ[ { Options[ drawing, VertexStyle ], Options[ drawing, VertexShapeFunction ] }, StandardRed ] ],
      { "CircularFiber", "3DFiber", "HighlightFiber" } ] ],
  { True, True, True },
  TestID -> "Fibered-highlight-section-and-connection-in-all-views"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ PathGraph[ Range[ 3 ] ], Identity ] },
    { drawing = InfraFiberedGraphHighlight[ fib, { InfraWalk[ { 1, 2, 1, 2, 3 } ] },
        "BaseVertexCoordinates" -> <| 1 -> { 0, 0 }, 2 -> { 1, 0 }, 3 -> { 2, 0 } |> ] },
    Map[ edge |-> FirstCase[ PropertyValue[ { drawing, edge }, EdgeStyle ], AbsoluteThickness[ size_ ] :> size,
        Missing[ "NoStroke" ], Infinity ], { UndirectedEdge[ 1, 2 ], UndirectedEdge[ 2, 3 ] } ] ],
  { 4., 1. },
  SameTest -> ( #1 == #2 & ),
  TestID -> "Fibered-highlight-repeated-traversals-have-distinct-strength"
]

VerificationTest[
  With[ { vertices = { { 1, "a" }, { 2, "b" }, { 3, "c" }, { 4, "d" } } },
    { total = Graph[ vertices, UndirectedEdge @@@ Partition[ vertices, 2, 1 ] ] },
    { fib = InfraFiberedGraph[ total, AssociationThread[ vertices, { "p", "p", "q", "q" } ] ] },
    Map[ method |-> Check[ With[ { drawing = InfraFiberedGraphHighlight[ fib,
          { InfraSection[ AssociationThread[ { "p", "q" }, vertices[[ { 2, 3 } ]] ] ],
            InfraWalk[ vertices[[ { 1, 2, 3, 2, 1 } ]] ] }, Method -> method ] },
        GraphQ[ drawing ] && VertexList[ drawing ] === vertices ], False ],
      { "CircularFiber", "3DFiber", "HighlightFiber" } ] ],
  { True, True, True },
  TestID -> "Fibered-highlight-literal-list-vertices-and-repeated-walk"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ CycleGraph[ 4 ], Identity ] },
    { drawing = InfraFiberedGraphHighlight[ fib, { Directive[ StandardGreen ], InfraWalk[ { 1, 2, 3 } ] },
        ImageSize -> 240, ImageSize -> 360, VertexLabels -> "Name" ] },
    { ImageSize /. Options[ drawing, ImageSize ], ! FreeQ[ Options[ drawing, EdgeStyle ], StandardGreen ] } ],
  { 240, True },
  TestID -> "Fibered-highlight-standard-options-and-first-duplicate"
]

VerificationTest[
  Head @ InfraFiberedGraphHighlight[ InfraFiberedGraph[ CycleGraph[ 4 ], Identity ], { }, Method -> "Unrecognized" ],
  InfraFiberedGraphHighlight,
  TestID -> "Fibered-highlight-unsupported-view-remains-unevaluated"
]

VerificationTest[
  GraphQ @ InfraFiberedGraphHighlight[ InfraFiberedGraph[ Graph[ { }, { } ], <| |> ] ],
  True,
  TestID -> "Fibered-highlight-empty-total"
]


VerificationTest[
  With[ { fib = InfraFiberedGraph[ CycleGraph[ 4 ], Identity ],
      malformed = InfraFiberedGraph[ CycleGraph[ 4 ], <| 1 -> "p" |> ] },
    { Head @ InfraFiberedGraphHighlight[ fib, { }, "UnknownOption" -> True ],
      Head @ InfraFiberedGraphHighlight[ malformed, { } ] } ],
  { InfraFiberedGraphHighlight, InfraFiberedGraphHighlight },
  TestID -> "InfraFiberedGraphHighlight-unknown-option-and-malformed-projection-stay-unevaluated"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ PathGraph[ Range[ 3 ] ], Identity ] },
    Map[ coordinates |-> Check[
      Head @ InfraFiberedGraphHighlight[ fib, { }, "BaseVertexCoordinates" -> coordinates ], "Message" ],
      { <| 1 -> { 0, 0 } |>, <| 1 -> { 0, 0 }, 2 -> { 1, 0, 1 }, 3 -> { 2, 0 } |> } ] ],
  { InfraFiberedGraphHighlight, InfraFiberedGraphHighlight },
  TestID -> "InfraFiberedGraphHighlight-malformed-coordinate-associations-remain-unevaluated"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ CycleGraph[ 4 ], Identity ],
      sections = { InfraSection[ <| 1 -> 1 |> ], InfraSection[ <| 2 -> 2 |> ] } },
    Map[ method |-> Check[ With[ { drawing = InfraFiberedGraphHighlight[ fib,
          { { Style[ sections, StandardRed ] }, sections -> Directive[ StandardBlue, Thick ] }, Method -> method ] },
        GraphQ[ drawing ] && ! FreeQ[ Options[ drawing, VertexShapeFunction ], StandardBlue ] ], False ],
      { "CircularFiber", "3DFiber", "HighlightFiber" } ] ],
  { True, True, True },
  TestID -> "Fibered-highlight-nested-styled-section-families"
]

VerificationTest[
  With[ { total = PathGraph[ Range[ 3 ] ] },
    { fib = InfraFiberedGraph[ total, Identity ] },
    { drawing = InfraFiberedGraphHighlight[ fib, { { Subgraph[ total, { 1 } ], Subgraph[ total, { 2 } ] } } ] },
    PropertyValue[ { drawing, 1 }, VertexShapeFunction ] === PropertyValue[ { drawing, 2 }, VertexShapeFunction ] ],
  True,
  TestID -> "Fibered-highlight-native-graph-aggregate-remains-one-object"
]

VerificationTest[
  With[ { vertices = { { 1, "a" }, { 2, "b" } } },
    { fib = InfraFiberedGraph[ Graph[ vertices, { UndirectedEdge @@ vertices } ], Identity ] },
    Check[ GraphQ @ InfraFiberedGraphHighlight[ fib, { First @ vertices } ], False ] ],
  True,
  TestID -> "Fibered-highlight-literal-list-vertex-is-not-a-family"
]

VerificationTest[
  With[ { fib = RandomInfraFibration[ PathGraph[ Range[ 3 ] ], "VerticalVertices" -> 2 ] },
    { coordinates = <| 1 -> { 0, 0 }, 2 -> { .6, 0 }, 3 -> { 0, .1 } |> },
    { drawing = InfraFiberedGraphHighlight[ fib, "BaseVertexCoordinates" -> coordinates ] },
    Chop[ Norm[ First @ GraphEmbedding @ drawing ] - .2 ] == 0 ],
  True,
  TestID -> "Fibered-highlight-radius-uses-base-edges-not-all-pairs"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ CycleGraph[ 4 ], Identity ],
      section = InfraSection[ <| 1 -> 1, 2 -> 2, 3 -> 3, 4 -> 4 |> ],
      connection = InfraConnection[ EdgeList @ CycleGraph[ 4 ] ] },
    Map[ method |-> With[ { drawing = InfraFiberedGraphHighlight[ fib,
          { section -> StandardRed, connection -> StandardBlue }, Method -> method ] },
        ! FreeQ[ PropertyValue[ { drawing, 1 }, VertexShapeFunction ], StandardRed ] &&
          ! FreeQ[ PropertyValue[ { drawing, UndirectedEdge[ 1, 2 ] }, EdgeStyle ], StandardBlue ] ],
      { "CircularFiber", "3DFiber", "HighlightFiber" } ] ],
  { True, True, True },
  TestID -> "Fibered-highlight-later-connection-retains-section-vertex-style"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ PathGraph[ Range[ 3 ] ], Identity ] },
    Check[ GraphQ @ InfraFiberedGraphHighlight[ fib,
      { InfraSection[ <| 1 -> 1 |> ], InfraConnection[ { } ] } ], False ] ],
  True,
  TestID -> "Fibered-highlight-empty-connection-is-an-empty-drawing-object"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ CycleGraph[ 4 ], Identity ] },
    { drawing = InfraFiberedGraphHighlight[ fib, { }, { Method -> "3DFiber", ImageSize -> 200 } ] },
    { GraphQ[ drawing ], Length @ First @ GraphEmbedding[ drawing ], ImageSize /. Options[ drawing, ImageSize ] } ],
  { True, 3, 200 },
  TestID -> "Fibered-highlight-explicit-items-and-standard-option-list"
]

VerificationTest[
  With[ { vertices = { { "left", 1 }, { "right", 2 }, { "top", 3 } } },
    { total = PathGraph[ vertices ], coordinates = { { 0, 0 }, { 2, 1 }, { 4, 0 } } },
    { fib = InfraFiberedGraph[ total, Identity ],
      rules = MapThread[ Rule, { Reverse @ vertices, Reverse @ coordinates } ] },
    Map[ method |-> Check[ With[ { drawing = InfraFiberedGraphHighlight[ fib,
          { Style[ InfraSection @ AssociationThread[ vertices, vertices ], StandardRed ] },
          Method -> method, "BaseVertexCoordinates" -> rules ] },
        GraphQ[ drawing ] && VertexList[ drawing ] === vertices && EdgeList[ drawing ] === EdgeList[ total ] ], False ],
      { "CircularFiber", "3DFiber", "HighlightFiber" } ] ],
  { True, True, True },
  TestID -> "Fibered-highlight-general-head-all-views-with-literal-coordinate-rules"
]

VerificationTest[
  With[ { vertices = { { 2, 0 }, { 0, 0 }, { 1, 0 } }, coordinates = { { 4, 0 }, { 0, 0 }, { 2, 0 } } },
    { fib = InfraFiberedGraph[ PathGraph[ vertices ], Identity ],
      rules = MapThread[ Rule, { Reverse @ vertices, Reverse @ coordinates } ] },
    Map[ specification |-> GraphEmbedding @ InfraFiberedGraphHighlight[ fib, { },
        "BaseVertexCoordinates" -> specification, "BaseVertexCoordinates" -> <| |> ],
      { coordinates, rules, Association @ rules } ] ],
  ConstantArray[ { { 4, 0 }, { 0, 0 }, { 2, 0 } }, 3 ],
  SameTest -> ( #1 == #2 & ),
  TestID -> "Fibered-highlight-native-coordinate-forms-preserve-vertex-order-and-first-option"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ PathGraph[ Range[ 3 ] ], Identity ] },
    Map[ coordinates |-> Check[
      Head @ InfraFiberedGraphHighlight[ fib, { }, "BaseVertexCoordinates" -> coordinates ], "Message" ],
      { { { 0, 0 }, { 1, 0 } }, { 1 -> { 0, 0 }, 2 -> { 1, 0 } },
        { 1 -> { 0, 0 }, 2 -> { 1, 0 }, 3 -> { 2, 0, 1 } } } ] ],
  ConstantArray[ InfraFiberedGraphHighlight, 3 ],
  TestID -> "Fibered-highlight-incomplete-native-coordinate-forms-remain-unevaluated"
]

EndTestSection[ ]
