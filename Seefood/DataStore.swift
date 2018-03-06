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

let organicGlutenMild = [SpecialRequest.NONE, SpecialRequest.ORGANIC, SpecialRequest.MILD, SpecialRequest.GLUTENFREE]

let organicGlutenSpicy = [SpecialRequest.NONE, SpecialRequest.ORGANIC, SpecialRequest.SPICY, SpecialRequest.GLUTENFREE]

let organicVegetarianMild = [SpecialRequest.NONE, SpecialRequest.ORGANIC, SpecialRequest.MILD, SpecialRequest.VEGETARIAN]

let organicVegetarianSpicy = [SpecialRequest.NONE, SpecialRequest.ORGANIC, SpecialRequest.SPICY, SpecialRequest.VEGETARIAN]

class DataStore {
    var currentItem = 0

    // make-shift sql database
    let dishesByID: [String: DishResult] = [
        "salmonBento": DishResult(imageId: "salmonBento",
                        title: "Salmon Bento Box",
                        restaurant: "Sushi Moto",
                        price: 15.99,
                        descripLabel: "Succulent, fresh salmon nigiri served with rice.",
                        size: MealSize.LARGE,
                        requests: [SpecialRequest.NONE, SpecialRequest.ORGANIC, SpecialRequest.MILD],
                        cuisine: Cuisine.JAPANESE
        ),
        
        "tunaBento": DishResult(imageId: "tunaBento",
                        title: "Tuna Bento Box",
                        restaurant: "Sushi Moto",
                        price: 12.99,
                        descripLabel: "Salmon Bento Box, except with Tuna.",
                        size: MealSize.LARGE,
                        requests: [SpecialRequest.NONE, SpecialRequest.ORGANIC, SpecialRequest.MILD],
                        cuisine: Cuisine.JAPANESE
        ),
        
        "salmonNigiri": DishResult(imageId: "salmonNigiri",
                                   title: "Salmon Nigiri",
                                   restaurant: "Maki Yaki",
                                   price: 8.00,
                                   descripLabel: "",
                                   size: nil,
                                   requests: [SpecialRequest.NONE, SpecialRequest.ORGANIC, SpecialRequest.MILD],
                                   cuisine: Cuisine.JAPANESE
        ),
        
        "tunaNigiri": DishResult(imageId: "tunaNigiri",
                                 title: "Tuna Nigiri",
                                 restaurant: "Maki Yaki",
                                 price: 8.00,
                                 descripLabel: "Fresh slices of raw tuna caught off the West Coast",
                                 size: MealSize.SMALL,
                                 requests: organicGlutenMild,
                                 cuisine: Cuisine.JAPANESE),
        
        "californiaRoll": DishResult(imageId: "californiaRoll",
                                     title: "California Roll",
                                     restaurant: "Sushi Queen",
                                     price: 6.99,
                                     descripLabel: "8pcs california roll served with miso soup.",
                                     size: MealSize.SMALL,
                                     requests: organicVegetarianMild,
                                     cuisine: Cuisine.JAPANESE),
        
        "goldenRoll": DishResult(imageId: "goldenRoll",
                                title: "Golden Roll",
                                restaurant: "Maki Yaki",
                                price: 7.99,
                                descripLabel: "Salmon with carrot avocado and tempura.",
                                size: MealSize.MEDIUM,
                                requests: [SpecialRequest.NONE, SpecialRequest.MILD],
                                cuisine: Cuisine.JAPANESE
                            ),        
        "unagiNigiri": DishResult(imageId: "unagiNigiri",
                                  title: "Unagi Nigiri",
                                  restaurant: "Sushi Moto",
                                  price: 6.49,
                                  descripLabel: "Freshwater eel wrapped in seeweed.",
                                  size: MealSize.SMALL,
                                  requests: [SpecialRequest.NONE, SpecialRequest.MILD],
                                  cuisine: Cuisine.JAPANESE),
        
        "spicyTunaRoll": DishResult(imageId: "spicyTunaRoll",
                                    title: "Spicy Tuna Roll",
                                    restaurant: "Sushi Moto",
                                    price: 7.99,
                                    descripLabel: "Fresh tuna topped with zesty orange sauce.",
                                    size: MealSize.SMALL,
                                    requests: organicGlutenSpicy,
                                    cuisine: Cuisine.JAPANESE),
        
        "yellowtailNigiri": DishResult(imageId: "yellowtailNigiri",
                                       title: "Yellow Tail Nigiri",
                                       restaurant: "Sushi Moto",
                                       price: 12.99,
                                       descripLabel: "Japanese amberjack fish. Extremely high in protein!",
                                       size: MealSize.SMALL,
                                       requests: organicGlutenMild,
                                       cuisine: Cuisine.JAPANESE),
        
        "shrimpNigiri": DishResult(imageId: "shrimpNigiri",
                                   title: "Shrimp Nigiri",
                                   restaurant: "Sushi Moto",
                                   price: 5.29,
                                   descripLabel: "Slices of parcooked shrimp atop rice. Source of omega fatty acids.",
                                   size: MealSize.SMALL,
                                   requests: organicGlutenMild,
                                   cuisine: Cuisine.JAPANESE),
        
        "tamagoNigiri": DishResult(imageId: "tamagoNigiri",
                                   title: "Tamago Nigiri",
                                   restaurant: "Sushi Queen",
                                   price: 6.29,
                                   descripLabel: "6pcs slices of Tamago nigiri.",
                                   size: MealSize.SMALL,
                                   requests: organicGlutenMild,
                                   cuisine: Cuisine.JAPANESE),
        
        "cheeseburger": DishResult(imageId: "cheeseburger",
                                   title: "Cheeseburger",
                                   restaurant: "Caltech Chandler Cafe",
                                   price: 8.99,
                                   descripLabel: "Angus beef burger with cheddar cheese.",
                                   size: MealSize.LARGE,
                                   requests: [SpecialRequest.NONE],
                                   cuisine: Cuisine.AMERICAN),
        
        "cookie": DishResult(imageId: "cookie",
                            title: "Chocolate Chip Cookie",
                            restaurant: "Caltech Chandler Cafe",
                            price: 1.99,
                            descripLabel: "Cookie with large chocolate chunks.",
                            size: MealSize.SMALL,
                            requests: [SpecialRequest.NONE],
                            cuisine: Cuisine.AMERICAN),        
        "padthai": DishResult(imageId: "padthai",
                              title: "Pad Thai",
                              restaurant: "Rice Thai Tapas",
                              price: 14.99,
                              descripLabel: "House-favorite pad thai dish with chicken and signature peanut sauce.",
                              size: MealSize.LARGE,
                              requests: [SpecialRequest.NONE],
                              cuisine: Cuisine.CHINESE
        ),
        
        "mutterPaneer": DishResult(imageId: "mutterPaneer",
                                   title: "Mutter Paneer",
                                   restaurant: "Annapurna Grill",
                                   price: 7.99,
                                   descripLabel: "Cottage cheese and green pea Indian dish",
                                   size: MealSize.MEDIUM,
                                   requests: organicVegetarianSpicy,
                                   cuisine: Cuisine.INDIAN),
        
        "beefRoganjosh": DishResult(imageId: "beefRoganjosh",
                                    title: "Beef Roganjosh",
                                    restaurant: "New Delhi Palace",
                                    price: 7.99,
                                    descripLabel: "Beef stir fried with tomatoes, onion, lime, and garlic.",
                                    size: MealSize.MEDIUM,
                                    requests: [SpecialRequest.NONE, SpecialRequest.SPICY, SpecialRequest.MILD],
                                    cuisine: Cuisine.INDIAN),
        
        "veggieBurger": DishResult(imageId: "veggieBurger",
                                   title: "Veggie Burger",
                                   restaurant: "Paul Martin's",
                                   price: 16.00,
                                   descripLabel: "vegetarian three-mushroom patty, dressed arugula, pesto aioli",
                                   size: MealSize.LARGE,
                                   requests: [SpecialRequest.NONE, SpecialRequest.VEGETARIAN],
                                   cuisine: Cuisine.AMERICAN),
        
        "quinoaBowl": DishResult(imageId: "quinoaBowl",
                                   title: "Seasonal Quinoa Bowl",
                                   restaurant: "Paul Martin's",
                                   price: 18.00,
                                   descripLabel: "Savoy spinach, blistered tomatoes, fresh vegetables, grilled avocado, served warm",
                                   size: MealSize.MEDIUM,
                                   requests: [SpecialRequest.NONE,SpecialRequest.GLUTENFREE, SpecialRequest.VEGETARIAN, SpecialRequest.MILD],
                                   cuisine: Cuisine.AMERICAN),
        
        "bibimbap": DishResult(imageId: "bibimbap",
                               title: "Dolsat BiBimBap",
                               restaurant: "Teri & Yaki",
                               price: 13.99,
                               descripLabel: "Fried rice, beef, egg, and assorted vegetables in a stone bowl.",
                               size: MealSize.LARGE,
                               requests: [SpecialRequest.NONE,SpecialRequest.MILD, SpecialRequest.SPICY],
                               cuisine: Cuisine.KOREAN
        ),
        
        "bulgogi": DishResult(imageId: "bulgogi",
                              title: "Bulgogi",
                              restaurant: "Teri & Yaki",
                              price: 13.99,
                              descripLabel: "Thin, marinated slices of beef or pork grilled on a barbecue or on a stove-top griddle",
                              size: MealSize.LARGE,
                              requests: [SpecialRequest.MILD, SpecialRequest.SPICY, SpecialRequest.NONE],
                              cuisine: Cuisine.KOREAN
        ),
        "gamjatang": DishResult(imageId: "gamjatang",
                              title: "Gamjatang",
                              restaurant: "Soh Grill House",
                              price: 12.99,
                              descripLabel: "Spicy Korean soup made from the spine and neck bones of a pig",
                              size: MealSize.LARGE,
                              requests: [SpecialRequest.NONE, SpecialRequest.ORGANIC, SpecialRequest.NONE, SpecialRequest.SPICY],
                              cuisine: Cuisine.KOREAN
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
        if let dishes = dishesByRestaurant[name.lowercased()] {
            return dishes
        }
        return []
    }
    
    func filterDishes(cuisine: Cuisine?, size: MealSize?, requests: [SpecialRequest]?) -> [DishResult] {
        var allData = Array(dishesByID.values)
        print(allData)
        if requests != nil && requests! != [] {
            allData = allData.filter({ dish in return requests!.reduce(true, {
                (acc: Bool, elm: SpecialRequest) -> Bool in return acc && (dish["requests"] as! [SpecialRequest]).contains(elm)
            })})
        }
        print(allData)
        if cuisine != nil {
            allData = allData.filter({ dish in return dish["cuisine"] as? Cuisine == cuisine })
        }
        print(allData)
        if size != nil {
            allData = allData.filter({ dish in return dish["size"] as? MealSize == size })
        }
        print(allData)
        return allData
    }
    
    init() {
        // Group all dishes by restaurant
        for (_, dish) in dishesByID {
            let restaurant = dish["restaurant"] as! String
            if dishesByRestaurant[restaurant.lowercased()] != nil {
                dishesByRestaurant[restaurant.lowercased()]!.append(dish)
            } else {
                dishesByRestaurant[restaurant.lowercased()] = [dish]
            }
        }
    }
    
}
