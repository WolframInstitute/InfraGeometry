Package["WolframInstitute`SyntheticInfrageometry`"]

(* usage-message rules: CLAUDE.md "Usage messages" *)

(* ===================== InfraPoint ===================== *)

InfraPoint::usage = "InfraPoint is the scene-language token for the point search -- FindInfraPoint minus the graph. InfraPoint[] draws from the whole vertex list, InfraPoint[v] names one vertex, InfraPoint[\"Center\"] / InfraPoint[\"Periphery\"] a pool, InfraPoint[origin, d] the vertices at distance d, InfraPoint[n, \"Distance\" -> spec] an n-tuple. It is not a wrapper: a point IS a vertex of the substrate, carrying its label verbatim.";
FindInfraPoint::usage = "FindInfraPoint[graph] draws a vertex from the candidate pool; a trailing n | UpTo[n] | All sets the count and returns a List of vertices. Options \"From\", \"Distance\", \"MaxCliques\".";
FindInfraMidpoint::usage = "FindInfraMidpoint[graph, p1, p2] gives the density <|v -> m, ...|> of the middle vertices of every geodesic from p1 to p2 (one vertex at even distance, two at odd). Option Method.";
FindInfraGoldenSection::usage = "FindInfraGoldenSection[graph, p1, p2] gives the density <|v -> m, ...|> at the golden-ratio index along every geodesic from p1 to p2. Option Method.";
FindInfraReflection::usage = "FindInfraReflection[graph, x, a] gives the reflections x' of x through a: the vertices with B(x, a, x') and d(a, x) == d(a, x').";
CompleteInfraEquilateralTriangle::usage = "CompleteInfraEquilateralTriangle[graph, p1, p2] gives the apexes equidistant from p1 and p2 at distance d(p1, p2) (Euclid I.1).";
FindInfraCommonPoint::usage = "FindInfraCommonPoint[graph, lines] gives the points lying on every listed line.";
FindClosestInfraPoint::usage = "FindClosestInfraPoint[graph, line, point] gives the vertices of line at minimum graph distance from point.";
SelectInfraPoint::usage = "SelectInfraPoint[graph, vertices] draws a vertex from a supplied bundle under graph distance; a trailing n | UpTo[n] | All sets the count. Options \"From\", \"Distance\", \"MaxCliques\".";
InfraReachableQ::usage = "InfraReachableQ[graph, p1, p2] tests whether p1 and p2 have realisations in the same connected component.";

(* ===================== InfraMeasurement ===================== *)

Undetermined::usage = "Undetermined is the value of the measurement \"Faithful\" on a head whose graph is faithful only under a hypothesis this paclet does not certify.";
InfraMeasurement::usage = "InfraMeasurement[graph, obj, property] measures a Euclidean head on graph: \"Graph\", \"Cardinality\", \"Length\", \"VertexDensity\", \"EdgeDensity\", \"Subgraph\", \"Faithful\", \"Volume\", \"BoundaryVolume\", \"InteriorVolume\", \"HalfBoundaryVolume\". A List of properties gives an Association, All gives them all, a List of heads measures each.";
InfraVertexList::usage = "InfraVertexList[graph, obj] gives one member of obj as a vertex list; a trailing n | UpTo[n] | All gives a List of them. Modifiers \"RandomChoice\" (a uniform member) and \"Pruning\" -> q.";
InfraMemberQ::usage = "InfraMemberQ[graph, obj, path] tests whether the vertex list path is a member of obj.";
InfraSubgraph::usage = "InfraSubgraph[graph, obj] gives the subgraph of graph induced on the support of obj; InfraSubgraph[graph, obj -> t] thickens the support by t steps.";

(* ===================== InfraSegment ===================== *)

InfraSegment::usage = "InfraSegment[p1, ..., pk] is the inert polyline of the segments [p1, p2], ..., [p(k-1), pk]; InfraSegment[p, q] is the segment itself, whose graph is the geodesic interval I(p, q). InfraMeasurement and InfraVertexList evaluate it on a graph; FindInfraSegment is the search.";
FindInfraSegment::usage = "FindInfraSegment[graph, p, q] gives one geodesic from p to q as a vertex list; a trailing n | UpTo[n] | All gives a List of them.";
ExtendInfraSegment::usage = "ExtendInfraSegment[graph, seg, kspec] gives the geodesics containing seg extended by at most kspec edges per side, inextensible within that budget; kspec Infinity gives the lines through seg. ExtendInfraSegment[graph, a, b, c, d] gives the x with B(a, b, x) and d(b, x) == d(c, d) (Tarski A4). Options Method, \"Direction\".";
InfraWalkQ::usage = "InfraWalkQ[graph, walk] tests whether walk is a walk: consecutive vertices adjacent (revisits allowed).";
InfraSegmentQ::usage = "InfraSegmentQ[graph, walk] tests whether walk is a geodesic.";
UniqueInfraSegmentQ::usage = "UniqueInfraSegmentQ[graph, u, v] tests whether the u-v geodesic is unique; UniqueInfraSegmentQ[graph] tests the geodetic property.";

(* ===================== InfraWalk ===================== *)

InfraWalk::usage = "InfraWalk[p1, ..., pk] inside InfraScene is the literal walk through p1, ..., pk. A walk itself is a Graph: a directed path on the position pairs {i, v}, a closed walk a directed cycle on them; Last /@ VertexList gives the vertex sequence.";
FindInfraWalk::usage = "FindInfraWalk[graph, p1, kspec] grows the walks from p1 in the class cut by the Properties rules (default {\"Simple\"}) until a stopping condition or the budget kspec (UpTo[k], {k}, {lo, hi}, Infinity) stops them; FindInfraWalk[graph, p1, p2, kspec] keeps those ending at p2. Each walk is a path graph on position pairs. Options \"InfraScale\", Properties, \"StoppingCondition\", Method.";
FindInfraGeodesic::usage = "FindInfraGeodesic[graph, p1, scale, kspec] grows the geodesics at infra-scale scale from p1 -- FindInfraWalk at \"InfraScale\" -> scale with \"Minimizing\" among the rules; FindInfraGeodesic[graph, p1, p2, scale, kspec] keeps those ending at p2. Options Properties, \"StoppingCondition\", Method.";
InfraGeodesicQ::usage = "InfraGeodesicQ[graph, walk, scale] tests whether every window of scale consecutive vertices of walk plus the next one is a shortest path; scale 1 gives InfraWalkQ and Infinity gives InfraSegmentQ.";
WalkSingularities::usage = "WalkSingularities[walk] gives the singularities of a walk (a vertex list or a walk graph; a cycle graph is read on its cyclic core) as parameter data: \"SelfIntersections\" (position groups sharing a vertex), \"SelfTangencies\" (oriented interval groups sharing an arc), \"Cusps\" (mirrored blocks).";
InfraImmersedQ::usage = "InfraImmersedQ[graph, walk] tests whether walk is an immersed walk: a walk with no cusp (no backtrack).";
InfraGenericQ::usage = "InfraGenericQ[graph, walk] tests whether walk is a generic immersed curve: no cusps, no self-tangencies, every self-intersection a double point off the endpoints.";
InfraWalkCrossingQ::usage = "InfraWalkCrossingQ[graph, walk, v, r] tests whether the double visit of walk at v is a transverse crossing at scale r: the two passes separate each other's exits on the shell {r, r+1}; {i, j} names two positions instead.";
ExtendInfraWalk::usage = "ExtendInfraWalk[graph, seed, kspec] continues a seed walk -- a vertex list or a walk graph -- in the class cut by the Properties rules (default {\"Simple\"}) until a stopping condition or the budget kspec (UpTo[k], {k}, {lo, hi}, Infinity; edges added per growing side) stops it. Options \"InfraScale\", Properties, \"StoppingCondition\", Method, \"Direction\".";
ExtendInfraGeodesic::usage = "ExtendInfraGeodesic[graph, seed, scale, kspec] continues a seed walk as a geodesic at infra-scale scale -- ExtendInfraWalk at \"InfraScale\" -> scale with \"Minimizing\" among the rules. Options Properties, \"StoppingCondition\", Method, \"Direction\".";
ConcatenateInfraWalk::usage = "ConcatenateInfraWalk[path1, path2] joins every compatible walk pair, those with Last[walk1] === First[walk2].";

(* ===================== InfraLine ===================== *)

