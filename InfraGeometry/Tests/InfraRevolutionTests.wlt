(* InfraRevolution.wl tests *)

geodesicGraph = WolframInstitute`InfraGeometry`PackageScope`geodesicGraph;


(* Surface is a subset of Solid for the same axis and profile. *)

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ], axis = { 1, 2, 3, 4 } },
    With[ {
        surf = FindInfraRevolution[ g, axis, 1, "Form" -> "Surface" ],
        sol  = FindInfraRevolution[ g, axis, 1, "Form" -> "Solid"   ] },
      SubsetQ[ sol, surf ] ] ],
  True,
  TestID -> "FindInfraRevolution-Surface-subset-Solid"
]


(* Solid equals the union of capped-profile Surfaces. *)

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ], axis = { 1, 2, 3, 4, 5 }, prof = { 0, 1, 2, 1, 0 } },
    With[ {
        sol   = FindInfraRevolution[ g, axis, prof, "Form" -> "Solid" ],
        union = Sort[ Union @@ Table[
          FindInfraRevolution[ g, axis, Min[ #, k ] & /@ prof, "Form" -> "Surface" ],
          { k, 0, Max @ prof } ] ] },
      Sort @ sol === union ] ],
  True,
  TestID -> "FindInfraRevolution-Solid-equals-union-of-Surfaces"
]


(* Profile as a List and as a callable agree. *)

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ], axis = { 1, 2, 3, 4, 5 } },
    FindInfraRevolution[ g, axis, Range[ 0, 4 ] ] ===
    FindInfraRevolution[ g, axis, # - 1 & ] ],
  True,
  TestID -> "FindInfraRevolution-list-and-function-agree"
]


(* Singleton axis with Surface degenerates to FindInfraShell. *)

VerificationTest[
  With[ { g = PetersenGraph[] },
    FindInfraRevolution[ g, { 1 }, 2, "Form" -> "Surface" ] ===
    Sort @ Select[ VertexList @ g, GraphDistance[ g, 1, # ] === 2 & ] ],
  True,
  TestID -> "FindInfraRevolution-singleton-axis-Surface-equals-FindInfraShell"
]


(* Profile larger than diameter:  Solid covers everything, Surface is empty. *)

VerificationTest[
  With[ { g = PathGraph @ Range @ 5 },
    FindInfraRevolution[ g, { 3 }, 100, "Form" -> "Solid" ] === Sort @ VertexList @ g ],
  True,
  TestID -> "FindInfraRevolution-large-radius-Solid-is-all"
]

VerificationTest[
  With[ { g = PathGraph @ Range @ 5 },
    FindInfraRevolution[ g, { 3 }, 100, "Form" -> "Surface" ] ],
  { },
  TestID -> "FindInfraRevolution-large-radius-Surface-is-empty"
]


(* Method -> "PerpendicularBisector": on a path graph every position's
   bisector slab is just that position itself, so the solid degenerates
   to the axis. *)

VerificationTest[
  With[ { g = PathGraph @ Range @ 9, axis = { 3, 4, 5, 6, 7 } },
    FindInfraRevolution[ g, axis, 1, Method -> "PerpendicularBisector" ] ],
  { 3, 4, 5, 6, 7 },
  TestID -> "FindInfraRevolution-PerpendicularBisector-PathGraph"
]


(* InfraRevolutionQ round-trip. *)

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ], axis = { 1, 2, 3, 4, 5 }, prof = { 0, 1, 2, 1, 0 } },
    With[ { vs = FindInfraRevolution[ g, axis, prof, "Form" -> "Solid" ] },
      InfraRevolutionQ[ g, vs, axis, prof, "Form" -> "Solid" ] ] ],
  True,
  TestID -> "InfraRevolutionQ-round-trip-Solid"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ], axis = { 1, 2, 3, 4, 5 }, prof = { 0, 1, 2, 1, 0 } },
    With[ { vs = FindInfraRevolution[ g, axis, prof, "Form" -> "Surface" ] },
      InfraRevolutionQ[ g, vs, axis, prof, "Form" -> "Surface" ] ] ],
  True,
  TestID -> "InfraRevolutionQ-round-trip-Surface"
]


(* Profile as an Association keyed by axis vertices. *)

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ], axis = { 1, 2, 3, 4 } },
    FindInfraRevolution[ g, axis, <| 1 -> 0, 2 -> 1, 3 -> 1, 4 -> 0 |>, "Form" -> "Solid" ] ===
    FindInfraRevolution[ g, axis, { 0, 1, 1, 0 }, "Form" -> "Solid" ] ],
  True,
  TestID -> "FindInfraRevolution-Association-equals-List"
]


(* Multi-axis (two geodesics in CycleGraph[6] form a thick axis;
   profile { 0, 1, 0, 0 } picks up the off-axis position-2 vertex 6
   in addition to vertex 2, which the single-axis case misses). *)

VerificationTest[
  With[ { g = CycleGraph[ 6 ] },
    FindInfraRevolution[ g,
      geodesicGraph /@ { { 1, 2, 3, 4 }, { 1, 6, 5, 4 } },
      { 0, 1, 0, 0 }, "Form" -> "Solid" ] ],
  { 1, 2, 3, 4, 5, 6 },
  TestID -> "FindInfraRevolution-multi-axis-thick"
]


(* Single-axis variant of the same profile gives a strictly smaller set. *)

VerificationTest[
  With[ { g = CycleGraph[ 6 ] },
    FindInfraRevolution[ g, { 1, 2, 3, 4 }, { 0, 1, 0, 0 }, "Form" -> "Solid" ] ],
  { 1, 2, 3, 4 },
  TestID -> "FindInfraRevolution-single-axis-thinner"
]
