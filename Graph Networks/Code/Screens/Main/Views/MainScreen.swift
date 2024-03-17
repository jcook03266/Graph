//
//  MainScreen.swift
//  Graph Networks
//
//  Created by Justin Cook on 1/31/24.
//

import SwiftUI
import SceneKit

struct MainScreen: View {
    // MARK: - Observed
    @StateObject var cameraController: CameraController = .init()
    @StateObject var vm: MainScreenViewModel = .init()
    
    // MARK: - Properties
    // Graph
    @State var connectorGeometry: Graph3DView.ConnectorGeometry = .dimensions_3
    @State var nodeConnectorThickness: CGFloat = 0.01
    @State var connectorColor: CGColor = UIColor.white.cgColor
    
    // Simulation
    @State var simulationSpeed: CGFloat = 1
    @State var simulationIterations: Int = 0
    
    // View
    @State var isSimulating: Bool = false
    @State var configPanelVisible: Bool = true
    
    var body: some View {
        mainSection
    }
    
    // MARK: - Subviews
    var hideConfigPanelButton: some View {
        Button {
            configPanelVisible.toggle()
        } label: {
            ZStack {
                Circle().foregroundStyle(.black)
                
                Image(systemName: configPanelVisible ? "arrow.down" : "arrow.up")
                    .tint(.white)
            }
            .frame(width: 40, height: 40)
        }
        .fixedSize()
    }
    