InfraLine::usage = "InfraLine[graph, p, q] is the pool of lines -- inextensible geodesics -- through p and q as one object; InfraLine[graph, walk] the lines containing a walk graph or an InfraSegment. line[[i]] enumerates in canonical order, Normal all; \"Multiplicity\", \"InfraDensity\", \"Length\", \"Graph\" read the DAGs. Inside InfraScene, InfraLine[p, q] and InfraLine[path] are the construction tokens; FindInfraLine is the search.";
FindInfraLine::usage = "FindInfraLine[graph, p1, p2] gives the lines through p1 and p2, the inextensible geodesics containing them; FindInfraLine[graph, segment] those containing segment. Options Method, \"Direction\".";
FindInfraParallel::usage = "FindInfraParallel[graph, line, p] gives one parallel to line through p: a geodesic through p inextensible within the level set { v : d(v, line) == d(p, line) }; a trailing n | UpTo[n] | All sets the count, All giving the pool. Option Method.";
FindInfraPerpendicular::usage = "FindInfraPerpendicular[graph, line, point] gives the lines through point perpendicular to line. Options Method, \"Radius\".";
FindInfraCommonLine::usage = "FindInfraCommonLine[graph, vertices] gives the canonical lines containing every listed vertex.";
InfraLineQ::usage = "InfraLineQ[graph, walk] tests whether walk is a line: a geodesic that no neighbour of either endpoint prolongs.";
InfraParallelQ::usage = "InfraParallelQ[graph, l1, l2] tests whether two lines stay at constant distance; a trailing threshold allows that distance to vary.";
InfraPerpendicularQ::usage = "InfraPerpendicularQ[graph, l1, l2] tests whether two lines meet perpendicularly at every common vertex. Options Method, \"Radius\".";
PencilDirections::usage = "PencilDirections[graph, O] gives the pencil at O: every ray from O, as a list of vertex sequences.";
PencilCardinality::usage = "PencilCardinality[graph, O] gives the number of rays from O, counted on the ray pools without enumeration.";
LineCount::usage = "LineCount[graph] gives the number of distinct canonical maximal geodesics in graph.";
FindLineHull::usage = "FindLineHull[graph, S] gives, as the multiset <|v -> 1, ...|>, the smallest superset of S closed under the line operator. Option \"LineStructure\".";
LineHullQ::usage = "LineHullQ[graph, S] tests whether S is closed under the line operator.";
UniversalLineQ::usage = "UniversalLineQ[graph] tests whether some pair spans a line filling a whole connected component (Chen-Chvatal); UniversalLineQ[graph, {u, v}] tests one line.";

(* ===================== InfraLineStructure ===================== *)

InfraLineStructure::usage = "InfraLineStructure[{line1, ...}] is a consistent geodesic path system, stored as its maximal lines. Accessors \"Lines\", \"Paths\", \"Incidence\", \"Coordinates\", [\"Path\", u, v].";
FindLineStructure::usage = "FindLineStructure[graph] gives a consistent geodesic path system: one shortest path per vertex pair, with every stretch of a chosen path again chosen. Option Method sets the tie-breaking edge ranking.";
ConsistentPathSystemQ::usage = "ConsistentPathSystemQ[graph, obj] tests whether a geodesic path system is subpath-closed (Cizma-Linial consistent).";

(* ===================== InfraShell ===================== *)

InfraShell::usage = "InfraShell[center, r] inside InfraScene is the metric shell of radius r about center -- a level set of the distance from center; FindInfraShell is the search. A shell itself is a sorted vertex list.";
FindInfraShell::usage = "FindInfraShell[graph, c, r] gives the metric shell { v : d(c, v) == r }; r may be a band {rmin, rmax}. Options Properties, Method.";
FindInfraOsculatingShell::usage = "FindInfraOsculatingShell[graph, path, i, k] gives the shells whose level set contains the k-vertex window of path centred at position i, one per osculating centre.";
FindAdvancingInfraFront::usage = "FindAdvancingInfraFront[graph, origin, steps] gives the foliation by a bouncing wavefront as a List of multisets <|v -> 1, ...|>: each front steps one geodesic step outward and reflects inward where it cannot.";
FindInfraShellCenter::usage = "FindInfraShellCenter[graph, shell] recovers {center, radii} from a shell. Option Method.";
InfraShellQ::usage = "InfraShellQ[graph, vertexSet] tests whether vertexSet is a metric shell { v : d(c, v) == r } for some centre c and radius r.";
SeparatesQ::usage = "SeparatesQ[graph, vertexSet, u, v] tests whether deleting vertexSet disconnects u from v.";

(* ===================== InfraBall ===================== *)

InfraBall::usage = "InfraBall[center, r] inside InfraScene is the closed metric ball of radius r about center; FindInfraBall is the search. A ball itself is a sorted vertex list.";
FindInfraBall::usage = "FindInfraBall[graph, c, r] gives the closed ball { v : d(c, v) <= r }.";
InfraBallQ::usage = "InfraBallQ[graph, vertexSet] tests whether vertexSet is a closed metric ball.";
FindBallHull::usage = "FindBallHull[graph, S] gives, as the multiset <|v -> 1, ...|>, the ball hull of S: the intersection of all closed balls containing S, the smallest ball-convex superset.";
BallHullQ::usage = "BallHullQ[graph, S] tests whether S is ball-convex, i.e. an intersection of closed balls.";

(* ===================== InfraCircle ===================== *)

InfraCircle::usage = "InfraCircle[graph, c, p] is the object of circles around c through p: the shortest simple cycles through p in the band of radius d(c, p) that separate c from beyond, with p their source and sink. circle[[i]] enumerates them as directed cycle graphs, \"Multiplicity\", \"InfraDensity\", \"Length\", \"Graph\" read the carrier. Option \"Tolerance\" (t or {tIn, tOut}) widens the band about d(c, p). Inside InfraScene, InfraCircle[center, r] is the construction token; FindInfraCircle is the search by radius.";
FindInfraCircle::usage = "FindInfraCircle[graph, c, r] gives one circle around c at radius r: a shortest cycle in the level surface separating c from beyond; r may be a band {rmin, rmax}; All gives the circle pool. Options Properties, Method.";
InfraArc::usage = "InfraArc[graph, c, p, q] is the arc around c from p to q as one object: the shortest paths from p to q inside the band of radius d(c, p), one geodesic DAG with source p and sink q. arc[[i]] enumerates, \"Multiplicity\", \"InfraDensity\", \"Length\", \"Graph\" read the DAG. Option \"Tolerance\" (t or {tIn, tOut}) widens the band.";
FindInfraCycle::usage = "FindInfraCycle[graph, n] gives the n shortest simple cycles of graph; FindInfraCycle[graph, {kmin, kmax}, n] restricts their length.";
InfraCircleQ::usage = "InfraCircleQ[graph, cycle] tests whether cycle is a cyclic edge chain whose vertex set is a metric shell.";

(* ===================== InfraPolygon ===================== *)

InfraPolygon::usage = "InfraPolygon[{v1, ..., vn}] inside InfraScene is the closed geodesic chain through the given corners, InfraPolygon[pool, n] the n-gon search over a pool; FindInfraPolygon is the search. A polygon itself is the List of its sides, one directed path graph each, consecutive sides sharing a corner.";
FindInfraPolygon::usage = "FindInfraPolygon[graph, {p1, ..., pn}] gives one polygon with corners p1, ..., pn: a geodesic between each pair of consecutive corners; a trailing n | UpTo[n] | All sets the count. Option Method.";
FindInfraRegularPolygon::usage = "FindInfraRegularPolygon[graph, As, n] gives one closed n-vertex sequence whose k-th diagonal distances all match As[[k]] (each slot an Integer, {lo, hi}, or Automatic); a trailing n | UpTo[n] | All sets the count. Options Method, \"From\".";
InfraPolygonQ::usage = "InfraPolygonQ[graph, poly] tests whether poly is a closed cyclic chain of geodesic sides.";
InfraRegularPolygonQ::usage = "InfraRegularPolygonQ[graph, cycle, As] tests whether cycle is regular with respect to the diagonal-distance tuple As.";

(* ===================== InfraTriangle ===================== *)

InfraTriangle::usage = "InfraTriangle[{a, b, c}] inside InfraScene is the geodesic triangle on three corners, the n = 3 case of InfraPolygon; FindInfraTriangle is the search. A triangle itself is the List of its three sides, one directed path graph each.";
FindInfraTriangle::usage = "FindInfraTriangle[graph, {a, b, c}] gives one triangle with corners a, b, c and a geodesic on each side; a trailing n | UpTo[n] | All sets the count. Option Method.";
InfraTriangleQ::usage = "InfraTriangleQ[graph, poly] tests whether poly is a closed chain of exactly three geodesic sides.";

(* ===================== InfraEllipticShell ===================== *)

InfraEllipticShell::usage = "InfraEllipticShell names the elliptic-shell construction -- a level set of a sum of distances to two foci -- and carries no value of its own; FindInfraEllipticShell is the search and gives a sorted vertex list.";
FindInfraEllipticShell::usage = "FindInfraEllipticShell[graph, {p1, p2}, c] gives the elliptic shell { v : d(p1, v) + d(p2, v) == c }; c may be a band {cmin, cmax}. Options Properties, Method.";
InfraEllipticShellQ::usage = "InfraEllipticShellQ[graph, vertexSet] tests whether vertexSet is an elliptic shell for some pair of foci and some constant.";

(* ===================== InfraQuadric ===================== *)

FindInfraQuadric::usage = "FindInfraQuadric[graph, {p1, ..., pk}, c] gives the solid interior { v : Sum_i d(p_i, v) <= c }; a trailing weight list gives the signed sum, so weights {1, -1} give a hyperboloid branch.";

(* ===================== InfraEllipse ===================== *)

