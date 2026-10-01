Package["WolframInstitute`InfraGeometry`"]

(* BallTopology[g, r]: Hasse diagram of the specialization preorder of the
   Alexandrov topology on V(g) with closed-set subbasis the closed r-balls.
   Directed edge q -> p iff B_r(p) subset B_r(q), transitive edges removed.
   The returned digraph IS the topology object plugged into the operators below;
   its VertexList recovers the carrier set V (reflexivity keeps every vertex). *)

Options[BallTopology] = {"Dual" -> False};

BallTopology[graph_Graph, r_, OptionsPattern[]] :=
	With[
		{ind = UnitStep[r - GraphDistanceMatrix[graph]]},
		{hasse = TransitiveReductionGraph @ AdjacencyGraph[
			VertexList[graph],
			Outer[Boole[AllTrue[#1 - #2, NonNegative]] &, ind, ind, 1],
			DirectedEdges -> True]},
		If[TrueQ @ OptionValue["Dual"], ReverseGraph @ hasse, hasse]
	]

TopologicalClosure[topo_Graph, verts_List] :=
	Union @@ Map[v |-> VertexInComponent[topo, {v}], verts]

TopologicalInterior[topo_Graph, verts_List] :=
	With[{vertices = VertexList[topo]},
		Complement[vertices, TopologicalClosure[topo, Complement[vertices, verts]]]
	]

TopologicalBoundary[topo_Graph, verts_List] :=
	Complement[TopologicalClosure[topo, verts], TopologicalInterior[topo, verts]]

TopologicalNeighborhood[topo_Graph, verts_List] :=
	Union @@ Map[v |-> VertexOutComponent[topo, {v}], verts]

(* ContinuousMapQ[f, topo1, topo2]: the vertex map f is continuous iff it is
   monotone for the specialization preorders -- every Hasse edge q -> p of topo1
   maps to a pair reachable in the transitive closure of topo2. f: Association,
   list of Rule, or callable. *)
ContinuousMapQ[f_, topo1_Graph, topo2_Graph] :=
	With[
		{tgtClosure = TransitiveClosureGraph[topo2]},
		{map = If[MatchQ[f, {__Rule}], Association @ f, f]},
		AllTrue[EdgeList[topo1], e |-> EdgeQ[tgtClosure, map @ e[[1]] -> map @ e[[2]]]]
	]

TopologyGraph[graph_Graph, topo_Graph] :=
	With[{coords = Thread[VertexList[graph] -> GraphEmbedding[graph]]},
		Show[
			Graph[graph,
				VertexCoordinates -> coords,
				EdgeStyle -> Directive[GrayLevel[0.70], Thickness[0.006]]],
			Graph[VertexList[graph], EdgeList[topo],
				DirectedEdges -> True,
				VertexCoordinates -> coords,
				VertexStyle -> Transparent,
				VertexLabels -> None,
				EdgeStyle -> Directive[RGBColor[0.42, 0.55, 0.78], Thickness[0.005], Arrowheads[Medium]]]
		]
	]
