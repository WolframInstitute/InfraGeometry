BeginTestSection["InfraMetricTensor"]

(* Moved from EuclideanSpaceTests.wlt on 2026-10-05 with the metric tensor's kernel file (APISurfaceCleanup T9) *)

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