InfraEllipse::usage = "InfraEllipse names the metric-ellipse construction -- a cycle lying on an elliptic shell -- and carries no value of its own; FindInfraEllipse is the search and gives a directed cycle graph.";
FindInfraEllipse::usage = "FindInfraEllipse[graph, {p1, p2}, c] gives one shortest separating cycle in the level surface { v : d(p1, v) + d(p2, v) == c }; a trailing n | UpTo[n] | All sets the count. Options Properties, Method.";
InfraEllipseQ::usage = "InfraEllipseQ[graph, cycle] tests whether cycle is a cyclic edge chain whose vertex set is an elliptic shell.";

(* ===================== InfraPlane ===================== *)

InfraPlane::usage = "InfraPlane[p1, p2] inside InfraScene is the bisecting hyperplane of p1 and p2; FindInfraBisectingHyperplane is the search. A plane itself is a sorted vertex list.";
FindInfraBisectingHyperplane::usage = "FindInfraBisectingHyperplane[graph, p1, p2] gives the perpendicular bisector { v : d(p1, v) == d(p2, v) }; a positional {lo, hi} widens it to a slab. Options Properties, Method.";

(* ===================== InfraRay ===================== *)

InfraRay::usage = "InfraRay[p, q] is the inert ray from p through q, whose graph is the ray DAG R(p, q); InfraRay[p, p] is the pencil at p. InfraMeasurement and InfraVertexList evaluate it on a graph; FindInfraRay is the search.";
FindInfraRay::usage = "FindInfraRay[graph, p, q] gives one ray from p through q as a vertex list -- a geodesic from p through q that no neighbour of its last vertex prolongs; a trailing n | UpTo[n] | All gives a List of them.";
InfraRayQ::usage = "InfraRayQ[graph, ray] tests whether ray is a pointed half-line: a geodesic from its own first vertex that cannot be prolonged past its last.";

(* ===================== InfraPolyline ===================== *)

InfraPolyline::usage = "InfraPolyline[{v1, ..., vk}] inside InfraScene is the open geodesic chain through the given knots; FindInfraPolylineSubdivision chunks a walk into such legs. A polyline itself is the List of its legs, one directed path graph each, consecutive legs sharing a knot.";
FindInfraPolylineSubdivision::usage = "FindInfraPolylineSubdivision[graph, path] chunks a walk into the fewest geodesic legs whose knots are walk vertices. Option \"MaxLength\" caps each leg.";
InfraPolylineQ::usage = "InfraPolylineQ[graph, poly] tests whether every leg is a geodesic and consecutive legs share an endpoint.";

(* ===================== InfraRevolution ===================== *)

InfraRevolution::usage = "InfraRevolution[axis, profile] is the InfraScene constructor for a solid of revolution.";
FindInfraRevolution::usage = "FindInfraRevolution[graph, axis, profile] gives the rotational vertex set around axis with the given radius profile, a constant, list, association, or function. Options \"Form\", Method.";
FindInfraCylinder::usage = "FindInfraCylinder[graph, axis, r] gives the constant-radius solid of revolution around axis, by default the r-neighbourhood of the axis.";
FindInfraCone::usage = "FindInfraCone[graph, axis, slope] gives the cone of the given slope with apex at one end of axis. Option \"Apex\".";
InfraRevolutionQ::usage = "InfraRevolutionQ[graph, vs, axis, profile] tests whether vs is the solid of revolution around axis with the given profile. Option \"Form\".";

(* ===================== EuclideanSpace ===================== *)

InfraScalarProduct::usage = "InfraScalarProduct[graph, o, u, v] gives the base-point-relative product d(o, u) d(o, v) cos(theta), at curvature 0 the polar form (d(o,u)^2 + d(o,v)^2 - d(u,v)^2)/2. Option Method.";
FindInfraLinearCombination::usage = "FindInfraLinearCombination[graph, o, {{lambda1, u1}, ...}] gives the vertex realisations of Sum_i lambda_i u_i based at o. Options \"ScaleMethod\", \"SumMethod\".";
InfraAngle::usage = "InfraAngle[graph, {q1, p, q2}] gives the angle at p in radians. Option Method (\"Arclength\", \"Alexandrov\").";

(* ===================== InfraCurveGeometry ===================== *)

TurningAngles::usage = "TurningAngles[graph, path] gives the exterior angles Pi - InfraAngle at each interior vertex of path; for an InfraPolyline, the angles at its knots.";
TotalCurvature::usage = "TotalCurvature[graph, path] gives Total @ TurningAngles[graph, path], the discrete total curvature of path.";
TotalAbsoluteCurvature::usage = "TotalAbsoluteCurvature[graph, path] gives Total @ Abs @ TurningAngles[graph, path], the discrete Fenchel integral of |kappa|.";
TurningNumber::usage = "TurningNumber[graph, cycle] gives TotalCurvature[graph, cycle] / (2 Pi).";

(* ===================== AlexandrovGeometry ===================== *)

ComparisonTriangle::usage = "ComparisonTriangle[a, b, c] gives the Euclidean Triangle with side lengths a, b, c; ComparisonTriangle[graph, p, q, r] reads the sides from the graph. Option \"Curvature\" places it in M_k^2.";
InfraComparisonTriangle::usage = "InfraComparisonTriangle[<|...|>] is the wrapper for comparison triangles of nonzero curvature. Accessors \"Sides\", \"Curvature\", \"Angles\".";
CATInequalityQ::usage = "CATInequalityQ[graph, {p, q, r}, k] tests whether the geodesic triangle on p, q, r satisfies the CAT(k) thinness inequality. Option Method (\"ApexSide\", \"TwoRays\").";
InfraCurvature::usage = "InfraCurvature[graph, v] gives the local Alexandrov upper curvature bound at v: the supremum of per-triangle CAT bounds inside a ball around v. Option \"Radius\".";

(* ===================== WalkSpace ===================== *)

SelectInfraWalk::usage = "SelectInfraWalk[graph, walks] draws a walk from a bundle -- vertex lists or walk graphs, cycle graphs selecting as closed walks -- treated as a metric space. Options \"From\", \"Distance\", \"Metric\", \"MaxCliques\", \"Cyclic\".";
EmbeddingClosest::usage = "EmbeddingClosest[graph, bundle, ref] keeps the bundle elements drawn closest to a Euclidean reference under GraphEmbedding; ref is {p1, p2}, {center, radius}, or a curve.";
FindEmbeddingClosestPath::usage = "FindEmbeddingClosestPath[graph, curve] snaps an embedded curve to a walk graph, mapping sampled points to nearest vertices and joining them by geodesics.";
GeodesicSprayGraph::usage = "GeodesicSprayGraph[graph, c] gives the BFS DAG rooted at c, whose directed source-to-sink paths are exactly the maximal geodesics from c; GeodesicSprayGraph[graph, pairs] gives the union of geodesics between listed pairs.";
GeodesicExtensionGraph::usage = "GeodesicExtensionGraph[graph, {p1, p2}] gives the DAG of geodesic extensions of the segment p1 -> p2 beyond p2: the vertices e with d(p1, e) == d(p1, p2) + d(p2, e), edges along increasing distance from p1; wrapper anchors give one DAG per pair.";
PathSubgraph::usage = "PathSubgraph[graph, u, v] gives the union of all shortest u-v paths; a trailing length cap or All widens it to longer simple paths.";
InfraDeformationSize::usage = "InfraDeformationSize[ref, walk] gives the number of ref edges that walk replaces -- Length[ref] - 1 less the shared prefix and suffix.";

(* ===================== Homotopy ===================== *)

FindInfraHomotopyRepresentative::usage = "FindInfraHomotopyRepresentative[graph, walk] gives the length-shortest walks in the homotopy class of walk -- an open walk with its endpoints fixed, a cycle graph a loop with its base point fixed, \"FreeHomotopy\" -> True freeing either. Options Method, \"FreeHomotopy\", \"NullHomotopicCycles\", \"MaxLength\", \"MaxMoves\".";
FindInfraHomotopyRepresentativeHomotopy::usage = "FindInfraHomotopyRepresentativeHomotopy[graph, obj] gives the chain of elementary moves reducing obj to a shortest representative. Options as FindInfraHomotopyRepresentative.";
FindInfraHomotopy::usage = "FindInfraHomotopy[graph, a, b] gives one chain of elementary moves from a to b as the List of walk graphs it passes through, { } when there is none; a bounded count or All gives a List of chains. Both walks must be open or both closed. Options as FindInfraHomotopyRepresentative.";
HomotopicQ::usage = "HomotopicQ[graph, a, b] tests whether a and b lie in the same homotopy class.";
NullHomotopicQ::usage = "NullHomotopicQ[graph, cycle] tests whether a closed walk -- a vertex list read cyclically, or a cycle graph -- is null-homotopic.";
HomotopyMoveType::usage = "HomotopyMoveType[walk1, walk2] classifies an elementary move as \"Contract\", \"Extend\", or \"Lateral\".";
HomotopyMoveTypes::usage = "HomotopyMoveTypes[chain] applies HomotopyMoveType to each consecutive pair of a homotopy chain.";

(* ===================== MetricAlgebra ===================== *)

