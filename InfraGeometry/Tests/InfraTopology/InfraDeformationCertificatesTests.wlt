BeginTestSection[ "InfraDeformationCertificates" ]

VerificationTest[
  FindInfraDeformation[ CycleGraph[ 4 ], InfraDeformation[ { 1, 2 }, UpTo[ 2 ] ], { 1, 4, 3, 2 } ],
  { { 1, 2 }, { 1, 4, 3, 2 } },
  TestID -> "DeformationCertificate-square-edge-to-detour"
]

VerificationTest[
  With[ { graph = Graph[ { 1 <-> 2, 2 <-> 3, 3 <-> 6, 6 <-> 5, 5 <-> 4, 4 <-> 1, 2 <-> 5 } ] },
    { chain = FindInfraDeformation[ graph, InfraDeformation[ { 1, 2, 3, 6 }, { 0 } ],
        { 1, 4, 5, 6 }, Method -> "Exhaustive" ] },
    { First[ chain ], Last[ chain ], Length[ chain ], AllTrue[ chain, DuplicateFreeQ ] } ],
  { { 1, 2, 3, 6 }, { 1, 4, 5, 6 }, 3, True },
  TestID -> "DeformationCertificate-two-square-moves"
]

VerificationTest[
  MatchQ[ FindInfraDeformation[ CycleGraph[ 4 ], InfraDeformation[ { 1, 2 }, UpTo[ 1 ] ], { 1, 4, 3, 2 } ],
    _FindInfraDeformation ],
  True,
  TestID -> "DeformationCertificate-target-over-cap-is-nonmatch"
]

VerificationTest[
  MatchQ[ FindInfraDeformation[ CycleGraph[ 6 ], InfraDeformation[ { 1, 2, 3, 4 }, { 0 } ], { 1, 6, 5, 4 } ],
    _FindInfraDeformation ],
  True,
  TestID -> "DeformationCertificate-cycle6-no-filled-face-is-unresolved"
]

VerificationTest[
  MatchQ[ FindInfraDeformation[ CycleGraph[ 4 ], InfraDeformation[ { 1, 2 }, UpTo[ 2 ] ],
      { 1, 4, 3, 2 }, "MaxMoves" -> 0 ], _FindInfraDeformation ],
  True,
  TestID -> "DeformationCertificate-zero-move-budget-is-unresolved"
]

VerificationTest[
  MatchQ[ FindInfraDeformation[ CycleGraph[ 4 ], InfraDeformation[ { 1, 2 }, UpTo[ 2 ] ],
      { 1, 4, 3, 2 }, "MaxStates" -> 1 ], _FindInfraDeformation ],
  True,
  TestID -> "DeformationCertificate-one-state-budget-is-unresolved"
]

VerificationTest[
  FindInfraDeformation[ CycleGraph[ 4 ], InfraDeformation[ { 1, 2 }, { 2 } ], { 1, 4, 3, 2 } ],
  { { 1, 2 }, { 1, 4, 3, 2 } },
  TestID -> "DeformationCertificate-exact-target-excess-allows-reference-intermediate"
]

VerificationTest[
  With[ { graph = CycleGraph[ 4 ], reference = { 1, 2 }, target = { 1, 4, 3, 2 } },
    { chain = FindInfraDeformation[ graph, InfraDeformation[ reference, UpTo[ 2 ], "TubeRadius" -> 1 ], target ],
      tube = NeighborhoodGraph[ graph, reference, 1 ] },
    First[ chain ] === reference && Last[ chain ] === target &&
      AllTrue[ chain, walk |-> DuplicateFreeQ[ walk ] && Length[ walk ] <= Length[ reference ] + 2 &&
        First[ walk ] === First[ reference ] && Last[ walk ] === Last[ reference ] &&
        AllTrue[ walk, VertexQ[ tube, # ] & ] &&
        AllTrue[ Partition[ walk, 2, 1 ], EdgeQ[ graph, UndirectedEdge @@ # ] & ] ] ],
  True,
  TestID -> "DeformationCertificate-every-state-obeys-geometric-constraints"
]

VerificationTest[
  FindInfraDeformation[ CycleGraph[ 4 ], InfraDeformation[ { 1, 2, 3 }, { 0 } ],
    { 1, 4, 3 }, "NullHomotopicCycles" -> { { 1, 2, 3, 4 } } ],
  { { 1, 2, 3 }, { 1, 4, 3 } },
  TestID -> "DeformationCertificate-explicit-simple-face"
]

VerificationTest[
  FindInfraDeformation[ CycleGraph[ 3 ], InfraDeformation[ { 1, 2 }, { 1 } ], { 1, 3, 2 } ],
  { { 1, 2 }, { 1, 3, 2 } },
  TestID -> "DeformationCertificate-triangle-move"
]

EndTestSection[]
