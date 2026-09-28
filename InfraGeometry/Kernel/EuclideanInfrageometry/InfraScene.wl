Package["WolframInstitute`InfraGeometry`"]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraScene *)

PackageScope[sceneAssertionRules]
PackageScope[resolveExpression]
PackageScope[extractBranches]
PackageScope[capBranches]
PackageScope[applySelectOption]
PackageScope[constructionPatternQ]
PackageScope[dispatchConstruction]
PackageScope[evaluateConstruction]
PackageScope[pointQ]
PackageScope[closedWalkQ]
PackageScope[positionSpelledQ]
PackageScope[walkSequence]
PackageScope[walkRealisations]
PackageScope[closeWalk]
PackageScope[dagGeodesics]
PackageScope[walkVertexSet]
PackageScope[infraSpread]
PackageScope[vertexSet]
PackageScope[infraVertexSet]
PackageScope[polylineToVertexSeq]
PackageScope[embeddingClosestCycles]
PackageScope[EmbeddingCircleDistance]
PackageScope[resolveEmbeddingCoords]


(* ===================== Helpers ===================== *)

(* every scene assertion, as (inert user-facing form :> the named predicate the graph is injected into); the guard below decides admissibility by this table, so no head and no arity is accepted without a rule *)
sceneAssertionRules[ graph_ ] :=
  { InfraDistance[ x_, y_ ]      :> GraphDistance[ graph, x, y ],
    InfraWalkQ[ w_ ]             :> InfraWalkQ[ graph, w ],
    InfraSegmentQ[ s_ ]          :> InfraSegmentQ[ graph, s ],
    InfraShellQ[ vs_ ]           :> InfraShellQ[ graph, vs ],
    InfraBallQ[ vs_ ]            :> InfraBallQ[ graph, vs ],
    InfraPlaneQ[ h_, p1_, p2_ ]  :> InfraPlaneQ[ graph, h, p1, p2 ],
    InfraCircleQ[ c_ ]           :> InfraCircleQ[ graph, c ],
    InfraLineQ[ s_ ]             :> InfraLineQ[ graph, s ],
    InfraParallelQ[ l1_, l2_ ]   :> InfraParallelQ[ graph, l1, l2 ],
    InfraIntersectQ[ s1_, s2_ ]  :> IntersectingQ[ s1, s2 ],
    InfraPolylineQ[ poly_ ]      :> InfraPolylineQ[ graph, poly ],
    InfraRegularPolygonQ[ c_, as_ ] :> InfraRegularPolygonQ[ graph, c, as ],
    InfraRevolutionQ[ vs_, axis_, profile_ ] :> InfraRevolutionQ[ graph, vs, axis, profile ] }

resolveExpression[ expr_, bindings_Association, graph_Graph ] :=
  ( expr /. Normal[ bindings ] ) /. sceneAssertionRules[ graph ]

(* an Infra*Q with no rule in that table never receives the graph, so it stays inert and TrueQ reads it as False; matching the whole shape rather than the head catches a known head at an unsupported arity too *)
undecidableAssertions[ assertions_List ] :=
  With[ { decidable = Alternatives @@ Keys @ sceneAssertionRules[ Null ] },
    DeleteDuplicates @ Cases[ assertions,
      token : head_Symbol[ ___ ] /;
        StringMatchQ[ SymbolName[ head ], "Infra" ~~ ___ ~~ "Q" ] &&
          ! MatchQ[ token, decidable ],
      { 0, Infinity } ] ]

extractBranches[ opts_List ] :=
  Lookup[ Association @ opts, "Branches", All ]

constructionPatternQ[ objects_List, h_ ] :=
  MatchQ[ h, ( key_ == _ ) /;
    ( MemberQ[ objects, key ] || ( ListQ[ key ] && SubsetQ[ objects, key ] ) ) ]

capBranches[ paths_List, All ]              := paths
capBranches[ paths_List, n_Integer ]        := Take[ paths, UpTo[ n ] ]
capBranches[ paths_List, UpTo[ n_Integer ] ] := Take[ paths, UpTo[ n ] ]
capBranches[ other_, _ ]                    := other

