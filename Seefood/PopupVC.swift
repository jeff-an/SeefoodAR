//
//  PopupVC.swift
//  Seefood
//
//  Created by Jeff on 2018-03-03.
//  Copyright © 2018 Duvelop. All rights reserved.
//

import UIKit

class PopupVC: UIViewController {
    @IBOutlet weak var TextAction: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "RestaurantSelectAction") {
            ResultsTableViewController.receiveRestaurantName(name: self.TextAction.text!)
        }
    }
}
