BeginTestSection["InfraEuclideanSpace"]

(* ===== InfraScalarProduct (Alexandrov, k = 0 default) ===== *)

VerificationTest[
  InfraScalarProduct[PathGraph[Range[5]], 1, 3, 4],
  6,
  TestID -> "InfraScalarProduct-path-Alexandrov-formula"
]

VerificationTest[
  Table[
    InfraScalarProduct[PathGraph[Range[5]], 1, k, l] === (k - 1)(l - 1),
    {k, 1, 5}, {l, 1, 5}
  ] // Flatten // Apply[And],
  True,
  TestID -> "InfraScalarProduct-path-Alexandrov-identity"
]

VerificationTest[
  InfraScalarProduct[GridGraph[{4, 4}], 1, 2, 5],
  -1,
  TestID -> "InfraScalarProduct-grid-Alexandrov-not-orthogonal"
]

VerificationTest[
  InfraScalarProduct[PathGraph[Range[5]], 1, 3, 3],
  GraphDistance[PathGraph[Range[5]], 1, 3]^2,
  TestID -> "InfraScalarProduct-norm-equals-distance-squared"
]

(* ===== InfraScalarProduct (Alexandrov, curvature k != 0) ===== *)

(* k = 0 default agrees with explicit "Curvature" -> 0. *)
VerificationTest[
  InfraScalarProduct[GridGraph[{4, 4}], 1, 2, 5,
    Method -> {"Alexandrov", "Curvature" -> 0}],
  -1,
  TestID -> "InfraScalarProduct-Alexandrov-curvature-zero-matches-default"
]

(* Generic relation: InfraAngle Alexandrov(k) = ArcCos[SP_k / (|u||v|)] for any k. *)
VerificationTest[
  With[ { g = CycleGraph[8], k = 1/4 },
    With[ { spk = InfraScalarProduct[g, 1, 3, 7,
                    Method -> {"Alexandrov", "Curvature" -> k}],
            angK = InfraAngle[g, {3, 1, 7},
                    Method -> {"Alexandrov", "Curvature" -> k}],
            a = GraphDistance[g, 1, 3], b = GraphDistance[g, 1, 7] },
      Simplify[ ArcCos[ spk / ( a b ) ] - angK ] === 0
    ] ],
  True,
  TestID -> "InfraScalarProduct-Alexandrov-curvature-recovers-angle"
]

(* ===== InfraScalarProduct (Parallelogram) ===== *)

VerificationTest[
  InfraScalarProduct[PathGraph[Range[10]], 5, 7, 6, Method -> "Parallelogram"],
  2,
  TestID -> "InfraScalarProduct-path-Parallelogram-matches-Alexandrov"
]

VerificationTest[
  Quiet @ InfraScalarProduct[CycleGraph[6], 1, 2, 3, Method -> "Parallelogram"],
  { },
  TestID -> "InfraScalarProduct-cycle-Parallelogram-no-negation"
]

VerificationTest[
  InfraScalarProduct[PathGraph[Range[5]], 1, 2, 5, Method -> "Parallelogram"],
  { },
  TestID -> "InfraScalarProduct-Parallelogram-no-realisation"
]

(* ===== FindInfraLinearCombination scaling: "Metric" ===== *)

VerificationTest[
  FindInfraLinearCombination[PathGraph[Range[10]], 1, {{2, 3}}],
  { 5 },
  TestID -> "FindInfraLinearCombination-scale-metric-integer"
]

VerificationTest[
  FindInfraLinearCombination[PathGraph[Range[10]], 1, {{1.7, 3}}, All, "ScaleMethod" -> "Metric"],
  { },
  TestID -> "FindInfraLinearCombination-scale-metric-real-empty"
]

(* ===== FindInfraLinearCombination scaling: "Line" ===== *)

VerificationTest[
  FindInfraLinearCombination[PathGraph[Range[10]], 1, {{1.7, 3}}, "ScaleMethod" -> "Line"],
  { 4 },
  TestID -> "FindInfraLinearCombination-scale-line-real"
]

VerificationTest[
  FindInfraLinearCombination[PathGraph[Range[10]], 1, {{2, 3}}, "ScaleMethod" -> "Line"],
  { 5 },
  TestID -> "FindInfraLinearCombination-scale-line-integer"
]

