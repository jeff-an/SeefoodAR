//
//  DataViewController.swift
//  Seefood
//
//  Created by Sara on 3/3/18.
//  Copyright © 2018 Duvelop. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {
    
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var descripLabel: UILabel!
    var foodTitle = ""
    var foodDescrip = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 1.0
        blurEffectView.layer.cornerRadius = 35
        blurEffectView.clipsToBounds = true
        blurEffectView.frame = self.view.bounds
        blurEffectView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 0)
        
        //let currDish = DataViewController.dataStore.getDishById(id: "\(DataViewController.dataStore.currentItem)")
        //toggleButton.setTitle(currDish["title"] as! String, for: .normal)
        //descripLabel.text = currDish["descripLabel"] as! String
        
        NotificationCenter.default.addObserver(forName: toggleDataActionUpdatesNotification, object: nil, queue: nil) { (notification) in
            if let visible = notification.object as? Bool{
                UIView.transition(with: self.toggleButton, duration: 0.5, options: .curveLinear, animations: {
                    if visible{
                        //self.toggleButton.setImage(#imageLiteral(resourceName: "collapseButton"), for: .normal)
                    }else{
                        //self.toggleButton.setImage(#imageLiteral(resourceName: "aboutBtn"), for: .normal)
                    }
                }, completion: nil)
            }
        }
    }
    
    
    @IBAction func collapseClicked(_ sender: Any) {
        NotificationCenter.default.post(name: toggleDataShowHideNotification, object: nil)
    }
    
    /*
    @IBAction func presetButtonClicked(_ sender: UIButton) {
        NotificationCenter.default.post(name: toggleDataShowHideNotification, object: nil)
    }*/
    
    
    
}


