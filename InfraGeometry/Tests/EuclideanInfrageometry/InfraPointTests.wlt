BeginTestSection["InfraPoint"]

(* the vertex density of a point token is the set it draws from, every vertex with weight 1 *)
VerificationTest[
  With[ { g = CycleGraph[ 4 ] },
    InfraMeasurement[ g, #, "VertexDensity" ] & /@ { InfraPoint[ ], InfraPoint[ 2 ], InfraPoint[ InfraSegment[ 1, 3 ] ] } ],
  { <| 1 -> 1, 2 -> 1, 3 -> 1, 4 -> 1 |>, <| 2 -> 1 |>, <| 1 -> 1, 2 -> 1, 3 -> 1, 4 -> 1 |> },
  TestID -> "InfraPoint-VertexDensity-is-its-pool"
]

(* the support of the density is what RandomInfraPoint draws from *)
VerificationTest[
  With[ { g = CycleGraph[ 6 ] },
    AllTrue[ { InfraPoint[ ], InfraPoint[ 3 ], InfraPoint[ InfraSegment[ 1, 4 ] ], InfraPoint[ InfraBall[ 1, 1 ] ] },
      token |-> Keys @ InfraMeasurement[ g, token, "VertexDensity" ] === Sort @ RandomInfraPoint[ g, token, All ] ] ],
  True,
  TestID -> "InfraPoint-VertexDensity-support-is-the-sample-space"
]

(* reachability reads point and walk tokens through their vertex densities *)
VerificationTest[
  With[ { g = Graph[ { 1 <-> 2, 3 <-> 4 } ] },
    { InfraReachableQ[ g, InfraPoint[ 1 ], 2 ], InfraReachableQ[ g, InfraWalk[ 1, 2 ], InfraPoint[ 4 ] ] } ],
  { True, False },
  TestID -> "InfraReachableQ-on-point-and-walk-tokens"
]

(* an object without a vertex density is a non-match *)
VerificationTest[
  Head @ InfraReachableQ[ PathGraph[ Range[ 3 ] ], InfraWalk[ 1, 3 ], 2 ],
  InfraReachableQ,
  TestID -> "InfraReachableQ-stays-unevaluated-without-a-density"
]

EndTestSection[]