(* ===== FindInfraLinearCombination scaling: "Midpoint" ===== *)

VerificationTest[
  FindInfraLinearCombination[PathGraph[Range[9]], 1, {{1/2, 5}}, "ScaleMethod" -> "Midpoint"],
  { 3 },
  TestID -> "FindInfraLinearCombination-scale-midpoint-half"
]

VerificationTest[
  FindInfraLinearCombination[PathGraph[Range[9]], 1, {{1/4, 5}}, "ScaleMethod" -> "Midpoint"],
  { 2 },
  TestID -> "FindInfraLinearCombination-scale-midpoint-quarter"
]

(* ===== FindInfraLinearCombination scaling: Automatic dispatch ===== *)

VerificationTest[
  FindInfraLinearCombination[PathGraph[Range[9]], 1, {{1/2, 5}}],
  { 3 },
  TestID -> "FindInfraLinearCombination-scale-auto-dyadic"
]

VerificationTest[
  FindInfraLinearCombination[PathGraph[Range[10]], 1, {{2, 3}}],
  { 5 },
  TestID -> "FindInfraLinearCombination-scale-auto-integer"
]

(* ===== FindInfraLinearCombination sum: "Metric" ===== *)

VerificationTest[
  FindInfraLinearCombination[GridGraph[{4, 4}], 1, {{1, 2}, {1, 5}}],
  { 6 },
  TestID -> "FindInfraLinearCombination-sum-metric-grid-parallelogram"
]

VerificationTest[
  FindInfraLinearCombination[CycleGraph[4], 1, {{1, 2}, {1, 4}}],
  { 3 },
  TestID -> "FindInfraLinearCombination-sum-metric-C4-antipode"
]

VerificationTest[
  Sort[ FindInfraLinearCombination[
    Graph[{1 <-> 2, 1 <-> 3, 2 <-> 4, 2 <-> 5, 3 <-> 6, 3 <-> 7}],
    1, {{1, 2}, {1, 3}}, All
  ] ],
  {},
  TestID -> "FindInfraLinearCombination-sum-tree-no-parallelogram"
]

(* ===== FindInfraLinearCombination sum: "Parallel" ===== *)

VerificationTest[
  MemberQ[
    FindInfraLinearCombination[GridGraph[{4, 4}], 1, {{1, 2}, {1, 5}}, All, "SumMethod" -> "Parallel"],
    6
  ],
  True,
  TestID -> "FindInfraLinearCombination-sum-parallel-grid-includes-corner"
]

(* ===== FindInfraLinearCombination composition / edge cases ===== *)

VerificationTest[
  FindInfraLinearCombination[PathGraph[Range[10]], 5, {{-1, 8}}],
  { 2 },
  TestID -> "FindInfraLinearCombination-reflection-by-minus-one"
]

VerificationTest[
  FindInfraLinearCombination[PathGraph[Range[5]], 3, {}],
  { 3 },
  TestID -> "FindInfraLinearCombination-empty-terms"
]

VerificationTest[
  FindInfraLinearCombination[PathGraph[Range[5]], 3, {{0, 5}}],
  { 3 },
  TestID -> "FindInfraLinearCombination-zero-coefficient"
]

(* ===== InfraAngle (moved from EuclideanConstructions) ===== *)

VerificationTest[
  InfraAngle[CycleGraph[6], {1, 2, 3}],
  4,
  TestID -> "InfraAngle-cycle-local"
]

VerificationTest[
  InfraAngle[PathGraph[Range[5]], {1, 3, 5}],
  Infinity,
  TestID -> "InfraAngle-path-infinite"
]

VerificationTest[
  InfraAngle[CompleteGraph[4], {2, 1, 3}],
  1,
  TestID -> "InfraAngle-complete-graph"
]

VerificationTest[
  InfraAngle[CycleGraph[6], {1, 2, 3}] == InfraAngle[CycleGraph[6], {3, 2, 1}],
  True,
  TestID -> "InfraAngle-symmetric"
]

