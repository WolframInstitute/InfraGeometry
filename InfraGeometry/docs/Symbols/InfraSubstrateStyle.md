---
Template: Symbol
Name: InfraSubstrateStyle
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSubstrateStyle
Keywords: [substrate, backdrop, style, vertex size, opacity, drawing]
SeeAlso: [InfraSubstrate, InfraSubstrateCode, InfraSubstrateHighlight]
RelatedGuides: [InfraSubstrates]
---

## Usage

<code>[InfraSubstrateStyle]()[*size*]</code> gives the list of [Graph]() options a substrate of size `"Small"`, `"Medium"` or `"Large"` is drawn with; `"Default"` gives none.

<code>[InfraSubstrateStyle]()[*name*, *size*]</code> gives the style of the named substrate at *size*.

<code>[InfraSubstrateStyle]()[]</code> lists the default and the custom styles; <code>[InfraSubstrateStyle]()[All]</code> gives them as one list.

## Details & Options

A substrate is a backdrop, and the construction drawn on it carries the colour. The style draws it in gray: [StandardGray]() edges and faintly filled vertex disks with a dark outline, lighter as the substrate grows.

| *size* | Edge opacity | Vertex opacity | Vertex size |
|---|---|---|---|
| `"Small"` | 0.35 | 0.5 | 0.013 |
| `"Medium"` | 0.3 | 0.45 | 0.009 |
| `"Large"` | 0.22 | 0.33 | 0.006 |

The vertex size is a fraction of the diagonal of the drawing, so a vertex stays one small dot however many vertices there are.

Every named substrate takes the style of its size. A substrate at a raw size takes the style of its vertex count: up to 250 `"Small"`, up to 800 `"Medium"`, more `"Large"`.

A custom look for one substrate is one more definition <code>[InfraSubstrateStyle]()[*name*, *size*] = …</code>, listed under `"Custom"`. Any graph is drawn like a substrate by <code>[Graph]()[*g*, [Sequence]() @@ [InfraSubstrateStyle]()[*size*]]</code>.

## Basic Examples

The square mesh with no style and in the three styles:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "Default", "KeepCoordinates" -> True]},
  GraphicsRow @ Table[Graph[g, Sequence @@ InfraSubstrateStyle[style], PlotLabel -> style],
    {style, {"Default", "Small", "Medium", "Large"}}]]
```

The small style:

```wl
InfraSubstrateStyle["Small"]
```

## Scope

The listing: four default styles and no custom one:

```wl
InfraSubstrateStyle[]
```

A graph of one's own drawn like a substrate, a ball of the hyperbolic tiling by squares:

```wl
Graph[TessellationNeighborhoodGraph[{4, 5}, 4], Sequence @@ InfraSubstrateStyle["Small"], ImageSize -> Medium]
```

## Properties and Relations

[InfraSubstrate]() splices the style of the size into the substrate drawn with no style:

```wl
InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True] ===
  Graph[InfraSubstrate["SquareGridGraph", "Small", "Default", "KeepCoordinates" -> True], Sequence @@ InfraSubstrateStyle["Small"]]
```

At a raw size the vertex count picks the style. Grids of 10 × 10, 20 × 20 and 35 × 35, with 96, 396 and 1221 vertices, take the vertex sizes of the small, medium and large style:

```wl
Table[Options[InfraSubstrate["SquareGridGraph", dims], VertexSize], {dims, {{10, 10}, {20, 20}, {35, 35}}}]
```
