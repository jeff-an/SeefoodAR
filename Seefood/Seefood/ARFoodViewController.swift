//
//  ARFoodViewController.swift
//  ARSceneKit
//
//  Created by Alexander Cui on 3/2/18.
//  Copyright © 2018 Hacktech 2018. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARFoodViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var nodeModel:SCNNode!
    var currentNode:SCNNode!
    let nodeName = "ar_food"
    var numModels:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Turn on anti aliasing for smoothing surfaces
        sceneView.antialiasingMode = .multisampling4X
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // Create a scene with a model
        let modelScene = SCNScene(named:"art.scnassets/unagi_nigiri.dae")!
        
        nodeModel = modelScene.rootNode.childNode(withName: nodeName, recursively: true)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        sceneView.addGestureRecognizer(tapGesture)
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeftGesture.direction = .left
        sceneView.addGestureRecognizer(swipeLeftGesture)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        sceneView.addGestureRecognizer(panGesture)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        sceneView.addGestureRecognizer(pinchGesture)
    }
    
    @objc func handlePinch(_ gestureRecognize: UIPinchGestureRecognizer) {
        let scale = Float(gestureRecognize.scale)
        if let node = currentNode {
            node.scale = SCNVector3(node.scale.x * scale, node.scale.y * scale, node.scale.z * scale)
        }
        gestureRecognize.scale = 1
    }
    
    @objc func handleSwipe(_ gestureRecognize: UISwipeGestureRecognizer) {
        if (gestureRecognize.direction == .left) {
            print("left swipe")
        }
        else if (gestureRecognize.direction == .right) {
            print("right swipe")
        }
    }
    
    @objc func tapGesture () {
        print("got tapped")
    }
    
    @objc func handlePan(_ gestureRecognize:UIPanGestureRecognizer) {
        let translation = gestureRecognize.translation(in: self.view)
        let coeff = Float(0.04)
        if let node = currentNode {
            
            print(translation.x, node.eulerAngles.x, node.eulerAngles.y, node.eulerAngles.z)
            node.eulerAngles = SCNVector3Make(node.eulerAngles.x, node.eulerAngles.y + Float(translation.x) * coeff, node.eulerAngles.z)
        }
        gestureRecognize.setTranslation(CGPoint.zero, in: self.view)
    }
    
    // Run when screen is touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Track touch location
        let location = touches.first!.location(in: sceneView)
        var hitTestOptions = [SCNHitTestOption: Any]()
        hitTestOptions[SCNHitTestOption.boundingBoxOnly] = true
        let hitResults: [SCNHitTestResult]  =
            sceneView.hitTest(location, options: hitTestOptions)
        
        // Prevent more than one model being spawned at a time, and from being removed
        if numModels >= 1 {
            return
        }
        
        // If touched a model, remove it
        if let hit = hitResults.first {
            if let node = getParent(hit.node) {
                node.removeFromParentNode()
                numModels -= 1
                print("Removed model")
                return
            }
        }
        
        // Otherwise, add the model to the world, facing you
        let hitResultsFeaturePoints: [ARHitTestResult] =
            sceneView.hitTest(location, types: .featurePoint)
        if let hit = hitResultsFeaturePoints.first {
            // Get a transformation matrix with the euler angle of the camera
            let rotate = simd_float4x4(SCNMatrix4MakeRotation(sceneView.session.currentFrame!.camera.eulerAngles.y, 0, 1, 0))
            
            // Combine both transformation matrices
            let finalTransform = simd_mul(hit.worldTransform, rotate)
            
            // Use the resulting matrix to position the anchor
            sceneView.session.add(anchor: ARAnchor(transform: finalTransform))
            
            numModels += 1
            print("Added model")
        }
    }
    
    // Get parent node (for scenekit models)
    func getParent(_ nodeFound: SCNNode?) -> SCNNode? {
        if let node = nodeFound {
            if node.name == nodeName {
                return node
            } else if let parent = node.parent {
                return getParent(parent)
            }
        }
        return nil
    }
    
    // render scenekit model
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if !anchor.isKind(of: ARPlaneAnchor.self) {
            DispatchQueue.main.async {
                let modelClone = self.nodeModel.clone()
                modelClone.position = SCNVector3Zero
                self.currentNode = modelClone
                // Add model as a child of the node
                node.addChildNode(modelClone)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSCNViewDelegate
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
