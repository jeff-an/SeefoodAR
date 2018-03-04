//
//  DataStore.swift
//  Seefood
//
//  Created by Jeff on 2018-03-03.
//  Copyright © 2018 Duvelop. All rights reserved.
//

//
//  DataStore.swift
//  Seefood
//
//  Created by Jeff on 2018-03-03.
//  Copyright © 2018 Duvelop. All rights reserved.
//
import Foundation

enum MealSize {
    case SMALL
    case MEDIUM
    case LARGE
}

enum SpecialRequest {
    case SPICY
    case MILD
    case ORGANIC
    case GLUTENFREE
    case VEGETARIAN
    case NONE
}

enum Cuisine {
    case JAPANESE
    case KOREAN
    case CHINESE
    case AMERICAN
    case COMFORT
    case INDIAN
}

class DataStore {
    let dishesByID: [String: DishResult] = [
        "0": DishResult(imageId: "0",
                        title: "Salmon Bento Box",
                        restaurant: "Sushi Moto",
                        price: 12.99,
                        descripLabel: "Succulent, fresh salmon nigiri served with rice.",
                        size: MealSize.SMALL,
                        requests: nil,
                        cuisine: Cuisine.JAPANESE
        ),
        
        "1": DishResult(imageId: "1",
                        title: "Tuna Bento Box",
                        restaurant: "Sushi Moto",
                        price: 12.99,
                        descripLabel: "Salmon Bento Box, except with Tuna.",
                        size: nil,
                        requests: nil,
                        cuisine: nil
        ),
        
        ]
    
    var dishesByRestaurant: [String: [DishResult]] = [:]
    
    func getDishById(id: String) -> DishResult {
        if let dish = dishesByID[id] {
            return dish
        }
        return dishesByID["0"]!
    }
    
    func getDishesByRestaurant(name: String) -> [DishResult] {
        if let dishes = dishesByRestaurant[name] {
            return dishes
        }
        return dishesByRestaurant["Sushi Moto"]!
    }
    
    func filterDishes(cuisine: Cuisine?, size: MealSize?, requests: [SpecialRequest]?) -> [DishResult] {
        var allData = Array(dishesByID.values)
        if requests != nil && requests! != [] {
            allData = allData.filter({ dish in return requests!.reduce(true, {
                (acc: Bool, elm: SpecialRequest) -> Bool in return acc && (dish["requests"] as! [SpecialRequest]).contains(elm)
            })})
        }
        if cuisine != nil && allData.count > 0 {
            allData = allData.filter({ dish in return dish["cuisine"] as? Cuisine == cuisine })
        }
        if size != nil && allData.count > 0 {
            allData = allData.filter({ dish in return dish["size"] as? MealSize == size })
        }
        return allData
    }
    
    init() {
        // Group all dishes by restaurant
        for (_, dish) in dishesByID {
            let restaurant = dish["restaurant"] as! String
            if var dishes = dishesByRestaurant[restaurant] {
                dishes.append(dish)
            } else {
                dishesByRestaurant[restaurant] = [dish]
            }
        }
    }
    
}
