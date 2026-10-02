BeginTestSection["InfraShell"]

VerificationTest[
  InfraMeasurement[GridGraph[{5, 5}], InfraShell[13, 2], "VertexDensity"],
  <| 3 -> 1, 7 -> 1, 9 -> 1, 11 -> 1, 15 -> 1, 17 -> 1, 19 -> 1, 23 -> 1 |>,
  TestID -> "InfraShell-level-set-r2"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    { FindInfraRepresentative[g, InfraShell[13, {1, 2}]], FindInfraRepresentative[g, InfraShell[13, {0, 0}]],
      FindInfraRepresentative[g, InfraShell[13, {3, 2}]], FindInfraRepresentative[g, InfraShell[13, 9]] } ],
  { {3, 7, 8, 9, 11, 12, 14, 15, 17, 18, 19, 23}, {13}, {}, {} },
  TestID -> "InfraShell-band-point-reversed-past-eccentricity"
]

VerificationTest[
  FindInfraRepresentative[PathGraph[Range[7]], InfraShell[{1, 7}, 1]],
  {2, 6},
  TestID -> "InfraShell-of-a-vertex-set-is-a-level-set-of-the-set-distance"
]

VerificationTest[
  Keys @ InfraMeasurement[GridGraph[{5, 5}], InfraShell[13, 2], All],
  { "Faithful", "Cardinality", "VertexDensity", "EdgeDensity", "Subgraph", "Volume", "BoundaryVolume", "InteriorVolume", "HalfBoundaryVolume" },
  TestID -> "InfraShell-All-nine-properties"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    { InfraMeasurement[g, InfraShell[13, {1, 2}], "EdgeDensity"], InfraMeasurement[g, InfraShell[13, 2], { "Cardinality", "Faithful" }] } ],
  { <| UndirectedEdge[3, 8] -> 1, UndirectedEdge[7, 8] -> 1, UndirectedEdge[7, 12] -> 1, UndirectedEdge[8, 9] -> 1, UndirectedEdge[9, 14] -> 1,
       UndirectedEdge[11, 12] -> 1, UndirectedEdge[12, 17] -> 1, UndirectedEdge[14, 15] -> 1, UndirectedEdge[14, 19] -> 1,
       UndirectedEdge[17, 18] -> 1, UndirectedEdge[18, 19] -> 1, UndirectedEdge[18, 23] -> 1 |>,
    <| "Cardinality" -> 1, "Faithful" -> True |> },
  TestID -> "InfraShell-edges-of-the-induced-subgraph"
]

(* |S_r| = 4r on the square grid away from the rim *)
VerificationTest[
  With[ { g = GridGraph[{11, 11}] },
    InfraMeasurement[g, InfraShell[61, #], "Volume"] & /@ Range[1, 5] ],
  4 Range[1, 5],
  TestID -> "InfraShell-square-grid-volume-4r"
]

VerificationTest[
  Table[
    With[ { g = InfraSubstrate[name, "Small"] },
      { c = InfraCenter[g] },
      { profile = ShellAreas[g, c] },
      InfraMeasurement[g, InfraShell[c, #], "Volume"] & /@ Range[0, Length[profile] - 1] === profile ],
    { name, { "SquareTilingGraph", "TriangularTilingGraph" } } ],
  { True, True },
  TestID -> "InfraShell-volume-profile-is-ShellAreas"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    { FindInfraShell[g, 13, 2], FindInfraShell[g, 13, {1, 2}] } ===
      { FindInfraRepresentative[g, InfraShell[13, 2]], FindInfraRepresentative[g, InfraShell[13, {1, 2}]] } ],
  True,
  TestID -> "FindInfraShell-is-the-level-set"
]

VerificationTest[
  Head @ InfraSubstrateHighlight[GridGraph[{5, 5}], { InfraShell[13, {1, 2}] }],
  Graph,
  TestID -> "InfraShell-draws"
]

EndTestSection[]
