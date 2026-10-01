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

EndTestSection[]

BeginTestSection["InfraMetricTensor"]

(* On a path from its end, I(p, w) is the initial stretch, so the projection of v is min(v, w). *)
VerificationTest[
  InfraMetricTensor[PathGraph[Range[5]], 1],
  Table[If[v == 1, 0, Min[v - 1, w - 1]/(v - 1)], {v, 5}, {w, 5}],
  TestID -> "InfraMetricTensor-path-end"
]

(* From the middle of a path, opposite sides are orthogonal and the entry is clamped at d(p, w)/d(p, v). *)
VerificationTest[
  With[ { T = InfraMetricTensor[PathGraph[Range[5]], 3] }, { T[[1, 5]], T[[5, 4]], T[[4, 5]] } ],
  { 0, 1/2, 1 },
  TestID -> "InfraMetricTensor-path-middle"
]

VerificationTest[
  InfraMetricTensor[CycleGraph[6], 1],
  { {0, 0, 0, 0, 0, 0}, {0, 1, 1, 1, 0, 0}, {0, 1/2, 1, 1, 0, 0},
    {0, 1/3, 2/3, 1, 2/3, 1/3}, {0, 0, 0, 1, 1, 1/2}, {0, 0, 0, 1, 1, 1} },
  TestID -> "InfraMetricTensor-cycle"
]

(* On C6 the vertex 3 is equidistant from both ends of I(1, 5) = {1, 6, 5}, at indices 0 and 1. *)
VerificationTest[
  With[ { g = CycleGraph[6] },
    { tensor = sel |-> InfraMetricTensor[g, 1, "SelectCoordinate" -> sel] },
    { tensor[#][[3, 5]] & /@ { Min, Max, Mean, All },
      And @@ Thread[ Flatten @ tensor[Min] <= Flatten @ tensor[Mean] <= Flatten @ tensor[Max] ] } ],
  { { 0, 1, 1/2, {0, 1} }, True },
  TestID -> "InfraMetricTensor-tie-rule"
]

VerificationTest[
  With[ { g = GridGraph[{3, 3}] }, { T = InfraMetricTensor[g, 5], dp = GraphDistance[g, 5] },
    { T[[5]] == ConstantArray[0, 9], T[[All, 5]] == ConstantArray[0, 9],
      Delete[Diagonal @ T, 5] == ConstantArray[1, 8],
      And @@ Flatten @ Table[ v == 5 || 0 <= T[[v, w]] <= dp[[w]]/dp[[v]], {v, 9}, {w, 9} ] } ],
  { True, True, True, True },
  TestID -> "InfraMetricTensor-bounds"
]

(* On the square grid the interval is a box and the projection the unique coordinate clamp: T is the normalised Gromov product. *)
VerificationTest[
  With[ { g = GridGraph[{4, 4}] }, { dm = GraphDistanceMatrix[g] },
    { InfraMetricTensor[g, 6] ==
        Table[If[v == 6, 0, (dm[[6, v]] + dm[[6, w]] - dm[[v, w]])/(2 dm[[6, v]])], {v, 16}, {w, 16}],
      InfraMetricTensor[g, 6] == InfraMetricTensor[g, 6, "SelectCoordinate" -> Max] } ],
  { True, True },
  TestID -> "InfraMetricTensor-grid-Gromov-product"
]

(* On a grid shell of radius r the tensor is symmetric, 1 - d(v, w)/(2 r), and the shell block of the full tensor. *)
VerificationTest[
  With[ { g = GridGraph[{5, 5}] }, { dm = GraphDistanceMatrix[g], s = Flatten @ Position[GraphDistance[g, 13], 2] },
    { T = InfraMetricTensor[g, 13, 2] },
    { T == Transpose[T], T == 1 - dm[[s, s]]/4, Dimensions[T], T == InfraMetricTensor[g, 13][[s, s]] } ],
  { True, True, {8, 8}, True },
  TestID -> "InfraMetricTensor-grid-shell"
]

VerificationTest[
  InfraMetricTensor[CycleGraph[6], 1, 2, "SelectCoordinate" -> #] & /@ { Min, Max, Mean },
  { {{1, 0}, {0, 1}}, {{1, 1}, {1, 1}}, {{1, 1/2}, {1/2, 1}} },
  TestID -> "InfraMetricTensor-cycle-shell"
]

(* The hexagonal stable norm has flat faces, so the triangular lattice has genuine ties and the square grid none. *)
VerificationTest[
  With[ { h = TessellationNeighborhoodGraph[{3, 6}, 2], g = GridGraph[{5, 5}] }, { c = First @ GraphCenter[h] },
    { Max[ InfraMetricTensor[h, c, "SelectCoordinate" -> Max] - InfraMetricTensor[h, c] ] > 0,
      InfraMetricTensor[g, 13, "SelectCoordinate" -> Max] == InfraMetricTensor[g, 13] } ],
  { True, True },
  TestID -> "InfraMetricTensor-ties-triangular-not-square"
]

EndTestSection[]
