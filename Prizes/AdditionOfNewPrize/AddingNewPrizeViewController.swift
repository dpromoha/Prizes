//
//  AddingNewPrizeViewController.swift
//  Prizes
//
//  Created by Daria Pr on 21.07.2021.
//

import UIKit

@objc protocol AddingNewPrizeDelegate: class {
    func saveNew(prize: Prize)
}

class AddingNewPrizeViewController: UIViewController {

    //MARK: - UIProperty
    
    private lazy var addingView: AddingNewPrizeView = {
        let view = AddingNewPrizeView()
        view.delegate = self
        return view
    } ()
    
    weak var delegate: PrizesListDelegate?
    
    //MARK: - Property
    
    private let db = DataBaseManager.shared

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view = addingView
    }
}

//MARK: - AddingNewPrizeDelegate

extension AddingNewPrizeViewController: AddingNewPrizeDelegate {
    func saveNew(prize: Prize) {
        db.saveNew(prize: prize)
        
        self.dismiss(animated: true) {
            self.delegate?.reloadListOfPrizes()
        }
    }
}
