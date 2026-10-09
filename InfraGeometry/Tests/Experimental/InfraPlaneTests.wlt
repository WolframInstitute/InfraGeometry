VerificationTest[
  With[{g = PathGraph[Range[6]], plane = InfraPlane[1, 6, {-1, 1}]},
    {all = RandomInfraRepresentative[g, plane, All]},
    {Sort[all] === {{3}, {4}},
     RandomInfraRepresentative[g, plane, All, "NextVertexFunction" -> Identity] === all}],
  {True, True},
  TestID -> "RandomInfraRepresentative-InfraPlane-All-is-deterministic"
]

VerificationTest[
  With[{g = PathGraph[Range[6]], plane = InfraPlane[1, 6, {-1, 1}]},
    {draw = BlockRandom[RandomInfraRepresentative[g, plane], RandomSeeding -> 17]},
    {draw === BlockRandom[RandomInfraRepresentative[g, plane], RandomSeeding -> 17],
     InfraPlaneQ[g, draw, 1, 6, {-1, 1}],
     Length @ DeleteDuplicates @ Table[
       BlockRandom[RandomInfraRepresentative[g, plane], RandomSeeding -> s], {s, 1, 32}] > 1}],
  {True, True, True},
  TestID -> "RandomInfraRepresentative-InfraPlane-random-and-seeded"
]
