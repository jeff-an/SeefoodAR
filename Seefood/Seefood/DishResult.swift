//
//  DishResult.swift
//  Seefood
//
//  Created by Jeff on 2018-03-03.
//  Copyright © 2018 Duvelop. All rights reserved.
//

import Foundation

class DishResult {
    var data: [String: String]

    init(imageId: String, title: String, restaurant: String, price: String?, descripLabel: String?) {
        data["imageId"] = imageId
        data["title"] = title
        data["restaurant"] = restaurant
        data["price"] = price ?? "Price not available online"
        data["descripLabel"] = descripLabel ?? "See restaurant menu for description"
    }
    
    subscript(key: String) -> String {
        get {
            return data[key]!
        }
        set(newValue) {
            return data[key] = newValue
        }
    }
}
