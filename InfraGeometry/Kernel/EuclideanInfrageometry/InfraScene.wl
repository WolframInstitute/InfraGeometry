Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraScene *)

PackageScope[ sceneAssertionRules ]
PackageScope[ resolveExpression ]
PackageScope[ extractBranches ]
PackageScope[ capBranches ]
PackageScope[ applySelectOption ]
PackageScope[ constructionPatternQ ]
PackageScope[ dispatchConstruction ]
PackageScope[ selectContext ]
PackageScope[ evaluateConstruction ]
PackageScope[ pointQ ]
PackageScope[ closedWalkQ ]
PackageScope[ positionSpelledQ ]
PackageScope[ walkSequence ]
PackageScope[ walkRealisations ]
PackageScope[ closeWalk ]
PackageScope[ dagGeodesics ]
PackageScope[ walkVertexSet ]
PackageScope[ infraSpread ]
PackageScope[ vertexSet ]
PackageScope[ infraVertexSet ]
PackageScope[ polylineToVertexSeq ]
PackageScope[ embeddingClosestCycles ]
PackageScope[ EmbeddingCircleDistance ]
PackageScope[ resolveEmbeddingCoords ]

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
    InfraRegularPolygonQ[ c_, as_ ] :> InfraRegularPolygonQ[ graph, c, as ],
    InfraMemberQ[ obj_, vs_ ]    :> InfraMemberQ[ graph, obj, vs ] }

resolveExpression[ expr_, bindings_Association, graph_Graph ] :=
  ( expr /. Normal[ bindings ] ) /. sceneAssertionRules[ graph ]

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

capBranches[ paths_List, All ]              :=
  paths
capBranches[ paths_List, n_Integer ]        :=
  Take[ paths, UpTo[ n ] ]
capBranches[ paths_List, UpTo[ n_Integer ] ] :=
  Take[ paths, UpTo[ n ] ]
capBranches[ other_, _ ]                    :=
  other

applySelectOption[ _Graph, paths_, None, _, _ ] :=
  paths
