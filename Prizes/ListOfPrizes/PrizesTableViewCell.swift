//
//  PrizesTableViewCell.swift
//  Prizes
//
//  Created by Daria Pr on 21.07.2021.
//

import UIKit

class PrizesTableViewCell: UITableViewCell {
    
    //MARK: - UIProperties
    
    private let nameOfPrizeLabel: UILabel = {
        let label = UILabel()
        label.font = Font.aileronBold(size: 20)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    } ()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = Font.aileronRegular(size: 15)
        label.textColor = .gray
        return label
    } ()
    
    private let checkmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.emptyCheckmarkImageState(), for: .normal)
        return button
    } ()
    
    //MARK: - Property
    
    var isPicked = false

    //MARK: - Init
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        backgroundColor = .clear
        layer.masksToBounds = false
        layer.shadowOpacity = 0.23
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor

        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5
        
        selectionStyle = .none
                
        setupLayout()
    }
}

//MARK: - Setup Layout

private extension PrizesTableViewCell {
    func setupLayout() {
        addSubviews(nameOfPrizeLabel, priceLabel, checkmarkButton)
        
        nameOfPrizeLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.centerY.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints {
            $0.left.equalTo(nameOfPrizeLabel.snp.right).offset(10)
            $0.centerY.equalToSuperview()
        }
        
        checkmarkButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-25)
        }
    }
}

//MARK: - Public methods: setup tableViewCell

extension PrizesTableViewCell {
    func setupCell(name: String, price: String, isSelected: Bool) {
        nameOfPrizeLabel.text = name
        priceLabel.text = "(\(price)$)"
        
        isSelected ? picked() : unpicked()
    }
    
    func picked() {
        isPicked = true
        checkmarkButton.setImage(Image.fullCheckmarkImageState(), for: .normal)
        
    }
    
    func unpicked() {
        isPicked = false
        checkmarkButton.setImage(Image.emptyCheckmarkImageState(), for: .normal)
    }
}
