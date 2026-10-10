Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraScene *)

PackageScope[ sceneAssertionRules ]
PackageScope[ resolveExpression ]
PackageScope[ extractBranches ]
PackageScope[ capBranches ]
PackageScope[ applySelectOption ]
PackageScope[ constructionPatternQ ]
PackageScope[ selectContext ]
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
    InfraInfiniteLineQ[ s_ ]             :> InfraInfiniteLineQ[ graph, s ],
    InfraLineQ[ s_ ] :> InfraInfiniteLineQ[ graph, s ],
    InfraHalfLineQ[ s_ ] :> InfraHalfLineQ[ graph, s ],
    InfraRayQ[ s_ ] :> InfraHalfLineQ[ graph, s ],
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

selectContext[ _Graph, ( InfraCircle | InfraShell | InfraSphere )[ c_, rs_, ___ ] ] :=
  <| "Center" -> c, "Radius" -> Mean @ Flatten @ { rs } |>

selectContext[ graph_Graph, InfraArc[ c_, { p_, ___, p_ } | { p_ }, opts___Rule ] ] :=
  With[ { r = GraphDistance[ graph, c, p ],
          delta = Replace[ Lookup[ { opts }, "RadiusDelta", 0 ], d : Except[ _List ] :> { 0, d } ] },
    <| "Center" -> c, "Radius" -> Mean @ { Max[ 1, r - First @ delta ], r + Last @ delta } |> ]

selectContext[ _Graph, InfraArc[ _, pts_List, ___ ] ] :=
  <| "Endpoints" -> { First @ pts, Last @ pts } |>

selectContext[ _Graph, ( InfraInfiniteLine | InfraLine )[ path_List, ___ ] ] :=
  <| "Endpoints" -> { First @ path, Last @ path } |>

selectContext[ _Graph, ( InfraSegment | InfraHalfLine | InfraRay | InfraInfiniteLine | InfraLine | InfraPlane )[ p1_, p2_, ___ ] ] :=
  <| "Endpoints" -> { p1, p2 } |>

selectContext[ _, _ ] :=
  <| |>

Options[ InfraDistance ] = { "Aggregation" -> Min }

InfraDistance[ graph_Graph, p_, q_, opts : OptionsPattern[] ] /;
    SubsetQ[ { "Aggregation" }, First /@ { opts } ] :=
  With[ { densities = Map[ object |-> Which[
      VertexQ[ graph, object ], <| object -> 1 |>,
      GraphQ[ object ] && AllTrue[ VertexList[ object ], vertex |-> VertexQ[ graph, vertex ] ], Counts[ VertexList[ object ] ],
      MatchQ[ object, _List | _Association | _Graph | _InfraMidpoint | _InfraPerpendicularBisector | _InfraRegionNearest ],
        InfraDensity[ graph, object ],
      True, Quiet[ InfraMeasurement[ graph, object, "VertexDensity" ] ] ], { p, q } ] },
    With[ { vertices = VertexList[ graph ] },
      { indices = AssociationThread[ vertices, Range[ Length[ vertices ] ] ],
        indexedGraph = VertexReplace[ graph, Thread[ vertices -> Range[ Length[ vertices ] ] ] ],
        supports = Keys /@ Map[ density |-> Select[ density, value |-> value != 0 ], densities ] },
      OptionValue[ "Aggregation" ] @ Flatten @ Outer[
        { source, target } |-> GraphDistance[ indexedGraph, Lookup[ indices, Key[ source ] ], Lookup[ indices, Key[ target ] ] ],
        supports[[ 1 ]], supports[[ 2 ]], 1 ] ] /;
      AllTrue[ densities, density |-> AssociationQ[ density ] && AllTrue[ Values[ density ], NumericQ ] &&
        AllTrue[ Keys[ density ], vertex |-> VertexQ[ graph, vertex ] ] ] ]

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

Options[ RandomInfraInstance ] = { "NextVertexFunction" -> Automatic, "Steps" -> All }

