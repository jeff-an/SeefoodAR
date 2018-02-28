//
//  StartViewController.swift
//  Seefood
//
//  Created by Jeff on 2018-03-03.
//  Copyright © 2018 Duvelop. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentModal() {
        let modalController = PopupVC()
        modalController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        present(modalController, animated: true, completion: nil)
    }

    @IBAction func FindDishAction(_ sender: Any) {
        self.performSegue(withIdentifier: "FindDish", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowMenuSegue") {
            
        }
    }
    
    @IBAction func unwindToViewControllerStartController(segue: UIStoryboardSegue) {
    }

}