    var zoomInButton: some View {
        Button {
            cameraController
                .updateZoom(by: -0.5)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(.black)
                
                Image(systemName: "plus")
                    .tint(.white)
            }
            .frame(width: 40, height: 40)
        }
        .fixedSize()
    }
    
    var zoomOutButton: some View {
        Button {
            cameraController
                .updateZoom(by: 0.5)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(.black)
                
                Image(systemName: "minus")
                    .tint(.white)
            }
            .frame(width: 40, height: 40)
        }
        .fixedSize()
    }
    
    var zoomButtonControl: some View {
            VStack(spacing: 8) {
                Spacer()
                zoomInButton
                zoomOutButton
            }
    }
    
    var configMenuVisibilityControl: some View {
            VStack {
                Spacer()
                hideConfigPanelButton
            }
    }
    
    var connectorGeometryToggle: some View {
        Picker("Connector",
               selection: $connectorGeometry) {
            Text("None").tag(Graph3DView.ConnectorGeometry.none)
            Text("2D").tag(Graph3DView.ConnectorGeometry.dimensions_2)
            Text("3D").tag(Graph3DView.ConnectorGeometry.dimensions_3)
        }
               .pickerStyle(.segmented)
    }
    
    var connectorThicknessSlider: some View {
        Slider(value: $nodeConnectorThickness,
               in: 0.01...0.05)
        .tint(.cyan)
    }
    
    var simulationSpeedSlider: some View {
        Slider(value: $simulationSpeed,
               in: 0.01...2)
        .tint(.red)
    }
    
    var edgeEditor: some View {
        HStack(
            alignment: .center,
            spacing: 12
        ) {
            
            Spacer()
            Button {
                vm.addRandomEdge()
            } label: {
                HStack {
                    Text("Add Edge")
                }
            }
            .buttonStyle(.bordered)
            
            Button {
                vm.removeLastEdge()
            } label: {
                HStack(alignment: .center) {
                    Text("Remove Edge")
                }
            }
            .buttonStyle(.bordered)
            
            Spacer()
        }
        .foregroundStyle(.black)
    }
    
    var animateToggleButton: some View {
        HStack(alignment: .center) {
            Spacer()
            
            Button {
                isSimulating.toggle()
            } label: {
                HStack {
                    Text(isSimulating ?
                         "Stop Simulation"
                         : "Start Simulation"
                    )
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 40)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.black)
            )
            .foregroundStyle(.white)
            
            Spacer()
        }
    }
    
    var vertexViewer: some View {
        VStack {
            Divider()
            
            Text("Vertex Viewer")
                .font(.title3)
                .bold()
            
            Divider()
            
            Group {
                if (vm.graph.edges.count > 0) {
                    LazyVGrid(columns: [.init()]) {
                        ForEach(vm.graph.edges.enumeratedArray(),
                                id: \.offset) { index, edge in
                            HStack {
                                VStack {
                                    Text("V \(index * 2)")
                                    Divider()
                                    Text(edge.v1.coordinates.toString())
                                }
                                
                                Divider()
                                
                                VStack {
                                    Text("V \((index * 2) + 1)")
                                    Divider()
                                    Text(edge.v2.coordinates.toString())
                                }
                            }
                            
                            Divider()
                        }
                    }
                    .transition(.slide)
                }
                else {
                    Text("None")
                }
            }
        }
    }
    
    // MARK: - Sections
    var controlSection: some View {
        HStack {
            configMenuVisibilityControl
            Spacer()
            zoomButtonControl
        }
        .padding([.trailing, .leading, .bottom], 16)
    }
    
    var configPanel: some View {
        VStack {
            Divider()
            ScrollView {
                VStack(
                    alignment: .leading,
                    spacing: 18
                ) {
                    HStack {
                        Text("Configurator")
                            .font(.title2)
                        
                        Spacer()
                        
                        Text("\(vm.totalEdgeCount) Edges")
                        Text("\(vm.totalVertexCount) Vertices")
                    }
                    
                    Divider()
                    
                    // MARK: - Connector Geometry Toggle
                    VStack(
                        alignment: .leading,
                        spacing: 8
                    ) {
                        Text("Connector Geometry")
                        connectorGeometryToggle
                    }
                    
                    Divider()
                    
                    // MARK: - Connector Thickness Slider
                    VStack(
                        alignment: .leading,
                        spacing: 8
                    ) {
                        HStack {
                            Text("Connector Thickness")
                            Text("\(String(format: "%.2f", nodeConnectorThickness * 100))x")
                        }
                        
                        connectorThicknessSlider
                        
                        ColorPicker(selection: $connectorColor, supportsOpacity: true) {
                            Text("Connector Color")
                        }
                    }
                    
                    Divider()
                    
                    // MARK: - Edge Editor
                    edgeEditor
                    
                    Divider()
                    
                    animateToggleButton
                    
                    Group {
                        if (!isSimulating) {
                            HStack {
                                Text("Simulation Speed")
                                Text("\(String(format: "%.2f", (1/simulationSpeed)))x")
                            }
                            
                            simulationSpeedSlider
                        }
                        
                        Text("Simulation Iterations: \(simulationIterations)")
                    }
                    
                    vertexViewer
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
                .background(.white)
                .multilineTextAlignment(.leading)
                .font(.body)
                .bold()
            }
            .refreshable {
                vm.proceduralGraphGenerationFlow()
            }
        }
    }
            
    
    var mainSection: some View {
                VStack {
                    ZStack {
                        Graph3DView(
                            cameraController: cameraController,
                            graph: vm.graph,
                            connectorGeometry: $connectorGeometry,
                            nodeConnectorThickness: $nodeConnectorThickness,
                            connectorColor: $connectorColor,
                            animationDuration: $simulationSpeed
                        )
                        
                        controlSection
                    }
                    
                    Group {
                        if (configPanelVisible) {
                            configPanel
                        }
                    }
                    .transition(.move(edge: .bottom))
            }
        .ignoresSafeArea(.all)
        .animation(.easeInOut, value: configPanelVisible)
        .animation(.easeInOut, value: vm.graph.edges)
        .onChange(of: isSimulating) {
            Timer.scheduledTimer(
                withTimeInterval: simulationSpeed,
                repeats: true
            ) { timerRef in
                if (isSimulating) {
                    vm.simpleMovementSimulation()
                    simulationIterations += 1
                }
                else {
                    timerRef.invalidate()
                }
            }
        }
    }
}

#Preview {
    MainScreen()
}
