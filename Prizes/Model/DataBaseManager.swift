//
//  DataBaseManager.swift
//  Prizes
//
//  Created by Daria Pr on 21.07.2021.
//

import UIKit
import RealmSwift

class DataBaseManager {
    static let shared = DataBaseManager()
    
    let realm = try! Realm()
    
    var prizes: Results<Prize>?
    
    var choosingPrizeStruct = [ChoosingPrize]()
    
    func saveNew(prize: Prize) {
        do {
            try realm.write({
                realm.add(prize)
            })
        } catch {
            print("Can`t add")
        }
    }
    
    func getListOfPrizes() -> Results<Prize> {
        return realm.objects(Prize.self)
    }
    
    func delete(prize: Prize) {
        do {
            try realm.write({
                realm.delete(prize)
            })
        } catch {
            print("Can`t delete")
        }
        
        fillStructBy(prizes: getListOfPrizes())
    }
    
    func fillStructBy(prizes: Results<Prize>) {
        choosingPrizeStruct = []
        for i in prizes {
            choosingPrizeStruct.append(ChoosingPrize(name: i.nameOfPrize, identNumber: i.identificationNumber, isChoose: false, price: i.priceOfPrize))
        }
    }
}
