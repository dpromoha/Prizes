//
//  Prize.swift
//  Prizes
//
//  Created by Daria Pr on 21.07.2021.
//

import UIKit
import RealmSwift

class Prize: Object {
    @objc dynamic var nameOfPrize: String = ""
    @objc dynamic var priceOfPrize: Int = 0
    @objc dynamic var identificationNumber: String = ""
    
    convenience init(nameOfPrize: String, priceOfPrize: Int, identificationNumber: String) {
        self.init()
        
        self.nameOfPrize = nameOfPrize
        self.priceOfPrize = priceOfPrize
        self.identificationNumber = identificationNumber
    }
}
