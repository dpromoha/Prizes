//
//  UIStackView + Extension.swift
//  Prizes
//
//  Created by Daria Pr on 21.07.2021.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(views: UIView...) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}
