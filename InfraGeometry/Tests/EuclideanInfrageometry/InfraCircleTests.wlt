BeginTestSection["InfraCircle"]

(* the shortest cycles of the band r <= d(c, v) <= s that separate c from beyond it, by brute force *)
bruteCircles[g_Graph, c_, rs_] :=
  Module[{dist, band, local, bandGraph, sepQ, found = {}},
    dist = AssociationThread[VertexList@g, GraphDistance[g, c]];
    band = Replace[rs, k : Except[_List] :> {k, k}];
    local = Subgraph[g, Select[VertexList@g, dist[#] <= Last@band + 1 &]];
    bandGraph = Subgraph[local, Select[VertexList@local, Max[1, First@band] <= dist[#] <= Last@band &]];
    sepQ = Function[cyc, AllTrue[VertexComponent[VertexDelete[local, cyc], c], dist[#] <= Last@band &]];
    Do[With[{cycles = Select[First /@ # & /@ FindCycle[bandGraph, {k}, All], sepQ]},
      If[cycles =!= {}, found = cycles; Break[]]], {k, 3, VertexCount@bandGraph}];
    found]

cycleSets[cycles_] := Sort[Sort /@ cycles]

(* the chains of the necklace graph, source to sink, read without the representative finder (whose circle clause is the sweep) *)
necklaceChains[g_Graph, cir_, k_ : Infinity] :=
  Take[Catenate[Function[dag,
      Catenate[FindPath[dag, #1, #2, Infinity, Replace[k, Infinity -> All]] & @@@
        Tuples[{Pick[VertexList@dag, VertexInDegree@dag, 0], Pick[VertexList@dag, VertexOutDegree@dag, 0]}]]] /@
    InfraMeasurement[g, cir, "Graph"]], UpTo[k]]

(* ===== the triangular patch: the hexagonal ring of radius 2 is the one circle ===== *)

VerificationTest[
  With[{g = TessellationNeighborhoodGraph[{3, 6}, 5]}, {c = First @ GraphCenter[g]}, {cir = InfraCircle[c, 2]},
    {InfraMeasurement[g, cir, "Cardinality"], InfraMeasurement[g, cir, "Length"],
     InfraMeasurement[g, cir, "Faithful"],
     AllTrue[FindInfraRepresentative[g, cir], GraphDistance[g, c, #] == 2 &]}],
  {1, 12, Undetermined, True},
  TestID -> "InfraCircle-triangular-hexagonal-ring"
]

(* the search sweeps the substrate and finds the same cycle, in its own rotation and direction *)
VerificationTest[
  With[{g = TessellationNeighborhoodGraph[{3, 6}, 5]}, {c = First @ GraphCenter[g]},
    {cir = InfraCircle[c, 2]}, {swept = FindInfraRepresentative[g, cir, All]},
    cycleSets[necklaceChains[g, cir]] === cycleSets[swept] &&
    AllTrue[swept, InfraMemberQ[g, cir, #] &]],
  True,
  TestID -> "InfraCircle-search-finds-the-same-circle"
]

(* ===== the square grid: the level set is edgeless, so the circle needs a band ===== *)

VerificationTest[
  With[{g = GridGraph[{7, 7}]},
    {InfraMeasurement[g, InfraCircle[25, 3], "Cardinality"],
     InfraMeasurement[g, InfraCircle[25, {2, 3}], "Cardinality"] > 0,
     InfraMeasurement[g, InfraCircle[25, {2, 3}], "Length"]}],
  {0, True, 16},
  TestID -> "InfraCircle-grid-needs-the-band"
]

(* the family is the brute-force family, on several bands *)
VerificationTest[
  With[{g = GridGraph[{7, 7}]},
    AllTrue[{{1, 2}, {2, 3}, {1, 3}, {2, 4}},
      rs |-> With[{cir = InfraCircle[25, rs]},
        cycleSets[necklaceChains[g, cir]] === cycleSets[bruteCircles[g, 25, rs]] &&
        InfraMeasurement[g, cir, "Cardinality"] == Length @ necklaceChains[g, cir]]]],
  True,
  TestID -> "InfraCircle-equals-brute-force-on-the-grid"
]

(* ===== a band with sixteen circles: the counting DP against the enumeration ===== *)

VerificationTest[
  With[{g = GridGraph[{11, 11}]}, {cir = InfraCircle[61, {2, 4}]},
    {members = necklaceChains[g, cir]},
    {InfraMeasurement[g, cir, "Cardinality"] == Length[members],
     InfraMeasurement[g, cir, "Length"] == 16 && Union[Length /@ members] === {16},
     InfraMeasurement[g, cir, "VertexDensity"] === KeySort @ Counts @ Catenate[members],
     Total @ InfraMeasurement[g, cir, "EdgeDensity"] ==
       InfraMeasurement[g, cir, "Length"] InfraMeasurement[g, cir, "Cardinality"],
     InfraMeasurement[g, cir, "CountingMeasure"] == Length @ Union @ Catenate[members]}],
  {True, True, True, True, True},
  TestID -> "InfraCircle-densities-by-DP-equal-the-enumeration"
]

(* every member is a simple cycle of the band that separates the centre from beyond it *)
VerificationTest[
  With[{g = GridGraph[{11, 11}]}, {cir = InfraCircle[61, {2, 4}]},
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
  With[{g = GridGraph[{11, 11}]}, {cir = InfraCircle[61, {2, 4}]},
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
    {cir = InfraCircle[c, {1, 2}]}, {swept = FindInfraRepresentative[g, cir, All]},
    {necklaceChains[g, cir], Length[swept], Union[Length /@ swept],
     AllTrue[swept, AllTrue[VertexComponent[VertexDelete[g, #], c], GraphDistance[g, c, #] <= 2 &] &]}],
  {{}, 3, {8}, True},
  TestID -> "InfraCircle-hypercube-has-no-winding-functional"
]

(* the representative finder reads the circle by the sweep, so it finds the three circles the seam misses *)
VerificationTest[
  With[{g = HypercubeGraph[4]}, {c = First @ VertexList[g]}, {cir = InfraCircle[c, {1, 2}]},
    {FindInfraRepresentative[g, cir, All] === bruteCircles[g, c, {1, 2}],
     Length @ FindInfraRepresentative[g, cir, All], necklaceChains[g, cir]}],
  {True, 3, {}},
  TestID -> "FindInfraRepresentative-circle-is-the-sweep"
]

(* ===== the octagon: (W) holds and (T) fails, so the seam through a loses a circle ===== *)

octagonGraph[] := Graph[{
  "a" <-> "b", "b" <-> "c", "c" <-> "d", "d" <-> "e", "e" <-> "f", "f" <-> "g", "g" <-> "h", "h" <-> "a",
  "a" <-> "u", "u" <-> "c", "o" <-> "a", "o" <-> "e", "c" <-> "y",
  "e" <-> "j", "j" <-> "k", "k" <-> "z"}]

(* the band (1, 3) has two circles, both through a and e; a radial seam meets one of them in two runs, so
   the band's necklaces may carry only the other, but what they carry always separates (design Ex. octagon);
   the seam through a is the closed arc's, pinned in InfraArcTests *)
VerificationTest[
  With[{g = octagonGraph[]}, {cir = InfraCircle["o", {1, 3}]},
    {Length @ FindInfraRepresentative[g, cir, All],
     1 <= InfraMeasurement[g, cir, "Cardinality"] <= 2,
     AllTrue[necklaceChains[g, cir],
       cyc |-> Length[cyc] == 8 && AllTrue[VertexComponent[VertexDelete[g, cyc], "o"], GraphDistance[g, "o", #] <= 3 &]]}],
  {2, True, True},
  TestID -> "InfraCircle-seam-carries-separating-cycles-only"
]

(* ===== degenerate bands and the inert head ===== *)

(* radius 0 is the centre alone, so the band is empty and there is nothing to separate *)
VerificationTest[
  InfraMeasurement[GridGraph[{5, 5}], InfraCircle[13, 0], "Cardinality"],
  0,
  TestID -> "InfraCircle-radius-zero-is-empty"
]

(* a positional second argument is a radius, never a point: an integer vertex label is read as a radius,
   any other label leaves the head unmatched *)
VerificationTest[
  With[{g = GridGraph[{11, 11}]},
    {InfraMeasurement[g, InfraCircle[61, 4], "Cardinality"], InfraMeasurement[g, InfraCircle[61, {4, 5}], "Length"],
     Head @ FindInfraRepresentative[g, InfraCircle[61, "a"], All],
     MatchQ[InfraMeasurement[octagonGraph[], InfraCircle["o", "a"], "Graph"], _InfraMeasurement]}],
  {0, 32, FindInfraRepresentative, True},
  TestID -> "InfraCircle-second-argument-is-a-radius"
]

(* a band reaching the eccentricity has nothing beyond it, so no radial geodesic leaves it and the
   seam is empty, while separation is vacuous and the sweep still returns the shortest band cycles
   -- which is what Euclid I.1 draws on the Petersen graph *)
VerificationTest[
  With[{g = PetersenGraph[]},
    {necklaceChains[g, InfraCircle[1, 2]],
     Length @ FindInfraRepresentative[g, InfraCircle[1, 2], All],
     Union[Length /@ FindInfraRepresentative[g, InfraCircle[1, 2], All]]}],
  {{}, 1, {6}},
  TestID -> "InfraCircle-a-band-with-nothing-beyond-it"
]

VerificationTest[
  {InfraCircle[13, 2], InfraCircle[13, {2, 3}]},
  {InfraCircle[13, 2], InfraCircle[13, {2, 3}]},
  TestID -> "InfraCircle-without-a-graph-stays-inert"
]

(* a necklace is opened at its closing arrow, so it is a DAG with one source and one sink *)
VerificationTest[
  With[{g = GridGraph[{11, 11}]}, {cir = InfraCircle[61, {2, 4}]},
    {dags = InfraMeasurement[g, cir, "Graph"]},
    AllTrue[dags, dag |-> AcyclicGraphQ[dag] && DirectedGraphQ[dag] &&
      Count[VertexInDegree[dag], 0] == 1 && Count[VertexOutDegree[dag], 0] == 1]],
  True,
  TestID -> "InfraCircle-necklaces-are-opened-DAGs"
]

(* ===== the family against the search and the brute force ===== *)

VerificationTest[
  With[{g = GridGraph[{11, 11}]}, {cir = InfraCircle[61, {2, 4}]},
    {brute = cycleSets[bruteCircles[g, 61, {2, 4}]]},
    {Length[brute], cycleSets[FindInfraRepresentative[g, cir, All]] === brute,
     cycleSets[necklaceChains[g, cir]] === brute}],
  {16, True, True},
  TestID -> "InfraCircle-search-graph-and-brute-force-agree"
]

(* widening the band keeps the least circumference *)
VerificationTest[
  With[{g = GridGraph[{11, 11}]},
    InfraMeasurement[g, InfraCircle[61, #], "Length"] & /@ {{2, 3}, {2, 4}}],
  {16, 16},
  TestID -> "InfraCircle-Length-is-the-least-circumference"
]

VerificationTest[
  With[{g = GridGraph[{11, 11}]}, {cir = InfraCircle[61, {2, 4}]},
    InfraMeasurement[g, cir, "EdgeDensity"] ===
      KeySort @ Counts @ Catenate[Apply[DirectedEdge, Partition[#, 2, 1, 1], {1}] & /@ necklaceChains[g, cir]]],
  True,
  TestID -> "InfraCircle-EdgeDensity-equals-the-enumeration"
]

(* ===== a family too large to list ===== *)

(* the circle of the band (5, 9) factors into four independent quadrant arcs of 41 choices each *)
VerificationTest[
  InfraMeasurement[GridGraph[{25, 25}], InfraCircle[313, {5, 9}], "Cardinality"],
  41^4,
  TestID -> "InfraCircle-counts-an-unenumerable-family"
]

VerificationTest[
  With[{g = GridGraph[{25, 25}]}, {cycles = necklaceChains[g, InfraCircle[313, {5, 9}], 5]},
    {Length[cycles], Union[Length /@ cycles],
     AllTrue[cycles, cyc |-> DuplicateFreeQ[cyc] &&
       AllTrue[Partition[Append[cyc, First @ cyc], 2, 1], EdgeQ[g, UndirectedEdge @@ #] &]]}],
  {5, {40}, True},
  TestID -> "InfraCircle-bounded-count-is-lazy"
]

(* a cycle graph's band carries no separating cycle *)
VerificationTest[
  {bruteCircles[CycleGraph[6], 1, {1, 2}],
   FindInfraRepresentative[CycleGraph[6], InfraCircle[1, {1, 2}], All]},
  {{}, {}},
  TestID -> "FindInfraRepresentative-circle-empty-family-is-quiet"
]

EndTestSection[]
