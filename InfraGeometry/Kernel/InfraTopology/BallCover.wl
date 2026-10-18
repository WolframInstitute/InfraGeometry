Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: InfraTopology :: BallCover *)

Options[ FindBallCover ] = { Method -> Automatic }

FindBallCover[ graph_Graph, opts : OptionsPattern[] ] :=
	With[ { cover = FindBallCover[ graph, 1, All, opts ] }, cover /; ListQ[ cover ] ]

FindBallCover[ graph_Graph, radius_Integer?( r |-> r >= 0 ), target_ : All,
	count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All ) : Automatic,
	opts : OptionsPattern[] ] /; UndirectedGraphQ[ graph ] && ! WeightedGraphQ[ graph ] &&
	( ! OptionQ[ target ] || VertexQ[ graph, target ] ||
		( ListQ[ target ] && AllTrue[ target, vertex |-> VertexQ[ graph, vertex ] ] ) ) &&
	SubsetQ[ { Method }, First /@ Flatten[ { opts } ] ] &&
	MatchQ[ OptionValue[ FindBallCover, { opts }, Method ], Automatic | "IntegerLinearProgramming" | "Exhaustive" | "Greedy" ] &&
	( OptionValue[ FindBallCover, { opts }, Method ] =!= "Greedy" || count === Automatic ) :=
	With[
		{ density = Which[
			target === All, AssociationThread[ VertexList[ graph ], 1 ],
			VertexQ[ graph, target ], Association[ target -> 1 ],
			AtomQ[ target ] || MatchQ[ target, _List | _Association | _Graph ], InfraDensity[ graph, target ],
			True, Quiet[ InfraMeasurement[ graph, target, "VertexDensity" ] ] ] },
		With[
			{ targets = Keys[ density ], method = OptionValue[ FindBallCover, { opts }, Method ] },
			Which[
				count === 0 || count === UpTo[ 0 ], { },
				targets === { },
				Switch[ count, Automatic, { }, All, { { } }, _Integer, If[ count === 1, { { } }, { } ], _UpTo, Take[ { { } }, count ] ],
				True, With[
					{ candidateMatrix = If[ target === All,
						{ VertexList[ graph ], Map[ distance |-> Boole[ distance <= radius ], GraphDistanceMatrix[ graph ], { 2 } ] },
						With[
							{ vertices = VertexList[ graph ], indexedGraph = IndexGraph[ graph ],
							vertexIndex = AssociationThread[ VertexList[ graph ], Range[ VertexCount[ graph ] ] ] },
							{ balls = ( vertex |-> vertices[[ VertexList[
								NeighborhoodGraph[ indexedGraph, Lookup[ vertexIndex, Key[ vertex ] ], radius ] ] ]] ) /@ targets },
							{ candidates = Union @@ balls },
							{ index = AssociationThread[ candidates, Range[ Length[ candidates ] ] ] },
							{ candidates, SparseArray[
								Catenate @ MapIndexed[ { ball, row } |->
									( vertex |-> { First[ row ], Lookup[ index, Key[ vertex ] ] } -> 1 ) /@ ball, balls ],
								{ Length[ targets ], Length[ candidates ] } ] } ] ] },
					{ candidates = First[ candidateMatrix ], matrix = Last[ candidateMatrix ] },
					{ one = If[ method === "Greedy",
						Sort @ candidates[[ Last @ NestWhile[
							Apply[ { uncovered, chosen } |-> With[
								{ column = First @ Ordering[ uncovered . matrix, -1 ] },
								{ uncovered ( 1 - Normal[ matrix[[ All, column ]] ] ), Append[ chosen, column ] } ] ],
							{ ConstantArray[ 1, Length[ targets ] ], { } },
							Apply[ { uncovered, chosen } |-> Total[ uncovered ] > 0 ] ] ]],
						With[ { variables = Array[ \[FormalX], Length[ candidates ] ] },
							Sort @ candidates[[ Flatten @ Position[
								Round[ variables /. LinearOptimization[
									Total[ variables ], Join[ Thread[ matrix . variables >= 1 ], Thread[ 0 <= variables <= 1 ] ],
									variables \[Element] Vectors[ Length[ candidates ], Integers ] ] ], 1 ] ]] ] ] },
					Which[
						count === Automatic, one,
						count === 1 || count === UpTo[ 1 ], { one },
						True,
						With[ { covers = Sort @ Map[ Sort, Select[ Subsets[ candidates, { Length[ one ] } ],
							centres |-> BallCoverQ[ graph, radius, centres, target ] ] ] },
							Which[
								count === All, covers,
								IntegerQ[ count ] && Length[ covers ] < count, { },
								True, Take[ covers, count ] ] ] ] ] ] ] /;
			AssociationQ[ density ] && AllTrue[ Keys[ density ], vertex |-> VertexQ[ graph, vertex ] ] ]

BallCoverQ[ graph_Graph, radius_Integer?( r |-> r >= 0 ), centres_List, target_ : All ] /;
	UndirectedGraphQ[ graph ] && ! WeightedGraphQ[ graph ] && AllTrue[ centres, vertex |-> VertexQ[ graph, vertex ] ] :=
	With[
		{ density = Which[
			target === All, AssociationThread[ VertexList[ graph ], 1 ],
			VertexQ[ graph, target ], Association[ target -> 1 ],
			AtomQ[ target ] || MatchQ[ target, _List | _Association | _Graph ], InfraDensity[ graph, target ],
			True, Quiet[ InfraMeasurement[ graph, target, "VertexDensity" ] ] ] },
		With[
			{ index = AssociationThread[ VertexList[ graph ], Range[ VertexCount[ graph ] ] ], distances = GraphDistanceMatrix[ graph ] },
			{ columns = Lookup[ index, Key /@ centres ] },
			AllTrue[ Keys[ density ], vertex |-> AnyTrue[ columns,
				column |-> distances[[ Lookup[ index, Key[ vertex ] ], column ]] <= radius ] ] ] /;
			AssociationQ[ density ] && AllTrue[ Keys[ density ], vertex |-> VertexQ[ graph, vertex ] ] ]

Options[ BallCoverNumber ] = { Method -> Automatic }

BallCoverNumber[ graph_Graph, opts : OptionsPattern[] ] :=
	With[ { number = BallCoverNumber[ graph, 1, All, opts ] }, number /; IntegerQ[ number ] ]

BallCoverNumber[ graph_Graph, radius_Integer?( r |-> r >= 0 ), target_ : All, opts : OptionsPattern[] ] /;
	( ! OptionQ[ target ] || VertexQ[ graph, target ] ||
		( ListQ[ target ] && AllTrue[ target, vertex |-> VertexQ[ graph, vertex ] ] ) ) &&
	SubsetQ[ { Method }, First /@ Flatten[ { opts } ] ] &&
	MatchQ[ OptionValue[ BallCoverNumber, { opts }, Method ], Automatic | "IntegerLinearProgramming" | "Exhaustive" ] :=
	With[ { cover = FindBallCover[ graph, radius, target, FilterRules[ Flatten[ { opts } ], Options[ FindBallCover ] ] ] },
		Length[ cover ] /; ListQ[ cover ] ]
