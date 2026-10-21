---
Template: Symbol
Name: InfraPlaneQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraPlaneQ
Keywords: [plane, hyperplane, bisector, separator, test]
SeeAlso: [InfraPlane, RandomInfraPlane, FindInfraBisectingHyperplane, InfraPerpendicularBisector, InfraScene]
---

## Usage

<code>[InfraPlaneQ]()[*g*, *h*, *p*, *q*]</code> gives `True` if the vertex set *h* is equidistant from *p* and *q* and separates them in *g*.

<code>[InfraPlaneQ]()[*g*, *h*, *p*, *q*, *w*]</code> allows *|d(p, v) − d(q, v)| ≤ w* on *h*; <code>[InfraPlaneQ]()[*g*, *h*, *p*, *q*, {*lo*, *hi*}]</code> allows *lo ≤ d(p, v) − d(q, v) ≤ hi*.

## Details & Options

*h* passes when *d(p, v) = d(q, v)* for every *v* in *h*, *p* and *q* are not in *h*, and every path from *p* to *q* meets *h*.

Minimality is not tested: the members of <code>[InfraPlane]()[*p*, *q*]</code> pass, and so does every larger equidistant set, such as the whole bisector when it separates.

*h* is a vertex list, a density `<|v -> m, …|>` read as its support, or a list of vertex lists, which passes when each one does.

In an [InfraScene](), `InfraPlaneQ[h, p, q]` is the assertion that *h* is a plane of *p* and *q*.

## Basic Examples

A plane of 45 and 47 passes; with one vertex removed it no longer separates:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {plane = RandomInfraPlane[g, InfraPlane[45, 47], RandomSeeding -> 1]},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {h, 45, 47}, PlotLabel -> InfraPlaneQ[g, h, 45, 47]], {h, {plane, Rest @ plane}}]]
```

The whole bisector passes too:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  InfraPlaneQ[g, FindInfraBisectingHyperplane[g, 45, 47], 45, 47]]
```

## Scope

At odd distance on the grid a plane lies in the window {−1, 1}, and passes only with *w* = 1:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {plane = RandomInfraPlane[g, InfraPlane[45, 48, {-1, 1}], RandomSeeding -> 1]},
  {InfraPlaneQ[g, plane, 45, 48], InfraPlaneQ[g, plane, 45, 48, 1]}]
```

As an assertion in a scene. The bisector of 45 and 47 is a plane; the shell of radius 1 about 45 separates the points but is not equidistant from them, and the scene has no instance:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  Table[
    Length @ RandomInfraSceneInstance[
      InfraScene[{pA, pB, h}, {pA == InfraPoint[45], pB == InfraPoint[47], h == token, InfraPlaneQ[h, pA, pB]}],
      g, All],
    {token, {InfraPerpendicularBisector[pA, pB], InfraShell[pA, 1]}}]]
```
