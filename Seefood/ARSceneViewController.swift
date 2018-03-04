//
//  ARSceneViewController.swift
//  Seefood
//
//  Created by Sara on 3/3/18.
//  Copyright © 2018 Duvelop. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

let toggleDataShowHideNotification = Notification.Name("ToggleDataShowHideNotification")
let toggleDataActionUpdatesNotification = Notification.Name("ToggleDataActionUpdatesNotification")

class ARSceneViewController: UIViewController, ARSCNViewDelegate{

    @IBOutlet weak var sceneView: ARSCNView!
    var dataVC: DataViewController? = nil
    var dataYOffset: CGFloat = 110
    @objc var tapGesture = UITapGestureRecognizer()
    var panGesture = UIPanGestureRecognizer()
    var dataVisible = false
    var dataSize = CGSize()
    
    var nodeModel:SCNNode!
    var currentNode:SCNNode!
    var nodeName = "apple"
    var numModels:Int = 0
    
    var foodTitle = ""
    var foodDescrip = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(nodeName)
        
        if let dataVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DataVC") as? DataViewController{
            self.dataVC = dataVC
            
            dataVC.view.frame =  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 150)
            dataSize = dataVC.view.frame.size
            dataVC.view.frame.origin.y = self.view.frame.height - self.dataYOffset
            self.addChildViewController(dataVC)
            self.view.addSubview(dataVC.view)
            dataVC.didMove(toParentViewController: self)
            self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(ARSceneViewController.handlePanGesture(_:)))
            dataVC.view.addGestureRecognizer(self.panGesture)
            dataVC.foodTitle = self.foodTitle
            dataVC.foodDescrip = self.foodDescrip
            
            NotificationCenter.default.addObserver(forName: toggleDataShowHideNotification, object: nil, queue: nil, using: { (notification) in
                self.toggleState()
            })
            
        }
        
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
        let modelScene = SCNScene(named:"art.scnassets/SeefoodObjects/" + nodeName + ".dae")!

        nodeModel = modelScene.rootNode.childNode(withName: nodeName, recursively: true)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(getter: self.tapGesture))
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

    @objc func handlePan(_ gestureRecognize:UIPanGestureRecognizer) {
        let translation = gestureRecognize.translation(in: self.view)
        let coeff = Float(0.04)
        if let node = currentNode {
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
                if let model = self.nodeModel {
                    print("self.nodeModel exists")
                    let modelClone = model.clone()
                    modelClone.position = SCNVector3Zero
                    self.currentNode = modelClone
                    // Add model as a child of the node
                    node.addChildNode(modelClone)
                } else {
                    print("self.nodeModel does not exist")
                }
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
    
    func getConfiguration() -> ARWorldTrackingConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        return configuration
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        sceneView.session.pause()
    }
    

}

extension ARSceneViewController: UIGestureRecognizerDelegate{
    func toggle(visible:Bool ){
        if let dataVC = self.dataVC {
            print("Animating State Change")
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 5.0, options: .curveEaseOut, animations: {
                
                if visible == true{
                    dataVC.view.frame = CGRect(origin: CGPoint.zero, size: self.dataSize)
                    dataVC.view.center = self.view.center
                }else if visible == false{
                    dataVC.view.frame.origin.y = self.view.frame.height - self.dataYOffset
                }
            }, completion:{ (finished) in
                NotificationCenter.default.post(name: toggleDataActionUpdatesNotification, object: visible)
            })
            self.dataVisible = visible
            
        }
    }
    
    func toggleState(){
        if self.dataVisible == true{
            toggle(visible: false)
        }else{
            toggle(visible: true)
        }
    }
    
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == tapGesture {
            if let dataVC = self.dataVC{
                return  dataVC.view.frame.contains(gestureRecognizer.location(in: self.view)) == false
            }
        }
        return true
    }
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer){
        if let dataVC = self.dataVC{
            switch recognizer.state {
            case .began:
                print("Began sliding VC")
            case .changed:
                let translation = recognizer.translation(in: view).y
                dataVC.view.center.y += translation
                recognizer.setTranslation(CGPoint.zero, in: view)
            case .ended:
                if abs(recognizer.velocity(in: view).y) > 200{
                    if recognizer.velocity(in: view).y < -200{
                        toggle(visible: true)
                    }else if recognizer.velocity(in: view).y > 200{
                        toggle(visible: false)
                    }
                }else{
                    if dataVC.view.center.y > self.view.frame.height / 2.0{
                        toggle(visible: false)
                    }else{
                        toggle(visible: true)
                    }
                }
            default:
                break
            }
        }
    }
    
}


