//
//  PeopleTableViewCell.swift
//  HFProject
//
//  Created by Biron Su on 8/11/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {

    @IBOutlet weak var peopleNameLabel: UILabel!
    @IBOutlet weak var peopleHairColorLabel: UILabel!
    @IBOutlet weak var peopleEyeColorLabel: UILabel!
    @IBOutlet weak var peopleBirthYearLabel: UILabel!
    @IBOutlet weak var peopleDateCreatedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
