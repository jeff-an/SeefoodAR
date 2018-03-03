//
//  DataStore.swift
//  Seefood
//
//  Created by Jeff on 2018-03-03.
//  Copyright © 2018 Duvelop. All rights reserved.
//

import Foundation

class DataStore {
    let dishById: [String: DishResult] = [
        "0": DishResult(imageId: "0", title: "Salmon Bento Box", restaurant: "Sushi Moto", price: "12.99", descripLabel: "Succulent, fresh salmon nigiri served with rice."),
        "1": DishResult(imageId: "1", title: "Tuna Bento Box", restaurant: "Sushi Moto", price: "12.99", descripLabel: "Salmon Bento Box, except with Tuna.")
    ]
    
    var dishesByRestaurant: [String: [DishResult]] = [:]
    
    func getDishById(id: String) -> DishResult {
        if let dish = dishById[id] {
            return dish
        }
        return dishById["0"]!
    }
    
    init() {
        // Group all dishes by restaurant
        for (_, dish) in dishById {
            let restaurant = dish["restaurant"]
            if var dishes = dishesByRestaurant[restaurant] {
                dishes.append(dish)
            } else {
                dishesByRestaurant[restaurant] = [dish]
            }
        }
    }
    
}
