BeginTestSection[ "InfraAngle" ]

VerificationTest[
  InfraAngle[ CompleteGraph[ 4 ], { 2, 1, 3 } ],
  1,
  TestID -> "InfraAngle-unit-radius-arc"
]

VerificationTest[
  InfraAngle[ CycleGraph[ 5 ], { 1, 2, 3 }, "RadiusDelta" -> 1 ],
  3,
  TestID -> "InfraAngle-band-permits-detour"
]

VerificationTest[
  InfraAngle[ CycleGraph[ 12 ], { 4, 1, 10 }, "RadiusDelta" -> 3 ],
  6,
  TestID -> "InfraAngle-arc-length-without-radius-normalization"
]

VerificationTest[
  InfraAngle[ CycleGraph[ 6 ], { 1, 2, 3 } ],
  InfraMeasurement[ CycleGraph[ 6 ], InfraArc[ 2, { 1, 3 }, "RadiusDelta" -> 0 ], "Length" ],
  TestID -> "InfraAngle-disconnected-thin-band-follows-arc-measurement"
]

EndTestSection[]
