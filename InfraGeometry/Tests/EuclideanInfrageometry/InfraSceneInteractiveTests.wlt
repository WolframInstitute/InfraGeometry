(* Smoke tests: every Manipulate-based viewer constructs without throwing
   on a small grid graph. We do not exercise the interactive controls. *)

VerificationTest[
  FreeQ[ PointViewer[ GridGraph[ { 3, 3 } ] ], $Failed ],
  True,
  TestID -> "PointViewer-constructs"
]

VerificationTest[
  FreeQ[ SegmentViewer[ GridGraph[ { 3, 3 } ] ], $Failed ],
  True,
  TestID -> "SegmentViewer-constructs"
]

VerificationTest[
  FreeQ[ ShellViewer[ GridGraph[ { 3, 3 } ] ], $Failed ],
  True,
  TestID -> "ShellViewer-constructs"
]

VerificationTest[
  FreeQ[ CircleViewer[ GridGraph[ { 3, 3 } ] ], $Failed ],
  True,
  TestID -> "CircleViewer-constructs"
]

VerificationTest[
  With[ { g = PathGraph[ Range[ 5 ] ], scene = InfraScene[ { p }, { p == InfraPoint[] } ] },
    FreeQ[ InfraSceneViewer[ scene, g ], $Failed ]
  ],
  True,
  TestID -> "InfraSceneViewer-constructs"
]

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ],
      scene = InfraScene[ { a, b, s }, {
        InfraSceneStep[ { a == InfraPoint[ ], b == InfraPoint[ ] }, "two points" ],
        InfraSceneStep[ { s == InfraSegment[ a, b ] }, "segment" ] } ] },
    FreeQ[ InfraSceneViewer[ scene, g, <| a -> 1, b -> 16 |>, ImageSize -> 300 ], $Failed ]
  ],
  True,
  TestID -> "InfraSceneViewer-steps-init-constructs"
]
