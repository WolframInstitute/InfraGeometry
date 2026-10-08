BeginTestSection["BallIntersectionComplex"]

(* Moved from the DiscreteGeometry paclet 2026-09-22 with Kernel/BallIntersectionComplex.wl. *)

VerificationTest[
    MiniballRadius[N @ {{0, 0}, {1, 0}, {1/2, Sqrt[3]/2}}],
    1/Sqrt[3.],
    SameTest -> (Abs[#1 - #2] < 10.^-9 &),
    TestID -> "MiniballRadius-equilateral-circumradius"
]

VerificationTest[
    With[{tri = N @ {{0, 0}, {1, 0}, {1/2, Sqrt[3]/2}}},
        {MemberQ[BallIntersectionComplex[tri, 0.55, 2], {1, 2, 3}],
         MemberQ[BallIntersectionComplex[tri, 0.55, Infinity], {1, 2, 3}]}
    ],
    {True, False},
    TestID -> "BallIntersectionComplex-triangle-discriminator"
]

(* order 2 reproduces Vietoris-Rips at scale 2 r (closed balls meet iff d <= 2 r).
   Rips is built here from the proximity graph rather than with the sibling paclet's
   VietorisRipsComplex, so this suite depends on no other paclet. Checked identical
   to VietorisRipsComplex[pts, 0.9] on these points. *)
VerificationTest[
    With[{pts = N @ CirclePoints[8]},
        With[{rips = Union @@ (Subsets[#, {1, Infinity}] & /@
                FindClique[RelationGraph[
                    EuclideanDistance[pts[[#1]], pts[[#2]]] <= 0.9 &, Range[8]],
                    {1, Infinity}, All])},
            Sort[BallIntersectionComplex[pts, 0.45, 2]] === Sort[rips]]],
    True,
    TestID -> "BallIntersectionComplex-order2-equals-rips-at-2r"
]

VerificationTest[
    With[{pts = N @ {{0, 0}, {1, 0}, {1, 1}, {0, 1}, {1/2, 1/2}}},
        AllTrue[CechComplex[pts, 0.7], MiniballRadius[pts[[#]]] <= 0.7 + 10.^-9 &]
    ],
    True,
    TestID -> "CechComplex-every-simplex-has-common-point"
]

VerificationTest[
    With[{pts = N @ CirclePoints[6], r = 0.65},
        With[{lad = Sort[BallIntersectionComplex[pts, r, #]] & /@ {2, 3, Infinity}},
            {SubsetQ[lad[[1]], lad[[2]]], lad[[2]] === lad[[3]]}
        ]
    ],
    {True, True},
    TestID -> "BallIntersectionComplex-helly-ladder-saturation-R2"
]

VerificationTest[
    With[{sq = N @ {{0, 0}, {1, 0}, {1, 1}, {0, 1}, {1/2, 1/2}}},
        With[{fk = BallIntersectionFiltrationValue[sq, #, 2] &},
            fk[{1, 2}] <= fk[{1, 2, 3}] + 10.^-12
        ]
    ],
    True,
    TestID -> "BallIntersectionFiltrationValue-monotone-under-faces"
]

VerificationTest[
    With[{m = GraphDistanceMatrix[CycleGraph[6]], v = Range[6]},
        With[{rips = Sort[BallIntersectionComplex[v, 2, 2, "Metric" -> m]],
              cech = Sort[BallIntersectionComplex[v, 2, Infinity, "Metric" -> m]]},
            SubsetQ[rips, cech] && rips =!= cech
        ]
    ],
    True,
    TestID -> "BallIntersectionComplex-metric-oracle-no-collapse"
]

VerificationTest[
    With[{sq = N @ {{0, 0}, {1, 0}, {1, 1}, {0, 1}, {1/2, 1/2}}, r = 0.72},
        SubsetQ[
            Sort[CechComplex[sq, r]],
            Sort[BallIntersectionComplex[sq, r, Infinity, "IntersectionTest" -> (RegionMeasure[#] >= 0.05 &)]]
        ]
    ],
    True,
    TestID -> "BallIntersectionComplex-quality-measure-refines-cech"
]


VerificationTest[
    Sort @ BallIntersectionComplex[{2, 4, 6}, 1, Infinity, "Metric" -> PathGraph[Range[7]]],
    {{1}, {2}, {3}, {1, 2}, {2, 3}},
    TestID -> "BallIntersectionComplex-graph-chosen-centres"
]

(* one point: the smallest enclosing ball has radius exactly 0 *)
VerificationTest[
    {MiniballRadius[{{0, 0}}], MiniballRadius[{{1., 2., 3.}}]},
    {0, 0},
    TestID -> "MiniballRadius-one-point-exact-zero"
]

EndTestSection[]
