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
     Sort @ InfraVertexList[g, arc, All] === Sort @ FindPath[shell, p, q, {6}, All],
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
     InfraSegmentQ[shell, InfraVertexList[g, arc]],
     InfraVertexList[g, arc] === First @ InfraVertexList[g, arc, All]}],
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
    {members = InfraVertexList[g, arc, All]},
    {Sort @ members === Sort @ FindPath[band, p, q, {GraphDistance[band, p, q]}, All],
     Sort @ members === Sort @ FindInfraArc[g, c, {p, q}, All, "RadiusDelta" -> 2],
     Union[Length /@ members] === {InfraMeasurement[g, arc, "Length"] + 1},
     Length @ members === InfraMeasurement[g, arc, "Cardinality"]}],
  {True, True, True, True},
  TestID -> "InfraArc-members-are-the-band-geodesics"
]

(* the density counts the members through each vertex *)
VerificationTest[
  With[{g = GridGraph[{9, 9}], c = 41},
    {arc = InfraArc[c, {25, 57}, "RadiusDelta" -> 2]},
    {members = InfraVertexList[g, arc, All]},
    InfraMeasurement[g, arc, "VertexDensity"] === KeySort @ Counts @ Catenate @ members],
  True,
  TestID -> "InfraArc-density-counts-the-members"
]

(* the count contract: one member count-less, a List under n, UpTo and All *)
VerificationTest[
  With[{g = GridGraph[{9, 9}], c = 41},
    {arc = InfraArc[c, {25, 57}, "RadiusDelta" -> 2]},
    {n = InfraMeasurement[g, arc, "Cardinality"]},
    {MatchQ[InfraVertexList[g, arc], {__Integer}],
     Length @ InfraVertexList[g, arc, 2],
     Length @ InfraVertexList[g, arc, UpTo[n + 5]] === n,
     InfraVertexList[g, arc, n + 5]}],
  {True, 2, True, $Failed},
  TestID -> "InfraArc-count-contract"
]

(* every member is a member, and a path off the band is not *)
VerificationTest[
  With[{g = GridGraph[{9, 9}], c = 41},
    {arc = InfraArc[c, {25, 57}, "RadiusDelta" -> 2]},
    {AllTrue[InfraVertexList[g, arc, All], InfraMemberQ[g, arc, #] &],
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
     FindInfraArc[g, c, {p, q}, All]}],
  {0, True, {}},
  TestID -> "InfraArc-a-point-off-the-band"
]

(* the arc stays inside the band: no member leaves it *)
VerificationTest[
  With[{g = GridGraph[{9, 9}], c = 41},
    {members = InfraVertexList[g, InfraArc[c, {25, 57}, "RadiusDelta" -> 2], All]},
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
     Length @ InfraVertexList[g, poly, All] === InfraMeasurement[g, poly, "Cardinality"]}],
  {True, True, True, True},
  TestID -> "InfraArc-polyline-pieces-are-factors"
]

(* the density of a polyline is the sum of the piece densities, the knot counted in both *)
VerificationTest[
  With[{g = GridGraph[{9, 9}], c = 41},
    {poly = InfraArc[c, {25, 57, 21}, "RadiusDelta" -> 2]},
    {a = InfraArc[c, {25, 57}, "RadiusDelta" -> 2], b = InfraArc[c, {57, 21}, "RadiusDelta" -> 2]},
    InfraMeasurement[g, poly, "VertexDensity"] ===
      KeySort @ Merge[{InfraMeasurement[g, a, "VertexDensity"],
                       InfraMeasurement[g, b, "VertexDensity"]}, Total]],
  True,
  TestID -> "InfraArc-polyline-density-is-the-sum"
]

(* a polyline member passes through the knot, is a member, and the search finds the same family *)
VerificationTest[
  With[{g = GridGraph[{9, 9}], c = 41},
    {poly = InfraArc[c, {25, 57, 21}, "RadiusDelta" -> 1]},
    {members = InfraVertexList[g, poly, All]},
    {AllTrue[members, MemberQ[#, 57] &],
     AllTrue[members, InfraMemberQ[g, poly, #] &],
     Sort @ members === Sort @ FindInfraArc[g, c, {25, 57, 21}, All, "RadiusDelta" -> 1],
     Union[Length /@ members] === {InfraMeasurement[g, poly, "Length"] + 1}}],
  {True, True, True, True},
  TestID -> "InfraArc-polyline-members"
]

(* ===== the inert head ===== *)

VerificationTest[
  {InfraArc[1, {2, 3}], InfraArc[1, {2, 3, 4}, "RadiusDelta" -> 1]},
  {InfraArc[1, {2, 3}], InfraArc[1, {2, 3, 4}, "RadiusDelta" -> 1]},
  TestID -> "InfraArc-without-a-graph-stays-inert"
]

(* the arc needs (W) and the points on a common circle, and certifies neither *)
VerificationTest[
  InfraMeasurement[GridGraph[{5, 5}], InfraArc[13, {3, 11}], "Faithful"],
  Undetermined,
  TestID -> "InfraArc-faithfulness-is-undetermined"
]

EndTestSection[]