applySelectOption[ _Graph, paths_, None, _, _ ] := paths
applySelectOption[ graph_Graph, paths_, list_List, cyclic_, ctx_ ] :=
  Fold[ applySelectOption[ graph, #1, #2, cyclic, ctx ] &, paths, list ]
applySelectOption[ graph_Graph, paths_, "EmbeddingClosest", True,  ctx_ ] :=
  embeddingClosestCycles[ graph, paths, ctx[ "Center" ], ctx[ "Radius" ] ]
applySelectOption[ graph_Graph, paths_, "EmbeddingClosest", False, ctx_ ] :=
  EmbeddingClosest[ graph, paths, ctx[ "Endpoints" ] ]
applySelectOption[ graph_Graph, paths_, name_String, True,  _ ] :=
  SelectInfraWalk[ graph, paths, All, "From" -> selectFromName[ name ], "Cyclic" -> True ]
applySelectOption[ graph_Graph, paths_, name_String, False, _ ] :=
  SelectInfraWalk[ graph, paths, All, "From" -> selectFromName[ name ] ]

selectFromName[ "Central"    ] := "Center"
selectFromName[ "Peripheral" ] := "Periphery"
selectFromName[ name_String  ] := name


(* ===================== InfraDistance ===================== *)

(* the distance between the supports of two shapes, read by the anchor rule *)

Options[ InfraDistance ] = { "Aggregation" -> Min }

InfraDistance[ g_Graph, p_, q_, OptionsPattern[] ] :=
  OptionValue[ "Aggregation" ] @
    Flatten @ Outer[ GraphDistance[ g, #1, #2 ] &,
      Keys @ InfraDensity[ g, p ], Keys @ InfraDensity[ g, q ], 1 ]


(* ===================== InfraIntersection / InfraUnion ===================== *)

(* the vertex set of an intersection or union of shapes -- vertex lists, densities, walk graphs, bundles -- as a sorted List.  Graph-first, like every other public function here, because the anchor rule needs the substrate: without it a set of list-labelled vertices and a family of sets are the same expression, and the graphless reading returned the coordinates.  A symbol or an undispatched construction stays inert, so scene hypotheses are not perturbed *)

$infraRealisationPattern = _List | _Association | _Graph;

InfraIntersection[ graph_Graph, args__ ] /; AllTrue[ { args }, MatchQ[ $infraRealisationPattern ] ] :=
  Intersection @@ ( infraVertexSet[ graph, # ] & /@ { args } )

InfraUnion[ graph_Graph, args__ ] /; AllTrue[ { args }, MatchQ[ $infraRealisationPattern ] ] :=
  Union @@ ( infraVertexSet[ graph, # ] & /@ { args } )


(* ===================== Scene ===================== *)

InfraScene::badassertion = "`1` is not a scene assertion the graph can be \
injected into; it stays inert, so the scene would reject every branch without a \
message.";

(* Manual-step form: hypotheses contain explicit InfraGeometricStep blocks. *)
InfraScene[ objects_List, hypotheses_List ] /;
  MemberQ[ hypotheses, _InfraGeometricStep ] :=
  Module[ { gSteps, perStep, constructions, steps, labels, assertions },

    gSteps = Cases[ hypotheses, _InfraGeometricStep ];

    perStep = Map[
      gStep |-> With[ { hyps = gStep[[ 1 ]] },
        <| "Constructions" -> Association @ Cases[ hyps,
              ( key_ == rhs_ ) /; constructionPatternQ[ objects, key == rhs ] :> ( key -> rhs ) ],
           "Assertions" -> Select[ hyps, ! constructionPatternQ[ objects, # ] & ],
           "Label"      -> If[ Length @ gStep >= 2, gStep[[ 2 ]], None ] |> ],
      gSteps ];

    constructions = Join @@ ( #[ "Constructions" ] & /@ perStep );
    steps  = Flatten[ If[ ListQ @ #, #, { # } ] & /@ Keys @ #[ "Constructions" ] ] & /@ perStep;
    labels = #[ "Label" ] & /@ perStep;
    assertions = Join[
      Select[ hypotheses,
        h |-> ! MatchQ[ h, _InfraGeometricStep ] && ! constructionPatternQ[ objects, h ] ],
      Flatten[ #[ "Assertions" ] & /@ perStep ] ];

    With[ { undecidable = undecidableAssertions[ assertions ] },
      If[ undecidable =!= { },
        Message[ InfraScene::badassertion, First @ undecidable ];
        Return[ $Failed, Module ] ] ];

    InfraScene[ <|
      "Objects"         -> objects,
      "Constructions"   -> constructions,
      "Assertions"      -> assertions,
      "DependencyGraph" -> None,
      "Steps"           -> steps,
      "Labels"          -> labels,
      "ManualSteps"     -> True
    |> ]
  ]

(* auto-step form: the steps are the topological levels of the dependency DAG *)
InfraScene[ objects_List, hypotheses_List ] :=
  Module[ { constructions, assertions, dag, steps = { }, remaining },
    constructions = Association @ Cases[ hypotheses,
      ( key_ == rhs_ ) /; constructionPatternQ[ objects, key == rhs ] :> ( key -> rhs ) ];
    assertions = Select[ hypotheses, ! constructionPatternQ[ objects, # ] & ];
    With[ { undecidable = undecidableAssertions[ assertions ] },
      If[ undecidable =!= { },
        Message[ InfraScene::badassertion, First @ undecidable ];
        Return[ $Failed, Module ] ] ];
    dag = Graph[ objects,
      Flatten @ KeyValueMap[
        { key, rhs } |-> With[ {
            deps    = Intersection[ Cases[ rhs, Alternatives @@ objects, Infinity ], objects ],
            targets = If[ ListQ @ key, key, { key } ] },
          DirectedEdge[ #1, #2 ] & @@@ Tuples[ { deps, targets } ] ],
        constructions ],
      DirectedEdges -> True ];
    (* topological levels of the dependency DAG: each step is the current source set *)
    remaining = VertexList @ dag;
    While[ remaining =!= { },
      With[ { current = Select[ remaining,
          v |-> VertexInDegree[ Subgraph[ dag, remaining ], v ] == 0 ] },
        AppendTo[ steps, current ];
        remaining = Complement[ remaining, current ] ] ];
    InfraScene[ <|
      "Objects"         -> objects,
      "Constructions"   -> constructions,
      "Assertions"      -> assertions,
      "DependencyGraph" -> dag,
      "Steps"           -> steps,
      "Labels"          -> ConstantArray[ None, Length @ steps ],
      "ManualSteps"     -> False
    |> ]
  ]

InfraScene[ data_Association ][ prop_String ] := data[ prop ]


(* ===================== Instance accessors ===================== *)

InfraSceneInstance[ inst_InfraSceneInstance, sym_ ] /; ! ListQ[ sym ] :=
  inst[[ 1 ]][ sym ]

InfraSceneInstance[ inst_InfraSceneInstance, syms_List ] :=
  inst[[ 1 ]] /@ syms

InfraSceneInstance[ bindings_Association, sym_ ] /; ! ListQ[ sym ] :=
  bindings[ sym ]

InfraSceneInstance[ bindings_Association, syms_List ] :=
  bindings /@ syms


(* ===================== Construction Dispatch ===================== *)

(* maps an InfraHead expression with bindings already substituted into its concrete graph realization; the per-primitive scene-DSL rules live in the respective Infra*.wl files *)


(* ===================== Evaluation Engine ===================== *)


(* each operand is itself a construction, so it must be dispatched before its vertex set exists; an operand already bound to a vertex set has no dispatch rule and is read directly *)
evaluateConstruction[ graph_Graph, sym_, InfraIntersection[ objs__ ], bindings_Association ] :=
  Append[ bindings, sym -> # ] & /@
    Intersection @@ Map[
      obj |-> With[ { resolved = resolveExpression[ obj, bindings, graph ] },
        { realisations = dispatchConstruction[ graph, resolved ] },
        If[ ListQ[ realisations ],
          Union @@ ( infraVertexSet[ graph, # ] & /@ realisations ),
          infraVertexSet[ graph, resolved ] ] ],
      { objs } ]

evaluateConstruction[ graph_Graph, sym_, rhs_, bindings_Association ] :=
  With[ { results = dispatchConstruction[ graph, resolveExpression[ rhs, bindings, graph ] ] },
    (* a construction that yields no result simply stops propagating this branch *)
    If[ ! ListQ[ results ] || results === {} || results === {{}}, {},
      Append[ bindings, sym -> # ] & /@ results ] ]

evaluateConstruction[ graph_Graph, syms_List, rhs_, bindings_Association ] :=
  With[ { tuples = dispatchConstruction[ graph, resolveExpression[ rhs, bindings, graph ] ] },
    If[ ! ListQ[ tuples ] || tuples === {}, {},
      Join[ bindings, AssociationThread[ syms, # ] ] & /@ tuples ] ]

(* ===================== FindInfraScene ===================== *)

Options[ FindInfraScene ] = { "PruneProbability" -> 0 };

FindInfraScene[ scene_InfraScene, graph_Graph, opts : OptionsPattern[] ] :=
  FindInfraScene[ scene, graph, Length @ scene[ "Steps" ], <||>, opts ]

FindInfraScene[ scene_InfraScene, graph_Graph, nSteps_Integer, opts : OptionsPattern[] ] :=
  FindInfraScene[ scene, graph, nSteps, <||>, opts ]

FindInfraScene[ scene_InfraScene, graph_Graph, init_Association, opts : OptionsPattern[] ] :=
  FindInfraScene[ scene, graph, Length @ scene[ "Steps" ], init, opts ]

FindInfraScene[ scene_InfraScene, graph_Graph, nSteps_Integer, init_Association,
    opts : OptionsPattern[] ] :=
  Module[ { branches = { init }, prob = OptionValue[ "PruneProbability" ],
            objects = scene[ "Objects" ] },
    Do[
      With[ { effective = Select[ step,
          ! KeyExistsQ[ First[ branches, <||> ], # ] & ] },
        If[ effective =!= {},
          (* tuple-keyed constructions (sym lists) are evaluated last so their
             parts are not double-bound *)
          branches = With[ { constructions = scene[ "Constructions" ] },
            { tuplesInStep = Select[ Select[ Keys @ constructions, ListQ ],
                ContainsAny[ #, effective ] & ] },
            Fold[
              { currentBranches, key } |->
                Flatten[ evaluateConstruction[ graph, key, constructions[ key ], # ] & /@
                  currentBranches, 1 ],
              branches,
              Join[
                Select[ Complement[ effective, Flatten @ tuplesInStep ],
                  KeyExistsQ[ constructions, # ] & ],
                tuplesInStep ] ] ];
          If[ prob > 0,
            branches = With[ { kept = Pick[ branches,
                UnitStep[ RandomReal[ { 0, 1 }, Length @ branches ] - prob ], 1 ] },
              If[ kept === {}, { RandomChoice @ branches }, kept ] ] ] ] ],
      { step, Take[ scene[ "Steps" ], UpTo[ nSteps ] ] } ];
    InfraSceneInstance /@ If[ scene[ "Assertions" ] === {}, branches,
      Select[ branches, b |-> And @@ (
        With[ { vars = Intersection[
              Cases[ #, Alternatives @@ objects, { 0, Infinity } ], objects ] },
          ! SubsetQ[ Keys @ b, vars ] ||
            TrueQ[ resolveExpression[ #, b, graph ] ] ] & /@ scene[ "Assertions" ] ) ] ]
  ]


(* ===================== The shape readers ===================== *)

pointQ[ graph_Graph, x_ ] := VertexQ[ graph, x ]

closedWalkQ[ w_Graph ] := ! LoopFreeGraphQ[ w ] || ! AcyclicGraphQ[ w ]

positionSpelledQ[ w_Graph ] :=
  AllTrue[ VertexList @ w, MatchQ[ { _Integer, _ } ] ] &&
  Sort[ First /@ VertexList @ w ] === Range @ VertexCount @ w

(* the vertex sequence of one walk graph, the cyclic core of a closed one; a substrate path or cycle is read by following its edges from an end, or from its first vertex when it has none *)
walkSequence[ w_Graph ] := Which[
  positionSpelledQ @ w, Last /@ SortBy[ VertexList @ w, First ],
  EdgeCount[ w ] == 0,  VertexList @ w,
  True,
    With[ { start = SelectFirst[ VertexList @ w,
              If[ DirectedGraphQ @ w, VertexInDegree[ w, # ] == 0, VertexDegree[ w, # ] == 1 ] &,
              First @ VertexList @ w ],
            nextOf = If[ DirectedGraphQ @ w,
              { u, prev } |-> First[ VertexOutComponent[ w, { u }, { 1 } ], None ],
              { u, prev } |-> First[ DeleteCases[ AdjacencyList[ w, u ], prev ], None ] ] },
      { seq = TakeWhile[
          First /@ NestList[ { nextOf @@ #, First @ # } &, { start, None }, VertexCount @ w ],
          # =!= None & ] },
      If[ closedWalkQ @ w, Most @ seq, seq ] ] ]

(* the walks a graph stands for, as vertex sequences: one for a path graph or a cycle (closed, first vertex repeated at the end), the source -> sink paths for a DAG *)
walkRealisations[ w_Graph ] := Which[
  closedWalkQ @ w,      { closeWalk @ walkSequence @ w },
  positionSpelledQ @ w, Map[ Last, dagGeodesics @ w, { 2 } ],
  DirectedGraphQ @ w,   dagGeodesics @ w,
  True,                 { walkSequence @ w } ]

closeWalk[ cycle_List ] :=
  If[ First[ cycle ] === Last[ cycle ], cycle, Append[ cycle, First[ cycle ] ] ]

(* all source -> sink directed paths, the one exponential step, materialised on demand *)

dagGeodesics[ dag_Graph ] := Which[
  VertexCount[ dag ] == 0, { },
  EdgeCount[ dag ] == 0,   List /@ VertexList[ dag ],
  True,
    With[ { srcs = Select[ VertexList[ dag ], VertexInDegree[ dag, # ] == 0 & ],
            snks = Select[ VertexList[ dag ], VertexOutDegree[ dag, # ] == 0 & ] },
      DeleteDuplicates @ Catenate @ Catenate @
        Table[ FindPath[ dag, s, t, Infinity, All ], { s, srcs }, { t, snks } ] ] ]

walkVertexSet[ w_Graph ] :=
  Sort @ DeleteDuplicates @ If[ positionSpelledQ @ w, Last /@ VertexList @ w, VertexList @ w ]

(* the REALISATION spread, not the anchor rule: an Association spreads over its support, a walk graph into the vertex sequences it stands for, a list of graphs into all of theirs; anything else -- a bare vertex, and a walk or a set written as a vertex list -- is one realisation.  InfraDensity is where a List is read as a multiset *)

infraSpread[ fam_Association ]       := Keys @ fam
infraSpread[ w_Graph ]               := walkRealisations @ w
infraSpread[ ws : { __Graph } ]      := Catenate[ walkRealisations /@ ws ]
infraSpread[ { } ]                   := { }
infraSpread[ other_ ]                := { other }

vertexSet[ vs_List ] := Sort @ DeleteDuplicates @ vs

infraVertexSet[ fam_Association ]  := Keys @ fam
infraVertexSet[ w_Graph ]          := walkVertexSet @ w
infraVertexSet[ ws : { __Graph } ] := Union @@ ( walkVertexSet /@ ws )
infraVertexSet[ { } ]              := { }
infraVertexSet[ sets : { __List } ] := Union @@ ( infraVertexSet /@ sets )
infraVertexSet[ list_List ]        := vertexSet @ list
infraVertexSet[ v_ ]               := { v }

infraVertexSet[ graph_Graph, x_ ]  := Keys @ InfraDensity[ graph, x ]

(* consecutive legs share their endpoint, so Rest drops the duplicate when joining *)

polylineToVertexSeq[ { } ] := { }
polylineToVertexSeq[ legs : { __Graph } ] :=
  Fold[ Join[ #1, Rest @ walkSequence @ #2 ] &, walkSequence @ First @ legs, Rest @ legs ]

(* the scene engine's circle ranking *)

embeddingClosestCycles[ graph_Graph, cycles_List, center_, radius_ ] /; Length[ cycles ] <= 1 := cycles

embeddingClosestCycles[ graph_Graph, cycles_List, center_, radius_ ] :=
  With[ { coords = resolveEmbeddingCoords[ graph, Automatic ],
          vertexIndex = AssociationThread[ VertexList[ graph ], Range @ VertexCount[ graph ] ] },
    { centerIdx = vertexIndex[ center ] },
    MinimalBy[ cycles,
      cycle |-> EmbeddingCircleDistance[ coords, Lookup[ vertexIndex, cycle ], centerIdx, radius ] ]
  ]


(* plane Hausdorff between the embedded closed polyline of a cycle and the Euclidean circle *)

EmbeddingCircleDistance[ coords_List, cycle_List, centerIdx_Integer, radius_ ] /; Length[ cycle ] >= 3 :=
  With[ { centerPt = coords[[ centerIdx ]], cyclePts = coords[[ cycle ]] },
    { nPts = Max[ 64, 4 * Length[ cycle ] ] },
    { circlePoints = Table[
        centerPt + radius * { Cos[ t ], Sin[ t ] },
        { t, 0, 2 Pi - 2 Pi / nPts, 2 Pi / nPts } ] },
    RegionHausdorffDistance[
      Line[ Append[ cyclePts, First[ cyclePts ] ] ],
      Line[ Append[ circlePoints, First[ circlePoints ] ] ] ]
  ]

EmbeddingCircleDistance[ _List, cycle_List, _Integer, _ ] /; Length[ cycle ] < 3 := Infinity


(* Automatic = GraphEmbedding under SpringEmbedding, the closest built-in to the edge-length-preserving criterion *)

resolveEmbeddingCoords[ graph_Graph, Automatic ] :=
  GraphEmbedding[ Graph[ graph, GraphLayout -> "SpringEmbedding" ] ]
resolveEmbeddingCoords[ _, coords_List ] := coords
