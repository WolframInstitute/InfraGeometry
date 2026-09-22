BeginTestSection["InfraCircle"]

(* the shortest simple cycles of the band through p that separate c from beyond, by brute force *)
bruteCircles[g_Graph, c_, p_, tol_] :=
  Module[{r = GraphDistance[g, c, p], band, localG, dist, shell, sepQ, found = {}},
    band = {Max[1, r - tol], r + tol};
    localG = NeighborhoodGraph[g, c, Last@band + 2];
    dist = AssociationThread[VertexList@localG, GraphDistance[localG, c]];
    shell = Subgraph[localG, Select[VertexList@localG, First@band <= dist[#] <= Last@band &]];
    sepQ = Function[verts, With[{cc = SelectFirst[ConnectedComponents@VertexDelete[localG, verts], MemberQ[#, c] &]},
      cc =!= Missing["NotFound"] && AllTrue[cc, dist[#] <= Last@band &]]];
    Do[With[{cycles = Select[First /@ # & /@ FindCycle[shell, {k}, All], MemberQ[#, p] && sepQ[#] &]},
      If[cycles =!= {}, found = cycles; Break[]]], {k, 3, VertexCount@shell}];
    found]

cycleSets[cycles_] := Sort[Sort /@ cycles]

(* ===== the triangular patch: the radius-2 hexagon is the one circle through p ===== *)

VerificationTest[
  With[{g = TessellationNeighborhoodGraph[{3, 6}, 5]}, {c = First @ GraphCenter[g]},
    {p = First @ Select[VertexList[g], GraphDistance[g, c, #] == 2 &]},
    {circle = InfraCircle[g, c, p]},
    {circle["Multiplicity"], circle["Length"], VertexCount @ First @ Normal[circle],
     InfraCircleQ[g, circle], MemberQ[VertexList @ First @ Normal[circle], p]}],
  {1, 12, 12, True, True},
  TestID -> "InfraCircle-triangular-patch-radius-2"
]

(* it is the same circle FindInfraCircle finds at that radius *)
VerificationTest[
  With[{g = TessellationNeighborhoodGraph[{3, 6}, 5]}, {c = First @ GraphCenter[g]},
    {p = First @ Select[VertexList[g], GraphDistance[g, c, #] == 2 &]},
    Sort @ VertexList @ First @ Normal @ InfraCircle[g, c, p] === Sort @ VertexList @ FindInfraCircle[g, c, 2]],
  True,
  TestID -> "InfraCircle-agrees-with-FindInfraCircle-at-the-radius"
]

(* p is the source and sink of the carrier: the closed walks of "Graph" through p are the circles *)
VerificationTest[
  With[{g = TessellationNeighborhoodGraph[{3, 6}, 5]}, {c = First @ GraphCenter[g]},
    {p = First @ Select[VertexList[g], GraphDistance[g, c, #] == 3 &]},
    {circle = InfraCircle[g, c, p]}, {dag = circle["Graph"]},
    {VertexInDegree[dag, p] > 0, VertexOutDegree[dag, p] > 0, AcyclicGraphQ @ VertexDelete[dag, p],
     circle["InfraDensity"][p] == circle["Multiplicity"], circle["Length"] == 18}],
  {True, True, True, True, True},
  TestID -> "InfraCircle-p-is-source-and-sink"
]

(* ===== the grid: the exact radius carries no cycle, the tolerance band does ===== *)

VerificationTest[
  With[{g = GridGraph[{7, 7}]}, {p = First @ Select[VertexList[g], GraphDistance[g, 25, #] == 3 &]},
    {InfraCircle[g, 25, p]["Multiplicity"], InfraCircle[g, 25, p, "Tolerance" -> 1]["Band"]}],
  {0, {2, 4}},
  TestID -> "InfraCircle-grid-needs-the-band"
]

(* the object equals the brute-force family through p, as cycles, on several points and tolerances *)
VerificationTest[
  With[{g = GridGraph[{7, 7}]},
    AllTrue[Tuples[{Select[VertexList[g], 2 <= GraphDistance[g, 25, #] <= 3 &][[{1, 4, 7, 10}]], {1}}],
      Function[{pt},
        With[{circle = InfraCircle[g, 25, pt[[1]], "Tolerance" -> pt[[2]]]},
          cycleSets[VertexList /@ Normal[circle]] === cycleSets[bruteCircles[g, 25, pt[[1]], pt[[2]]]] &&
          circle["Multiplicity"] == Length @ Normal[circle]]]]],
  True,
  TestID -> "InfraCircle-equals-brute-force-on-the-grid"
]

(* every realisation is a simple cycle through p inside the band, separating c *)
VerificationTest[
  With[{g = GridGraph[{9, 9}]}, {c = 41}, {p = First @ Select[VertexList[g], GraphDistance[g, c, #] == 3 &]},
    {circle = InfraCircle[g, c, p, "Tolerance" -> 1]},
    AllTrue[Normal[circle],
      Function[{cyc}, With[{vs = VertexList[cyc]},
        DuplicateFreeQ[vs] && MemberQ[vs, p] && AllTrue[vs, 2 <= GraphDistance[g, c, #] <= 4 &] &&
        AllTrue[EdgeList[cyc], EdgeQ[g, UndirectedEdge @@ #] &] && EdgeCount[cyc] == VertexCount[cyc] &&
        ! MemberQ[VertexComponent[VertexDelete[g, vs], c], First @ Select[VertexList[g], GraphDistance[g, c, #] == 5 &]]]]]],
  True,
  TestID -> "InfraCircle-realisations-are-separating-band-cycles"
]

(* the edge density counts the closing edges too: it sums to circumference times multiplicity *)
VerificationTest[
  With[{g = GridGraph[{9, 9}]}, {c = 41}, {p = First @ Select[VertexList[g], GraphDistance[g, c, #] == 3 &]},
    {circle = InfraCircle[g, c, p, "Tolerance" -> 1]},
    Total[circle["EdgeDensity"]] == circle["Length"] circle["Multiplicity"] &&
    circle["InfraDensity"] === KeySort @ Counts @ Catenate[VertexList /@ Normal[circle]]],
  True,
  TestID -> "InfraCircle-densities-by-DP-equal-the-enumeration"
]

(* Part streams: the first circle, a span, the last *)
VerificationTest[
  With[{g = GridGraph[{9, 9}]}, {c = 41}, {p = First @ Select[VertexList[g], GraphDistance[g, c, #] == 3 &]},
    {circle = InfraCircle[g, c, p, "Tolerance" -> 1]}, {all = Normal[circle]},
    circle[[1]] === First[all] && circle[[2 ;; 4]] === all[[2 ;; 4]] && circle[[-1]] === Last[all]],
  True,
  TestID -> "InfraCircle-Part-streams-the-family"
]

(* through the centre itself there is nothing to separate *)
VerificationTest[
  InfraCircle[GridGraph[{5, 5}], 13, 13]["Multiplicity"],
  0,
  TestID -> "InfraCircle-through-the-centre-is-empty"
]

(* the scene token stays inert *)
VerificationTest[
  InfraCircle[13, 2],
  InfraCircle[13, 2],
  TestID -> "InfraCircle-token-without-graph-stays-inert"
]

(* ===== InfraArc ===== *)

(* the arc is the geodesic interval inside the band: antipodes on the hexagon give the two half-rings *)
VerificationTest[
  With[{g = TessellationNeighborhoodGraph[{3, 6}, 5]}, {c = First @ GraphCenter[g]},
    {ring = Select[VertexList[g], GraphDistance[g, c, #] == 2 &]},
    {shell = Subgraph[g, ring]},
    {p = First @ ring}, {q = First @ Select[ring, GraphDistance[shell, First @ ring, #] == 6 &]},
    {arc = InfraArc[g, c, p, q]},
    {arc["Multiplicity"], arc["Length"], Sort[VertexList /@ Normal[arc]] === Sort[FindPath[shell, p, q, {6}, All]],
     Sort[VertexList[arc]] === Sort[ring]}],
  {2, 6, True, True},
  TestID -> "InfraArc-antipodes-give-both-half-rings"
]

(* a short arc is one path; the closing arc back to p is a circle's complement *)
VerificationTest[
  With[{g = TessellationNeighborhoodGraph[{3, 6}, 5]}, {c = First @ GraphCenter[g]},
    {ring = Select[VertexList[g], GraphDistance[g, c, #] == 2 &]},
    {shell = Subgraph[g, ring]},
    {p = First @ ring}, {q = First @ Select[ring, GraphDistance[shell, First @ ring, #] == 2 &]},
    {arc = InfraArc[g, c, p, q]},
    {arc["Multiplicity"], arc["Length"], InfraSegmentQ[shell, arc], First[arc] === arc[[1]]}],
  {1, 2, True, True},
  TestID -> "InfraArc-short-arc"
]

(* a point off the band gives the empty arc; the tolerance admits it *)
VerificationTest[
  With[{g = GridGraph[{7, 7}]}, {c = 25},
    {p = First @ Select[VertexList[g], GraphDistance[g, c, #] == 2 &], q = First @ Select[VertexList[g], GraphDistance[g, c, #] == 3 &]},
    {InfraArc[g, c, p, q]["Multiplicity"] == 0, InfraArc[g, c, p, q, "Tolerance" -> {0, 1}]["Multiplicity"] > 0,
     InfraArc[g, c, p, q, "Tolerance" -> {0, 1}]["Band"] === {2, 3}}],
  {True, True, True},
  TestID -> "InfraArc-band-membership"
]

EndTestSection[]