applySelectOption[ graph_Graph, paths_, list_List, cyclic_, ctx_ ] :=
  Fold[ applySelectOption[ graph, #1, #2, cyclic, ctx ] &, paths, list ]
applySelectOption[ graph_Graph, paths_, "EmbeddingClosest", True,  ctx_ ] :=
  embeddingClosestCycles[ graph, paths, ctx[ "Center" ], ctx[ "Radius" ] ]
applySelectOption[ graph_Graph, paths_, "EmbeddingClosest", False, KeyValuePattern[ "Endpoints" -> { p_, q_ } ] ] :=
  EmbeddingClosest[ graph, paths,
    Line @ resolveEmbeddingCoords[ graph, Automatic ][[ VertexIndex[ graph, # ] & /@ { p, q } ]] ]
applySelectOption[ graph_Graph, paths_, name_String, True,  _ ] :=
  SelectInfraWalk[ graph, paths, All, "From" -> selectFromName[ name ], "Cyclic" -> True ]
applySelectOption[ graph_Graph, paths_, name_String, False, _ ] :=
  SelectInfraWalk[ graph, paths, All, "From" -> selectFromName[ name ] ]

selectFromName[ "Central"    ] :=
  "Center"
selectFromName[ "Peripheral" ] :=
  "Periphery"
selectFromName[ name_String  ] :=
  name

dispatchConstruction[ graph_Graph, vs_List ] /;
    vs =!= { } && ! pointQ[ graph, vs ] && SubsetQ[ VertexList @ graph, vs ] :=
  vs

dispatchConstruction[ graph_Graph, fam_Association ] /;
    Length[ fam ] > 0 && SubsetQ[ VertexList @ graph, Keys @ fam ] :=
  Keys @ fam

dispatchConstruction[ graph_Graph, token : Except[ _List | _Association ] ] :=
  With[ { opts = Cases[ token, _Rule ] },
    { head = DeleteCases[ token, ( "Select" | "Branches" ) -> _ ] },
    { members = RandomInfraRepresentative[ graph, head, All ] },
    If[ ListQ @ members,
      capBranches[
        applySelectOption[ graph, members, Lookup[ opts, "Select", None ],
          MatchQ[ head, InfraCircle[ __ ] | InfraPolygon[ _List, _Integer, ___ ] | InfraArc[ _, { p_, ___, p_ } | { _ }, ___ ] ],
          selectContext[ graph, head ] ],
        Lookup[ opts, "Branches", All ] ],
      members ] ]

selectContext[ _Graph, ( InfraCircle | InfraShell | InfraSphere )[ c_, rs_, ___ ] ] :=
  <| "Center" -> c, "Radius" -> Mean @ Flatten @ { rs } |>

selectContext[ graph_Graph, InfraArc[ c_, { p_, ___, p_ } | { p_ }, opts___Rule ] ] :=
  With[ { r = GraphDistance[ graph, c, p ],
          delta = Replace[ Lookup[ { opts }, "RadiusDelta", 0 ], d : Except[ _List ] :> { 0, d } ] },
    <| "Center" -> c, "Radius" -> Mean @ { Max[ 1, r - First @ delta ], r + Last @ delta } |> ]

selectContext[ _Graph, InfraArc[ _, pts_List, ___ ] ] :=
  <| "Endpoints" -> { First @ pts, Last @ pts } |>

selectContext[ _Graph, InfraLine[ path_List, ___ ] ] :=
  <| "Endpoints" -> { First @ path, Last @ path } |>

selectContext[ _Graph, ( InfraSegment | InfraRay | InfraLine | InfraPlane )[ p1_, p2_, ___ ] ] :=
  <| "Endpoints" -> { p1, p2 } |>

selectContext[ _, _ ] :=
  <| |>

Options[ InfraDistance ] = { "Aggregation" -> Min }

InfraDistance[ g_Graph, p_, q_, OptionsPattern[] ] :=
  OptionValue[ "Aggregation" ] @
    Flatten @ Outer[ GraphDistance[ g, #1, #2 ] &,
      Keys @ InfraDensity[ g, p ], Keys @ InfraDensity[ g, q ], 1 ]

$infraRealisationPattern = _List | _Association | _Graph

InfraIntersection[ graph_Graph, args__ ] /; AllTrue[ { args }, MatchQ[ $infraRealisationPattern ] ] :=
  Intersection @@ ( infraVertexSet[ graph, # ] & /@ { args } )

InfraUnion[ graph_Graph, args__ ] /; AllTrue[ { args }, MatchQ[ $infraRealisationPattern ] ] :=
  Union @@ ( infraVertexSet[ graph, # ] & /@ { args } )

InfraScene[ objects_List, hypotheses_List ] /;
  MemberQ[ hypotheses, _InfraStep ] &&
    undecidableAssertions[ Select[ Join[ DeleteCases[ hypotheses, _InfraStep ], Catenate[ First /@ Cases[ hypotheses, _InfraStep ] ] ],
      ! constructionPatternQ[ objects, # ] & ] ] === { } :=
  With[ { gSteps = Cases[ hypotheses, _InfraStep ] },
    { perStep = Map[
        gStep |-> With[ { hyps = gStep[[ 1 ]] },
          <| "Constructions" -> Association @ Cases[ hyps,
                ( key_ == rhs_ ) /; constructionPatternQ[ objects, key == rhs ] :> ( key -> rhs ) ],
             "Assertions" -> Select[ hyps, ! constructionPatternQ[ objects, # ] & ],
             "Label"      -> If[ Length @ gStep >= 2, gStep[[ 2 ]], None ] |> ],
        gSteps ] },
    { constructions = Join @@ ( #[ "Constructions" ] & /@ perStep ),
      steps         = Flatten[ If[ ListQ @ #, #, { # } ] & /@ Keys @ #[ "Constructions" ] ] & /@ perStep,
      labels        = #[ "Label" ] & /@ perStep,
      assertions    = Join[
        Select[ hypotheses, h |-> ! MatchQ[ h, _InfraStep ] && ! constructionPatternQ[ objects, h ] ],
        Flatten[ #[ "Assertions" ] & /@ perStep ] ] },
    InfraScene[ <|
      "Objects"         -> objects,
      "Constructions"   -> constructions,
      "Assertions"      -> assertions,
      "DependencyGraph" -> None,
      "Steps"           -> steps,
      "Labels"          -> labels,
      "ManualSteps"     -> True
    |> ] ]

InfraScene[ objects_List, hypotheses_List ] /;
    undecidableAssertions[ Select[ Join[ DeleteCases[ hypotheses, _InfraStep ], Catenate[ First /@ Cases[ hypotheses, _InfraStep ] ] ],
      ! constructionPatternQ[ objects, # ] & ] ] === { } :=
  With[ {
      constructions = Association @ Cases[ hypotheses,
        ( key_ == rhs_ ) /; constructionPatternQ[ objects, key == rhs ] :> ( key -> rhs ) ],
      assertions = Select[ hypotheses, ! constructionPatternQ[ objects, # ] & ] },
    { dag = Graph[ objects,
        Flatten @ KeyValueMap[
          { key, rhs } |-> With[ {
              deps    = Intersection[ Cases[ rhs, Alternatives @@ objects, Infinity ], objects ],
              targets = If[ ListQ @ key, key, { key } ] },
            DirectedEdge[ #1, #2 ] & @@@ Tuples[ { deps, targets } ] ],
          constructions ],
        DirectedEdges -> True ] },
    { steps = First @ NestWhile[
        Apply[ { done, remaining } |->
          With[ { current = Select[ remaining, v |-> VertexInDegree[ Subgraph[ dag, remaining ], v ] == 0 ] },
            { Append[ done, current ], Complement[ remaining, current ] } ] ],
        { { }, VertexList @ dag },
        state |-> Last @ state =!= { } ] },
    InfraScene[ <|
      "Objects"         -> objects,
      "Constructions"   -> constructions,
      "Assertions"      -> assertions,
      "DependencyGraph" -> dag,
      "Steps"           -> steps,
      "Labels"          -> ConstantArray[ None, Length @ steps ],
      "ManualSteps"     -> False
    |> ] ]

InfraScene[ data_Association ][ prop_String ] :=
  data[ prop ]

InfraSceneInstance[ inst_InfraSceneInstance, sym_ ] /; ! ListQ[ sym ] :=
  inst[[ 1 ]][ sym ]

InfraSceneInstance[ inst_InfraSceneInstance, syms_List ] :=
  inst[[ 1 ]] /@ syms

InfraSceneInstance[ bindings_Association, sym_ ] /; ! ListQ[ sym ] :=
  bindings[ sym ]

InfraSceneInstance[ bindings_Association, syms_List ] :=
  bindings /@ syms

evaluateConstruction[ graph_Graph, sym_, ( head : InfraIntersection | InfraUnion )[ objs__ ], bindings_Association ] :=
  Append[ bindings, sym -> # ] & /@
    Replace[ head, { InfraIntersection -> Intersection, InfraUnion -> Union } ] @@ Map[
      obj |-> With[ { resolved = resolveExpression[ obj, bindings, graph ] },
        { realisations = dispatchConstruction[ graph, resolved ] },
        If[ ListQ[ realisations ],
          Union @@ ( infraVertexSet[ graph, # ] & /@ realisations ),
          infraVertexSet[ graph, resolved ] ] ],
      { objs } ]

evaluateConstruction[ graph_Graph, sym_, rhs_, bindings_Association ] :=
  With[ { results = dispatchConstruction[ graph, resolveExpression[ rhs, bindings, graph ] ] },
    If[ ! ListQ[ results ] || results === {} || results === { {} }, {},
      Append[ bindings, sym -> # ] & /@ results ] ]

evaluateConstruction[ graph_Graph, syms_List, rhs_, bindings_Association ] :=
  With[ { tuples = dispatchConstruction[ graph, resolveExpression[ rhs, bindings, graph ] ] },
    If[ ! ListQ[ tuples ] || tuples === {}, {},
      Join[ bindings, AssociationThread[ syms, # ] ] & /@ tuples ] ]

Options[ RandomInfraInstance ] = { "NextVertexFunction" -> Automatic, "Steps" -> All }

RandomInfraInstance[ scene_InfraScene, graph_Graph,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic,
    init : _Association : <| |>, opts : OptionsPattern[] ] /;
    count =!= All || OptionValue[ RandomInfraInstance, { opts }, "NextVertexFunction" ] =!= RandomChoice :=
  With[ { cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ],
          objects = scene[ "Objects" ], constructions = scene[ "Constructions" ],
          steps = Replace[ OptionValue[ "Steps" ], n_Integer :> UpTo[ n ] ],
          nextFunction = Replace[ OptionValue[ "NextVertexFunction" ],
            Automatic -> If[ count === All, Identity, RandomSample ] ] },
    { keys = Catenate @ Map[
        step |-> With[ { effective = Select[ step, ! KeyExistsQ[ init, # ] & ] },
          { tuples = Select[ Select[ Keys @ constructions, ListQ ], ContainsAny[ #, effective ] & ] },
          Join[ Select[ Complement[ effective, Flatten @ tuples ], KeyExistsQ[ constructions, # ] & ], tuples ] ],
        Take[ scene[ "Steps" ], steps ] ],
      assertions = { #, Intersection[ Cases[ #, Alternatives @@ objects, { 0, Infinity } ], objects ] } & /@
        scene[ "Assertions" ] },
    { instances = Keys @ Last @ NestWhile[
        Apply[ { stack, found } |-> With[ { bindings = stack[[ 1, 1 ]], index = stack[[ 1, 2 ]] },
          Which[
            cap === 0,
              { { }, found },
            ! AllTrue[ assertions,
                assertion |-> ! SubsetQ[ Keys @ bindings, Last @ assertion ] ||
                  TrueQ[ resolveExpression[ First @ assertion, bindings, graph ] ] ],
              { Rest @ stack, found },
            index > Length @ keys,
              { Rest @ stack, Append[ found, InfraSceneInstance[ bindings ] -> Null ] },
            True,
              With[ { key = keys[[ index ]] },
                { targets = If[ ListQ @ key, key, { key } ] },
                { candidates = If[ AllTrue[ targets, KeyExistsQ[ bindings, # ] & ],
                    { bindings },
                    Select[ evaluateConstruction[ graph, key, constructions[ key ], bindings ],
                      candidate |-> AllTrue[ Intersection[ targets, Keys @ bindings ],
                        target |-> candidate[ target ] === bindings[ target ] ] ] ] },
                { next = If[ candidates === { }, { },
                    Replace[ nextFunction @ candidates, binding_Association :> { binding } ] ] },
                { Join[ { #, index + 1 } & /@ next, Rest @ stack ], found } ] ] ] ],
        { { { init, 1 } }, <| |> },
        state |-> First @ state =!= { } && Length[ Last @ state ] < cap ] },
    Switch[ count,
      Automatic, First[ instances, { } ],
      _Integer, If[ Length @ instances < count, { }, instances ],
      _, instances ] ]

pointQ[ graph_Graph, x_ ] :=
  VertexQ[ graph, x ]

closedWalkQ[ w_Graph ] :=
  ! LoopFreeGraphQ[ w ] || ! AcyclicGraphQ[ w ]

positionSpelledQ[ w_Graph ] :=
  AllTrue[ VertexList @ w, MatchQ[ { _Integer, _ } ] ] &&
  Sort[ First /@ VertexList @ w ] === Range @ VertexCount @ w

walkSequence[ w_Graph ] :=
  Which[
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

walkRealisations[ w_Graph ] :=
  Which[
    closedWalkQ @ w,      { closeWalk @ walkSequence @ w },
    positionSpelledQ @ w, Map[ Last, dagGeodesics @ w, { 2 } ],
    DirectedGraphQ @ w,   dagGeodesics @ w,
    True,                 { walkSequence @ w } ]

closeWalk[ cycle_List ] :=
  If[ First[ cycle ] === Last[ cycle ], cycle, Append[ cycle, First[ cycle ] ] ]

dagGeodesics[ dag_Graph ] :=
  Which[
    VertexCount[ dag ] == 0, { },
    EdgeCount[ dag ] == 0,   List /@ VertexList[ dag ],
    True,
      With[ { srcs = Select[ VertexList[ dag ], VertexInDegree[ dag, # ] == 0 & ],
              snks = Select[ VertexList[ dag ], VertexOutDegree[ dag, # ] == 0 & ] },
        DeleteDuplicates @ Catenate @ Catenate @
          Table[ FindPath[ dag, s, t, Infinity, All ], { s, srcs }, { t, snks } ] ] ]

walkVertexSet[ w_Graph ] :=
  Sort @ DeleteDuplicates @ If[ positionSpelledQ @ w, Last /@ VertexList @ w, VertexList @ w ]

infraSpread[ fam_Association ]       :=
  Keys @ fam
infraSpread[ w_Graph ]               :=
  walkRealisations @ w
infraSpread[ ws : { __Graph } ]      :=
  Catenate[ walkRealisations /@ ws ]
infraSpread[ { } ]                   :=
  { }
infraSpread[ other_ ]                :=
  { other }

vertexSet[ vs_List ] :=
  Sort @ DeleteDuplicates @ vs

infraVertexSet[ fam_Association ]  :=
  Keys @ fam
infraVertexSet[ w_Graph ]          :=
  walkVertexSet @ w
infraVertexSet[ ws : { __Graph } ] :=
  Union @@ ( walkVertexSet /@ ws )
infraVertexSet[ { } ]              :=
  { }
infraVertexSet[ sets : { __List } ] :=
  Union @@ ( infraVertexSet /@ sets )
infraVertexSet[ list_List ]        :=
  vertexSet @ list
infraVertexSet[ v_ ]               :=
  { v }

infraVertexSet[ graph_Graph, x_ ]  :=
  Keys @ InfraDensity[ graph, x ]

polylineToVertexSeq[ { } ] :=
  { }
polylineToVertexSeq[ legs : { __Graph } ] :=
  Fold[ Join[ #1, Rest @ walkSequence @ #2 ] &, walkSequence @ First @ legs, Rest @ legs ]

embeddingClosestCycles[ graph_Graph, cycles_List, center_, radius_ ] /; Length[ cycles ] <= 1 :=
  cycles

embeddingClosestCycles[ graph_Graph, cycles_List, center_, radius_ ] :=
  With[ { coords = resolveEmbeddingCoords[ graph, Automatic ],
          vertexIndex = AssociationThread[ VertexList[ graph ], Range @ VertexCount[ graph ] ] },
    { centerIdx = vertexIndex[ center ] },
    MinimalBy[ cycles,
      cycle |-> EmbeddingCircleDistance[ coords, Lookup[ vertexIndex, cycle ], centerIdx, radius ] ]
  ]

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

EmbeddingCircleDistance[ _List, cycle_List, _Integer, _ ] /; Length[ cycle ] < 3 :=
  Infinity

resolveEmbeddingCoords[ graph_Graph, Automatic ] :=
  GraphEmbedding[ Graph[ graph, GraphLayout -> "SpringEmbedding" ] ]
resolveEmbeddingCoords[ _, coords_List ] :=
  coords
