//
//  DishResult.swift
//  Seefood
//
//  Created by Jeff on 2018-03-03.
//  Copyright © 2018 Duvelop. All rights reserved.
//
import Foundation

class DishResult {
    var data: [String: Any] = [:]
    
    init(imageId: String, title: String, restaurant: String, price: Double?, descripLabel: String?, size: MealSize?, requests: [SpecialRequest]?, cuisine: Cuisine?) {
        data["imageId"] = imageId
        data["title"] = title
        data["restaurant"] = restaurant
        data["price"] = price ?? "Price not available online"
        data["descripLabel"] = descripLabel ?? "See restaurant menu for description"
        data["size"] = size ?? MealSize.MEDIUM
        data["requests"] = requests ?? []
        data["cuisine"] = cuisine ?? Cuisine.COMFORT
    }
    
    subscript(key: String) -> Any {
        get {
            return data[key]!
        }
        set(newValue) {
            return data[key] = newValue
        }
    }
}
