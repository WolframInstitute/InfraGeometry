Package[ "WolframInstitute`InfraGeometry`" ]

CausalFoliationQ[ graph_Graph, foliation_List ] :=
  AllTrue[ foliation, slice |-> MatchQ[ slice, { __ } ] ] &&
    With[ { vertices = Catenate @ foliation },
      DuplicateFreeQ[ vertices ] && Sort[ vertices ] === Sort @ VertexList @ graph &&
        With[ { times = AssociationThread[ vertices,
            Catenate @ MapIndexed[ { slice, index } |-> ConstantArray[ First @ index, Length @ slice ], foliation ] ] },
          AllTrue[ EdgeList @ graph,
            edge |-> MatchQ[ edge, _DirectedEdge ] &&
              Lookup[ times, Key[ edge[[ 1 ]] ] ] < Lookup[ times, Key[ edge[[ 2 ]] ] ] ] ] ]

Options[ CausalSpatialGraphs ] = { "AncestorDepth" -> 1 }

CausalSpatialGraphs[ graph_Graph ] /;
    causalReconstructionDAGQ[ graph ] :=
  CausalSpatialGraphs[ graph, CausalHeightFoliation[ graph ] ]

CausalSpatialGraphs[ graph_Graph, opts : Repeated[ _Rule | _RuleDelayed ] ] /;
    causalReconstructionDAGQ[ graph ] :=
  CausalSpatialGraphs[ graph, CausalHeightFoliation[ graph ], opts ]

CausalSpatialGraphs[ graph_Graph, Automatic, opts : OptionsPattern[ ] ] /;
    causalReconstructionDAGQ[ graph ] :=
  CausalSpatialGraphs[ graph, CausalHeightFoliation[ graph ], opts ]

CausalSpatialGraphs[ graph_Graph, foliation_List, opts : OptionsPattern[ ] ] /;
    CausalFoliationQ[ graph, foliation ] && IntegerQ[ OptionValue[ CausalSpatialGraphs, { opts }, "AncestorDepth" ] ] &&
      OptionValue[ CausalSpatialGraphs, { opts }, "AncestorDepth" ] >= 0 :=
  With[ { depth = OptionValue[ CausalSpatialGraphs, { opts }, "AncestorDepth" ],
      descendants = AssociationMap[ vertex |-> VertexOutComponent[ graph, { vertex } ], VertexList @ graph ] },
    AssociationThread[ Range @ Length @ foliation,
      MapIndexed[
        { slice, index } |-> causalSpatialGraph[ slice,
          Catenate @ Take[ Take[ foliation, First @ index - 1 ], -Min[ depth, First @ index - 1 ] ], descendants ],
        foliation ] ] ]

CausalSliceRelation[ graph_Graph, Automatic, indices : { _Integer, _Integer } ] /;
    causalReconstructionDAGQ[ graph ] :=
  CausalSliceRelation[ graph, CausalHeightFoliation[ graph ], indices ]

CausalSliceRelation[ graph_Graph, foliation_List, indices : { _Integer, _Integer } ] /;
    CausalFoliationQ[ graph, foliation ] && AllTrue[ indices, index |-> 1 <= index <= Length @ foliation ] :=
  With[ { source = foliation[[ First @ indices ]], target = foliation[[ Last @ indices ]],
      component = If[ First @ indices <= Last @ indices, VertexOutComponent, VertexInComponent ] },
    AssociationMap[
      vertex |-> With[ { reachable = component[ graph, { vertex } ] },
        Select[ target, candidate |-> MemberQ[ reachable, Verbatim[ candidate ] ] ] ],
      source ] ]

Options[ CausalSliceMap ] = { "SelectImage" -> Automatic }

CausalSliceMap[ graph_Graph, Automatic, indices : { _Integer, _Integer }, opts : OptionsPattern[ ] ] /;
    causalReconstructionDAGQ[ graph ] :=
  CausalSliceMap[ graph, CausalHeightFoliation[ graph ], indices, opts ]

CausalSliceMap[ graph_Graph, foliation_List, indices : { _Integer, _Integer }, OptionsPattern[ ] ] /;
    CausalFoliationQ[ graph, foliation ] && AllTrue[ indices, index |-> 1 <= index <= Length @ foliation ] :=
  With[ { relation = CausalSliceRelation[ graph, foliation, indices ], selection = OptionValue[ "SelectImage" ] },
    With[ { images = If[ selection === Automatic, First, selection ] /@ relation },
      images /; And @@ MapThread[ { candidates, image } |-> MemberQ[ candidates, Verbatim[ image ] ],
        { Values @ relation, Values @ images } ] ] /;
      AllTrue[ Values @ relation, candidates |-> candidates =!= { } &&
        ( selection =!= Automatic || Length[ candidates ] === 1 ) ] ]

CausalSliceKernel[ graph_Graph, Automatic, indices : { _Integer, _Integer } ] /;
    causalReconstructionDAGQ[ graph ] :=
  CausalSliceKernel[ graph, CausalHeightFoliation[ graph ], indices ]

CausalSliceKernel[ graph_Graph, foliation_List, indices : { _Integer, _Integer } ] /;
    CausalFoliationQ[ graph, foliation ] && AllTrue[ indices, index |-> 1 <= index <= Length @ foliation ] :=
  With[ { relation = CausalSliceRelation[ graph, foliation, indices ] },
    Map[ candidates |-> AssociationThread[ candidates, ConstantArray[ 1 / Length[ candidates ], Length[ candidates ] ] ],
      relation ] /; AllTrue[ Values @ relation, candidates |-> candidates =!= { } ] ]

causalReconstructionDAGQ[ graph_Graph ] :=
  AllTrue[ EdgeList @ graph, edge |-> MatchQ[ edge, _DirectedEdge ] ] && AcyclicGraphQ[ graph ]

causalSpatialGraph[ slice_List, ancestors_List, descendants_Association ] :=
  Graph[ slice,
    DeleteDuplicates @ Catenate @ Map[
      ancestor |-> UndirectedEdge @@@ Subsets[ Intersection[ slice, Lookup[ descendants, Key[ ancestor ] ] ], { 2 } ],
      ancestors ] ]
