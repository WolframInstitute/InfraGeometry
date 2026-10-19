BeginTestSection["InfraComparisonAngle"]

VerificationTest[
  InfraComparisonAngle[ CompleteGraph[ 3 ], { 1, 2, 3 } ],
  Pi / 3,
  SameTest -> ( Abs[ N[ #1 ] - N[ #2 ] ] < 10^-10 & ),
  TestID -> "InfraComparisonAngle-K3-Alexandrov-Pi-over-3"
]

VerificationTest[
  InfraComparisonAngle[ PathGraph[ Range[ 3 ] ], { 1, 2, 3 } ],
  Pi,
  SameTest -> ( Abs[ N[ #1 ] - N[ #2 ] ] < 10^-10 & ),
  TestID -> "InfraComparisonAngle-P3-Alexandrov-degenerate-Pi"
]

VerificationTest[
  N @ InfraComparisonAngle[ CompleteGraph[ 3 ], { 1, 2, 3 } ],
  N[ Pi / 3 ],
  SameTest -> ( Abs[ #1 - #2 ] < 10^-10 & ),
  TestID -> "InfraComparisonAngle-Alexandrov-Curvature0-matches-Euclidean"
]

EndTestSection[]
