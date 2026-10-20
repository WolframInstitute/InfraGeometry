BeginTestSection[ "InfraSceneRandomSeeding" ]

VerificationTest[
  RandomSeeding /. Options[ RandomInfraSceneInstance ],
  Automatic,
  TestID -> "RandomInfraSceneInstance-standard-RandomSeeding-default"
]

VerificationTest[
  With[ { scene = InfraScene[ { p, q }, { p == InfraPoint[], q == InfraPoint[] } ], graph = PathGraph[ Range[ 5 ] ] },
    AllTrue[ { 41, "scene-seed" }, seed |->
      BlockRandom[ RandomInfraSceneInstance[ scene, graph, 3, RandomSeeding -> seed ], RandomSeeding -> 17 ] ===
        BlockRandom[ RandomInfraSceneInstance[ scene, graph, 3, RandomSeeding -> seed ], RandomSeeding -> 29 ] ] ],
  True,
  TestID -> "RandomInfraSceneInstance-explicit-integer-string-seeds-ignore-ambient-state"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraPoint[] } ], graph = PathGraph[ Range[ 5 ] ],
      state = BlockRandom[ $RandomGeneratorState, RandomSeeding -> 41 ] },
    RandomInfraSceneInstance[ scene, graph, 3, RandomSeeding -> state ] ===
      RandomInfraSceneInstance[ scene, graph, 3, RandomSeeding -> state ] &&
      Head @ RandomInfraSceneInstance[ scene, graph, RandomSeeding -> state ] === InfraSceneInstance ],
  True,
  TestID -> "RandomInfraSceneInstance-saved-RandomGeneratorState-reproducible"
]

VerificationTest[
  With[ { scene = InfraScene[ { p, q }, { p == InfraPoint[], q == InfraPoint[] } ], graph = PathGraph[ Range[ 5 ] ],
      state = BlockRandom[ $RandomGeneratorState, RandomSeeding -> 13 ] },
    AllTrue[ { Automatic, 41, "scene-seed", Inherited, state }, seed |->
      BlockRandom[
        RandomInfraSceneInstance[ scene, graph, 3, RandomSeeding -> seed ]; $RandomGeneratorState,
        RandomSeeding -> 17 ] === BlockRandom[ $RandomGeneratorState, RandomSeeding -> 17 ] ] ],
  True,
  TestID -> "RandomInfraSceneInstance-all-seeding-settings-preserve-outer-state"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraPoint[] } ], graph = PathGraph[ Range[ 5 ] ] },
    BlockRandom[
      With[ { first = RandomInfraSceneInstance[ scene, graph, 3, RandomSeeding -> Inherited ] },
        first === RandomInfraSceneInstance[ scene, graph, 3, RandomSeeding -> Inherited ] &&
          first === RandomInfraSceneInstance[ scene, graph, 3, RandomSeeding -> $RandomGeneratorState ] ],
      RandomSeeding -> 41 ] ],
  True,
  TestID -> "RandomInfraSceneInstance-Inherited-is-a-restored-snapshot"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraPoint[] } ], graph = PathGraph[ Range[ 5 ] ] },
    BlockRandom[
      RandomInteger[ 1000000, 7 ]; RandomInfraSceneInstance[ scene, graph, 3, RandomSeeding -> Inherited ],
      RandomSeeding -> 41 ] ===
    BlockRandom[
      RandomInteger[ 1000000, 7 ];
      RandomInfraSceneInstance[ scene, graph, 3, RandomSeeding -> $RandomGeneratorState ], RandomSeeding -> 41 ] ],
  True,
  TestID -> "RandomInfraSceneInstance-Inherited-uses-current-advanced-state"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraPoint[] } ], graph = PathGraph[ Range[ 5 ] ] },
    AllTrue[ { Automatic, 41, "scene-seed", Inherited }, seed |->
      ( InfraSceneInstance[ #, p ] & /@ RandomInfraSceneInstance[ scene, graph, All, RandomSeeding -> seed ] ) === Range[ 5 ] &&
        InfraSceneInstance[ RandomInfraSceneInstance[ scene, graph, "NextVertexFunction" -> Identity,
          RandomSeeding -> seed ], p ] === 1 ] ],
  True,
  TestID -> "RandomInfraSceneInstance-All-and-Identity-ignore-seeding"
]