MetricInterval::usage = "MetricInterval[graph, u, v] gives { w : d(u, w) + d(w, v) == d(u, v) }, the union of all geodesics from u to v.";
GeodesicMultiplicity::usage = "GeodesicMultiplicity[graph, u, v] gives the number of distinct geodesics from u to v.";
GeodesicMultiplicityMatrix::usage = "GeodesicMultiplicityMatrix[graph] gives {D, M} with D the distance matrix and M the matrix of geodesic counts.";
MedianVertices::usage = "MedianVertices[graph, vs] gives the vertices minimising the sum of distances to vs.";
FindSegmentHull::usage = "FindSegmentHull[graph, S] gives, as the multiset <|v -> 1, ...|>, the smallest superset of S closed under MetricInterval -- the geodesic convex hull. Option \"LineStructure\".";
SegmentHullQ::usage = "SegmentHullQ[graph, S] tests whether S is geodesically convex.";

(* ===================== Visit measure ===================== *)

InfraDensity::usage = "InfraDensity[graph, x] gives the marginal of any shape to the vertex set, <|v -> m|>, with respect to the counting measure: a vertex gives <|v -> 1|>, a vertex list its Counts, a density itself, a walk graph or a bundle its vertex occupation. It is the one coercion in the API -- Keys demotes it back to the set, Counts promotes a list to one.";

(* ===================== Sets ===================== *)

(* a set is the multiset <| v -> m |> itself -- Keys is the support, Length the size -- so there is no head to document.  Unlike every other Infra head it names no construction, so it is not a scene token either: a literal vertex set is dispatched by shape *)
FindInfraEquidistantSet::usage = "FindInfraEquidistantSet[graph, {p1, ..., pn}] gives { v : d(p1, v) == ... == d(pn, v) } as the multiset <|v -> 1, ...|>; a trailing {lo, hi} thickens each bisector to a slab.";
InfraBoundary::usage = "InfraBoundary[graph, s] gives, as the multiset <|v -> 1, ...|>, the boundary of a vertex set, multiset or Infra* object. Option Method (\"Combinatorial\", \"Alexandrov\").";
InfraInterior::usage = "InfraInterior[graph, s] gives, as the multiset <|v -> 1, ...|>, the interior of a vertex set, multiset or Infra* object. Option Method (\"Combinatorial\", \"Alexandrov\").";
InfraVolume::usage = "InfraVolume[graph, s] gives the volume of a vertex set, multiset or Infra* object. Options \"Measure\" (\"FullCount\", \"WithoutBoundary\", \"HalfBoundary\", \"Boundary\"), Method.";

(* ===================== Coordinatization ===================== *)

OrthogonalCoordinates::usage = "OrthogonalCoordinates[graph, c, axes, v] gives the integer displacement of v along each axis through the centre c; without v, the association over all vertices. Option \"SelectCoordinate\".";
FindInfraOrthogonalFrame::usage = "FindInfraOrthogonalFrame[graph, c, axisLength] gives frames of mutually perpendicular geodesic axes through the centre c. Options Method, \"AxisCount\", \"BranchSampleSize\", \"SelectCoordinate\".";
FindInfraSpanningAxes::usage = "FindInfraSpanningAxes[graph, n] gives n mutually well-separated longest geodesics across graph, with no fixed centre. Options \"AxisDistance\", \"MinLength\", \"MinSeparation\", \"AxisThickness\", \"RandomPick\".";

(* ===================== TarskiGeometry ===================== *)

BetweennessQ::usage = "BetweennessQ[graph, u, w, v] tests Tarski betweenness B(u, w, v): w lies on a geodesic from u to v.";
EquidistanceQ::usage = "EquidistanceQ[graph, a, b, c, d] tests Tarski equidistance d(a, b) == d(c, d).";
TarskiStructure::usage = "TarskiStructure[graph] gives a memoized association of the Tarski primitives: vertices, distances, betweenness, equidistance, diameter.";
TarskiBetweennessTensor::usage = "TarskiBetweennessTensor[graph] gives the sparse rank-3 tensor whose nonzero entries are the triples with B(v_i, v_j, v_k).";
TarskiEquidistanceClasses::usage = "TarskiEquidistanceClasses[graph] gives the partition of unordered vertex pairs by distance value.";
TarskiCongruenceReflexivityQ::usage = "TarskiCongruenceReflexivityQ[graph] tests Tarski axiom A1, ab == ba. Always True on undirected simple graphs.";
TarskiCongruenceTransitivityQ::usage = "TarskiCongruenceTransitivityQ[graph] tests Tarski axiom A2, transitivity of congruence. A tautology of equality.";
TarskiCongruenceIdentityQ::usage = "TarskiCongruenceIdentityQ[graph] tests Tarski axiom A3, ab == cc implies a == b. Holds on connected simple graphs.";
TarskiSegmentConstructionQ::usage = "TarskiSegmentConstructionQ[graph] tests Tarski axiom A4, segment construction. Generally False on finite graphs.";
TarskiFiveSegmentsQ::usage = "TarskiFiveSegmentsQ[graph] tests Tarski axiom A5, five segments. Holds on median graphs. Option \"MaxTuples\" caps the O(n^8) search.";
TarskiBetweennessIdentityQ::usage = "TarskiBetweennessIdentityQ[graph] tests Tarski axiom A6, B(a, b, a) implies a == b. Always True on connected simple graphs.";
TarskiInnerPaschQ::usage = "TarskiInnerPaschQ[graph] tests Tarski axiom A7, inner Pasch. Holds on median graphs; fails on cycles of length >= 5 and on Petersen.";
TarskiLowerDimensionQ::usage = "TarskiLowerDimensionQ[graph] tests Tarski axiom A8, the existence of three non-collinear points.";
TarskiUpperDimensionQ::usage = "TarskiUpperDimensionQ[graph] tests Tarski axiom A9, three points equidistant from two distinct points are collinear. False in effective dimension >= 3.";
TarskiEuclidAxiomQ::usage = "TarskiEuclidAxiomQ[graph] tests Tarski axiom A10, the parallel-axiom variant. Stub: returns Indeterminate.";
TarskiContinuityQ::usage = "TarskiContinuityQ[graph] tests Tarski axiom A11, Dedekind continuity. Always False on finite graphs.";
TarskiAxiomQ::usage = "TarskiAxiomQ[graph] gives the per-axiom results of all eleven Tarski axiom predicates.";
FindTarskiCounterexample::usage = "FindTarskiCounterexample[graph, predQ] gives vertex tuples witnessing the failure of a Tarski axiom predicate.";

(* ===================== ProjectiveGeometry ===================== *)

SameDirectionQ::usage = "SameDirectionQ[graph, O, v, w] tests whether v and w lie in the same direction at O, i.e. whether some ray from O through v contains w.";
CollinearQ::usage = "CollinearQ[graph, vertices] tests whether all listed vertices lie on a common line.";
ConcurrentQ::usage = "ConcurrentQ[graph, lines] tests whether all listed lines share a common vertex.";
UniqueCollinearQ::usage = "UniqueCollinearQ[graph, vertices] tests whether the listed vertices lie on a unique common line.";
UniqueConcurrentQ::usage = "UniqueConcurrentQ[graph, lines] tests whether the listed lines share exactly one common vertex.";
WhiteheadW1Q::usage = "WhiteheadW1Q[graph] tests Whitehead axiom W1: every line has at least three vertices.";
WhiteheadW2Q::usage = "WhiteheadW2Q[graph] tests Whitehead axiom W2: any two distinct vertices lie on exactly one line.";
WhiteheadW3Q::usage = "WhiteheadW3Q[graph] tests Whitehead axiom W3, the intersection property. O(|V|^4); use on small graphs.";
ProjectivePlaneGraphQ::usage = "ProjectivePlaneGraphQ[graph] tests whether graph is a synthetic projective plane: W1, W2, W3 and non-degeneracy.";

(* ===================== Enumeration ===================== *)

EnumerateGraphs::usage = "EnumerateGraphs[n, predQ] gives the connected n-vertex graphs from GraphData satisfying predQ. Option \"From\" supplies a different generator.";

(* ===================== Scenes ===================== *)

InfraScene::usage = "InfraScene[objects, hypotheses] builds a scene descriptor from symbolic objects and construction or assertion hypotheses. Properties \"Steps\", \"Constructions\", \"Assertions\", \"DependencyGraph\".";
FindInfraScene::usage = "FindInfraScene[scene, graph] solves a scene on a graph and gives the resulting InfraInstance bindings. Option \"PruneProbability\".";
InfraInstance::usage = "InfraInstance[bindings] wraps a solved binding association; InfraInstance[bindings, sym] reads one object out of it.";
InfraGeometricStep::usage = "InfraGeometricStep[{hyp1, ...}] groups hypotheses into one construction step of a scene; a second argument labels it.";
InfraIntersection::usage = "InfraIntersection[graph, obj1, obj2, ...] gives the vertex-set intersection of shapes on graph -- vertex lists, densities, walk graphs, bundles -- as a sorted List. Inside InfraScene it is the token InfraIntersection[c1, c2], the engine supplying the graph.";
InfraUnion::usage = "InfraUnion[graph, obj1, obj2, ...] gives the vertex-set union of shapes on graph as a sorted List. Inside InfraScene it is the token InfraUnion[c1, c2], the engine supplying the graph.";
InfraDistance::usage = "InfraDistance[graph, p, q] gives the graph distance between two Infra* objects, aggregated over their vertex sets. Option \"Aggregation\".";
InfraPlaneQ::usage = "InfraPlaneQ[graph, h, p1, p2] tests whether h lies in the bisector slab of p1, p2 and separates them; a trailing window widens the slab. The graph-free InfraPlaneQ[h, p1, p2] is the inert InfraScene assertion.";
InfraIntersectQ::usage = "InfraIntersectQ[s1, s2] asserts inside an InfraScene that two sets intersect; it stays inert until bindings resolve, which is why it exists rather than the built-in IntersectingQ.";

