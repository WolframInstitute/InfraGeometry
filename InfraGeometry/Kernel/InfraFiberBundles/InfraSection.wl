Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: InfraFiberBundles :: InfraSection *)

InfraSectionQ[ fib : _[ _Graph, __ ], InfraSection[ section_Association ] ] /;
    AssociationQ[ InfraFibrationAssociation @ fib ] && GraphQ[ InfraBaseGraph @ fib ] :=
  With[ { projection = InfraFibrationAssociation @ fib },
    AllTrue[ Normal @ section,
      binding |-> KeyExistsQ[ projection, Last @ binding ] && Lookup[ projection, Key @ Last @ binding ] === First @ binding ] ]

InfraSectionQ[ fib : _[ _Graph, __ ], sections_List ] /;
    AssociationQ[ InfraFibrationAssociation @ fib ] && GraphQ[ InfraBaseGraph @ fib ] :=
  sections =!= { } && And @@ ( InfraSectionQ[ fib, # ] & /@ sections )

InfraContinuousSectionQ[ fib : _[ _Graph, __ ], section : InfraSection[ values_Association ] ] /;
    AssociationQ[ InfraFibrationAssociation @ fib ] && GraphQ[ InfraBaseGraph @ fib ] :=
  With[ { total = InfraTotalGraph @ fib },
    { positions = AssociationThread[ VertexList @ total, Range @ VertexCount @ total ], indexed = IndexGraph @ total },
    InfraSectionQ[ fib, section ] &&
      AllTrue[ Select[ EdgeList @ InfraBaseGraph @ fib, edge |-> AllTrue[ List @@ edge, KeyExistsQ[ values, # ] & ] ],
        EdgeQ[ indexed, UndirectedEdge @@ Lookup[ positions, Key /@ Lookup[ values, Key /@ List @@ # ] ] ] & ] ]

InfraContinuousSectionQ[ fib : _[ _Graph, __ ], sections_List ] /;
    AssociationQ[ InfraFibrationAssociation @ fib ] && GraphQ[ InfraBaseGraph @ fib ] :=
  sections =!= { } && And @@ ( InfraContinuousSectionQ[ fib, # ] & /@ sections )

InfraParallelSectionQ[ fib : _[ _Graph, __ ], connection_InfraConnection, section : InfraSection[ values_Association ] ] /;
    AssociationQ[ InfraFibrationAssociation @ fib ] && GraphQ[ InfraBaseGraph @ fib ] &&
    TrueQ[ InfraConnectionQ[ fib, connection ] ] :=
  InfraSectionQ[ fib, section ] &&
    AllTrue[ Select[ EdgeList @ InfraBaseGraph @ fib, edge |-> AllTrue[ List @@ edge, KeyExistsQ[ values, # ] & ] ],
      edge |-> Lookup[ InfraParallelTransport[ fib, connection, List @@ edge ], Key @ Lookup[ values, Key @ First @ edge ] ] ===
        Lookup[ values, Key @ Last @ edge ] ]

InfraParallelSectionQ[ fib : _[ _Graph, __ ], connection_InfraConnection, sections_List ] /;
    AssociationQ[ InfraFibrationAssociation @ fib ] && GraphQ[ InfraBaseGraph @ fib ] &&
    TrueQ[ InfraConnectionQ[ fib, connection ] ] :=
  sections =!= { } && And @@ ( InfraParallelSectionQ[ fib, connection, # ] & /@ sections )

Options[ RandomInfraSection ] = { Properties -> { }, "NextVertexFunction" -> Automatic }

RandomInfraSection[ fib : _[ _Graph, __ ],
    specification : ( _List | InfraSection[ _Association ] ) : InfraSection[ <| |> ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[] ] /;
    AssociationQ[ InfraFibrationAssociation @ fib ] && GraphQ[ InfraBaseGraph @ fib ] &&
    SubsetQ[ First /@ Options[ RandomInfraSection ], First /@ Flatten @ { opts } ] &&
    ( OptionValue[ RandomInfraSection, { opts }, Properties ] === { } ||
      OptionValue[ RandomInfraSection, { opts }, Properties ] === { "Continuous" } ) &&
    ! MatchQ[ OptionValue[ RandomInfraSection, { opts }, "NextVertexFunction" ],
      _String | _Integer | _Real | _Rational | _Complex | _List | _Association | _Rule | _RuleDelayed ] &&
    ( count =!= All || OptionValue[ RandomInfraSection, { opts }, "NextVertexFunction" ] =!= RandomChoice ) &&
    If[ ListQ @ specification,
      AllTrue[ specification, point |-> AnyTrue[ VertexList @ InfraBaseGraph @ fib, # === point & ] ],
      TrueQ[ InfraSectionQ[ fib, specification ] ] ] :=
  With[ { projection = InfraFibrationAssociation @ fib, total = InfraTotalGraph @ fib, base = InfraBaseGraph @ fib,
          continuous = OptionValue[ RandomInfraSection, { opts }, Properties ] === { "Continuous" },
          cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ],
          nextFunction = If[ count === All && OptionValue[ RandomInfraSection, { opts }, "NextVertexFunction" ] === Automatic,
            Identity, OptionValue[ RandomInfraSection, { opts }, "NextVertexFunction" ] ] },
    { vertices = VertexList @ total,
      domain = If[ ListQ @ specification, DeleteDuplicates @ specification, VertexList @ base ],
      fixed = If[ ListQ @ specification, <| |>, First @ specification ],
      indexed = IndexGraph @ total, baseAdjacency = If[ VertexCount @ base === 0, { }, AdjacencyMatrix @ base ],
      basePositions = AssociationThread[ VertexList @ base, Range @ VertexCount @ base ] },
    { positions = AssociationThread[ vertices, Range @ Length @ vertices ],
      fibers = GroupBy[ Range @ Length @ vertices, Lookup[ projection, Key @ vertices[[ # ]] ] & ],
      domainPositions = Lookup[ basePositions, Key /@ domain ] },
    { candidates = Map[ point |-> If[ KeyExistsQ[ fixed, point ],
          { Lookup[ positions, Key @ Lookup[ fixed, Key @ point ] ] }, Lookup[ fibers, Key @ point ] ], domain ],
      constraints = Table[ Select[ Range[ position - 1 ],
          baseAdjacency[[ domainPositions[[ # ]], domainPositions[[ position ]] ]] === 1 & ], { position, Length @ domain } ],
      order = choices |-> Which[
        choices === { } || nextFunction === Identity, choices,
        nextFunction === Automatic, RandomSample @ choices,
        True, With[ { labels = vertices[[ choices ]] },
          { selected = nextFunction[ labels ] },
          Which[
            AnyTrue[ labels, # === selected & ], { Lookup[ positions, Key @ selected ] },
            ListQ @ selected && DuplicateFreeQ @ selected &&
              AllTrue[ selected, label |-> AnyTrue[ labels, # === label & ] ], Lookup[ positions, Key /@ selected ],
            True, Missing[ "UnsupportedSelector" ] ] ] ] },
    (* A section is a graph-homomorphism CSP; FindClique does not expose the per-fiber ordering callback and bounded backtracking. *)
    { search = Reap @ NestWhile[
        Apply[ { pending, found, valid } |-> With[ { chosen = First @ pending },
          If[ Length @ chosen === Length @ domain,
            ( Sow[ InfraSection @ AssociationThread[ domain, vertices[[ chosen ]] ] ]; { Rest @ pending, found + 1, True } ),
            With[ { position = Length @ chosen + 1 },
              { choices = If[ continuous,
                  Intersection @@ Prepend[ AdjacencyList[ indexed, chosen[[ # ]] ] & /@ constraints[[ position ]],
                    candidates[[ position ]] ], candidates[[ position ]] ] },
              { ordered = order @ choices },
              If[ ListQ @ ordered,
                { Join[ Append[ chosen, # ] & /@ ordered, Rest @ pending ], found, True },
                { { }, found, False } ] ] ] ] ],
        { { { } }, 0, True },
        state |-> Last @ state && First @ state =!= { } && state[[ 2 ]] < cap ] },
    { sections = Catenate @ Last @ search },
    Switch[ count,
      Automatic, First[ sections, { } ],
      All, sections,
      _UpTo, sections,
      _, If[ Length @ sections < count, { }, sections ] ] /; TrueQ[ search[[ 1, 3 ]] ] ]

FindInfraSection[ fib : _[ _Graph, __ ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All ) ] /;
    AssociationQ[ InfraFibrationAssociation @ fib ] && GraphQ[ InfraBaseGraph @ fib ] :=
  RandomInfraSection[ fib, count, Properties -> { "Continuous" }, "NextVertexFunction" -> Identity ]
