//
//  PrizesListViewController.swift
//  Prizes
//
//  Created by Daria Pr on 21.07.2021.
//

import UIKit
import SnapKit

@objc protocol PrizesListDelegate: class {
    func reloadListOfPrizes()
}

class PrizesListViewController: UIViewController {

    //MARK: - UIProperties
    
    private let navigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.barTintColor = .white
        return navBar
    } ()
    
    private let prizesView = PrizesView()
        
    //MARK: - Properties
    
    private let db = DataBaseManager.shared
    
    private var isFirstClick = true
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view = prizesView
        
        setupNavigationBar()
    }
}

//MARK: - Setup NavigationBar

private extension PrizesListViewController {
    func setupNavigationBar() {
        view.addSubview(navigationBar)
        
        navigationBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
                
        let navItem = UINavigationItem(title: "Prizes")
        
        let addItem = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(addNewPrize))
        
        addItem.tintColor = Color.mainColor()
        
        navItem.rightBarButtonItem = addItem

        navigationBar.setItems([navItem], animated: false)
    }
}

//MARK: - Actions

extension PrizesListViewController {
    @objc func addNewPrize() {
        let vc = AddingNewPrizeViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK: - PrizesListDelegate

extension PrizesListViewController: PrizesListDelegate {
    func reloadListOfPrizes() {
        db.fillStructBy(prizes: db.getListOfPrizes())
        prizesView.reloadPrizeTable()
    }
}
