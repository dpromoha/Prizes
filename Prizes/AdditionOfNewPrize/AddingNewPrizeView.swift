//
//  AddingNewPrizeView.swift
//  Prizes
//
//  Created by Daria Pr on 21.07.2021.
//

import UIKit

class AddingNewPrizeView: UIView {
    
    //MARK: - UIProperties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add new prize"
        label.font = Font.aileronBold(size: 25)
        label.textColor = .black
        return label
    } ()
    
    private let nameOfPrizeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Title of the price"
        textField.textColor = .black
        textField.font = Font.aileronRegular(size: 18)
        textField.keyboardType = .alphabet
        textField.addTarget(self, action: #selector(nameOfPrizeAction), for: .editingChanged)
        return textField
    } ()
    
    private lazy var priceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Price of the price"
        textField.textColor = .black
        textField.font = Font.aileronRegular(size: 18)
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(priceOfPrizeAction), for: .editingChanged)
        textField.delegate = self
        return textField
    } ()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("ADD", for: .normal)
        button.backgroundColor = .gray
        button.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        return button
    } ()
    
    private let addFormStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 30
        return stackView
    } ()
    
    private let lineBelowNameView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.mainColor()
        return view
    } ()
    
    private let lineBelowPriceView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.mainColor()
        return view
    } ()
    
    private lazy var warningAlertView: WarningAlertView = {
        let view = WarningAlertView()
        view.errorDelegate = self
        view.setupError()
        return view
    } ()
    
    //MARK: - Properties
    
    private var name = String()
    private var price = Int()
    private var isValid = false
    
    weak var delegate: AddingNewPrizeDelegate?
        
    private let db = DataBaseManager.shared
    
    private let ident = IdentificationCode()
    
    //MARK: - Init view
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupKeyboard()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setup Layout

private extension AddingNewPrizeView {
    func setupLayout() {
        addFormStackView.addArrangedSubviews(views: nameOfPrizeTextField, priceTextField, addButton)
        
        addSubviews(titleLabel, addFormStackView, lineBelowNameView, lineBelowPriceView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.centerX.equalToSuperview()
        }
        
        addFormStackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.center.equalToSuperview()
        }
        
        lineBelowNameView.snp.makeConstraints {
            $0.top.equalTo(nameOfPrizeTextField.snp.bottom).offset(5)
            $0.height.equalTo(2)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        lineBelowPriceView.snp.makeConstraints {
            $0.top.equalTo(priceTextField.snp.bottom).offset(5)
            $0.height.equalTo(2)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
    }
}

//MARK: - Check TextField`s State

private extension AddingNewPrizeView {
    func checkStateOfTextFields() {
        if name.count >= 3 && price >= 1 && price <= 99 {
            isValid = true
            addButton.backgroundColor = Color.mainColor()
        } else {
            isValid = false
            addButton.backgroundColor = .gray
        }
    }
}

//MARK: - Adding new prize: action

extension AddingNewPrizeView {
    @objc func addButtonAction() {
        checkStateOfTextFields()
        
        if isValid {
            endEditing(true)
            let identNumber = ident.randomAlphaNumericString(length: 15)
            let prize = Prize(nameOfPrize: name, priceOfPrize: price, identificationNumber: identNumber)
            if db.choosingPrizeStruct.isEmpty {
                delegate?.saveNew(prize: prize)
            } else {
                var isExists = false
                
                for i in 0..<db.choosingPrizeStruct.count {
                    if db.choosingPrizeStruct[i].name == name {
                        addSubview(warningAlertView)
                        warningAlertView.snp.makeConstraints {
                            $0.edges.equalToSuperview()
                        }
                        isExists = true
                        break
                    }
                }
                
                if isExists == false {
                    delegate?.saveNew(prize: prize)
                }
            }
        }
    }
}

//MARK: - Setup Keyboard

private extension AddingNewPrizeView {
    func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.frame.origin.y == 0 {
                self.frame.origin.y -= (keyboardSize.height - 150)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.frame.origin.y != 0 {
            self.frame.origin.y = 0
        }
    }
}

//MARK: - UITextField actions

extension AddingNewPrizeView {
    @objc func nameOfPrizeAction() {
        if let namePrize = nameOfPrizeTextField.text {
            name = namePrize
            checkStateOfTextFields()
        }
    }
    
    @objc func priceOfPrizeAction() {
        if let pricePrize = priceTextField.text {
            price = Int(pricePrize) ?? 0
            checkStateOfTextFields()
        }
    }
}

//MARK: - UITextFieldDelegate

extension AddingNewPrizeView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 2
    }
}

//MARK: - ErrorAlertDelegate

extension AddingNewPrizeView: ErrorAlertDelegate {
    func okAction() {
        warningAlertView.removeFromSuperview()
    }
}