VerificationTest[
  With[ { scene = InfraScene[ { p, q, r }, { p == InfraPoint[], q == InfraPoint[], r == InfraPoint[] } ],
      graph = PathGraph[ Range[ 5 ] ] },
    With[ { observed = Reap[ RandomInfraSceneInstance[ scene, graph,
        "NextVertexFunction" -> ( #[[ Sow[ RandomSample[ Range[ Length[ # ] ] ] ] ]] & ), RandomSeeding -> 41 ] ] },
      Head[ First[ observed ] ] === InfraSceneInstance &&
        Last[ observed ] === { BlockRandom[ Table[ RandomSample[ Range[ 5 ] ], 3 ], RandomSeeding -> 41 ] } ] ],
  True,
  TestID -> "RandomInfraSceneInstance-callbacks-share-one-stream-across-constructions"
]

VerificationTest[
  With[ { scene = InfraScene[ { p, q, r }, { p == InfraPoint[], q == InfraPoint[], r == InfraPoint[] } ],
      graph = PathGraph[ Range[ 5 ] ] },
    With[ { observed = Reap[ RandomInfraSceneInstance[ scene, graph,
        "NextVertexFunction" -> ( candidates |-> ( Sow[ RandomInfraPoint[ graph, InfraPoint[], RandomSeeding -> None ] ]; candidates ) ), RandomSeeding -> 41 ] ] },
      Head[ First[ observed ] ] === InfraSceneInstance &&
        Last[ observed ] === { BlockRandom[ Table[ RandomInfraPoint[ graph, InfraPoint[], RandomSeeding -> None ], 3 ], RandomSeeding -> 41 ] } ] ],
  True,
  TestID -> "RandomInfraSceneInstance-nested-named-samplers-use-scene-stream"
]

VerificationTest[
  With[ { scene = InfraScene[ { p, q }, { p == InfraPoint[], q == InfraPoint[] } ], graph = PathGraph[ Range[ 5 ] ] },
    With[ { instances = RandomInfraSceneInstance[ scene, graph, All,
        "NextVertexFunction" -> ( RandomSample[ #, UpTo[ 2 ] ] & ), RandomSeeding -> 41 ] },
      Length[ instances ] === 4 && DuplicateFreeQ[ instances ] &&
        instances === RandomInfraSceneInstance[ scene, graph, All,
          "NextVertexFunction" -> ( RandomSample[ #, UpTo[ 2 ] ] & ), RandomSeeding -> 41 ] ] ],
  True,
  TestID -> "RandomInfraSceneInstance-stochastic-pruning-All-seed-reproducible"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraPoint[], p > 3 } ], graph = PathGraph[ Range[ 3 ] ] },
    With[ { observed = Reap[ RandomInfraSceneInstance[ scene, graph, <| p -> 1 |>,
        "NextVertexFunction" -> ( candidates |-> ( Sow[ "Visited" ]; candidates ) ), RandomSeeding -> 41 ] ] },
      observed === { { }, { } } ] ],
  True,
  TestID -> "RandomInfraSceneInstance-rejected-root-never-visits-stochastic-callback"
]

VerificationTest[
  With[ { scene = InfraScene[ { p, q }, { p == InfraPoint[], q == UnknownConstruction[ p ] } ],
      graph = PathGraph[ Range[ 3 ] ] },
    { Head @ RandomInfraSceneInstance[ scene, graph, RandomSeeding -> 41 ],
      BlockRandom[ RandomInfraSceneInstance[ scene, graph, RandomSeeding -> Inherited ]; $RandomGeneratorState,
        RandomSeeding -> 17 ] === BlockRandom[ $RandomGeneratorState, RandomSeeding -> 17 ] } ],
  { RandomInfraSceneInstance, True },
  TestID -> "RandomInfraSceneInstance-unsupported-call-unevaluated-preserves-state"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraPoint[] } ], graph = PathGraph[ Range[ 3 ] ] },
    With[ { observed = BlockRandom[
        Reap[ RandomInfraSceneInstance[ scene, graph, All,
          "NextVertexFunction" :> ( Sow[ RandomInteger[ 1000000 ], "OptionEvaluation" ]; Identity ),
          RandomSeeding -> 41 ], "OptionEvaluation" ], RandomSeeding -> 17 ] },
      Length[ First[ observed ] ] === 3 &&
        Last[ observed ] === { { BlockRandom[ RandomInteger[ 1000000 ], RandomSeeding -> 41 ] } } ] ],
  True,
  TestID -> "RandomInfraSceneInstance-delayed-next-function-evaluated-once-in-scene-stream"
]

VerificationTest[
  With[ { scene = InfraScene[ { p }, { p == InfraPoint[] } ], graph = PathGraph[ Range[ 3 ] ] },
    BlockRandom[
      RandomInfraSceneInstance[ scene, graph, All,
        "NextVertexFunction" :> ( RandomInteger[ 1000000 ]; Identity ), RandomSeeding -> 41 ]; $RandomGeneratorState,
      RandomSeeding -> 17 ] === BlockRandom[ $RandomGeneratorState, RandomSeeding -> 17 ] ],
  True,
  TestID -> "RandomInfraSceneInstance-delayed-next-function-preserves-outer-state"
]

EndTestSection[]
