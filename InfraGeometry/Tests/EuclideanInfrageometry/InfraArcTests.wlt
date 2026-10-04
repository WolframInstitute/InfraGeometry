BeginTestSection["InfraArc"]

(* the band graph of the circle around c through p, widened by delta *)
bandGraph[g_Graph, c_, p_, delta_] :=
  Module[{dist = AssociationThread[VertexList@g, GraphDistance[g, c]]},
    Subgraph[g, Select[VertexList@g,
      Max[1, dist[p] - First@delta] <= dist[#] <= dist[p] + Last@delta &]]]

(* ===== the hexagonal ring: antipodes give both half-rings, a near pair one short arc ===== *)

(* the minor arcs of the ring of radius 2 are the geodesics of the ring, and there are two of them
   between antipodes *)
VerificationTest[
  With[{g = TessellationNeighborhoodGraph[{3, 6}, 5]}, {c = First @ GraphCenter[g]},
    {ring = Select[VertexList[g], GraphDistance[g, c, #] == 2 &]},
    {shell = Subgraph[g, ring]},
    {p = First @ ring},
    {q = First @ Select[ring, GraphDistance[shell, First @ ring, #] == 6 &]},
    {arc = InfraArc[c, {p, q}]},
    {InfraMeasurement[g, arc, "Cardinality"],
     InfraMeasurement[g, arc, "Length"],
     Sort @ FindInfraRepresentative[g, arc, All] === Sort @ FindPath[shell, p, q, {6}, All],
     Sort @ Keys @ InfraMeasurement[g, arc, "VertexDensity"] === Sort @ ring}],
  {2, 6, True, True},
  TestID -> "InfraArc-antipodes-give-both-half-rings"
]

(* a short arc is one geodesic of the ring, and it is a geodesic of the ring as a graph *)
VerificationTest[
  With[{g = TessellationNeighborhoodGraph[{3, 6}, 5]}, {c = First @ GraphCenter[g]},
    {ring = Select[VertexList[g], GraphDistance[g, c, #] == 2 &]},
    {shell = Subgraph[g, ring]},
    {p = First @ ring},
    {q = First @ Select[ring, GraphDistance[shell, First @ ring, #] == 2 &]},
    {arc = InfraArc[c, {p, q}]},
    {InfraMeasurement[g, arc, "Cardinality"],
     InfraMeasurement[g, arc, "Length"],
     InfraSegmentQ[shell, FindInfraRepresentative[g, arc]],
     FindInfraRepresentative[g, arc] === First @ FindInfraRepresentative[g, arc, All]}],
  {1, 2, True, True},
  TestID -> "InfraArc-short-arc"
]

(* ===== the members are the band geodesics, and the searches agree ===== *)

(* design Thm. arc: every member is a geodesic of the band graph, so they all have length d_A(p, q)
   and the search finds exactly the same family *)
VerificationTest[
  With[{g = GridGraph[{9, 9}], c = 41, delta = {0, 2}},
    {p = 25, q = 57},
    {arc = InfraArc[c, {p, q}, "RadiusDelta" -> 2]},
    {band = bandGraph[g, c, p, delta]},
    {members = FindInfraRepresentative[g, arc, All]},
    {Sort @ members === Sort @ FindPath[band, p, q, {GraphDistance[band, p, q]}, All],
     Union[Length /@ members] === {InfraMeasurement[g, arc, "Length"] + 1},
     Length @ members === InfraMeasurement[g, arc, "Cardinality"]}],
  {True, True, True},
  TestID -> "InfraArc-members-are-the-band-geodesics"
]

(* the density counts the members through each vertex *)
VerificationTest[
  With[{g = GridGraph[{9, 9}], c = 41},
    {arc = InfraArc[c, {25, 57}, "RadiusDelta" -> 2]},
    {members = FindInfraRepresentative[g, arc, All]},
    InfraMeasurement[g, arc, "VertexDensity"] === KeySort @ Counts @ Catenate @ members],
  True,
  TestID -> "InfraArc-density-counts-the-members"
]

(* the count contract: one member count-less, a List under n, UpTo and All *)
VerificationTest[
  With[{g = GridGraph[{9, 9}], c = 41},
    {arc = InfraArc[c, {25, 57}, "RadiusDelta" -> 2]},
    {n = InfraMeasurement[g, arc, "Cardinality"]},
    {MatchQ[FindInfraRepresentative[g, arc], {__Integer}],
     Length @ FindInfraRepresentative[g, arc, 2],
     Length @ FindInfraRepresentative[g, arc, UpTo[n + 5]] === n,
     FindInfraRepresentative[g, arc, n + 5]}],
  {True, 2, True, { }},
  TestID -> "InfraArc-count-contract"
]

(* every member is a member, and a path off the band is not *)
VerificationTest[
  With[{g = GridGraph[{9, 9}], c = 41},
    {arc = InfraArc[c, {25, 57}, "RadiusDelta" -> 2]},
    {AllTrue[FindInfraRepresentative[g, arc, All], InfraMemberQ[g, arc, #] &],
     InfraMemberQ[g, arc, FindInfraSegment[g, 25, 57]]}],
  {True, False},
  TestID -> "InfraArc-membership"
]

(* ===== the band ===== *)

(* a point off the band is on no arc; "RadiusDelta" admits it *)
VerificationTest[
  With[{g = GridGraph[{7, 7}], c = 25},
    {p = First @ Select[VertexList[g], GraphDistance[g, c, #] == 2 &],
     q = First @ Select[VertexList[g], GraphDistance[g, c, #] == 3 &]},
    {InfraMeasurement[g, InfraArc[c, {p, q}], "Cardinality"],
     InfraMeasurement[g, InfraArc[c, {p, q}, "RadiusDelta" -> 1], "Cardinality"] > 0,
     FindInfraRepresentative[g, InfraArc[c, {p, q}], All]}],
  {0, True, {}},
  TestID -> "InfraArc-a-point-off-the-band"
]

(* the arc stays inside the band: no member leaves it *)
VerificationTest[
  With[{g = GridGraph[{9, 9}], c = 41},
    {members = FindInfraRepresentative[g, InfraArc[c, {25, 57}, "RadiusDelta" -> 2], All]},
    Union[GraphDistance[g, c, #] & /@ Catenate @ members]],
  {4, 5, 6},
  TestID -> "InfraArc-stays-in-the-band"
]

(* ===== the polyline of arcs ===== *)

(* three points of one band: the members concatenate one chain per piece, so the cardinality is the
   product of the pieces and the length their sum *)
VerificationTest[
  With[{g = GridGraph[{9, 9}], c = 41},
    {p = 25, q = 57, s = 21},
    {poly = InfraArc[c, {p, q, s}, "RadiusDelta" -> 2]},
    {a = InfraArc[c, {p, q}, "RadiusDelta" -> 2], b = InfraArc[c, {q, s}, "RadiusDelta" -> 2]},
    {MatchQ[InfraMeasurement[g, poly, "Graph"], {_Graph, _Graph}],
     InfraMeasurement[g, poly, "Cardinality"] ===
       InfraMeasurement[g, a, "Cardinality"] InfraMeasurement[g, b, "Cardinality"],
     InfraMeasurement[g, poly, "Length"] ===
       InfraMeasurement[g, a, "Length"] + InfraMeasurement[g, b, "Length"],
     Length @ FindInfraRepresentative[g, poly, All] === InfraMeasurement[g, poly, "Cardinality"]}],
  {True, True, True, True},
  TestID -> "InfraArc-polyline-pieces-are-factors"
]

(* the density of a polyline counts its members, the knot once *)
VerificationTest[
  With[{g = GridGraph[{9, 9}], c = 41},
    {poly = InfraArc[c, {25, 57, 21}, "RadiusDelta" -> 2]},
    {members = FindInfraRepresentative[g, poly, All]},
    {InfraMeasurement[g, poly, "VertexDensity"] === KeySort @ Counts @ Catenate @ members,
     InfraMeasurement[g, poly, "EdgeDensity"] ===
       KeySort @ Counts @ Catenate[DirectedEdge @@@ Partition[#, 2, 1] & /@ members]}],
  {True, True},
  TestID -> "InfraArc-polyline-density-counts-members"
]

(* a polyline member passes through the knot, is a member, and the search finds the same family *)
VerificationTest[
  With[{g = GridGraph[{9, 9}], c = 41},
    {poly = InfraArc[c, {25, 57, 21}, "RadiusDelta" -> 1]},
    {members = FindInfraRepresentative[g, poly, All], band = bandGraph[g, c, 25, {0, 1}]},
    {AllTrue[members, MemberQ[#, 57] &],
     AllTrue[members, InfraMemberQ[g, poly, #] &],
     Sort @ members === Sort @ Catenate @ Outer[Join[#1, Rest @ #2] &,
       FindPath[band, 25, 57, {GraphDistance[band, 25, 57]}, All], FindPath[band, 57, 21, {GraphDistance[band, 57, 21]}, All], 1],
     Union[Length /@ members] === {InfraMeasurement[g, poly, "Length"] + 1}}],
  {True, True, True, True},
  TestID -> "InfraArc-polyline-members"
]

(* ===== the closed arc: the circles through p ===== *)

(* the shortest cycles of the band of p, widened by delta, that pass through p and separate c from beyond the band, by brute force *)
bruteClosedArcs[g_Graph, c_, p_, delta_] :=
  Module[{dist, band, local, bandGraph, sepQ, found = {}},
    dist = AssociationThread[VertexList@g, GraphDistance[g, c]];
    band = dist[p] + {-First@delta, Last@delta};
    local = Subgraph[g, Select[VertexList@g, dist[#] <= Last@band + 1 &]];
    bandGraph = Subgraph[local, Select[VertexList@local, Max[1, First@band] <= dist[#] <= Last@band &]];
    sepQ = Function[cyc, AllTrue[VertexComponent[VertexDelete[local, cyc], c], dist[#] <= Last@band &]];
    Do[With[{cycles = Select[First /@ # & /@ FindCycle[bandGraph, {k}, All], MemberQ[#, p] && sepQ[#] &]},
      If[cycles =!= {}, found = cycles; Break[]]], {k, 3, VertexCount@bandGraph}];
    found]

cycleSets[cycles_] := Sort[Sort /@ cycles]

(* the chains of the closed arc's graph, source to sink, read without the representative finder (whose closed-arc clause is the sweep); the
   sink is a copy {x, 3/2} of the source, which is not a vertex of g and is dropped *)
closedArcChains[g_Graph, arc_] :=
  Catenate[Function[dag,
      Select[#, VertexQ[g, #] &] & /@ Catenate[FindPath[dag, #1, #2, Infinity, All] & @@@
        Tuples[{Pick[VertexList@dag, VertexInDegree@dag, 0], Pick[VertexList@dag, VertexOutDegree@dag, 0]}]]] /@
    InfraMeasurement[g, arc, "Graph"]]

(* the hexagonal ring of radius 2 is the one circle through p, and the sweep finds the same cycle *)
VerificationTest[
  With[{g = TessellationNeighborhoodGraph[{3, 6}, 5]}, {c = First @ GraphCenter[g]},
    {p = First @ Select[VertexList[g], GraphDistance[g, c, #] == 2 &]},
    {arc = InfraArc[c, {p, p}]}, {swept = FindInfraRepresentative[g, arc, All]},
    {InfraMeasurement[g, arc, "Cardinality"], InfraMeasurement[g, arc, "Length"],
     InfraMeasurement[g, arc, "Faithful"],
     MemberQ[FindInfraRepresentative[g, arc], p],
     AllTrue[FindInfraRepresentative[g, arc], GraphDistance[g, c, #] == 2 &],
     cycleSets[closedArcChains[g, arc]] === cycleSets[swept] && AllTrue[swept, InfraMemberQ[g, arc, #] &]}],
  {1, 12, Undetermined, True, True, True},
  TestID -> "InfraArc-closed-triangular-hexagonal-ring"
]

(* the level set of the square grid is edgeless, so the closed arc needs the band *)
VerificationTest[
  With[{g = GridGraph[{7, 7}]}, {p = First @ Select[VertexList[g], GraphDistance[g, 25, #] == 3 &]},
    {InfraMeasurement[g, InfraArc[25, {p, p}], "Cardinality"],
     InfraMeasurement[g, InfraArc[25, {p, p}, "RadiusDelta" -> 1], "Cardinality"],
     InfraMeasurement[g, InfraArc[25, {p, p}, "RadiusDelta" -> 1], "Length"]}],
  {0, 1, 24},
  TestID -> "InfraArc-closed-grid-needs-the-band"
]

VerificationTest[
  With[{g = GridGraph[{7, 7}]},
    AllTrue[
      Tuples[{Select[VertexList[g], 2 <= GraphDistance[g, 25, #] <= 3 &][[{1, 4, 7, 10}]], {1, 2}}],
      Apply[{p, d} |-> With[{arc = InfraArc[25, {p, p}, "RadiusDelta" -> d]},
        cycleSets[closedArcChains[g, arc]] === cycleSets[bruteClosedArcs[g, 25, p, {0, d}]] &&
        InfraMeasurement[g, arc, "Cardinality"] == Length @ closedArcChains[g, arc]]]]],
  True,
  TestID -> "InfraArc-closed-equals-brute-force-on-the-grid"
]

(* on the band (2, 4) of the 11 x 11 grid the closed arc through p is the circle's members through p, by count and by density *)
VerificationTest[
  With[{g = GridGraph[{11, 11}]}, {cir = InfraCircle[61, {2, 4}]},
    {members = closedArcChains[g, cir]},
    AllTrue[Select[VertexList[g], GraphDistance[g, 61, #] == 2 &],
      p |-> With[{arc = InfraArc[61, {p, p}, "RadiusDelta" -> 2]}, {through = Select[members, MemberQ[#, p] &]},
        InfraMeasurement[g, arc, "Cardinality"] == Length[through] > 0 &&
        InfraMeasurement[g, arc, "VertexDensity"] === KeySort @ Counts @ Catenate[through] &&
        InfraMeasurement[g, arc, "Length"] == 16 &&
        cycleSets[FindInfraRepresentative[g, arc, All]] === cycleSets[through]]]],
  True,
  TestID -> "InfraArc-closed-is-the-circle-through-p"
]

(* the closing arrow is counted once per member, and every member is a member *)
VerificationTest[
  With[{g = GridGraph[{11, 11}]}, {arc = InfraArc[61, {39, 39}, "RadiusDelta" -> 2]},
    {members = closedArcChains[g, arc]},
    {InfraMeasurement[g, arc, "EdgeDensity"] ===
       KeySort @ Counts @ Catenate[Apply[DirectedEdge, Partition[#, 2, 1, 1], {1}] & /@ members],
     AllTrue[FindInfraRepresentative[g, arc, All], InfraMemberQ[g, arc, #] &],
     InfraMemberQ[g, arc, Reverse @ RotateLeft[First @ members, 3]],
     InfraMemberQ[g, arc, FindInfraSegment[g, 39, 83]]}],
  {True, True, True, False},
  TestID -> "InfraArc-closed-edge-density-and-membership"
]

(* {p} is shorthand for {p, p} *)
VerificationTest[
  With[{g = GridGraph[{11, 11}]},
    {a = InfraArc[61, {39}, "RadiusDelta" -> 2], b = InfraArc[61, {39, 39}, "RadiusDelta" -> 2]},
    {InfraMeasurement[g, a, {"Cardinality", "Length", "VertexDensity", "EdgeDensity"}] ===
       InfraMeasurement[g, b, {"Cardinality", "Length", "VertexDensity", "EdgeDensity"}],
     FindInfraRepresentative[g, a, All] === FindInfraRepresentative[g, b, All],
     cycleSets[FindInfraRepresentative[g, a, All]] === cycleSets[bruteClosedArcs[g, 61, 39, {0, 2}]]}],
  {True, True, True},
  TestID -> "InfraArc-closed-shorthand"
]

(* the first point repeated last closes the list: the circles through all its points, in any order *)
VerificationTest[
  With[{g = GridGraph[{11, 11}]}, {cir = InfraCircle[61, {2, 4}]},
    {members = closedArcChains[g, cir]},
    {pairs = Select[
       Tuples[{Select[VertexList[g], GraphDistance[g, 61, #] == 2 &], Select[VertexList[g], 2 <= GraphDistance[g, 61, #] <= 4 &]}],
       pair |-> First[pair] =!= Last[pair] && AnyTrue[members, SubsetQ[#, pair] &]][[;; ;; 9]]},
    AllTrue[pairs,
      Apply[{p, q} |-> With[{arc = InfraArc[61, {p, q, p}, "RadiusDelta" -> 2]}, {through = Select[members, SubsetQ[#, {p, q}] &]},
        InfraMeasurement[g, arc, "Cardinality"] == Length[through] &&
        InfraMeasurement[g, arc, "VertexDensity"] === KeySort @ Counts @ Catenate[through] &&
        cycleSets[FindInfraRepresentative[g, arc, All]] === cycleSets[through]]]]],
  True,
  TestID -> "InfraArc-closed-through-two-points"
]

VerificationTest[
  With[{g = GridGraph[{11, 11}]}, {cir = InfraCircle[61, {2, 4}]},
    {through = Select[closedArcChains[g, cir], SubsetQ[#, {39, 37, 81}] &]},
    {a = InfraArc[61, {39, 37, 81, 39}, "RadiusDelta" -> 2], b = InfraArc[61, {39, 81, 37, 39}, "RadiusDelta" -> 2]},
    {0 < Length[through] < 16, InfraMeasurement[g, a, "Cardinality"] == InfraMeasurement[g, b, "Cardinality"] == Length[through],
     InfraMeasurement[g, a, "EdgeDensity"] ===
       KeySort @ Counts @ Catenate[Apply[DirectedEdge, Partition[#, 2, 1, 1], {1}] & /@ closedArcChains[g, a]],
     InfraMeasurement[g, InfraArc[61, {39, 61, 39}, "RadiusDelta" -> 2], "Cardinality"]}],
  {True, True, True, 0},
  TestID -> "InfraArc-closed-through-three-points"
]

(* on a circle the graph is the one atom at p of the unrolled band, from p to its copy {p, 3/2}; the closed arc through a second point cuts it
   down and keeps both ends *)
VerificationTest[
  With[{g = GridGraph[{11, 11}]},
    {one = InfraMeasurement[g, InfraArc[61, {39, 39}, "RadiusDelta" -> 2], "Graph"],
     two = InfraMeasurement[g, InfraArc[61, {39, 37, 39}, "RadiusDelta" -> 2], "Graph"]},
    {Length @ one, Length @ two,
     {Pick[VertexList @ #, VertexInDegree @ #, 0], Pick[VertexList @ #, VertexOutDegree @ #, 0]} & /@ Join[one, two],
     MemberQ[VertexList @ First @ two, 37], VertexCount @ First @ two < VertexCount @ First @ one}],
  {1, 1, {{{39}, {{39, 3/2}}}, {{39}, {{39, 3/2}}}}, True, True},
  TestID -> "InfraArc-closed-on-a-circle-is-one-atom"
]

(* off a circle the shortest closed walks of winding one through p run out to a shorter circle and back, so the atom is not the closed arc: on
   the band (2, 5) of the 13 x 13 grid the circles have length 16 and pass through 58, not through 46, whose closed arc has 84 cycles of length
   18; the graph there is the necklaces, and they agree with the sweep *)
VerificationTest[
  With[{g = GridGraph[{13, 13}]},
    {off = InfraArc[85, {46, 46}, "RadiusDelta" -> {1, 2}], on = InfraArc[85, {58, 58}, "RadiusDelta" -> {1, 2}]},
    {Length @ InfraMeasurement[g, on, "Graph"], InfraMeasurement[g, on, {"Cardinality", "Length"}],
     Length @ InfraMeasurement[g, off, "Graph"] > 1, InfraMeasurement[g, off, {"Cardinality", "Length"}],
     AllTrue[InfraMeasurement[g, off, "Graph"], AcyclicGraphQ],
     cycleSets[closedArcChains[g, off]] === cycleSets[FindInfraRepresentative[g, off, All]]}],
  {1, <|"Cardinality" -> 16, "Length" -> 16|>, True, <|"Cardinality" -> 84, "Length" -> 18|>, True, True},
  TestID -> "InfraArc-closed-off-a-circle-reads-the-necklaces"
]

(* on the triangular ring and on a Delaunay mesh the closed arc at a point of the circle is one atom from p, and its chains and its density
   are the brute force's *)
VerificationTest[
  {With[{g = TessellationNeighborhoodGraph[{3, 6}, 5]}, {c = First @ GraphCenter[g]},
     AllTrue[Select[VertexList[g], GraphDistance[g, c, #] == 2 &][[;; 4]],
       p |-> With[{arc = InfraArc[c, {p, p}]}, {dags = InfraMeasurement[g, arc, "Graph"]},
         Length @ dags == 1 && Pick[VertexList @ First @ dags, VertexInDegree @ First @ dags, 0] === {p} &&
         cycleSets[closedArcChains[g, arc]] === cycleSets[bruteClosedArcs[g, c, p, {0, 0}]] &&
         InfraMeasurement[g, arc, "VertexDensity"] === KeySort @ Counts @ Catenate @ bruteClosedArcs[g, c, p, {0, 0}]]]],
   SeedRandom[3]; With[{g = IndexGraph @ MeshConnectivityGraph[DelaunayMesh[RandomReal[1, {150, 2}]], 0]}, {c = First @ GraphCenter[g]},
     AllTrue[{15, 17, 36, 70},
       p |-> With[{arc = InfraArc[c, {p, p}, "RadiusDelta" -> 1]}, {dags = InfraMeasurement[g, arc, "Graph"]},
         Length @ dags == 1 && Pick[VertexList @ First @ dags, VertexInDegree @ First @ dags, 0] === {p} &&
         InfraMeasurement[g, arc, "Cardinality"] == 4 &&
         cycleSets[closedArcChains[g, arc]] === cycleSets[bruteClosedArcs[g, c, p, {0, 1}]] &&
         InfraMeasurement[g, arc, "VertexDensity"] === KeySort @ Counts @ Catenate @ bruteClosedArcs[g, c, p, {0, 1}]]]]},
  {True, True},
  TestID -> "InfraArc-closed-atom-equals-brute-force"
]

(* the octagon: (W) holds and (T) fails, so the seam through a loses a circle *)
octagonGraph[] := Graph[{
  "a" <-> "b", "b" <-> "c", "c" <-> "d", "d" <-> "e", "e" <-> "f", "f" <-> "g", "g" <-> "h", "h" <-> "a",
  "a" <-> "u", "u" <-> "c", "o" <-> "a", "o" <-> "e", "c" <-> "y",
  "e" <-> "j", "j" <-> "k", "k" <-> "z"}]

(* the same octagon, its two outer vertices swapped, so that the seam through e ends at the one beyond k and is (e, j, k) *)
octagonSwapped[] := Graph[{
  "a" <-> "b", "b" <-> "c", "c" <-> "d", "d" <-> "e", "e" <-> "f", "f" <-> "g", "g" <-> "h", "h" <-> "a",
  "a" <-> "u", "u" <-> "c", "o" <-> "a", "o" <-> "e", "c" <-> "z",
  "e" <-> "j", "j" <-> "k", "k" <-> "y"}]

(* the two circles of the band (1, 3) both pass through a and through e.  The seam through a is (a, b, c) and the seam through e is (e, d, c);
   both cut bands are disconnected (u hangs at a and c, {j, k} at e), so both arcs read the necklaces.  The seam through a meets the octagon in
   the two runs {a} and {c}, so its necklaces carry only the other circle, while those of the seam through e carry both (design Ex. octagon) *)
VerificationTest[
  With[{g = octagonGraph[]},
    {aa = InfraArc["o", {"a", "a"}, "RadiusDelta" -> {0, 2}], ee = InfraArc["o", {"e", "e"}, "RadiusDelta" -> {0, 2}]},
    {InfraMeasurement[g, aa, "Cardinality"], Length @ FindInfraRepresentative[g, aa, All],
     InfraMeasurement[g, ee, "Cardinality"], Length @ FindInfraRepresentative[g, ee, All],
     InfraMeasurement[g, aa, "Length"], InfraMeasurement[g, ee, "Length"]}],
  {1, 2, 2, 2, 8, 8},
  TestID -> "InfraArc-closed-octagon-loses-a-circle-off-one-seam"
]

(* on the swapped octagon the seam through e is (e, j, k), whose cut band is connected: the graph is the one atom at e, from e to its copy, and
   carries both circles, the one that meets the seam (a, b, c) twice included; the seam through a is still (a, b, c) *)
VerificationTest[
  With[{g = octagonSwapped[]},
    {aa = InfraArc["o", {"a", "a"}, "RadiusDelta" -> {0, 2}], ee = InfraArc["o", {"e", "e"}, "RadiusDelta" -> {0, 2}]},
    {dags = InfraMeasurement[g, ee, "Graph"]},
    {Length @ dags, Pick[VertexList @ First @ dags, VertexInDegree @ First @ dags, 0], Pick[VertexList @ First @ dags, VertexOutDegree @ First @ dags, 0],
     InfraMeasurement[g, ee, {"Cardinality", "Length"}],
     cycleSets[closedArcChains[g, ee]] === cycleSets[FindInfraRepresentative[g, ee, All]],
     InfraMeasurement[g, ee, "VertexDensity"] === KeySort @ Counts @ Catenate @ FindInfraRepresentative[g, ee, All],
     InfraMeasurement[g, aa, "Cardinality"]}],
  {1, {"e"}, {{"e", 3/2}}, <|"Cardinality" -> 2, "Length" -> 8|>, True, True, 1},
  TestID -> "InfraArc-closed-octagon-seam-through-e-is-one-atom"
]

VerificationTest[
  With[{g = octagonGraph[]},
    AllTrue[{InfraArc["o", {"a", "a"}, "RadiusDelta" -> {0, 2}], InfraArc["o", {"e", "e"}, "RadiusDelta" -> {0, 2}]},
      arc |-> AllTrue[closedArcChains[g, arc],
        cyc |-> Length[cyc] == 8 && AllTrue[VertexComponent[VertexDelete[g, cyc], "o"], GraphDistance[g, "o", #] <= 3 &]]]],
  True,
  TestID -> "InfraArc-closed-seam-carries-separating-cycles-only"
]

(* the centre is at radius 0, so the band is empty and there is nothing to separate *)
VerificationTest[
  {InfraMeasurement[GridGraph[{5, 5}], InfraArc[13, {13, 13}], "Cardinality"],
   InfraMeasurement[GridGraph[{5, 5}], InfraArc[13, {13}], "Cardinality"],
   FindInfraRepresentative[GridGraph[{5, 5}], InfraArc[13, {13}], All]},
  {0, 0, {}},
  TestID -> "InfraArc-closed-through-the-centre-is-empty"
]

(* ===== the inert head ===== *)

VerificationTest[
  {InfraArc[1, {2, 3}], InfraArc[1, {2, 3, 4}, "RadiusDelta" -> 1], InfraArc[1, {2, 2}], InfraArc[1, {2}], InfraArc[1, {2, 3, 2}]},
  {InfraArc[1, {2, 3}], InfraArc[1, {2, 3, 4}, "RadiusDelta" -> 1], InfraArc[1, {2, 2}], InfraArc[1, {2}], InfraArc[1, {2, 3, 2}]},
  TestID -> "InfraArc-without-a-graph-stays-inert"
]

(* the arc needs (W) and the points on a common circle, and certifies neither *)
VerificationTest[
  InfraMeasurement[GridGraph[{5, 5}], InfraArc[13, {3, 11}], "Faithful"],
  Undetermined,
  TestID -> "InfraArc-faithfulness-is-undetermined"
]

(* an inner repeated point is the trivial walk: {a, b, b, c} reads as {a, b, c} in every measure and in the search *)
VerificationTest[
  With[{g = GridGraph[{9, 9}], c = 41},
    {a = InfraArc[c, {25, 57, 57, 21}, "RadiusDelta" -> 2], b = InfraArc[c, {25, 57, 21}, "RadiusDelta" -> 2]},
    {props = {"Cardinality", "Length", "VertexDensity", "EdgeDensity"}},
    {InfraMeasurement[g, a, props] === InfraMeasurement[g, b, props],
     FindInfraRepresentative[g, a, All] === FindInfraRepresentative[g, b, All],
     InfraMeasurement[g, a, {"Cardinality", "Length"}],
     AllTrue[FindInfraRepresentative[g, b, All], InfraMemberQ[g, a, #] &],
     InfraMeasurement[g, InfraArc[c, {25, 25, 57}, "RadiusDelta" -> 2], props] === InfraMeasurement[g, InfraArc[c, {25, 57}, "RadiusDelta" -> 2], props]}],
  {True, True, <|"Cardinality" -> 256, "Length" -> 24|>, True, True},
  TestID -> "InfraArc-polyline-collapses-consecutive-repeats"
]

(* the scene's "Select" reads the open arc by its endpoints and the closed arc as a circle of the mean radius of its band *)
VerificationTest[
  With[{d = WolframInstitute`InfraGeometry`PackageScope`dispatchConstruction},
    {g = GridGraph[{9, 9}], h = GridGraph[{11, 11}]},
    {open = d[g, InfraArc[41, {25, 57}, "RadiusDelta" -> 2, "Select" -> "EmbeddingClosest"]],
     closed = d[h, InfraArc[61, {39, 39}, "RadiusDelta" -> 2, "Select" -> "EmbeddingClosest"]]},
    {1 <= Length @ open < Length @ d[g, InfraArc[41, {25, 57}, "RadiusDelta" -> 2]],
     SubsetQ[d[g, InfraArc[41, {25, 57}, "RadiusDelta" -> 2]], open],
     Length @ closed, MemberQ[FindInfraRepresentative[h, InfraArc[61, {39, 39}, "RadiusDelta" -> 2], All], First @ closed],
     Length @ d[h, InfraArc[61, {39, 39}, "RadiusDelta" -> 2, "Select" -> "Central"]]}],
  {True, True, 1, True, 16},
  TestID -> "InfraArc-scene-select-embedding-closest"
]

EndTestSection[]
