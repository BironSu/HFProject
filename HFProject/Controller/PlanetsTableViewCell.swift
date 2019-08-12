//
//  PlanetsTableViewCell.swift
//  HFProject
//
//  Created by Biron Su on 8/12/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class PlanetsTableViewCell: UITableViewCell {

    @IBOutlet weak var planetsNameLabel: UILabel!
    @IBOutlet weak var planetsClimateLabel: UILabel!
    @IBOutlet weak var planetsPopulationLabel: UILabel!
    @IBOutlet weak var planetsCreatedLabel: UILabel!
    @IBOutlet weak var planetsPreviousButton: UIButton!
    @IBOutlet weak var planetsNextButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
