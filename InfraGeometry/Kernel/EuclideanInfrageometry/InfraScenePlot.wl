Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraScenePlot *)

Options[ InfraScenePlot ] := Options[ InfraSubstrateHighlight ]

InfraScenePlot[ scene_InfraScene, graph_Graph, instance : InfraSceneInstance[ bindings_Association ], opts : OptionsPattern[] ] /;
	AssociationQ[ First[ scene ] ] && AllTrue[ { opts }, MatchQ[ _Rule | _RuleDelayed ] ] :=
	InfraScenePlot[ scene, graph, instance, Select[ scene[ "Objects" ], name |-> KeyExistsQ[ bindings, name ] ], opts ]

InfraScenePlot[ scene_InfraScene, graph_Graph, InfraSceneInstance[ bindings_Association ], objects_List, opts : OptionsPattern[] ] /;
	AssociationQ[ First[ scene ] ] :=
	Module[ { kinds, geometryHeads, resolve, available, drawable, draw },
		kinds = Association @ Catenate @ KeyValueMap[
			{ name, expression } |-> With[ { targets = If[ ListQ[ name ], name, { name } ] },
				Thread[ targets -> Which[
					ListQ[ name ] || VertexQ[ graph, expression ], "Point",
					MatchQ[ expression, _InfraPoint | _InfraMidpoint | _InfraRegionNearest ], "Point",
					MatchQ[ expression, _InfraPerpendicularBisector | _InfraEquidistantSet | _InfraPlane | _InfraBall | _InfraShell | _InfraSphere | _InfraTube | _InfraCylinder |
						_InfraCone | _InfraSolidOfRevolution | _InfraBallHull | _InfraConvexHull | _InfraQuadric | _InfraIntersection | _InfraUnion ], "VertexSet",
					MatchQ[ expression, _InfraEllipse ], "Graph",
					MatchQ[ expression, _InfraCircle | _InfraCircleThrough | _InfraRegularPolygon | _InfraPolygon | InfraArc[ _, { p_, ___, p_ } | { _ }, ___ ] ], "Cycle",
					MatchQ[ expression, _InfraSegment | _InfraHalfLine | _InfraRay | _InfraInfiniteLine | _InfraLine | _InfraArc | _InfraWalk | _InfraGeodesic ], "Walk",
					True, "Exact" ] ] ], scene[ "Constructions" ] ];
		geometryHeads = { InfraWalk, InfraSegment, InfraHalfLine, InfraRay, InfraInfiniteLine, InfraLine, InfraCircle, InfraCircleThrough, InfraArc,
			InfraMidpoint, InfraPerpendicularBisector, InfraEquidistantSet, InfraRegionNearest, InfraBall, InfraShell, InfraSphere, InfraTube,
			InfraCylinder, InfraCone, InfraSolidOfRevolution, InfraBallHull, InfraConvexHull, InfraQuadric, InfraIntersection, InfraUnion,
			InfraGeodesic, InfraEllipse };
		resolve[ expression_ ] := Which[
			KeyExistsQ[ bindings, expression ], Lookup[ bindings, Key[ expression ] ],
			VertexQ[ graph, expression ] || AtomQ[ expression ] || GraphQ[ expression ] || AssociationQ[ expression ] ||
				MatchQ[ expression, _Function ], expression,
			True, Map[ resolve, expression ] ];
		available[ expression_ ] := Which[
			KeyExistsQ[ bindings, expression ] || VertexQ[ graph, expression ] || GraphQ[ expression ] || AssociationQ[ expression ] ||
				MatchQ[ expression, _Function ], True,
			AnyTrue[ scene[ "Objects" ], name |-> name === expression ], False,
			AtomQ[ expression ], True,
			True, AllTrue[ List @@ expression, available ] ];
		drawable[ expression_ ] := Which[
			KeyExistsQ[ bindings, expression ], With[ { value = Lookup[ bindings, Key[ expression ] ] },
				VertexQ[ graph, value ] || GraphQ[ value ] || AssociationQ[ value ] ||
				( ListQ[ value ] && MemberQ[ { "Walk", "Cycle", "VertexSet" }, Lookup[ kinds, Key[ expression ], "Exact" ] ] ) ||
				MemberQ[ geometryHeads, Head[ value ] ] ],
			VertexQ[ graph, expression ] || GraphQ[ expression ] || AssociationQ[ expression ] || MatchQ[ expression, _Directive ], True,
			MatchQ[ expression, Style[ _, __ ] | _Rule ], drawable[ First[ expression ] ],
			ListQ[ expression ], AllTrue[ expression, item |-> drawable[ item ] &&
				( KeyExistsQ[ bindings, item ] || VertexQ[ graph, item ] || ! MatchQ[ item, _Style | _Rule | _Directive ] ) ],
			MemberQ[ geometryHeads, Head[ expression ] ], AllTrue[ List @@ expression, available ],
			True, False ];
		draw[ expression_ ] := Which[
			KeyExistsQ[ bindings, expression ], With[ { value = Lookup[ bindings, Key[ expression ] ] },
				Which[
					VertexQ[ graph, value ], Association[ value -> 1 ],
					ListQ[ value ] && Lookup[ kinds, Key[ expression ], "Exact" ] === "Walk", InfraWalk[ value ],
					ListQ[ value ] && Lookup[ kinds, Key[ expression ], "Exact" ] === "Cycle", InfraWalk[ closeWalk @ value ],
					ListQ[ value ] && Lookup[ kinds, Key[ expression ], "Exact" ] === "VertexSet", AssociationThread[ value, ConstantArray[ 1, Length[ value ] ] ],
					True, value ] ],
			VertexQ[ graph, expression ], Association[ expression -> 1 ],
			GraphQ[ expression ] || AssociationQ[ expression ] || MatchQ[ expression, _Directive ], expression,
			MatchQ[ expression, Style[ _, __ ] ], MapAt[ draw, expression, 1 ],
			MatchQ[ expression, _Rule ], draw[ First[ expression ] ] -> Last[ expression ],
			ListQ[ expression ], Map[ draw, expression ],
			True, resolve[ expression ] ];
		BlockRandom[ InfraSubstrateHighlight[ graph, draw /@ objects,
			Sequence @@ FilterRules[ Join[ Flatten[ { opts } ],
				Select[ Options[ InfraScenePlot ], option |-> ! AnyTrue[ Options[ InfraSubstrateHighlight ], default |-> default === option ] ] ],
				Options[ InfraSubstrateHighlight ] ] ] ] /;
			AllTrue[ objects, drawable ]
	]
