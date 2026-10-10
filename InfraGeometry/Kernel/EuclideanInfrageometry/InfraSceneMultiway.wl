Package[ "WolframInstitute`InfraGeometry`" ]

Options[ InfraSceneMultiway ] = {
  "Steps" -> All, "MaxDepth" -> Infinity, "MaxStates" -> Infinity,
  "MaxEvents" -> Infinity, "MaxCandidates" -> Infinity, "MaxTime" -> Infinity }

InfraSceneMultiway[ scene_InfraScene, graph_Graph, init : _Association : <| |>, opts : OptionsPattern[] ] /;
    AssociationQ[ First[ scene ] ] && UndirectedGraphQ[ graph ] && SimpleGraphQ[ graph ] && ! WeightedGraphQ[ graph ] &&
    SubsetQ[ First /@ Options[ InfraSceneMultiway ], First /@ { opts } ] &&
    MatchQ[ OptionValue[ InfraSceneMultiway, { opts }, "Steps" ], All | _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] ] &&
    AllTrue[ ( name |-> OptionValue[ InfraSceneMultiway, { opts }, name ] ) /@ { "MaxDepth", "MaxEvents", "MaxCandidates" },
      value |-> value === Infinity || ( IntegerQ[ value ] && value >= 0 ) ] &&
    ( OptionValue[ InfraSceneMultiway, { opts }, "MaxStates" ] === Infinity || ( IntegerQ[ OptionValue[ InfraSceneMultiway, { opts }, "MaxStates" ] ] && OptionValue[ InfraSceneMultiway, { opts }, "MaxStates" ] > 0 ) ) &&
    ( OptionValue[ InfraSceneMultiway, { opts }, "MaxTime" ] === Infinity || ( NumericQ[ OptionValue[ InfraSceneMultiway, { opts }, "MaxTime" ] ] && OptionValue[ InfraSceneMultiway, { opts }, "MaxTime" ] > 0 ) ) :=
  With[ { result = Catch[ Module[
    { objects = scene[ "Objects" ], constructions = scene[ "Constructions" ], groups = scene[ "Steps" ],
      assertions = scene[ "Assertions" ], settings = Association[ Options[ InfraSceneMultiway ] ],
      started = AbsoluteTime[ ], schedule = <| |>, kinds = <| |>, states = <| |>, events = <| |>,
      expansions = { }, frontier = { }, diagnostics = { }, stateKeys = { }, layers, stepLayers,
      dependencies, resolve, canonical, classify, groupOf, stateRecord, pool, selectPool, context,
      stop, addObligation, remainingTime, bounded, assertionDependencies, keys, targets, expression, kind,
      group, order, available, producers, dependencyEdges, requestedGroups, requestedDepth, maximumDepth,
      root = 1, rootAssertions, rootBindings, cursor = 1, halted = False, source, record, ready, unfinished,
      acquisition, selectedPoolSize, invalidSelector,
      construction, fixed, members, poolSize, examined, expansionReason, candidateIndex, candidate,
      trialBindings, trialAssertions, outcome, completed, key, target, newState, reason, eventID,
      rejected, unsupported, certified, boundaryStates, instances, reasons, requestedComplete, sceneComplete,
      examinedTotal = 0, resultOptions, rawOptions, unknownConstructions, value },
    settings = Join[ settings, Association[ { opts } ] ];
    rawOptions = Values[ constructions ];
    If[ ! KeyExistsQ[ First[ scene ], "ScheduleValidity" ] || ! TrueQ[ scene[ "ScheduleValidity" ][ "Valid" ] ],
      Throw[ "UnsupportedSchedule", "InfraSceneMultiway" ] ];
    dependencies[ item_ ] := Which[
      VertexQ[ graph, item ], { },
      AnyTrue[ objects, object |-> object === item ], { item },
      AtomQ[ item ] || GraphQ[ item ] || MatchQ[ item, _Function ], { },
      True, DeleteDuplicates[ Catenate[ dependencies /@ ( List @@ item ) ], SameQ ] ];
    resolve[ item_, bindings_ ] := Which[
      KeyExistsQ[ bindings, item ], Lookup[ bindings, Key[ item ] ],
      VertexQ[ graph, item ] || AtomQ[ item ] || GraphQ[ item ] || MatchQ[ item, _Function ], item,
      True, Replace[ Map[ part |-> resolve[ part, bindings ], item ], {
        InfraDistance[ x_, y_, rules___Rule ] :> InfraDistance[ graph, x, y, rules ],
        InfraMeasurement[ object_, property_ ] :> InfraMeasurement[ graph, object, property ],
        assertion_InfraGeometricAssertion :> InfraGeometricTest[ graph, assertion ],
        InfraWalkQ[ walk_ ] :> InfraWalkQ[ graph, walk ],
        InfraSegmentQ[ walk_ ] :> InfraSegmentQ[ graph, walk ],
        InfraShellQ[ region_ ] :> InfraShellQ[ graph, region ],
        InfraBallQ[ region_ ] :> InfraBallQ[ graph, region ],
        InfraPlaneQ[ region_, p_, q_ ] :> InfraPlaneQ[ graph, region, p, q ],
        InfraCircleQ[ walk_ ] :> InfraCircleQ[ graph, walk ],
        InfraInfiniteLineQ[ walk_ ] :> InfraInfiniteLineQ[ graph, walk ],
        InfraLineQ[ walk_ ] :> InfraInfiniteLineQ[ graph, walk ],
        InfraHalfLineQ[ walk_ ] :> InfraHalfLineQ[ graph, walk ],
        InfraRayQ[ walk_ ] :> InfraHalfLineQ[ graph, walk ],
        InfraParallelQ[ first_, second_ ] :> InfraParallelQ[ graph, first, second ],
        InfraIntersectQ[ first_, second_ ] :> IntersectingQ[ first, second ],
        InfraRegularPolygonQ[ walk_, anchors_ ] :> InfraRegularPolygonQ[ graph, walk, anchors ],
        InfraMemberQ[ object_, vertices_ ] :> InfraMemberQ[ graph, object, vertices ] } ] ];
    canonical[ bindings_ ] := KeySort @ Association @ KeyValueMap[
      { name, representative } |-> name -> If[
        Lookup[ kinds, Key[ name ], "Exact" ] === "VertexSet" && ! VertexQ[ graph, representative ] && ListQ[ representative ],
        Sort @ DeleteDuplicates[ representative, SameQ ], representative ], bindings ];
    keys = Keys[ constructions ];
    targets = Catenate[ Map[ name |-> If[ ListQ[ name ], name, { name } ], keys ] ];
    If[ ! DuplicateFreeQ[ targets ], Throw[ "UnsupportedSchedule", "InfraSceneMultiway" ] ];
    Do[
      targets = If[ ListQ[ keys[[ construction ]] ], keys[[ construction ]], { keys[[ construction ]] } ];
      expression = Lookup[ constructions, Key[ keys[[ construction ]] ] ];
      group = SelectFirst[ Range[ Length[ groups ] ], index |-> ContainsAll[ groups[[ index ]], targets ], None ];
      If[ group === None, Throw[ "UnsupportedSchedule", "InfraSceneMultiway" ] ];
      kind = Which[
        ListQ[ keys[[ construction ]] ], ConstantArray[ "Point", Length[ targets ] ],
        VertexQ[ graph, expression ], { "Point" },
        MatchQ[ expression, _InfraPoint | _InfraMidpoint | _InfraPerpendicularBisector | _InfraRegionNearest |
          _InfraIntersection | _InfraUnion ], { "Point" },
        MatchQ[ expression, _InfraPlane | _InfraBall | _InfraShell | _InfraSphere | _InfraTube | _InfraCylinder |
          _InfraCone | _InfraSolidOfRevolution | _InfraBallHull | _InfraConvexHull | _InfraQuadric ], { "VertexSet" },
        MatchQ[ expression, _InfraEllipse ], { "Graph" },
        MatchQ[ expression, _InfraSegment | _InfraHalfLine | _InfraRay | _InfraInfiniteLine | _InfraLine |
          _InfraCircle | _InfraArc | _InfraRegularPolygon | _InfraPolygon | _InfraWalk | _InfraGeodesic ], { "Walk" },
        True, { "Exact" } ];
      schedule = Append[ schedule, construction -> <| "Group" -> group, "Targets" -> targets,
        "Kinds" -> kind, "Expression" -> expression, "Dependencies" -> dependencies[ expression ] |> ];
      kinds = Join[ kinds, AssociationThread[ targets, kind ] ],
      { construction, Length[ keys ] } ];
    producers = Association @ Catenate @ KeyValueMap[
      { id, entry } |-> Map[ name |-> name -> id, entry[ "Targets" ] ], schedule ];
    dependencyEdges = Catenate @ KeyValueMap[ { id, entry } |-> Map[
      name |-> DirectedEdge[ Lookup[ producers, Key[ name ] ], id ],
      Select[ entry[ "Dependencies" ], name |-> KeyExistsQ[ producers, name ] ] ], schedule ];
    If[ ! AcyclicGraphQ[ Graph[ Keys[ schedule ], DeleteDuplicates[ dependencyEdges ], DirectedEdges -> True ] ] ||
        AnyTrue[ dependencyEdges, edge |-> schedule[ First[ edge ] ][ "Group" ] > schedule[ Last[ edge ] ][ "Group" ] ],
      Throw[ "UnsupportedSchedule", "InfraSceneMultiway" ] ];
    available = Keys[ init ];
    Do[
      order = With[ { tuples = Select[ keys, name |-> ListQ[ name ] && ContainsAny[ name, groups[[ group ]] ] ] },
        Join[ Select[ Complement[ groups[[ group ]], Catenate[ tuples ] ], KeyExistsQ[ constructions, # ] & ], tuples ] ];
      Do[
        construction = First @ FirstPosition[ keys, item_ /; item === name ];
        record = schedule[ construction ];
        If[ ! ContainsAll[ available, record[ "Targets" ] ] && ! ContainsAll[ available, record[ "Dependencies" ] ],
          If[ AnyTrue[ Complement[ record[ "Dependencies" ], available ], dependency |-> KeyExistsQ[ producers, dependency ] ],
            Throw[ "UnsupportedSchedule", "InfraSceneMultiway" ] ] ];
        available = Union[ available, record[ "Targets" ] ], { name, order } ], { group, Length[ groups ] } ];
    unknownConstructions = Select[ assertions, assertion |-> MatchQ[ assertion,
      ( name_ == rhs_ ) /; ( MemberQ[ objects, name ] || ( ListQ[ name ] && name =!= { } && ContainsAll[ objects, name ] ) ) &&
        ! AtomQ[ rhs ] && ! VertexQ[ graph, rhs ] && ( Context @@ { Head[ rhs ] } ) =!= "System`" &&
        ! MatchQ[ rhs, _InfraDistance | _InfraMeasurement ] ] ];
    If[ unknownConstructions =!= { }, Throw[ "UnsupportedSchedule", "InfraSceneMultiway" ] ];
    invalidSelector[ token_ ] := Which[
      VertexQ[ graph, token ] || AtomQ[ token ] || GraphQ[ token ] || MatchQ[ token, _Function ], False,
      MatchQ[ token, "NextVertexFunction" -> _ ], ! MemberQ[ { Automatic, Identity }, Last[ token ] ],
      True, AnyTrue[ List @@ token, invalidSelector ] ];
    If[ AnyTrue[ rawOptions, invalidSelector ],
      Throw[ "UnsupportedSchedule", "InfraSceneMultiway" ] ];
    remainingTime[ ] := If[ settings[ "MaxTime" ] === Infinity, Infinity,
      Max[ 0, settings[ "MaxTime" ] - ( AbsoluteTime[ ] - started ) ] ];
    SetAttributes[ bounded, HoldAll ];
    bounded[ operation_ ] := If[ remainingTime[ ] <= 0, "TimeLimit",
      TimeConstrained[ operation, remainingTime[ ], "TimeLimit" ] ];
    assertionDependencies = dependencies /@ assertions;
    classify[ bindings_ ] := AssociationThread[ Range[ Length[ assertions ] ], MapThread[
      { assertion, inputs } |-> If[ ContainsAll[ Keys[ bindings ], inputs ],
        With[ { evaluated = resolve[ assertion, bindings ] },
          Which[ evaluated === True, True, evaluated === False, False, True, "Unsupported" ] ], "Pending" ],
      { assertions, assertionDependencies } ] ];
    groupOf[ done_ ] := SelectFirst[ Range[ Length[ groups ] ], index |->
      AnyTrue[ Keys[ schedule ], id |-> schedule[ id ][ "Group" ] === index && ! MemberQ[ done, id ] ], Length[ groups ] + 1 ];
    stateRecord[ bindings_, done_, statuses_ ] := <| "Bindings" -> bindings, "Completed" -> Sort[ done ],
      "Depth" -> Length[ done ], "Group" -> groupOf[ done ], "Assertions" -> statuses, "IncomingEvents" -> { } |>;
    context[ token_ ] := Replace[ token, {
      ( InfraCircle | InfraShell | InfraSphere )[ center_, radius_, ___ ] :>
        <| "Center" -> center, "Radius" -> Mean @ Flatten[ { radius } ] |>,
      InfraArc[ center_, { p_, ___, p_ } | { p_ }, rules___Rule ] :>
        With[ { radius = GraphDistance[ graph, center, p ],
            delta = Replace[ Lookup[ { rules }, "RadiusDelta", 0 ], value : Except[ _List ] :> { 0, value } ] },
          <| "Center" -> center, "Radius" -> Mean[ { Max[ 1, radius - First[ delta ] ], radius + Last[ delta ] } ] |> ],
      InfraArc[ _, points_List, ___ ] :> <| "Endpoints" -> { First[ points ], Last[ points ] } |>,
      ( InfraInfiniteLine | InfraLine )[ path_List, ___ ] :> <| "Endpoints" -> { First[ path ], Last[ path ] } |>,
      ( InfraSegment | InfraHalfLine | InfraRay | InfraInfiniteLine | InfraLine | InfraPlane )[ p_, q_, ___ ] :>
        <| "Endpoints" -> { p, q } |>,
      _ :> <| |> } ];
    selectPool[ paths_, None, token_ ] := paths;
    selectPool[ paths_, selections_List, token_ ] := Fold[ selectPool[ #1, #2, token ] &, paths, selections ];
    selectPool[ paths_, selection_String, token_ ] /; selection =!= "EmbeddingClosest" :=
      SelectInfraWalk[ graph, paths, All, "From" -> Replace[ selection, { "Central" -> "Center", "Peripheral" -> "Periphery" } ],
        "Cyclic" -> MatchQ[ token, ( InfraCircle | InfraRegularPolygon | InfraPolygon )[ __ ] |
          InfraArc[ _, { p_, ___, p_ } | { _ }, ___ ] ] ];
    selectPool[ paths_, "EmbeddingClosest", token_ ] := With[
      { cyclic = MatchQ[ token, ( InfraCircle | InfraRegularPolygon | InfraPolygon )[ __ ] |
          InfraArc[ _, { p_, ___, p_ } | { _ }, ___ ] ], information = context[ token ],
        coordinates = GraphEmbedding[ Graph[ graph, GraphLayout -> "SpringEmbedding" ] ],
        indices = AssociationThread[ VertexList[ graph ], Range[ VertexCount[ graph ] ] ] },
      Which[
        Length[ paths ] <= 1, paths,
        cyclic && KeyExistsQ[ information, "Center" ] && KeyExistsQ[ information, "Radius" ],
          With[ { center = coordinates[[ Lookup[ indices, Key[ information[ "Center" ] ] ] ]], radius = information[ "Radius" ] },
            MinimalBy[ paths, cycle |-> If[ Length[ cycle ] < 3, Infinity,
              With[ { circle = Table[ center + radius * { Cos[ angle ], Sin[ angle ] },
                  { angle, 0, 2 Pi - 2 Pi / Max[ 64, 4 Length[ cycle ] ], 2 Pi / Max[ 64, 4 Length[ cycle ] ] } ] },
                RegionHausdorffDistance[ Line[ coordinates[[ Map[ vertex |-> Lookup[ indices, Key[ vertex ] ],
                  Append[ cycle, First[ cycle ] ] ] ]] ], Line[ Append[ circle, First[ circle ] ] ] ] ] ] ] ],
        ! cyclic && KeyExistsQ[ information, "Endpoints" ],
          EmbeddingClosest[ graph, paths, Line[ coordinates[[ Map[ vertex |-> Lookup[ indices, Key[ vertex ] ],
            information[ "Endpoints" ] ] ]] ] ],
        True, token ] ];
    pool[ item_ ] := With[ { rules = If[ VertexQ[ graph, item ], { }, Cases[ item, _Rule ] ],
        token = If[ VertexQ[ graph, item ], item, DeleteCases[ item, ( "Select" | "Branches" ) -> _ ] ] },
      { raw = Which[
        VertexQ[ graph, token ], { token },
        ListQ[ token ] && AllTrue[ token, vertex |-> VertexQ[ graph, vertex ] ], token,
        AssociationQ[ token ] && AllTrue[ Keys[ token ], vertex |-> VertexQ[ graph, vertex ] ], Keys[ token ],
        True, Replace[ token, {
          token_InfraPoint :> RandomInfraPoint[ graph, token, All ],
          token_InfraMidpoint :> RandomInfraMidpoint[ graph, token, All ],
          token_InfraPerpendicularBisector :> RandomInfraPerpendicularBisector[ graph, token, All ],
          token_InfraRegionNearest :> RandomInfraRegionNearest[ graph, token, All ],
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
      { selected = If[ ListQ[ raw ], selectPool[ raw, Lookup[ rules, "Select", None ], token ], raw ],
        branches = Lookup[ rules, "Branches", All ] },
      { indexed = If[ ListQ[ raw ] && ListQ[ selected ],
          Select[ MapIndexed[ { First[ #2 ], #1 } &, raw ], pair |-> AnyTrue[ selected, selectedMember |-> selectedMember === Last[ pair ] ] ], selected ] },
      { kept = Which[ ! ListQ[ indexed ], indexed, branches === All, indexed,
          MatchQ[ branches, _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] ],
            Take[ indexed, Replace[ branches, n_Integer :> UpTo[ n ] ] ], True, token ] },
      If[ ListQ[ kept ], <| "Candidates" -> kept, "PoolSize" -> Length[ raw ], "SelectedPoolSize" -> Length[ kept ] |>, kept ] ];
    addObligation[ sourceID_, constructionID_, next_, why_ ] :=
      ( frontier = Append[ frontier, <| "Source" -> sourceID, "Construction" -> constructionID,
        "NextCandidate" -> next, "Reason" -> why |> ] );
    requestedGroups = Min[ Length[ groups ], Replace[ settings[ "Steps" ], { All -> Infinity, UpTo[ n_ ] :> n } ] ];
    requestedDepth = Count[ Values[ schedule ], entry_ /; entry[ "Group" ] <= requestedGroups ];
    maximumDepth = Min[ requestedDepth, settings[ "MaxDepth" ] ];
    rootBindings = canonical[ init ];
    rootAssertions = bounded[ classify[ rootBindings ] ];
    If[ rootAssertions === "TimeLimit", rootAssertions = AssociationThread[ Range[ Length[ assertions ] ], ConstantArray[ "Unsupported", Length[ assertions ] ] ];
      addObligation[ 1, None, None, "TimeLimit" ] ];
    If[ MemberQ[ Values[ rootAssertions ], False ],
      root = None;
      diagnostics = { <| "State" -> None, "Reason" -> "RootRejected", "Assertions" -> rootAssertions |> },
      states = <| 1 -> stateRecord[ rootBindings, { }, rootAssertions ] |>;
      stateKeys = { { { }, rootBindings } } ];
    While[ cursor <= Length[ states ] && ! halted,
      source = cursor;
      record = states[ source ];
      unfinished = Select[ Keys[ schedule ], id |-> ! MemberQ[ record[ "Completed" ], id ] &&
        schedule[ id ][ "Group" ] === record[ "Group" ] ];
      Which[
        unfinished === { } && record[ "Group" ] > Length[ groups ] && MemberQ[ Values[ record[ "Assertions" ] ], "Pending" ],
          addObligation[ source, None, None, "UnboundInput" ];
          diagnostics = Append[ diagnostics, <| "State" -> source, "Reason" -> "UnboundInput",
            "Assertions" -> record[ "Assertions" ] |> ],
        MemberQ[ Values[ record[ "Assertions" ] ], "Unsupported" ],
          diagnostics = Append[ diagnostics, <| "State" -> source, "Reason" -> "Unsupported",
            "Assertions" -> record[ "Assertions" ] |> ];
          addObligation[ source, None, None, "Unsupported" ],
        record[ "Depth" ] >= requestedDepth && unfinished =!= { },
          addObligation[ source, None, None, "StepsLimit" ],
        record[ "Depth" ] >= maximumDepth && unfinished =!= { },
          addObligation[ source, None, None, "DepthLimit" ],
        True,
          ready = Select[ unfinished, id |-> ContainsAll[ Keys[ record[ "Bindings" ] ], schedule[ id ][ "Targets" ] ] ||
            ContainsAll[ Keys[ record[ "Bindings" ] ], schedule[ id ][ "Dependencies" ] ] ];
          If[ ready === { } && unfinished =!= { },
            Do[ addObligation[ source, id, None, "UnboundInput" ];
              diagnostics = Append[ diagnostics, <| "State" -> source, "Construction" -> id,
                "Reason" -> "UnboundInput", "Dependencies" -> schedule[ id ][ "Dependencies" ] |> ], { id, unfinished } ] ];
          Do[
            If[ halted, Break[ ] ];
            construction = id;
            targets = schedule[ id ][ "Targets" ];
            fixed = ContainsAll[ Keys[ record[ "Bindings" ] ], targets ];
            acquisition = If[ fixed, <| "Candidates" -> { { None, None } }, "PoolSize" -> 0, "SelectedPoolSize" -> 0 |>,
              bounded[ pool[ resolve[ schedule[ id ][ "Expression" ], record[ "Bindings" ] ] ] ] ];
            members = If[ AssociationQ[ acquisition ], acquisition[ "Candidates" ], acquisition ];
            poolSize = If[ AssociationQ[ acquisition ], acquisition[ "PoolSize" ], Missing[ "Unknown" ] ];
            selectedPoolSize = If[ AssociationQ[ acquisition ], acquisition[ "SelectedPoolSize" ], Missing[ "Unknown" ] ];
            examined = 0;
            expansionReason = None;
            If[ ! ListQ[ members ],
              expansionReason = If[ members === "TimeLimit", "TimeLimit", "Unsupported" ];
              addObligation[ source, id, None, expansionReason ];
              diagnostics = Append[ diagnostics, <| "State" -> source, "Construction" -> id,
                "Reason" -> expansionReason, "Expression" -> members |> ];
              If[ expansionReason === "TimeLimit", halted = True ],
              Do[
                candidateIndex = members[[ index, 1 ]];
                candidate = members[[ index, 2 ]];
                reason = Which[
                  remainingTime[ ] <= 0, "TimeLimit",
                  ! fixed && examinedTotal >= settings[ "MaxCandidates" ], "CandidateLimit",
                  Length[ events ] >= settings[ "MaxEvents" ], "EventLimit", True, None ];
                If[ reason =!= None,
                  expansionReason = reason; addObligation[ source, id, candidateIndex, reason ]; halted = True; Break[ ] ];
                trialBindings = If[ fixed, record[ "Bindings" ],
                  canonical @ Join[ record[ "Bindings" ], If[ ListQ[ keys[[ id ]] ],
                    AssociationThread[ targets, candidate ], <| First[ targets ] -> candidate |> ] ] ];
                rejected = ! AllTrue[ Intersection[ targets, Keys[ record[ "Bindings" ] ] ],
                  name |-> Lookup[ trialBindings, Key[ name ] ] === Lookup[ record[ "Bindings" ], Key[ name ] ] ];
                trialAssertions = If[ rejected, <| |>, bounded[ classify[ trialBindings ] ] ];
                If[ trialAssertions === "TimeLimit",
                  expansionReason = "TimeLimit"; addObligation[ source, id, candidateIndex, "TimeLimit" ]; halted = True; Break[ ] ];
                outcome = Which[ rejected, "FixedConflict", MemberQ[ Values[ trialAssertions ], False ], "AssertionFalse",
                  fixed, "Fixed", True, "Accepted" ];
                completed = Sort[ Append[ record[ "Completed" ], id ] ];
                key = { completed, trialBindings };
                target = If[ MemberQ[ { "Accepted", "Fixed" }, outcome ],
                  FirstCase[ Range[ Length[ stateKeys ] ], stateID_ /; stateKeys[[ stateID ]] === key, None ], None ];
                newState = MemberQ[ { "Accepted", "Fixed" }, outcome ] && target === None;
                If[ newState && Length[ states ] >= settings[ "MaxStates" ],
                  expansionReason = "StateLimit"; addObligation[ source, id, candidateIndex, "StateLimit" ]; halted = True; Break[ ] ];
                If[ newState,
                  target = Length[ states ] + 1;
                  states = Append[ states, target -> stateRecord[ trialBindings, completed, trialAssertions ] ];
                  stateKeys = Append[ stateKeys, key ] ];
                eventID = Length[ events ] + 1;
                events = Append[ events, eventID -> <| "Source" -> source, "Target" -> target, "Construction" -> id,
                  "Group" -> schedule[ id ][ "Group" ], "CandidateIndex" -> candidateIndex, "Candidate" -> candidate,
                  "Outcome" -> outcome, "Assertions" -> trialAssertions |> ];
                If[ target =!= None,
                  value = states[ target ];
                  value = Append[ value, "IncomingEvents" -> Append[ value[ "IncomingEvents" ], eventID ] ];
                  states = Append[ states, target -> value ] ];
                If[ ! fixed, examined++; examinedTotal++ ], { index, Length[ members ] } ] ];
            expansions = Append[ expansions, <| "Source" -> source, "Construction" -> id,
              "PoolSize" -> poolSize, "SelectedPoolSize" -> selectedPoolSize, "Examined" -> examined, "Complete" -> ( expansionReason === None ),
              "Reason" -> expansionReason |> ], { id, ready } ] ];
      cursor++ ];
    If[ halted,
      Do[ If[ ! AnyTrue[ frontier, obligation |-> obligation[ "Source" ] === stateID ],
          addObligation[ stateID, None, None, FirstCase[ Reverse[ frontier ], obligation_ :> obligation[ "Reason" ], "Unsupported" ] ] ],
        { stateID, cursor, Length[ states ] } ] ];
    certified = ! MemberQ[ Values[ rootAssertions ], "Unsupported" ];
    layers = <| 0 -> <| "States" -> Select[ Keys[ states ], stateID |-> states[ stateID ][ "Depth" ] === 0 ],
      "Complete" -> certified |> |>;
    Do[
      certified = certified && ! AnyTrue[ frontier, obligation |->
        states[ obligation[ "Source" ] ][ "Depth" ] < depth && obligation[ "Reason" ] =!= "StepsLimit" ] &&
        ! AnyTrue[ Values[ states ], state |-> state[ "Depth" ] === depth && MemberQ[ Values[ state[ "Assertions" ] ], "Unsupported" ] ];
      layers = Append[ layers, depth -> <| "States" -> Select[ Keys[ states ], stateID |-> states[ stateID ][ "Depth" ] === depth ],
        "Complete" -> certified |> ], { depth, maximumDepth } ];
    stepLayers = Association @ Table[
      With[ { depth = Count[ Values[ schedule ], entry_ /; entry[ "Group" ] <= step ] },
        step -> <| "Depth" -> depth, "States" -> If[ KeyExistsQ[ layers, depth ], layers[ depth ][ "States" ], { } ],
          "Complete" -> ( KeyExistsQ[ layers, depth ] && TrueQ[ layers[ depth ][ "Complete" ] ] ) |> ],
      { step, 0, requestedGroups } ];
    boundaryStates = stepLayers[ requestedGroups ][ "States" ];
    instances = DeleteDuplicates[ Map[ stateID |-> InfraSceneInstance[ states[ stateID ][ "Bindings" ] ],
      Select[ boundaryStates, stateID |-> ! MemberQ[ Values[ states[ stateID ][ "Assertions" ] ], "Unsupported" ] ] ] ];
    requestedComplete = TrueQ[ stepLayers[ requestedGroups ][ "Complete" ] ];
    sceneComplete = requestedComplete && requestedGroups === Length[ groups ] &&
      AllTrue[ boundaryStates, stateID |-> AllTrue[ Values[ states[ stateID ][ "Assertions" ] ], TrueQ ] ];
    reasons = DeleteDuplicates[ Lookup[ frontier, "Reason", { } ] ];
    resultOptions = Join[ settings, <| "PoolAcquisition" -> "EagerAll", "ConstructionSettings" -> rawOptions |> ];
    <| "Scene" -> scene, "Substrate" -> graph, "InitialBindings" -> rootBindings, "Options" -> resultOptions,
      "Schedule" -> schedule, "Root" -> root, "States" -> states, "Events" -> events,
      "StateGraph" -> Graph[ Keys[ states ], DeleteDuplicates @ Cases[ Values[ events ],
        event_ /; event[ "Target" ] =!= None :> DirectedEdge[ event[ "Source" ], event[ "Target" ] ] ], DirectedEdges -> True ],
      "Layers" -> layers, "StepLayers" -> stepLayers, "Instances" -> instances, "Expansions" -> expansions,
      "Frontier" -> frontier, "Diagnostics" -> diagnostics,
      "Completeness" -> <| "Requested" -> requestedComplete, "Scene" -> sceneComplete, "Reasons" -> reasons |>,
      "Statistics" -> <| "States" -> Length[ states ], "Events" -> Length[ events ], "Candidates" -> examinedTotal,
        "ElapsedSeconds" -> ( AbsoluteTime[ ] - started ) |> |> ], "InfraSceneMultiway" ] },
    result /; AssociationQ[ result ] ]

InfraBranchialGraph[ data_Association, depth_Integer ] /;
    KeyExistsQ[ data, "Layers" ] && KeyExistsQ[ data[ "Layers" ], depth ] :=
  With[ { vertices = data[ "Layers" ][ depth ][ "States" ],
      accepted = Select[ Values[ data[ "Events" ] ], event |-> MemberQ[ { "Accepted", "Fixed" }, event[ "Outcome" ] ] ] },
    { parents = Association @ Map[ vertex |-> vertex -> DeleteDuplicates[ Lookup[
        Select[ accepted, event |-> event[ "Target" ] === vertex ], "Source", { } ] ], vertices ] },
    { witnesses = Association @ Cases[ Subsets[ Sort[ vertices ], { 2 } ],
        { first_, second_ } /; Intersection[ parents[ first ], parents[ second ] ] =!= { } :>
          UndirectedEdge[ first, second ] -> Intersection[ parents[ first ], parents[ second ] ] ] },
    <| "Graph" -> Graph[ vertices, Keys[ witnesses ] ], "Depth" -> depth,
      "Complete" -> data[ "Layers" ][ depth ][ "Complete" ], "Witnesses" -> witnesses,
      "Frontier" -> Select[ data[ "Frontier" ], obligation |->
        data[ "States" ][ obligation[ "Source" ] ][ "Depth" ] < depth && obligation[ "Reason" ] =!= "StepsLimit" ] |> ]
