BeginTestSection["InfraShell"]

VerificationTest[
  InfraMeasurement[GridGraph[{5, 5}], InfraShell[13, 2], "VertexDensity"],
  <| 3 -> 1, 7 -> 1, 9 -> 1, 11 -> 1, 15 -> 1, 17 -> 1, 19 -> 1, 23 -> 1 |>,
  TestID -> "InfraShell-level-set-r2"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    { RandomInfraShell[ g, InfraShell[13, {1, 2}] ], RandomInfraShell[ g, InfraShell[13, {0, 0}] ],
      RandomInfraShell[ g, InfraShell[13, {3, 2}] ], RandomInfraShell[ g, InfraShell[13, 9] ] } ],
  { {3, 7, 8, 9, 11, 12, 14, 15, 17, 18, 19, 23}, {13}, {}, {} },
  TestID -> "InfraShell-band-point-reversed-past-eccentricity"
]

VerificationTest[
  RandomInfraShell[ PathGraph[Range[7]], InfraShell[{1, 7}, 1] ],
  {2, 6},
  TestID -> "InfraShell-of-a-vertex-set-is-a-level-set-of-the-set-distance"
]

VerificationTest[
  Keys @ InfraMeasurement[GridGraph[{5, 5}], InfraShell[13, 2], All],
  { "Faithful", "Cardinality", "VertexDensity", "EdgeDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" },
  TestID -> "InfraShell-All-seven-properties"
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
    InfraMeasurement[g, InfraShell[61, #], "CountingMeasure"] & /@ Range[1, 5] ],
  4 Range[1, 5],
  TestID -> "InfraShell-square-grid-counting-measure-4r"
]

(* the counting measure of the shells is the histogram of the distances from the centre *)
VerificationTest[
  Table[
    With[ { g = InfraSubstrate[name, "Small"] },
      { c = First @ GraphCenter[g] },
      { profile = Values @ KeySort @ Counts @ GraphDistance[g, c] },
      InfraMeasurement[g, InfraShell[c, #], "CountingMeasure"] & /@ Range[0, Length[profile] - 1] === profile ],
    { name, { "SquareTilingGraph", "TriangularTilingGraph" } } ],
  { True, True },
  TestID -> "InfraShell-counting-measure-is-the-distance-histogram"
]

(* every vertex of a shell S_r touches B_(r-1) or the far side, so its Riemannian measure is 0; a band {r - 1, r + 1}
   keeps its middle shell *)
VerificationTest[
  With[ { g = GridGraph[{9, 9}] },
    { Table[InfraMeasurement[g, InfraShell[41, r], "RiemannianMeasure"], { r, 0, 8 }],
      InfraMeasurement[g, InfraShell[41, {1, 3}], "RiemannianMeasure"] } ],
  { ConstantArray[0, 9], 8 },
  TestID -> "InfraShell-Riemannian-measure-of-a-shell-is-zero"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    { FindInfraShell[g, 13, 2], FindInfraShell[g, 13, {1, 2}] } ===
      { RandomInfraShell[ g, InfraShell[13, 2] ], RandomInfraShell[ g, InfraShell[13, {1, 2}] ] } ],
  True,
  TestID -> "FindInfraShell-is-the-level-set"
]

VerificationTest[
  Head @ InfraSubstrateHighlight[GridGraph[{5, 5}], { InfraShell[13, {1, 2}] }],
  Graph,
  TestID -> "InfraShell-draws"
]

EndTestSection[]
