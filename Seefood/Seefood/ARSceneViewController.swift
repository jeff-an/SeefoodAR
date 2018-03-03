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
    var tapGesture = UITapGestureRecognizer()
    var panGesture = UIPanGestureRecognizer()
    var dataVisible = false
    var dataSize = CGSize()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let dataVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DataVC") as? DataViewController{
            self.dataVC = dataVC
            
            dataVC.view.frame =  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 200)
            dataSize = dataVC.view.frame.size
            dataVC.view.frame.origin.y = self.view.frame.height - self.dataYOffset
            self.addChildViewController(dataVC)
            self.view.addSubview(dataVC.view)
            dataVC.didMove(toParentViewController: self)
            self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(ARSceneViewController.handlePanGesture(_:)))
            dataVC.view.addGestureRecognizer(self.panGesture)
            
            NotificationCenter.default.addObserver(forName: toggleDataShowHideNotification, object: nil, queue: nil, using: { (notification) in
                self.toggleState()
            })
            
        }
        
        sceneView.delegate = self
        
    }

    func getConfiguration() -> ARWorldTrackingConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        return configuration
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.run(getConfiguration())
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