RandomInfraInstance[ scene_InfraScene, graph_Graph,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    init : _Association : <| |>, opts : OptionsPattern[] ] /;
    count =!= All || OptionValue[ RandomInfraInstance, { opts }, "NextVertexFunction" ] =!= RandomChoice :=
  With[ { result = Catch[
    With[ { cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ],
          objects = scene[ "Objects" ], constructions = scene[ "Constructions" ],
          steps = Replace[ OptionValue[ "Steps" ], n_Integer :> UpTo[ n ] ],
          nextFunction = Replace[ OptionValue[ "NextVertexFunction" ],
            Automatic -> If[ count === All, Identity, RandomSample ] ] },
    { pool = expression |-> With[ { settings = Cases[ expression, _Rule ],
        token = DeleteCases[ expression, ( "Select" | "Branches" ) -> _ ] },
      { members = Which[
          VertexQ[ graph, token ], { token },
          ListQ[ token ] && SubsetQ[ VertexList @ graph, token ], token,
          AssociationQ[ token ] && SubsetQ[ VertexList @ graph, Keys @ token ], Keys @ token,
          True, Replace[ token, {
        token_InfraPoint :> RandomInfraPoint[ graph, token, All ],
        token_InfraSegment :> RandomInfraSegment[ graph, token, All ],
        token_InfraHalfLine :> RandomInfraHalfLine[ graph, token, All ],
        token_InfraInfiniteLine :> RandomInfraInfiniteLine[ graph, token, All ],
        token_InfraCircle :> RandomInfraCircle[ graph, token, All ],
        token_InfraArc :> RandomInfraArc[ graph, token, All ],
        token_InfraRegularPolygon :> RandomInfraRegularPolygon[ graph, token, All ],
        token_InfraPlane :> RandomInfraPlane[ graph, token, All ],
        token_InfraBall :> RandomInfraBall[ graph, token, All ],
        token_InfraShell :> RandomInfraShell[ graph, token, All ],
        token_InfraSphere :> RandomInfraSphere[ graph, token, All ],
        token_InfraTube :> RandomInfraTube[ graph, token, All ],
        token_InfraCylinder :> RandomInfraCylinder[ graph, token, All ],
        token_InfraCone :> RandomInfraCone[ graph, token, All ],
        token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ graph, token, All ],
        token_InfraBallHull :> RandomInfraBallHull[ graph, token, All ],
        token_InfraConvexHull :> RandomInfraConvexHull[ graph, token, All ],
        token_InfraQuadric :> RandomInfraQuadric[ graph, token, All ],
        token_InfraWalk :> RandomInfraWalk[ graph, token, All ],
        token_InfraGeodesic :> RandomInfraGeodesic[ graph, token, All ],
        token_InfraEllipse :> RandomInfraEllipse[ graph, token, All ],
        token_InfraIntersection :> RandomInfraIntersection[ graph, token, All ],
        token_InfraUnion :> RandomInfraUnion[ graph, token, All ],
        token_InfraRay :> RandomInfraHalfLine[ graph, token, All ],
        token_InfraLine :> RandomInfraInfiniteLine[ graph, token, All ],
        token_InfraPolygon :> RandomInfraRegularPolygon[ graph, token, All ] } ] ] },
      If[ ListQ[ members ],
        capBranches[ applySelectOption[ graph, members, Lookup[ settings, "Select", None ],
          MatchQ[ token, ( InfraCircle | InfraRegularPolygon | InfraPolygon )[ __ ] | InfraArc[ _, { p_, ___, p_ } | { _ }, ___ ] ],
          selectContext[ graph, token ] ], Lookup[ settings, "Branches", All ] ], members ] ] },
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
                    Select[ With[ { members = pool[ resolveExpression[ constructions[ key ], bindings, graph ] ] },
                      If[ ListQ[ members ],
                        If[ ListQ[ key ], Join[ bindings, AssociationThread[ key, # ] ] & /@ members,
                          Append[ bindings, key -> # ] & /@ members ],
                        Throw[ "UnsupportedConstruction", "UnsupportedConstruction" ] ] ],
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
      _, instances ] ], "UnsupportedConstruction" ] },
    result /; result =!= "UnsupportedConstruction" ]

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

Options[ RandomInfraIntersection ] = { "NextVertexFunction" -> Automatic }

RandomInfraIntersection[ graph_Graph, InfraIntersection[ objects__ ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[] ] :=
  RandomInfraIntersection[ graph, { objects }, count, opts ]

RandomInfraIntersection[ graph_Graph, objects : { __ },
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[] ] /;
    MemberQ[ { Automatic, Identity }, OptionValue[ RandomInfraIntersection, { opts }, "NextVertexFunction" ] ] &&
    SubsetQ[ First /@ Options[ RandomInfraIntersection ], First /@ { opts } ] :=
  With[ { supports = Map[ object |-> Which[
      VertexQ[ graph, object ], { object },
      MatchQ[ object, _List | _Association | _Graph ], Keys @ Select[ InfraDensity[ graph, object ], # != 0 & ],
      True, Replace[ object, {
        token_InfraCircle :> Union @@ RandomInfraCircle[ graph, token, All ],
        token_InfraPlane :> Union @@ RandomInfraPlane[ graph, token, All ],
        token : _InfraRegularPolygon | _InfraPolygon :> Union @@ RandomInfraRegularPolygon[ graph, token, All ],
        token_InfraEllipse :> Union @@ ( VertexList /@ RandomInfraEllipse[ graph, token, All ] ),
        token_InfraWalk :> Union @@ RandomInfraWalk[ graph, token, All ],
        token_InfraGeodesic :> Union @@ RandomInfraGeodesic[ graph, token, All ],
        token_InfraIntersection :> RandomInfraIntersection[ graph, token, All ],
        token_InfraUnion :> RandomInfraUnion[ graph, token, All ],
        token : ( InfraPoint | InfraSegment | InfraHalfLine | InfraRay | InfraInfiniteLine | InfraLine | InfraArc |
          InfraBall | InfraShell | InfraSphere | InfraTube | InfraCylinder | InfraCone | InfraSolidOfRevolution |
          InfraBallHull | InfraConvexHull | InfraQuadric )[ ___ ] :>
            Keys @ Select[ InfraMeasurement[ graph, token, "VertexDensity" ], # != 0 & ] } ] ], objects ] },
    { members = Intersection @@ supports },
    Which[
      count === Automatic, If[ members === { }, { },
        If[ OptionValue[ "NextVertexFunction" ] === Identity, First @ members, RandomChoice @ members ] ],
      count === All, members,
      IntegerQ[ count ] && Length[ members ] < count, { },
      OptionValue[ "NextVertexFunction" ] === Identity, Take[ members, count ],
      True, RandomSample[ members, count ] ] /; AllTrue[ supports, ListQ ] ]

Options[ RandomInfraUnion ] = { "NextVertexFunction" -> Automatic }

RandomInfraUnion[ graph_Graph, InfraUnion[ objects__ ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[] ] :=
  RandomInfraUnion[ graph, { objects }, count, opts ]

RandomInfraUnion[ graph_Graph, objects : { __ },
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[] ] /;
    MemberQ[ { Automatic, Identity }, OptionValue[ RandomInfraUnion, { opts }, "NextVertexFunction" ] ] &&
    SubsetQ[ First /@ Options[ RandomInfraUnion ], First /@ { opts } ] :=
  With[ { supports = Map[ object |-> Which[
      VertexQ[ graph, object ], { object },
      MatchQ[ object, _List | _Association | _Graph ], Keys @ Select[ InfraDensity[ graph, object ], # != 0 & ],
      True, Replace[ object, {
        token_InfraCircle :> Union @@ RandomInfraCircle[ graph, token, All ],
        token_InfraPlane :> Union @@ RandomInfraPlane[ graph, token, All ],
        token : _InfraRegularPolygon | _InfraPolygon :> Union @@ RandomInfraRegularPolygon[ graph, token, All ],
        token_InfraEllipse :> Union @@ ( VertexList /@ RandomInfraEllipse[ graph, token, All ] ),
        token_InfraWalk :> Union @@ RandomInfraWalk[ graph, token, All ],
        token_InfraGeodesic :> Union @@ RandomInfraGeodesic[ graph, token, All ],
        token_InfraIntersection :> RandomInfraIntersection[ graph, token, All ],
        token_InfraUnion :> RandomInfraUnion[ graph, token, All ],
        token : ( InfraPoint | InfraSegment | InfraHalfLine | InfraRay | InfraInfiniteLine | InfraLine | InfraArc |
          InfraBall | InfraShell | InfraSphere | InfraTube | InfraCylinder | InfraCone | InfraSolidOfRevolution |
          InfraBallHull | InfraConvexHull | InfraQuadric )[ ___ ] :>
            Keys @ Select[ InfraMeasurement[ graph, token, "VertexDensity" ], # != 0 & ] } ] ], objects ] },
    { members = Union @@ supports },
    Which[
      count === Automatic, If[ members === { }, { },
        If[ OptionValue[ "NextVertexFunction" ] === Identity, First @ members, RandomChoice @ members ] ],
      count === All, members,
      IntegerQ[ count ] && Length[ members ] < count, { },
      OptionValue[ "NextVertexFunction" ] === Identity, Take[ members, count ],
      True, RandomSample[ members, count ] ] /; AllTrue[ supports, ListQ ] ]