(* ===================== Highlights / Viewers ===================== *)

$InfraPointColor::usage   = "Default highlight color for points -- the shape classes Point and Density.";
$InfraSegmentColor::usage = "Default highlight color of the segment construction: the InfraSegment object draws in it when the palette is off, and a caller cites it by name.";
$InfraLineColor::usage    = "Default highlight color of the line construction: the InfraLine object draws in it when the palette is off, and a caller cites it by name.";
$InfraShellColor::usage   = "Default highlight color naming the shell construction. No shape defaults to it -- a caller cites it by name.";
$InfraBallColor::usage    = "Default highlight color for vertex sets -- the shape classes Set and SetFamily.";
$InfraPlaneColor::usage   = "Default highlight color naming the plane construction. No shape defaults to it -- a caller cites it by name.";
$InfraCircleColor::usage  = "Default highlight color of the circle construction: the InfraCircle and InfraArc objects draw in it when the palette is off, and a caller cites it by name.";
$InfraRayColor::usage     = "Default highlight color of the ray construction: the InfraRay object draws in it when the palette is off, and a caller cites it by name.";
$InfraWalkColor::usage    = "Default highlight color for walk graphs -- the shape classes Walk, Polyline and PolylineFamily.";
$InfraTopologyColor::usage = "Default highlight color for topology overlays.";
$InfraPalette::usage = "$InfraPalette is the Dataset of default colors, one row per named color, with columns \"Primitive\", \"Color\", \"Symbol\" and \"Shapes\" -- the shape classes that default to that color. Both the $Infra*Color symbols and InfraSceneHighlight read from it. A bare carrier does not remember its construction, so only three colors are reachable from a shape; the Euclidean objects InfraSegment, InfraRay, InfraLine, InfraCircle and InfraArc remember theirs and reach four more.";

InfraSceneHighlight::usage = "InfraSceneHighlight[graph, objects] renders shapes -- vertices, vertex lists, densities, walk graphs and lists of them -- and the Euclidean objects InfraSegment, InfraRay, InfraLine, InfraCircle, InfraArc diffusely on graph, intensity scaling with multiplicity and colors blending across objects. Options \"OpacityRange\", \"ThicknessRange\", \"PointSizeRange\", \"Arrowheads\" (Automatic = off; True = Arrowheads[Medium]; or an explicit head spec -- one head at the end of each path object, sized from the plot rather than the stroke). A single object takes a head of its own with obj -> True, obj -> Arrowheads[...] or Style[obj, ...], and obj -> False turns one off, overriding the option for that object.";
InfraSceneViewer::usage = "InfraSceneViewer[scene, graph] is an interactive step-by-step visualisation of an InfraScene on a graph.";
PointViewer::usage = "PointViewer[graph] is an interactive viewer for selecting points; PointViewer[graph, sym] stores the selection in sym.";
SegmentViewer::usage = "SegmentViewer[graph] is an interactive viewer for exploring geodesic segments.";
ShellViewer::usage = "ShellViewer[graph] is an interactive viewer for exploring metric shells.";
CircleViewer::usage = "CircleViewer[graph] is an interactive viewer for exploring separating cycles.";

(* ===================== InfraEquality ===================== *)

InfraEqualQ::usage = "InfraEqualQ[graph, a, b] tests equality of two Infra* objects through their diffusion diagrams. Option Method (\"Diffuse\", \"Overlap\", \"Set\", \"Multiset\").";

$InfraPointSizes::usage = "$InfraPointSizes is the association Small -> 4, Medium -> 7, Large -> 10 of absolute vertex-dot sizes. One value per class, independent of the graph.";
$InfraAccentPointSize::usage = "$InfraAccentPointSize is the absolute dot size (12) of the accent / centre role, which is not a size class and combines with Haloing[].";


(* ===================== The measurement layer (PacletSplit T2c) ===================== *)

(* ===================== VolumeGrowth ===================== *)

BallHull::usage = "BallHull[g, S] gives the ball hull of vertex subset S in g: the intersection of all closed metric balls containing S, equivalently { v : d(c, v) <= max_{s in S} d(c, s) for every vertex c }. This is the smallest ball-convex (Mazur) superset of S. S may be a vertex list or a subgraph.";

BallVolumes::usage = "BallVolumes[g, v] gives the ball volume profile {V(0), ..., V(ecc(v))}, V(r) = |B_r(v)|; slot 2 a vertex, a list or All, slot 3 a radius, a window {rmin, rmax} or All. Option \"Measure\" (\"FullCount\", \"WithoutBoundary\", \"HalfBoundary\", \"ExpandingFront\").";

ShellAreas::usage = "ShellAreas[g, v] gives the shell profile {A(0), ..., A(ecc(v))}, A(r) = V(r) - V(r-1) with V(-1) = 0, the radial derivative of BallVolumes under the same measure: A(1) is the coordination number and Accumulate recovers BallVolumes. Slots and option \"Measure\" as for BallVolumes; a window pads with 0 past eccentricity.";

CylinderVolumes::usage = "CylinderVolumes[g, sources, targets, s] gives the matrix of cylinder volumes between every source-target pair; the cylinder from p to q is the metric interval I(p, q) = { w : d(p, w) + d(w, q) == d(p, q) } (all p-q geodesics) thickened to its closed s-neighborhood (s defaults to 0), and its volume is the vertex count. A scalar source gives a flat list ordered as targets.";

TubeVolumes::usage = "TubeVolumes[g, core] gives the tube profile {T(0), ..., T(sMax)} of a vertex list, T(s) = |{w : d(w, core) <= s}|; TubeVolumes[g, p, q] takes the metric interval I(p, q) as core and TubeVolumes[g, p, targets] gives one profile per target. Radius slot and option \"Measure\" as in BallVolumes.";

IntervalVolumes::usage = "IntervalVolumes[g, p, q] gives the profile {I(0), ..., I(rMax)} of the interval at slack r, I(r) = |{x : d(p, x) + d(x, q) <= d(p, q) + r}|; IntervalVolumes[g, p, targets] gives one profile per target. Slack slot as the radius slot of BallVolumes; option \"Measure\" (\"FullCount\", \"WithoutBoundary\", \"HalfBoundary\").";

GeodesicIntervalGraph::usage = "GeodesicIntervalGraph[g, u, v] gives the metric interval I(u, v) = { w : d(u, w) + d(w, v) == d(u, v) } (all u-v geodesics) as a directed acyclic graph, edges w -> x oriented along increasing distance from u so directed u -> v paths are exactly the geodesics; built from distance fields without enumerating paths.";

GeodesicOccupation::usage = "GeodesicOccupation[dag] gives the association w -> c(w) of per-vertex geodesic occupation over a geodesic DAG, c(w) = (number of source -> w paths) * (number of w -> sink paths) by topological-order DP, with family size Max[c]; GeodesicOccupation[g, u, v] builds the u-v geodesic DAG first.";

GeodesicEdgeOccupation::usage = "GeodesicEdgeOccupation[dag] gives the association DirectedEdge[u, v] -> c(u -> v) of per-edge geodesic occupation over a geodesic DAG, c(u -> v) = (number of source -> u paths) * (number of v -> sink paths) by topological-order DP; GeodesicEdgeOccupation[g, u, v] builds the u-v geodesic DAG first.";

LogDifferenceQuotients::usage = "LogDifferenceQuotients[w] gives the log-difference quotients q(r) = (Log w(r) - Log w(r-1)) / (Log(r+1) - Log r) of a sequence w = {w(0), w(1), ...}, the discrete d Log w / d Log r; equals ResourceFunction[\"LogDifferences\"][w]. Accepts any numeric or Around sequence: feed BallVolumes[g, v] for the volume-growth dimension estimator, or LogDifferenceQuotients[MeanAround /@ Transpose[BallVolumes[g, subset, {0, R}]]] to average a vertex subset first and carry the spread into Around error bars.";

VolumeGrowthObservables::usage = "VolumeGrowthObservables[g, v, window] fits dimension and scalar curvature to the ball and sphere growth at v by DimensionCurvatureFit and returns profiles, quotients, fits and windows as one Association; window {rmin, rmax}, All or Automatic. Options \"Measure\", \"Dimension\".";

DimensionCurvatureFit::usage = "DimensionCurvatureFit[{{r, q(r)}, ...}] fits <|\"Dimension\", \"ScalarCurvature\"|> to log-difference quotients by Bishop-Gromov regression on r (r + 1); a bare list {q(0), q(1), ...} sits at radii 0, 1, .... Options \"Probe\" (\"Ball\", \"Sphere\", \"Tube\", \"TubeMantle\"), \"Dimension\".";

(* ===================== TessellationGraphs ===================== *)

