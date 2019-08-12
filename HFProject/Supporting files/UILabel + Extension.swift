//
//  UILabel + Extension.swift
//  HFProject
//
//  Created by Biron Su on 8/12/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

extension UILabel{
    func customize() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
        self.textAlignment = .center
        self.font = UIFont.boldSystemFont(ofSize: 18)
        self.backgroundColor = .init(white: 1.0, alpha: 0.6)
    }
}
