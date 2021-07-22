//
//  WarningAlertView.swift
//  Prizes
//
//  Created by Daria Pr on 22.07.2021.
//

import UIKit

@objc protocol WarningAlertDelegate: class {
    func yesAction()
    func noAction()
}

@objc protocol ErrorAlertDelegate: class {
    func okAction()
}

class WarningAlertView: UIView {
    
    //MARK: - UIProperties
    
    private let backgroundView: UIView = {
        let backgrView = UIView()
        backgrView.backgroundColor = .black.withAlphaComponent(0.5)
        return backgrView
    } ()
    
    private let alertBoxImageView: UIImageView = {
        let alertBox = UIImageView()
        alertBox.image = Image.alertBoxImage()
        return alertBox
    } ()
    
    private let alertTitleLabel: UILabel = {
        let l = UILabel()
        l.textColor = .black
        l.font = R.font.aileronBold(size: 16)
        l.numberOfLines = 3
        l.textAlignment = .center
        return l
    } ()
    
    private let yesButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Color.mainColor()
        button.setTitle("yes", for: .normal)
        button.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(yesAction), for: .touchUpInside)
        return button
    } ()
    
    private let noButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Color.mainColor()
        button.setTitle("no", for: .normal)
        button.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(noAction), for: .touchUpInside)
        return button
    } ()
    
    private let okButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Color.mainColor()
        button.setTitle("OK", for: .normal)
        button.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(okButtonAction), for: .touchUpInside)
        return button
    } ()
    
    weak var delegate: WarningAlertDelegate?
    weak var errorDelegate: ErrorAlertDelegate?
    
    //MARK: - Init view
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setup Layout

private extension WarningAlertView {
    func setupWarningAlert() {
        addSubview(backgroundView)
        
        alertTitleLabel.text = "Are you sure you want to add this prize? (This will remove the first selected prizes)"
        
        backgroundView.addSubviews(alertBoxImageView, alertTitleLabel, yesButton, noButton)
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        alertBoxImageView.snp.makeConstraints {
            $0.height.equalTo(164)
            $0.width.equalTo(327)
            $0.center.equalToSuperview()
        }
        
        alertTitleLabel.snp.makeConstraints {
            $0.top.equalTo(alertBoxImageView).offset(20)
            $0.left.equalTo(alertBoxImageView).offset(10)
            $0.right.equalTo(alertBoxImageView).offset(-10)
        }

        yesButton.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(40)
            $0.top.equalTo(alertBoxImageView).offset(100)
            $0.left.equalTo(alertBoxImageView).offset(23)
        }

        noButton.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(40)
            $0.top.equalTo(alertBoxImageView).offset(100)
            $0.left.equalTo(yesButton.snp.right).offset(40)
        }
    }
    
    func setupErrorAlert() {
        addSubview(backgroundView)
        
        alertTitleLabel.text = "Please choose another name for the prize, it already exists"
        
        backgroundView.addSubviews(alertBoxImageView, alertTitleLabel, okButton)
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        alertBoxImageView.snp.makeConstraints {
            $0.height.equalTo(164)
            $0.width.equalTo(327)
            $0.center.equalToSuperview()
        }
        
        alertTitleLabel.snp.makeConstraints {
            $0.top.equalTo(alertBoxImageView).offset(20)
            $0.left.equalTo(alertBoxImageView).offset(10)
            $0.right.equalTo(alertBoxImageView).offset(-10)
        }
        
        okButton.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(40)
            $0.top.equalTo(alertBoxImageView).offset(100)
            $0.centerX.equalToSuperview()
        }
    }
}

//MARK: - Actions

extension WarningAlertView {
    @objc func yesAction() {
        delegate?.yesAction()
    }
    
    @objc func noAction() {
        delegate?.noAction()
    }
    
    @objc func okButtonAction() {
        errorDelegate?.okAction()
    }
}

//MARK: - Setup typeOfAlert: public method

extension WarningAlertView {
    func setupWarning() {
        setupWarningAlert()
    }
    
    func setupError() {
        setupErrorAlert()
    }
}