TorusTessellation::usage ="TorusTessellation[{m, n}, shape] is the vertex-transitive flat-torus graph carrying the regular tessellation indicated by shape, one of \"Square\" ({4,4}), \"Triangular\" ({3,6}, the default) or \"Hexagonal\" ({6,3}).";

TessellationGraph::usage = "TessellationGraph[{p, q}] is the smallest regular map of type {p, q} as a graph -- the Platonic solid when (p-2)(q-2) < 4, the smallest hyperbolic quotient when > 4. TessellationGraph[config] is the uniform (Archimedean) map of vertex configuration config (the cyclic face sizes around a vertex, e.g. {3, 6, 3, 6}). TessellationGraph[spec, n] sizes the result (n x n flat torus in the Euclidean case, n-th PSL(2,ell) quotient in the hyperbolic case); TessellationGraph[{p, q}, {m, n}] gives the m x n flat torus; TessellationGraph[{p, q}, G] / [{p, q}, {r, s}] carries the coset graph of a finite group G or an explicit (2,p,q)-generation. Option Method (Automatic (default; fast realiser per curvature), \"Platonic\", \"Torus\", \"PSL2\", or \"CosetEnumeration\" / {\"CosetEnumeration\", \"MaxIndex\" -> n} for the general low-index method).";

TessellationCurvature::usage = "TessellationCurvature[{p, q}] (or TessellationCurvature[config]) is the combinatorial Gaussian curvature Sum 1/f_i - (k-2)/2 at a vertex of the {p, q} regular map or the uniform map of vertex configuration config; its sign is spherical (> 0), flat (== 0), or hyperbolic (< 0) and the geometric angle defect is 2 Pi times it. TessellationCurvature[graph] detects a regular configuration (uniform degree, girth face size) from the graph.";

TessellationEulerCharacteristic::usage = "TessellationEulerCharacteristic[graph, spec] is the Euler characteristic V - E + F of the realised tessellation graph, where spec is its {p, q} symbol or vertex configuration. TessellationEulerCharacteristic[graph] assumes a regular map and detects spec from the graph (pass spec explicitly for Archimedean / mixed-face maps).";

TessellationGenus::usage = "TessellationGenus[graph, spec] is the orientable genus (2 - chi)/2 of the realised tessellation graph, where spec is its {p, q} symbol or vertex configuration. TessellationGenus[graph] assumes a regular map and detects spec from the graph (pass spec explicitly for Archimedean / mixed-face maps).";

TessellationNeighborhoodGraph::usage = "TessellationNeighborhoodGraph[{p, q}, r] is the radius-r graph-distance ball cut from the infinite regular {p, q} tessellation of its covering surface (Euclidean plane, hyperbolic plane, or closing-up sphere by the curvature (p-2)(q-2)) -- the non-compact companion to TessellationGraph, with VertexCoordinates carrying the embedding. TessellationNeighborhoodGraph[config, r] cuts the same ball from the uniform / Archimedean tiling of a longer vertex configuration (the chiral snub / elongated families are deferred). TessellationNeighborhoodGraph[{p, q}, {m, n}] is the m x n rectangular Euclidean patch.";

CosetEnumeration::usage = "CosetEnumeration[p, q, subwords, maxc] is the Todd-Coxeter index [D(p,q,2) : H] of the subgroup H generated by subwords (lists over 1 = x, 2 = x^-1, 3 = y, 4 = y^-1) of the von Dyck group <x, y | x^p = y^q = (x y)^2 = 1>, or $Failed if it exceeds maxc; on the cyclic stabilizers <y>, <x y>, <x> it gives the vertex, edge, face counts.";

LowIndexMaps::usage = "LowIndexMaps[p, q, maxIndex] enumerates every genuine {p, q} map of index <= maxIndex up to isomorphism, by low-index subgroup enumeration of the von Dyck group, as associations with \"Index\", \"Generators\", \"Skeleton\", \"Regular\" (normal-subgroup test), and \"Genus\".";

RotationMapGraph::usage = "RotationMapGraph[{x, y}] is the 1-skeleton of the orientable map of the rotation pair {x, y}: vertices are the cycles of y, edges the 2-cycles of x y joining them.";

(* ===================== Displacements ===================== *)

DisplacementCompose::usage = "DisplacementCompose[d1, d2, ...] composes displacements as flows, the leftmost acting first; targets are collected over every intermediate point.";

DisplacementScale::usage = "DisplacementScale[g, d, t] scales displacement d by t: endpoints of the geodesics v -> d(v) rescaled to t times their length (t < 0 reflects through the base point).";

DisplacementNegative::usage = "DisplacementNegative[g, d] is the metric negative of d: each step is reflected through its base point, the scale -1 case of DisplacementScale.";

DisplacementInverse::usage = "DisplacementInverse[d] reverses the relation d: its value at v is the set of vertices whose d-value contains v. It is the ordinary inverse when d is bijective and may have empty fibers otherwise.";

DisplacementSum::usage = "DisplacementSum[g, d1, d2] is the bisector of the two composition orders of d1 and d2 -- by Baker-Campbell-Hausdorff the sum of the generators, with the commutator term cancelled.";

DisplacementCommutator::usage = "DisplacementCommutator[g, d1, d2] applies the commutator loop selected by Method. Method -> \"Inverse\" (default) is the exact group commutator of bijective displacements; Method -> \"Negative\" composes d1, d2 and their metric negatives. DisplacementCommutator[g, d1, d2, v] evaluates it at v.";

DisplacementBracket::usage = "DisplacementBracket[g, d1, d2] is DisplacementCommutator[g, d1, d2, Method -> \"Negative\"], the scale-dependent metric bracket candidate. DisplacementBracket[g, d1, d2, v] evaluates it at v.";

DisplacementMagnitude::usage = "DisplacementMagnitude[g, d] is the maximal step length of displacement d -- its scale.";

DisplacementReduce::usage = "DisplacementReduce[g, d] contracts each value set of d to its metric centre (minimal eccentricity within the set), iterated to a fixed point; genuine ties survive.";

DisplacementSingleValuedQ::usage = "DisplacementSingleValuedQ[d] tests whether every value of displacement d is a single vertex.";

DisplacementBijectionQ::usage = "DisplacementBijectionQ[d] tests whether displacement d is a single-valued permutation of the vertex set.";

DisplacementIsomorphismQ::usage = "DisplacementIsomorphismQ[g, d] tests whether displacement d is a graph automorphism of g -- a discrete Killing displacement.";

ContinuousDisplacementQ::usage = "ContinuousDisplacementQ[g, d, k] tests k-continuity of displacement d (default k = 1). Method -> \"Weak\" requires one close target pair across each edge; \"Hausdorff\" requires every target to have a close partner; \"Strong\" requires every cross-pair to be close.";

RandomDisplacement::usage = "RandomDisplacement[g, r] generates a random continuous displacement of magnitude at most r (default 1): a random continuous section of the scale-r tangent bundle.";

FindKillingDisplacement::usage = "FindKillingDisplacement[g] finds the nontrivial graph automorphism of least displacement magnitude, as a displacement. FindKillingDisplacement[g, All] returns all minimal ones.";

KillingDisplacementMagnitude::usage = "KillingDisplacementMagnitude[g] is the least magnitude of a nonidentity graph automorphism, or Infinity when g is asymmetric.";

PolarDisplacements::usage = "PolarDisplacements[g, c] gives the polar pair {radial, angular} at centre c: radial steps along geodesics from c (outward, or inward with \"Direction\" -> \"Inward\"), angular steps along edges of equal distance.";

GradientDisplacement::usage = "GradientDisplacement[g, f] is the steepest-ascent displacement of the vertex function f (an association): each vertex moves to the neighbours maximising the increase of f; local maxima stay put.";

TranslationDisplacement::usage = "TranslationDisplacement[g, v] translates along the graph embedding: each vertex moves to the vertices whose coordinates are nearest to its own position plus the vector v.";

DisplacementPlot::usage = "DisplacementPlot[g, d] draws displacement d as bent arcs over the graph's own embedding. DisplacementPlot[g, {d1, d2, ...}] draws a sequence, the k-th in the k-th Standard colour.";

(* ===================== Boundary ===================== *)

GraphBoundary::usage = "GraphBoundary[g, S] gives the inner vertex boundary of S in g (vertices where a g-edge escapes S). If S is a vertex list it is treated as the induced subgraph, so the boundary is the vertices of S adjacent to some vertex outside S; if S is a subgraph h, the boundary is the vertices of h having a g-neighbor they are not joined to in h (so a path/curve, lacking its induced chords, is all boundary).";

GraphInterior::usage = "GraphInterior[g, S] gives the interior of S in g (= S minus GraphBoundary[g, S]): the vertices all of whose g-edges stay inside the object. S may be a vertex list (induced-subgraph notion) or a subgraph h (its own edges, so a 1-D curve has empty interior).";

GraphExteriorBoundary::usage = "GraphExteriorBoundary[g] gives the exterior-boundary (rim) vertices of the whole graph, detected from vertex degrees; GraphExteriorBoundary[mr] gives the exact surface vertices of the MeshRegion (the vertices on a facet belonging to exactly one top cell). Option Method (\"AverageDegree\" (default, for meshes: the vertices of below-average degree) | \"MaxDegree\" (for lattices: the vertices of less than full degree)); a MeshRegion needs no method. Complements GraphBoundary, the inner boundary of a subset.";

