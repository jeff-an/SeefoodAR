//
//  ResultsTableViewController.swift
//  Seefood
//
//  Created by Sara on 3/3/18.
//  Copyright © 2018 Duvelop. All rights reserved.
//

import UIKit

class ResultsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var currCount = 0
    var selectedRow = 0
    // Flag to determine whether the search is for all restaurants or for a specific one
    static var isRestaurantSearch = false
    static var isGeneralDishSearch = false
    
    static var restaurantName = ""
    static var results: [DishResult] = []
    
    static let dataStore = DataStore()
    let dishData = [
        [
            "imageId": "salmonNigiri",
            "title": "Salmon Nigiri",
            "restaurant": "Sushi Moto",
            "price": "12.99",
            "descripLabel": "Food"
        ],
        [
            "imageId": "tunaNigiri",
            "title": "Tuna Nigiri",
            "restaurant": "Sushi Moto",
            "price": "12.99",
            "descripLabel": "Food"
        ],
        [
            "imageId": "dumpling",
            "title": "Chicken Dumpling",
            "restaurant": "Sushi Moto",
            "price": "12.99",
            "descripLabel": "Food"
        ],
        [
            "imageId": "californiaRoll",
            "title": "California Roll",
            "restaurant": "Sushi Moto",
            "price": "12.99",
            "descripLabel": "Food"
        ],
        [
            "imageId": "spicyTunaRoll",
            "title": "Spicy Tuna Roll",
            "restaurant": "Sushi Moto",
            "price": "12.99",
            "descripLabel": "Food"
        ],
        [
            "imageId": "unagi",
            "title": "Unagi",
            "restaurant": "Sushi Moto",
            "price": "12.99",
            "descripLabel": "Food"
        ],
        [
            "imageId": "yellowtailNigiri",
            "title": "Yellow Tail Nigiri",
            "restaurant": "Sushi Moto",
            "price": "12.99",
            "descripLabel": "Food"
        ],
        [
            "imageId": "shrimpNigiri",
            "title": "Shrimp Nigiri",
            "restaurant": "Sushi Moto",
            "price": "12.99",
            "descripLabel": "Food"
        ],
        [
            "imageId": "tamago",
            "title": "Tamago",
            "restaurant": "Sushi Moto",
            "price": "12.99",
            "descripLabel": "Food"
        ],
        [
            "imageId": "cookie",
            "title": "Chocolate Chip Cookies",
            "restaurant": "Sushi Moto",
            "price": "12.99",
            "descripLabel": "Food"
        ]
    ]
    

    @IBOutlet weak var resultsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.resultsTableView.register(UINib(nibName: "ResultsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.resultsTableView.register(UINib(nibName: "TitleCell", bundle: nil), forCellReuseIdentifier: "titlecell")
        self.resultsTableView.separatorStyle = .none
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return dishData.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 100
        }else{
            return 140
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        self.performSegue(withIdentifier: "next", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        assert(ResultsTableViewController.isRestaurantSearch || ResultsTableViewController.isGeneralDishSearch, "Attempting to render search results without setting a search mode")
        let titleCell: TitleCell = tableView.dequeueReusableCell(withIdentifier: "titlecell") as! TitleCell
        let cell : ResultsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ResultsTableViewCell
        cell.selectionStyle = .none
        
        if(indexPath.row == 0){
            titleCell.isUserInteractionEnabled = false
            return titleCell
        }else{
            let dish = dishData[indexPath.row - 1]
            if indexPath.row > 0 {
                //put in custom titles and descrips
                cell.foodImage.image = UIImage(named: dish["imageId"]!)
                cell.title.text = dish["title"]!
                cell.price.text = dish["price"]!
                cell.restaurant.text = dish["restaurant"]!
                cell.descripLabel.text = dish["descripLabel"]!
            }
            cell.alpha = 0
            UIView.animate(withDuration: 0.75, animations: { cell.alpha = 1 })
            return cell
        }
        let cell : ResultsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ResultsTableViewCell
        cell.selectionStyle = .none
        let dish = dishData[indexPath.row]
        if indexPath.row > 0 {
           //put in custom titles and descrips
            cell.foodImage.image = UIImage(named: dish["imageId"]! as! String)
            cell.title.text = dish["title"]! as! String
            cell.price.text = String(dish["price"]! as! Float)
            cell.restaurant.text = dish["restaurant"]! as! String
            cell.descripLabel.text = dish["descripLabel"]! as! String
        }
        cell.alpha = 0
        UIView.animate(withDuration: 0.75, animations: { cell.alpha = 1 })
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    static func receiveRestaurantName(name: String) {
        // Set the restaurant name
        ResultsTableViewController.isRestaurantSearch = true
        ResultsTableViewController.restaurantName = name
        
        // Filter results
        results = dataStore.getDishesByRestaurant(name: name)
    }
    
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
        resultsTableView.reloadData()
        resultsTableView.reloadInputViews()
    }

}
