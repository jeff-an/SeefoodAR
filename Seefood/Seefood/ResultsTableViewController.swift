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
    var isRestaurantSearch = false
    var isGeneralDishSearch = false
    
    var restaurantName = ""
    var results: [DishResult] = []
    let dataStore = DataStore()
    let dishData = [
        [
            "imageId": "0",
            "title": "Salmon Bento Box",
            "restaurant": "Sushi Moto",
            "price": "12.99",
            "descripLabel": "Food"
        ],
        [
            "imageId": "0",
            "title": "Salmon Bento Box",
            "restaurant": "Sushi Moto",
            "price": "12.99",
            "descripLabel": "Food"
        ],
        [
            "imageId": "0",
            "title": "Salmon Bento Box",
            "restaurant": "Sushi Moto",
            "price": "12.99",
            "descripLabel": "Food"
        ],
    ]
    

    @IBOutlet weak var resultsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.resultsTableView.register(UINib(nibName: "ResultsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.resultsTableView.register(UINib(nibName: "TitleCell", bundle: nil), forCellReuseIdentifier: "titlecell")
        self.resultsTableView.separatorStyle = .none
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return currCount + 1
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
        assert(isRestaurantSearch || isGeneralDishSearch, "Attempting to render search results without setting a search mode")
        let titleCell: TitleCell = tableView.dequeueReusableCell(withIdentifier: "titlecell") as! TitleCell
        if(indexPath.row == 0){
            titleCell.isUserInteractionEnabled = false
            return titleCell
        }
        let cell : ResultsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ResultsTableViewCell
        cell.selectionStyle = .none
        let dish = dishData[indexPath.row]
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func receiveRestaurantName(name: String) {
        // Set the restaurant name
        self.isRestaurantSearch = true
        self.restaurantName = name
        
        // Filter results
        results = dataStore.getDishesByRestaurant(name: name)
    }
    
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
        resultsTableView.reloadData()
        resultsTableView.reloadInputViews()
    }

}