BoundarylessGraph::usage = "BoundarylessGraph[g] deletes every edge joining two exterior-boundary vertices (GraphExteriorBoundary[g]) and then the vertices this isolates, preserving the original vertex coordinates and their dimension: the rim contour disappears while boundary vertices with an inward edge survive as whiskers, so the result models an open window onto the geometry. BoundarylessGraph[mr] does the same on the 1-skeleton of the MeshRegion, with the exact surface as the boundary. Options: Method (passed to GraphExteriorBoundary; Graph form only), \"KeepCoordinates\" (True (default) carries the coordinates over, False drops them).";

GraphEccentricities::usage = "GraphEccentricities[g] gives the eccentricity max_w d(v, w) of every vertex, in VertexList order -- the list form of VertexEccentricity. Also takes a distance matrix. Values run from GraphRadius[g] to GraphDiameter[g].";

CenterGraph::usage = "CenterGraph[g, q] gives the induced subgraph on { v : d(v, GraphCenter[g]) <= Floor[q GraphRadius[g]] }, the substrate cut to a fraction q of the way out from its centre; q = 0 is the centre, q = 1 (the default) the whole graph, and q is clipped to [0, 1]. Vertex labels and coordinates are g's, so a construction made on the ball draws on g. For a cut in hops use NeighborhoodGraph[g, GraphCenter[g], k]. Returns g unchanged when the graph is vertex-transitive or disconnected.";

RelativeEccentricity::usage = "RelativeEccentricity[g] gives (e(v) - radius)/(diameter - radius) for each vertex in VertexList order -- 0 on GraphCenter, 1 on GraphPeriphery. Also takes a distance matrix. Identically 0 when diameter == radius or the graph is disconnected.";

(* ===================== BallTopology ===================== *)

BallTopology::usage = "BallTopology[g, r] returns the Hasse diagram of the r-ball specialization preorder on V(g): directed edge q -> p iff the closed r-ball at p is contained in the one at q, transitive edges removed. This digraph is the topology object consumed by the Topological* operators. Option \"Dual\" (False default; True gives the ReverseGraph).";

TopologicalClosure::usage = "TopologicalClosure[topo, verts] gives the closure of vertex list verts in the specialization-preorder digraph topo: the union of the in-components (down-sets) of the vertices.";

TopologicalInterior::usage = "TopologicalInterior[topo, verts] gives the interior int(S) = V \\ cl(V\\S) of vertex list verts in the digraph topo, with carrier V = VertexList[topo].";

TopologicalBoundary::usage = "TopologicalBoundary[topo, verts] gives the (two-sided) boundary cl(S) \\ int(S) of vertex list verts in the digraph topo.";

TopologicalNeighborhood::usage = "TopologicalNeighborhood[topo, verts] gives the unique minimal open neighborhood of vertex list verts in the digraph topo: the union of the out-components (up-sets) of the vertices.";

ContinuousMapQ::usage = "ContinuousMapQ[f, topo1, topo2] tests whether the vertex map f is continuous from preorder digraph topo1 to topo2, i.e. every Hasse edge q -> p of topo1 maps to a pair reachable in the transitive closure of topo2. f: Association, list of Rule, or callable.";

TopologyGraph::usage = "TopologyGraph[g, topo] draws the graph g overlaid with the Hasse arrows of the specialization-preorder digraph topo.";

(* ===================== ExampleGraphs ===================== *)

SierpinskiGraph::usage = "SierpinskiGraph[n] is the trivalent Sierpinski graph: the 3-simplex K_4 with corner-cutting (truncation) iterated n-1 times. 3-regular at every generation, 4*3^(n-1) vertices; n=2 is the truncated tetrahedron. Graph options are forwarded.";

BetheGraph::usage = "BetheGraph[n, z] is the finite Bethe lattice / Cayley tree of n shells and coordination number z (argument order matching CompleteKaryTree[n, k]): the root branches z ways and every other internal node z-1, so all interior vertices are z-valent. Distinct from the rooted, irregular CompleteKaryTree. Undirected by default; DirectedEdges -> True orients edges away from the root.";

BranchingSequenceTree::usage = "BranchingSequenceTree[b] is the spherically symmetric rooted tree whose offspring count depends only on depth: a vertex at depth l has b[[l+1]] children. Length[b]+1 levels, FoldList[Times, 1, b] vertices per shell. Constant b gives CompleteKaryTree. Graph options are forwarded.";

InflateGraph::usage = "InflateGraph[g] grows a fiber of extra vertices over every vertex of g, joins each to its base vertex, and adds random edges between fibers whose base vertices lie within \"Radius\" in g. The base is recoverable as the induced subgraph on VertexList[g]. Options \"ExtraVertices\", \"ExtraEdges\", \"Radius\" and \"Density\", each a constant or a {min, max} range sampled per base vertex.";

InflatedVertex::usage = "InflatedVertex[v, i] is the i-th fiber vertex over base vertex v in a graph produced by InflateGraph.";

(* ===================== InfraSubstrate ===================== *)

InfraSubstrateStyle::usage = "InfraSubstrateStyle[size] is the Graph option list a substrate backdrop is drawn with at size \"Small\" | \"Medium\" | \"Large\" -- StandardGray edges on an opacity ladder and faintly filled outlined vertex disks at a scaled 0.013 | 0.009 | 0.006 of the coordinate diagonal, fading as the substrate grows, so one style draws one dot on every graph -- and \"Default\" is none. InfraSubstrateStyle[name, size] is the style of the named substrate at that size: every substrate falls back to the size default today, and a custom look for one substrate is one more definition. Splice a style into any graph construction: Graph[g, Sequence @@ InfraSubstrateStyle[\"Medium\"]] -- the way to draw a hand-built object (a Wolfram-model graph in particular) exactly like the roster substrates. InfraSubstrateStyle[] lists the available styles in an Association with \"Default\" and \"Custom\" keys; InfraSubstrateStyle[All] gives the flat list of all default and custom styles.";

InfraSubstrate::usage = "InfraSubstrate[name, size] is the named example substrate at size \"Small\", \"Medium\" or \"Large\", or at a raw spec (a cell measure, a radius, grid dimensions, a generation count); a substrate drawn from a random construction is seeded from outside, with SeedRandom, so the same seed recovers the same graph; a call consumes the random stream like any other draw. Each substrate is one explicit definition in Kernel/InfraSubstrate.wl, with its size table and its exceptions (an interior strip, a kept embedding) written into the definition. A Wolfram-model universe is named by its Registry of Notable Universes number, as in InfraSubstrate[\"wm6655\", 11], and any of the 947 registry entries resolves through ResourceFunction[\"WolframModelData\"]. InfraSubstrate[name, size, style] overrides the ambient style, which defaults to the InfraSubstrateStyle of that size since a substrate is a backdrop; pass \"Default\" for none. A substrate is bare combinatorics by default -- a stored embedding is discarded and a spring layout of its own dimension places the vertices; option \"KeepCoordinates\" -> True draws the substrate where it lives instead. Any substrate inflates: option \"Inflate\" -> amount grows a fiber of that many extra vertices over every vertex through InflateGraph (a constant or a {min, max} range), and \"Inflate\" -> {opts} passes InflateGraph its full option list. InfraSubstrate[] lists the roster classified by what a substrate models (\"OpenManifold\" -- boundaryless patches, open subsets delivered with the rim contour removed; \"ClosedManifold\" -- compact tessellated surfaces; \"Fractal\" -- self-similar, Hausdorff dimension between the integers; \"Exotic\" -- graphs with no manifold model and no scaling law; \"WolframModel\"); InfraSubstrate[All] is the flat name list; InfraSubstrate[name] is the \"Medium\" size. Graph options are forwarded.";

InfraSubstrateCode::usage = "InfraSubstrateCode[name, size] is the code behind InfraSubstrate[name, size]: the held construction, without the backdrop style, wrapped in a Graph call only when a layout clause or a forwarded option has to attach to it, whose ReleaseHold evaluates to the graph InfraSubstrate draws at the same seed with the \"Default\" style (building the code realizes the graph once, so set the seed after the build). It is HoldForm, so an output cell shows it as typeset code. The roster definition is itself held code -- InfraSubstrate evaluates it, InfraSubstrateCode prints it -- so the printed code cannot drift from the code that runs, and it names no symbol the reader cannot see. Baked in: the size table collapsed to the value the size selects, the rule and initial condition of a Wolfram-model universe, the layout dimension and the inflation call; the style is presentation and is spliced back with Sequence @@ InfraSubstrateStyle[size]. Takes the options of InfraSubstrate, and Graph options are forwarded.";

(* ===================== UniformLengthDiscretization ===================== *)

UniformLengthGraph::usage = "UniformLengthGraph[region, n] returns the contact graph of an n-sphere hard-sphere packing relaxed in region (filling a solid, meshing a surface); every edge has length 2r. Option Method (\"IterativeProjection\" (default), \"ConstrainedPacking\"); \"Radius\" (Automatic spaces the spheres to tile the region's content); \"KeepCoordinates\" (False (default) drops the packing coordinates, True stores them as VertexCoordinates).";

