BeginTestSection["InfraCircle"]

(* the shortest cycles of the band that separate c from beyond it, and in the point form pass through p, by brute force *)
bruteCircles[g_Graph, c_, spec_, delta_] :=
  Module[{dist, band, local, bandGraph, sepQ, found = {}},
    dist = AssociationThread[VertexList@g, GraphDistance[g, c]];
    band = If[MatchQ[spec, _Rule],
      Replace[Last@spec, k : Except[_List] :> {k, k}],
      dist[spec] + {-First@delta, Last@delta}];
    local = Subgraph[g, Select[VertexList@g, dist[#] <= Last@band + 1 &]];
    bandGraph = Subgraph[local, Select[VertexList@local, Max[1, First@band] <= dist[#] <= Last@band &]];
    sepQ = Function[cyc, AllTrue[VertexComponent[VertexDelete[local, cyc], c], dist[#] <= Last@band &]];
    Do[With[{cycles = Select[First /@ # & /@ FindCycle[bandGraph, {k}, All],
        (MatchQ[spec, _Rule] || MemberQ[#, spec]) && sepQ[#] &]},
      If[cycles =!= {}, found = cycles; Break[]]], {k, 3, VertexCount@bandGraph}];
    found]

cycleSets[cycles_] := Sort[Sort /@ cycles]

(* the chains of the necklace graph, source to sink, read without the representative finder (whose circle clause is the sweep) *)
necklaceChains[g_Graph, cir_, k_ : Infinity] :=
  Take[Catenate[Function[dag,
      Catenate[FindPath[dag, #1, #2, Infinity, Replace[k, Infinity -> All]] & @@@
        Tuples[{Pick[VertexList@dag, VertexInDegree@dag, 0], Pick[VertexList@dag, VertexOutDegree@dag, 0]}]]] /@
    InfraMeasurement[g, cir, "Graph"]], UpTo[k]]

(* ===== the triangular patch: the hexagonal ring of radius 2 is the one circle through p ===== *)

VerificationTest[
  With[{g = TessellationNeighborhoodGraph[{3, 6}, 5]}, {c = First @ GraphCenter[g]},
    {p = First @ Select[VertexList[g], GraphDistance[g, c, #] == 2 &]},
    {cir = InfraCircle[c, p]},
    {InfraMeasurement[g, cir, "Cardinality"], InfraMeasurement[g, cir, "Length"],
     InfraMeasurement[g, cir, "Faithful"],
     MemberQ[FindInfraRepresentative[g, cir], p],
     AllTrue[FindInfraRepresentative[g, cir], GraphDistance[g, c, #] == 2 &]}],
  {1, 12, Undetermined, True, True},
  TestID -> "InfraCircle-triangular-hexagonal-ring"
]

(* the search sweeps the substrate and finds the same cycle, in its own rotation and direction *)
VerificationTest[
  With[{g = TessellationNeighborhoodGraph[{3, 6}, 5]}, {c = First @ GraphCenter[g]},
    {p = First @ Select[VertexList[g], GraphDistance[g, c, #] == 2 &]},
    {cir = InfraCircle[c, p]}, {swept = FindInfraCircle[g, c, p, All]},
    cycleSets[necklaceChains[g, cir]] === cycleSets[swept] &&
    AllTrue[swept, InfraMemberQ[g, cir, #] &]],
  True,
  TestID -> "InfraCircle-search-finds-the-same-circle"
]

(* ===== the square grid: the level set is edgeless, so the band is the caller's line ===== *)

VerificationTest[
  With[{g = GridGraph[{7, 7}]}, {p = First @ Select[VertexList[g], GraphDistance[g, 25, #] == 3 &]},
    {InfraMeasurement[g, InfraCircle[25, p], "Cardinality"],
     InfraMeasurement[g, InfraCircle[25, p, "RadiusDelta" -> 1], "Cardinality"],
     InfraMeasurement[g, InfraCircle[25, p, "RadiusDelta" -> 1], "Length"]}],
  {0, 1, 24},
  TestID -> "InfraCircle-grid-needs-the-band"
]

(* the family through p is the brute-force family, on several points and widths *)
VerificationTest[
  With[{g = GridGraph[{7, 7}]},
    AllTrue[
      Tuples[{Select[VertexList[g], 2 <= GraphDistance[g, 25, #] <= 3 &][[{1, 4, 7, 10}]], {1, 2}}],
      Apply[{p, d} |-> With[{cir = InfraCircle[25, p, "RadiusDelta" -> d]},
        cycleSets[necklaceChains[g, cir]] === cycleSets[bruteCircles[g, 25, p, {0, d}]] &&
        InfraMeasurement[g, cir, "Cardinality"] == Length @ necklaceChains[g, cir]]]]],
  True,
  TestID -> "InfraCircle-equals-brute-force-on-the-grid"
]

(* ===== a band with sixteen circles: the counting DP against the enumeration ===== *)

VerificationTest[
  With[{g = GridGraph[{11, 11}]}, {cir = InfraCircle[61, "Radius" -> {2, 4}]},
    {members = necklaceChains[g, cir]},
    {InfraMeasurement[g, cir, "Cardinality"] == Length[members],
     InfraMeasurement[g, cir, "Length"] == 16 && Union[Length /@ members] === {16},
     InfraMeasurement[g, cir, "VertexDensity"] === KeySort @ Counts @ Catenate[members],
     Total @ InfraMeasurement[g, cir, "EdgeDensity"] ==
       InfraMeasurement[g, cir, "Length"] InfraMeasurement[g, cir, "Cardinality"],
     InfraMeasurement[g, cir, "Volume"] == Length @ Union @ Catenate[members]}],
  {True, True, True, True, True},
  TestID -> "InfraCircle-densities-by-DP-equal-the-enumeration"
]

(* every member is a simple cycle of the band that separates the centre from beyond it *)
VerificationTest[
  With[{g = GridGraph[{11, 11}]}, {cir = InfraCircle[61, "Radius" -> {2, 4}]},
    AllTrue[necklaceChains[g, cir],
      cyc |-> DuplicateFreeQ[cyc] &&
        AllTrue[Partition[Append[cyc, First @ cyc], 2, 1], EdgeQ[g, UndirectedEdge @@ #] &] &&
        AllTrue[cyc, 2 <= GraphDistance[g, 61, #] <= 4 &] &&
        AllTrue[VertexComponent[VertexDelete[g, cyc], 61], GraphDistance[g, 61, #] <= 4 &] &&
        InfraMemberQ[g, cir, cyc]]],
  True,
  TestID -> "InfraCircle-members-are-separating-band-cycles"
]

(* the count fixes the mode, and a random draw is a member *)
VerificationTest[
  With[{g = GridGraph[{11, 11}]}, {cir = InfraCircle[61, "Radius" -> {2, 4}]},
    {members = FindInfraRepresentative[g, cir, All]},
    SeedRandom[7];
    {Head @ FindInfraRepresentative[g, cir], Length @ FindInfraRepresentative[g, cir, 3],
     Length @ FindInfraRepresentative[g, cir, UpTo[1000]],
     AllTrue[FindInfraRepresentative[g, cir, 20, "RandomChoice"], MemberQ[members, #] &],
     Length @ DeleteDuplicates @ FindInfraRepresentative[g, cir, 20, "RandomChoice"] > 1}],
  {List, 3, 16, True, True},
  TestID -> "InfraCircle-count-contract-and-random-draws"
]

(* ===== the hypercube: without a winding functional the seam carries nothing ===== *)

(* Q4 with the band (1, 2) has three circles, the subdivided Hamiltonian cycles of K4, and no
   winding functional; every necklace of the seam is a subdivided triangle, which does not
   separate, so the seam family is empty while the sweep finds all three (design Ex. q4) *)
VerificationTest[
  With[{g = HypercubeGraph[4]}, {c = First @ VertexList[g]},
    {cir = InfraCircle[c, "Radius" -> {1, 2}]}, {swept = FindInfraCircle[g, c, "Radius" -> {1, 2}, All]},
    {necklaceChains[g, cir], Length[swept], Union[Length /@ swept],
     AllTrue[swept, AllTrue[VertexComponent[VertexDelete[g, #], c], GraphDistance[g, c, #] <= 2 &] &]}],
  {{}, 3, {8}, True},
  TestID -> "InfraCircle-hypercube-has-no-winding-functional"
]

(* the representative finder reads the circle by the sweep, so it finds the three circles the seam misses *)
VerificationTest[
  With[{g = HypercubeGraph[4]}, {c = First @ VertexList[g]}, {cir = InfraCircle[c, "Radius" -> {1, 2}]},
    {FindInfraRepresentative[g, cir, All] === FindInfraCircle[g, c, "Radius" -> {1, 2}, All],
     Length @ FindInfraRepresentative[g, cir, All], necklaceChains[g, cir]}],
  {True, 3, {}},
  TestID -> "FindInfraRepresentative-circle-is-the-sweep"
]

(* ===== the octagon: (W) holds and (T) fails, so the seam through a loses a circle ===== *)

octagonGraph[] := Graph[{
  "a" <-> "b", "b" <-> "c", "c" <-> "d", "d" <-> "e", "e" <-> "f", "f" <-> "g", "g" <-> "h", "h" <-> "a",
  "a" <-> "u", "u" <-> "c", "o" <-> "a", "o" <-> "e", "c" <-> "y",
  "e" <-> "j", "j" <-> "k", "k" <-> "z"}]

(* the two circles of the band (1, 3) both pass through a and through e; the seam through a meets
   the octagon in the two runs {a} and {c}, so it carries only the other circle, while the seam
   through e carries both (design Ex. octagon) *)
VerificationTest[
  With[{g = octagonGraph[]},
    {ca = InfraCircle["o", "a", "RadiusDelta" -> {0, 2}],
     ce = InfraCircle["o", "e", "RadiusDelta" -> {0, 2}]},
    {InfraMeasurement[g, ca, "Cardinality"], Length @ FindInfraCircle[g, "o", "a", All, "RadiusDelta" -> {0, 2}],
     InfraMeasurement[g, ce, "Cardinality"], Length @ FindInfraCircle[g, "o", "e", All, "RadiusDelta" -> {0, 2}],
     InfraMeasurement[g, ca, "Length"], InfraMeasurement[g, ce, "Length"]}],
  {1, 2, 2, 2, 8, 8},
  TestID -> "InfraCircle-octagon-loses-a-circle-off-one-seam"
]

(* what the seam does carry always separates, whichever seam it is *)
VerificationTest[
  With[{g = octagonGraph[]},
    AllTrue[{InfraCircle["o", "a", "RadiusDelta" -> {0, 2}], InfraCircle["o", "e", "RadiusDelta" -> {0, 2}],
             InfraCircle["o", "Radius" -> {1, 3}]},
      cir |-> AllTrue[necklaceChains[g, cir],
        cyc |-> Length[cyc] == 8 &&
          AllTrue[VertexComponent[VertexDelete[g, cyc], "o"], GraphDistance[g, "o", #] <= 3 &]]]],
  True,
  TestID -> "InfraCircle-seam-carries-separating-cycles-only"
]

(* ===== degenerate bands and the inert head ===== *)

(* the centre is at radius 0, so the band is empty and there is nothing to separate *)
VerificationTest[
  InfraMeasurement[GridGraph[{5, 5}], InfraCircle[13, 13], "Cardinality"],
  0,
  TestID -> "InfraCircle-through-the-centre-is-empty"
]

(* a band reaching the eccentricity has nothing beyond it, so no radial geodesic leaves it and the
   seam is empty, while separation is vacuous and the sweep still returns the shortest band cycles
   -- which is what Euclid I.1 draws on the Petersen graph *)
VerificationTest[
  With[{g = PetersenGraph[]},
    {necklaceChains[g, InfraCircle[1, "Radius" -> 2]],
     Length @ FindInfraCircle[g, 1, "Radius" -> 2, All],
     Union[Length /@ FindInfraCircle[g, 1, "Radius" -> 2, All]]}],
  {{}, 1, {6}},
  TestID -> "InfraCircle-a-band-with-nothing-beyond-it"
]

VerificationTest[
  {InfraCircle[13, 2], InfraCircle[13, "Radius" -> {2, 3}]},
  {InfraCircle[13, 2], InfraCircle[13, "Radius" -> {2, 3}]},
  TestID -> "InfraCircle-without-a-graph-stays-inert"
]

(* a necklace is opened at its closing arrow, so it is a DAG with one source and one sink *)
VerificationTest[
  With[{g = GridGraph[{11, 11}]}, {cir = InfraCircle[61, "Radius" -> {2, 4}]},
    {dags = InfraMeasurement[g, cir, "Graph"]},
    AllTrue[dags, dag |-> AcyclicGraphQ[dag] && DirectedGraphQ[dag] &&
      Count[VertexInDegree[dag], 0] == 1 && Count[VertexOutDegree[dag], 0] == 1]],
  True,
  TestID -> "InfraCircle-necklaces-are-opened-DAGs"
]

(* ===== the family against the search and the brute force ===== *)

VerificationTest[
  With[{g = GridGraph[{11, 11}]}, {cir = InfraCircle[61, "Radius" -> {2, 4}]},
    {brute = cycleSets[bruteCircles[g, 61, "Radius" -> {2, 4}, {0, 0}]]},
    {Length[brute], cycleSets[FindInfraCircle[g, 61, "Radius" -> {2, 4}, All]] === brute,
     cycleSets[necklaceChains[g, cir]] === brute}],
  {16, True, True},
  TestID -> "InfraCircle-search-graph-and-brute-force-agree"
]

(* widening the band keeps the least circumference *)
VerificationTest[
  With[{g = GridGraph[{11, 11}]},
    InfraMeasurement[g, InfraCircle[61, "Radius" -> #], "Length"] & /@ {{2, 3}, {2, 4}}],
  {16, 16},
  TestID -> "InfraCircle-Length-is-the-least-circumference"
]

VerificationTest[
  With[{g = GridGraph[{11, 11}]}, {cir = InfraCircle[61, "Radius" -> {2, 4}]},
    InfraMeasurement[g, cir, "EdgeDensity"] ===
      KeySort @ Counts @ Catenate[Apply[DirectedEdge, Partition[#, 2, 1, 1], {1}] & /@ necklaceChains[g, cir]]],
  True,
  TestID -> "InfraCircle-EdgeDensity-equals-the-enumeration"
]

(* ===== a family too large to list ===== *)

(* the circle of the band (5, 9) factors into four independent quadrant arcs of 41 choices each *)
VerificationTest[
  InfraMeasurement[GridGraph[{25, 25}], InfraCircle[313, "Radius" -> {5, 9}], "Cardinality"],
  41^4,
  TestID -> "InfraCircle-counts-an-unenumerable-family"
]

VerificationTest[
  With[{g = GridGraph[{25, 25}]}, {cycles = necklaceChains[g, InfraCircle[313, "Radius" -> {5, 9}], 5]},
    {Length[cycles], Union[Length /@ cycles],
     AllTrue[cycles, cyc |-> DuplicateFreeQ[cyc] &&
       AllTrue[Partition[Append[cyc, First @ cyc], 2, 1], EdgeQ[g, UndirectedEdge @@ #] &]]}],
  {5, {40}, True},
  TestID -> "InfraCircle-bounded-count-is-lazy"
]

(* a cycle graph's band carries no separating cycle *)
VerificationTest[
  {FindInfraCircle[CycleGraph[6], 1, "Radius" -> {1, 2}, All],
   FindInfraRepresentative[CycleGraph[6], InfraCircle[1, "Radius" -> {1, 2}], All]},
  {{}, {}},
  TestID -> "FindInfraCircle-empty-family-is-quiet"
]

EndTestSection[]
