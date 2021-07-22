//
//  PrizesView.swift
//  Prizes
//
//  Created by Daria Pr on 21.07.2021.
//

import UIKit
import RealmSwift

class PrizesView: UIView {
    
    //MARK: - UIProperties
    
    private let viewModel = PrizesViewModel()
    
    private lazy var prizesTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.separatorColor = .clear
        tableView.backgroundColor = .white
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        tableView.register(PrizesTableViewCell.self)
        return tableView
    } ()
    
    private let priceDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Font.aileronBold(size: 25)
        label.text = "Total selected for: "
        return label
    } ()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = Font.aileronBold(size: 25)
        label.text = "0"
        return label
    } ()
    
    private lazy var warningAlertView: WarningAlertView = {
        let view = WarningAlertView()
        view.delegate = self
        view.setupWarning()
        return view
    } ()
    
    //MARK: - Properties
    
    private let db = DataBaseManager.shared
    
    //MARK: - Init view
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        viewModel.delegate = self
        
        setupTableViewLayout()

        db.fillStructBy(prizes: db.getListOfPrizes())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Setup Layout

private extension PrizesView {
    func setupTableViewLayout() {
        addSubviews(priceLabel, priceDescriptionLabel, prizesTableView)
        
        priceDescriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(95)
            $0.left.equalToSuperview().offset(20)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(95)
            $0.left.equalTo(priceDescriptionLabel.snp.right).offset(5)
        }
        
        prizesTableView.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(10)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}

//MARK: - Public methods: reload prizes/setup price

extension PrizesView {
    func reloadPrizeTable() {
        prizesTableView.reloadData()
    }
    
    func setup(price: String) {
        priceLabel.text = "\(price)$"
    }
}

//MARK: - PrizesGetDataDelegate

extension PrizesView: PrizesGetDataDelegate {
    func add(prize: Prize) {
        priceLabel.text = "\(prize.priceOfPrize)$"
        
        for i in 0..<db.choosingPrizeStruct.count {
            if db.choosingPrizeStruct[i].identNumber == prize.identificationNumber {
                db.choosingPrizeStruct[i].isChoose = true
            }
        }
        
        countPrizesPrice()
    }
    
    func remove(prize: Prize) {
        for i in 0..<db.choosingPrizeStruct.count {
            if db.choosingPrizeStruct[i].identNumber == prize.identificationNumber {
                db.choosingPrizeStruct[i].isChoose = false
                countPrizesPrice()
                
                break
            }
        }
    }
}

//MARK: - Counting the number of selected prizes

private extension PrizesView {
    func countPrizesPrice() {
        var finalPrice = Int()
        
        for i in 0..<db.choosingPrizeStruct.count {
            if db.choosingPrizeStruct[i].isChoose {
                finalPrice += db.choosingPrizeStruct[i].price
                
                if finalPrice > 100 {
                    addSubview(warningAlertView)
                    warningAlertView.snp.makeConstraints {
                        $0.edges.equalToSuperview()
                    }
                    break
                }
            }
        }
        
        priceLabel.text = "\(finalPrice)$"
    }
}

//MARK: - WarningAlertDelegate

extension PrizesView: WarningAlertDelegate {
    func yesAction() {
        let sum = countOverflowSum()
        properSumOf(price: sum)
    }
    
    func noAction() {
        countLastSum()
        prizesTableView.reloadData()
        warningAlertView.removeFromSuperview()
    }
}

//MARK: - Counting a proper sum of prices

private extension PrizesView {
    func properSumOf(price: Int) {
        if price <= 100 {
            warningAlertView.removeFromSuperview()
            prizesTableView.reloadData()
            
            priceLabel.text = "\(price)$"
        } else {
            let sum = countOverflowSum()
            properSumOf(price: sum)
        }
    }
    
    func countOverflowSum() -> Int {
        var finalResult = 0
        
        for i in 0..<db.choosingPrizeStruct.count {
            if db.choosingPrizeStruct[i].isChoose {
                db.choosingPrizeStruct[i].isChoose = false
                break
            }
        }
        
        for i in 0..<db.choosingPrizeStruct.count {
            if db.choosingPrizeStruct[i].isChoose {
                finalResult += db.choosingPrizeStruct[i].price
            }
        }
        
        return finalResult
    }
    
    func countLastSum() {
        var finalResult = String()
        var sumPrice = Int()
        
        for i in 0..<db.choosingPrizeStruct.count {
            if db.choosingPrizeStruct[i].isChoose {
                finalResult = db.choosingPrizeStruct[i].identNumber
            }
        }
        
        for i in 0..<db.choosingPrizeStruct.count {
            if db.choosingPrizeStruct[i].identNumber == finalResult {
                db.choosingPrizeStruct[i].isChoose = false
                break
            }
        }
        
        for i in 0..<db.choosingPrizeStruct.count {
            if db.choosingPrizeStruct[i].isChoose {
                sumPrice += db.choosingPrizeStruct[i].price
            }
        }
        
        priceLabel.text = "\(sumPrice)$"
    }
}
