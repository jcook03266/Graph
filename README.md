<div align="center">
 
# Graphing Procedural Networks in Swift
 
[![Swift Version badge](https://img.shields.io/badge/Swift-5.7.1-orange.svg)](https://shields.io/)
[![Platforms description badge](https://img.shields.io/badge/Platform-iOS-blue.svg)](https://shields.io/)
[![GitHub version](https://badge.fury.io/gh/jcook03266%2FGraph.svg)](https://badge.fury.io/gh/jcook03266%2FGraph)
 
</div>

<div align="center">

<img src="https://github.com/jcook03266/Graph/blob/main/Resources/hero_1.png" width = "400">
<img src="https://github.com/jcook03266/Graph/blob/main/Resources/hero_2.png" width = "400">
 
</div>

<div align="left">
 
## Intro:
This is just me experimenting with graphing procedurally generated weighted and unweighted networks in 3D/2D using SceneKit and SwiftUI. I'll be adding more and more functionality and graphics as I dig deeper into the framework.

## Demo:
<video src="https://github.com/jcook03266/Graph/blob/main/Resources/screen-recording.png" width = "400">

### Current Functionality:
- Procedurally generate weighted / unweighted graphs in some arbitrary coordinate space. The default coordinate space is normalized to device space coordinates 0 -> 1.
- Print out a debug log of all edges and vertices, as well as their connections via an adjacency list.
- Control the zoom of the camera with discrete buttons
- Customizable 3D and 2D connectors that can be toggled between in real-time via the settings menu.

### In-Progress:
- Refining camera controls; might have to make my own camera controller to get around SceneKit's safety bars
- Adding more discrete controls to simplify movement around the scene

</div>
