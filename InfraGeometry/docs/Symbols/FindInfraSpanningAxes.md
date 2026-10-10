---
Template: Symbol
Name: FindInfraSpanningAxes
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraSpanningAxes
---

## Usage

`FindInfraSpanningAxes[graph, n]` returns n mutually well-separated longest shortest paths across graph (greedy, no fixed center) or $Failed; UpTo[n] returns up to n; All returns every axis above the separation threshold.

## Details & Options

For perpendicular axes through a fixed center vertex use [FindInfraOrthogonalAxes](), and [FindInfraOrthogonalRays]() for the rays.

Options: "AxisDistance" ("MinEndpoint" | "Hausdorff" | "Separation"), "MinLength", "MinSeparation", "AxisThickness", "RandomPick".
