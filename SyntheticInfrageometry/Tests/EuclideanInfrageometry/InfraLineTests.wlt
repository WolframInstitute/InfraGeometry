BeginTestSection["InfraLine"]

realisations = WolframInstitute`SyntheticInfrageometry`PackageScope`infraSpread;

(* ===== InfraLine[graph, p, q] stands for every line through p and q ===== *)

(* C_6 through {1, 2} has three lines, not four: the pool and the object agree *)
VerificationTest[
  With[{g = CycleGraph[6]}, {line = InfraLine[g, 1, 2]},
    Sort[VertexList /@ Normal[line]] === Sort[{{6, 1, 2, 3}, {5, 6, 1, 2}, {1, 2, 3, 4}}] && line["Multiplicity"] == 3],
  True,
  TestID -> "InfraLine-C6-three-lines"
]

(* the realisations are FindInfraLine's class, and every one satisfies InfraLineQ *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]}, {line = InfraLine[g, 4, 5]},
    Sort[VertexList /@ Normal[line]] === Sort[realisations @ FindInfraLine[g, 4, 5, All]] && InfraLineQ[g, line]],
  True,
  TestID -> "InfraLine-realisations-are-the-line-class"
]

(* one atom per admissible pair of ends; multiplicity by DP equals the enumeration *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]}, {line = InfraLine[g, 4, 5]},
    {Length[line["Atoms"]], line["Multiplicity"]} === {2, Length @ Normal[line]} && line["Length"] == 4],
  True,
  TestID -> "InfraLine-atoms-and-multiplicity"
]

(* the same lines through the segment object and through the walk graph *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]},
    {Normal @ InfraLine[g, InfraSegment[g, 4, 5]] === Normal @ InfraLine[g, 4, 5],
     Normal @ InfraLine[g, PathGraph[{4, 5}, DirectedEdges -> True]] === Normal @ InfraLine[g, 4, 5]}],
  {True, True},
  TestID -> "InfraLine-through-a-segment-object-or-a-walk"
]

(* Part and the density *)
VerificationTest[
  With[{g = GridGraph[{3, 3}]}, {line = InfraLine[g, 4, 5]}, {all = Normal[line]},
    line[[1]] === First[all] && line[[2 ;; 3]] === all[[2 ;; 3]] &&
    line["InfraDensity"] === KeySort @ Counts @ Catenate[VertexList /@ all]],
  True,
  TestID -> "InfraLine-Part-and-InfraDensity"
]

(* the scene tokens stay inert *)
VerificationTest[
  {InfraLine[1, 2], InfraLine[{1, 2, 3}]},
  {InfraLine[1, 2], InfraLine[{1, 2, 3}]},
  TestID -> "InfraLine-tokens-without-graph-stay-inert"
]

EndTestSection[]
