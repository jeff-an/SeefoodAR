//
//  ResultsTableViewCell.swift
//  Seefood
//
//  Created by Sara on 3/3/18.
//  Copyright © 2018 Duvelop. All rights reserved.
//

import UIKit
class ResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var restaurant: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var descripLabel: UILabel!

    override func awakeFromNib() {
        foodImage.layer.cornerRadius = 7
        foodImage.layer.masksToBounds = true
    }
}
