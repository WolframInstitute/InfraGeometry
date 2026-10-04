BeginTestSection["Hulls"]

(* UniversalLineQ: the path is a single universal line; C4 has one (antipodes
   1, 3 span the whole cycle); C5 has none (every line covers at most 4 of 5). *)

VerificationTest[
  UniversalLineQ[ PathGraph @ Range[ 5 ] ],
  True,
  TestID -> "UniversalLineQ-path"
]

VerificationTest[
  UniversalLineQ[ CycleGraph[ 4 ], { 1, 3 } ],
  True,
  TestID -> "UniversalLineQ-C4-pair"
]

VerificationTest[
  UniversalLineQ[ CycleGraph[ 4 ] ],
  True,
  TestID -> "UniversalLineQ-C4"
]

VerificationTest[
  UniversalLineQ[ CycleGraph[ 5 ] ],
  False,
  TestID -> "UniversalLineQ-C5-none"
]

(* Ball hull: the intersection of all closed balls containing S.  A closure
   operator (extensive, idempotent), output the sorted vertex list, and equal by
   definition to the intersection over every center of the smallest ball at
   that center enclosing S. *)

VerificationTest[
  FindBallHull[ GridGraph[ { 6, 4 } ], { 1, 6 } ] // ListQ,
  True,
  TestID -> "FindBallHull-returns-set"
]

VerificationTest[
  With[ { g = GridGraph[ { 6, 4 } ], s = { 1, 6, 22 } },
    SubsetQ[ FindBallHull[ g, s ], s ] ],
  True,
  TestID -> "FindBallHull-extensive"
]

VerificationTest[
  With[ { g = GridGraph[ { 6, 4 } ] }, { h = FindBallHull[ g, { 1, 6, 22 } ] },
    FindBallHull[ g, h ] === h ],
  True,
  TestID -> "FindBallHull-idempotent"
]

VerificationTest[
  With[ { g = GridGraph[ { 6, 4 } ] },
    BallHullQ[ g, FindBallHull[ g, { 1, 6, 22 } ] ] ],
  True,
  TestID -> "FindBallHull-ball-convex"
]

(* Defining property: w is in the hull iff d(c,w) <= max_{s} d(c,s) for every
   center c -- the intersection of the smallest enclosing balls. *)

VerificationTest[
  With[ { g = GridGraph[ { 6, 4 } ], s = { 1, 6, 22 } },
    FindBallHull[ g, s ] ===
      Sort @ Fold[ Intersection, VertexList @ g,
        Table[ With[ { r = Max[ GraphDistance[ g, c, # ] & /@ s ] },
            Select[ VertexList @ g, GraphDistance[ g, c, # ] <= r & ] ], { c, VertexList @ g } ] ] ],
  True,
  TestID -> "FindBallHull-equals-ball-intersection"
]

(* A singleton and a closed ball are both ball-convex (B_0(v) and B_r(c)); a
   generic mid-distance pair on a path is not. *)

VerificationTest[
  FindBallHull[ GridGraph[ { 4, 4 } ], { 6 } ],
  { 6 },
  TestID -> "FindBallHull-singleton"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    BallHullQ[ g, FindInfraRepresentative[g, InfraBall[13, 2]] ] ],
  True,
  TestID -> "BallHullQ-ball-is-ball-convex"
]

VerificationTest[
  BallHullQ[ PathGraph @ Range[ 5 ], { 1, 5 } ],
  False,
  TestID -> "BallHullQ-path-endpoints-open"
]

(* Input-form invariance: a bare vertex list and the density over it give the
   same ball hull. *)

VerificationTest[
  With[ { g = GridGraph[ { 6, 4 } ] },
    SameQ[
      FindBallHull[ g, { 1, 6, 22 } ],
      FindBallHull[ g, { 1, 6, 22 } ],
      FindBallHull[ g, <| 1 -> 1, 6 -> 1, 22 -> 1 |> ] ] ],
  True,
  TestID -> "FindBallHull-input-form-invariance"
]

(* each hull is a set: a sorted, duplicate-free vertex List containing S *)
VerificationTest[
  With[{g = GridGraph[{5, 5}], s = {1, 7}},
    {hulls = {FindBallHull[g, s], FindSegmentHull[g, s]}},
    AllTrue[hulls, ListQ[#] && # === Union[#] && SubsetQ[#, s] && SubsetQ[VertexList[g], #] &]],
  True,
  TestID -> "hulls-are-sorted-vertex-lists"
]

EndTestSection[]
