//
//  PrizesViewModel.swift
//  Prizes
//
//  Created by Daria Pr on 21.07.2021.
//

import UIKit
import RealmSwift

protocol PrizesGetDataDelegate: class {
    func add(prize: Prize)
    func remove(prize: Prize)
}

class PrizesViewModel: NSObject {
    
    //MARK: - Properties
    
    private var prizes: Results<Prize>?
    
    private let db = DataBaseManager.shared
        
    weak var delegate: PrizesGetDataDelegate?
    
    private var isFirstTime = false
    
    //MARK: - Init ViewModel
    
    override init() {
        super.init()

        prizes = db.getListOfPrizes()
    }
}

//MARK: -  UITableViewDelegate, UITableViewDataSource

extension PrizesViewModel: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return db.choosingPrizeStruct.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeue(PrizesTableViewCell.self, for: indexPath) else { return PrizesTableViewCell() }
        cell.setupCell(name: db.choosingPrizeStruct[indexPath.section].name, price: String(db.choosingPrizeStruct[indexPath.section].price), isSelected: db.choosingPrizeStruct[indexPath.section].isChoose)
        cell.addGrayShadow(offset: CGSize(width: 0, height: 2), radius: 10)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Delete", handler: { (action,view,completionHandler ) in
            completionHandler(true)
            self.db.delete(prize: self.prizes![indexPath.section])
            tableView.reloadData()
        })
        
        action.backgroundColor = Color.mainColor()

        let configuration = UISwipeActionsConfiguration(actions: [action])

        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? PrizesTableViewCell {
            if cell.isPicked {
                delegate?.remove(prize: prizes![indexPath.section])
                cell.unpicked()
            } else {
                delegate?.add(prize: prizes![indexPath.section])
                cell.picked()
            }
        }
    }
}
