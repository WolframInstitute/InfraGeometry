BeginTestSection[ "SamplerRandomSeeding" ]

samplerCalls = <|
  RandomInfraDeformation -> ( RandomInfraDeformation[ CycleGraph[ 4 ], InfraDeformation[ { 1, 2 }, UpTo[ 2 ] ], ## ] & ),
  RandomInfraPoint -> ( RandomInfraPoint[ GridGraph[ { 4, 4 } ], 3, ## ] & ),
  RandomInfraSegment -> ( RandomInfraSegment[ GridGraph[ { 4, 4 } ], 1, 16, ## ] & ),
  RandomInfraInfiniteLine -> ( RandomInfraInfiniteLine[ GridGraph[ { 4, 4 } ], 6, 7, ## ] & ),
  RandomInfraInfiniteLine -> ( RandomInfraInfiniteLine[ GridGraph[ { 4, 4 } ], 6, 7, ## ] & ),
  RandomInfraHalfLine -> ( RandomInfraHalfLine[ GridGraph[ { 4, 4 } ], 6, 7, ## ] & ),
  RandomInfraHalfLine -> ( RandomInfraHalfLine[ GridGraph[ { 4, 4 } ], 6, 7, ## ] & ),
  RandomInfraParallel -> ( RandomInfraParallel[
    Graph[ { "a", "b", "s", "u", "v", "p", "t" }, Join[ { UndirectedEdge[ "a", "b" ] },
      Flatten @ Table[ UndirectedEdge[ x, y ], { x, { "a", "b" } }, { y, { "s", "u", "v", "p", "t" } } ],
      { UndirectedEdge[ "s", "u" ], UndirectedEdge[ "s", "v" ], UndirectedEdge[ "u", "p" ], UndirectedEdge[ "v", "p" ], UndirectedEdge[ "p", "t" ] } ] ],
    { "a", "b" }, "p", ## ] & ),
  RandomInfraCircle -> ( RandomInfraCircle[ GridGraph[ { 7, 7 } ], InfraCircle[ 25, { 1, 3 } ], ## ] & ),
  RandomInfraCircleThrough -> ( RandomInfraCircleThrough[ GridGraph[ { 7, 7 } ], InfraCircleThrough[ { 11 }, InfraCircle[ 25, { 1, 3 } ] ], ## ] & ),
  RandomInfraArc -> ( RandomInfraArc[ GridGraph[ { 7, 7 } ], InfraArc[ 25, { 11, 39 }, "RadiusDelta" -> { 1, 1 } ], ## ] & ),
  RandomInfraEllipse -> ( RandomInfraEllipse[ GridGraph[ { 5, 5 } ], { 12, 14 }, { 4, 6 }, ## ] & ),
  RandomInfraPlane -> ( RandomInfraPlane[ GridGraph[ { 7, 7 } ], InfraPlane[ 9, 41 ], ## ] & ),
  RandomInfraRegularPolygon -> ( RandomInfraRegularPolygon[ GridGraph[ { 5, 5 } ], { 2 }, 4, ## ] & ),
  RandomInfraSphere -> ( RandomInfraSphere[ GridGraph[ { 4, 4 } ], 6, { 1, 2 }, 1, Properties -> { "Separating", "Connected" }, ## ] & ),
  RandomInfraMidpoint -> ( RandomInfraMidpoint[ CycleGraph[ 4 ], 1, 3, ## ] & ),
  RandomInfraRegionNearest -> ( RandomInfraRegionNearest[ CycleGraph[ 4 ], { 1, 3 }, 2, ## ] & ),
  RandomInfraWalk -> ( RandomInfraWalk[ GridGraph[ { 4, 4 } ], 1, { 6 }, Properties -> { "Simple" }, ## ] & ),
  RandomInfraGeodesic -> ( RandomInfraGeodesic[ GridGraph[ { 4, 4 } ], 1, Infinity, ## ] & ),
  RandomBallCover -> ( RandomBallCover[ PathGraph[ Range[ 4 ] ], ## ] & ),
  RandomDisplacement -> ( RandomDisplacement[ GridGraph[ { 4, 4 } ], ## ] & ),
  RandomInfraFiberedGraph -> ( RandomInfraFiberedGraph[ CycleGraph[ 4 ], "VerticalVertexCount" -> { 2, 4 }, "VerticalEdgeCount" -> 3, ## ] & ),
  RandomInfraFibration -> ( RandomInfraFibration[ Graph[ Range[ 6 ], { } ], "VerticalVertices" -> { 3, 5 }, ## ] & ),
  RandomInfraSection -> ( RandomInfraSection[ InfraFiberedGraph[ Graph[ Range[ 8 ], { } ], i |-> Ceiling[ i / 2 ] ], ## ] & ),
  RandomInfraConnection -> ( RandomInfraConnection[ InfraFiberedGraph[ CompleteGraph[ 4 ], <| 1 -> "p", 2 -> "p", 3 -> "q", 4 -> "q" |> ], ## ] & )
|>;

VerificationTest[
  Sort @ Keys @ samplerCalls === Sort @ DeleteCases[
    Select[ Names[ "WolframInstitute`InfraGeometry`Random*" ], StringStartsQ[ #, "Random" ] & ] /. s_String :> Symbol[ s ],
    RandomInfraSceneInstance ],
  True,
  TestID -> "SamplerRandomSeeding-every-sampler-is-covered"
]

VerificationTest[
  Union[ RandomSeeding /. Options[ # ] & /@ Append[ Keys @ samplerCalls, RandomInfraSceneInstance ] ],
  { Automatic },
  TestID -> "SamplerRandomSeeding-default-is-Automatic"
]

VerificationTest[
  Select[ Keys @ samplerCalls, sampler |-> With[ { call = samplerCalls @ sampler },
    ! AllTrue[ { 41, "seed" }, seed |->
      BlockRandom[ call[ RandomSeeding -> seed ], RandomSeeding -> 17 ] ===
        BlockRandom[ call[ RandomSeeding -> seed ], RandomSeeding -> 29 ] ] ] ],
  { },
  TestID -> "SamplerRandomSeeding-integer-and-string-seeds-ignore-ambient-state"
]

VerificationTest[
  Select[ Keys @ samplerCalls, sampler |-> With[ { call = samplerCalls @ sampler },
    call[ RandomSeeding -> 5 ] =!= BlockRandom[ call[ RandomSeeding -> None ], RandomSeeding -> 5 ] ] ],
  { },
  TestID -> "SamplerRandomSeeding-integer-seed-is-the-SeedRandom-stream"
]

VerificationTest[
  Select[ Keys @ samplerCalls, sampler |-> With[ { call = samplerCalls @ sampler,
      state = BlockRandom[ $RandomGeneratorState, RandomSeeding -> 13 ] },
    ! AllTrue[ { Automatic, 41, "seed", Inherited, state }, seed |->
      BlockRandom[ call[ RandomSeeding -> seed ]; $RandomGeneratorState, RandomSeeding -> 17 ] ===
        BlockRandom[ $RandomGeneratorState, RandomSeeding -> 17 ] ] ] ],
  { },
  TestID -> "SamplerRandomSeeding-every-setting-restores-the-outer-state"
]

VerificationTest[
  Select[ Keys @ samplerCalls, sampler |-> With[ { call = samplerCalls @ sampler },
    BlockRandom[ { call[ RandomSeeding -> Inherited ], call[ RandomSeeding -> Inherited ] }, RandomSeeding -> 7 ] =!=
      { #, # } & @ BlockRandom[ call[ RandomSeeding -> None ], RandomSeeding -> 7 ] ] ],
  { },
  TestID -> "SamplerRandomSeeding-Inherited-is-a-local-snapshot"
]

VerificationTest[
  Select[ { RandomInfraPoint, RandomInfraSegment, RandomInfraInfiniteLine, RandomInfraInfiniteLine, RandomInfraArc, RandomInfraPlane,
      RandomInfraRegularPolygon, RandomInfraSphere, RandomInfraWalk, RandomInfraGeodesic, RandomDisplacement,
      RandomInfraFiberedGraph, RandomInfraFibration, RandomInfraSection },
    sampler |-> With[ { call = samplerCalls @ sampler },
      Length @ DeleteDuplicates @ Table[ BlockRandom[ SeedRandom[ 1 ]; call[ ] ], 20 ] == 1 ] ],
  { },
  TestID -> "SamplerRandomSeeding-Automatic-is-independent-of-SeedRandom"
]

VerificationTest[
  Select[ { RandomInfraPoint, RandomInfraSegment, RandomInfraInfiniteLine, RandomInfraInfiniteLine, RandomInfraArc, RandomInfraPlane,
      RandomInfraRegularPolygon, RandomInfraSphere, RandomInfraWalk, RandomInfraGeodesic, RandomDisplacement,
      RandomInfraFiberedGraph, RandomInfraFibration, RandomInfraSection },
    sampler |-> With[ { call = samplerCalls @ sampler },
      BlockRandom[ call[ RandomSeeding -> None ]; $RandomGeneratorState, RandomSeeding -> 17 ] ===
        BlockRandom[ $RandomGeneratorState, RandomSeeding -> 17 ] ] ],
  { },
  TestID -> "SamplerRandomSeeding-None-draws-from-the-ambient-stream"
]

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ] },
    { RandomInfraPoint[ g, 3, RandomSeeding -> 2, RandomSeeding -> 9 ] === RandomInfraPoint[ g, 3, RandomSeeding -> 2 ],
      MatchQ[ RandomInfraPoint[ g, -1, RandomSeeding -> 2 ], HoldPattern[ RandomInfraPoint[ _Graph, -1, RandomSeeding -> 2 ] ] ] } ],
  { True, True },
  TestID -> "SamplerRandomSeeding-first-seed-wins-and-unknown-options"
]

EndTestSection[ ]
