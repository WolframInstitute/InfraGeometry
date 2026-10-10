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

(* the chains of the circle's graph, from the source x to its sink copy {x, 3/2}, read as cycles with the copy dropped, and without the
   representative finder (whose circle clause is the sweep) *)
circleChains[g_Graph, cir_, k_ : Infinity] :=
  Take[Catenate[Function[dag,
      Most /@ Catenate[FindPath[dag, #1, #2, Infinity, Replace[k, Infinity -> All]] & @@@
        Tuples[{Pick[VertexList@dag, VertexInDegree@dag, 0], Pick[VertexList@dag, VertexOutDegree@dag, 0]}]]] /@
    InfraMeasurement[g, cir, "Graph"]], UpTo[k]]

(* the oracle: the unrolled band built with the banks read off the plane drawing, which the kernel never reads, and the chain count of each of
   its atoms of least length before projection, as {seam vertex, count} *)
drawnAtomCounts[g_Graph, c_, rs_] :=
  Module[{dist, coords, local, band, radial, seam, angle, bank, onSeam, lift, cover, atoms},
    dist = AssociationThread[VertexList@g, GraphDistance[g, c]];
    coords = AssociationThread[VertexList@g, GraphEmbedding@g];
    local = Subgraph[g, Select[VertexList@g, dist[#] <= Last@rs + 1 &]];
    band = Subgraph[local, Select[VertexList@local, First@rs <= dist[#] <= Last@rs &]];
    radial = FindShortestPath[local, c, First@SortBy[Select[VertexList@local, dist[#] > Last@rs &], dist]];
    seam = Select[radial, First@rs <= dist[#] <= Last@rs &];
    angle = {x, w} |-> ArcTan @@ (coords[w] - coords[x]);
    bank = Association@Flatten@Table[
      With[{i = First@FirstPosition[radial, x]},
        {x, w} -> If[Mod[angle[x, w] - angle[x, radial[[i + 1]]], 2 Pi] < Mod[angle[x, radial[[i - 1]]] - angle[x, radial[[i + 1]]], 2 Pi], 1, -1]],
      {x, seam}, {w, Complement[AdjacencyList[band, x], seam]}];
    onSeam = AssociationThread[seam, True];
    lift = {a, b, n} |-> Switch[{TrueQ@onSeam[a], TrueQ@onSeam[b]},
      {False, False}, {a, n} <-> {b, n},
      {True, True}, {a, n + 1/2} <-> {b, n + 1/2},
      {True, False}, {b, n + (1 + bank[{a, b}])/2} <-> {a, n + 1/2},
      {False, True}, {a, n + (1 + bank[{b, a}])/2} <-> {b, n + 1/2}];
    cover = Graph@Flatten@Table[lift[First@e, Last@e, n], {e, EdgeList@band}, {n, Range[-3, 4]}];
    atoms = Table[
      With[{cut = VertexDelete[cover, Select[VertexList@cover, MemberQ[Take[seam, i - 1], First@#] &]], s = {seam[[i]], 1/2}, t = {seam[[i]], 3/2}},
        If[VertexQ[cut, s] && VertexQ[cut, t] && GraphDistance[cut, s, t] < Infinity,
          {seam[[i]], GraphDistance[cut, s, t], Length@FindPath[cut, s, t, {GraphDistance[cut, s, t]}, All]}, Nothing]],
      {i, Length@seam}];
    {#[[1]], #[[3]]} & /@ Select[atoms, #[[2]] == Min[atoms[[All, 2]]] &]]

(* every projected atom is a DAG from its seam vertex x to the copy {x, 3/2} with as many chains as the atom of the drawn cover (measured on
   every fixture, not proved); its chains are the sweep's circles and its density the sweep's *)
unrolledReport[g_Graph, c_, rs_] :=
  With[{cir = InfraCircle[c, rs]}, {dags = InfraMeasurement[g, cir, "Graph"], swept = Replace[ cir, { token_InfraPoint :> RandomInfraPoint[ g, token, All ], token_InfraSegment :> RandomInfraSegment[ g, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraCircle :> RandomInfraCircle[ g, token, All ], token_InfraArc :> RandomInfraArc[ g, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All ], token_InfraPlane :> RandomInfraPlane[ g, token, All ], token_InfraBall :> RandomInfraBall[ g, token, All ], token_InfraShell :> RandomInfraShell[ g, token, All ], token_InfraSphere :> RandomInfraSphere[ g, token, All ], token_InfraTube :> RandomInfraTube[ g, token, All ], token_InfraCylinder :> RandomInfraCylinder[ g, token, All ], token_InfraCone :> RandomInfraCone[ g, token, All ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token, All ], token_InfraBallHull :> RandomInfraBallHull[ g, token, All ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token, All ], token_InfraQuadric :> RandomInfraQuadric[ g, token, All ], token_InfraWalk :> RandomInfraWalk[ g, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All ], token_InfraIntersection :> RandomInfraIntersection[ g, token, All ], token_InfraUnion :> RandomInfraUnion[ g, token, All ], token_InfraRay :> RandomInfraHalfLine[ g, token, All ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, All ] } ]},
    {AllTrue[dags, AcyclicGraphQ] &&
       Sort[Function[dag, With[{s = First@Pick[VertexList@dag, VertexInDegree@dag, 0], t = First@Pick[VertexList@dag, VertexOutDegree@dag, 0]},
         If[t === {s, 3/2}, {s, Length@FindPath[dag, s, t, Infinity, All]}, {}]]] /@ dags] === Sort[drawnAtomCounts[g, c, rs]],
     swept =!= {} && cycleSets[circleChains[g, cir]] === cycleSets[swept],
     InfraMeasurement[g, cir, "VertexDensity"] === KeySort@Counts@Catenate[swept]}]

(* ===== the unrolled band against the drawn cover and the sweep, one fixture each ===== *)

VerificationTest[
  unrolledReport[GridGraph[{11, 11}], 61, {2, 4}],
  {True, True, True},
  TestID -> "InfraCircle-unrolled-grid-11"
]

VerificationTest[
  unrolledReport[GridGraph[{13, 13}], 85, {2, 5}],
  {True, True, True},
  TestID -> "InfraCircle-unrolled-grid-13"
]

VerificationTest[
  With[{g = TessellationNeighborhoodGraph[{3, 6}, 5]}, unrolledReport[g, First @ GraphCenter[g], {2, 2}]],
  {True, True, True},
  TestID -> "InfraCircle-unrolled-triangular"
]

(* a vertex of the hexagonal tiling has one neighbour off the seam, so each seam vertex sees one bank, and the seam as a whole both *)
VerificationTest[
  With[{g = TessellationNeighborhoodGraph[{6, 3}, 8]}, unrolledReport[g, First @ GraphCenter[g], #] & /@ {{2, 4}, {3, 5}, {4, 6}}],
  {{True, True, True}, {True, True, True}, {True, True, True}},
  TestID -> "InfraCircle-unrolled-hexagonal"
]

VerificationTest[
  SeedRandom[3]; With[{g = IndexGraph @ MeshConnectivityGraph[DelaunayMesh[RandomReal[1, {150, 2}]], 0]},
    unrolledReport[g, First @ GraphCenter[g], {2, 3}]],
  {True, True, True},
  TestID -> "InfraCircle-unrolled-delaunay"
]

(* off the centre of the same substrate the circles split over two atoms, 30 at the first seam vertex and 10 at the second *)
VerificationTest[
  SeedRandom[3]; With[{g = IndexGraph @ MeshConnectivityGraph[DelaunayMesh[RandomReal[1, {150, 2}]], 0]},
    {unrolledReport[g, 91, {2, 3}], Sort[Last /@ drawnAtomCounts[g, 91, {2, 3}]]}],
  {{True, True, True}, {10, 30}},
  TestID -> "InfraCircle-unrolled-delaunay-two-atoms"
]

(* ===== the triangular patch: the hexagonal ring of radius 2 is the one circle ===== *)

VerificationTest[
  With[{g = TessellationNeighborhoodGraph[{3, 6}, 5]}, {c = First @ GraphCenter[g]}, {cir = InfraCircle[c, 2]},
    {InfraMeasurement[g, cir, "Cardinality"], InfraMeasurement[g, cir, "Length"],
     InfraMeasurement[g, cir, "Faithful"],
     AllTrue[Replace[ cir, { token_InfraPoint :> RandomInfraPoint[ g, token ], token_InfraSegment :> RandomInfraSegment[ g, token ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token ], token_InfraCircle :> RandomInfraCircle[ g, token ], token_InfraArc :> RandomInfraArc[ g, token ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token ], token_InfraPlane :> RandomInfraPlane[ g, token ], token_InfraBall :> RandomInfraBall[ g, token ], token_InfraShell :> RandomInfraShell[ g, token ], token_InfraSphere :> RandomInfraSphere[ g, token ], token_InfraTube :> RandomInfraTube[ g, token ], token_InfraCylinder :> RandomInfraCylinder[ g, token ], token_InfraCone :> RandomInfraCone[ g, token ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token ], token_InfraBallHull :> RandomInfraBallHull[ g, token ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token ], token_InfraQuadric :> RandomInfraQuadric[ g, token ], token_InfraWalk :> RandomInfraWalk[ g, token ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token ], token_InfraEllipse :> RandomInfraEllipse[ g, token ], token_InfraIntersection :> RandomInfraIntersection[ g, token ], token_InfraUnion :> RandomInfraUnion[ g, token ], token_InfraRay :> RandomInfraHalfLine[ g, token ], token_InfraLine :> RandomInfraInfiniteLine[ g, token ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token ] } ], GraphDistance[g, c, #] == 2 &]}],
  {1, 12, Undetermined, True},
  TestID -> "InfraCircle-triangular-hexagonal-ring"
]

(* the search sweeps the substrate and finds the same cycle, in its own rotation and direction *)
VerificationTest[
  With[{g = TessellationNeighborhoodGraph[{3, 6}, 5]}, {c = First @ GraphCenter[g]},
    {cir = InfraCircle[c, 2]}, {swept = Replace[ cir, { token_InfraPoint :> RandomInfraPoint[ g, token, All ], token_InfraSegment :> RandomInfraSegment[ g, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraCircle :> RandomInfraCircle[ g, token, All ], token_InfraArc :> RandomInfraArc[ g, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All ], token_InfraPlane :> RandomInfraPlane[ g, token, All ], token_InfraBall :> RandomInfraBall[ g, token, All ], token_InfraShell :> RandomInfraShell[ g, token, All ], token_InfraSphere :> RandomInfraSphere[ g, token, All ], token_InfraTube :> RandomInfraTube[ g, token, All ], token_InfraCylinder :> RandomInfraCylinder[ g, token, All ], token_InfraCone :> RandomInfraCone[ g, token, All ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token, All ], token_InfraBallHull :> RandomInfraBallHull[ g, token, All ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token, All ], token_InfraQuadric :> RandomInfraQuadric[ g, token, All ], token_InfraWalk :> RandomInfraWalk[ g, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All ], token_InfraIntersection :> RandomInfraIntersection[ g, token, All ], token_InfraUnion :> RandomInfraUnion[ g, token, All ], token_InfraRay :> RandomInfraHalfLine[ g, token, All ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, All ] } ]},
    cycleSets[circleChains[g, cir]] === cycleSets[swept] &&
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
        cycleSets[circleChains[g, cir]] === cycleSets[bruteCircles[g, 25, rs]] &&
        InfraMeasurement[g, cir, "Cardinality"] == Length @ circleChains[g, cir]]]],
  True,
  TestID -> "InfraCircle-equals-brute-force-on-the-grid"
]

(* ===== a band with sixteen circles: the counting DP against the enumeration ===== *)

VerificationTest[
  With[{g = GridGraph[{11, 11}]}, {cir = InfraCircle[61, {2, 4}]},
    {members = circleChains[g, cir]},
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
    AllTrue[circleChains[g, cir],
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
    {members = Replace[ cir, { token_InfraPoint :> RandomInfraPoint[ g, token, All ], token_InfraSegment :> RandomInfraSegment[ g, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraCircle :> RandomInfraCircle[ g, token, All ], token_InfraArc :> RandomInfraArc[ g, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All ], token_InfraPlane :> RandomInfraPlane[ g, token, All ], token_InfraBall :> RandomInfraBall[ g, token, All ], token_InfraShell :> RandomInfraShell[ g, token, All ], token_InfraSphere :> RandomInfraSphere[ g, token, All ], token_InfraTube :> RandomInfraTube[ g, token, All ], token_InfraCylinder :> RandomInfraCylinder[ g, token, All ], token_InfraCone :> RandomInfraCone[ g, token, All ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token, All ], token_InfraBallHull :> RandomInfraBallHull[ g, token, All ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token, All ], token_InfraQuadric :> RandomInfraQuadric[ g, token, All ], token_InfraWalk :> RandomInfraWalk[ g, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All ], token_InfraIntersection :> RandomInfraIntersection[ g, token, All ], token_InfraUnion :> RandomInfraUnion[ g, token, All ], token_InfraRay :> RandomInfraHalfLine[ g, token, All ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, All ] } ]},
    SeedRandom[7];
    {Head @ Replace[ cir, { token_InfraPoint :> RandomInfraPoint[ g, token ], token_InfraSegment :> RandomInfraSegment[ g, token ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token ], token_InfraCircle :> RandomInfraCircle[ g, token ], token_InfraArc :> RandomInfraArc[ g, token ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token ], token_InfraPlane :> RandomInfraPlane[ g, token ], token_InfraBall :> RandomInfraBall[ g, token ], token_InfraShell :> RandomInfraShell[ g, token ], token_InfraSphere :> RandomInfraSphere[ g, token ], token_InfraTube :> RandomInfraTube[ g, token ], token_InfraCylinder :> RandomInfraCylinder[ g, token ], token_InfraCone :> RandomInfraCone[ g, token ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token ], token_InfraBallHull :> RandomInfraBallHull[ g, token ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token ], token_InfraQuadric :> RandomInfraQuadric[ g, token ], token_InfraWalk :> RandomInfraWalk[ g, token ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token ], token_InfraEllipse :> RandomInfraEllipse[ g, token ], token_InfraIntersection :> RandomInfraIntersection[ g, token ], token_InfraUnion :> RandomInfraUnion[ g, token ], token_InfraRay :> RandomInfraHalfLine[ g, token ], token_InfraLine :> RandomInfraInfiniteLine[ g, token ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token ] } ], Length @ Replace[ cir, { token_InfraPoint :> RandomInfraPoint[ g, token, 3 ], token_InfraSegment :> RandomInfraSegment[ g, token, 3 ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, 3 ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, 3 ], token_InfraCircle :> RandomInfraCircle[ g, token, 3 ], token_InfraArc :> RandomInfraArc[ g, token, 3 ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, 3 ], token_InfraPlane :> RandomInfraPlane[ g, token, 3 ], token_InfraBall :> RandomInfraBall[ g, token, 3 ], token_InfraShell :> RandomInfraShell[ g, token, 3 ], token_InfraSphere :> RandomInfraSphere[ g, token, 3 ], token_InfraTube :> RandomInfraTube[ g, token, 3 ], token_InfraCylinder :> RandomInfraCylinder[ g, token, 3 ], token_InfraCone :> RandomInfraCone[ g, token, 3 ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token, 3 ], token_InfraBallHull :> RandomInfraBallHull[ g, token, 3 ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token, 3 ], token_InfraQuadric :> RandomInfraQuadric[ g, token, 3 ], token_InfraWalk :> RandomInfraWalk[ g, token, 3 ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, 3 ], token_InfraEllipse :> RandomInfraEllipse[ g, token, 3 ], token_InfraIntersection :> RandomInfraIntersection[ g, token, 3 ], token_InfraUnion :> RandomInfraUnion[ g, token, 3 ], token_InfraRay :> RandomInfraHalfLine[ g, token, 3 ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, 3 ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, 3 ] } ],
     Length @ Replace[ cir, { token_InfraPoint :> RandomInfraPoint[ g, token, UpTo[1000] ], token_InfraSegment :> RandomInfraSegment[ g, token, UpTo[1000] ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, UpTo[1000] ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, UpTo[1000] ], token_InfraCircle :> RandomInfraCircle[ g, token, UpTo[1000] ], token_InfraArc :> RandomInfraArc[ g, token, UpTo[1000] ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, UpTo[1000] ], token_InfraPlane :> RandomInfraPlane[ g, token, UpTo[1000] ], token_InfraBall :> RandomInfraBall[ g, token, UpTo[1000] ], token_InfraShell :> RandomInfraShell[ g, token, UpTo[1000] ], token_InfraSphere :> RandomInfraSphere[ g, token, UpTo[1000] ], token_InfraTube :> RandomInfraTube[ g, token, UpTo[1000] ], token_InfraCylinder :> RandomInfraCylinder[ g, token, UpTo[1000] ], token_InfraCone :> RandomInfraCone[ g, token, UpTo[1000] ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token, UpTo[1000] ], token_InfraBallHull :> RandomInfraBallHull[ g, token, UpTo[1000] ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token, UpTo[1000] ], token_InfraQuadric :> RandomInfraQuadric[ g, token, UpTo[1000] ], token_InfraWalk :> RandomInfraWalk[ g, token, UpTo[1000] ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, UpTo[1000] ], token_InfraEllipse :> RandomInfraEllipse[ g, token, UpTo[1000] ], token_InfraIntersection :> RandomInfraIntersection[ g, token, UpTo[1000] ], token_InfraUnion :> RandomInfraUnion[ g, token, UpTo[1000] ], token_InfraRay :> RandomInfraHalfLine[ g, token, UpTo[1000] ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, UpTo[1000] ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, UpTo[1000] ] } ],
     AllTrue[Replace[ cir, { token_InfraPoint :> RandomInfraPoint[ g, token, UpTo[20] ], token_InfraSegment :> RandomInfraSegment[ g, token, UpTo[20] ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, UpTo[20] ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, UpTo[20] ], token_InfraCircle :> RandomInfraCircle[ g, token, UpTo[20] ], token_InfraArc :> RandomInfraArc[ g, token, UpTo[20] ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, UpTo[20] ], token_InfraPlane :> RandomInfraPlane[ g, token, UpTo[20] ], token_InfraBall :> RandomInfraBall[ g, token, UpTo[20] ], token_InfraShell :> RandomInfraShell[ g, token, UpTo[20] ], token_InfraSphere :> RandomInfraSphere[ g, token, UpTo[20] ], token_InfraTube :> RandomInfraTube[ g, token, UpTo[20] ], token_InfraCylinder :> RandomInfraCylinder[ g, token, UpTo[20] ], token_InfraCone :> RandomInfraCone[ g, token, UpTo[20] ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token, UpTo[20] ], token_InfraBallHull :> RandomInfraBallHull[ g, token, UpTo[20] ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token, UpTo[20] ], token_InfraQuadric :> RandomInfraQuadric[ g, token, UpTo[20] ], token_InfraWalk :> RandomInfraWalk[ g, token, UpTo[20] ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, UpTo[20] ], token_InfraEllipse :> RandomInfraEllipse[ g, token, UpTo[20] ], token_InfraIntersection :> RandomInfraIntersection[ g, token, UpTo[20] ], token_InfraUnion :> RandomInfraUnion[ g, token, UpTo[20] ], token_InfraRay :> RandomInfraHalfLine[ g, token, UpTo[20] ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, UpTo[20] ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, UpTo[20] ] } ], MemberQ[members, #] &],
     Length @ DeleteDuplicates @ Replace[ cir, { token_InfraPoint :> RandomInfraPoint[ g, token, UpTo[20] ], token_InfraSegment :> RandomInfraSegment[ g, token, UpTo[20] ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, UpTo[20] ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, UpTo[20] ], token_InfraCircle :> RandomInfraCircle[ g, token, UpTo[20] ], token_InfraArc :> RandomInfraArc[ g, token, UpTo[20] ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, UpTo[20] ], token_InfraPlane :> RandomInfraPlane[ g, token, UpTo[20] ], token_InfraBall :> RandomInfraBall[ g, token, UpTo[20] ], token_InfraShell :> RandomInfraShell[ g, token, UpTo[20] ], token_InfraSphere :> RandomInfraSphere[ g, token, UpTo[20] ], token_InfraTube :> RandomInfraTube[ g, token, UpTo[20] ], token_InfraCylinder :> RandomInfraCylinder[ g, token, UpTo[20] ], token_InfraCone :> RandomInfraCone[ g, token, UpTo[20] ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token, UpTo[20] ], token_InfraBallHull :> RandomInfraBallHull[ g, token, UpTo[20] ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token, UpTo[20] ], token_InfraQuadric :> RandomInfraQuadric[ g, token, UpTo[20] ], token_InfraWalk :> RandomInfraWalk[ g, token, UpTo[20] ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, UpTo[20] ], token_InfraEllipse :> RandomInfraEllipse[ g, token, UpTo[20] ], token_InfraIntersection :> RandomInfraIntersection[ g, token, UpTo[20] ], token_InfraUnion :> RandomInfraUnion[ g, token, UpTo[20] ], token_InfraRay :> RandomInfraHalfLine[ g, token, UpTo[20] ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, UpTo[20] ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, UpTo[20] ] } ] > 1}],
  {List, 3, 16, True, True},
  TestID -> "InfraCircle-count-contract-and-random-draws"
]

(* ===== the hypercube: without a winding functional the banks are one-sided ===== *)

(* Q4 with the band (1, 2) has three circles, the subdivided Hamiltonian cycles of K4, and no winding functional; the cut band is connected
   but every neighbour of the seam lies on one bank, so the cover has no atom and every necklace of the seam is a subdivided triangle,
   which does not separate: the graph is empty, "Faithful" is False, and the sweep finds all three (design Ex. q4) *)
VerificationTest[
  With[{g = HypercubeGraph[4]}, {c = First @ VertexList[g]},
    {cir = InfraCircle[c, {1, 2}]}, {swept = Replace[ cir, { token_InfraPoint :> RandomInfraPoint[ g, token, All ], token_InfraSegment :> RandomInfraSegment[ g, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraCircle :> RandomInfraCircle[ g, token, All ], token_InfraArc :> RandomInfraArc[ g, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All ], token_InfraPlane :> RandomInfraPlane[ g, token, All ], token_InfraBall :> RandomInfraBall[ g, token, All ], token_InfraShell :> RandomInfraShell[ g, token, All ], token_InfraSphere :> RandomInfraSphere[ g, token, All ], token_InfraTube :> RandomInfraTube[ g, token, All ], token_InfraCylinder :> RandomInfraCylinder[ g, token, All ], token_InfraCone :> RandomInfraCone[ g, token, All ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token, All ], token_InfraBallHull :> RandomInfraBallHull[ g, token, All ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token, All ], token_InfraQuadric :> RandomInfraQuadric[ g, token, All ], token_InfraWalk :> RandomInfraWalk[ g, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All ], token_InfraIntersection :> RandomInfraIntersection[ g, token, All ], token_InfraUnion :> RandomInfraUnion[ g, token, All ], token_InfraRay :> RandomInfraHalfLine[ g, token, All ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, All ] } ]},
    {InfraMeasurement[g, cir, "Graph"], InfraMeasurement[g, cir, "Faithful"], Length[swept], Union[Length /@ swept],
     AllTrue[swept, AllTrue[VertexComponent[VertexDelete[g, #], c], GraphDistance[g, c, #] <= 2 &] &]}],
  {{}, False, 3, {8}, True},
  TestID -> "InfraCircle-hypercube-has-no-winding-functional"
]

(* the representative finder reads the circle by the sweep, so it finds the three circles the graph misses *)
VerificationTest[
  With[{g = HypercubeGraph[4]}, {c = First @ VertexList[g]}, {cir = InfraCircle[c, {1, 2}]},
    {Replace[ cir, { token_InfraPoint :> RandomInfraPoint[ g, token, All ], token_InfraSegment :> RandomInfraSegment[ g, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraCircle :> RandomInfraCircle[ g, token, All ], token_InfraArc :> RandomInfraArc[ g, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All ], token_InfraPlane :> RandomInfraPlane[ g, token, All ], token_InfraBall :> RandomInfraBall[ g, token, All ], token_InfraShell :> RandomInfraShell[ g, token, All ], token_InfraSphere :> RandomInfraSphere[ g, token, All ], token_InfraTube :> RandomInfraTube[ g, token, All ], token_InfraCylinder :> RandomInfraCylinder[ g, token, All ], token_InfraCone :> RandomInfraCone[ g, token, All ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token, All ], token_InfraBallHull :> RandomInfraBallHull[ g, token, All ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token, All ], token_InfraQuadric :> RandomInfraQuadric[ g, token, All ], token_InfraWalk :> RandomInfraWalk[ g, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All ], token_InfraIntersection :> RandomInfraIntersection[ g, token, All ], token_InfraUnion :> RandomInfraUnion[ g, token, All ], token_InfraRay :> RandomInfraHalfLine[ g, token, All ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, All ] } ] === bruteCircles[g, c, {1, 2}],
     Length @ Replace[ cir, { token_InfraPoint :> RandomInfraPoint[ g, token, All ], token_InfraSegment :> RandomInfraSegment[ g, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraCircle :> RandomInfraCircle[ g, token, All ], token_InfraArc :> RandomInfraArc[ g, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All ], token_InfraPlane :> RandomInfraPlane[ g, token, All ], token_InfraBall :> RandomInfraBall[ g, token, All ], token_InfraShell :> RandomInfraShell[ g, token, All ], token_InfraSphere :> RandomInfraSphere[ g, token, All ], token_InfraTube :> RandomInfraTube[ g, token, All ], token_InfraCylinder :> RandomInfraCylinder[ g, token, All ], token_InfraCone :> RandomInfraCone[ g, token, All ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token, All ], token_InfraBallHull :> RandomInfraBallHull[ g, token, All ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token, All ], token_InfraQuadric :> RandomInfraQuadric[ g, token, All ], token_InfraWalk :> RandomInfraWalk[ g, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All ], token_InfraIntersection :> RandomInfraIntersection[ g, token, All ], token_InfraUnion :> RandomInfraUnion[ g, token, All ], token_InfraRay :> RandomInfraHalfLine[ g, token, All ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, All ] } ], circleChains[g, cir]}],
  {True, 3, {}},
  TestID -> "NamedConstructionSampler-circle-is-the-sweep"
]

(* a band cut through on the rim of the grid is not an annulus: its banks are one-sided too, and "Faithful" is False although neither the
   graph nor the sweep has a circle *)
VerificationTest[
  With[{g = GridGraph[{11, 11}]}, {cir = InfraCircle[6, {2, 4}]},
    {InfraMeasurement[g, cir, "Graph"], InfraMeasurement[g, cir, "Faithful"], Replace[ cir, { token_InfraPoint :> RandomInfraPoint[ g, token, All ], token_InfraSegment :> RandomInfraSegment[ g, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraCircle :> RandomInfraCircle[ g, token, All ], token_InfraArc :> RandomInfraArc[ g, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All ], token_InfraPlane :> RandomInfraPlane[ g, token, All ], token_InfraBall :> RandomInfraBall[ g, token, All ], token_InfraShell :> RandomInfraShell[ g, token, All ], token_InfraSphere :> RandomInfraSphere[ g, token, All ], token_InfraTube :> RandomInfraTube[ g, token, All ], token_InfraCylinder :> RandomInfraCylinder[ g, token, All ], token_InfraCone :> RandomInfraCone[ g, token, All ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token, All ], token_InfraBallHull :> RandomInfraBallHull[ g, token, All ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token, All ], token_InfraQuadric :> RandomInfraQuadric[ g, token, All ], token_InfraWalk :> RandomInfraWalk[ g, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All ], token_InfraIntersection :> RandomInfraIntersection[ g, token, All ], token_InfraUnion :> RandomInfraUnion[ g, token, All ], token_InfraRay :> RandomInfraHalfLine[ g, token, All ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, All ] } ]}],
  {{}, False, {}},
  TestID -> "InfraCircle-one-sided-banks-off-an-annulus"
]

(* ===== the octagon: (W) holds and (T) fails ===== *)

octagonGraph[] := Graph[{
  "a" <-> "b", "b" <-> "c", "c" <-> "d", "d" <-> "e", "e" <-> "f", "f" <-> "g", "g" <-> "h", "h" <-> "a",
  "a" <-> "u", "u" <-> "c", "o" <-> "a", "o" <-> "e", "c" <-> "y",
  "e" <-> "j", "j" <-> "k", "k" <-> "z"}]

(* the same octagon drawn in the plane, its two outer vertices swapped, so that the automatic seam ends at the one beyond k and is (e, j, k) *)
octagonDrawn[] := Graph[{
  "a" <-> "b", "b" <-> "c", "c" <-> "d", "d" <-> "e", "e" <-> "f", "f" <-> "g", "g" <-> "h", "h" <-> "a",
  "a" <-> "u", "u" <-> "c", "o" <-> "a", "o" <-> "e", "c" <-> "z",
  "e" <-> "j", "j" <-> "k", "k" <-> "y"},
  VertexCoordinates -> {"a" -> {1, 0}, "b" -> {0.71, 0.71}, "c" -> {0, 1}, "d" -> {-0.71, 0.71}, "e" -> {-1, 0}, "f" -> {-0.71, -0.71},
    "g" -> {0, -1}, "h" -> {0.71, -0.71}, "u" -> {1.4, 1.4}, "o" -> {0, 0}, "z" -> {0, 1.8}, "j" -> {-1.6, 0}, "k" -> {-2.2, 0}, "y" -> {-2.8, 0}}]

(* the band (1, 3) has two circles, both through a and e.  The automatic seam is (a, b, c), whose cut band is disconnected, u hanging at a and c;
   the graph is then the necklaces, which carry one of the circles, and what they carry separates (design Ex. octagon) *)
VerificationTest[
  With[{g = octagonGraph[]}, {cir = InfraCircle["o", {1, 3}]},
    {Length @ Replace[ cir, { token_InfraPoint :> RandomInfraPoint[ g, token, All ], token_InfraSegment :> RandomInfraSegment[ g, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraCircle :> RandomInfraCircle[ g, token, All ], token_InfraArc :> RandomInfraArc[ g, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All ], token_InfraPlane :> RandomInfraPlane[ g, token, All ], token_InfraBall :> RandomInfraBall[ g, token, All ], token_InfraShell :> RandomInfraShell[ g, token, All ], token_InfraSphere :> RandomInfraSphere[ g, token, All ], token_InfraTube :> RandomInfraTube[ g, token, All ], token_InfraCylinder :> RandomInfraCylinder[ g, token, All ], token_InfraCone :> RandomInfraCone[ g, token, All ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token, All ], token_InfraBallHull :> RandomInfraBallHull[ g, token, All ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token, All ], token_InfraQuadric :> RandomInfraQuadric[ g, token, All ], token_InfraWalk :> RandomInfraWalk[ g, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All ], token_InfraIntersection :> RandomInfraIntersection[ g, token, All ], token_InfraUnion :> RandomInfraUnion[ g, token, All ], token_InfraRay :> RandomInfraHalfLine[ g, token, All ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, All ] } ],
     InfraMeasurement[g, cir, "Cardinality"],
     InfraMeasurement[g, cir, "Faithful"],
     AllTrue[circleChains[g, cir],
       cyc |-> Length[cyc] == 8 && AllTrue[VertexComponent[VertexDelete[g, cyc], "o"], GraphDistance[g, "o", #] <= 3 &]]}],
  {2, 1, Undetermined, True},
  TestID -> "InfraCircle-octagon-disconnected-cut-band-gives-the-necklaces"
]

(* on the seam (e, j, k) the cut band is connected, and the one atom at e carries both circles, the one that meets the seam (a, b, c) twice
   included *)
VerificationTest[
  {unrolledReport[octagonDrawn[], "o", {1, 3}], InfraMeasurement[octagonDrawn[], InfraCircle["o", {1, 3}], {"Cardinality", "Length", "Faithful"}]},
  {{True, True, True}, <|"Cardinality" -> 2, "Length" -> 8, "Faithful" -> Undetermined|>},
  TestID -> "InfraCircle-octagon-seam-through-e-agrees-with-the-sweep"
]

(* ===== degenerate bands and the inert head ===== *)

(* radius 0 is the centre alone, so the band is empty and there is nothing to separate *)
VerificationTest[
  InfraMeasurement[GridGraph[{5, 5}], InfraCircle[13, 0], {"Cardinality", "Faithful"}],
  <|"Cardinality" -> 0, "Faithful" -> Undetermined|>,
  TestID -> "InfraCircle-radius-zero-is-empty"
]

(* a positional second argument is a radius, never a point: an integer vertex label is read as a radius,
   any other label leaves the head unmatched *)
VerificationTest[
  With[{g = GridGraph[{11, 11}]},
    {InfraMeasurement[g, InfraCircle[61, 4], "Cardinality"], InfraMeasurement[g, InfraCircle[61, {4, 5}], "Length"],
     Head @ RandomInfraCircle[ g, InfraCircle[61, "a"], All ],
     MatchQ[InfraMeasurement[octagonGraph[], InfraCircle["o", "a"], "Graph"], _InfraMeasurement]}],
  {0, 32, RandomInfraCircle, True},
  TestID -> "InfraCircle-second-argument-is-a-radius"
]

(* a band reaching the eccentricity has nothing beyond it, so no radial geodesic leaves it and the
   seam is empty, while separation is vacuous and the sweep still returns the shortest band cycles
   -- which is what Euclid I.1 draws on the Petersen graph *)
VerificationTest[
  With[{g = PetersenGraph[]},
    {circleChains[g, InfraCircle[1, 2]],
     InfraMeasurement[g, InfraCircle[1, 2], "Faithful"],
     Length @ RandomInfraCircle[ g, InfraCircle[1, 2], All ],
     Union[Length /@ RandomInfraCircle[ g, InfraCircle[1, 2], All ]]}],
  {{}, Undetermined, 1, {6}},
  TestID -> "InfraCircle-a-band-with-nothing-beyond-it"
]

VerificationTest[
  {InfraCircle[13, 2], InfraCircle[13, {2, 3}]},
  {InfraCircle[13, 2], InfraCircle[13, {2, 3}]},
  TestID -> "InfraCircle-without-a-graph-stays-inert"
]

(* an atom, and a necklace alike, is a DAG from a seam vertex x to its copy {x, 3/2}, its chains the circles as closed walks *)
VerificationTest[
  AllTrue[Catenate @ {InfraMeasurement[GridGraph[{11, 11}], InfraCircle[61, {2, 4}], "Graph"],
      InfraMeasurement[octagonGraph[], InfraCircle["o", {1, 3}], "Graph"]},
    dag |-> AcyclicGraphQ[dag] && DirectedGraphQ[dag] &&
      Count[VertexInDegree[dag], 0] == 1 && Count[VertexOutDegree[dag], 0] == 1 &&
      First @ Pick[VertexList@dag, VertexOutDegree@dag, 0] === {First @ Pick[VertexList@dag, VertexInDegree@dag, 0], 3/2}],
  True,
  TestID -> "InfraCircle-graph-closes-on-a-copy-of-the-source"
]

(* ===== the family against the search and the brute force ===== *)

VerificationTest[
  With[{g = GridGraph[{11, 11}]}, {cir = InfraCircle[61, {2, 4}]},
    {brute = cycleSets[bruteCircles[g, 61, {2, 4}]]},
    {Length[brute], cycleSets[Replace[ cir, { token_InfraPoint :> RandomInfraPoint[ g, token, All ], token_InfraSegment :> RandomInfraSegment[ g, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraCircle :> RandomInfraCircle[ g, token, All ], token_InfraArc :> RandomInfraArc[ g, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All ], token_InfraPlane :> RandomInfraPlane[ g, token, All ], token_InfraBall :> RandomInfraBall[ g, token, All ], token_InfraShell :> RandomInfraShell[ g, token, All ], token_InfraSphere :> RandomInfraSphere[ g, token, All ], token_InfraTube :> RandomInfraTube[ g, token, All ], token_InfraCylinder :> RandomInfraCylinder[ g, token, All ], token_InfraCone :> RandomInfraCone[ g, token, All ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token, All ], token_InfraBallHull :> RandomInfraBallHull[ g, token, All ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token, All ], token_InfraQuadric :> RandomInfraQuadric[ g, token, All ], token_InfraWalk :> RandomInfraWalk[ g, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All ], token_InfraIntersection :> RandomInfraIntersection[ g, token, All ], token_InfraUnion :> RandomInfraUnion[ g, token, All ], token_InfraRay :> RandomInfraHalfLine[ g, token, All ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, All ] } ]] === brute,
     cycleSets[circleChains[g, cir]] === brute}],
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

(* the edge into the sink copy is read as the closing edge u -> x *)
VerificationTest[
  With[{g = GridGraph[{11, 11}]}, {cir = InfraCircle[61, {2, 4}]},
    InfraMeasurement[g, cir, "EdgeDensity"] ===
      KeySort @ Counts @ Catenate[Apply[DirectedEdge, Partition[#, 2, 1, 1], {1}] & /@ circleChains[g, cir]]],
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
  With[{g = GridGraph[{25, 25}]}, {cycles = circleChains[g, InfraCircle[313, {5, 9}], 5]},
    {Length[cycles], Union[Length /@ cycles],
     AllTrue[cycles, cyc |-> DuplicateFreeQ[cyc] &&
       AllTrue[Partition[Append[cyc, First @ cyc], 2, 1], EdgeQ[g, UndirectedEdge @@ #] &]]}],
  {5, {40}, True},
  TestID -> "InfraCircle-bounded-count-is-lazy"
]

(* a cycle graph's band carries no separating cycle *)
VerificationTest[
  {bruteCircles[CycleGraph[6], 1, {1, 2}],
   RandomInfraCircle[ CycleGraph[6], InfraCircle[1, {1, 2}], All ]},
  {{}, {}},
  TestID -> "NamedConstructionSampler-circle-empty-family-is-quiet"
]

EndTestSection[]