VerificationTest[
  InfraScalarProduct[PathGraph[Range[7]], 4, 1, 7],
  -9,
  TestID -> "InfraScalarProduct-path-straight-recovers-Schoenberg-value"
]

(* (3, 4, 5) Pythagorean triple of graph distances:
   d(1, 4) = 3, d(1, 8) = 4, d(4, 8) = 5 -- Alexandrov SP = (9 + 16 - 25)/2 = 0. *)
VerificationTest[
  InfraScalarProduct[
    Graph[{1 <-> 2, 2 <-> 3, 3 <-> 4, 1 <-> 5, 5 <-> 6, 6 <-> 7, 7 <-> 8,
           4 <-> 9, 9 <-> 10, 10 <-> 11, 11 <-> 12, 12 <-> 8}],
    1, 4, 8],
  0,
  TestID -> "InfraScalarProduct-Pythagorean-right-angle"
]

(* ArcCos[SP / (|u||v|)] recovers the InfraAngle Alexandrov(k = 0) value. *)
VerificationTest[
  With[ { g = CycleGraph[8] },
    ArcCos[
      InfraScalarProduct[g, 1, 3, 7] /
      ( GraphDistance[g, 1, 3] GraphDistance[g, 1, 7] )
    ] === InfraAngle[g, {3, 1, 7}, Method -> "Alexandrov"] ],
  True,
  TestID -> "InfraScalarProduct-recovers-Alexandrov-angle"
]

(* ===== InfraAngle Method dispatch ===== *)

(* Arclength at p = 2 in C_5: radius = 1, the open ball deletes only vertex 2
   itself (distance 0 < 1).  In the remaining graph on {1, 3, 4, 5},
   d(1, 3) = 3 (via 1-5-4-3), so the angle is 3 / 1 = 3. *)
VerificationTest[
  InfraAngle[ CycleGraph[ 5 ], { 1, 2, 3 } ],
  3,
  TestID -> "InfraAngle-CycleGraph5-Arclength-default-unchanged"
]

VerificationTest[
  InfraAngle[ CompleteGraph[ 3 ], { 1, 2, 3 }, Method -> "Alexandrov" ],
  Pi / 3,
  SameTest -> ( Abs[ N[ #1 ] - N[ #2 ] ] < 10^-10 & ),
  TestID -> "InfraAngle-K3-Alexandrov-Pi-over-3"
]

VerificationTest[
  InfraAngle[ PathGraph[ Range[ 3 ] ], { 1, 2, 3 }, Method -> "Alexandrov" ],
  Pi,
  SameTest -> ( Abs[ N[ #1 ] - N[ #2 ] ] < 10^-10 & ),
  TestID -> "InfraAngle-P3-Alexandrov-degenerate-Pi"
]

VerificationTest[
  N @ InfraAngle[ CompleteGraph[ 3 ], { 1, 2, 3 },
        Method -> { "Alexandrov", "Curvature" -> 0 } ],
  N[ Pi / 3 ],
  SameTest -> ( Abs[ #1 - #2 ] < 10^-10 & ),
  TestID -> "InfraAngle-Alexandrov-Curvature0-matches-Euclidean"
]

(* ===== InfraAngle accepts v wrappers ===== *)

VerificationTest[
  InfraAngle[ GridGraph[ { 5, 5 } ], { 3, 13, 11 } ],
  InfraAngle[ GridGraph[ { 5, 5 } ], { 3, 13, 11 } ],
  TestID -> "InfraAngle-accepts-InfraPoint-wrappers-Arclength"
]

VerificationTest[
  InfraAngle[ CompleteGraph[ 3 ], { 1, 2, 3 }, Method -> "Alexandrov" ],
  InfraAngle[ CompleteGraph[ 3 ], { 1, 2, 3 }, Method -> "Alexandrov" ],
  TestID -> "InfraAngle-accepts-InfraPoint-wrappers-Alexandrov"
]

VerificationTest[
  InfraAngle[ GridGraph[ { 5, 5 } ], { 3, 13, 11 } ],
  InfraAngle[ GridGraph[ { 5, 5 } ], { 3, 13, 11 } ],
  TestID -> "InfraAngle-accepts-mixed-wrapped-and-bare"
]

EndTestSection[]
