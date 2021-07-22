//
//  UITableViewCellExtension.swift
//  Prizes
//
//  Created by Daria Pr on 21.07.2021.
//

import UIKit

extension UITableViewCell {
    func addGrayShadow(offset: CGSize, radius: CGFloat) {
        self.shadowColor = UIColor(red: 0.376, green: 0.396, blue: 0.447, alpha: 0.3)
        layer.cornerRadius = 20
        layer.masksToBounds = true
        self.shadowRadius = radius
        self.shadowOffset = offset
        self.shadowOpacity = 1
        self.clipsToBounds = false
    }
}
