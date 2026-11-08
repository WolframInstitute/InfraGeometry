---
Template: TechNote
Name: SpatialCoordinatization
Title: Spatial Coordinatization
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/tutorial/SpatialCoordinatization
Keywords: [causal graph, foliation, spatial reconstruction, coordinate axes, projection, fibered graph]
RelatedGuides: [InfraCausality, RiemannianInfrageometry, InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

We reconstruct spatial graphs from a causal history and assign integer coordinates using four persistent landmarks.
Coordinate fibers retain the events that these coordinates identify.
These examples require the current package version.
When using the notebook in the source checkout, register the local paclet first.

```wl
PacletDirectoryLoad[ ExpandFileName[ FileNameJoin[ { NotebookDirectory[ ], "..", "..", ".." } ] ] ];
Needs[ "WolframInstitute`InfraGeometry`" ]
```

## A causal history and a frame

At each time, take the points $x\in\{-1,0,1\}^3$.
An event $(t,x)$ has arrows to $(t+1,x)$ and each available $(t+1,x+e_i)$.
The chains at $0,e_1,e_2,e_3$ meet every time slice once.
They will specify an origin and three directions.
The tuple labels construct this example and position its pictures; the reconstruction uses graph adjacency.

```wl
causalGrid[ dimension_Integer ] :=
  With[ { points = Tuples[ Range[ -1, 1 ], dimension ],
      directions = Prepend[ IdentityMatrix[ dimension ], ConstantArray[ 0, dimension ] ] },
    { slices = Table[ event[ time, # ] & /@ points, { time, 0, 3 } ] },
    { edges = Catenate @ Table[ Catenate @ Map[ point |-> Map[
        step |-> If[ MemberQ[ points, point + step ],
          DirectedEdge[ event[ time, point ], event[ time + 1, point + step ] ], Nothing ],
        directions ], points ], { time, 0, 2 } ] },
    <| "Graph" -> Graph[ Catenate[ slices ], edges ],
      "Chains" -> Map[ point |-> Table[ event[ time, point ], { time, 0, 3 } ], directions ] |> ]

oblique[ point_List ] :=
  If[ Length[ point ] === 2, point,
    { point[[ 1 ]] + point[[ 3 ]] / 3, point[[ 2 ]] + point[[ 3 ]] / 2 } ]

causalData = causalGrid[ 3 ];
causalGraph = causalData[ "Graph" ];
chains = causalData[ "Chains" ];
foliation = CausalHeightFoliation[ causalGraph ];
```

Height is time in both pictures.
The left example has two spatial directions; the right has three, drawn obliquely within each layer.
Colors track the same landmarks through the history.

```wl
GraphicsRow[ Map[ data |-> With[
  { graph = data[ "Graph" ], walks = data[ "Chains" ],
    colors = Take[ { StandardBlue, StandardOrange, StandardGreen, StandardPurple }, Length[ data[ "Chains" ] ] ] },
  Graph3D[ graph,
    VertexCoordinates -> Map[ vertex |-> Append[ oblique[ Last[ vertex ] ], 1.6 First[ vertex ] ], VertexList[ graph ] ],
    VertexStyle -> Prepend[ Catenate @ MapThread[
      { walk, color } |-> Thread[ walk -> color ], { walks, colors } ], GrayLevel[ .75 ] ],
    EdgeStyle -> Prepend[ Catenate @ MapThread[
      { walk, color } |-> Thread[ ( DirectedEdge @@@ Partition[ walk, 2, 1 ] ) -> Directive[ color, Thick ] ],
      { walks, colors } ], Directive[ GrayLevel[ .75 ], Opacity[ .15 ], Arrowheads[ .018 ] ] ],
    VertexSize -> Map[ vertex |-> vertex -> If[ MemberQ[ Catenate[ walks ], vertex ], .12, .04 ], VertexList[ graph ] ],
    VertexLabels -> None, Boxed -> False, ImageSize -> 500 ] ],
  { causalGrid[ 2 ], causalData } ], ImageSize -> 1000 ]
```

## Reconstruct every later slice

[CausalSpatialGraphs]() joins events with a common ancestor in the preceding slice.
The first slice has no past in this finite history, so its spatial graph has no edges.
Each later graph has 27 vertices and 90 edges, with displacements $\pm e_i$ and $\pm(e_i-e_j)$.

Intersect each chain with the actual slice to obtain its frame.
[FindInfraCoordinateAxes]() selects oriented geodesic axes, and [RectilinearCoordinates]() projects onto them.
Here the three axes are $(-e_i,0,e_i)$.
In general, the automatic axes extend shortest germs without increasing the excess of interval vertices over path vertices.
This is a specified selection rule; explicit axes can instead be supplied with `"Axes"`.
Nearby spatial direction points can be selected from an `InfraShell`; their causal continuation remains additional frame data.

```wl
spatialGraphs = CausalSpatialGraphs[ causalGraph, foliation ];
frames = AssociationMap[ index |-> Map[ chain |-> First[ Intersection[ chain, foliation[[ index ]] ] ], chains ],
  Rest[ Keys[ spatialGraphs ] ] ];
axes = AssociationMap[ index |-> FindInfraCoordinateAxes[ spatialGraphs[ index ], frames[ index ] ], Keys[ frames ] ];
coordinates = AssociationMap[ index |-> RectilinearCoordinates[ spatialGraphs[ index ], frames[ index ],
  "Axes" -> axes[ index ] ], Keys[ frames ] ];
spatial = spatialGraphs[ 2 ];
frame = frames[ 2 ];
projection = coordinates[ 2 ];
{ EdgeCount /@ spatialGraphs, SameQ @@ ( Values /@ Values[ coordinates ] ) }
```

The last result confirms that these coordinates agree across the later slices after changing time labels.
The frame tracks landmarks; parallel transport of other states would require a connection.

```wl
InfraSubstrateHighlight[
  Graph3D[ spatial, VertexCoordinates -> ( Last /@ VertexList[ spatial ] ), Boxed -> False ],
  Append[ MapThread[ { axis, color } |-> Style[ InfraWalk[ axis ], color, AbsoluteThickness[ 3 ] ],
    { axes[ 2 ], { StandardOrange, StandardGreen, StandardPurple } } ],
    Style[ First[ frame ], StandardBlue, AbsolutePointSize[ 9 ] ] ],
  VertexLabels -> None, ImageSize -> 650 ]
```

## Integer projections and ties

Number each axis by signed distance from the origin.
For a vertex $v$, let $P_i(v)$ be its nearest vertices on axis $i$, using spatial graph distance.
The default coordinate is $x_i(v)=\min\{s_i(w):w\in P_i(v)\}$.

The point $-e_1$ is one step from both $0$ and $-e_2$, and similarly for the third axis.
`Min` gives $(-1,-1,-1)$; `Max` gives $(-1,0,0)$.
Removing the diagonal edges gives a Cartesian-grid calibration, whose coordinates recover all 27 original tuples.

```wl
With[ { vertex = event[ 1, { -1, 0, 0 } ],
    grid = Graph[ VertexList[ spatial ], Select[ EdgeList[ spatial ],
      edge |-> ManhattanDistance @@ ( Last /@ List @@ edge ) === 1 ] ] },
  { calibration = RectilinearCoordinates[ grid, frame ] },
  <| "Min" -> Lookup[ projection, Key[ vertex ] ],
    "Max" -> RectilinearCoordinates[ spatial, frame, "SelectCoordinate" -> Max ][ vertex ],
    "CartesianCoordinates" -> ( Values[ calibration ] === ( Last /@ VertexList[ grid ] ) ),
    "CartesianBaseSize" -> VertexCount[ InfraBaseSpace[ InfraFiberedGraph[ grid, calibration ] ] ] |> ]
```

## Retain collapsed events as fibers

[InfraFiberedGraph]() keeps the spatial graph as total space and uses its coordinates as the projection.
Here 27 events give 15 base tuples: eleven singleton fibers, three pairs, and one ten-event fiber.
The pictures mark that large fiber and its base point $(-1,-1,-1)$.
The base is drawn at its actual integer coordinates.

```wl
fibered = InfraFiberedGraph[ spatial, projection ];
base = InfraBaseSpace[ fibered ];
GraphicsRow[ {
  InfraSubstrateHighlight[
    Graph3D[ spatial, VertexCoordinates -> ( Last /@ VertexList[ spatial ] ), Boxed -> False ],
    { Style[ InfraFiber[ fibered, { -1, -1, -1 } ], StandardBlue ] },
    VertexLabels -> None, ImageSize -> 500 ],
  Graph3D[ base, VertexCoordinates -> VertexList[ base ],
    VertexStyle -> { { -1, -1, -1 } -> StandardBlue }, VertexLabels -> None,
    Boxed -> False, ImageSize -> 500 ] }, ImageSize -> 1000 ]
```

Select a coordinate to inspect its fiber.
The explorer uses an oblique planar layout of the base, with fibers arranged above their base points.
The projection labels remain integer triples; the drawing coefficients are not coordinates assigned by the construction.
The pictures are computed before the selector, so the saved notebook opens with the geometry already visible.

```wl
With[ { points = VertexList[ base ], positions = AssociationMap[ oblique, VertexList[ base ] ] },
  { pictures = Map[ point |-> InfraFiberedGraphHighlight[ fibered,
      { Style[ InfraFiber[ fibered, point ], StandardBlue ] },
      "BaseVertexCoordinates" -> positions, Method -> "3DFiber", VertexLabels -> None, ImageSize -> 650 ], points ] },
  Manipulate[ pictures[[ index ]],
    { { index, 1, "Coordinate" }, Thread[ Range[ Length[ points ] ] -> points ], ControlType -> PopupMenu } ] ]
```

This is a fibered graph over a finite set of integer triples.
Its base need not be the nearest-neighbor lattice, and a fiber-bundle structure requires further conditions.
For nonorthogonal axes the projection labels are not oblique basis coefficients.

## Relations between slices

For the diamond $a\to\{b,c\}\to d$, the backward branch map sends both middle events to $a$.
The forward merge map sends them to $d$.
Backward from $d$, [CausalSliceRelation]() retains both candidates and [CausalSliceKernel]() assigns each weight $1/2$.

```wl
With[ { diamond = Graph[ { "a" -> "b", "a" -> "c", "b" -> "d", "c" -> "d" } ],
    slices = { { "a" }, { "b", "c" }, { "d" } } },
  <| "BackwardBranchMap" -> CausalSliceMap[ diamond, slices, { 2, 1 } ],
    "ForwardMergeMap" -> CausalSliceMap[ diamond, slices, { 2, 3 } ],
    "BackwardMergeRelation" -> CausalSliceRelation[ diamond, slices, { 3, 2 } ],
    "BackwardMergeKernel" -> CausalSliceKernel[ diamond, slices, { 3, 2 } ] |> ]
```

A map is automatic only when every causal image is a singleton.
An explicit `"SelectImage"` chooses among candidates, without making that choice canonical.
Such causal maps need not preserve spatial adjacency or be surjective, so they do not generally define a coarse graph quotient.
For a kernel with row sums one, transport by $\nu(y)=\sum_x\mu(x)K(x,y)$ preserves total mass.
An event with no causal image prevents a total map or conservative kernel; those calls remain unevaluated.
