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
    
    @IBOutlet weak var resultsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultsTableView.register(UINib(nibName: "ResultsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.resultsTableView.register(UINib(nibName: "TitleCell", bundle: nil), forCellReuseIdentifier: "titlecell")
        self.resultsTableView.separatorStyle = .none
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ResultsTableViewController.results.count + 1
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

        if(indexPath.row == 0){
            titleCell.isUserInteractionEnabled = false
            return titleCell
        }
        
        let cell : ResultsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ResultsTableViewCell
        cell.selectionStyle = .none
        if indexPath.row > 0 {
            let dish = ResultsTableViewController.results[indexPath.row - 1]
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
    
    static func receiveRestaurantName(name: String) {
        // Set the restaurant name
        ResultsTableViewController.isRestaurantSearch = true
        ResultsTableViewController.restaurantName = name
        // Filter results
        results = dataStore.getDishesByRestaurant(name: name)
    }
    
    static func receiveChatResults(cuisine: Cuisine?, size: MealSize?, requests: [SpecialRequest]?) {
        ResultsTableViewController.isGeneralDishSearch = true
        results = dataStore.filterDishes(cuisine: cuisine, size: size, requests: requests)
    }
    
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
        resultsTableView.reloadData()
        resultsTableView.reloadInputViews()
    }
    
}