UniformLengthEmbedding::usage = "UniformLengthEmbedding[graph] embeds graph in R^d (option \"Dimension\") so every edge is a unit segment, returning coordinates in VertexList order (cf. GraphEmbedding); the iterative counterpart of ComplexEmbedding.";

(* ===================== Coordinatization ===================== *)

RadarCoordinates::usage = "RadarCoordinates[g, basis, v] gives the distance vector (d(v, b))_{b in basis} of vertex v; RadarCoordinates[g, basis] gives the association of all vertices' radar coordinates.";

ResolvingSetQ::usage = "ResolvingSetQ[g, basis] tests whether basis is a resolving set: the radar map v |-> (d(v, b))_{b in basis} is injective over the vertices.";

FindResolvingSet::usage = "FindResolvingSet[g, n, m] returns up to n resolving sets (metric bases) of g by ascending size; m restricts the sizes (All, an integer max, {min, max}, or {exact}).";

MetricDimension::usage = "MetricDimension[g] gives the metric dimension of g: the size of a smallest resolving set.";

ResistanceCoordinates::usage = "ResistanceCoordinates[g] gives the association vertex -> spectral embedding Phi with ||Phi(u)-Phi(v)||^2 == EffectiveResistance[g,u,v]; options \"Rescaling\" (\"ResistanceMatching\" | \"None\" | \"Diffusion\"->t), \"Dimension\", \"Origin\". ResistanceCoordinates[g, v] gives the coordinates of v.";

FindBallCover::usage = "FindBallCover[g, r] returns a minimum r-ball cover of g: a smallest set of centres whose radius-r balls cover every vertex (a minimum r-dominating set). FindBallCover[g, r, targets] covers only the given vertex subset (centres still chosen from all of g). FindBallCover[g, r, targets, count] returns up to count distinct minimum covers for an integer count or UpTo[count], or every one for All; count defaults to 1 (a single cover). Option Method (\"Exhaustive\" (default) exact integer program, \"Greedy\" repeatedly takes the centre covering the most uncovered targets -- fast but not minimum in general, even on vertex-transitive graphs, \"Symmetric\" smallest union of Aut(g) orbits that covers -- exact when a minimum cover is orbit-shaped, an upper bound otherwise).";

BallCoverQ::usage = "BallCoverQ[g, r, S] tests whether the radius-r balls around the centres S cover every vertex of g. BallCoverQ[g, r, S, targets] tests coverage of the given vertex subset.";

DominationNumber::usage = "DominationNumber[g, r] gives the r-domination number of g: the size of a minimum r-ball cover. DominationNumber[g, r, targets] gives the size of a minimum r-ball cover of the given vertex subset.";

(* ===================== OllivierCurvature ===================== *)

OllivierRicciCurvature::usage = "OllivierRicciCurvature[g] returns Association[edge -> kappa] with the Ollivier-Ricci curvature kappa(u, v) = 1 - W_1(mu_u, mu_v) / d(u, v), where mu_x is uniform on N(x) and W_1 is the Wasserstein-1 distance under graph distance (alpha = 0).";

EffectiveResistance::usage = "EffectiveResistance[g, u, v] returns the Klein-Randic resistance distance R(u, v) = (e_u - e_v)^T L^+ (e_u - e_v) for the graph Laplacian pseudoinverse L^+. EffectiveResistance[g] returns the full V x V matrix; EffectiveResistance[g, vs] the submatrix on a vertex list.";

ResistanceQ::usage = "ResistanceQ[r] tests whether a real symmetric n x n matrix r with zero diagonal is realisable as a resistance distance matrix (Klein-Randic / Schoenberg negative-type criterion: the centred Gram matrix is positive semidefinite).";

(* ---- BallIntersectionComplex.wl and DifferentialForms.wl, arrived 2026-09-22 ---- *)

MiniballRadius::usage = "MiniballRadius[pts] returns the radius of the smallest enclosing ball of the points (BoundingRegion[pts, 'MinBall']).";

BallIntersectionComplex::usage = "BallIntersectionComplex[data, r, k] returns the order-k ball-intersection complex of closed radius-r balls: a simplex is admitted iff every k-subset of its balls has a common point. k = 2 is Vietoris-Rips (equal to VietorisRipsComplex[data, 2 r]), k = Infinity is Cech (the nerve), 2 < k < Infinity interpolates. Options: 'Metric'->EuclideanDistance|matrix|Graph|fn (Euclidean uses the exact miniball test, other metrics an intrinsic intersection oracle over the sample points), 'IntersectionTest'->fn applied to the common region (default = non-empty), 'MaxDimension'->k.";

CechComplex::usage = "CechComplex[data, r] returns the Cech complex (nerve) of closed radius-r balls = BallIntersectionComplex[data, r, Infinity].";

BallIntersectionFiltrationValue::usage = "BallIntersectionFiltrationValue[data, sigma, k] returns f_k(sigma), the birth radius of sigma in the order-k complex: the max miniball radius over its k-subsets (its own miniball when |sigma| <= k). Monotone under faces.";

BallIntersectionFiltration::usage = "BallIntersectionFiltration[data, radii, k] returns association r -> BallIntersectionComplex[data, r, k] over the sorted radii, ready for PersistenceIntervals.";

CechFiltration::usage = "CechFiltration[data, radii] = BallIntersectionFiltration[data, radii, Infinity].";

BallIntersectionBifiltration::usage = "BallIntersectionBifiltration[data, radii, orders] returns the (r, k) object as association k -> (association r -> complex); for fixed r the nesting C^(k) contains C^(k+1) as k grows, saturating to Cech at k = d + 1 for convex balls (Helly).";

FormValue::usage = "FormValue[w, v, tuple] gives the value of the germ of form w at vertex v on a tuple of neighbours of v, alternating in the tuple.";

CochainValue::usage = "CochainValue[a, tuple] gives the value of the ALTERNATING cochain a on an arbitrary vertex tuple, by the sign of the permutation taking it to increasing order; 0 off the complex. Do not apply it to the output of OrderedCochainCup or CochainCupOne, which are ordered cochains.";

OrderedCochainValue::usage = "OrderedCochainValue[a, tuple] gives the value of the ORDERED cochain a on an increasing vertex tuple, 0 off the complex, and Missing[\"NonIncreasingTuple\", tuple] otherwise. This is the correct accessor for the output of OrderedCochainCup and CochainCupOne.";

FormDegree::usage = "FormDegree[w] gives the degree of form w, read off a stored germ.";

CochainDegree::usage = "CochainDegree[a] gives the degree of cochain a: one less than the number of vertices of a stored cell.";

ZeroForm::usage = "ZeroForm[g, f] is the vertex function f (an association or a function) as a 0-form on g.";

RestrictionMap::usage = "RestrictionMap[g, a] is the form R a obtained from the alternating cochain a by reading it with the base vertex prepended; it vanishes off cliques.";

IntegrationMap::usage = "IntegrationMap[g, w] is the alternating cochain I w obtained by averaging the germs of w over the vertices of each clique with the orientation sign. I is a left inverse of RestrictionMap and a chain map.";

Coboundary::usage = "Coboundary[g, a] is the coboundary of cochain a: the alternating sum over the faces of every clique one dimension up. It agrees on the alternating and the ordered convention.";

FormDifferential::usage = "FormDifferential[g, w] is the differential of form w: the graph gradient on 0-forms, and on 1-forms the difference of germ values corrected by the transport term from the neighbouring germs.";

NaiveDifferential::usage = "NaiveDifferential[g, w] is the differential of the 1-form w with the transport term dropped; integrating it loses the factor (k+1)/(k+2).";

FormWedge::usage = "FormWedge[w, e] is the wedge product of forms, the exterior product on each tangent fiber. It is strictly associative and graded-commutative, but its differential fails Leibniz.";

CochainCup::usage = "CochainCup[g, a, b] is the cup product of ALTERNATING cochains: the full antisymmetrisation of the Alexander-Whitney formula over the (p+q+1)! orderings of each clique. It needs no vertex order, is unital, graded-commutative and a derivation for the coboundary, and is NOT associative; its 1/(p+q+1)! normalisation is the one agreeing with the cup product on cohomology. For the associative Alexander-Whitney formula use OrderedCochainCup.";

OrderedCochainCup::usage = "OrderedCochainCup[g, a, b] is the bare Alexander-Whitney cup product of ORDERED cochains, a(v0..vp) b(vp..v_{p+q}) on each increasing clique. Associative and unital but not graded-commutative, and well defined only in the ordered convention: the Alexander-Whitney cup of two alternating cochains is not alternating, so read the result with OrderedCochainValue. It is what the Steenrod tower and the A-infinity comparison need.";

CochainCupOne::usage = "CochainCupOne[g, a, b] is the Steenrod cup-1 product of ORDERED cochains. For closed a and b it is a primitive for the graded commutator: Coboundary[g, CochainCupOne[g, a, b]] equals OrderedCochainCup[g, a, b] - (-1)^(p q) OrderedCochainCup[g, b, a]. It vanishes when a has degree 0.";

AntisymmetrizedCup::usage = "AntisymmetrizedCup[g, a, b] is an alias of CochainCup, the name the antisymmetrised product carried before it became the cup product.";
